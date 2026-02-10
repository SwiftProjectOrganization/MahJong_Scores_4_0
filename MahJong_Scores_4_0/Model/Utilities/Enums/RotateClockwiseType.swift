//
//  RotateClockwiseType.swift
//  MahJong_Scores_2_0
//
//  Created by Robert Goedman on 5/26/24.
//

import Foundation

let rotateClockwiseTypes = RotateClockwiseType.allCases

enum RotateClockwiseType: Codable, CaseIterable, Hashable {
  case clockwise
  case counterClockwise
}

extension RotateClockwiseType: Identifiable {
  var id: Self {
    self
  }
}

extension RotateClockwiseType: CustomStringConvertible {
  var description: String {
    switch self {
      case .clockwise: "Clockwise"
      case .counterClockwise: "Counter clockwise"
    }
  }
}

extension RotateClockwiseType {
  static func random() -> RotateClockwiseType {
    rotateClockwiseTypes.randomElement() ?? .counterClockwise
  }
}

