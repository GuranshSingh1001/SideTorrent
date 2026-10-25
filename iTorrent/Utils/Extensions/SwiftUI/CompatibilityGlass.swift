//
//  CompatibilityGlass.swift
//  iTorrent
//
//  Simple, opaque controls in place of Liquid Glass styling.
//

import SwiftUI

struct CompatibilityGlassContainer<Content: View>: View {
    let spacing: CGFloat
    let content: Content

    init(spacing: CGFloat = 0, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }

    var body: some View {
        content
    }
}

extension View {
    func compatibilityGlassEffect(isClear: Bool = false, interactive: Bool = false) -> some View {
        compatibilityGlassEffect(in: Capsule(), isClear: isClear, interactive: interactive)
    }

    func compatibilityGlassEffect<S: Shape>(
        in shape: S,
        isClear: Bool = false,
        interactive: Bool = false
    ) -> some View {
        background(Color(uiColor: .secondarySystemBackground), in: shape)
    }

    func compatibilityGlassTransition() -> some View {
        self
    }

    func compatibilityGlassID<ID: Hashable & Sendable>(_ id: ID, in namespace: Namespace.ID) -> some View {
        self
    }
}
