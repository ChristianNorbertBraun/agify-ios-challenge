import SwiftUI

struct SearchView: View {
    private enum Phase: Equatable {
        case idle
        case loaded(GetAgeForNameResponse)
        case failed(String)
    }

    @Environment(\.ageSearch) private var ageSearch
    @State private var query = ""
    @State private var phase = Phase.idle
    @State private var isLoading = false
    @FocusState private var isNameFocused: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    Text("Wie alt klingt dein Name?")
                        .font(.largeTitle.bold())
                    Text("Gib einen Vornamen ein und agify schätzt das Alter.")
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.center)

                NameField(name: $query, isLoading: isLoading)
                    .focused($isNameFocused)

                switch phase {
                case .idle:
                    EmptyView()
                case let .loaded(estimate):
                    AgeResultView(estimate: estimate)
                case let .failed(message):
                    Label(message, systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.secondary)
                }
            }
            .padding(24)
            .frame(maxWidth: 500)
        }
        .scrollDismissesKeyboard(.interactively)
        .sensoryFeedback(trigger: phase) { _, phase in
            switch phase {
            case .idle: nil
            case let .loaded(estimate): estimate.age == nil ? .warning : .success
            case .failed: .error
            }
        }
        .onAppear { isNameFocused = true }
        .task(id: query, debounce: .milliseconds(500)) {
            await search()
        }
    }

    private func search() async {
        isLoading = true
        defer { isLoading = false }
        do {
            phase = try await ageSearch(query).map(Phase.loaded) ?? .idle
        } catch {
            guard !Task.isCancelled else {
                return
            }
            phase = .failed(error.localizedDescription)
            ErrorReporter.capture(error)
        }
    }
}

#Preview {
    SearchView()
}

#Preview("Rate limited") {
    SearchView()
        .environment(
            \.ageSearch,
            AgeSearchUseCase(client: MockAgifyClient(error: .rateLimited(resetIn: .seconds(8568)))),
        )
}
