//
//  GameGraphView.swift
//  MJS
//
//  Created by Robert Goedman on 5/8/24.
//

import SwiftUI
import SwiftData
import Charts

struct GameGraphView {
  @State var tournament: Tournament
}

extension GameGraphView: View {

  var body: some View {
    var scores: [Score] = []
    for player in [tournament.fpName!, tournament.spName!, tournament.tpName!, tournament.lpName!] {
      if player == tournament.fpName! {
        let fpScores = tournament.sortedFpScores.filter { $0.name == player }
        for fpScore in fpScores {
          scores.append(Score(player, fpScore.game!, fpScore.score!))
        }
      } else {
        if player == tournament.spName! {
          let spScores = tournament.sortedSpScores.filter { $0.name == player }
          for spScore in spScores {
            scores.append(Score(player, spScore.game!, spScore.score!))
          }
        } else {
          if player == tournament.tpName! {
            let tpScores = tournament.sortedTpScores.filter { $0.name == player }
            for tpScore in tpScores {
              scores.append(Score(player, tpScore.game!, tpScore.score!))
            }
          } else {
            if player == tournament.lpName! {
              let lpScores = tournament.sortedLpScores.filter { $0.name == player }
              for lpScore in lpScores {
                scores.append(Score(player, lpScore.game!, lpScore.score!))
              }
            }
          }
        }
      }
    }

    return Chart {
      ForEach(scores, id: \.name) { players in
          LineMark(
            x: .value("Game", players.game),
            y: .value("Score", players.score)
          )
          .foregroundStyle(by: .value("Player", players.name))
      }
    }
    .frame(height: 200)
  }
}
