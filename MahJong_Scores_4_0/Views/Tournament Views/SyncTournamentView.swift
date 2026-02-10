//
//  SyncTournamentView.swift
//  MahJong_Scores_4_0
//
//  View for syncing tournaments with the backend server
//

import SwiftUI
import SwiftData

struct SyncTournamentView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext
  @Query private var tournaments: [Tournament]
  
  @State private var apiService = TournamentAPIService()
  @State private var serverURL = UserDefaults.standard.string(forKey: "serverURL") ?? "http://Rob-Travel-M5.local:8080/"
  @State private var selectedTournaments: Set<Tournament> = []
  @State private var selectedRemoteTournaments: Set<UUID> = []
  @State private var isSyncing = false
  @State private var isDownloading = false
  @State private var syncStatus: String = ""
  @State private var showError = false
  @State private var errorMessage = ""
  @State private var remoteTournaments: [TournamentDTO] = []
  @State private var selectedMode: SyncMode = .upload
  
  enum SyncMode: String, CaseIterable {
    case upload = "Upload"
    case download = "Download"
  }
  
  var body: some View {
    NavigationStack {
      Form {
        Section("Server Configuration:") {
          TextField("Server URL", text: $serverURL)
            .textInputAutocapitalization(.never)
            .keyboardType(.URL)
          
          HStack {
            Text("Status:")
            Spacer()
            Text(apiService.isConnected ? "Connected" : "Not Connected")
              .foregroundStyle(apiService.isConnected ? .green : .secondary)
          }
        }
        
        Section {
          Picker("Mode", selection: $selectedMode) {
            ForEach(SyncMode.allCases, id: \.self) { mode in
              Text(mode.rawValue).tag(mode)
            }
          }
          .pickerStyle(.segmented)
        }
        
        if selectedMode == .upload {
          uploadSection
        } else {
          downloadSection
        }
        
        if !syncStatus.isEmpty {
          Section("Sync Status:") {
            Text(syncStatus)
              .foregroundStyle(.secondary)
          }
        }
      }
      .navigationTitle("Sync Tournaments")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Close") {
            dismiss()
          }
        }
        
        ToolbarItem(placement: .primaryAction) {
          if selectedMode == .upload {
            uploadButton
          } else {
            downloadButton
          }
        }
      }
      .alert("Sync Error", isPresented: $showError) {
        Button("OK", role: .cancel) { }
      } message: {
        Text(errorMessage)
      }
    }
    .onChange(of: serverURL) { _, newValue in
      apiService = TournamentAPIService(serverURL: newValue)
      UserDefaults.standard.set(newValue, forKey: "serverURL")
    }
    .task {
      if selectedMode == .download {
        await fetchRemoteTournaments()
      }
    }
  }
  
  private var uploadSection: some View {
    Section("Select Tournaments to Upload") {
      if tournaments.isEmpty {
        Text("No tournaments available")
          .foregroundStyle(.secondary)
      } else {
        ForEach(tournaments) { tournament in
          Toggle(isOn: Binding(
            get: { selectedTournaments.contains(tournament) },
            set: { isSelected in
              if isSelected {
                selectedTournaments.insert(tournament)
              } else {
                selectedTournaments.remove(tournament)
              }
            }
          )) {
            VStack(alignment: .leading) {
              let status = "\(tournament.ruleSet ?? "Unknown") : \(tournament.currentWind ?? "Unknown")"
              Text(status)
                .font(.headline)
              let game = "\(tournament.startDate ?? "No date") : \(tournament.fpName ?? "") vs \(tournament.spName ?? "") vs \(tournament.tpName ?? "") vs \(tournament.lpName ?? "")"
              Text(game)
                .font(.caption)
                //.foregroundStyle(.secondary)
            }
          }
        }
      }
    }
  }
  
  private var downloadSection: some View {
    Section {
      if isDownloading {
        HStack {
          Spacer()
          ProgressView()
          Text("Loading...")
            .foregroundStyle(.secondary)
            .padding(.leading, 8)
          Spacer()
        }
      } else if remoteTournaments.isEmpty {
        Text("No tournaments on server")
          .foregroundStyle(.secondary)
        Button("Refresh") {
          Task {
            await fetchRemoteTournaments()
          }
        }
      } else {
        ForEach(remoteTournaments) { tournament in
          Toggle(isOn: Binding(
            get: { selectedRemoteTournaments.contains(tournament.id) },
            set: { isSelected in
              if isSelected {
                selectedRemoteTournaments.insert(tournament.id)
              } else {
                selectedRemoteTournaments.remove(tournament.id)
              }
            }
          )) {
            VStack(alignment: .leading) {
              let status = "\(tournament.ruleSet ?? "Unknown") : \(tournament.currentWind ?? "Unknown")"
              Text(status)
                .font(.headline)
              let game = "\(tournament.startDate ?? "No date") : \(tournament.fpName ?? "") vs \(tournament.spName ?? "") vs \(tournament.tpName ?? "") vs \(tournament.lpName ?? "")"
              Text(game)
                .font(.caption)
                //.foregroundStyle(.secondary)
            }
          }
        }
      }
    } header: {
      HStack {
        Text("Available Tournaments on Server")
        Spacer()
        if !remoteTournaments.isEmpty && !isDownloading {
          Button(selectedRemoteTournaments.count == remoteTournaments.count ? "Deselect All" : "Select All") {
            if selectedRemoteTournaments.count == remoteTournaments.count {
              selectedRemoteTournaments.removeAll()
            } else {
              selectedRemoteTournaments = Set(remoteTournaments.map { $0.id })
            }
          }
          .font(.caption)
          .textCase(nil)
        }
      }
    }
  }
  
  private var uploadButton: some View {
    Button("Upload") {
      Task {
        await syncTournaments()
      }
    }
    .disabled(selectedTournaments.isEmpty || isSyncing)
  }
  
  private var downloadButton: some View {
    Button("Download") {
      Task {
        await downloadTournaments()
      }
    }
    .disabled(selectedRemoteTournaments.isEmpty || isDownloading)
  }
  
  private func syncTournaments() async {
    isSyncing = true
    syncStatus = "Starting sync..."
    
    var successCount = 0
    var errorCount = 0
    
    for tournament in selectedTournaments {
      syncStatus = "Uploading tournament: \(tournament.ruleSet ?? "Unknown")..."
      
      do {
        let dto = tournament.toDTO()
        _ = try await apiService.uploadTournament(dto)
        successCount += 1
      } catch {
        errorCount += 1
        errorMessage = error.localizedDescription
        showError = true
      }
    }
    
    syncStatus = "Sync complete: \(successCount) successful, \(errorCount) failed"
    isSyncing = false
    
    if errorCount == 0 {
      // Auto-dismiss after successful sync
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        dismiss()
      }
    }
  }
  
  private func fetchRemoteTournaments() async {
    isDownloading = true
    syncStatus = "Fetching tournaments from server..."
    
    do {
      let tournaments = try await apiService.listTournaments()
      await MainActor.run {
        remoteTournaments = tournaments
        syncStatus = "Found \(tournaments.count) tournament(s) on server"
        isDownloading = false
      }
    } catch {
      await MainActor.run {
        errorMessage = error.localizedDescription
        showError = true
        syncStatus = "Failed to fetch tournaments"
        isDownloading = false
      }
    }
  }
  
  private func downloadTournaments() async {
    isDownloading = true
    syncStatus = "Downloading tournaments..."
    
    var successCount = 0
    
    // Filter to only selected tournaments
    let selectedTournamentDTOs = remoteTournaments.filter { selectedRemoteTournaments.contains($0.id) }
    
    for tournamentDTO in selectedTournamentDTOs {
      syncStatus = "Downloading: \(tournamentDTO.ruleSet ?? "Unknown")..."
      
      // Create a new Tournament from the DTO
      let tournament = Tournament(
        tournamentDTO.fpName ?? "",
        tournamentDTO.spName ?? "",
        tournamentDTO.tpName ?? "",
        tournamentDTO.lpName ?? "",
        tournamentDTO.currentWind ?? "East",
        tournamentDTO.gameWinnerName ?? ""
      )
      
      // Copy over all properties
      tournament.rotateClockwise = tournamentDTO.rotateClockwise
      tournament.ruleSet = tournamentDTO.ruleSet
      tournament.startDate = tournamentDTO.startDate
      tournament.scheduleItem = tournamentDTO.scheduleItem
      tournament.lastGame = tournamentDTO.lastGame
      tournament.windPlayer = tournamentDTO.windPlayer
      tournament.players = tournamentDTO.players
      tournament.winds = tournamentDTO.winds
      tournament.ptScore = tournamentDTO.ptScore
      tournament.pgScore = tournamentDTO.pgScore
      tournament.windsToPlayersInGame = tournamentDTO.windsToPlayersInGame
      tournament.playersToWindsInGame = tournamentDTO.playersToWindsInGame
      
      // Insert into SwiftData
      await MainActor.run {
        modelContext.insert(tournament)
      }
      
      successCount += 1
    }
    
    // Save the context
    do {
      try await MainActor.run {
        try modelContext.save()
      }
      
      syncStatus = "Download complete: \(successCount) tournament(s) downloaded"
      isDownloading = false
      selectedRemoteTournaments.removeAll()
      
      // Auto-dismiss after successful download
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        dismiss()
      }
    } catch {
      await MainActor.run {
        errorMessage = error.localizedDescription
        showError = true
        syncStatus = "Failed to save tournaments"
        isDownloading = false
      }
    }
  }
}

#Preview {
  SyncTournamentView()
    .modelContainer(previewContainer)
}
