//
//  NSParagraphStyle+Picker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2025-04-04.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension Array {
    
    /// Get default picker values for a certain key path.
    static func defaultPickerValues<Value>(
        for keyPath: KeyPath<NSParagraphStyle, Value>
    ) -> [Value]? {
        switch keyPath {
        case \.alignment: NSTextAlignment.defaultPickerValues as? [Value]
        case \.allowsDefaultTighteningForTruncation: [true, false] as? [Value]
        case \.baseWritingDirection: NSWritingDirection.defaultPickerValues as? [Value]
        case \.defaultTabInterval: [28.0, 36.0, 72.0, 144.0] as? [Value]
        case \.firstLineHeadIndent: [0.0, 10.0, 20.0, 30.0, 40.0, 50.0] as? [Value]
        case \.headIndent: [0.0, 10.0, 20.0, 30.0, 40.0, 50.0] as? [Value]
        case \.hyphenationFactor: [0.0, 0.5, 1.0] as? [Value]
        case \.lineBreakMode: NSLineBreakMode.defaultPickerValues as? [Value]
        case \.lineBreakStrategy: NSParagraphStyle.LineBreakStrategy.defaultPickerValues as? [Value]
        case \.lineHeightMultiple: [1.0, 1.1, 1.2, 1.5, 2.0] as? [Value]
        case \.lineSpacing: [0.0, 2.0, 4.0, 6.0, 8.0, 10.0] as? [Value]
        case \.maximumLineHeight: [0.0, 20.0, 24.0, 28.0, 32.0, 36.0] as? [Value]
        case \.minimumLineHeight: [0.0, 16.0, 18.0, 20.0, 22.0, 24.0] as? [Value]
        case \.paragraphSpacing: [0.0, 4.0, 8.0, 12.0, 16.0, 20.0] as? [Value]
        case \.paragraphSpacingBefore: [0.0, 4.0, 8.0, 12.0, 16.0, 20.0] as? [Value]
        case \.tabStops: [[]] as? [Value] // Usually customized based on document needs
        case \.tailIndent: [0.0, 10.0, 20.0, 30.0, 40.0, 50.0] as? [Value]
        case \.usesDefaultHyphenation: [true, false] as? [Value]
        default: [] as? [Value]
        }
    }
}

public extension NSLineBreakMode {
    
    /// Get the default picker values.
    static var defaultPickerValues: [Self] {
        [Self.byWordWrapping, .byCharWrapping, .byClipping, .byTruncatingHead, .byTruncatingTail, .byTruncatingMiddle]
    }
}

public extension NSParagraphStyle.LineBreakStrategy {
    
    /// Get the default picker values.
    static var defaultPickerValues: [Self] {
        [Self.standard, .pushOut, .hangulWordPriority]
    }
}

public extension NSTextAlignment {
    
    /// Get the default picker values.
    static var defaultPickerValues: [Self] {
        [Self.left, .center, .right, .justified]
    }
}

public extension NSWritingDirection {
    
    /// Get the default picker values.
    static var defaultPickerValues: [Self] {
        [Self.leftToRight, .rightToLeft]
    }
}
