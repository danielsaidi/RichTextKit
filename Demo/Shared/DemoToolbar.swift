//
//  DemoToolbar.swift
//  Demo
//
//  Created by Daniel Saidi on 2022-06-06.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import RichTextKit
import SwiftUI

protocol DemoToolbar: View {

    var context: RichTextContext { get }
}

extension DemoToolbar {

    var actionButtons: some View {
        HStack {
            button(icon: .richTextActionCopy, action: context.copyCurrentSelection)
                .disabled(!context.canCopy)
            button(icon: .richTextActionUndo, action: context.undoLatestChange)
                .disabled(!context.canUndoLatestChange)
            button(icon: .richTextActionRedo, action: context.redoLatestChange)
                .disabled(!context.canRedoLatestChange)
        }
    }

    func alignmentPicker(for alignment: Binding<RichTextAlignment>) -> some View {
        RichTextAlignmentPicker(selection: alignment)
            .pickerStyle(.segmented)
            .labelsHidden()
    }

    var colorPickers: some View {
        HStack {
            ColorPicker("", selection: context.backgroundColorBinding)
            ColorPicker("", selection: context.foregroundColorBinding)
        }.labelsHidden()
    }

    var divider: some View {
        Divider().frame(height: 10)
    }

    func fontPicker(for font: Binding<String>) -> some View {
        FontPicker(selection: font, fontSize: 12)
    }

    func sizeTools(for size: Binding<CGFloat>) -> some View {
        HStack(spacing: sizeToolSpacing) {
            button(icon: .minus) {
                context.decrementFontSize()
            }
            FontSizePicker(selection: size)
                .labelsHidden()
            button(icon: .plus) {
                context.incrementFontSize()
            }
        }
    }

    var sizeToolSpacing: CGFloat {
        #if os(macOS)
        return 5
        #else
        return 0
        #endif
    }

    var styleButtons: some View {
        HStack(spacing: 5) {
            button(forStyle: .bold)
            button(forStyle: .italic)
            button(forStyle: .underlined)
        }
    }
}

private extension DemoToolbar {

    func button(
        icon: Image,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            icon.frame(height: 17)
        }
        #if os(macOS)
        .buttonStyle(.borderedProminent)
        #else
        .buttonStyle(.bordered)
        #endif
    }

    func button(forStyle style: RichTextStyle) -> some View {
        button(icon: style.icon) {
            context.toggle(style)
        }.highlighted(if: context.hasStyle(style))
    }
}

private extension View {

    func highlighted(if condition: Bool) -> some View {
        self.tint(condition ? .blue : .primary)
    }
}
