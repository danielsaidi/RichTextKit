//
//  RichTextCoordinator+Subscriptions.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(macOS) || os(tvOS)
import SwiftUI

extension RichTextCoordinator {

    /**
     Make the coordinator subscribe to context changes.
     */
    func subscribeToContextChanges() {
        subscribeToAlignment()
        subscribeToBackgroundColor()
        subscribeToFontName()
        subscribeToFontSize()
        subscribeToForegroundColor()
        subscribeToHighlightedRange()
        subscribeToIsBold()
        subscribeToIsEditingText()
        subscribeToIsItalic()
        subscribeToIsUnderlined()
        subscribeToSelectedRange()
        subscribeToShouldCopySelection()
        subscribeToShouldPasteText()
        subscribeToShouldRedoLatestChange()
        subscribeToShouldUndoLatestChange()
    }
}

private extension RichTextCoordinator {

    func subscribeToAlignment() {
        context.$alignment
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setAlignment(to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToBackgroundColor() {
        context.$backgroundColor
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setBackgroundColor(to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToFontName() {
        context.$fontName
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setFontName(to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToFontSize() {
        context.$fontSize
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setFontSize(to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToForegroundColor() {
        context.$foregroundColor
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setForegroundColor(to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToHighlightedRange() {
        context.$highlightedRange
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setHighlightedRange(to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToIsBold() {
        context.$isBold
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setStyle(.bold, to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToIsEditingText() {
        context.$isEditingText
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setIsEditing(to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToIsItalic() {
        context.$isItalic
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setStyle(.italic, to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToIsUnderlined() {
        context.$isUnderlined
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setStyle(.underlined, to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToSelectedRange() {
        context.$selectedRange
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setSelectedRange(to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToShouldCopySelection() {
        context.$shouldCopySelection
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.copySelection($0) })
            .store(in: &cancellables)
    }

    func subscribeToShouldPasteImage() {
        context.$shouldPasteImage
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.pasteImage($0) })
            .store(in: &cancellables)
    }

    func subscribeToShouldPasteImages() {
        context.$shouldPasteImages
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.pasteImages($0) })
            .store(in: &cancellables)
    }

    func subscribeToShouldPasteText() {
        context.$shouldPasteText
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.pasteText($0) })
            .store(in: &cancellables)
    }

    func subscribeToShouldRedoLatestChange() {
        context.$shouldRedoLatestChange
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.redoLatestChange($0) })
            .store(in: &cancellables)
    }

    func subscribeToShouldUndoLatestChange() {
        context.$shouldUndoLatestChange
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.undoLatestChange($0) })
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
            moveCursorToPastedContent: data.moveCursor)
    }

    func pasteImages(_ data: (images: [ImageRepresentable], atIndex: Int, moveCursor: Bool)?) {
        guard let data = data else { return }
        textView.pasteImages(
            data.images,
            at: data.atIndex,
            moveCursorToPastedContent: data.moveCursor)
    }

    func pasteText(_ data: (text: String, atIndex: Int, moveCursor: Bool)?) {
        guard let data = data else { return }
        textView.pasteText(
            data.text,
            at: data.atIndex,
            moveCursorToPastedContent: data.moveCursor)
    }

    func redoLatestChange(_ shouldRedo: Bool) {
        guard shouldRedo else { return }
        textView.redoLatestChange()
        syncContextWithTextView()
    }

    func resetHighlightedRangeAppearance() {
        guard
            let range = context.highlightedRange,
            let background = highlightedRangeOriginalBackgroundColor,
            let foreground = highlightedRangeOriginalForegroundColor
        else { return }
        textView.setBackgroundColor(to: background, at: range)
        textView.setForegroundColor(to: foreground, at: range)
    }

    func setAlignment(to newValue: RichTextAlignment) {
        if newValue == textView.currentRichTextAlignment { return }
        textView.setCurrentRichTextAlignment(to: newValue)
    }

    func setBackgroundColor(to newValue: ColorRepresentable?) {
        if newValue == textView.currentBackgroundColor { return }
        guard let color = newValue else { return }
        textView.setCurrentBackgroundColor(to: color)
    }

    func setFontName(to newValue: String) {
        if newValue == textView.currentFontName { return }
        textView.setCurrentFontName(to: newValue)
    }

    func setFontSize(to size: CGFloat) {
        if isSteppingFontSize { return }
        if size == textView.currentFontSize { return }
        textView.setCurrentFontSize(to: size)
    }

    func setForegroundColor(to newValue: ColorRepresentable?) {
        if textView.currentForegroundColor == newValue { return }
        guard let color = newValue else { return }
        textView.setCurrentForegroundColor(to: color)
    }

    func setHighlightedRange(to range: NSRange?) {
        resetHighlightedRangeAppearance()
        guard let range = range else { return }
        setHighlightedRangeAppearance(for: range)
    }

    func setHighlightedRangeAppearance(for range: NSRange) {
        highlightedRangeOriginalBackgroundColor = textView.backgroundColor(at: range) ?? .clear
        highlightedRangeOriginalForegroundColor = textView.foregroundColor(at: range) ?? .textColor
        let style = textView.highlightingStyle
        let background = ColorRepresentable(style.backgroundColor)
        let foreground = ColorRepresentable(style.foregroundColor)
        textView.setBackgroundColor(to: background, at: range)
        textView.setForegroundColor(to: foreground, at: range)
    }

    func setIsEditing(to newValue: Bool) {
        if newValue == textView.isFirstResponder { return }
        if newValue {
            textView.becomeFirstResponder()
        } else {
            textView.resignFirstResponder()
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
