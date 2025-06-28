# 📈 Stock Market Tracker – Real-Time System  

A Java-based application that monitors live stock prices, pushes instant notifications, and showcases classic design-pattern architecture. Built for learning high-performance, concurrent programming concepts.  

---

## 💡 Key Features  
* Real-time price updates for multiple tickers  
* Multithreaded data-fetching and event dispatching for snappy CLI / UI feedback  
* **Observer** pattern to broadcast price changes to any number of listeners (GUI, CLI, logging, alerts)  
* **Singleton** pattern for the core `MarketDataHub`, guaranteeing one source of truth  
* Fast in-memory storage with `HashMap<String, Stock>` for *O*(1) look-ups and updates  
* Clean, modular packages that mirror a distributed micro-service design (data-ingest → processing → notification)  

---

## 🔧 Tech Stack  
| Layer       | Technology                                    |
|-------------|-----------------------------------------------|
| Language    | Java 17 (compatible with 11+)                 |
| Build       | Maven or Gradle                               |
| Concurrency | `java.util.concurrent` (Executors, Locks)     |
| Testing     | JUnit 5 & Mockito                              |
| Logging     | SLF4J + Logback                               |

---

## 🚀 Quick Start  

```bash
# 1 — Clone
git clone https://github.com/your-username/stock-market-tracker.git
cd stock-market-tracker

# 2 — Build
mvn clean package            # or: ./gradlew build

# 3 — Run
java -jar target/stock-tracker-1.0.jar          # CLI mode
# or launch demo Swing UI
java -cp target/stock-tracker-1.0.jar ui.SwingDashboard
```

Default tickers live in **`config/tickers.json`** – edit and restart to track other symbols.  

---

## 🏗️ Architecture Overview  

```text
┌────────────┐      notifies        ┌───────────────┐
│  DataFeed  │ ───────────────▶ │   MarketDataHub │◀─┐
└────────────┘                   └───────────────┘  │ Singleton
      ▲   fetches                       │            │
      │                                  ▼ Observer
┌────────────┐      updates        ┌─────────────────┐
│ Scheduler  │ ─────────────────▶ │   Subscribers   │
└────────────┘                    │ • CLIView       │
 ExecutorService                  │ • SwingDashboard│
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
3. Open a pull request explaining **what** and **why**  

---

## 📄 License  
MIT – see **`LICENSE`**.  

---

## 🙋‍♀️ Questions?  
Open an issue or start a discussion. Happy coding!  

