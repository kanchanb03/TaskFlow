# 📆 TaskFlow – iOS Productivity Suite

A Swift-powered iPhone app that merges task management, calendar syncing, and smart reminders into a sleek, tab-based dashboard. Designed to demonstrate clean UIKit architecture, Apple frameworks, and classic design patterns.

---

## 💡 Highlights

* Unified dashboard, task list, calendar, and settings in one UITabBarController
* EventKit integration writes tasks straight to the user’s Apple Calendar
* Optional in-app alerts via UserNotifications for due-date nudges
* MVC style with lightweight `struct` models and a **Singleton** `DataManager`
* 100 percent programmatic auto-layout for pixel-perfect views across devices
* Dark / light theme toggle at runtime

---

## 🔧 Tech Stack

| Layer    | Technology                         |
| -------- | ---------------------------------- |
| Language | Swift 5                            |
| IDE      | Xcode 15 (.xcodeproj + Storyboard) |
| UI       | UIKit, Auto-Layout, SF Symbols     |
| APIs     | EventKit, UserNotifications        |
| Patterns | MVC, Singleton                     |
| Testing  | XCTest (`TaskFlowTests`)           |

---

## 🚀 Quick Start

```bash
# 1 — Clone
git clone https://github.com/your-username/TaskFlow.git
cd TaskFlow

# 2 — Open in Xcode
open TaskFlow.xcodeproj       # or: xed .

# 3 — Build & run
Select “TaskFlow” scheme → ▶ to launch on Simulator or device
```

On first launch the app requests Calendar and Notification permissions—grant both to unlock all features.

---

## 🏗️ Architecture Overview

```
┌─────────────────┐  owns arrays   ┌───────────────────┐
│   DataManager   │◀─────────────▶│   Task / Event    │
└─────────────────┘  Singleton     └───────────────────┘
        │                              ▲
        │ feeds                        │ MVC Model
        ▼                              │
┌─────────────────┐ observer → alerts ┌──────────────────┐
│ DashboardVC     │──────────────▶│  NotificationMgr │
│ TaskManagerVC   │               └──────────────────┘
│ CalendarVC      │ delegate           ▲ EventKit save
│ SettingsVC      │────────────▶┐      │
└─────────────────┘             │      ▼
      UIKit ViewControllers     └─────────────┐
                         UITabBarController ◀─┘
```

---

## 📝 Code Snippet

```swift
let task = Task(title: "Ship v1.0",
                due: Date().addingTimeInterval(3600),
                priority: .high)

DataManager.shared.add(task)
NotificationManager.schedule(task)

overrideUserInterfaceStyle = .dark   // toggle dark mode
```

---

## ✅ Tests

Run all tests from Xcode: **Product ▸ Test** (⌘U).

---

## 🤝 Contributing

1. Fork → create a feature branch
2. Follow SwiftLint rules (`brew install swiftlint`)
3. Submit a pull request with screenshots and context

---

## 📄 License

MIT – see `LICENSE`.

---

## 🙋‍♂️ Questions?

Open an issue or join Discussions. Happy building!

```
```
