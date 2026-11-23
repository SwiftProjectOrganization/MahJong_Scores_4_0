//
//  TournamentTitleView.swift
//  MahJong_Scores_2_0
//
//  Created by Robert Goedman on 5/27/24.
//

import SwiftUI

struct TournamentTitleView {
  @State var tournament: Tournament
}

extension TournamentTitleView: View {
  var body: some View {
    VStack {
      if let rules = tournament.windPlayerRules {
        // Put the rules on the same row when there is room, otherwise on a small line below
        ViewThatFits(in: .horizontal) {
          HStack {
            headerRow
            Text(rules)
              .font(.caption)
              .foregroundStyle(.secondary)
              .lineLimit(1)
          }
          VStack(spacing: 2) {
            HStack {
              headerRow
            }
            Text(rules)
              .font(.caption)
              .foregroundStyle(.secondary)
              .lineLimit(1)
              .minimumScaleFactor(0.8)
          }
        }
      } else {
        HStack {
          headerRow
        }
      }
      Spacer()
      HStack {
        if tournament.fpName == tournament.windPlayer!.last {
          Text(tournament.fpName!)
            .font(.headline)
            .foregroundColor(.blue)
        } else {
          Text(tournament.fpName!)
            .font(.headline)
        }
        Spacer()
        if tournament.spName == tournament.windPlayer!.last {
          Text(tournament.spName!)
            .font(.headline)
            .foregroundColor(.blue)
        } else {
          Text(tournament.spName!)
            .font(.headline)
        }
        Spacer()
        if tournament.tpName == tournament.windPlayer!.last {
          Text(tournament.tpName!)
            .font(.headline)
            .foregroundColor(.blue)
        } else {
          Text(tournament.tpName!)
            .font(.headline)
        }
        Spacer()
        if tournament.lpName == tournament.windPlayer!.last {
          Text(tournament.lpName!)
            .font(.headline)
            .foregroundColor(.blue)
        } else {
          Text(tournament.lpName!)
            .font(.headline)
        }
      }
    }
  }
}

extension TournamentTitleView {
  /// Rule set, current wind and start date; meant to be placed inside an HStack.
  @ViewBuilder
  private var headerRow: some View {
    Text("\(tournament.ruleSet!): ")
    Spacer()
    Text(tournament.currentWind!)
      .font(.headline)
      .foregroundColor(.blue)
    Spacer()
    Text(tournament.startDate!)
    Spacer()
  }
}

//#Preview {
//    TournamentTitleView()
//    .modelContainer(previewContainer)
//}
