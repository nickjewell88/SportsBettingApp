
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
    var body: some View {
        VStack {
            // TODO: Add Expected Runs Calculator
            // TODO: Add True Average Calculator
        }
        .navigationBarTitle("Baseball Tools")
    }
}

struct BasketballToolView: View {
    var body: some View {
        // TODO: Add Basketball Tool
        Text("Basketball Tool")
            .navigationBarTitle("Basketball Tool")
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
