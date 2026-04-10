import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TranslateView()
                .tabItem {
                    Label("번역", systemImage: "globe")
                }
            CorrectView()
                .tabItem {
                    Label("교정", systemImage: "checkmark.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}
