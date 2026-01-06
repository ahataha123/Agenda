import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppTab = .today   // 👈 default tab

    var body: some View {
        TabView(selection: $selectedTab) {
            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar")
                }
                .tag(AppTab.stats)

            TodayView()
                .tabItem {
                    Label("Present", systemImage: "sun.max")
                }
                .tag(AppTab.today)

            UpcomingView()
                .tabItem {
                    Label("Upcoming", systemImage: "calendar")
                }
                .tag(AppTab.upcoming)

            NewsView()
                .tabItem {
                    Label("Headlines", systemImage: "newspaper")
                }
                .tag(AppTab.headlines)


        }
    }
}


