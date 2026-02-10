//
//  AddTournamentView.swift
//  MJS
//
//  Created by Robert Goedman on 3/25/24.
//

import SwiftUI
import SwiftData

@MainActor
struct AddTournamentView {
  @State private var fp: String = ""
  @State private var sp: String = ""
  @State private var tp: String = ""
  @State private var lp: String = ""
  @State var selectedRotation: RotateClockwiseType = .counterClockwise
  @State var selectedRuleSet: RuleSetType = .traditional
  @AppStorage("rotateClockwise") private var rotateClockwise: Bool = false
  @AppStorage("ruleSet") private var ruleSet: String = "Traditional"
  @Environment(\.scenePhase) private var scenePhase
  @FocusState private var focusedField
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var context
}

extension AddTournamentView: View {
  var body: some View {
    VStack {
      Spacer()
      Text("Enter all 4 players, select rotation direction and rule set and press `save`.")
        .font(.title)
      Spacer()
      HStack {
        TextField("East wind player", text: $fp)
          .focused($focusedField)
          .multilineTextAlignment(.center)
          .font(.largeTitle)
      }
      HStack {
        TextField("South (to the right of East)", text: $sp)
          .multilineTextAlignment(.center)
          .font(.largeTitle)
      }
      HStack {
        TextField("West (to the right of South)", text: $tp)
          .multilineTextAlignment(.center)
          .font(.largeTitle)
      }
      HStack {
        TextField("North (to the right of West)", text: $lp)
          .multilineTextAlignment(.center)
          .font(.largeTitle)
      }
      Spacer()
      RotateClockwisePickerView(selectedRotation: $selectedRotation)
      Spacer()
      RuleSetPickerView(selectedRuleSet: $selectedRuleSet)
      Spacer()
      HStack {
        Spacer()
        Button("Cancel",
               role: .cancel) {
          dismiss()
        }
        .buttonStyle(.borderedProminent)
        Spacer()
        Button("Save",
               action: save)
        .disabled(fp.isEmpty || sp.isEmpty || tp.isEmpty || lp.isEmpty)
        .buttonStyle(.borderedProminent)
        Spacer()
      }
      .font(.largeTitle)
      Spacer()
    }
    .onAppear {
      focusedField = true
    }
  }
}

extension AddTournamentView {
  private func save() {
    focusedField = false
    let tournament = Tournament(fp, sp, tp, lp, fp, "East")
    
    tournament.scheduleItem = 0
    tournament.players = [fp, sp, tp, lp]
    tournament.winds = ["East", "South", "West", "North"]
    let scores = selectedRuleSet == RuleSetType.traditional ? [2000, 2000, 2000, 2000] : [0, 0, 0, 0]
    tournament.ptScore = Dictionary(uniqueKeysWithValues: zip(tournament.players!, scores))
    tournament.pgScore = Dictionary(uniqueKeysWithValues: zip(tournament.players!, [0,0,0,0]))
    
    let tmp = tournament.windsAndPlayers(["East", "South", "West", "North"], [fp, sp, tp, lp], 0)
    tournament.windsToPlayersInGame = Dictionary(uniqueKeysWithValues: zip(tmp.0, tmp.1))
    tournament.playersToWindsInGame = Dictionary(uniqueKeysWithValues: zip(tmp.1, tmp.0))
    tournament.currentWind = tmp.0[0]
    tournament.windPlayer = [tmp.1[0]]
    
    tournament.ruleSet = selectedRuleSet.description
    tournament.rotateClockwise = (selectedRotation == RotateClockwiseType.clockwise ? true : false)
    
    let tmp2 = tournament.lastGame! + 1
    tournament.lastGame! = tmp2
    tournament.fpScores!.append(FpScore(fp, tmp2, scores[0]))
    tournament.spScores!.append(SpScore(sp, tmp2, scores[1]))
    tournament.tpScores!.append(TpScore(tp, tmp2, scores[2]))
    tournament.lpScores!.append(LpScore(lp, tmp2, scores[3]))
    
    context.insert(tournament)
    dismiss()
  }
}

//#Preview {
//  AddTournamentView()
//    .modelContainer(previewContainer)
//}
