//
//  RichTextPresenter.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-27.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented any types that can present
 a rich text and provide a selected range.

 The protocol extends the ``RichTextReader`` protocol with a
 selected range. This makes it possible to provide even more
 properties and features.
 */
public protocol RichTextPresenter: RichTextReader {
    
    /**
     Get the currently selected range.
     */
    var selectedRange: NSRange { get }
}

public extension RichTextPresenter {

    /**
     Get whether or not the presenter has a selected range.
     */
    var hasSelectedRange: Bool {
        selectedRange.length > 0
    }

    /**
     Whether or not the rich text contains any trimmed text.
     */
    var hasTrimmedText: Bool {
        let string = richText.string
        let trimmed = string.trimmingCharacters(in: .whitespaces)
        return !trimmed.isEmpty
    }
    
    /**
     Get the range after the input cursor.
     */
    var rangeAfterInputCursor: NSRange {
        let location = selectedRange.location
        let length = richText.length - location
        return NSRange(location: location, length: length)
    }
    
    /**
     Get the range before the input cursor.
     */
    var rangeBeforeInputCursor: NSRange {
        let location = selectedRange.location
        return NSRange(location: 0, length: location)
    }

    /**
     Get the rich text after the input cursor.
     */
    var richTextAfterInputCursor: NSAttributedString {
        richText(at: rangeAfterInputCursor)
    }

    /**
     Get the rich text before the input cursor.
     */
    var richTextBeforeInputCursor: NSAttributedString {
        richText(at: rangeBeforeInputCursor)
    }
}
