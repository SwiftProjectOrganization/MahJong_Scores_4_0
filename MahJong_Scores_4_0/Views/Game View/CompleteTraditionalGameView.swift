//
//  CompleteGameView.swift
//  MJS
//
//  Created by Robert Goedman on 3/28/24.
//

import SwiftUI
import SwiftData

struct CompleteTraditionalGameView {
  //@Binding var tournament: Tournament
  @Binding var isCompleteGameViewDisplayed: Bool
  
  @State private var gameWinnerName: String = ""
  @State private var gameSpName: String = ""
  @State private var gameTpName: String = ""
  @State private var gameLpName: String = ""
  @State private var gameWinnerScore: String = ""
  @State private var gameSpScore: String = ""
  @State private var gameTpScore: String = ""
  @State private var gameLpScore: String = ""
  @Environment(\.scenePhase) private var scenePhase
  @FocusState private var focusedField
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var context
  var tournament: Tournament
}


extension CompleteTraditionalGameView: View {
    var body: some View {
      VStack(spacing: 50) {
        Text("Press `Rotate` until the game winner is on the top line. Then enter game scores and press `Save`.")
          .font(.largeTitle)
        VStack {
          List {
            HStack {
              Spacer(minLength: 40)
              Text("\(gameWinnerName):")
                .multilineTextAlignment(.trailing)
              Spacer()
              TextField("Game score", text: $gameWinnerScore)
                .focused($focusedField)
                .multilineTextAlignment(.trailing)
             Spacer(minLength: 60)
            }
            HStack {
              Spacer(minLength: 40)
              Text("\(gameSpName):")
                .multilineTextAlignment(.trailing)
              Spacer()
              TextField("Game score", text: $gameSpScore)
                .multilineTextAlignment(.trailing)
             Spacer(minLength: 60)
            }
            HStack {
              Spacer(minLength: 40)
              Text("\(gameTpName):")
                .multilineTextAlignment(.trailing)
              Spacer()
              TextField("Game score", text: $gameTpScore)
                .multilineTextAlignment(.trailing)
              Spacer(minLength: 60)
            }
            HStack {
              Spacer(minLength: 40)
              Text("\(gameLpName):")
                .multilineTextAlignment(.trailing)
              Spacer()
              TextField("Game score", text: $gameLpScore)
                .multilineTextAlignment(.trailing)
              Spacer(minLength: 60)
            }
          }
        }
        .keyboardType(.numberPad)
        HStack {
          Spacer()
          Button("Cancel",
                 role: .cancel) {
            isCompleteGameViewDisplayed = false
            dismiss()
          }
          .buttonStyle(.bordered)
          Button("Rotate") {
            rotate()
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
        Spacer()
       }
      .onAppear {
        gameWinnerName = tournament.players![0]
        gameSpName = tournament.players![1]
        gameTpName = tournament.players![2]
        gameLpName = tournament.players![3]
        gameWinnerScore = ""
        gameSpScore = ""
        gameTpScore = ""
        gameLpScore = ""
        focusedField = true
      }
    }
}

extension CompleteTraditionalGameView {
  func anyFieldEmpty() -> Bool {
    let namesEmpty = gameWinnerName.isEmpty || gameSpName.isEmpty || gameTpName.isEmpty || gameLpName.isEmpty
    let scoresEmpty = gameWinnerScore.isEmpty || gameSpScore.isEmpty || gameTpScore.isEmpty || gameLpScore.isEmpty
    return namesEmpty || scoresEmpty
  }
}

extension CompleteTraditionalGameView {
  func rotate() {
    //print("Rotate called")
    let tmpName = gameWinnerName
    gameWinnerName = gameSpName
    gameSpName = gameTpName
    gameTpName = gameLpName
    gameLpName = tmpName
  }
}

extension CompleteTraditionalGameView {
  private func save(_ tournament: Tournament) {
    tournament.lastGame! += 1
    tournament.gameWinnerName = gameWinnerName
    tournament.pgScore![gameWinnerName] = Int(gameWinnerScore)
    tournament.pgScore![gameSpName] = Int(gameSpScore)
    tournament.pgScore![gameTpName] = Int(gameTpScore)
    tournament.pgScore![gameLpName] = Int(gameLpScore)
    updateTraditionalTournamentScore(tournament)
    focusedField = false
    dismiss()
  }
}

func updateTraditionalTournamentScore(_ tournament: Tournament) {
  if tournament.gameWinnerName == tournament.windPlayer!.last {
    for i in 0...3 {
      // Settle between winner and other players if game winner is wind player
      let pi = tournament.players![i]
      if pi == tournament.gameWinnerName {
        tournament.ptScore![pi]! += 6 * tournament.pgScore![tournament.gameWinnerName!]!
      } else {
        tournament.ptScore![pi]! -= 2 * tournament.pgScore![tournament.gameWinnerName!]!
        for j in 0...3 {
          let pj = tournament.players![j]
          if pi != pj && pj != tournament.gameWinnerName {
            // Settle between non-winners
            tournament.ptScore![pi]! += tournament.pgScore![pi]! - tournament.pgScore![pj]!
          }
        }
      }
    }
    tournament.windPlayer = tournament.windPlayer! + [tournament.windPlayer!.last!]
  } else {
    // Game winner is not the wind player
    for i in 0...3 {
      let pi = tournament.players![i]
      if pi == tournament.gameWinnerName {
        tournament.ptScore![pi]! += 4 * tournament.pgScore![tournament.gameWinnerName!]!
      } else {
        if pi == tournament.windPlayer!.last {
          tournament.ptScore![pi]! -= 2 * tournament.pgScore![tournament.gameWinnerName!]!
        } else {
          tournament.ptScore![pi]! -= 1 * tournament.pgScore![tournament.gameWinnerName!]!
        }
        for j in 0...3 {
          let pj = tournament.players![j]
          if pi != pj {
            if pi != tournament.gameWinnerName && pj != tournament.gameWinnerName {
              // Settle between non-winners
              let dif = tournament.pgScore![pi]! - tournament.pgScore![pj]!
              if pi == tournament.windPlayer!.last || pj == tournament.windPlayer!.last {
                tournament.ptScore![pi]! += 2 * dif
              } else {
                tournament.ptScore![pi]! += 1 * dif
              }
            }
          }
        }
      }
    }
    tournament.scheduleItem += 1
    tournament.updateTournamentStatus()
   }
  tournament.updateGameScores()
}


