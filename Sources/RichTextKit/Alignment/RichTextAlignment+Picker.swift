//
//  RichTextAlignment+Picker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextAlignment {
 
    /**
     This picker can be used to pick rich text alignments.

     The view returns a plain SwiftUI `Picker` view that can
     be styled and configured with plain SwiftUI.
     */
    struct Picker: View {

        /**
         Create a rich text alignment picker.

         - Parameters:
           - selection: The binding to update with the picker.
           - style: The style to apply, by default `.standard`.
           - values: The pickable alignments, by default `.allCases`.
         */
        public init(
            selection: Binding<RichTextAlignment>,
            style: Style = .standard,
            values: [RichTextAlignment] = RichTextAlignment.allCases
        ) {
            self._selection = selection
            self.style = style
            self.values = values
        }

        let style: Style
        let values: [RichTextAlignment]

        @Binding
        private var selection: RichTextAlignment

        public var body: some View {
            SwiftUI.Picker("", selection: $selection) {
                ForEach(RichTextAlignment.allCases) { value in
                    value.icon
                        .foregroundColor(style.iconColor)
                        .accessibilityLabel(value.title)
                        .tag(value)
                }
            }
            .accessibilityLabel(RTKL10n.textAlignment.text)
        }
    }
}

public extension RichTextAlignment.Picker {
    
    /// This style can be used to style an alignment picker.
    struct Style {
        
        public init(
            iconColor: Color = .primary
        ) {
            self.iconColor = iconColor
        }
        
        public var iconColor: Color
    }
}

public extension RichTextAlignment.Picker.Style {
    
    static var standard = Self.init()
}

struct RichTextAlignment_Picker_Previews: PreviewProvider {

    struct Preview: View {

        @State
        private var alignment = RichTextAlignment.left

        var body: some View {
            RichTextAlignment.Picker(
                selection: $alignment,
                values: .all
            )
        }
    }

    static var previews: some View {
        Preview()
    }
}
