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

    /**
     The image configuration to use by the rich text view.

     The view uses the ``RichTextImageConfiguration/disabled``
     configuration by default. You can change this by either
     setting the property manually or by setting up the view
     with a ``RichTextDataFormat`` that supports images.
     */
    public var imageConfiguration: RichTextImageConfiguration = .disabled {
        didSet {
            #if os(iOS)
            refreshDropInteraction()
            #endif
        }
    }

    #if os(iOS)

    /**
     The image drop interaction to use when dropping images.
     */
    lazy var imageDropInteraction: UIDropInteraction = {
        UIDropInteraction(delegate: self)
    }()

    #endif

    /**
     This keeps track of the first time a valid frame is set.
     We should find another way to handle this.
     */
    private var isInitialFrameSetupNeeded = true

    /**
     This keeps track of the data format used by the view.
     */
    private var richTextDataFormat: RichTextDataFormat = .archivedData


    // MARK: - Overrides

    /**
     Layout subviews and auto-resize images in the rich text.

     I tried to only autosize image attachments here, but it
     didn't work - they weren't resized. I then tried adding
     font size adjustment, but that also didn't work. So now
     we initialize this once, when the frame is first set.
     */
    public override var frame: CGRect {
        didSet {
            if frame.size == .zero { return }
            if !isInitialFrameSetupNeeded { return }
            isInitialFrameSetupNeeded = false
            setup(with: attributedString, format: richTextDataFormat)
        }
    }

    #if os(iOS)
    /**
     Check whether or not a certain action can be performed.
     */
    public override func canPerformAction(
        _ action: Selector,
        withSender sender: Any?
    ) -> Bool {
        let pasteboard = UIPasteboard.general
        let hasImage = pasteboard.image != nil
        let isPaste = action == #selector(paste(_:))
        let canPerformImagePaste = imagePasteConfiguration != .disabled
        if isPaste && hasImage && canPerformImagePaste { return true }
        return super.canPerformAction(action, withSender: sender)
    }

    /**
     Paste the current content of the general pasteboard.
     */
    public override func paste(_ sender: Any?) {
        let pasteboard = UIPasteboard.general
        if let image = pasteboard.image {
            return pasteImage(image, at: selectedRange.location)
        }
        super.paste(sender)
    }
    #endif
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
        allowsEditingTextAttributes = false
        autocapitalizationType = .sentences
        backgroundColor = .clear
        imageConfiguration = standardImageConfiguration(for: format)
        text.autosizeImageAttachments(maxSize: imageAttachmentMaxSize)
        richTextDataFormat = format
        spellCheckingType = .no
        textColor = .label
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        setupInitialFontSize(for: text)
    }
}


// MARK: - Public Functionality

public extension RichTextView {

    /**
     The spacing between the text view's edge and its text.

     The reason why this only supports setting a `CGSize` is
     that AppKit only supports a `CGSize`. You can still use
     the `textContainerInset` of the underlying `UITextView`
     if you want more control.
     */
    var textContentInset: CGSize {
        get {
            CGSize(
                width: textContainerInset.left,
                height: textContainerInset.top)
        } set {
            textContainerInset = UIEdgeInsets(
                top: newValue.height,
                left: newValue.width,
                bottom: newValue.height,
                right: newValue.width)
        }
    }


    /**
     Alert a certain title and message.

     This view uses a `UIAlertController` to alert messages.
     */
    func alert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        let controller = window?.rootViewController?.presentedViewController
        controller?.present(alert, animated: true, completion: nil)
    }
    
    /**
     Copy the current selection.
     */
    func copySelection() {
        #if os(iOS)
        let pasteboard = UIPasteboard.general
        let range = safeRange(for: selectedRange)
        let text = richText(at: range)
        pasteboard.string = text.string
        #else
        print("Pasteboard is not available on this platform")
        #endif
    }

    /**
     Get the frame of a certain range.

     - Parameters:
       - range: The range to get the frame from.
     */
    func frame(of range: NSRange) -> CGRect {
        let beginning = beginningOfDocument
        guard
            let start = position(from: beginning, offset: range.location),
            let end = position(from: start, offset: range.length),
            let textRange = textRange(from: start, to: end)
        else { return .zero }
        let rect = firstRect(for: textRange)
        return convert(rect, from: textInputView)
    }

    /**
     Get the text range at a certain point.

     - Parameters:
       - index: The text index to get the range from.
     */
    func range(at index: CGPoint) -> NSRange? {
        guard let range = characterRange(at: index) else { return nil }
        let location = offset(from: beginningOfDocument, to: range.start)
        let length = offset(from: range.start, to: range.end)
        return NSRange(location: location, length: length)
    }

    /**
     Try to redo the latest undone change.
     */
    func redoLatestChange() {
        undoManager?.redo()
    }

    /**
     Scroll the text view to a certain range.

     - Parameters:
       - range: The range to scroll to.     
     */
    func scroll(to range: NSRange) {
        let caret = frame(of: range)
        scrollRectToVisible(caret, animated: true)
    }

    /**
     Set the rich text in the text view.
     */
    func setRichText(_ text: NSAttributedString) {
        attributedString = text
    }

    /**
     Set the selected range in the text view.
     */
    func setSelectedRange(_ range: NSRange) {
        selectedRange = range
    }

    /**
     Try to undo the latest change.
     */
    func undoLatestChange() {
        undoManager?.undo()
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
