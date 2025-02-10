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
        didSet { setup(theme) }
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

    // MARK: - Overrides

    /// Paste the current pasteboard content into the view.
    open override func paste(_ sender: Any?) {
        // Set default typing attributes to ensure proper font size
        let defaultFont = NSFont(name: "New York", size: 16) ?? NSFont.systemFont(ofSize: 16)
        typingAttributes[.font] = defaultFont
        typingAttributes[NSAttributedString.Key("NSFontSizeAttribute")] = 16.0
        
        let pasteboard = NSPasteboard.general
        
        // Try to get any text data (RTF or plain)
        if let rtfData = pasteboard.data(forType: .rtf),
           let rtfString = try? NSAttributedString(data: rtfData, documentAttributes: nil) {
            // Create mutable copy and strip only color and unnecessary style attributes
            let mutableString = NSMutableAttributedString(attributedString: rtfString)
            let range = NSRange(location: 0, length: mutableString.length)
            
            // List of attributes we want to strip (only colors and unnecessary styles)
            let attributesToStrip: [NSAttributedString.Key] = [
                // Color attributes
                .foregroundColor,
                .backgroundColor,
                .underlineColor,
                .strokeColor,
                NSAttributedString.Key("NSColor"),
                NSAttributedString.Key("NSBackgroundColor"),
                NSAttributedString.Key("NSStrokeColor"),
                NSAttributedString.Key("NSUnderlineColor"),
                NSAttributedString.Key("NSStrikethroughColor"),
                
                // Stroke attributes
                .strokeWidth,
                NSAttributedString.Key("NSStrokeWidth"),
                
                // Other unnecessary style attributes
                .kern,
                .baselineOffset,
                .obliqueness,
                .expansion
            ]
            
            // Remove specified attributes while preserving others (bold, italic, underline, alignment, lists)
            for attribute in attributesToStrip {
                mutableString.removeAttribute(attribute, range: range)
            }
            
            // Map font sizes and ensure minimum size
            mutableString.enumerateAttribute(.font, in: range, options: []) { value, subrange, _ in
                if let font = value as? NSFont {
                    let mappedSize = mapFontSize(font.pointSize)
                    
                    // Create new font with mapped size but preserve other attributes (weight, traits)
                    let traits = font.fontDescriptor.symbolicTraits
                    let newFont = NSFont(name: "New York", size: mappedSize) ?? NSFont.systemFont(ofSize: mappedSize)
                    
                    // Create a font descriptor with the original traits
                    let descriptor = newFont.fontDescriptor
                    if let fontWithTraits = NSFont(descriptor: descriptor.withSymbolicTraits(traits), size: mappedSize) {
                        mutableString.addAttribute(.font, value: fontWithTraits, range: subrange)
                        mutableString.addAttribute(NSAttributedString.Key("NSFontSizeAttribute"), value: mappedSize, range: subrange)
                    } else {
                        mutableString.addAttribute(.font, value: newFont, range: subrange)
                        mutableString.addAttribute(NSAttributedString.Key("NSFontSizeAttribute"), value: mappedSize, range: subrange)
                    }
                } else {
                    // If no font is set, use default paragraph font
                    let defaultSize = 16.0
                    let defaultFont = NSFont(name: "New York", size: defaultSize) ?? NSFont.systemFont(ofSize: defaultSize)
                    mutableString.addAttribute(.font, value: defaultFont, range: subrange)
                    mutableString.addAttribute(NSAttributedString.Key("NSFontSizeAttribute"), value: defaultSize, range: subrange)
                }
            }
            
            handlePastedText(mutableString)
            return
        } else if let data = pasteboard.data(forType: .string),
           let string = String(data: data, encoding: .utf8) {
            // For plain text, always use paragraph font size
            let attrString = NSAttributedString(string: string, attributes: [
                .font: defaultFont,
                NSAttributedString.Key("NSFontSizeAttribute"): 16.0
            ])
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
        print("=== Starting handlePastedText ===")
        let attributedString = NSMutableAttributedString(attributedString: text)
        let range = NSRange(location: 0, length: attributedString.length)
        
        print("Processing text of length: \(range.length)")
        
        // Get the current typing attributes to preserve the correct color
        let currentAttributes = typingAttributes
        
        // Strip all color attributes but don't set new ones - let SectionEditorView handle colors
        attributedString.removeAttribute(.foregroundColor, range: range)
        attributedString.removeAttribute(.backgroundColor, range: range)
        attributedString.removeAttribute(.underlineColor, range: range)
        attributedString.removeAttribute(.strokeColor, range: range)
        attributedString.removeAttribute(NSAttributedString.Key("NSColor"), range: range)
        attributedString.removeAttribute(NSAttributedString.Key("NSBackgroundColor"), range: range)
        attributedString.removeAttribute(NSAttributedString.Key("NSStrokeColor"), range: range)
        attributedString.removeAttribute(NSAttributedString.Key("NSUnderlineColor"), range: range)
        attributedString.removeAttribute(NSAttributedString.Key("NSStrikethroughColor"), range: range)
        
        // Remove all indents from paragraph styles
        attributedString.enumerateAttribute(.paragraphStyle, in: range, options: []) { value, subrange, _ in
            if let oldStyle = value as? NSParagraphStyle {
                let newStyle = NSMutableParagraphStyle()
                // Copy only essential non-indent attributes
                newStyle.alignment = oldStyle.alignment
                newStyle.lineSpacing = oldStyle.lineSpacing
                newStyle.paragraphSpacing = 12  // Consistent paragraph spacing
                newStyle.paragraphSpacingBefore = 0  // No extra space before paragraphs
                
                // Reset all indent-related attributes to 0
                newStyle.firstLineHeadIndent = 0  // Remove leading indent for first line
                newStyle.headIndent = 0  // Remove leading indent for rest of paragraph
                newStyle.tailIndent = 0  // Remove trailing indent
                
                attributedString.addAttribute(.paragraphStyle, value: newStyle, range: subrange)
            }
        }
        
        // Apply the current foreground color from typing attributes
        if let foregroundColor = currentAttributes[.foregroundColor] as? NSColor {
            attributedString.addAttribute(.foregroundColor, value: foregroundColor, range: range)
        }
        
        // Map font sizes to standard heading sizes
        attributedString.enumerateAttribute(.font, in: range, options: []) { value, subrange, _ in
            let mappedSize: CGFloat
            if let font = value as? NSFont {
                mappedSize = max(16.0, mapFontSize(font.pointSize))
                
                // Create new font with mapped size but preserve other attributes (weight, traits)
                let traits = font.fontDescriptor.symbolicTraits
                let newFont = NSFont(name: "New York", size: mappedSize) ?? NSFont.systemFont(ofSize: mappedSize)
                
                // Create a font descriptor with the original traits
                let descriptor = newFont.fontDescriptor
                if let fontWithTraits = NSFont(descriptor: descriptor.withSymbolicTraits(traits), size: mappedSize) {
                    attributedString.addAttribute(.font, value: fontWithTraits, range: subrange)
                    attributedString.addAttribute(NSAttributedString.Key("NSFontSizeAttribute"), value: mappedSize, range: subrange)
                } else {
                    attributedString.addAttribute(.font, value: newFont, range: subrange)
                    attributedString.addAttribute(NSAttributedString.Key("NSFontSizeAttribute"), value: mappedSize, range: subrange)
                }
            } else {
                mappedSize = 16.0
                let defaultFont = NSFont(name: "New York", size: mappedSize) ?? NSFont.systemFont(ofSize: mappedSize)
                attributedString.addAttribute(.font, value: defaultFont, range: subrange)
                attributedString.addAttribute(NSAttributedString.Key("NSFontSizeAttribute"), value: mappedSize, range: subrange)
            }
        }
        
        // Use textStorage to replace the text while preserving attributes
        let insertRange = selectedRange()
        if let textStorage = self.textStorage {
            textStorage.replaceCharacters(in: insertRange, with: attributedString)
            
            // Re-apply non-color attributes as a safeguard
            attributedString.enumerateAttributes(in: range, options: []) { attrs, subrange, _ in
                let adjustedRange = NSRange(location: insertRange.location + subrange.location, length: subrange.length)
                for (key, value) in attrs {
                    textStorage.addAttribute(key, value: value, range: adjustedRange)
                }
            }
            
            // Ensure the color is set correctly from typing attributes
            if let foregroundColor = currentAttributes[.foregroundColor] as? NSColor {
                textStorage.addAttribute(.foregroundColor, value: foregroundColor, range: NSRange(location: insertRange.location, length: attributedString.length))
            }
        }
        
        // Scan for list patterns and apply list attributes
        let string = attributedString.string
        let lines = string.components(separatedBy: .newlines)
        var location = insertRange.location
        
        for line in lines {
            if let range = line.range(of: "^\\d+\\.\\s+", options: .regularExpression) {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.configureForList(.ordered)
                
                let attributes: [NSAttributedString.Key: Any] = [
                    .listStyle: RichTextListStyle.ordered,
                    .listItemNumber: 1,
                    .paragraphStyle: paragraphStyle
                ]
                
                let lineRange = NSRange(location: location, length: line.count)
                textStorage?.addAttributes(attributes, range: lineRange)
            }
            
            location += line.count + 1
        }
        
        // Update list item numbers if needed
        if let textStorage = textStorage {
            let fullRange = NSRange(location: 0, length: textStorage.length)
            updateListItemNumbers(in: fullRange)
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
        set { textStorage?.setAttributedString(newValue) }
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
