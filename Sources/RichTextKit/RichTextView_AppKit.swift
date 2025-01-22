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

        // Calculate the position of the container below the selection
        let layoutManager = self.layoutManager!
        let glyphRange = layoutManager.glyphRange(forCharacterRange: selectedRange, actualCharacterRange: nil)
        let boundingRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: self.textContainer!)
        let containerOrigin = self.textContainerOrigin

        // Convert the bounding rectangle to view coordinates
        let buttonPosition = NSPoint(x: boundingRect.maxX + containerOrigin.x + 5, // Offset slightly to the right
                                     y: boundingRect.minY + containerOrigin.y + self.frame.origin.y - 4)

       containerView.setFrameOrigin(buttonPosition)
    }

    @objc private func recordButtonAction() {
        print("Record button action on selected text:")
        // Add custom behavior for Record Button here
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
        print("NSTextView lost focus")
        return super.resignFirstResponder()
    }

}

#endif
