//
//  RichTextView_AppKit.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-12.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if macOS
import AppKit

/**
 This is a platform-agnostic rich text view that can be used
 in both UIKit and AppKit.

 The view inherits `NSTextView` in AppKit and `UITextView`
 in UIKit. It aims to make these views behave more alike and
 make them implement ``RichTextViewComponent``, which is the
 protocol that is used within this library.

 The view will apply a ``RichTextImageConfiguration/disabled``
 image config by default. You can change this by setting the
 property manually or by using a ``RichTextDataFormat`` that
 supports images.
 */
open class RichTextView: NSTextView, RichTextViewComponent {

    // MARK: - Properties

    /// The configuration to use by the rich text view.
    public var configuration: Configuration = .standard

    /// The theme for coloring and setting style to text view.
    public var theme: Theme = .standard {
        didSet { 
            setup(theme)
            // Set up link text attributes
            if let linkColor = theme.linkColor {
                linkTextAttributes = [
                    .foregroundColor: linkColor,
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .underlineColor: linkColor,
                    NSAttributedString.Key.cursor: NSCursor.pointingHand
                ]
            }
        }
    }

    /// The style to use when highlighting text in the view.
    public var highlightingStyle: RichTextHighlightingStyle = .standard

    /// The image configuration to use by the rich text view.
    public var imageConfiguration: RichTextImageConfiguration = .disabled {
        didSet { imageConfigurationWasSet = true }
    }

    /// The image configuration to use by the rich text view.
    var imageConfigurationWasSet = false
    private var customToolContainerView: NSView?
    var onAIChatBtnAction: (String) -> () = { _ in }
    var onEditBtnAction: (String) -> () = { _ in }
    var onRecordBtnAction: () -> () = {}
    var onFocus: () -> () = {}

    // MARK: - Private Helper Methods
    
    private let whitelistedKeys: Set<NSAttributedString.Key> = [
        .font,  // For font size mapping
        .underlineStyle,  // For underline
        .paragraphStyle,  // For alignment and line spacing
        .listStyle,  // For list handling
        .listItemNumber,  // For list handling
        .link  // For preserving link functionality
    ]
    
    private func cleanAttributes(_ attributedString: NSMutableAttributedString, range: NSRange, preserveColor: Bool = false) {
        // Remove all attributes except our whitelist
        attributedString.enumerateAttributes(in: range, options: []) { attrs, subrange, _ in
            for (key, _) in attrs {
                if !whitelistedKeys.contains(key) {
                    attributedString.removeAttribute(key, range: subrange)
                }
            }
            
            // Clean up paragraph style - preserve alignment, line spacing, and paragraph spacing
            if let oldStyle = attrs[.paragraphStyle] as? NSParagraphStyle {
                let newStyle = NSMutableParagraphStyle()
                newStyle.alignment = oldStyle.alignment
                
                // Get the font size to determine line spacing
                if let font = attrs[.font] as? NSFont {
                    let mappedSize = mapFontSize(font.pointSize)
                    newStyle.lineSpacing = mapLineSpacing(mappedSize)
                } else {
                    newStyle.lineSpacing = mapLineSpacing(16.0) // Default line spacing
                }
                
                // Add paragraph spacing
                // newStyle.paragraphSpacing = 20
                // newStyle.paragraphSpacingBefore = 20
                
                // Handle list indentation if needed
                if let listStyle = attrs[.listStyle] as? RichTextListStyle,
                   listStyle != .none {
                    if let level = attrs[.listItemNumber] as? Int {
                        newStyle.headIndent = CGFloat((level + 1) * 36) // 36 points per level
                    }
                }
                
                attributedString.addAttribute(.paragraphStyle, value: newStyle, range: subrange)
            }
            
            // Apply theme's link color if this is a link
            if attrs[.link] != nil, let linkColor = theme.linkColor {
                attributedString.addAttribute(.foregroundColor, value: linkColor, range: subrange)
                attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: subrange)
                attributedString.addAttribute(.underlineColor, value: linkColor, range: subrange)
            }
        }
        
        // Map font sizes and apply our font family
        attributedString.enumerateAttribute(.font, in: range, options: []) { value, subrange, _ in
            let mappedSize: CGFloat
            if let font = value as? NSFont {
                mappedSize = mapFontSize(font.pointSize)
            } else {
                mappedSize = 16.0 // Default to paragraph size
            }
            
            let defaultFont = NSFont(name: "New York", size: mappedSize) ?? NSFont.systemFont(ofSize: mappedSize)
            attributedString.addAttribute(.font, value: defaultFont, range: subrange)
            attributedString.addAttribute(NSAttributedString.Key("NSFontSizeAttribute"), value: mappedSize, range: subrange)
        }
        
        // Apply color if needed
        if preserveColor, let foregroundColor = typingAttributes[.foregroundColor] as? NSColor {
            attributedString.addAttribute(.foregroundColor, value: foregroundColor, range: range)
        }
    }
    
    private func createDefaultAttributedString(from string: String) -> NSAttributedString {
        let defaultFont = NSFont(name: "New York", size: 16.0) ?? NSFont.systemFont(ofSize: 16.0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = mapLineSpacing(16.0) // Default line spacing
        // paragraphStyle.paragraphSpacing = 10
        // paragraphStyle.paragraphSpacingBefore = 10
        
        return NSAttributedString(string: string, attributes: [
            .font: defaultFont,
            NSAttributedString.Key("NSFontSizeAttribute"): 16.0,
            .paragraphStyle: paragraphStyle
        ])
    }

    // MARK: - Overrides

    /// Paste the current pasteboard content into the view.
    open override func paste(_ sender: Any?) {
        let pasteboard = NSPasteboard.general
        
        // Try to get any text data (RTF or plain)
        if let rtfData = pasteboard.data(forType: .rtf),
           let rtfString = try? NSAttributedString(data: rtfData, documentAttributes: nil) {
            // Create mutable copy to clean up attributes
            let mutableString = NSMutableAttributedString(attributedString: rtfString)
            let range = NSRange(location: 0, length: mutableString.length)
            
            cleanAttributes(mutableString, range: range, preserveColor: true)
            handlePastedText(mutableString)
            return
        } else if let data = pasteboard.data(forType: .string),
                  let string = String(data: data, encoding: .utf8) {
            let attrString = createDefaultAttributedString(from: string)
            handlePastedText(attrString)
            return
        }
        
        // Fall back to super implementation for other types (like images)
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
        // Handle fileURLs that contain known image types
        let images = pasteboard.pasteboardItems?.compactMap {
            if let str = $0.string(forType: NSPasteboard.PasteboardType.fileURL),
               let url = URL(string: str), let image = ImageRepresentable(contentsOf: url) {
                let fileExtension = url.pathExtension.lowercased()
                let imageExtensions = ["jpg", "jpeg", "png", "gif", "tiff", "bmp", "heic"]
                if imageExtensions.contains(fileExtension) {
                    return image
                }
            }
            return nil
        } ?? [ImageRepresentable]()
        if images.count > 0 {
            pasteImages(images, at: selectedRange().location, moveCursorToPastedContent: true)
            return true
        }

        return super.performDragOperation(draggingInfo)
    }

    open override func scrollWheel(with event: NSEvent) {

        if configuration.isScrollingEnabled {
            return super.scrollWheel(with: event)
        }

        // 1st nextResponder is NSClipView
        // 2nd nextResponder is NSScrollView
        // 3rd nextResponder is NSResponder SwiftUIPlatformViewHost
        self.nextResponder?
            .nextResponder?
            .nextResponder?
            .scrollWheel(with: event)
    }

    // Add text input handling
    open override func insertText(_ string: Any, replacementRange: NSRange) {
        // Store current selection for undo
        let currentRange = selectedRange
        let currentAttributes = typingAttributes
        
        // Begin undo grouping
        undoManager?.beginUndoGrouping()
        
        // If we're typing after a link or inserting whitespace, remove link attributes
        if let text = string as? String {
            let attributes = richTextAttributes(at: NSRange(location: max(0, currentRange.location - 1), length: 1))
            
            if attributes[.link] != nil || text.rangeOfCharacter(from: .whitespacesAndNewlines) != nil {
                // Remove link-related attributes from typing attributes
                var attrs = typingAttributes
                attrs.removeValue(forKey: .link)
                attrs.removeValue(forKey: .underlineStyle)
                attrs.removeValue(forKey: .underlineColor)
                if let linkColor = theme.linkColor {
                    // Reset color if it matches the link color
                    if attrs[.foregroundColor] as? NSColor == linkColor {
                        attrs[.foregroundColor] = textColor
                    }
                }
                typingAttributes = attrs
                
                // Also remove link attributes from the current position
                if let textStorage = self.textStorage {
                    textStorage.removeAttribute(.link, range: NSRange(location: currentRange.location, length: 0))
                    textStorage.removeAttribute(.underlineStyle, range: NSRange(location: currentRange.location, length: 0))
                    textStorage.removeAttribute(.underlineColor, range: NSRange(location: currentRange.location, length: 0))
                }
            }
        }
        
        // Perform the text insertion
        super.insertText(string, replacementRange: replacementRange)
        
        // Register undo operation
        undoManager?.registerUndo(withTarget: self) { target in
            target.undoTextInsertion(at: currentRange, attributes: currentAttributes)
        }
        
        undoManager?.endUndoGrouping()
    }
    
    private func undoTextInsertion(at range: NSRange, attributes: [NSAttributedString.Key: Any]) {
        if let textStorage = self.textStorage {
            textStorage.deleteCharacters(in: range)
            typingAttributes = attributes
            selectedRange = range
        }
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
        setupSharedBehavior(with: text, format)
        allowsImageEditing = true
        allowsUndo = true
        isAutomaticLinkDetectionEnabled = true
        isEditable = true
        isSelectable = true
        layoutManager?.defaultAttachmentScaling = NSImageScaling.scaleProportionallyDown
        isContinuousSpellCheckingEnabled = configuration.isContinuousSpellCheckingEnabled
        setup(theme)
        setupCustomToolButton()
        NotificationCenter.default.addObserver(self, selector: #selector(selectionDidChange), name: NSTextView.didChangeSelectionNotification, object: self)
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

    /// Copy the current selection.
    open func copySelection() {
        let pasteboard = NSPasteboard.general
        let range = safeRange(for: selectedRange)
        let text = richText(at: range)
        pasteboard.clearContents()
        pasteboard.setString(text.string, forType: .string)
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
        scrollRangeToVisible(range)
    }

    /// Set the rich text in the text view.
    open func setRichText(_ text: NSAttributedString) {
        attributedString = text
    }

    /// Undo the latest change.
    open func undoLatestChange() {
        undoManager?.undo()
    }

    private func handlePastedText(_ text: NSAttributedString) {
        let attributedString = NSMutableAttributedString(attributedString: text)
        let range = NSRange(location: 0, length: attributedString.length)
        
        cleanAttributes(attributedString, range: range, preserveColor: true)
        
        // Use textStorage to replace the text while preserving attributes
        let insertRange = selectedRange()
        if let textStorage = self.textStorage {
            textStorage.replaceCharacters(in: insertRange, with: attributedString)
        }
    }
    
    private func mapFontSize(_ originalSize: CGFloat) -> CGFloat {
        let mappedSize = switch originalSize {
        case 0..<17:
            16.0 // paragraph (anything under 17)
        case 17..<21:
            20.0 // heading3 (17-20)
        case 21..<24:
            24.0 // heading2 (21-23)
        case 24...:
            28.0 // heading1 (24 or larger)
        default:
            16.0 // default to paragraph size
        }
        return mappedSize
    }

    private func mapLineSpacing(_ fontSize: CGFloat) -> CGFloat {
        return 10.0  // Use consistent line spacing for all text
    }
}

// MARK: - Public Extensions

public extension RichTextView {

    /// The text view's layout manager, if any.
    var layoutManagerWrapper: NSLayoutManager? {
        layoutManager
    }

    /// The spacing between the text view edges and its text.
    var textContentInset: CGSize {
        get { textContainerInset }
        set { textContainerInset = newValue }
    }

    /// The text view's text storage, if any.
    var textStorageWrapper: NSTextStorage? {
        textStorage
    }
}

// MARK: - RichTextProvider

public extension RichTextView {

    /// Get the rich text that is managed by the view.
    var attributedString: NSAttributedString {
        get { attributedString() }
        set { 
            let currentRange = selectedRange
            textStorage?.setAttributedString(newValue)
            selectedRange = currentRange
        }
    }

    /// Whether or not the text view is the first responder.
    var isFirstResponder: Bool {
        window?.firstResponder == self
    }
}

// MARK: - RichTextWriter

public extension RichTextView {

    // Get the rich text that is managed by the view.
    var mutableAttributedString: NSMutableAttributedString? {
        textStorage
    }
}

// MARK: - Additional Pasteboard Types

public extension RichTextView {
    override var readablePasteboardTypes: [NSPasteboard.PasteboardType] {
        var pasteboardTypes = super.readablePasteboardTypes
        pasteboardTypes.append(.png)
        return pasteboardTypes
    }
}
// custom tool buttons for ai chat and Record option
// TODO:  Can Make this tool buttons more dynamic, also should have flag to show hide this buttons according to prefrence of projects, in case using same framework in other project
public extension RichTextView {

    override open func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        updateColorsForAppearance()
    }

    // Setup the custom tool button
    private func setupCustomToolButton() {
        customToolContainerView = NSView()
        customToolContainerView?.isHidden = true // Hide initially
        customToolContainerView?.wantsLayer = true
        updateColorsForAppearance()
        customToolContainerView?.layer?.borderColor = NSColor.gray.withAlphaComponent(0.3).cgColor
                customToolContainerView?.layer?.borderWidth = 1
        customToolContainerView?.layer?.cornerRadius = 3

        // Set container dimensions (adjust as needed)
        customToolContainerView?.frame.size = NSSize(width: 26, height: 24)

        if let containerView = customToolContainerView {
            self.addSubview(containerView)
        }
        // Paragraph button
        let symbolConfiguration = NSImage.SymbolConfiguration(textStyle: .caption1, scale: .small)
        let commandSign = NSImage(systemSymbolName: "command", accessibilityDescription: "command")!
            .withSymbolConfiguration(symbolConfiguration)

        let btn = NSButton()
        btn.bezelStyle = .rounded
        btn.isBordered = false

        // Create a combined attributed title with both icon and text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let attributedTitle = NSMutableAttributedString()

        // Add command icon
        let commandAttachment = NSTextAttachment()
        commandAttachment.image = commandSign
        commandAttachment.bounds = CGRect(x: 0, y: -1, width: 12, height: 12)
        let commandString = NSAttributedString(attachment: commandAttachment)
        attributedTitle.append(commandString)

        // Add "K" with semi-bold styling
        let semi = NSFont.systemFont(ofSize: 12, weight: .semibold)
        let kString = NSAttributedString(string: "L", attributes: [
            .font: semi,
            .paragraphStyle: paragraphStyle,
            .baselineOffset: 0
        ])
        attributedTitle.append(kString)

        btn.attributedTitle = attributedTitle
        btn.target = self
        btn.action = #selector(chatButtonAction)
        btn.keyEquivalent = "l"
        btn.keyEquivalentModifierMask = [.command]

        btn.imageHugsTitle = true
        btn.imagePosition = .imageLeading
        btn.frame = NSRect(x: 0, y: 0, width: 26, height: 24) // Match container size
        customToolContainerView?.addSubview(btn)

    }

    private func updateColorsForAppearance() {
        guard let customToolContainerView = customToolContainerView else { return }

        let cursorButtonColor = NSColor(name: "cursorButtonColor") { appearance in
            switch appearance.bestMatch(from: [.aqua, .darkAqua]) {
            case .darkAqua:
                return NSColor(red: 48/255, green: 45/255, blue: 38/255, alpha: 1)
            case .aqua:
                return NSColor(red: 228/255, green: 224/255, blue: 211/255, alpha: 1)
            default:
                return NSColor(red: 228/255, green: 224/255, blue: 211/255, alpha: 1)
            }
        }
        customToolContainerView.layer?.backgroundColor = cursorButtonColor.cgColor
    }

    @objc func showContextMenu(_ sender: NSButton) {
        let menu = NSMenu()
        menu.addItem(createMenuItem(title: "Edit and Author", imageName: "character.cursor.ibeam", action: #selector(editButtonAction)))
        menu.addItem(createMenuItem(title: "Ask a Question", imageName: "sparkles", action: #selector(chatButtonAction)))
        menu.addItem(createMenuItem(title: "Write with Voice", imageName: "mic.fill", action: #selector(recordButtonAction)))
        // Show the menu at the button's location
        menu.popUp(positioning: nil, at: sender.bounds.origin, in: sender)
    }

    private func createMenuItem(title: String, imageName: String, action: Selector) -> NSMenuItem {
        let menuItem = NSMenuItem(title: title, action: action, keyEquivalent: "")
        menuItem.image = NSImage(named: imageName) // Set the image
        menuItem.target = self // Ensure the action is triggered
        return menuItem
    }

    // Update container visibility and position based on selection
    @objc private func selectionDidChange() {
        if selectedRange.length > 0 {
            showCustomToolButton()
        } else {
            hideCustomToolButton()
        }
    }

    private func hideCustomToolButton() {
        guard let containerView = customToolContainerView else { return }
        containerView.isHidden = true
    }

    private func showCustomToolButton() {
        guard let containerView = customToolContainerView else { return }
        // Show container and position it below the selected text
        containerView.isHidden = false
        setCustomToolButtonFrameOrigin()
    }

    func setCustomToolButtonFrameOrigin() {
        guard let containerView = customToolContainerView, !containerView.isHidden else { return }
        // Calculate the position of the container below the selection
        if let layoutManager = self.layoutManager {
            let glyphRange = layoutManager.glyphRange(forCharacterRange: selectedRange, actualCharacterRange: nil)
            let boundingRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: self.textContainer!)
            let containerOrigin = self.textContainerOrigin

            // Convert the bounding rectangle to view coordinates
            let buttonPosition = NSPoint(x: boundingRect.maxX + containerOrigin.x + 5, // Offset slightly to the right
                                         y: boundingRect.minY + containerOrigin.y + self.frame.origin.y - 4)
            containerView.setFrameOrigin(buttonPosition)
        }
    }

    @objc private func recordButtonAction() {
        onRecordBtnAction()
    }

    @objc private func chatButtonAction() {
        let range = safeRange(for: selectedRange)
        let text = richText(at: range)
        onAIChatBtnAction(text.string)
        hideCustomToolButton()
    }

    @objc private func editButtonAction() {
        let range = safeRange(for: selectedRange)
        let text = richText(at: range)
        onEditBtnAction(text.string)
    }
}

extension RichTextView {

    open override func becomeFirstResponder() -> Bool {
        onFocus()
        return super.becomeFirstResponder()
    }

    open override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder()
    }

}

// MARK: - List Support

extension RichTextView {
    
    open override func insertNewline(_ sender: Any?) {
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
                
                super.insertNewline(sender)
                return
            }
            
            // Insert newline with list formatting
            super.insertNewline(sender)
            
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
            
        } else {
            super.insertNewline(sender)
        }
    }
    
    open override func drawBackground(in rect: NSRect) {
        super.drawBackground(in: rect)
        drawListMarkers(in: rect)
    }
    
    private func drawListMarkers(in rect: NSRect) {
        guard let layoutManager = self.layoutManager,
              let textContainer = self.textContainer else { return }
        
        layoutManager.enumerateLineFragments(forGlyphRange: layoutManager.glyphRange(forBoundingRect: rect, in: textContainer)) { (lineRect, usedRect, textContainer, glyphRange, stop) in
            
            let characterRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
            let attributes = self.textStorage?.attributes(at: characterRange.location, effectiveRange: nil) ?? [:]
            
            guard let listStyle = attributes[.listStyle] as? RichTextListStyle,
                  listStyle != .none else { return }
            
            let paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle
            let indent = paragraphStyle?.headIndent ?? 0
            
            // Calculate marker position
            let markerX = lineRect.minX + (paragraphStyle?.firstLineHeadIndent ?? 0)
            let markerY = lineRect.minY + (lineRect.height - (self.font?.pointSize ?? 12)) / 2
            
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
                .font: self.font ?? .systemFont(ofSize: NSFont.systemFontSize),
                .foregroundColor: self.textColor ?? .textColor
            ]
            
            marker.draw(at: NSPoint(x: markerX, y: markerY), withAttributes: markerAttributes)
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

#endif
