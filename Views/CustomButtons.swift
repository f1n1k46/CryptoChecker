import SwiftUI

struct TabButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: 30, alignment: .center)
            .bold()
            .foregroundStyle(.blue)
            .contentShape(Rectangle())
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.smooth, value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == TabButtonStyle {
    static var tabButton: TabButtonStyle { .init() }
}
