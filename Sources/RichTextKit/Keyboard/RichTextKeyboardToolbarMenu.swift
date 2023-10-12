//
//  KeyboardToolbarMenu.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-13.
//  Copyright © 2022 Dnaiel Saidi. All rights reserved.
//

#if os(iOS)
import SwiftUI

/**
 This keyboard toolbar menu can be used to solve a UI glitch
 that can appear when adding a `Menu` to a keyboard toolbar.

 The glitch is that the menu label can be incorrectly offset
 vertically, beyound the bounds of the menu. If that happens,
 use this view to ensure that it's correctly positioned.
 */
public struct RichTextKeyboardToolbarMenu<Label: View, Content: View>: View {

    /**
     Create a keyboard toolbar menu.
     */
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

struct RichTextKeyboardToolbarMenu_Previews: PreviewProvider {

    @ViewBuilder
    static var buttons: some View {
        Button("1") {}
        Button("2") {}
        Button("3") {}
    }

    static var previews: some View {
        RichTextKeyboardToolbarMenu {
            Section("Title") {
                buttons
            }
            Section {
                ControlGroup {
                    buttons
                }
            }
        } label: {
            Label("Menu", systemImage: "ellipsis.circle")
        }
    }
}
#endif
