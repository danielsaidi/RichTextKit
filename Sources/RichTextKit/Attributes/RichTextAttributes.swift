//
//  RichTextAttributes.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This typealias represents a ``RichTextAttribute`` keyed and
 `Any` valued dictionary.

 The typealias also defines additional functionality as type
 extensions for the platform-specific types.
 */
public typealias RichTextAttributes = [RichTextAttribute: Any]

public extension RichTextAttributes {

    /**
     Whether or not the attributes has a strikethrough style.
     */
    var isStrikethrough: Bool {
        get {
            self[.strikethroughStyle] as? Int == 1
        }
        set {
            self[.strikethroughStyle] = newValue ? 1 : 0
        }
    }

    /**
     Whether or not the attributes has an underline style.
     */
    var isUnderlined: Bool {
        get {
            self[.underlineStyle] as? Int == 1
        }
        set {
            self[.underlineStyle] = newValue ? 1 : 0
        }
    }
}
