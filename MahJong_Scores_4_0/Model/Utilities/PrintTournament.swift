//
//  PrintTournament.swift
//  MJS
//
//  Created by Robert Goedman on 4/1/24.
//

import Foundation

func printTournament(_ tournament: Tournament) {
  print("\n\tTournament summary:\n")
  print("First player:              \(tournament.fpName!)")
  print("Second player:             \(tournament.spName!)")
  print("Third player:              \(tournament.tpName!)")
  print("Fourth player:             \(tournament.lpName!)\n")
  print("Players:                   \(tournament.players!)")
  print("Winds:                     \(tournament.winds!)\n")
  print("Wind players:              \(tournament.windPlayer!)")
  print("Current wind:              \(tournament.currentWind!)")
  print("Schedule item:             \(tournament.scheduleItem)")
  print("Winds to players:          \(tournament.windsToPlayersInGame!)")
  print("Players to winds:          \(tournament.playersToWindsInGame!)")
  print("Player game scores:        \(tournament.pgScore!)")
  print("Player tournament scores:  \(tournament.ptScore!)")
}
