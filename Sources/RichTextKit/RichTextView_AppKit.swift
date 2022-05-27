//
//  RichTextView_AppKit.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-12.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(macOS)
import AppKit

/**
 This view inhertits and extends `NSTextField` in AppKit and
 `UITextField` in UIKit.
 */
public class RichTextView: NSTextView, RichTextReader, RichTextWriter {
}


// MARK: - RichTextProvider

public extension RichTextView {

    /**
     Get the rich text that is managed by the view.
     */
    var attributedString: NSAttributedString {
        get { attributedString() }
        set { textStorage?.setAttributedString(newValue) }
    }
}


// MARK: - RichTextWriter

public extension RichTextView {

    /**
     Get the mutable rich text that is managed by the view.
     */
    var mutableAttributedString: NSMutableAttributedString? {
        textStorage
    }
}
#endif
