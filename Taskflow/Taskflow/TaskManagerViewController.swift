//
//  TaskManagerViewController.swift
//  Taskflow
//
//  Created by Kanchan Bandesha on 3/14/25.
//

import UIKit

class TaskCell: UITableViewCell {
    
    let indicatorView = UIView()
    let checkboxButton = UIButton(type: .system)
    let nameLabel = UILabel()
    let notePreviewLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Make the cell's background transparent.
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.layer.cornerRadius = 4
        indicatorView.clipsToBounds = true
        contentView.addSubview(indicatorView)
        
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        checkboxButton.setTitle("☐", for: .normal)
        checkboxButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        contentView.addSubview(checkboxButton)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        contentView.addSubview(nameLabel)
        
        notePreviewLabel.translatesAutoresizingMaskIntoConstraints = false
        notePreviewLabel.font = UIFont.systemFont(ofSize: 14)
        notePreviewLabel.textColor = .darkGray
        notePreviewLabel.numberOfLines = 1
        contentView.addSubview(notePreviewLabel)
       
        NSLayoutConstraint.activate([
            indicatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            indicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: 8),
            indicatorView.heightAnchor.constraint(equalToConstant: 40),
            
            checkboxButton.leadingAnchor.constraint(equalTo: indicatorView.trailingAnchor, constant: 10),
            checkboxButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkboxButton.widthAnchor.constraint(equalToConstant: 30),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
 
            notePreviewLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            notePreviewLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            notePreviewLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            notePreviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
}

class TaskManagerViewController: UIViewController,
                                UITableViewDataSource,
                                UITableViewDelegate,
                                UIPickerViewDelegate,
                                UIPickerViewDataSource {
    
    let titleLabel = UILabel()
    let taskNameTextField = UITextField()
    let importanceTextField = UITextField()
    let addTaskButton = UIButton(type: .system)
    let tableView = UITableView()
 
    let importancePicker = UIPickerView()
    let importanceOptions = ["Low", "Medium", "High"]
    
    var sortedTasks: [Task] {
        TaskManager.shared.getTasks().sorted { task1, task2 in
            priorityValue(for: task1.importance) < priorityValue(for: task2.importance)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .dynamicBackground
        
        // Title label in #DAA520 (Goldenrod)
        titleLabel.text = "Task Manager"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(
            red: 218.0/255.0,
            green: 165.0/255.0,
            blue: 32.0/255.0,
            alpha: 1.0
        )
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        taskNameTextField.placeholder = "Enter task name"
        taskNameTextField.borderStyle = .roundedRect
        taskNameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(taskNameTextField)
        
        importanceTextField.placeholder = "Select Importance"
        importanceTextField.borderStyle = .roundedRect
        importanceTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(importanceTextField)
        
        addTaskButton.setTitle("Add Task", for: .normal)
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.addTarget(self, action: #selector(addTaskTapped), for: .touchUpInside)
        view.addSubview(addTaskButton)

        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)

        importancePicker.delegate = self
        importancePicker.dataSource = self
        importanceTextField.inputView = importancePicker

        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
      
            taskNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            taskNameTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            taskNameTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            taskNameTextField.heightAnchor.constraint(equalToConstant: 40),

            importanceTextField.topAnchor.constraint(equalTo: taskNameTextField.bottomAnchor, constant: 10),
            importanceTextField.leadingAnchor.constraint(equalTo: taskNameTextField.leadingAnchor),
            importanceTextField.trailingAnchor.constraint(equalTo: taskNameTextField.trailingAnchor),
            importanceTextField.heightAnchor.constraint(equalToConstant: 40),
            
            addTaskButton.topAnchor.constraint(equalTo: importanceTextField.bottomAnchor, constant: 10),
            addTaskButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            addTaskButton.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: addTaskButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }

    @objc func addTaskTapped() {
        guard let taskName = taskNameTextField.text, !taskName.isEmpty,
              let importance = importanceTextField.text, !importance.isEmpty else {
            return
        }

        let newTask = Task(name: taskName, importance: importance, isCompleted: false, note: nil)
        TaskManager.shared.add(task: newTask)
        tableView.reloadData()

        taskNameTextField.text = ""
        importanceTextField.text = ""
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return sortedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "TaskCell",
            for: indexPath
        ) as? TaskCell else {
            return UITableViewCell()
        }
        
        // Make the cell transparent
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        let task = sortedTasks[indexPath.row]
        cell.nameLabel.text = task.name
        cell.notePreviewLabel.text = task.note ?? ""
        
        let checkboxTitle = task.isCompleted ? "☑︎" : "☐"
        cell.checkboxButton.setTitle(checkboxTitle, for: .normal)
        cell.checkboxButton.tag = indexPath.row
        cell.checkboxButton.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
        
        cell.indicatorView.backgroundColor = colorForImportance(task.importance)
        
        return cell
    }
    
    // Swipe to delete
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            TaskManager.shared.removeTask(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    


    @objc func checkboxTapped(_ sender: UIButton) {
        let sorted = sortedTasks
        let tappedTask = sorted[sender.tag]

        if let originalIndex = TaskManager.shared.getTasks().firstIndex(where: { $0.name == tappedTask.name }) {
            var tasks = TaskManager.shared.getTasks()
            tasks[originalIndex].isCompleted.toggle()
            TaskManager.shared.updateTask(at: originalIndex, with: tasks[originalIndex])
            tableView.reloadData()
        }
    }



    func priorityValue(for importance: String) -> Int {
        let normalized = importance.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch normalized {
            case "high": return 0
            case "medium": return 1
            case "low": return 2
            default: return 3
        }
    }
    
    func colorForImportance(_ importance: String) -> UIColor {
         let normalized = importance.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
         switch normalized {
            case "high": return .systemRed
            case "medium": return .systemOrange
            case "low": return .systemGreen
            default: return .gray
         }
    }


    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return importanceOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
         return importanceOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
         importanceTextField.text = importanceOptions[row]
         importanceTextField.resignFirstResponder()
    }
}
