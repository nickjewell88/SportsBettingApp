import SwiftUI

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

struct BetTrackerView: View {
    var body: some View {
        VStack {
            // TODO: Add Bet Input UI
            // TODO: Add History Viewer UI
        }
        .navigationBarTitle("Bet Tracker")
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
