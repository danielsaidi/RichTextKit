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
       - greedy: Whether or not the group is horizontally greedy, by default `true`.
       - buttonStyle: The button style to use, by default ``RichTextStyleToggle/Style/standard``.
     */
    public init(
        context: RichTextContext,
        styles: [RichTextStyle] = .all,
        greedy: Bool = true,
        buttonStyle: RichTextStyleButton.Style = .standard
    ) {
        self._context = ObservedObject(wrappedValue: context)
        self.isGreedy = greedy
        self.styles = styles
        self.buttonStyle = buttonStyle
    }

    private let styles: [RichTextStyle]
    private let isGreedy: Bool
    private let buttonStyle: RichTextStyleButton.Style

    private var groupWidth: CGFloat? {
        if isGreedy { return nil }
        let count = Double(styles.count)
        #if os(macOS)
        return 30 * count
        #else
        return 50 * count
        #endif
    }

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
        }.frame(width: groupWidth)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct RichTextStyleToggleGroup_Previews: PreviewProvider {

    struct Preview: View {

        @StateObject
        private var context = RichTextContext()

        func group(greedy: Bool) -> some View {
            RichTextStyleToggleGroup(
                context: context,
                greedy: greedy
            )
        }

        var body: some View {
            VStack {
                group(greedy: true)
                group(greedy: false)
            }.padding()

        }
    }

    static var previews: some View {
        Preview()
    }
}
#endif
