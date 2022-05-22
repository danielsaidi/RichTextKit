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
     Get the attributed text in the text view.
     */
    var attributedString: NSAttributedString {
        get { super.attributedText ?? NSAttributedString(string: "") }
        set { attributedText = newValue }
    }
}
#endif
