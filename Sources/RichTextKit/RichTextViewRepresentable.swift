//
//  RichTextViewRepresentable.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol defines a platform-agnostic api that's shared
 by the UIKit and AppKit implementation of ``RichTextView``.

 By implementing and using this protocol in the library, the
 library doesn't have to do a bunch of `#if` checks.

 This protocol aggregates many other protocols, although the
 protocols often implement eachother. To show every protocol,
 some are commented out in the list below.
 */
public protocol RichTextViewRepresentable:
    AnyObject,
    RichTextPresenter,
    // RichTextAttributeReader,
    // RichTextAttributeWriter,
    RichTextAlignmentReader,
    RichTextAlignmentWriter,
    RichTextColorReader,
    RichTextColorWriter,
    RichTextDataReader,
    RichTextDataWriter,
    // RichTextFontReader,
    // RichTextFontWriter,
    // RichTextStyleReader,
    RichTextStyleWriter
{

    /**
     The style to use when highlighting text in the view.
     */
    var highlightingStyle: RichTextHighlightingStyle { get set }

    /**
     Whether or not the text view is the first responder.
     */
    var isFirstResponder: Bool { get }

    /**
     The text view's mutable attributed string, if any.
     */
    var mutableAttributedString: NSMutableAttributedString? { get }

    /**
     The text view current typing attributes.
     */
    var typingAttributes: RichTextAttributes { get set }


    /**
     Setup the rich text view with a rich text and a certain
     data format.
     */
    func setup(
        with text: NSAttributedString,
        format: RichTextDataFormat)
}

internal extension RichTextViewRepresentable {

    /**
     This setup function can be called by all implemetations,
     to setup the initial font size for a text.
     */
    func setupInitialFontSize(for text: NSAttributedString) {
        let fontSize = FontRepresentable.standardRichTextFont.pointSize
        setFontSize(to: fontSize, at: NSRange(location: 0, length: text.length))
        setCurrentFontSize(to: FontRepresentable.standardRichTextFont.pointSize)
    }
}
