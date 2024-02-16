//
//  RichTextContextFocusedValueKey.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-19.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This key can be used to keep track of the currently focused
 ``RichTextContext`` in a multi-window app.
 */
public struct RichTextContextFocusedValueKey: FocusedValueKey {

    public typealias Value = RichTextContext
}

public extension FocusedValues {

    /**
     This value can be used to bind a rich text context to a
     view, using the `focusedValue` view modifier:

     ```swift
     RichTextEditor(...)
        .focusedValue(\.richTextContext, richTextContext)
     ```

     You can then access the currently focused context using
     the `@FocusedValue` property wrapper:

     ```swift
     @FocusedValue(\.richTextContext)
     var richTextContext: RichTextContext?
     ```

     This is needed for e.g. main menu commands to determine
     which context to affect, if any.
     */
    var richTextContext: RichTextContextFocusedValueKey.Value? {
        get { self[RichTextContextFocusedValueKey.self] }
        set { self[RichTextContextFocusedValueKey.self] = newValue }
    }
}
