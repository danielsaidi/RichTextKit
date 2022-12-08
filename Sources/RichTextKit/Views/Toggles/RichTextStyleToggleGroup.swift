//
//  RichTextStyleToggleGroup.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This view can be used to list ``RichTextStyleToggle`` views
 for all available styles.
 */
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 9.0, *)
public struct RichTextStyleToggleGroup: View {

    /**
     Create a rich text style button.

     - Parameters:
     - styles: The styles to list, by default all.
     - buttonStyle: The button style to use, by default ``RichTextStyleToggle/Style/standard``.
     - context: The context to affect.
     */
    public init(
        styles: [RichTextStyle] = RichTextStyle.allCases,
        buttonStyle: RichTextStyleToggle.Style = .standard,
        context: RichTextContext
    ) {
        self.styles = styles
        self.buttonStyle = buttonStyle
        self._context = ObservedObject(wrappedValue: context)
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
                    context: context
                )
            }
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 9.0, *)
struct RichTextStyleToggleGroup_Previews: PreviewProvider {

    struct Preview: View {

        @StateObject
        private var context = RichTextContext()

        var body: some View {
            RichTextStyleToggleGroup(context: context)
                .padding()
        }
    }

    static var previews: some View {
        Preview()
    }
}
