# 📆 TaskFlow – iOS Productivity Suite  

A Swift-powered iPhone app that merges task management, calendar syncing, and smart reminders into a sleek, tab-based dashboard. Designed to demonstrate clean UIKit architecture, Apple frameworks, and classic design patterns.

---

## 💡 Highlights  
* Unified dashboard, task list, calendar, and settings in one UITabBarController  
* EventKit integration to write tasks straight to the user’s Apple Calendar  
* Optional push-in-app alerts via UserNotifications for due-date nudges  
* MVC style with lightweight `struct` models, view controllers per screen, and a **Singleton** `DataManager`  
* 100 % programmatic auto-layout for pixel-perfect views across devices  
* Dark / light theme toggle at runtime

---

## 🔧 Tech Stack  
| Layer | Technology |
|-------|------------|
| Language | Swift 5 |
| IDE | Xcode 15.x (.xcodeproj + Storyboard) |
| UI | UIKit, Auto-Layout, SF Symbols |
| APIs | EventKit, UserNotifications |
| Patterns | MVC, Singleton |
| Tests | XCTest (unit tests stubbed in `TaskflowTests`) |

---

## 🚀 Quick Start  

```bash
# 1. Clone
git clone https://github.com/your-username/TaskFlow.git
cd TaskFlow

# 2. Open in Xcode
open TaskFlow.xcodeproj   # or: xed .

# 3. Build & run
Choose “TaskFlow” scheme ➡️ press ▶️ to launch on Simulator or device
---

## 🏗️ Architecture Overview
---

┌─────────────────┐   owns arrays   ┌───────────────────┐
│   DataManager   │◀──────────────▶│   Task / Event    │
└─────────────────┘   Singleton     └───────────────────┘
        │                               ▲
        │ feeds                         │ MVC Model
        ▼                               │
┌─────────────────┐ observer ▶ alerts ┌──────────────────┐
│ DashboardVC     │──────────────▶│   NotificationMgr │
│ TaskManagerVC   │               └──────────────────┘
│ CalendarVC      │  delegates        ▲ EventKit save
│ SettingsVC      │───────────▶┐      │
└─────────────────┘            │      ▼
       UIKit ViewControllers   └───────────────┐
                         UITabBarController ◀─┘
DataManager – central in-memory store for tasks and events.
DashboardVC – high-level stats and quick-add buttons.
TaskManagerVC – table view for tasks with priority picker.
CalendarVC – Month grid backed by EventKit.
SettingsVC – theme toggle, notification options.
## 📝 Code Snippets

// Add a new task and schedule a reminder
let task = Task(title: "Finish README",
                due: Date().addingTimeInterval(3600),
                priority: .high)

DataManager.shared.add(task)
NotificationManager.schedule(task)

// Switch to dark mode
overrideUserInterfaceStyle = .dark
✅ Running Tests

⌘U  # inside Xcode
Unit tests validate model logic and singleton data consistency.

---
## 🤝 Contributing
---

Fork → create feature branch
Follow SwiftLint style rules (brew install swiftlint)
Submit a pull request with context and screenshots

---

🙋‍♂️ Questions / Feedback
---

Open an issue or join the discussion board. Happy building!
