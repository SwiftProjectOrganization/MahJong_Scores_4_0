//
//  TournamentView.swift
//  MJS
//
//  Created by Robert Goedman on 3/25/24.
//

import SwiftUI
import SwiftData

@MainActor
struct TournamentView {
  @AppStorage("dirName") private var dirName = "MahjongScore"
  @AppStorage("urlPath") private var urlPath = "http://Rob-Travel-M5.local:8081/"

  @State private var isAddingTournament = false
  @State private var isShowingSyncView = false
  @State private var tournamentToUpload: Tournament?
  @State private var showUploadSuccess = false
  @State private var showUploadError = false
  @State private var uploadErrorMessage = ""
  @Environment(\.modelContext) private var context
  @Query var tournaments: [Tournament]
  
  private let apiService = TournamentAPIService()
}

extension TournamentView: View {
  var body: some View {
    NavigationStack {
      List {
        ForEach(tournaments) { tournament in
          NavigationLink(tournament.title,
                         value: tournament)
          .contextMenu {
            Button {
              Task {
                await uploadTournament(tournament)
              }
            } label: {
              Label("Upload to Server", systemImage: "arrow.up.circle")
            }
            
            Button(role: .destructive) {
              context.delete(tournament)
            } label: {
              Label("Delete", systemImage: "trash")
            }
          }
        }
        .onDelete { indexSet in
          if let index = indexSet.first {
            context.delete(tournaments[index])
          }
        }
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          EditButton()
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            isShowingSyncView = true
          } label: {
            Label("Sync", systemImage: "arrow.triangle.2.circlepath")
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            isAddingTournament = true
          } label: {
            Label("Add Tournament", systemImage: "plus")
          }
        }
      }
      .navigationTitle("Tournaments")
      .navigationDestination(for: Tournament.self) { tournament in
        IndividualTournamentView(tournament: tournament)
      }
      Spacer()

    }
    .sheet(isPresented: $isAddingTournament) {
        AddTournamentView()
    }
    .sheet(isPresented: $isShowingSyncView) {
        SyncTournamentView()
    }
    .alert("Upload Successful", isPresented: $showUploadSuccess) {
      Button("OK", role: .cancel) { }
    } message: {
      Text("Tournament uploaded to server successfully")
    }
    .alert("Upload Failed", isPresented: $showUploadError) {
      Button("OK", role: .cancel) { }
    } message: {
      Text(uploadErrorMessage)
    }
  }
  
  private func uploadTournament(_ tournament: Tournament) async {
    do {
      let dto = tournament.toDTO()
      _ = try await apiService.uploadTournament(dto)
      await MainActor.run {
        showUploadSuccess = true
      }
    } catch {
      await MainActor.run {
        uploadErrorMessage = error.localizedDescription
        showUploadError = true
      }
    }
  }
}

#Preview {
  TournamentView()
    .modelContainer(previewContainer)
}
