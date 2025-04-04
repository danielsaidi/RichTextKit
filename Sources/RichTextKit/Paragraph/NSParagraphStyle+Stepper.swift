//
//  NSParagraphStyle+Stepper.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2025-04-04.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension KeyPath where Root == NSParagraphStyle {
    
    /// Get the default stepper interval for the key path.
    var defaultStepperInterval: Value? {
        switch self {
        case \.defaultTabInterval: 0.1 as? Value
        case \.firstLineHeadIndent: 1 as? Value
        case \.headIndent: 1 as? Value
        case \.hyphenationFactor: 0.1 as? Value
        case \.lineHeightMultiple: 0.1 as? Value
        case \.lineSpacing: 0.1 as? Value
        case \.maximumLineHeight: 0.1 as? Value
        case \.minimumLineHeight: 0.1 as? Value
        case \.paragraphSpacing: 1 as? Value
        case \.paragraphSpacingBefore: 1 as? Value
        case \.tailIndent: 0.1 as? Value
        default: nil
        }
    }
}
