//
//  RichTextStyleToggleGroup.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2023-06-01.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(macOS)
import SwiftUI

/**
 This view can be used to list a collection of toggles for a
 set of ``RichTextStyle`` values in a bordered button group.

 See the ``RichTextStyleToggle`` for more information on the
 toggle views that are rendered by this view.

 Since this view controls multiple styles, it binds directly
 to a ``RichTextContext`` instead of individual values.
 */
@available(iOS 15.0, macOS 12.0, *)
public struct RichTextStyleToggleGroup: View {

    /**
     Create a rich text style toggle button group.

     - Parameters:
       - context: The context to affect.
       - styles: The styles to list, by default ``RichTextStyle/all``.
       - buttonStyle: The button style to use, by default ``RichTextStyleToggle/Style/standardNonProminent``.
       - greedy: Whether or not the group is horizontally greedy, by default `false`.
     */
    public init(
        context: RichTextContext,
        styles: [RichTextStyle] = .all,
        buttonStyle: RichTextStyleButton.Style = .standard,
        greedy: Bool = false
    ) {
        self._context = ObservedObject(wrappedValue: context)
        self.styles = styles
        self.buttonStyle = buttonStyle
        self.isGreedy = greedy
    }

    private let styles: [RichTextStyle]
    private let buttonStyle: RichTextStyleButton.Style
    private let isGreedy: Bool

    @ObservedObject
    private var context: RichTextContext

    public var body: some View {
        ControlGroup {
            ForEach(styles) {
                RichTextStyleButton(
                    style: $0,
                    buttonStyle: buttonStyle,
                    context: context,
                    fillVertically: true
                )
            }
        }.frame(width: isGreedy ? nil : (50.0 * Double(styles.count)))
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
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
#endif
