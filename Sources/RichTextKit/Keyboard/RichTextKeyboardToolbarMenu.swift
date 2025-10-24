//
//  KeyboardToolbarMenu.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-13.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if iOS || os(visionOS)
import SwiftUI

/// This menu can be used to fix a UI glitch that can appear in a `Menu` when it
/// is presented in a keyboard toolbar.
///
/// The menu label can be incorrectly offset vertically, beyond the menu bounds.
/// This view fixes that problem.
public struct RichTextKeyboardToolbarMenu<Label: View, Content: View>: View {

    /// Create a keyboard toolbar menu.
    public init(
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.content = content
        self.label = label
    }

    private let content: () -> Content
    private let label: () -> Label

    public var body: some View {
        Menu {
            content()
        } label: {
            label().opacity(0)
        }
        .preferesMenuOrderFixed()
        .background(label())
    }
}

private extension Menu {

    @ViewBuilder
    func preferesMenuOrderFixed() -> some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            self.menuOrder(.fixed)
        } else {
            self
        }
    }
}

#Preview {

    @ViewBuilder
    func buttons() -> some View {
        Button("1") {}
        Button("2") {}
        Button("3") {}
    }

    return RichTextKeyboardToolbarMenu {
        Section("Title") {
            buttons()
        }
        Section {
            ControlGroup {
                buttons()
            }
        }
    } label: {
        Label("Menu", systemImage: "ellipsis.circle")
    }
}
#endif
