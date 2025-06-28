//
//  DashboardViewController.swift
//  Taskflow
//
//  Created by Kanchan Bandesha on 3/14/25.
//

import UIKit
import EventKit
import EventKitUI

class DashboardViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,EKEventEditViewDelegate {

    private let welcomeLabel = UILabel()
    private let dateLabel = UILabel()
    private let addTaskButton = UIButton(type: .system)
    private let addEventButton = UIButton(type: .system)
    private let tasksLabel = UILabel()
    private let eventsLabel = UILabel()
    private let tasksTableView = UITableView()
    private let eventsTableView = UITableView()


    private let eventStore = EKEventStore()
    private var events: [EKEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .dynamicBackground
        

        welcomeLabel.text = "Welcome to Taskflow!"
        welcomeLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        welcomeLabel.textAlignment = .center
        welcomeLabel.textColor = .dynamicHeading
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeLabel)

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        dateLabel.text = formatter.string(from: Date())
        dateLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        dateLabel.textAlignment = .center
        dateLabel.textColor = .dynamicHeading
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)
        
        addTaskButton.setTitle("Add Task", for: .normal)
        addTaskButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        addTaskButton.backgroundColor = .systemGray6
        addTaskButton.layer.cornerRadius = 8
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.addTarget(self, action: #selector(addTaskTapped), for: .touchUpInside)
        view.addSubview(addTaskButton)
       
        addEventButton.setTitle("Add Event", for: .normal)
        addEventButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        addEventButton.backgroundColor = .systemGray6
        addEventButton.layer.cornerRadius = 8
        addEventButton.translatesAutoresizingMaskIntoConstraints = false
        addEventButton.addTarget(self, action: #selector(addEventTapped), for: .touchUpInside)
        view.addSubview(addEventButton)
        
       
        tasksLabel.text = "Your Tasks"
        tasksLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        tasksLabel.textColor = .dynamicHeading
        tasksLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tasksLabel)
        
       
        tasksTableView.backgroundColor = .clear
        tasksTableView.separatorStyle = .singleLine
        tasksTableView.translatesAutoresizingMaskIntoConstraints = false
        tasksTableView.dataSource = self
        tasksTableView.delegate = self
        tasksTableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        view.addSubview(tasksTableView)
        
       
        eventsLabel.text = "Upcoming Events"
        eventsLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        eventsLabel.textColor = .dynamicHeading
        eventsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventsLabel)
        

        eventsTableView.backgroundColor = .clear
        eventsTableView.separatorStyle = .singleLine
        eventsTableView.translatesAutoresizingMaskIntoConstraints = false
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        eventsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "EventCell")
        view.addSubview(eventsTableView)

        setupConstraints()

        requestCalendarAccess()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tasksTableView.reloadData()
        fetchUpcomingEvents()
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([

            welcomeLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            

            dateLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor),

            addTaskButton.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 15),
            addTaskButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            addTaskButton.widthAnchor.constraint(equalToConstant: 120),
            addTaskButton.heightAnchor.constraint(equalToConstant: 40),
            
      
            addEventButton.centerYAnchor.constraint(equalTo: addTaskButton.centerYAnchor),
            addEventButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            addEventButton.widthAnchor.constraint(equalToConstant: 120),
            addEventButton.heightAnchor.constraint(equalToConstant: 40),
            
        
            tasksLabel.topAnchor.constraint(equalTo: addTaskButton.bottomAnchor, constant: 25),
            tasksLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            tasksLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
   
            tasksTableView.topAnchor.constraint(equalTo: tasksLabel.bottomAnchor, constant: 10),
            tasksTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            tasksTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            tasksTableView.heightAnchor.constraint(equalToConstant: 200),
            
   
            eventsLabel.topAnchor.constraint(equalTo: tasksTableView.bottomAnchor, constant: 25),
            eventsLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            eventsLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
       
            eventsTableView.topAnchor.constraint(equalTo: eventsLabel.bottomAnchor, constant: 10),
            eventsTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            eventsTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            eventsTableView.heightAnchor.constraint(equalToConstant: 200),
            eventsTableView.bottomAnchor.constraint(lessThanOrEqualTo: safeArea.bottomAnchor, constant: -20)
        ])
    }
    

    
    private func requestCalendarAccess() {
        eventStore.requestFullAccessToEvents { granted, error in
            if granted {
                DispatchQueue.main.async {
                    self.fetchUpcomingEvents()
                }
            } else {
                print("Calendar is not working")
            }
        }
    }
    
    private func fetchUpcomingEvents() {
        let startDate = Date()
        guard let endDate = Calendar.current.date(byAdding: .day, value: 7, to: startDate) else { return }
        
        let predicate = eventStore.predicateForEvents(
            withStart: startDate,
            end: endDate,
            calendars: nil
        )
        let foundEvents = eventStore.events(matching: predicate)
            .sorted { $0.startDate < $1.startDate }
        
        // Only first 4
        events = Array(foundEvents.prefix(4))
        eventsTableView.reloadData()
    }
    
    @objc private func addTaskTapped() {
        let alert = UIAlertController(
            title: "Add Task",
            message: "Enter task details",
            preferredStyle: .alert
        )
        alert.addTextField { textField in
            textField.placeholder = "Task Name"
        }
        alert.addTextField { textField in
            textField.placeholder = "Importance (Low, Medium, High)"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            guard let taskName = alert.textFields?[0].text,
                  !taskName.isEmpty,
                  let importance = alert.textFields?[1].text,
                  !importance.isEmpty else {
                return
            }
            let newTask = Task(
                name: taskName,
                importance: importance,
                isCompleted: false,
                note: nil
            )
            TaskManager.shared.add(task: newTask)
            self.tasksTableView.reloadData()
        }))
        present(alert, animated: true)
    }
    
    @objc private func addEventTapped() {
        let editVC = EKEventEditViewController()
        editVC.eventStore = eventStore
        editVC.editViewDelegate = self
        present(editVC, animated: true)
    }
    

    
    func eventEditViewController(_ controller: EKEventEditViewController,
                                 didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true) {
            if action != .canceled {
                self.fetchUpcomingEvents()
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if tableView == tasksTableView {
            return sortedTasks.count
        } else {
            return events.count
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tasksTableView {
   
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "TaskCell",
                for: indexPath
            ) as? TaskCell else {
                return UITableViewCell()
            }
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            
            let task = sortedTasks[indexPath.row]
            cell.nameLabel.text = task.name
          
            cell.nameLabel.textColor = .dynamicBody
            
            cell.notePreviewLabel.text = task.note ?? ""
            cell.notePreviewLabel.textColor = .dynamicBody
            
            let checkboxTitle = task.isCompleted ? "☑︎" : "☐"
            cell.checkboxButton.setTitle(checkboxTitle, for: .normal)
            cell.checkboxButton.tag = indexPath.row
            cell.checkboxButton.addTarget(
                self,
                action: #selector(checkboxTapped(_:)),
                for: .touchUpInside
            )
      
            cell.indicatorView.backgroundColor = colorForImportance(task.importance)
            return cell
            
        } else {
         
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            
            let event = events[indexPath.row]
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            
            let eventDate = formatter.string(from: event.startDate)
            cell.textLabel?.text = "\(event.title ?? "No Title") - \(eventDate)"
  
            cell.textLabel?.textColor = .dynamicBody
            return cell
        }
    }
    

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if tableView == tasksTableView && editingStyle == .delete {
            TaskManager.shared.removeTask(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
  
    
    @objc private func checkboxTapped(_ sender: UIButton) {
        let tappedTask = sortedTasks[sender.tag]
        if let originalIndex = TaskManager.shared.getTasks().firstIndex(where: { $0.name == tappedTask.name }) {
            var tasks = TaskManager.shared.getTasks()
            tasks[originalIndex].isCompleted.toggle()
            TaskManager.shared.updateTask(at: originalIndex, with: tasks[originalIndex])
            tasksTableView.reloadData()
        }
    }
    

    
    private func colorForImportance(_ importance: String) -> UIColor {
        let normalized = importance.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch normalized {
        case "low":
            return .systemGreen
        case "medium":
            return .systemOrange
        case "high":
            return .systemRed
        default:
            return .gray
        }
    }
    
    private func priorityValue(for importance: String) -> Int {
        let normalized = importance.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch normalized {
        case "high":
            return 0
        case "medium":
            return 1
        case "low":
            return 2
        default:
            return 3
        }
    }
    

    
    private var sortedTasks: [Task] {
        return TaskManager.shared.getTasks().sorted { task1, task2 in
            priorityValue(for: task1.importance) < priorityValue(for: task2.importance)
        }
    }
}
