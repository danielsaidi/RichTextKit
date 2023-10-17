//
//  RichTextContextFocusedValueKey.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-19.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This key can be used to keep track of the currently focused
 ``RichTextContext`` instance in a multi-window app.
 */
public struct RichTextContextFocusedValueKey: FocusedValueKey {
    
    public typealias Value = RichTextContext
}

public extension FocusedValues {

    /**
     This value can be used to bind a rich text context to a
     SwiftUI view, using a `focusedValue` view modifier:

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
     */
    var richTextContext: RichTextContextFocusedValueKey.Value? {
        get { self[RichTextContextFocusedValueKey.self] }
        set { self[RichTextContextFocusedValueKey.self] = newValue }
    }
}
