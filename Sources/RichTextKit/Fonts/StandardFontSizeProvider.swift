//
//  CFGloat+RichText.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import CoreGraphics

/// This protocol can be implemented by any type that should be able to provide a
/// standard rich text font size.
///
/// This protocol is implemented by native types like `CGFloat`, `Double`, as
/// well as library types like ``RichTextContext``, ``RichTextEditor``,
/// and ``RichTextView``. All can use the ``standardRichTextFontSize``
/// property to set the standard rich text font size.
public protocol StandardFontSizeProvider {}

extension CGFloat: StandardFontSizeProvider {}

extension Double: StandardFontSizeProvider {}

extension RichTextContext: StandardFontSizeProvider {}

#if iOS || macOS || os(tvOS) || os(visionOS)
extension RichTextEditor: StandardFontSizeProvider {}

extension RichTextView: StandardFontSizeProvider {}
#endif

public extension StandardFontSizeProvider {

    /// The standard font size to use for rich text.
    static var standardRichTextFontSize: CGFloat {
        get { StandardFontSizeProviderStorage.shared.richTextFontSize }
        set { StandardFontSizeProviderStorage.shared.richTextFontSize = newValue }
    }
}

private class StandardFontSizeProviderStorage: @unchecked Sendable {

    private init() {}

    static let shared = StandardFontSizeProviderStorage()

    var richTextFontSize: CGFloat = 16
}
