//
//  RichTextView_UIKit.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-12.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if iOS || os(tvOS) || os(visionOS)
import UIKit

#if iOS || os(visionOS)
import UniformTypeIdentifiers

extension RichTextView: UIDropInteractionDelegate {}
#endif

/**
 This is a platform-agnostic rich text view that can be used
 in both UIKit and AppKit.

 The view inherits `NSTextView` in AppKit and `UITextView`
 in UIKit. It aims to make these views behave more alike and
 make them implement ``RichTextViewComponent``, which is the
 protocol that is used within this library.
 */
open class RichTextView: UITextView, RichTextViewComponent {

    // MARK: - Initializers

    public convenience init(
        data: Data,
        format: RichTextDataFormat = .archivedData
    ) throws {
        self.init()
        try self.setup(with: data, format: format)
    }

    public convenience init(
        string: NSAttributedString,
        format: RichTextDataFormat = .archivedData
    ) {
        self.init()
        self.setup(with: string, format: format)
    }

    // MARK: - Essentials

    /// Get the frame of a certain range.
    open func frame(of range: NSRange) -> CGRect {
        let beginning = beginningOfDocument
        guard
            let start = position(from: beginning, offset: range.location),
            let end = position(from: start, offset: range.length),
            let textRange = textRange(from: start, to: end)
        else { return .zero }
        let rect = firstRect(for: textRange)
        return convert(rect, from: textInputView)
    }

    /// Get the text range at a certain point.
    open func range(at index: CGPoint) -> NSRange? {
        let range = characterRange(at: index) ?? UITextRange()
        let location = offset(from: beginningOfDocument, to: range.start)
        let length = offset(from: range.start, to: range.end)
        return NSRange(location: location, length: length)
    }


    // MARK: - Properties

    /// The configuration to use by the rich text view.
    public var configuration: Configuration = .standard {
        didSet {
            isScrollEnabled = configuration.isScrollingEnabled
            allowsEditingTextAttributes = configuration.allowsEditingTextAttributes
            autocapitalizationType = configuration.autocapitalizationType
            spellCheckingType = configuration.spellCheckingType
        }
    }

    public var theme: Theme = .standard {
        didSet { setup(theme) }
    }

    /// The style to use when highlighting text in the view.
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
            #if iOS || os(visionOS)
            refreshDropInteraction()
            imageConfigurationWasSet = true
            #endif
        }
    }

    /// The image configuration to use by the rich text view.
    var imageConfigurationWasSet = false

    #if iOS || os(visionOS)

    /// The image drop interaction to use.
    lazy var imageDropInteraction: UIDropInteraction = {
        UIDropInteraction(delegate: self)
    }()

    /// The interaction types supported by drag & drop.
    var supportedDropInteractionTypes: [UTType] {
        [.image, .text, .plainText, .utf8PlainText, .utf16PlainText]
    }

    #endif

    /// Keeps track of the first time a valid frame is set.
    private var isInitialFrameSetupNeeded = true

    /// Keeps track of the data format used by the view.
    private var richTextDataFormat: RichTextDataFormat = .archivedData

    // MARK: - Overrides

    /**
     Layout subviews and auto-resize images in the rich text.

     I tried to only autosize image attachments here, but it
     didn't work - they weren't resized. I then tried adding
     font size adjustment, but that also didn't work. So now
     we initialize this once, when the frame is first set.
     */
    open override var frame: CGRect {
        didSet {
            if frame.size == .zero { return }
            if !isInitialFrameSetupNeeded { return }
            isInitialFrameSetupNeeded = false
            setup(with: attributedString, format: richTextDataFormat)
        }
    }

    #if iOS || os(visionOS)
    /**
     Check whether or not a certain action can be performed.
     */
    open override func canPerformAction(
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
    open override func paste(_ sender: Any?) {
        let pasteboard = UIPasteboard.general
        
        // Handle images first
        if let image = pasteboard.image {
            pasteImage(image, at: selectedRange.location)
            return
        }
        
        // Try to get rich text data
        if let rtfData = pasteboard.data(forType: .rtf),
           let rtfString = try? NSAttributedString(data: rtfData, documentAttributes: nil) {
            let attributedString = NSMutableAttributedString(attributedString: rtfString)
            
            // Get our default attributes for font and color
            let defaultAttrs = richTextAttributes
            let defaultFont = defaultAttrs[.font] as? UIFont
            let defaultColor = defaultAttrs[.foregroundColor] as? UIColor
            
            // Strip colors and fonts while preserving other attributes
            let range = NSRange(location: 0, length: attributedString.length)
            attributedString.enumerateAttributes(in: range, options: []) { (attrs, subrange, _) in
                var newAttrs = attrs
                
                // Preserve font traits (bold, italic) while using our font
                if let defaultFont = defaultFont {
                    if let oldFont = attrs[.font] as? UIFont {
                        // Get the traits from the old font
                        let oldTraits = oldFont.fontDescriptor.symbolicTraits
                        
                        // Create a new font descriptor with the same traits
                        let newDesc = defaultFont.fontDescriptor.withSymbolicTraits(oldTraits)
                        if let newFont = UIFont(descriptor: newDesc, size: defaultFont.pointSize) {
                            newAttrs[.font] = newFont
                        } else {
                            newAttrs[.font] = defaultFont
                        }
                    } else {
                        newAttrs[.font] = defaultFont
                    }
                }
                
                // Remove color attributes and apply default color
                newAttrs.removeValue(forKey: .foregroundColor)
                newAttrs.removeValue(forKey: .backgroundColor)
                if let defaultColor = defaultColor {
                    newAttrs[.foregroundColor] = defaultColor
                }
                
                // Update attributes
                attributedString.setAttributes(newAttrs, range: subrange)
            }
            
            insertText(attributedString, replacementRange: selectedRange)
            return
        }
        
        // Then try getting regular string
        if let string = pasteboard.string {
            // Create attributed string from pasteboard
            let attributedString = NSMutableAttributedString(string: string)
            
            // Apply our default attributes
            let defaultAttrs = richTextAttributes
            attributedString.addAttributes(defaultAttrs, range: NSRange(location: 0, length: attributedString.length))
            
            // Scan for list patterns
            let lines = string.components(separatedBy: .newlines)
            var location = 0
            
            for line in lines {
                // Check for ordered list pattern (e.g., "1.", "2.", etc.)
                if let range = line.range(of: "^\\d+\\.\\s+", options: .regularExpression) {
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.configureForList(.ordered)
                    
                    let attributes: [NSAttributedString.Key: Any] = [
                        .listStyle: RichTextListStyle.ordered,
                        .listItemNumber: 1, // Will be updated later
                        .paragraphStyle: paragraphStyle
                    ]
                    
                    let lineRange = NSRange(location: location, length: line.count)
                    attributedString.addAttributes(attributes, range: lineRange)
                }
                
                location += line.count + 1 // +1 for newline
            }
            
            // Insert the attributed string
            insertText(attributedString, replacementRange: selectedRange)
            
            // Update list item numbers
            if let textStorage = textStorage {
                let fullRange = NSRange(location: 0, length: textStorage.length)
                updateListItemNumbers(in: fullRange)
            }
            return
        }
        
        // Fall back to super implementation
        super.paste(sender)
    }
    #endif

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
        text.autosizeImageAttachments(maxSize: imageAttachmentMaxSize)
        setupSharedBehavior(with: text, format)
        richTextDataFormat = format
        setup(theme)
    }

    // MARK: - Open Functionality

    /// Alert a certain title and message.
    open func alert(title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alert.addAction(action)
        let controller = window?.rootViewController?.presentedViewController
        controller?.present(alert, animated: true, completion: nil)
    }

    /// Copy the current selection.
    open func copySelection() {
        #if iOS || os(visionOS)
        let pasteboard = UIPasteboard.general
        let range = safeRange(for: selectedRange)
        let text = richText(at: range)
        pasteboard.string = text.string
        #else
        print("Pasteboard is not available on this platform")
        #endif
    }

    /// Delete the text at a certain range.
    open func deleteText(in range: NSRange) {
        deleteCharacters(in: range)
    }

    /// Try to redo the latest undone change.
    open func redoLatestChange() {
        undoManager?.redo()
    }

    /// Scroll to a certain range.
    open func scroll(to range: NSRange) {
        let caret = frame(of: range)
        scrollRectToVisible(caret, animated: true)
    }

    /// Set the rich text in the text view.
    open func setRichText(_ text: NSAttributedString) {
        attributedString = text
    }

    ///  Set the selected range in the text view.
    open func setSelectedRange(_ range: NSRange) {
        selectedRange = range
    }

    /// Undo the latest change.
    open func undoLatestChange() {
        undoManager?.undo()
    }

    #if iOS || os(visionOS)

    // MARK: - UIDropInteractionDelegate

    /// Whether or not the view can handle a drop session.
    open func dropInteraction(
        _ interaction: UIDropInteraction,
        canHandle session: UIDropSession
    ) -> Bool {
        if session.hasImage && imageDropConfiguration == .disabled { return false }
        let identifiers = supportedDropInteractionTypes.map { $0.identifier }
        return session.hasItemsConforming(toTypeIdentifiers: identifiers)
    }

    /// Handle an updated drop session.
    open func dropInteraction(
        _ interaction: UIDropInteraction,
        sessionDidUpdate session: UIDropSession
    ) -> UIDropProposal {
        let operation = dropInteractionOperation(for: session)
        return UIDropProposal(operation: operation)
    }

    /// The drop interaction operation for a certain session.
    open func dropInteractionOperation(
        for session: UIDropSession
    ) -> UIDropOperation {
        guard session.hasDroppableContent else { return .forbidden }
        let location = session.location(in: self)
        return frame.contains(location) ? .copy : .cancel
    }

    /**
     Handle a performed drop session.

     In this function, we reverse the item collection, since
     each item will be pasted at the drop point, which would
     result in a reverse result.
     */
    open func dropInteraction(
        _ interaction: UIDropInteraction,
        performDrop session: UIDropSession
    ) {
        guard session.hasDroppableContent else { return }
        let location = session.location(in: self)
        guard let range = self.range(at: location) else { return }
        performImageDrop(with: session, at: range)
        performTextDrop(with: session, at: range)
    }

    // MARK: - Drop Interaction Support

    /**
     Performs an image drop session.

     We reverse the item collection, since each item will be
     pasted at the original drop point.
     */
    open func performImageDrop(with session: UIDropSession, at range: NSRange) {
        guard validateImageInsertion(for: imageDropConfiguration) else { return }
        session.loadObjects(ofClass: UIImage.self) { items in
            let images = items.compactMap { $0 as? UIImage }.reversed()
            images.forEach { self.pasteImage($0, at: range.location) }
        }
    }

    /**
     Perform a text drop session.

     We reverse the item collection, since each item will be
     pasted at the original drop point.
     */
    open func performTextDrop(with session: UIDropSession, at range: NSRange) {
        if session.hasImage { return }
        _ = session.loadObjects(ofClass: String.self) { items in
            let strings = items.reversed()
            strings.forEach { self.pasteText($0, at: range.location) }
        }
    }

    /// Refresh the drop interaction based on the config.
    open func refreshDropInteraction() {
        switch imageDropConfiguration {
        case .disabled:
            removeInteraction(imageDropInteraction)
        case .disabledWithWarning, .enabled:
            addInteraction(imageDropInteraction)
        }
    }
    #endif

    // MARK: - List Support

    open override func insertText(_ text: String) {
        // Handle return key for lists
        if text == "\n" {
            let currentRange = selectedRange
            let attributes = richTextAttributes(at: currentRange)
            
            // Check if we're in a list
            if let listStyle = attributes[.listStyle] as? RichTextListStyle,
               listStyle != .none {
                
                // Get the current line's text
                let lineRange = lineRange(for: currentRange)
                let lineText = richText(at: lineRange).string.trimmingCharacters(in: .whitespaces)
                
                // If the line is empty, end the list
                if lineText.isEmpty {
                    // Remove list formatting from the current line
                    let paragraphStyle = NSMutableParagraphStyle()
                    setRichTextParagraphStyle(paragraphStyle)
                    
                    if let string = mutableRichText {
                        string.removeAttribute(.listStyle, range: lineRange)
                        string.removeAttribute(.listItemNumber, range: lineRange)
                    }
                    
                    super.insertText(text)
                    return
                }
                
                // Insert newline with list formatting
                super.insertText(text)
                
                // Get the new line range
                let newLineRange = selectedRange
                
                // Create paragraph style for the new line
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.configureForList(listStyle)
                
                // Get the next number for ordered lists
                let nextNumber = (attributes[.listItemNumber] as? Int ?? 1) + 1
                
                // Apply list attributes to the new line
                let listAttributes: [NSAttributedString.Key: Any] = [
                    .listStyle: listStyle,
                    .listItemNumber: nextNumber,
                    .paragraphStyle: paragraphStyle
                ]
                
                if let string = mutableRichText {
                    string.addAttributes(listAttributes, range: newLineRange)
                }
                
                // Update all following list item numbers
                updateListItemNumbers(in: NSRange(location: newLineRange.location, length: (textStorage?.length ?? 0) - newLineRange.location))
                
                return
            }
        }
        
        super.insertText(text)
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawListMarkers(in: rect)
    }
    
    private func drawListMarkers(in rect: CGRect) {
        guard let layoutManager = layoutManager,
              let textContainer = textContainer else { return }
        
        layoutManager.enumerateLineFragments(forGlyphRange: layoutManager.glyphRange(forBoundingRect: rect, in: textContainer)) { (lineRect, usedRect, textContainer, glyphRange, stop) in
            
            let characterRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
            let attributes = self.textStorage?.attributes(at: characterRange.location, effectiveRange: nil) ?? [:]
            
            guard let listStyle = attributes[.listStyle] as? RichTextListStyle,
                  listStyle != .none else { return }
            
            let paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle
            let indent = paragraphStyle?.headIndent ?? 0
            
            // Calculate marker position
            let markerX = lineRect.minX + (paragraphStyle?.firstLineHeadIndent ?? 0)
            let markerY = lineRect.minY + (lineRect.height - (font?.pointSize ?? 12)) / 2
            
            // Create marker string
            let marker: String
            if listStyle == .ordered {
                let number = attributes[.listItemNumber] as? Int ?? 1
                marker = "\(number)."
            } else {
                marker = listStyle.marker
            }
            
            // Draw marker
            let markerAttributes: [NSAttributedString.Key: Any] = [
                .font: font ?? .systemFont(ofSize: UIFont.systemFontSize),
                .foregroundColor: textColor ?? .label
            ]
            
            (marker as NSString).draw(at: CGPoint(x: markerX, y: markerY), withAttributes: markerAttributes)
        }
    }
    
    private func updateListItemNumbers(in range: NSRange) {
        guard let textStorage = textStorage else { return }
        
        var currentNumber = 1
        var location = range.location
        
        while location < range.location + range.length {
            let attributes = textStorage.attributes(at: location, effectiveRange: nil)
            
            if let style = attributes[.listStyle] as? RichTextListStyle,
               style == .ordered {
                let lineRange = lineRange(for: NSRange(location: location, length: 0))
                textStorage.addAttribute(.listItemNumber, value: currentNumber, range: lineRange)
                currentNumber += 1
                location = lineRange.location + lineRange.length
            } else {
                location += 1
            }
        }
    }
}

#if iOS || os(visionOS)
private extension UIDropSession {

    var hasDroppableContent: Bool {
        hasImage || hasText
    }

    var hasImage: Bool {
        canLoadObjects(ofClass: UIImage.self)
    }

    var hasText: Bool {
        canLoadObjects(ofClass: String.self)
    }
}
#endif

// MARK: - Public Extensions

public extension RichTextView {

    /// The text view's layout manager, if any.
    var layoutManagerWrapper: NSLayoutManager? {
        layoutManager
    }

    /// The spacing between the text view edges and its text.
    var textContentInset: CGSize {
        get {
            CGSize(
                width: textContainerInset.left,
                height: textContainerInset.top
            )
        } set {
            textContainerInset = UIEdgeInsets(
                top: newValue.height,
                left: newValue.width,
                bottom: newValue.height,
                right: newValue.width
            )
        }
    }

    /// The text view's text storage, if any.
    var textStorageWrapper: NSTextStorage? {
        textStorage
    }
}

// MARK: - RichTextProvider

public extension RichTextView {

    /// Get the rich text managed by the text view.
    var attributedString: NSAttributedString {
        get { super.attributedText ?? NSAttributedString(string: "") }
        set { attributedText = newValue }
    }
}

// MARK: - RichTextWriter

public extension RichTextView {

    /// Get the mutable rich text managed by the view.
    var mutableAttributedString: NSMutableAttributedString? {
        textStorage
    }
}
#endif
