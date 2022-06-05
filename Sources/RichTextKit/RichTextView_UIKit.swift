//
//  RichTextView_UIKit.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-12.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit

/**
 This view inhertits and extends `NSTextField` in AppKit and
 `UITextField` in UIKit.
 */
public class RichTextView: UITextView, RichTextViewRepresentable {

    /**
     The style to use when highlighting text in the view.
     */
    public var highlightingStyle: RichTextHighlightingStyle = .standard
}


// MARK: - Public Functions

public extension RichTextView {

    /**
     Setup the rich text view with a rich text and a certain
     data format.

     We should later make all these configurations easier to
     customize.
     */
    func setup(
        with text: NSAttributedString,
        format: RichTextDataFormat
    ) {
        attributedString = text
        allowsEditingTextAttributes = false
        autocapitalizationType = .sentences
        backgroundColor = .clear
        // TODO: imageConfiguration = imageConfig ?? imageConfiguration
        // TODO: text.autosizeImageAttachments(maxSize: imageAttachmentMaxSize)
        spellCheckingType = .no
        textColor = .label
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        setupInitialFontSize(for: text)
    }
}


// MARK: - RichTextProvider

extension RichTextView {

    /**
     Get the rich text that is managed by the text view.
     */
    public var attributedString: NSAttributedString {
        get { super.attributedText ?? NSAttributedString(string: "") }
        set { attributedText = newValue }
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
