//
//  Task.swift
//  Taskflow
//
//  Created by Kanchan Bandesha on 3/15/25.
//

import Foundation

struct Task: Codable {
    var name: String
    var importance: String
    var isCompleted: Bool
    var note: String?
}
