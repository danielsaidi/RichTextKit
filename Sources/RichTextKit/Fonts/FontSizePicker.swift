//
//  FontSizePicker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
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
public struct FontSizePicker: View {

    /**
     Create a font picker.

     - Parameters:
       - selection: The selected font size.
       - sizes: The sizes to display in the list, by default ``FontSizePicker/standardFontSizes``.
       - fontSize: The font size to use in the list items.
     */
    public init(
        selection: Binding<CGFloat>,
        sizes: [CGFloat] = standardFontSizes
    ) {
        self._selection = selection
        self.sizes = Self.fontSizePickerSizes(
            for: sizes,
            selection: selection.wrappedValue)
    }

    private let sizes: [CGFloat]

    @Binding
    private var selection: CGFloat

    public var body: some View {
        Picker(selection: $selection) {
            ForEach(sizes, id: \.self) {
                text(for: $0)
                    .tag($0)
            }
        } label: {
            EmptyView()
        }
    }
}

public extension FontSizePicker {

    /**
     The default font sizes to list in a font size picker.
     */
    static var standardFontSizes: [CGFloat] {
        [10, 12, 14, 18, 20, 22, 24, 28, 36, 48, 64, 72, 96, 144]
    }

    /**
     Get a list of sizes for a certain selection.
     */
    static func fontSizePickerSizes(
        for sizes: [CGFloat],
        selection: CGFloat) -> [CGFloat] {
        let sizes = sizes + [selection]
        return Array(Set(sizes)).sorted()
    }
}

private extension FontSizePicker {

    /**
     Get the text to display for a certain font size.
     */
    func text(for fontSize: CGFloat) -> some View {
        Text("\(Int(fontSize))")
            .fixedSize(horizontal: true, vertical: false)
    }
}
