//
//  CalendarViewController.swift
//  Taskflow
//
//  Created by Kanchan Bandesha on 3/14/25.
//

import UIKit
import EventKit
import EventKitUI

class CalendarViewController: UIViewController,UICalendarSelectionSingleDateDelegate,EKEventEditViewDelegate,
UITableViewDataSource, UITableViewDelegate {

    private let eventStore = EKEventStore()
    private var events: [EKEvent] = []

    private var selectedDate: Date = Date()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Calendar"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = UIColor(
            red: 218.0/255.0,
            green: 165.0/255.0,
            blue: 32.0/255.0,
            alpha: 1.0
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let calendarView: UICalendarView = {
        let cv = UICalendarView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.calendar = Calendar.current
        cv.locale = Locale.current
        cv.backgroundColor = .clear
        return cv
    }()

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        return tv
    }()


    private let addEventButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Add Event", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .dynamicBackground

        view.addSubview(titleLabel)
        view.addSubview(calendarView)
        view.addSubview(addEventButton)
        view.addSubview(tableView)

        calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)


        tableView.dataSource = self
        tableView.delegate = self

        addEventButton.addTarget(self, action: #selector(addEventTapped), for: .touchUpInside)

        setupConstraints()
        requestCalendarAccess()
    }

  
    private func setupConstraints() {
        
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
          
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),

            calendarView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            calendarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: 300),


            addEventButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 8),
            addEventButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            addEventButton.heightAnchor.constraint(equalToConstant: 40),


            tableView.topAnchor.constraint(equalTo: addEventButton.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }


    private func requestCalendarAccess() {
        eventStore.requestFullAccessToEvents { granted, error in
            if granted {
                DispatchQueue.main.async {
                    self.fetchEvents(for: self.selectedDate)
                }
            } else {
                print("Calendar access denied.")
            }
        }
    }

 
    private func fetchEvents(for date: Date) {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else { return }
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        self.events = eventStore.events(matching: predicate).sorted { $0.startDate < $1.startDate }
        tableView.reloadData()
    }


    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents,
              let date = Calendar.current.date(from: dateComponents) else {
            return
        }
        selectedDate = date
        fetchEvents(for: date)
    }

 
    @objc private func addEventTapped() {
        let eventEditVC = EKEventEditViewController()
        eventEditVC.eventStore = eventStore
        eventEditVC.editViewDelegate = self
        present(eventEditVC, animated: true)
    }


    func eventEditViewController(_ controller: EKEventEditViewController,
                                 didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true) {
            if action != .canceled {
                // Refresh events after adding or editing an event.
                self.fetchEvents(for: self.selectedDate)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")

        // Make each cell transparent so background shows.
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear

        let event = events[indexPath.row]
        cell.textLabel?.text = event.title ?? "No Title"

        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        cell.detailTextLabel?.text = "\(formatter.string(from: event.startDate)) - \(formatter.string(from: event.endDate))"

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedEvent = events[indexPath.row]
        let eventEditVC = EKEventEditViewController()
        eventEditVC.eventStore = eventStore
        eventEditVC.event = selectedEvent
        eventEditVC.editViewDelegate = self
        present(eventEditVC, animated: true)
    }
}
