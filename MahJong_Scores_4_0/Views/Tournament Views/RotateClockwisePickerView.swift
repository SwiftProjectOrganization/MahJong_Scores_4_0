//
//  RotateClockwisePickerView.swift
//  MahJong_Scores_2_0
//
//  Created by Robert Goedman on 5/27/24.
//

import SwiftUI

let rotationDirections = RotateClockwiseType.allCases

struct RotateClockwisePickerView {
  @Binding var selectedRotation: RotateClockwiseType
}

extension RotateClockwisePickerView: View {
  var body: some View {
    Picker("Rule set",
           selection: $selectedRotation) {
      ForEach(rotationDirections) { rotateDirection in
        Text(rotateDirection.description)
          .tint(selectedRotation == rotateDirection ? .blue : .gray)
      }
    }
    .pickerStyle(.segmented)
    .padding(.horizontal)
    .onChange(of: selectedRotation) { oldValue, newValue in
      selectedRotation = newValue
    }
  }
}

#Preview {
  RotateClockwisePickerView(selectedRotation: .constant(RotateClockwiseType.clockwise))
}
