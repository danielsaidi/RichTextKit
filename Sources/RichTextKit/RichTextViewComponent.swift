//
//  RichTextViewComponent.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
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
    RichTextAttributeReader,
    RichTextAttributeWriter,
    RichTextDataReader,
    RichTextImageAttachmentManager,
    RichTextPdfDataReader
{
        
    /// The text view's frame.
    var frame: CGRect { get }

    /// The style to use when highlighting text in the view.
    var highlightingStyle: RichTextHighlightingStyle { get set }

    /// The image configuration used by the rich text view.
    var imageConfiguration: RichTextImageConfiguration { get set }

    /// Whether or not the text view is the first responder.
    var isFirstResponder: Bool { get }

    /// The text view's mutable attributed string, if any.
    var mutableAttributedString: NSMutableAttributedString? { get }

    /// The spacing between the text view's edge and its text.
    var textContentInset: CGSize { get set }

    /// The text view current typing attributes.
    var typingAttributes: RichTextAttributes { get set }


    // MARK: - Setup

    /// Setup the view with a text and ``RichTextDataFormat``.
    func setup(
        with text: NSAttributedString,
        format: RichTextDataFormat
    )


    // MARK: - Functions

    /// Show an alert with a title, message and button text.
    func alert(title: String, message: String, buttonTitle: String)

    /// Copy the current selection.
    func copySelection()

    /// Try to redo the latest undone change.
    func redoLatestChange()

    /// Scroll to a certain range.
    func scroll(to range: NSRange)

    /// Set the rich text in the text view.
    func setRichText(_ text: NSAttributedString)

    /// Set the selected range in the text view.
    func setSelectedRange(_ range: NSRange)

    /// Undo the latest change.
    func undoLatestChange()
}


// MARK: - Public Extension

public extension RichTextViewComponent {

    /// Show an alert with a title, message and OK button.
    func alert(title: String, message: String) {
        alert(title: title, message: message, buttonTitle: "OK")
    }
    
    /// Delete all characters in a certain range.
    func deleteCharacters(in range: NSRange) {
        mutableAttributedString?.deleteCharacters(in: range)
    }

    /// Move the text cursor to a certain input index.
    func moveInputCursor(to index: Int) {
        let newRange = NSRange(location: index, length: 0)
        let safeRange = safeRange(for: newRange)
        setSelectedRange(safeRange)
    }

    /// Setup the view with data and a ``RichTextDataFormat``.
    func setup(
        with data: Data,
        format: RichTextDataFormat
    ) throws {
        let string = try NSAttributedString(data: data, format: format)
        setup(with: string, format: format)
    }

    /// Get the image configuration for a certain format.
    func standardImageConfiguration(
        for format: RichTextDataFormat
    ) -> RichTextImageConfiguration {
        let insertConfig = standardImageInsertConfiguration(for: format)
        return RichTextImageConfiguration(
            pasteConfiguration: insertConfig,
            dropConfiguration: insertConfig,
            maxImageSize: (width: .frame, height: .frame))
    }

    /// Get the image insert config for a certain format.
    func standardImageInsertConfiguration(
        for format: RichTextDataFormat
    ) -> RichTextImageInsertConfiguration {
        format.supportsImages ? .enabled : .disabled
    }
}

internal extension RichTextViewComponent {

    /// This can be called to setup the initial font size.
    func setupInitialFontSize() {
        let font = FontRepresentable.standardRichTextFont
        let size = font.pointSize
        setCurrentFontSize(size)
    }

    /// This can be called to setup an initial text color.
    func trySetupInitialTextColor(
        for text: NSAttributedString,
        _ action: () -> Void
    ) {
        guard text.string.isEmpty else { return }
        action()
    }
}
