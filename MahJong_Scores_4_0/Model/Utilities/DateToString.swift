//
//  DateToString.swift
//  MJS
//
//  Created by Robert Goedman on 4/1/24.
//

import Foundation

func dateToString() -> String {
  let date = Date()
  let calendar = Calendar.current
  let components = calendar.dateComponents([.day, .month, .year], from: date)
  return "\(components.month!)/\(components.day!)/\(components.year!)"
}
