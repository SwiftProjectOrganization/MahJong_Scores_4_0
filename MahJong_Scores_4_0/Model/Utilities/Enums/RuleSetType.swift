//
//  RuleSetType.swift
//  MahJong_Scores_2_0
//
//  Created by Robert Goedman on 5/26/24.
//

import Foundation

let ruleSetType = RuleSetType.allCases

enum RuleSetType: Codable, CaseIterable, Hashable {
  case traditional
  case american
}

extension RuleSetType: Identifiable {
  var id: Self {
    self
  }
}

extension RuleSetType: CustomStringConvertible {
  var description: String {
    switch self {
      case .traditional: "Traditional"
      case .american: "American"
    }
  }
}

extension RuleSetType {
  static func random() -> RuleSetType {
    ruleSetType.randomElement() ?? .traditional
  }
}


