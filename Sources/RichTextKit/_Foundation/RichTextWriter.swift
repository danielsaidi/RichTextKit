//
//  RichTextWriter.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-27.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

/// This protocol can be implemented by any type with a mutable attributed string.
public protocol RichTextWriter: RichTextReader {

    /// The mutable attributed string.
    var mutableAttributedString: NSMutableAttributedString? { get }
}

extension NSMutableAttributedString: RichTextWriter {

    /// This type returns itself as the attributed string.
    public var mutableAttributedString: NSMutableAttributedString? {
        self
    }
}

public extension RichTextWriter {

    /// The mutable rich text.
    ///
    /// This is a name alias for ``mutableAttributedString``.
    var mutableRichText: NSMutableAttributedString? {
        mutableAttributedString
    }

    /// Replace the text in a certain range.
    ///
    /// - Parameters:
    ///   - range: The range to replace text in.
    ///   - string: The string to replace the current text with.
    func replaceText(
        in range: NSRange,
        with string: String
    ) {
        mutableRichText?.replaceCharacters(
            in: range,
            with: string
        )
    }

    /// Replace the text in a certain range.
    ///
    /// - Parameters:
    ///   - range: The range to replace text in.
    ///   - string: The string to replace the current text with.
    func replaceText(
        in range: NSRange,
        with string: NSAttributedString
    ) {
        mutableRichText?.replaceCharacters(
            in: range,
            with: string
        )
    }
}
