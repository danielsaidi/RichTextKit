//
//  RichTextWriter.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-27.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented any types that can provide
 a writable rich text string.

 This protocol is implemented by `NSMutableAttributedString`
 as well as other library types.
 */
public protocol RichTextWriter: RichTextReader {

    /**
     Get the writable attributed string provided by the type.
     */
    var mutableAttributedString: NSMutableAttributedString? { get }
}

extension NSMutableAttributedString: RichTextWriter {

    /**
     This type returns itself as mutable attributed string.
     */
    public var mutableAttributedString: NSMutableAttributedString? {
        self
    }
}

public extension RichTextWriter {

    /**
     Get the writable rich text provided by the implementing
     type.

     This is an alias for ``mutableAttributedString`` and is
     used to get a property that uses the rich text naming.
     */
    var mutableRichText: NSMutableAttributedString? {
        mutableAttributedString
    }

    /**
     Replace the text in a certain range with a new string.

     - Parameters:
       - range: The range to replace text in.
       - string: The string to replace the current text with.
     */
    func replaceText(in range: NSRange, with string: String) {
        mutableRichText?.replaceCharacters(in: range, with: string)
    }

    /**
     Replace the text in a certain range with a new string.

     - Parameters:
       - range: The range to replace text in.
       - string: The string to replace the current text with.
     */
    func replaceText(in range: NSRange, with string: NSAttributedString) {
        mutableRichText?.replaceCharacters(in: range, with: string)
    }
}
