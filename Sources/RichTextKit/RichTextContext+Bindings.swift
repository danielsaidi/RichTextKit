//
//  RichTextContext+Bindings.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextContext {


    // MARK: - Colors

    /// A ``RichTextContext/backgroundColor`` binding.
    var backgroundColorBinding: Binding<Color> {
        Binding(
            get: { Color(self.backgroundColor ?? .clear) },
            set: { self.backgroundColor = ColorRepresentable($0) }
        )
    }


    /// A ``RichTextContext/foregroundColor`` binding.
    var foregroundColorBinding: Binding<Color> {
        Binding(
            get: { Color(self.foregroundColor ?? .clear) },
            set: { self.foregroundColor = ColorRepresentable($0) }
        )
    }


    // MARK: - Styles

    /// A ``RichTextContext/isBold`` binding.
    var isBoldBinding: Binding<Bool> {
        Binding(
            get: { self.isBold },
            set: { self.isBold = $0 }
        )
    }

    /// A ``RichTextContext/isItalic`` binding.
    var isItalicBinding: Binding<Bool> {
        Binding(
            get: { self.isItalic },
            set: { self.isItalic = $0 }
        )
    }

    /// A ``RichTextContext/isUnderlined`` binding.
    var isUnderlinedBinding: Binding<Bool> {
        Binding(
            get: { self.isUnderlined },
            set: { self.isUnderlined = $0 }
        )
    }
}
