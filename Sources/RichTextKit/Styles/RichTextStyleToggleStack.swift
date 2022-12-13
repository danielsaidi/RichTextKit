//
//  RichTextStyleToggleStack.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This view can be used to list a collection of toggles for a
 set of ``RichTextStyle`` values in a horizontal line.

 See the ``RichTextStyleToggle`` for more information on the
 toggle views that are rendered by this view. Since the view
 controls multiple values, it uses a ``RichTextContext`` and
 not individual values.
 */
public struct RichTextStyleToggleStack: View {

    /**
     Create a rich text style toggle button group.

     - Parameters:
       - context: The context to affect.
       - styles: The styles to list, by default ``RichTextStyle/all``.
       - buttonStyle: The button style to use, by default ``RichTextStyleToggle/Style/standard``.
     */
    public init(
        context: RichTextContext,
        styles: [RichTextStyle] = .all,
        buttonStyle: RichTextStyleToggle.Style = .standard
    ) {
        self._context = ObservedObject(wrappedValue: context)
        self.styles = styles
        self.buttonStyle = buttonStyle
    }

    private let styles: [RichTextStyle]
    private let buttonStyle: RichTextStyleToggle.Style

    @ObservedObject
    private var context: RichTextContext

    public var body: some View {
        HStack(spacing: 5) {
            ForEach(styles) {
                RichTextStyleToggle(
                    style: $0,
                    buttonStyle: buttonStyle,
                    context: context,
                    fillVertically: true
                )
            }
        }.fixedSize(horizontal: false, vertical: true)
    }
}

struct RichTextStyleToggleStack_Previews: PreviewProvider {

    struct Preview: View {

        @StateObject
        private var context = RichTextContext()

        var body: some View {
            RichTextStyleToggleStack(context: context)
                .padding()
        }
    }

    static var previews: some View {
        Preview()
    }
}
