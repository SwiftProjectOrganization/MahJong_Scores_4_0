//
//  JokersPresentPickerView.swift
//  MahJong_Scores_2_0
//
//  Created by Robert Goedman on 5/29/24.
//

import SwiftUI

struct JokersPresentPickerView {
  @Binding var jokersPresent: JokersPresentType
}

extension JokersPresentPickerView : View {
  var body: some View {
    VStack {
      HStack {
          Spacer().frame(width: 30)
          Picker("", selection: $jokersPresent) {
            ForEach(JokersPresentType.allCases, id: \.self) { aValidSelection in
              Text(aValidSelection.description)
            }
          }
          .pickerStyle(.segmented)
          .padding()
        }
    }
  }
}

//#Preview {
//  JokersPresentPickerView(jokersPresent: JokersPresentType.no)
//}
