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
public class RichTextView: NSTextView {
}


// MARK: - RichTextProvider

extension RichTextView: RichTextProvider {

    /**
     Get the rich text that is managed by the text view.
     */
    public var attributedString: NSAttributedString {
        get { attributedString() }
        set { textStorage?.setAttributedString(newValue) }
    }
}
#endif
