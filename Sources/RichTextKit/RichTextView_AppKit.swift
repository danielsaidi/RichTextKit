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
 This is a platform-agnostic rich text view that can be used
 in both UIKit and AppKit.

 The view inhertits `NSTextField` in AppKit and `UITextField`
 in UIKit. It aims to make these views behave more alike and
 make them implement ``RichTextViewComponent``, which is the
 protocol that is used within this library.
 */
open class RichTextView: NSTextView, RichTextViewComponent {

    // MARK: - Properties
    
    /**
     The style to use when highlighting text in the view.
     */
    public var highlightingStyle: RichTextHighlightingStyle = .standard

    /**
     The image configuration to use by the rich text view.

     The view uses the ``RichTextImageConfiguration/disabled``
     configuration by default. You can change this by either
     setting the property manually or by setting up the view
     with a ``RichTextDataFormat`` that supports images.
     */
    public var imageConfiguration: RichTextImageConfiguration = .disabled


    // MARK: - Overrides

    /**
     Paste the current pasteboard content into the text view.
     */
    open override func paste(_ sender: Any?) {
        let pasteboard = NSPasteboard.general
        if let image = pasteboard.image {
            return pasteImage(image, at: selectedRange.location)
        }
        super.paste(sender)
    }

    /**
     Try to perform a certain drag operation, which will get
     and paste images from the drag info into the text.
     */
    open override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool {
        let pasteboard = draggingInfo.draggingPasteboard
        if let images = pasteboard.images, images.count > 0 {
            pasteImages(images, at: selectedRange().location, moveCursorToPastedContent: true)
            return true
        }
        return super.performDragOperation(draggingInfo)
    }


    // MARK: - Setup

    /**
     Setup the rich text view with a rich text and a certain
     ``RichTextDataFormat``.

     - Parameters:
       - text: The text to edit with the text view.
       - format: The rich text format to edit.
     */
    open func setup(
        with text: NSAttributedString,
        format: RichTextDataFormat
    ) {
        attributedString = text
        allowsImageEditing = true
        allowsUndo = true
        backgroundColor = .clear
        imageConfiguration = standardImageConfiguration(for: format)
        layoutManager?.defaultAttachmentScaling = NSImageScaling.scaleProportionallyDown
        textColor = .textColor
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        setupInitialFontSize(for: text)
    }


    // MARK: - Open Functionality

    /**
     Alert a certain title and message.

     - Parameters:
       - title: The alert title.
       - message: The alert message.
       - buttonTitle: The alert button title.
     */
    open func alert(title: String, message: String, buttonTitle: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: buttonTitle)
        alert.runModal()
    }

    /**
     Copy the current selection.
     */
    open func copySelection() {
        let pasteboard = NSPasteboard.general
        let range = safeRange(for: selectedRange)
        let text = richText(at: range)
        pasteboard.clearContents()
        pasteboard.setString(text.string, forType: .string)
    }

    /**
     Try to redo the latest undone change.
     */
    open func redoLatestChange() {
        undoManager?.redo()
    }

    /**
     Scroll to a certain range.

     - Parameters:
       - range: The range to scroll to.
     */
    open func scroll(to range: NSRange) {
        scrollRangeToVisible(range)
    }

    /**
     Set the rich text in the text view.

     - Parameters:
       - text: The rich text to set.
     */
    open func setRichText(_ text: NSAttributedString) {
        attributedString = text
    }

    /**
     Undo the latest change.
     */
    open func undoLatestChange() {
        undoManager?.undo()
    }
}


// MARK: - Public Extensions

public extension RichTextView {

    /**
     The spacing between the text view's edge and its text.

     This is an alias for `textContainerInset`, to make sure
     that the text view has a platform-agnostic API.
     */
    var textContentInset: CGSize {
        get { textContainerInset }
        set { textContainerInset = newValue }
    }
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

    /**
     Whether or not the text view is the first responder.
     */
    var isFirstResponder: Bool {
        window?.firstResponder == self
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
