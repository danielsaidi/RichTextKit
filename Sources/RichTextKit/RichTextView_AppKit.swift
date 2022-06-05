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
public class RichTextView: NSTextView, RichTextViewRepresentable {

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
}


// MARK: - Setup

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
        allowsImageEditing = true
        allowsUndo = true
        backgroundColor = .clear
        // TODO: imageConfiguration = imageConfig ?? imageConfiguration
        // TODO: layoutManager?.defaultAttachmentScaling = NSImageScaling.scaleProportionallyDown
        textColor = .textColor
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        setupInitialFontSize(for: text)
    }
}


// MARK: - Public Functionality

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


    /**
     Alert a certain title and message.

     This view uses an `NSAlert` to alert messages.
     */
    func alert(_ title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    /**
     Copy the current selection.
     */
    func copySelection() {
        let pasteboard = NSPasteboard.general
        let range = safeRange(for: selectedRange)
        let text = richText(at: range)
        pasteboard.setString(text.string, forType: .string)
    }

    /**
     Try to redo the latest undone change.
     */
    func redoLatestChange() {
        undoManager?.redo()
    }

    /**
     Set the rich text in the text view.
     */
    func setRichText(_ text: NSAttributedString) {
        attributedString = text
    }

    /**
     Try to undo the latest change.
     */
    func undoLatestChange() {
        undoManager?.undo()
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
