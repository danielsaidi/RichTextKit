//
//  RichTextViewComponent.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import CoreGraphics
import Foundation

/**
 This protocol defines a platform-agnostic api that's shared
 by the UIKit and AppKit ``RichTextView`` components.

 By implementing and using this protocol in the library, the
 library doesn't have to do a bunch of `#if` checks.

 This protocol aggregates many other protocols, although the
 protocols often implement each other. To show all protocols,
 some are commented out in the list below.
 */
public protocol RichTextViewComponent: AnyObject,
    RichTextPresenter,
    // RichTextAttributeReader,
    // RichTextAttributeWriter,
    RichTextAlignmentReader,
    RichTextAlignmentWriter,
    RichTextIndentReader,
    RichTextIndentWriter,
    RichTextColorReader,
    RichTextColorWriter,
    RichTextDataReader,
    // RichTextFontReader,
    // RichTextFontWriter,
    RichTextImageAttachmentManager,
    RichTextPdfDataReader,
    // RichTextStyleReader,
    RichTextStyleWriter
{
        
    /**
     The text view's frame.
     */
    var frame: CGRect { get }

    /**
     The style to use when highlighting text in the view.
     */
    var highlightingStyle: RichTextHighlightingStyle { get set }

    /**
     The image configuration used by the rich text view.
     */
    var imageConfiguration: RichTextImageConfiguration { get set }

    /**
     Whether or not the text view is the first responder.
     */
    var isFirstResponder: Bool { get }

    /**
     The text view's mutable attributed string, if any.
     */
    var mutableAttributedString: NSMutableAttributedString? { get }

    /**
     The spacing between the text view's edge and its text.
     */
    var textContentInset: CGSize { get set }

    /**
     The text view current typing attributes.
     */
    var typingAttributes: RichTextAttributes { get set }


    // MARK: - Setup

    /**
     Setup the view with text and a ``RichTextDataFormat``.

     - Parameters:
       - text: The text to edit with the text view.
       - format: The rich text format to use.
       - scrollingDisabled: Disables the scrolling in the NSTextView
     */
    func setup(
        with text: NSAttributedString,
        format: RichTextDataFormat,
        scrollingDisabled: Bool
    )


    // MARK: - Functions

    /**
     Alert a certain title and message.

     - Parameters:
       - title: The alert title.
       - message: The alert message.
       - buttonTitle: The alert button title.
     */
    func alert(title: String, message: String, buttonTitle: String)

    /**
     Copy the current selection.
     */
    func copySelection()

    /**
     Try to redo the latest undone change.
     */
    func redoLatestChange()

    /**
     Scroll to a certain range.

     - Parameters:
       - range: The range to scroll to.
     */
    func scroll(to range: NSRange)

    /**
     Set the rich text in the text view.

     - Parameters:
       - text: The rich text to set.
     */
    func setRichText(_ text: NSAttributedString)

    /**
     Set the selected range in the text view.

     - Parameters:
       - range: The range to set.     
     */
    func setSelectedRange(_ range: NSRange)

    /**
     Undo the latest change.
     */
    func undoLatestChange()
}


// MARK: - Public Extension

public extension RichTextViewComponent {

    /**
     Alert a title and message, using "OK" as button text.

     - Parameters:
       - title: The alert title.
       - message: The alert message.
     */
    func alert(title: String, message: String) {
        alert(title: title, message: message, buttonTitle: "OK")
    }

    /**
     Move the text cursor to a certain input index.

     This will use `safeRange(for:)` to cap the index to the
     available rich text range.
     */
    func moveInputCursor(to index: Int) {
        let newRange = NSRange(location: index, length: 0)
        let safeRange = safeRange(for: newRange)
        setSelectedRange(safeRange)
    }

    /**
     Setup the view with data and a ``RichTextDataFormat``.

     - Parameters:
       - data: The rich text data to edit with the text view.
       - format: The rich text format to use.
     */
    func setup(
        with data: Data,
        format: RichTextDataFormat
    ) throws {
        let string = try NSAttributedString(data: data, format: format)
        setup(with: string, format: format, scrollingDisabled: false)
    }

    /**
     Get the image configuration to use for a certain format.

     - Parameters:
       - format: The format to get a configuration for.
     */
    func standardImageConfiguration(for format: RichTextDataFormat) -> RichTextImageConfiguration {
        let insertConfig = standardImageInsertConfiguration(for: format)
        return RichTextImageConfiguration(
            pasteConfiguration: insertConfig,
            dropConfiguration: insertConfig,
            maxImageSize: (width: .frame, height: .frame))
    }

    /**
     Get the image configuration to use for a certain format.

     - Parameters:
       - format: The format to get a configuration for.
     */
    func standardImageInsertConfiguration(for format: RichTextDataFormat) -> RichTextImageInsertConfiguration {
        format.supportsImages ? .enabled : .disabled
    }
}

internal extension RichTextViewComponent {

    /**
     This can be called to setup the initial font size for a
     text view component.
     */
    func setupInitialFontSize() {
        let font = FontRepresentable.standardRichTextFont
        let size = font.pointSize
        setCurrentFontSize(to: size)
    }

    /**
     This can be called to setup an initial text color for a
     text view component.

     To avoid incorrectly coloring an already formatted text,
     the action is only called if the provided text is empty.
     */
    func trySetupInitialTextColor(
        for text: NSAttributedString,
        _ action: () -> Void
    ) {
        if text.string.isEmpty {
            action()
        }
    }
}
