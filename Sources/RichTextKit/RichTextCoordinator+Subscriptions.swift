//
//  RichTextCoordinator+Subscriptions.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(macOS) || os(tvOS)
import SwiftUI

extension RichTextCoordinator {

    /// Make the coordinator subscribe to context changes.
    func subscribeToContextChanges() {
        subscribeToAlignment()
        subscribeToBackgroundColor()
        subscribeToFontName()
        subscribeToFontSize()
        subscribeToForegroundColor()
        subscribeToHighlightedRange()
        subscribeToHighlightingStyle()
        subscribeToIsBold()
        subscribeToIsEditingText()
        subscribeToIsItalic()
        subscribeToIsStrikethrough()
        subscribeToIsUnderlined()
        subscribeToShouldCopySelection()
        subscribeToShouldPasteImage()
        subscribeToShouldPasteImages()
        subscribeToShouldPasteText()
        subscribeToShouldRedoLatestChange()
        subscribeToShouldSelectRange()
        subscribeToShouldSetAttributedString()
        subscribeToShouldStepTextIndent()
        subscribeToShouldUndoLatestChange()
    }
}

private extension RichTextCoordinator {

    func subscribeToAlignment() {
        richTextContext.$textAlignment
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setAlignment(to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToBackgroundColor() {
        richTextContext.$backgroundColor
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setBackgroundColor(to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToFontName() {
        richTextContext.$fontName
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setFontName(to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToFontSize() {
        richTextContext.$fontSize
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setFontSize(to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToForegroundColor() {
        richTextContext.$foregroundColor
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setForegroundColor(to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToHighlightedRange() {
        richTextContext.$highlightedRange
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setHighlightedRange(to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToHighlightingStyle() {
        richTextContext.$highlightingStyle
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setHighlightingStyle(to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToIsBold() {
        richTextContext.$isBold
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setStyle(.bold, to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToIsEditingText() {
        richTextContext.$isEditingText
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setIsEditing(to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToIsItalic() {
        richTextContext.$isItalic
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setStyle(.italic, to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToIsStrikethrough() {
        richTextContext.$isStrikethrough
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setStyle(.strikethrough, to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToIsUnderlined() {
        richTextContext.$isUnderlined
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setStyle(.underlined, to: $0) })
            .store(in: &cancellables)
    }
    
    func subscribeToShouldCopySelection() {
        richTextContext.$shouldCopySelection
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.copySelection($0) })
            .store(in: &cancellables)
    }

    func subscribeToShouldPasteImage() {
        richTextContext.$shouldPasteImage
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.pasteImage($0) })
            .store(in: &cancellables)
    }

    func subscribeToShouldPasteImages() {
        richTextContext.$shouldPasteImages
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.pasteImages($0) })
            .store(in: &cancellables)
    }

    func subscribeToShouldPasteText() {
        richTextContext.$shouldPasteText
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.pasteText($0) })
            .store(in: &cancellables)
    }

    func subscribeToShouldRedoLatestChange() {
        richTextContext.$shouldRedoLatestChange
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.redoLatestChange($0) })
            .store(in: &cancellables)
    }

    func subscribeToShouldSetAttributedString() {
        richTextContext.$shouldSetAttributedString
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setAttributedString(to: $0) })
            .store(in: &cancellables)
    }
    
    func subscribeToShouldSelectRange() {
        richTextContext.$shouldSelectRange
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setSelectedRange(to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToShouldUndoLatestChange() {
        richTextContext.$shouldUndoLatestChange
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.undoLatestChange($0) })
            .store(in: &cancellables)
    }
    
    func subscribeToShouldStepTextIndent() {
        richTextContext.$shouldStepIndentPoints
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    guard let points = $0 else { return }
                    self?.stepTextIndent(points: points)
                }
            )
            .store(in: &cancellables)
    }
}

internal extension RichTextCoordinator {

    func copySelection(_ shouldCopy: Bool) {
        guard shouldCopy else { return }
        textView.copySelection()
    }

    func pasteImage(_ data: (image: ImageRepresentable, atIndex: Int, moveCursor: Bool)?) {
        guard let data = data else { return }
        textView.pasteImage(
            data.image,
            at: data.atIndex,
            moveCursorToPastedContent: data.moveCursor
        )
    }

    func pasteImages(_ data: (images: [ImageRepresentable], atIndex: Int, moveCursor: Bool)?) {
        guard let data = data else { return }
        textView.pasteImages(
            data.images,
            at: data.atIndex,
            moveCursorToPastedContent: data.moveCursor
        )
    }

    func pasteText(_ data: (text: String, atIndex: Int, moveCursor: Bool)?) {
        guard let data = data else { return }
        textView.pasteText(
            data.text,
            at: data.atIndex,
            moveCursorToPastedContent: data.moveCursor
        )
    }

    func redoLatestChange(_ shouldRedo: Bool) {
        guard shouldRedo else { return }
        textView.redoLatestChange()
        syncContextWithTextView()
    }

    func setAlignment(to newValue: RichTextAlignment) {
        if newValue == textView.currentTextAlignment { return }
        textView.setCurrentTextAlignment(newValue)
    }

    func setAttributedString(to newValue: NSAttributedString?) {
        guard let newValue else { return }
        textView.setRichText(newValue)
    }

    func setBackgroundColor(to newValue: ColorRepresentable?) {
        if newValue == textView.currentBackgroundColor { return }
        guard let color = newValue else { return }
        textView.setCurrentBackgroundColor(color)
    }

    func setFontName(to newValue: String) {
        if newValue == textView.currentFontName { return }
        textView.setCurrentFontName(newValue)
    }

    func setFontSize(to size: CGFloat) {
        if size == textView.currentFontSize { return }
        textView.setCurrentFontSize(size)
    }

    func setForegroundColor(to newValue: ColorRepresentable?) {
        if textView.currentForegroundColor == newValue { return }
        guard let color = newValue else { return }
        textView.setCurrentForegroundColor(color)
    }

    func setHighlightedRange(to range: NSRange?) {
        resetHighlightedRangeAppearance()
        guard let range = range else { return }
        setHighlightedRangeAppearance(for: range)
    }

    func setHighlightedRangeAppearance(for range: NSRange) {
        highlightedRangeOriginalBackgroundColor = textView.richTextBackgroundColor(at: range) ?? .clear
        highlightedRangeOriginalForegroundColor = textView.richTextForegroundColor(at: range) ?? .textColor
        let style = textView.highlightingStyle
        let background = ColorRepresentable(style.backgroundColor)
        let text = ColorRepresentable(style.foregroundColor)
        textView.setRichTextBackgroundColor(background, at: range)
        textView.setRichTextForegroundColor(text, at: range)
    }

    func setHighlightingStyle(to style: RichTextHighlightingStyle) {
        textView.highlightingStyle = style
    }
    
    func stepTextIndent(points: CGFloat) {
        textView.stepCurrentRichTextIndent(points: points)
    }

    func setIsEditing(to newValue: Bool) {
        if newValue == textView.isFirstResponder { return }
        if newValue {
#if os(iOS)
            textView.becomeFirstResponder()
#else
            print("macOS currently doesn't resign first responder.")
#endif
        } else {
#if os(iOS)
            textView.resignFirstResponder()
#else
            print("macOS currently doesn't resign first responder.")
#endif
        }
    }

    func setSelectedRange(to range: NSRange) {
        if range == textView.selectedRange { return }
        textView.selectedRange = range
    }

    func setStyle(_ style: RichTextStyle, to newValue: Bool) {
        let hasStyle = textView.currentRichTextStyles.hasStyle(style)
        if newValue == hasStyle { return }
        textView.setCurrentRichTextStyle(style, to: newValue)
    }

    func undoLatestChange(_ shouldUndo: Bool) {
        guard shouldUndo else { return }
        textView.undoLatestChange()
        syncContextWithTextView()
    }
}

private extension ColorRepresentable {

    #if os(iOS) || os(tvOS)
    static var textColor: ColorRepresentable { .label }
    #endif
}
#endif
