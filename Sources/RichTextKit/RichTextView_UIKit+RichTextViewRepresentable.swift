//
//  RichTextView_UIKit+RichTextViewRepresentable.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-12.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit

extension RichTextView: RichTextViewRepresentable {}

public extension RichTextView {

    /**
     The text view's attributed string.
     */
    var attributedString: NSAttributedString {
        get { super.attributedText ?? NSAttributedString(string: "") }
        set { attributedText = newValue }
    }

    /**
     The text view's mutable attributed string, if any.
     */
    var mutableAttributedString: NSMutableAttributedString? {
        textStorage
    }
}
#endif
