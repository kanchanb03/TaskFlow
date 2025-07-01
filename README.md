````markdown
# 📈 Stock Market Tracker – Real-Time System  

A Java-based application that monitors live stock prices, pushes instant notifications, and showcases classic design-pattern architecture. Built for learning high-performance, concurrent programming concepts.  

---

## 💡 Key Features  
* Real-time price updates for multiple tickers  
* Multithreaded data-fetching and event dispatching for snappy CLI / UI feedback  
* **Observer** pattern to broadcast price changes to any number of listeners (GUI, CLI, logging, alerts)  
* **Singleton** pattern for the core `MarketDataHub`, guaranteeing one source of truth  
* Fast in-memory storage with `HashMap<String, Stock>` for O(1) look-ups and updates  
* Clean, modular packages that mirror a distributed micro-service design (data-ingest → processing → notification)  

---

## 🔧 Tech Stack  
| Layer      | Technology                                     |
|------------|------------------------------------------------|
| Language   | Java 17 (compatible with 11+)                  |
| Build      | Maven or Gradle                                |
| Concurrency| `java.util.concurrent` (Executors, Locks)      |
| Testing    | JUnit 5 & Mockito                              |
| Logging    | SLF4J + Logback                                |

---

## 🚀 Quick Start  

```bash
# 1 — Clone
git clone https://github.com/your-username/stock-market-tracker.git
cd stock-market-tracker

# 2 — Build
mvn clean package          # or: ./gradlew build

# 3 — Run
java -jar target/stock-tracker-1.0.jar          # CLI mode
# or launch demo Swing UI
java -cp target/stock-tracker-1.0.jar ui.SwingDashboard
````

Tickers live in `config/tickers.json`; edit and restart to track other symbols.

---

## 🏗️ Architecture Overview

```
┌────────────┐      notifies        ┌───────────────┐
│  DataFeed  │ ───────────────▶ │   MarketDataHub │◀─┐
└────────────┘                   └───────────────┘  │ Singleton
      ▲   fetches                        │           │
      │                                   ▼ Observer
┌────────────┐      updates         ┌─────────────────┐
│ Scheduler  │ ───────────────────▶ │   Subscribers   │
└────────────┘                      │ • CLIView       │
 ExecutorService                    │ • SwingDashboard│
                                    │ • EmailAlert    │
                                    └─────────────────┘
```

---

## 📝 Usage Example

```java
PriceListener logger = (symbol, price) ->
    System.out.printf("%s → $%.2f%n", symbol, price);

MarketDataHub.getInstance().subscribe(logger);
MarketDataHub.getInstance().addSymbol("TSLA");
```

---

## ✅ Tests

```bash
mvn test
```

Unit tests mock the data feed for deterministic offline runs.

---

## 🤝 Contributing

1. Fork and create a feature branch
2. Keep code readable and tested (`mvn spotless:apply`)
3. Open a pull request describing **what** and **why**

---

## 📄 License

MIT – see `LICENSE`.

---

## 🙋‍♀️ Questions?

Open an issue or start a discussion. Happy coding!

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
