//
//  RichTextCoordinator+Subscriptions.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || tvOS
import SwiftUI

extension RichTextCoordinator {
    
    func subscribeToUserActions() {
        richTextContext.userInitiatedActionPublisher.sink { [weak self] action in
            switch action {
            case .changeStyle(let style, let newValue):
                self?.setStyle(style, to: newValue)
            case .triggerAction(let action):
                self?.handle(action)
            case .shouldPasteImage(let insertion):
                // TODO: Only one paste action and switch in other function?
                self?.pasteImage(insertion)
            case .shouldPasteImages(let images):
                self?.pasteImages(images)
            case .shouldPasteText(let text):
                // TODO: Is this even used?
                self?.pasteText(text)
            case .shouldSelectRange(let range):
                // TODO: Is this even used?
                self?.setSelectedRange(to: range)
            case .shouldSetAttributedString(let attributedString):
                // TODO: Is this even used?
                self?.setAttributedString(to: attributedString)
            case .strikethroughColor(let color):
                self?.setColor(color, for: .strikethrough)
            case .strokeColor(let color):
                self?.setColor(color, for: .stroke)
            case .foregroundColor(let color):
                self?.setColor(color, for: .foreground)
            case .backgroundColor(let color):
                self?.setColor(color, for: .background)
            case .highlightedRange(let range):
                self?.setHighlightedRange(to: range)
            case .highlightingStyle(let style):
                self?.textView.highlightingStyle = style
            }
        }
        .store(in: &cancellables)
        
        // TODO: Alignment is binded to buttons, way much easier to maintain it like this.
        subscribeToAlignment()
        subscribeToFontName()
        subscribeToFontSize()
        // TODO: Is this needed?
        subscribeToIsEditingText()
    }
}

private extension RichTextCoordinator {
    func handle(_ action: RichTextAction?) {
        guard let action else { return }
        switch action {
        case .copy:
            textView.copySelection()
        case .dismissKeyboard:
            textView.resignFirstResponder()
        case .print: break
        case .redoLatestChange:
            textView.redoLatestChange()
            syncContextWithTextView()
        case .setAlignment: break
        case .stepFontSize: break
        case .stepIndent(let points):
            textView.stepCurrentIndent(points: points)
        case .stepSuperscript: break
        case .toggleStyle: break
        case .undoLatestChange:
            textView.undoLatestChange()
            syncContextWithTextView()
        }
    }

    func subscribeToIsEditingText() {
        richTextContext.$isEditingText
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.setIsEditing(to: $0)
                })
            .store(in: &cancellables)
    }

    func subscribeToAlignment() {
        richTextContext.$textAlignment
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.textView.setCurrentTextAlignment($0)
                })
            .store(in: &cancellables)
    }

    func subscribeToFontName() {
        richTextContext.$fontName
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.textView.setCurrentFontName($0)
                })
            .store(in: &cancellables)
    }

    func subscribeToFontSize() {
        richTextContext.$fontSize
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.textView.setCurrentFontSize($0)
                })
            .store(in: &cancellables)
    }
}

internal extension RichTextCoordinator {
    
    func pasteImage(_ data: Insertion<ImageRepresentable>?) {
        guard let data = data else { return }
        textView.pasteImage(
            data.content,
            at: data.at,
            moveCursorToPastedContent: data.moveCursor
        )
    }
    
    func pasteImages(_ data: Insertion<[ImageRepresentable]>?) {
        guard let data = data else { return }
        textView.pasteImages(
            data.content,
            at: data.at,
            moveCursorToPastedContent: data.moveCursor
        )
    }
    
    func pasteText(_ data: Insertion<String>?) {
        guard let data = data else { return }
        textView.pasteText(
            data.content,
            at: data.at,
            moveCursorToPastedContent: data.moveCursor
        )
    }
    
    func setAttributedString(to newValue: NSAttributedString?) {
        guard let newValue else { return }
        textView.setRichText(newValue)
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
    
    func setIsEditing(to newValue: Bool) {
        if newValue == textView.isFirstResponder { return }
        if newValue {
#if iOS
            textView.becomeFirstResponder()
#else
            print("macOS currently doesn't resign first responder.")
#endif
        } else {
#if iOS
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
        let hasStyle = textView.currentRichTextTypingAttributeStyles.hasStyle(style)
        if newValue == hasStyle { return }
        if textView.hasSelectedRange {
            textView.applyToCurrentSelection(style, to: newValue)
        } else {
            textView.setCurrentRichTextStyleTypingAttributes(style, to: newValue)
        }
    }
}

public extension ColorRepresentable {
    
#if iOS || tvOS
    static var textColor: ColorRepresentable { .label }
#endif
}
#endif
