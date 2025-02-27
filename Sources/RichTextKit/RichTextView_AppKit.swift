//
//  RichTextView_AppKit.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-12.
//  Copyright 2022-2024 Daniel Saidi. All rights reserved.
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
    var openNote: (String) -> () = { _ in }
    var openSection: (String) -> () = { _ in }
    public var formattingStateDidChange: ((RichTextStyle) -> Void)?

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
                newStyle.paragraphSpacing = 10
                newStyle.paragraphSpacingBefore = 10
                
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
        paragraphStyle.paragraphSpacing = 10
        paragraphStyle.paragraphSpacingBefore = 10
        
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
        let currentRange = selectedRange
        let currentAttributes = typingAttributes

        undoManager?.beginUndoGrouping()

        if let text = string as? String {
            let attributes = richTextAttributes(at: NSRange(location: max(0, currentRange.location - 1), length: 1))

            if attributes[.link] != nil || text.rangeOfCharacter(from: .whitespacesAndNewlines) != nil {
                var attrs = typingAttributes
                attrs.removeValue(forKey: .link)
                attrs.removeValue(forKey: .underlineStyle)
                attrs.removeValue(forKey: .underlineColor)
                if let linkColor = theme.linkColor, attrs[.foregroundColor] as? NSColor == linkColor {
                    attrs[.foregroundColor] = textColor
                }
                typingAttributes = attrs

                textStorage?.removeAttribute(.link, range: NSRange(location: currentRange.location, length: 0))
                textStorage?.removeAttribute(.underlineStyle, range: NSRange(location: currentRange.location, length: 0))
                textStorage?.removeAttribute(.underlineColor, range: NSRange(location: currentRange.location, length: 0))
            }
        }

        super.insertText(string, replacementRange: replacementRange)

        undoManager?.registerUndo(withTarget: self) { target in
            target.undoTextInsertion(at: currentRange, attributes: currentAttributes)
        }

        undoManager?.endUndoGrouping()

        handleMarkdownInput()
    }

    private func undoTextInsertion(at range: NSRange, attributes: [NSAttributedString.Key: Any]) {
        textStorage?.deleteCharacters(in: range)
        typingAttributes = attributes
        selectedRange = range
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
        setupCmdLButton()
        setupHighlightShortcut()
        NotificationCenter.default.addObserver(self, selector: #selector(selectionDidChange), name: NSTextView.didChangeSelectionNotification, object: self)
    }

    // Add highlight shortcut setup
    private func setupHighlightShortcut() {
        // Create a menu item for CMD+SHIFT+H
        let menuItem = NSMenuItem()
        menuItem.title = "Toggle Highlight"
        menuItem.keyEquivalent = "h"
        menuItem.keyEquivalentModifierMask = [.command, .shift]
        menuItem.action = #selector(cycleHighlight)
        menuItem.target = self
        
        // Add to main menu
        if let mainMenu = NSApplication.shared.mainMenu {
            // Try to find existing Edit menu
            if let editMenu = mainMenu.items.first(where: { $0.submenu?.title == "Edit" })?.submenu {
                editMenu.addItem(NSMenuItem.separator())
                editMenu.addItem(menuItem)
            } else {
                // Create Edit menu if it doesn't exist
                let editMenu = NSMenu(title: "Edit")
                let editMenuItem = NSMenuItem()
                editMenuItem.submenu = editMenu
                editMenuItem.title = "Edit"
                mainMenu.addItem(editMenuItem)
                editMenu.addItem(menuItem)
            }
        }
    }
    
    @objc private func cycleHighlight() {
        guard let textStorage = textStorage else { return }
        
        // Get current highlight color if any
        let attributes = richTextAttributes(at: selectedRange)
        let currentHighlight = attributes[.backgroundColor] as? NSColor
        
        print("Cycling highlight. Current color: \(String(describing: currentHighlight?.description))")
        
        // Define highlight colors directly
        let greenHighlight = NSColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 0.5)
        let redHighlight = NSColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 0.5)
        
        // Helper function to compare colors approximately
        func colorsAreEqual(_ color1: NSColor?, _ color2: NSColor) -> Bool {
            guard let color1 = color1?.usingColorSpace(.genericRGB) else { return false }
            let color2 = color2.usingColorSpace(.genericRGB)!
            
            // Compare RGB components with some tolerance for floating point comparison
            let tolerance: CGFloat = 0.1
            return abs(color1.redComponent - color2.redComponent) < tolerance &&
                   abs(color1.greenComponent - color2.greenComponent) < tolerance &&
                   abs(color1.blueComponent - color2.blueComponent) < tolerance
        }
        
        // Determine next color in cycle
        if currentHighlight == nil {
            // No highlight -> Green
            print("Applying green highlight")
            applyHighlight(greenHighlight)
        } else if colorsAreEqual(currentHighlight, greenHighlight) {
            // Green -> Red
            print("Applying red highlight")
            applyHighlight(redHighlight)
        } else if colorsAreEqual(currentHighlight, redHighlight) {
            // Red -> None
            print("Removing highlight")
            textStorage.removeAttribute(.backgroundColor, range: selectedRange)
        } else {
            // Unknown color -> Start over with green
            print("Unknown color, applying green highlight")
            applyHighlight(greenHighlight)
        }
        
        // Move cursor to end of selection and deselect
        selectedRange = NSRange(location: selectedRange.location + selectedRange.length, length: 0)
    }

    private func applyHighlight(_ color: NSColor) {
        if let textStorage = textStorage {
            textStorage.addAttribute(.backgroundColor, value: color, range: selectedRange)
        }
    }

    // MARK: - Custom Tool Button Setup

    private func setupCustomToolButton() {
        customToolContainerView = NSView()
        customToolContainerView?.isHidden = true // Hide initially
        customToolContainerView?.wantsLayer = true
        customToolContainerView?.layer?.cornerRadius = 4
        customToolContainerView?.layer?.borderWidth = 1
        customToolContainerView?.layer?.borderColor = NSColor(named: "secondaryBackground")?.cgColor ?? NSColor.gray.cgColor
        customToolContainerView?.layer?.backgroundColor = NSColor(named: "quaternaryBackground")?.cgColor ?? NSColor.windowBackgroundColor.cgColor
        
        // Set container dimensions for three squares
        customToolContainerView?.frame.size = NSSize(width: 70, height: 24)

        if let containerView = customToolContainerView {
            self.addSubview(containerView)
            setupColorSquares(in: containerView)
        }
    }

    private func setupColorSquares(in container: NSView) {
        let squareSize: CGFloat = 16
        let spacing: CGFloat = 4  // Reduced spacing between squares
        let yOffset: CGFloat = 4
        
        // Create three square buttons
        let clearButton = createColorSquare(color: .clear, size: squareSize, withSlash: true)
        let redButton = createColorSquare(color: NSColor(named: "highlightRed") ?? .red, size: squareSize)
        let greenButton = createColorSquare(color: NSColor(named: "highlightGreen") ?? .green, size: squareSize)
        
        // Position squares horizontally with even spacing
        let totalWidth = squareSize * 3 + spacing * 2
        let startX = (container.frame.width - totalWidth) / 2
        
        clearButton.frame.origin = NSPoint(x: startX, y: yOffset)
        redButton.frame.origin = NSPoint(x: startX + squareSize + spacing, y: yOffset)
        greenButton.frame.origin = NSPoint(x: startX + (squareSize + spacing) * 2, y: yOffset)
        
        container.addSubview(clearButton)
        container.addSubview(redButton)
        container.addSubview(greenButton)
        
        // Add actions
        clearButton.target = self
        clearButton.action = #selector(clearHighlightAction)
        redButton.target = self
        redButton.action = #selector(redHighlightAction)
        greenButton.target = self
        greenButton.action = #selector(greenHighlightAction)
    }
    
    private func createColorSquare(color: NSColor, size: CGFloat, withSlash: Bool = false) -> NSButton {
        let button = NSButton(frame: NSRect(x: 0, y: 0, width: size, height: size))
        button.wantsLayer = true
        button.layer?.cornerRadius = 2
        button.layer?.borderWidth = 1
        button.layer?.borderColor = NSColor.gray.withAlphaComponent(0.3).cgColor
        button.title = ""
        button.bezelStyle = .regularSquare
        button.isBordered = false
        
        // Create a container view for the button content
        let containerView = NSView(frame: NSRect(x: 0, y: 0, width: size, height: size))
        containerView.wantsLayer = true
        
        // Background layer
        let backgroundLayer = CALayer()
        backgroundLayer.frame = containerView.bounds
        backgroundLayer.cornerRadius = 2
        backgroundLayer.borderWidth = 1
        backgroundLayer.borderColor = NSColor.gray.withAlphaComponent(0.3).cgColor
        backgroundLayer.backgroundColor = color == .clear ? NSColor.white.cgColor : color.cgColor
        containerView.layer = backgroundLayer
        
        if withSlash {
            // Add diagonal red line for clear button
            let slashLayer = CAShapeLayer()
            slashLayer.frame = containerView.bounds
            
            let path = NSBezierPath()
            path.move(to: NSPoint(x: 2, y: 2))
            path.line(to: NSPoint(x: size - 2, y: size - 2))
            
            slashLayer.path = path.cgPath
            slashLayer.strokeColor = NSColor.red.cgColor
            slashLayer.lineWidth = 1.5
            slashLayer.lineCap = .round
            
            containerView.layer?.addSublayer(slashLayer)
        }
        
        button.addSubview(containerView)
        
        return button
    }

    private func updateColorsForAppearance() {
        guard let customToolContainerView = customToolContainerView else { return }
        customToolContainerView.layer?.backgroundColor = NSColor(named: "quaternary")?.cgColor ?? NSColor.windowBackgroundColor.cgColor
        customToolContainerView.layer?.borderColor = NSColor(named: "secondary")?.cgColor ?? NSColor.gray.cgColor
    }

    // MARK: - Tool Button Visibility

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
        containerView.isHidden = false
        setCustomToolButtonFrameOrigin()
    }

    public func setCustomToolButtonFrameOrigin() {
        guard let containerView = customToolContainerView, !containerView.isHidden else { return }
        
        if let layoutManager = self.layoutManager {
            let glyphRange = layoutManager.glyphRange(forCharacterRange: selectedRange, actualCharacterRange: nil)
            let boundingRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: self.textContainer!)
            let containerOrigin = self.textContainerOrigin
            
            // Get the cursor position (start of selection)
            let cursorRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: selectedRange.location, length: 0), in: self.textContainer!)
            
            // Position above the cursor with offset
            let buttonPosition = NSPoint(
                x: cursorRect.minX + containerOrigin.x,
                y: cursorRect.minY + containerOrigin.y - containerView.frame.height - 5
            )
            containerView.setFrameOrigin(buttonPosition)
        }
    }

    // MARK: - Highlight Actions

    @objc private func clearHighlightAction() {
        // Remove highlight from selected text
        if let textStorage = textStorage {
            textStorage.removeAttribute(.backgroundColor, range: selectedRange)
        }
        hideCustomToolButton()
        selectedRange = NSRange(location: selectedRange.location + selectedRange.length, length: 0)  // Deselect text
    }

    @objc private func redHighlightAction() {
        if let color = NSColor(named: "highlightRed") {
            applyHighlight(color)
        }
        hideCustomToolButton()
        selectedRange = NSRange(location: selectedRange.location + selectedRange.length, length: 0)  // Deselect text
    }

    @objc private func greenHighlightAction() {
        if let color = NSColor(named: "highlightGreen") {
            applyHighlight(color)
        }
        hideCustomToolButton()
        selectedRange = NSRange(location: selectedRange.location + selectedRange.length, length: 0)  // Deselect text
    }

    // MARK: - CMD+L Button Setup
    
    private func setupCmdLButton() {
        // Create a menu item for CMD+L
        let menuItem = NSMenuItem()
        menuItem.title = "Chat"
        menuItem.keyEquivalent = "l"
        menuItem.keyEquivalentModifierMask = .command
        menuItem.action = #selector(chatButtonAction)
        menuItem.target = self
        
        // Add to main menu
        if let mainMenu = NSApplication.shared.mainMenu {
            // Try to find existing Edit menu
            if let editMenu = mainMenu.items.first(where: { $0.submenu?.title == "Edit" })?.submenu {
                editMenu.addItem(NSMenuItem.separator())
                editMenu.addItem(menuItem)
            } else {
                // Create Edit menu if it doesn't exist
                let editMenu = NSMenu(title: "Edit")
                let editMenuItem = NSMenuItem()
                editMenuItem.submenu = editMenu
                editMenuItem.title = "Edit"
                mainMenu.addItem(editMenuItem)
                editMenu.addItem(menuItem)
            }
        }
    }
    
    @objc private func chatButtonAction() {
        let range = safeRange(for: selectedRange)
        let text = richText(at: range)
        onAIChatBtnAction(text.string)
    }

    @objc private func editButtonAction() {
        let range = safeRange(for: selectedRange)
        let text = richText(at: range)
        onEditBtnAction(text.string)
    }

    @objc private func recordButtonAction() {
        onRecordBtnAction()
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

    // Override to handle keyboard shortcuts
    open override func performKeyEquivalent(with event: NSEvent) -> Bool {
        print("Received key event: \(event.charactersIgnoringModifiers ?? ""), modifiers: \(event.modifierFlags)")
        
        let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        let chars = event.charactersIgnoringModifiers ?? ""
        
        // Handle CMD+L
        if flags == .command && chars == "l" {
            chatButtonAction()
            return true
        }
        
        // Handle CMD+SHIFT+H
        if chars.lowercased() == "h" && flags.contains(.command) && flags.contains(.shift) {
            print("Detected CMD+SHIFT+H")
            if selectedRange.length > 0 {
                cycleHighlight()
                return true
            }
        }
        
        // If we didn't handle it, let super try
        let handled = super.performKeyEquivalent(with: event)
        print("Super handled: \(handled)")
        return handled
    }

    open override var acceptsFirstResponder: Bool {
        return true
    }

    open override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        if result {
            // Register for the keyboard shortcut
            if let window = window {
                window.makeFirstResponder(self)
            }
        }
        return result
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

#endif
