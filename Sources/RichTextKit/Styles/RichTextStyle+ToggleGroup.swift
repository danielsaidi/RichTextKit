//
//  RichTextStyle+ToggleGroup.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2023-06-01.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

public extension RichTextStyle {
    
    /**
     This view can list ``RichTextStyle/Toggle``s for a list
     of ``RichTextStyle`` values, in a bordered button group.
     
     Since this view uses multiple styles, it binds directly
     to a ``RichTextContext`` instead of individual values.
     */
    struct ToggleGroup: View {
        
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
            buttonStyle: RichTextStyle.Toggle.Style = .standard
        ) {
            self._context = ObservedObject(wrappedValue: context)
            self.isGreedy = greedy
            self.styles = styles
            self.buttonStyle = buttonStyle
        }
        
        private let styles: [RichTextStyle]
        private let isGreedy: Bool
        private let buttonStyle: RichTextStyle.Toggle.Style
        
        private var groupWidth: CGFloat? {
            if isGreedy { return nil }
            let count = Double(styles.count)
            #if macOS
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
                    RichTextStyle.Toggle(
                        style: $0,
                        buttonStyle: buttonStyle,
                        context: context,
                        fillVertically: true
                    )
                }
            }
            .frame(width: groupWidth)
        }
    }
}

struct RichTextStyle_ToggleGroup_Previews: PreviewProvider {

    struct Preview: View {

        @StateObject
        private var context = RichTextContext()

        func group(greedy: Bool) -> some View {
            RichTextStyle.ToggleGroup(
                context: context,
                greedy: greedy
            )
        }

        var body: some View {
            VStack {
                group(greedy: true)
                group(greedy: false)
            }
            .padding()
        }
    }

    static var previews: some View {
        Preview()
    }
}
#endif
