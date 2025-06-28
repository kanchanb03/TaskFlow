//
//  TaskManager.swift
//  Taskflow
//
//  Created by Kanchan Bandesha on 3/14/25.
//

import Foundation

class TaskManager {
    static let shared = TaskManager()
    private init() {
        loadTasks()
    }
    
    private var tasks: [Task] = []
    private let tasksKey = "tasksKey" 
    
    func add(task: Task) {
        tasks.append(task)
        saveTasks()
    }
    
    func removeTask(at index: Int) {
        tasks.remove(at: index)
        saveTasks()
    }
    
    func updateTask(at index: Int, with task: Task) {
        tasks[index] = task
        saveTasks()
    }
    
    func getTasks() -> [Task] {
        return tasks
    }
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: tasksKey)
        }
    }
    
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: tasksKey),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decoded
        }
    }
}
