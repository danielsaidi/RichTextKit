//
//  RichTextView_AppKit.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-12.
//  Copyright 2022-2024 Daniel Saidi. All rights reserved.
//

#if macOS
import AppKit

public extension Notification.Name {
    static let richTextKitScaleChanged = Notification.Name("richTextKitScaleChanged")
}

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

    /// 100% 1x1 unit scaling:
     let unitSize: NSSize = NSSize(width: 1.0, height: 1.0)

     /// The last scaling factor that this textview experienced
     private(set) var oldScaleFactor: Double = 1.0

     /// The current zoom factor
     private(set) var zoomFactor: Double = 1.0

    let minZoomFactor: Double = 0.8

     /// Zooms to the specified scaling factor.
     /// - Parameter factor: The scaling factor. 1.0 = 100%
     func zoomTo(factor: Double) {
         var scaleFactor = factor

         // No negative values:
         if scaleFactor < 0 {
             scaleFactor = abs(scaleFactor)
         }

         // No 0 value allowed!
         if scaleFactor == 0.0 {
             scaleFactor = 1.0
         }

         // Don't do redundant scaling:
         if scaleFactor == oldScaleFactor {
             // We've already scaled.
             return
         }

         // Reset the zoom before re-zooming
         scaleUnitSquare(to: NSSize(width: 1.0 / oldScaleFactor, height: 1.0 / oldScaleFactor))

         // Perform the zoom on the text view:
         scaleUnitSquare(to: NSSize(width: scaleFactor, height: scaleFactor))

         // Handle the details:
         guard let tc = textContainer, let lm = layoutManager, let scrollContentSize = enclosingScrollView?.contentSize else {
             return
         }

         // scrollContentSize- To make word-wrapping update:

         // Necessary for word wrap
         frame = CGRect(x:0, y:0, width: scrollContentSize.width, height: 0.0)

         tc.containerSize = NSMakeSize(scrollContentSize.width, CGFloat(FLT_MAX))
         tc.widthTracksTextView = true
         lm.ensureLayout(for: tc)

         // Scroll to the cursor! Makes zooming super nice :)
         alternativeScrollToCursor()

         needsDisplay = true

         zoomFactor = scaleFactor

         // Keep track of the old scale factor:
         oldScaleFactor = scaleFactor
     }

     /// Forces the textview to scroll to the current cursor/caret position.
     func alternativeScrollToCursor() {
         if let cursorPosition: NSInteger = selectedRanges.first?.rangeValue.location {
             scrollRangeToVisible(NSRange(location: cursorPosition, length: 0))
         }
     }

    func updateFontScale(to scale: FontScalingOption) {
        zoomTo(factor: scale.factor)
    }

    func zoomIn() {
        let currentScale = FontScalingOption.allCases.first { $0.factor == oldScaleFactor } ?? .defaultFont
        let orderedScales: [FontScalingOption] = [.extraSmall, .small, .defaultFont, .large, .extraLarge]
        if let currentIndex = orderedScales.firstIndex(of: currentScale),
           currentIndex < orderedScales.count - 1 {
            let nextScale = orderedScales[currentIndex + 1]
            performZoom(factor: nextScale.factor)
        }
    }

    func zoomOut() {
        let currentScale = FontScalingOption.allCases.first { $0.factor == oldScaleFactor } ?? .defaultFont
        let orderedScales: [FontScalingOption] = [.extraSmall, .small, .defaultFont, .large, .extraLarge]
        if let currentIndex = orderedScales.firstIndex(of: currentScale),
           currentIndex > 0 {
            let previousScale = orderedScales[currentIndex - 1]
            performZoom(factor: previousScale.factor)
        }
    }

    func performZoom(factor: Double) {
        DispatchQueue.main.async {
            guard self.oldScaleFactor != factor else { return }
            let factorString = String(format: "%.2f", factor)
            let roundedFactor = Double(factorString) ?? 0.0
            self.zoomTo(factor: roundedFactor)
            
            // Notify observers with the new scale factor
            if let scale = FontScalingOption.allCases.first(where: { $0.factor == roundedFactor }) {
                NotificationCenter.default.post(name: .richTextKitScaleChanged, object: scale)
            }
        }
    }

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
        // Track font traits to preserve
        var preservedFontTraits = [NSRange: (isBold: Bool, isItalic: Bool)]()
        var preservedUnderline = [NSRange: Int]()
        
        // First pass: collect all formatting we want to preserve
        attributedString.enumerateAttributes(in: range, options: []) { attrs, subrange, _ in
            // Preserve font traits (bold, italic)
            if let font = attrs[.font] as? NSFont {
                let fontManager = NSFontManager.shared
                let isBold = fontManager.traits(of: font).contains(.boldFontMask)
                let isItalic = fontManager.traits(of: font).contains(.italicFontMask)
                preservedFontTraits[subrange] = (isBold, isItalic)
            }
            
            // Preserve underline
            if let underlineStyle = attrs[.underlineStyle] as? Int {
                preservedUnderline[subrange] = underlineStyle
            }
        }
        
        // Remove all attributes except our whitelist
        attributedString.enumerateAttributes(in: range, options: []) { attrs, subrange, _ in
            for (key, _) in attrs {
                if !whitelistedKeys.contains(key) {
                    attributedString.removeAttribute(key, range: subrange)
                }
            }
            
            // Preserve font traits (bold, italic) but standardize font family
            if let oldFont = attrs[.font] as? NSFont {
                let fontManager = NSFontManager.shared
                let traits = preservedFontTraits[subrange]
                let isBold = traits?.isBold ?? fontManager.traits(of: oldFont).contains(.boldFontMask)
                let isItalic = traits?.isItalic ?? fontManager.traits(of: oldFont).contains(.italicFontMask)
                
                // Start with standard font at the original size
                var newFont = NSFont.standardRichTextFont.withSize(oldFont.pointSize)
                
                // Apply bold if needed
                if isBold {
                    newFont = fontManager.convert(newFont, toHaveTrait: .boldFontMask)
                }
                
                // Apply italic if needed
                if isItalic {
                    newFont = fontManager.convert(newFont, toHaveTrait: .italicFontMask)
                }
                
                // Apply the new font
                attributedString.addAttribute(.font, value: newFont, range: subrange)
            }
            
            // Restore underline if it was present
            if let underlineStyle = preservedUnderline[subrange] {
                attributedString.addAttribute(.underlineStyle, value: underlineStyle, range: subrange)
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
                
                // Preserve original paragraph spacing
                newStyle.paragraphSpacing = oldStyle.paragraphSpacing
                newStyle.paragraphSpacingBefore = oldStyle.paragraphSpacingBefore
                
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
                
                // Get the traits from the current font
                let fontManager = NSFontManager.shared
                let traits = preservedFontTraits[subrange]
                let isBold = traits?.isBold ?? fontManager.traits(of: font).contains(.boldFontMask)
                let isItalic = traits?.isItalic ?? fontManager.traits(of: font).contains(.italicFontMask)
                
                // Create a new font with the mapped size but preserve bold/italic
                var newFont = NSFont(name: "New York", size: mappedSize) ?? NSFont.systemFont(ofSize: mappedSize)
                
                // Apply bold if needed
                if isBold {
                    newFont = fontManager.convert(newFont, toHaveTrait: .boldFontMask)
                }
                
                // Apply italic if needed
                if isItalic {
                    newFont = fontManager.convert(newFont, toHaveTrait: .italicFontMask)
                }
                
                // Apply the new font
                attributedString.addAttribute(.font, value: newFont, range: subrange)
            } else {
                mappedSize = 16.0 // Default to paragraph size
                let defaultFont = NSFont(name: "New York", size: mappedSize) ?? NSFont.systemFont(ofSize: mappedSize)
                attributedString.addAttribute(.font, value: defaultFont, range: subrange)
            }
            
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
        
        // Check for image data first
        if let image = pasteboard.image {
            // Insert the image at the current selection point
            let attachment = NSTextAttachment()
            attachment.image = image
            
            // Scale down large images to a reasonable size
            let imageSize = image.size
            if imageSize.width > 600 {
                let ratio = imageSize.height / imageSize.width
                let newWidth: CGFloat = 600
                let newHeight = newWidth * ratio
                attachment.bounds = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
            }
            
            let attachmentString = NSAttributedString(attachment: attachment)
            let mutableString = NSMutableAttributedString(attributedString: attachmentString)
            
            // Add a newline after the image
            mutableString.append(NSAttributedString(string: "\n"))
            
            // Insert at current selection
            if let storage = textStorage {
                let insertionPoint = selectedRange.location
                storage.replaceCharacters(in: selectedRange, with: mutableString)
                
                // Move cursor right after the inserted image (before the newline)
                let newPosition = insertionPoint + 1  // Position after the attachment character
                selectedRange = NSRange(location: newPosition, length: 0)
                
                // Ensure the cursor is visible
                scrollRangeToVisible(selectedRange)
            } else {
                // Fall back to handlePastedText if textStorage is nil
                handlePastedText(mutableString)
            }
            
            return
        }
        
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
        
        // Fall back to super implementation for other types
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
        // Store current selection and content for undo
        let currentRange = selectedRange
        let currentAttributes = typingAttributes
        let currentText = textStorage?.attributedSubstring(from: currentRange) ?? NSAttributedString()
        
        // Begin undo grouping
        undoManager?.beginUndoGrouping()
        
        // Handle newline independently of markdown processing
        if let text = string as? String, text == "\n",
           let coordinator = delegate as? RichTextCoordinator,
           let textStorage = self.textStorage {
            
            // Get the current paragraph's attributes
            let currentParagraphStyle = typingAttributes[.paragraphStyle] as? NSParagraphStyle
            let currentAlignment = currentParagraphStyle?.alignment ?? .left
            
            // Set up attributes for the new paragraph
            coordinator.context.headerLevel = .paragraph
            let newStyle = NSMutableParagraphStyle()
            newStyle.lineSpacing = coordinator.context.lineSpacing
            newStyle.alignment = currentAlignment  // Preserve alignment for new paragraph
            
            var attributes = typingAttributes
            attributes[.paragraphStyle] = newStyle
            typingAttributes = attributes
            
            // Perform the actual newline insertion
            super.insertText(string, replacementRange: replacementRange)
        } else {
            // For all other text insertions
            super.insertText(string, replacementRange: replacementRange)
        }
        
        // If we're typing after a link or inserting whitespace, remove link attributes
        if let text = string as? String,
           currentRange.location > 0,
           let textStorage = self.textStorage {
            let safeLocation = min(currentRange.location - 1, textStorage.length - 1)
            let attributes = richTextAttributes(at: NSRange(location: safeLocation, length: 1))
            
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
                let safeRange = NSRange(location: min(currentRange.location, textStorage.length), length: 0)
                textStorage.removeAttribute(.link, range: safeRange)
                textStorage.removeAttribute(.underlineStyle, range: safeRange)
                textStorage.removeAttribute(.underlineColor, range: safeRange)
            }
        }
        
        // Get the final state after insertion
        let finalRange = selectedRange
        
        // Register undo operation
        undoManager?.registerUndo(withTarget: self) { target in
            target.undoTextInsertion(
                at: currentRange,
                originalText: currentText,
                originalAttributes: currentAttributes,
                finalRange: finalRange
            )
        }
        
        // End undo grouping
        undoManager?.endUndoGrouping()
        
        // Handle markdown after undo grouping is complete
        handleMarkdownInput()
    }
    
    private func undoTextInsertion(
        at range: NSRange,
        originalText: NSAttributedString,
        originalAttributes: [NSAttributedString.Key: Any],
        finalRange: NSRange
    ) {
        guard let textStorage = self.textStorage else { return }
        
        // Begin undo grouping for the reverse operation
        undoManager?.beginUndoGrouping()
        
        // Store the current state for redo
        let redoText = textStorage.attributedSubstring(from: finalRange)
        let redoAttributes = typingAttributes
        
        // Restore the original state
        textStorage.replaceCharacters(in: finalRange, with: originalText)
        typingAttributes = originalAttributes
        selectedRange = range
        
        // Register redo operation
        undoManager?.registerUndo(withTarget: self) { target in
            target.undoTextInsertion(
                at: finalRange,
                originalText: redoText,
                originalAttributes: redoAttributes,
                finalRange: range
            )
        }
        
        // End undo grouping
        undoManager?.endUndoGrouping()
    }

    open override func deleteBackward(_ sender: Any?) {
        let currentRange = selectedRange
        
        // If there's no text storage, fall back to super
        guard let textStorage = self.textStorage else {
            super.deleteBackward(sender)
            return
        }
        
        // If there's no selection and we're at the start, nothing to delete
        if currentRange.length == 0 && currentRange.location == 0 {
            return
        }
        
        // Calculate the range to delete
        let deleteRange: NSRange
        if currentRange.length > 0 {
            // If there's a selection, delete the selected range
            deleteRange = currentRange
        } else {
            // If no selection, delete the character before the cursor
            deleteRange = NSRange(location: currentRange.location - 1, length: 1)
        }
        
        // Ensure the range is valid
        guard deleteRange.location >= 0 && 
              deleteRange.location + deleteRange.length <= textStorage.length else {
            return
        }
        
        // Begin undo grouping
        undoManager?.beginUndoGrouping()
        
        // Store the current state
        let deletedText = textStorage.attributedSubstring(from: deleteRange)
        let currentAttributes = typingAttributes
        
        // Perform the deletion directly on the text storage
        textStorage.deleteCharacters(in: deleteRange)
        
        // Update selection
        selectedRange = NSRange(location: deleteRange.location, length: 0)
        
        // Register undo operation
        undoManager?.registerUndo(withTarget: self) { target in
            // Begin undo grouping for the restore operation
            target.undoManager?.beginUndoGrouping()
            
            // Store the current state for redo
            let redoRange = target.selectedRange
            let redoAttributes = target.typingAttributes
            
            // Restore the deleted text
            if let ts = target.textStorage {
                let insertPoint = NSRange(location: deleteRange.location, length: 0)
                ts.replaceCharacters(in: insertPoint, with: deletedText)
                target.selectedRange = deleteRange
                target.typingAttributes = currentAttributes
                
                // Register redo operation
                target.undoManager?.registerUndo(withTarget: target) { redoTarget in
                    if let ts = redoTarget.textStorage {
                        ts.deleteCharacters(in: deleteRange)
                        redoTarget.selectedRange = redoRange
                        redoTarget.typingAttributes = redoAttributes
                    }
                }
            }
            
            // End undo grouping for the restore operation
            target.undoManager?.endUndoGrouping()
        }
        
        // End undo grouping
        undoManager?.endUndoGrouping()
    }

    open override func copy(_ sender: Any?) {
        copySelection()
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
            applyHighlight(greenHighlight)
        } else if colorsAreEqual(currentHighlight, greenHighlight) {
            // Green -> Red
            applyHighlight(redHighlight)
        } else if colorsAreEqual(currentHighlight, redHighlight) {
            // Red -> None
            textStorage.removeAttribute(.backgroundColor, range: selectedRange)
        } else {
            // Unknown color -> Start over with green
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

        do {
            let rtfData = try text.data(from: NSRange(location: 0, length: text.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtf])
            pasteboard.setData(rtfData, forType: .rtf)
        } catch {
            // Error handling silently
        }
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
        // Store current selection and content for undo
        let currentRange = selectedRange()
        let currentText = NSAttributedString(attributedString: textStorage?.attributedSubstring(from: currentRange) ?? NSAttributedString())
        
        let attributedString = NSMutableAttributedString(attributedString: text)
        let range = NSRange(location: 0, length: attributedString.length)
        
        cleanAttributes(attributedString, range: range, preserveColor: true)
        
        // Use textStorage to replace the text while preserving attributes
        let insertRange = selectedRange()
        if let storage = textStorage {
            // Begin undo grouping
            undoManager?.beginUndoGrouping()
            
            storage.replaceCharacters(in: insertRange, with: attributedString)
            
            // Register undo operation
            undoManager?.registerUndo(withTarget: self) { target in
                // Restore previous state on undo
                if let ts = target.textStorage {
                    target.selectedRange = currentRange
                    ts.replaceCharacters(in: NSRange(location: currentRange.location, length: attributedString.length), with: currentText)
                    target.selectedRange = currentRange
                }
            }
            
            // End undo grouping
            undoManager?.endUndoGrouping()
        }
    }
    
    private func mapFontSize(_ originalSize: CGFloat) -> CGFloat {
        let mappedSize = switch originalSize {
   case 26...:
            RichTextHeaderLevel.heading1.fontSize
        case 20..<25:
            RichTextHeaderLevel.heading2.fontSize
        case 17..<20:
            RichTextHeaderLevel.heading3.fontSize
        default:
            RichTextHeaderLevel.paragraph.fontSize
        }
        return mappedSize
    }

    private func mapLineSpacing(_ fontSize: CGFloat) -> CGFloat {
        return 10.0  // Use consistent line spacing for all text
    }

    // Override to handle keyboard shortcuts
    open override func performKeyEquivalent(with event: NSEvent) -> Bool {
        let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        let chars = event.charactersIgnoringModifiers ?? ""
        
        // Handle CMD+L
        if flags == .command && chars == "l" {
            chatButtonAction()
            return true
        }
        
        // Handle CMD+SHIFT+H
        if chars.lowercased() == "h" && flags.contains(.command) && flags.contains(.shift) {
            if selectedRange.length > 0 {
                cycleHighlight()
                return true
            }
        }

        if flags == .command && event.characters == "+" {
            zoomIn()
            return true
        }

        if flags == .command && event.characters == "-" {
            zoomOut()
            return true
        }

        // If we didn't handle it, let super try
        return super.performKeyEquivalent(with: event)
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
    
    // MARK: - Private Helper Methods
    
    // Track if we're already in an undo operation to prevent nesting
    private var isPerformingUndoOperation = false
    
    // Safely begin an undo group only if we're not already in one
    private func safelyBeginUndoGrouping() {
        guard !isPerformingUndoOperation else { return }
        isPerformingUndoOperation = true
        undoManager?.beginUndoGrouping()
    }
    
    // Safely end an undo group only if we started one
    private func safelyEndUndoGrouping() {
        guard isPerformingUndoOperation else { return }
        undoManager?.endUndoGrouping()
        isPerformingUndoOperation = false
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
