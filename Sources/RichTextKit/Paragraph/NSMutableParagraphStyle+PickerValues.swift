//
//  NSMutableParagraphStyle+PickerValues.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2025-04-04.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension KeyPath where Root == NSMutableParagraphStyle {

    /// Get default picker values for the key path.
    var defaultPickerValues: [Value]? {
        switch self {
        case \.alignment: NSTextAlignment.defaultPickerValues as? [Value]
        case \.allowsDefaultTighteningForTruncation: [true, false] as? [Value]
        case \.baseWritingDirection: NSWritingDirection.defaultPickerValues as? [Value]
        case \.defaultTabInterval: [28.0, 36, 72, 144] as? [Value]
        case \.firstLineHeadIndent: [0.0, 10, 20, 30, 40, 50] as? [Value]
        case \.headIndent: [0.0, 10, 20, 30, 40, 50] as? [Value]
        case \.hyphenationFactor: [0.0, 0.5, 1.0] as? [Value]
        case \.lineBreakMode: NSLineBreakMode.defaultPickerValues as? [Value]
        case \.lineBreakStrategy: NSParagraphStyle.LineBreakStrategy.defaultPickerValues as? [Value]
        case \.lineHeightMultiple: [1.0, 1.1, 1.2, 1.5, 2.0] as? [Value]
        case \.lineSpacing: [0.0, 2, 4, 6, 8, 10] as? [Value]
        case \.maximumLineHeight: [0.0, 20, 24, 28, 32, 36] as? [Value]
        case \.minimumLineHeight: [0.0, 16, 18, 20, 22, 24] as? [Value]
        case \.paragraphSpacing: [0.0, 4, 8, 12, 16, 20] as? [Value]
        case \.paragraphSpacingBefore: [0.0, 4, 8, 12, 16, 20] as? [Value]
        case \.tabStops: [[]] as? [Value] // Usually customized based on document needs
        case \.tailIndent: [0.0, 10, 20, 30, 40, 50] as? [Value]
        case \.usesDefaultHyphenation: [true, false] as? [Value]
        default: [] as? [Value]
        }
    }
}

public extension NSLineBreakMode {

    /// Get the default picker values.
    static var defaultPickerValues: [Self] {
        .defaultPickerValues
    }
}

public extension Collection where Element == NSLineBreakMode {

    /// Get the default picker values.
    static var defaultPickerValues: [Element] {
        [.byWordWrapping, .byCharWrapping, .byClipping, .byTruncatingHead, .byTruncatingTail, .byTruncatingMiddle]
    }
}

public extension NSParagraphStyle.LineBreakStrategy {

    /// Get the default picker values.
    static var defaultPickerValues: [Self] {
        .defaultPickerValues
    }
}

public extension Collection where Element == NSParagraphStyle.LineBreakStrategy {

    /// Get the default picker values.
    static var defaultPickerValues: [Element] {
        [.standard, .pushOut, .hangulWordPriority]
    }
}

public extension NSTextAlignment {

    /// Get the default picker values.
    static var defaultPickerValues: [Self] {
        .defaultPickerValues
    }
}

public extension Collection where Element == NSTextAlignment {

    /// Get the default picker values.
    static var defaultPickerValues: [Element] {
        [.left, .center, .right, .justified]
    }
}

public extension NSWritingDirection {

    /// Get the default picker values.
    static var defaultPickerValues: [Self] {
        .defaultPickerValues
    }
}

public extension Collection where Element == NSWritingDirection {

    /// Get the default picker values.
    static var defaultPickerValues: [Element] {
        [.leftToRight, .rightToLeft]
    }
}
