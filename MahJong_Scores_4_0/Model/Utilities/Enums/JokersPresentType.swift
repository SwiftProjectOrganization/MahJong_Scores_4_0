//
//  JokersPresentType.swift
//  MahJong_Scores_2_0
//
//  Created by Robert Goedman on 5/31/24.
//

import Foundation

let jokersPresent = JokersPresentType.allCases

enum JokersPresentType: Int, Codable, CaseIterable, Hashable {
  case yes = 0
  case no
}

extension JokersPresentType: Identifiable {
  var id: Self {
    self
  }
}

extension JokersPresentType: CustomStringConvertible {
  var description: String {
    switch self {
      case .yes: "Jokers"
      case .no: "No jokers"
    }
  }
}
