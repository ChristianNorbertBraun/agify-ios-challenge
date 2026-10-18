import SwiftUI

struct AgeResultView: View {
    let estimate: GetAgeForNameResponse
    @State private var displayedAge = 0

    var body: some View {
        VStack(spacing: 8) {
            if let age = estimate.age {
                Text("\(estimate.name.capitalized) ist geschätzt")
                    .font(.title3)
                Text(displayedAge, format: .number)
                    .font(.system(size: 120, weight: .bold, design: .rounded))
                    .contentTransition(.numericText(value: Double(displayedAge)))
                    .onChange(of: age, initial: true) {
                        withAnimation(.smooth(duration: 0.8)) { displayedAge = age }
                    }
                Text("Jahre alt")
                    .font(.title3)
                Text("Basierend auf \(estimate.count.formatted()) Einträgen")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)
            } else {
                ContentUnavailableView(
                    "Kein Alter gefunden",
                    systemImage: "questionmark.circle",
                    description: Text("Für „\(estimate.name)“ hat agify keine Daten."),
                )
            }
        }
        .multilineTextAlignment(.center)
        .animation(.snappy, value: estimate)
    }
}

#Preview {
    AgeResultView(estimate: GetAgeForNameResponse(name: "michael", age: 57, count: 311_558))
}

#Preview("Unknown name") {
    AgeResultView(estimate: GetAgeForNameResponse(name: "xqzvbn", age: nil, count: 0))
}
