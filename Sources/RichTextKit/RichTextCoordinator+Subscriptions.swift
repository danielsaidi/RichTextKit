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
        subscribeToIsBold()
        subscribeToIsEditingText()
        subscribeToIsItalic()
        subscribeToIsUnderlined()
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

    func subscribeToShouldRedoLatestChange() {
        context.$shouldRedoLatestChange
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.redoLastChange($0) })
            .store(in: &cancellables)
    }

    func subscribeToShouldUndoLatestChange() {
        context.$shouldUndoLatestChange
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.undoLastChange($0) })
            .store(in: &cancellables)
    }
}

private extension RichTextCoordinator {

    func redoLastChange(_ shouldRedo: Bool) {
        guard shouldRedo else { return }
        textView.undoManager?.redo()
        syncContextWithTextView()
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

    func setIsEditing(to newValue: Bool) {
        if newValue == textView.isFirstResponder { return }
        if newValue {
            textView.becomeFirstResponder()
        } else {
            textView.resignFirstResponder()
        }
    }

    func setStyle(_ style: RichTextStyle, to newValue: Bool) {
        let hasStyle = textView.currentRichTextStyles.hasStyle(style)
        if newValue == hasStyle { return }
        textView.setCurrentRichTextStyle(style, to: newValue)
    }

    func undoLastChange(_ shouldUndo: Bool) {
        guard shouldUndo else { return }
        textView.undoManager?.undo()
        syncContextWithTextView()
    }
}
#endif
