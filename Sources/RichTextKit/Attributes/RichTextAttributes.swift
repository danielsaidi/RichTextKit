//
//  RichTextAttributes.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This typealias represents a dictionary that with attributed
 string keys as keys and `Any` as value.

 The typealias also defines additional functionality as type
 extensions for the platform-specific types.
 */
public typealias RichTextAttributes = [RichTextAttribute: Any]

public extension RichTextAttributes {

    /**
     Get or set whether or not the attributes contains a
     value that indicates that underline is active.
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
