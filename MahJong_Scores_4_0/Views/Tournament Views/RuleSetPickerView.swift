//
//  RuleSetPickerView.swift
//  MahJong_Scores_2_0
//
//  Created by Robert Goedman on 5/26/24.
//

import SwiftUI

let ruleSets = RuleSetType.allCases

struct RuleSetPickerView {
  @Binding var selectedRuleSet: RuleSetType
}

extension RuleSetPickerView: View {
  var body: some View {
    Picker("Rule set",
           selection: $selectedRuleSet) {
      ForEach(ruleSets) { ruleSet in
        Text(ruleSet.description)
      }
    }
    .pickerStyle(.segmented)
    .padding(.horizontal)
    .onChange(of: selectedRuleSet) { oldValue, newValue in
      selectedRuleSet = newValue
    }
  }
}

#Preview {
  RuleSetPickerView(selectedRuleSet: .constant(RuleSetType.traditional))
}
