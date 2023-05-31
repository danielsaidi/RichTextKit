//
//  RichTextCoordinator.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(macOS) || os(tvOS)
import Combine
import SwiftUI

/**
 This coordinator is used to keep a ``RichTextView`` in sync
 with a ``RichTextContext``.
 
 The coordinator sets itself as the text view's delegate and
 updates the context when things change in the text view. It
 also subscribes to context observable changes and keeps the
 text view in sync with these changes.
 
 You can inherit this class to customize the coordinator for
 your own use cases.
 */
open class RichTextCoordinator: NSObject {
    
    // MARK: - Initialization
    
    /**
     Create a rich text coordinator.
     
     - Parameters:
     - text: The rich text to edit.
     - textView: The rich text view to keep in sync.
     - richTextContext: The context to keep in sync.
     */
    public init(
        text: Binding<NSAttributedString>,
        textView: RichTextView,
        richTextContext: RichTextContext,
        resize: Bool,
        calculatedHeight: Binding<CGFloat>,
        placeholder: String
    ) {
        textView.attributedString = text.wrappedValue
        self.text = text
        self.textView = textView
        self.richTextContext = richTextContext
        self.resize = resize
        self.calculatedHeight = calculatedHeight
        self.placeholder = placeholder
        super.init()
        self.textView.delegate = self
        subscribeToContextChanges()
    }
    
    
    // MARK: - Properties
    
    /**
     The rich text context for which the coordinator is used.
     */
    public let richTextContext: RichTextContext
    
    /**
     The rich text to edit.
     */
    public var text: Binding<NSAttributedString>
    
    /**
     The text view for which the coordinator is used.
     */
    public private(set) var textView: RichTextView
    
    /**
     
     */
    public var resize: Bool
    
    /**
     
     */
    public var calculatedHeight: Binding<CGFloat>
    
    /**
     
     */
    public var placeholder: String
    
    /**
     This set is used to store context observations.
     */
    public var cancellables = Set<AnyCancellable>()
    
    /**
     This test flag is used to avoid delaying context sync.
     */
    internal var shouldDelaySyncContextWithTextView = true
    
    internal var isTagging = false
    
    internal var tempContext = RichTextContext()
    internal var tagRange = NSRange()
    internal var kerning = 0.0
    
    
    // MARK: - Internal Properties
    
    /**
     The background color that was used before the currently
     highlighted range was set.
     */
    internal var highlightedRangeOriginalBackgroundColor: ColorRepresentable?
    
    /**
     The foreground color that was used before the currently
     highlighted range was set.
     */
    internal var highlightedRangeOriginalForegroundColor: ColorRepresentable?
    
    
#if canImport(UIKit)
    
    // MARK: - UITextViewDelegate
    
    open func textViewDidBeginEditing(_ textView: UITextView) {
        richTextContext.isEditingText = true
        
        if textView.text == placeholder {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    open func textViewDidChange(_ textView: UITextView) {
        //        textView.attributedText = self.resolveTags(textView: textView)
        if resize {
            recalculateHeight(view: textView, result: calculatedHeight)
        }
        syncWithTextView()
    }
    
    open func textViewDidChangeSelection(_ textView: UITextView) {
        syncWithTextView()
    }
    
    open func textViewDidEndEditing(_ textView: UITextView) {
        richTextContext.isEditingText = false
        
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    ///
    ///
    
    open func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        guard let char = text.character(at: 0) else { return true }
        richTextContext.lastTypedCharacter = char
        //        tagCheck(textView: textView, range: range, char: char, replacement: text)
        if char.isNewLineSeparator {
            // Get the current attributes of the previous character.
            var attributes: [NSAttributedString.Key: Any]
            if textView.text.isEmpty || range.location == 0 {
                attributes = textView.typingAttributes
            } else {
                let previousCharacterRange = NSRange(location: range.location - 1, length: 1)
                attributes = textView.textStorage.attributes(at: previousCharacterRange.location, effectiveRange: nil)
            }
            
            // Copy the current paragraph style and create a new one with the same properties.
            if let currentParagraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle {
                let newParagraphStyle = NSMutableParagraphStyle()
                newParagraphStyle.setParagraphStyle(currentParagraphStyle)
                attributes[.paragraphStyle] = newParagraphStyle
            }
            
            // Manually insert newline character and set the new paragraph's attributes.
            let original = NSMutableAttributedString(attributedString: textView.attributedText)
            let line = NSMutableAttributedString(string: String(char))
            
            line.addAttributes(attributes, range: NSMakeRange(0, line.string.count))
            original.append(line)
            textView.attributedText = original
            
            // Update the cursor's position.
            let newPosition = textView.position(from: textView.beginningOfDocument, offset: range.location + 1)!
            textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
            
            return false  // We've manually inserted the newline character and set its attributes, so we return false to prevent the text view from doing it again.
        }
        if char.isNonBreakingSpace {
            print("Non-Breaking")
            return false
        }
        return true
    }
    
    func textView(
        _ textView: UITextView,
        shouldInteractWithURL URL: NSURL,
        inRange characterRange: NSRange
    ) -> Bool {
        return true
    }
    
#endif
    
    
#if canImport(AppKit)
    
    // MARK: - NSTextViewDelegate
    
    open func textDidBeginEditing(_ notification: Notification) {
        richTextContext.isEditingText = true
        
        if textView.text == placeholder {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    open func textDidChange(_ notification: Notification) {
        syncWithTextView()
    }
    
    open func textViewDidChangeSelection(_ notification: Notification) {
        syncWithTextView()
    }
    
    open func textDidEndEditing(_ notification: Notification) {
        richTextContext.isEditingText = false
        
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
    }
#endif
    
    public func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height // !! must be called asynchronously
            }
        }
    }
    
    open func copyContext(from context: RichTextContext) -> RichTextContext {
        let newContext = RichTextContext()
        
        newContext.foregroundColor = context.foregroundColor
        newContext.backgroundColor = context.backgroundColor
        newContext.isBold = context.isBold
        newContext.isItalic = context.isItalic
        newContext.isUnderlined = context.isUnderlined
        
        return newContext
    }
}


#if os(iOS) || os(tvOS)
import UIKit

extension RichTextCoordinator: UITextViewDelegate {}

#elseif os(macOS)
import AppKit

extension RichTextCoordinator: NSTextViewDelegate {}
#endif


// MARK: - Public Extensions

public extension RichTextCoordinator {
    
    /**
     Reset the apperance for the currently highlighted range,
     if any.
     */
    func resetHighlightedRangeAppearance() {
        guard
            let range = richTextContext.highlightedRange,
            let background = highlightedRangeOriginalBackgroundColor,
            let text = highlightedRangeOriginalForegroundColor
        else { return }
        textView.setBackgroundColor(to: background, at: range)
        textView.setForegroundColor(to: text, at: range)
    }
}


// MARK: - Internal Extensions

extension RichTextCoordinator {
    
    /**
     Sync state from the text view's current state.
     */
    func syncWithTextView() {
        syncContextWithTextView()
        syncTextWithTextView()
    }
    
    /**
     Sync the rich text context with the text view.
     */
    func syncContextWithTextView() {
        if shouldDelaySyncContextWithTextView {
            DispatchQueue.main.async {
                self.syncContextWithTextViewAfterDelay()
            }
        } else {
            syncContextWithTextViewAfterDelay()
        }
    }
    
    /**
     Sync the rich text context with the text view after the
     dispatch queue delay above. The delay will silence some
     purple alert warnings about how state is updated.
     */
    func syncContextWithTextViewAfterDelay() {
        let styles = textView.currentRichTextStyles
        
        let range = textView.selectedRange
        if richTextContext.selectedRange != range {
            richTextContext.selectedRange = range
        }
        
        let background = textView.currentBackgroundColor
        if richTextContext.backgroundColor != background {
            richTextContext.backgroundColor = background
        }
        
        let hasRange = textView.hasSelectedRange
        if richTextContext.canCopy != hasRange {
            richTextContext.canCopy = hasRange
        }
        
        let canRedo = textView.undoManager?.canRedo ?? false
        if richTextContext.canRedoLatestChange != canRedo {
            richTextContext.canRedoLatestChange = canRedo
        }
        
        let canUndo = textView.undoManager?.canUndo ?? false
        if richTextContext.canUndoLatestChange != canUndo {
            richTextContext.canUndoLatestChange = canUndo
        }
        
        let fontName = textView.currentFontName ?? ""
        if richTextContext.fontName != fontName {
            richTextContext.fontName = fontName
        }
        
        let fontSize = textView.currentFontSize ?? .standardRichTextFontSize
        if richTextContext.fontSize != fontSize {
            richTextContext.fontSize = fontSize
        }
        
        let foreground = textView.currentForegroundColor
        if richTextContext.foregroundColor != foreground {
            richTextContext.foregroundColor = foreground
        }
        
        let isBold = styles.hasStyle(.bold)
        if richTextContext.isBold != isBold {
            richTextContext.isBold = isBold
        }
        
        let isItalic = styles.hasStyle(.italic)
        if richTextContext.isItalic != isItalic {
            richTextContext.isItalic = isItalic
        }
        
        let isStrikethrough = styles.hasStyle(.strikethrough)
        if richTextContext.isStrikethrough != isStrikethrough {
            richTextContext.isStrikethrough = isStrikethrough
        }
        
        let isUnderlined = styles.hasStyle(.underlined)
        if richTextContext.isUnderlined != isUnderlined {
            richTextContext.isUnderlined = isUnderlined
        }
        
        let isEditingText = textView.isFirstResponder
        if richTextContext.isEditingText != isEditingText {
            richTextContext.isEditingText = isEditingText
        }
        
        let textAlignment = textView.currentRichTextAlignment ?? .left
        if richTextContext.textAlignment != textAlignment {
            richTextContext.textAlignment = textAlignment
        }
        
        let textIndent = RichTextIndent.increase
        if richTextContext.textIndent != textIndent {
            richTextContext.textIndent = textIndent
        }
        
        updateTextViewAttributesIfNeeded()
    }
    
    /**
     Sync the text binding with the text view.
     */
    func syncTextWithTextView() {
        DispatchQueue.main.async {
            self.text.wrappedValue = self.textView.attributedString
        }
    }
    
    /**
     On macOS, we have to update the font and colors when we
     move the text input cursor and there's no selected text.
     
     The code looks very strange, but setting current values
     to the current values will reset the text view in a way
     that is otherwise not done correctly.
     
     To try out the incorrect behavior, comment out the code
     below, then change font size, colors etc. for a part of
     the text then move the input cursor around. When you do,
     the presented information will be correct, but when you
     type, the last selected font, colors etc. will be used.
     */
    func updateTextViewAttributesIfNeeded() {
#if os(macOS)
        if textView.hasSelectedRange { return }
        let attributes = textView.currentRichTextAttributes
        textView.setCurrentRichTextAttributes(attributes)
#endif
    }
}
#endif
