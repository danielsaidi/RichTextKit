//
//  RichTextViewRepresentable.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import CoreGraphics
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
public protocol RichTextViewRepresentable: AnyObject,
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
    RichTextImageAttachmentManager,
    // RichTextStyleReader,
    RichTextStyleWriter {
        
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


    /**
     Setup the rich text view with a rich text and a certain
     data format.
     */
    func setup(
        with text: NSAttributedString,
        format: RichTextDataFormat)


    /**
     Alert a certain title and message.
     */
    func alert(_ title: String, message: String)
    
    /**
     Copy the current selection.
     */
    func copySelection()

    /**
     Redo the latest undone change.
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

public extension RichTextViewRepresentable {

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
        switch format {
        case .archivedData: return .enabled
        case .plainText: return .disabled
        case .rtf: return .disabled
        }
    }
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
