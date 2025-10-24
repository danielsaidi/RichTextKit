//
//  RichTextContextFocusedValueKey.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-19.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextContext {

    /// This key can be used to keep track of a context in a multi-windowed app.
    struct FocusedValueKey: SwiftUI.FocusedValueKey {

        public typealias Value = RichTextContext
    }
}

public extension FocusedValues {

    /// This value can be used to keep track of a context in a multi-windowed app.
    ///
    /// You can bind a context to a view with `focusedValue`:
    ///
    /// ```swift
    /// RichTextEditor(...)
    ///     .focusedValue(\.richTextContext, richTextContext)
    /// ```
    ///
    /// You can then access the context as a `@FocusedValue`:
    ///
    /// ```swift
    /// @FocusedValue(\.richTextContext)
    /// var richTextContext: RichTextContext?
    /// ```
    var richTextContext: RichTextContext.FocusedValueKey.Value? {
        get { self[RichTextContext.FocusedValueKey.self] }
        set { self[RichTextContext.FocusedValueKey.self] = newValue }
    }
}
