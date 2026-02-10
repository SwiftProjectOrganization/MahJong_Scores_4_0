//
//  LastTileType.swift
//  MahJong_Scores_2_0
//
//  Created by Robert Goedman on 5/31/24.
//

import Foundation

let LastTileTypes = LastTileType.allCases

enum LastTileType: Int, Codable, CaseIterable, Hashable {
  case firstPlayer = 0
  case secondPlayer
  case thirdPlayer
  case fourthPlayer
}

extension LastTileType: Identifiable {
  var id: Self {
    self
  }
}

extension LastTileType: CustomStringConvertible {
  var description: String {
    switch self {
      case .firstPlayer: "FirstPlayer"
      case .secondPlayer: "SecondPlayer"
      case .thirdPlayer: "ThirdPlayer"
      case .fourthPlayer: "FourthPlayer"
    }
  }
}
