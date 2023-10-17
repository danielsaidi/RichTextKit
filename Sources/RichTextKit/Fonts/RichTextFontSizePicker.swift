//
//  RichTextFontSizePicker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This size picker uses a plain `Picker` to list the provided
 font sizes, of which one can be selected.

 Since this view uses a plain `Picker`, you can apply any of
 the native picker styles to this picker as well.

 The picker will also add the current selection to the sizes
 in the list, since a text can have sizes that aren't in the
 available option set.
 */
public struct RichTextFontSizePicker: View {

    /**
     Create a font size picker.

     - Parameters:
       - selection: The selected font size.
       - sizes: The sizes to display in the list, by default ``RichTextFontSizePicker/standardFontSizes``.
     */
    public init(
        selection: Binding<CGFloat>,
        values: [CGFloat] = standardFontSizes
    ) {
        self._selection = selection
        self.values = Self.fontSizePickerSizes(
            for: values,
            selection: selection.wrappedValue)
    }

    private let values: [CGFloat]

    @Binding
    private var selection: CGFloat

    public var body: some View {
        Picker(selection: $selection) {
            ForEach(values, id: \.self) {
                text(for: $0).tag($0)
            }
        } label: {
            EmptyView()
        }
        .labelsHidden()
        .accessibilityLabel(RTKL10n.fontSize.text)
    }
}

public extension RichTextFontSizePicker {

    /// The default font sizes to list in a font size picker.
    static var standardFontSizes: [CGFloat] {
        [10, 12, 14, 18, 20, 22, 24, 28, 36, 48, 64, 72, 96, 144]
    }

    /// Get a list of sizes for a certain selection.
    static func fontSizePickerSizes(
        for sizes: [CGFloat],
        selection: CGFloat) -> [CGFloat] {
        let sizes = sizes + [selection]
        return Array(Set(sizes)).sorted()
    }
}

private extension RichTextFontSizePicker {

    /// Get the text to display for a certain font size.
    func text(for fontSize: CGFloat) -> some View {
        Text("\(Int(fontSize))")
            .fixedSize(horizontal: true, vertical: false)
    }
}

struct RichTextFontSizePicker_Previews: PreviewProvider {

    struct Preview: View {

        @State
        private var selection: CGFloat = 36.0

        var body: some View {
            RichTextFontSizePicker(selection: $selection)
        }
    }

    static var previews: some View {
        Preview()
    }
}
