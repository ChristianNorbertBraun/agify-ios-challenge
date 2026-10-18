import SwiftUI

struct NameField: View {
    @Binding var name: String
    var isLoading = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.text.rectangle")
                .foregroundStyle(.secondary)
            TextField("Vorname", text: $name)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
            if isLoading {
                ProgressView()
            } else if !name.isEmpty {
                Button("Eingabe löschen", systemImage: "xmark.circle.fill") {
                    name = ""
                }
                .labelStyle(.iconOnly)
                .foregroundStyle(.secondary)
            }
        }
        .font(.title3)
        .padding(.horizontal, 20)
        .frame(minHeight: 60)
        .glassEffect(.regular, in: .capsule)
    }
}

#Preview {
    @Previewable @State var name = "Michael"
    NameField(name: $name)
        .padding()
}

#Preview("Loading") {
    NameField(name: .constant("Michael"), isLoading: true)
        .padding()
}
