@testable import AgifyApp
import SnapshotTesting
import SwiftUI
import Testing

@Suite(.snapshots(record: .missing, diffTool: .ksdiff))
struct SnapshotTests {
    @Test(arguments: [UIUserInterfaceStyle.light, .dark])
    func `name field`(style: UIUserInterfaceStyle) {
        let view = NameField(name: .constant("Michael"))
            .padding()
            .withoutAnimations()

        assertSnapshot(of: view, as: .image(size: CGSize(width: 390, height: 100), style: style), named: style.name)
    }

    @Test(arguments: [UIUserInterfaceStyle.light, .dark])
    func `age result`(style: UIUserInterfaceStyle) {
        let view = AgeResultView(estimate: GetAgeForNameResponse(name: "michael", age: 57, count: 311_558))
            .withoutAnimations()

        assertSnapshot(of: view, as: .image(size: CGSize(width: 390, height: 320), style: style), named: style.name)
    }
}

private extension Snapshotting where Value: SwiftUI.View, Format == UIImage {
    static func image(size: CGSize, style: UIUserInterfaceStyle) -> Self {
        .image(
            drawHierarchyInKeyWindow: true,
            layout: .fixed(width: size.width, height: size.height),
            traits: UITraitCollection(userInterfaceStyle: style),
        )
    }
}

private extension UIUserInterfaceStyle {
    var name: String {
        self == .dark ? "dark" : "light"
    }
}

private extension View {
    func withoutAnimations() -> some View {
        transaction { $0.animation = nil }
    }
}
