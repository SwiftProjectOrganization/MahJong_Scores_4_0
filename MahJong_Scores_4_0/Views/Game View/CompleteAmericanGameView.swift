//
//  CompleteAmericanGameView.swift
//  MahJong_Scores_2_0
//
//  Created by Robert Goedman on 5/29/24.
//

import SwiftUI
import SwiftData

struct CompleteAmericanGameView {
  @Binding var isCompleteGameViewDisplayed: Bool
  
  @State private var gameWinnerName: String = ""
  @State private var gameSpName: String = ""
  @State private var gameTpName: String = ""
  @State private var gameLpName: String = ""
  @State private var gameWinnerScore: String = ""
  @State private var gameSpScore: String = ""
  @State private var gameTpScore: String = ""
  @State private var gameLpScore: String = ""
  @State var jokersPresent: JokersPresentType = JokersPresentType.no
  @State var lastTileSource: LastTileType = LastTileType.firstPlayer
  @Environment(\.scenePhase) private var scenePhase
  @FocusState private var focusedField
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var context
  var tournament: Tournament
}


extension CompleteAmericanGameView: View {
    var body: some View {
      VStack(spacing: 50) {
        Text("Enter game results:")
          .font(.title)
        VStack {
          List {
            Section("Winner name and score:") {
              HStack {
                Button("Rotate players:") {
                  rotate()
                }
                .buttonStyle(.bordered)
                Spacer(minLength: 50)
                Text("\(gameWinnerName):")
                  .multilineTextAlignment(.trailing)
                //Spacer()
                TextField("Game score", text: $gameWinnerScore)
                  .focused($focusedField)
                  .multilineTextAlignment(.trailing)
                Spacer()
              }
            }
            Section("Last tile from, jokers in MahJong hand:") {
              VStack {
                LastTilePickerView(players: tournament.players!,
                                   lastTileSource: $lastTileSource)
                JokersPresentPickerView(jokersPresent: $jokersPresent)
              }
            }
            Section("Cancel or save:") {
              HStack {
                Spacer()
                Button("Cancel",
                       role: .cancel) {
                  isCompleteGameViewDisplayed = false
                  dismiss()
                }
                .buttonStyle(.bordered)
                Spacer()
                Button("Save") {
                  isCompleteGameViewDisplayed = false
                  //print("Save pressed")
                  save(tournament)
                }
                .disabled(anyFieldEmpty())
                .buttonStyle(.borderedProminent)
                Spacer()
              }
            }
          }
        }
        .keyboardType(.numberPad)
       }
      .onAppear {
        gameWinnerName = tournament.players![0]
        gameSpName = tournament.players![1]
        gameTpName = tournament.players![2]
        gameLpName = tournament.players![3]
        gameWinnerScore = ""
        //gameSpScore = ""
        //gameTpScore = ""
        //gameLpScore = ""
        focusedField = true
      }
    }
}

extension CompleteAmericanGameView {
  func anyFieldEmpty() -> Bool {
    let namesEmpty = gameWinnerName.isEmpty
    let scoresEmpty = gameWinnerScore.isEmpty
    return namesEmpty || scoresEmpty
  }
}

extension CompleteAmericanGameView {
  func rotate() {
    //print("Rotate called")
    let tmpName = gameWinnerName
    gameWinnerName = gameSpName
    gameSpName = gameTpName
    gameTpName = gameLpName
    gameLpName = tmpName
  }
}

extension CompleteAmericanGameView {
  private func save(_ tournament: Tournament) {
    tournament.lastGame! += 1
    tournament.gameWinnerName = gameWinnerName
    tournament.pgScore![gameWinnerName] = Int(gameWinnerScore)
    tournament.pgScore![gameSpName] = Int(0)
    tournament.pgScore![gameTpName] = Int(0)
    tournament.pgScore![gameLpName] = Int(0)
    updateAmericanTournamentScore(tournament, gameWinnerName, 
                                  Int(gameWinnerScore)!,
                                  Int(jokersPresent.rawValue),
                                  tournament.players![lastTileSource.rawValue])
    focusedField = false
    dismiss()
  }
}

func updateAmericanTournamentScore(_ tournament: Tournament,
                                   _ gameWinnerName: String,
                                   _ gameWinnerScore: Int,
                                   _ jokersPresent: Int,
                                   _ lastTileSource: String) {
  var score = gameWinnerScore
  print(jokersPresent)
  if jokersPresent == 1 {
    score *= 2
  }
  if gameWinnerName == lastTileSource {
    print([gameWinnerName, lastTileSource])
    // Game winner didn draw last tile
    for i in 0...3 {
      let pi = tournament.players![i]
      if pi == gameWinnerName {
        tournament.ptScore![pi]! += 6 * score
      } else {
        tournament.ptScore![pi]! -= 2 * score
      }
    }
  } else {
    // Game winner didn't draw last tile
    print([gameWinnerName, lastTileSource])
    for i in 0...3 {
      let pi = tournament.players![i]
      if pi == gameWinnerName {
        tournament.ptScore![pi]! += 4 * score
      } else {
        if pi == lastTileSource {
          tournament.ptScore![pi]! -= 2 * score
        } else {
          tournament.ptScore![pi]! -= 1 * score
        }
      }
    }
  }
  tournament.scheduleItem += 1
  tournament.updateTournamentStatus()
  tournament.updateGameScores()
}

