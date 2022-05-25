//
//  RichTextView_AppKit+RichTextViewRepresentable.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-12.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(macOS)
import AppKit

extension RichTextView: RichTextViewRepresentable {}

public extension RichTextView {

    /**
     The text view's attributed text.
     */
    var attributedString: NSAttributedString {
        get { attributedString() }
        set { textStorage?.setAttributedString(newValue) }
    }

    /**
     The text view's mutable attributed string, if any.
     */
    var mutableAttributedString: NSMutableAttributedString? {
        textStorage
    }
}
#endif
