import SwiftUI

// Bet data model
struct Bet: Identifiable, Codable {
    var id: UUID = UUID()
    var teamName: String
    var amount: Double
    var predictedOutcome: String
}

// View model for the BetTrackerView
class BetTrackerViewModel: ObservableObject {
    @Published var bets: [Bet] = [] {
        didSet {
            saveBets()
        }
    }

    init() {
        loadBets()
    }

    func addBet(teamName: String, amount: Double, predictedOutcome: String) {
        let newBet = Bet(teamName: teamName, amount: amount, predictedOutcome: predictedOutcome)
        bets.append(newBet)
    }

    func saveBets() {
        if let encoded = try? JSONEncoder().encode(bets) {
            UserDefaults.standard.set(encoded, forKey: "SavedBets")
        }
    }

    func loadBets() {
        if let savedBets = UserDefaults.standard.data(forKey: "SavedBets"),
           let decodedBets = try? JSONDecoder().decode([Bet].self, from: savedBets) {
            bets = decodedBets
        }
    }
}

struct BetTrackerView: View {
    @StateObject private var viewModel = BetTrackerViewModel()
    @State private var teamName: String = ""
    @State private var amountText: String = ""
    @State private var predictedOutcome: String = ""

    var body: some View {
        VStack {
            TextField("Team Name", text: $teamName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Bet Amount", text: $amountText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .padding()

            TextField("Predicted Outcome", text: $predictedOutcome)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Add Bet") {
                if let amount = Double(amountText) {
                    viewModel.addBet(teamName: teamName, amount: amount, predictedOutcome: predictedOutcome)
                    teamName = ""
                    amountText = ""
                    predictedOutcome = ""
                }
            }
            .padding()

            List(viewModel.bets) { bet in
                VStack(alignment: .leading) {
                    Text(bet.teamName).font(.headline)
                    Text("Bet Amount: $\(bet.amount, specifier: "%.2f")")
                    Text("Predicted Outcome: \(bet.predictedOutcome)")
                }
            }
        }
        .navigationBarTitle("Bet Tracker")
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Baseball Tools", destination: BaseballToolsView())
                NavigationLink("Basketball Tool", destination: BasketballToolView())
                NavigationLink("Costanza", destination: CostanzaView())
                NavigationLink("Bet Tracker", destination: BetTrackerView())
                NavigationLink("User Profile", destination: UserProfileView())
            }
            .navigationBarTitle("SportsBet Assistant")
        }
    }
}

struct BaseballToolsView: View {
    @State private var avgOffenseA: String = ""
    @State private var avgDefenseA: String = ""
    @State private var avgOffenseB: String = ""
    @State private var avgDefenseB: String = ""
    @State private var windSpeed: String = ""
    @State private var windGust: String = ""
    @State private var windDirection: String = ""
    @State private var expectedRunsResult: String = ""

    var body: some View {
        VStack {
            TextField("Average Offense Scored by Home Team", text: $avgOffenseA)
                .keyboardType(.decimalPad)
            TextField("Average Defense Scored by Home Team", text: $avgDefenseA)
                .keyboardType(.decimalPad)
            TextField("Average Offense Scored by Away Team", text: $avgOffenseB)
                .keyboardType(.decimalPad)
            TextField("Average Defense Scored by Away Team", text: $avgDefenseB)
                .keyboardType(.decimalPad)
            TextField("Wind Speed in mph", text: $windSpeed)
                .keyboardType(.decimalPad)
            TextField("Wind Gust in mph", text: $windGust)
                .keyboardType(.decimalPad)
            TextField("Wind Direction ('in', 'out', 'cross')", text: $windDirection)

            Button("Calculate Expected Runs") {
                expectedRunsResult = calculateExpectedRuns()
            }

            // Display the result
            Text(expectedRunsResult)
        }
        .navigationBarTitle("Baseball Tools")
        .padding()
    }

    func calculateExpectedRuns() -> String {
        guard let avgOffA = Double(avgOffenseA),
              let defA = Double(avgDefenseA),
              let avgOffB = Double(avgOffenseB),
              let defB = Double(avgDefenseB),
              let windSpd = Double(windSpeed),
              let windGst = Double(windGust),
              !windDirection.isEmpty else {
            return "Please fill in all fields with valid numbers."
        }

        let expectedRunsBase = (avgOffA + defB + avgOffB + defA) / 2.0
        let windFactor = windDirection.lowercased() == "in" ? -0.03 : (windDirection.lowercased() == "out" ? 0.06 : 0.04)
        let gustFactor = windDirection.lowercased() == "in" ? -0.01 : (windDirection.lowercased() == "out" ? 0.03 : 0.02)
        let adjustedRuns = expectedRunsBase + (windFactor * windSpd) + (gustFactor * windGst)

        return String(format: "Expected runs: %.2f", adjustedRuns)
    }
}
struct BasketballToolView: View {
    @State private var averageMinutesPlayed: String = ""
    @State private var statPer48Minutes: String = ""
    @State private var actualAverageResult: String = ""

    var body: some View {
        VStack {
            TextField("Average Minutes Played Per Game", text: $averageMinutesPlayed)
                .keyboardType(.numberPad)
                .padding()

            TextField("Stat Per 48 Minutes", text: $statPer48Minutes)
                .keyboardType(.decimalPad)
                .padding()

            Button("Calculate Actual Average") {
                actualAverageResult = calculateActualAverage()
            }
            .padding()

            // Display the result
            Text(actualAverageResult)
        }
        .navigationBarTitle("Basketball Tool")
        .padding()
    }

    func calculateActualAverage() -> String {
        guard let avgMinutes = Double(averageMinutesPlayed), avgMinutes > 0,
              let statFor48 = Double(statPer48Minutes) else {
            return "Please enter valid numbers."
        }

        let perMinuteStat = statFor48 / 48 // Stat per minute
        let actualAverage = perMinuteStat * avgMinutes // Adjusted for actual minutes played
        return String(format: "Actual Average: %.2f", actualAverage)
    }
}


struct CostanzaView: View {
    var body: some View {
        // TODO: Add Costanza UI
        Text("Costanza")
            .navigationBarTitle("Costanza")
    }
}

struct UserProfileView: View {
    var body: some View {
        // TODO: Add User Profile UI
        Text("User Profile")
            .navigationBarTitle("User Profile")
    }
}

@main
struct SportsBetAssistantApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
