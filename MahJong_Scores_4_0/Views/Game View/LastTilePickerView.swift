//
//  LastTilePickerView.swift
//  MahJong_Scores_2_0
//
//  Created by Robert Goedman on 5/29/24.
//

import SwiftUI

struct LastTilePickerView: View {
  @State var players: [String]
  @Binding var lastTileSource: LastTileType
  
  var body: some View {
    VStack {
      HStack {
          Picker("Source of last tile?", selection: $lastTileSource) {
            ForEach(LastTileType.allCases, id: \.self) { aValidSelection in
              Text(players[aValidSelection.rawValue])
                .padding()
            }
          }
          .pickerStyle(.segmented)
          .padding()
      }
    }
  }
}

//#Preview {
//  LastTilePickerView(players: ["Liesbeth", "Rob", "Nancy", "CareL"],
//                     lastTileSource: $LastTileType.firstPlayer)
//}
