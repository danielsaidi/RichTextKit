//
//  RichTextCoordinator+Subscriptions.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(tvOS) || os(visionOS)
import SwiftUI

extension RichTextCoordinator {

    func subscribeToUserActions() {
        richTextContext.userActionPublisher.sink { [weak self] action in
            self?.handle(action)
        }
        .store(in: &cancellables)
        
        subscribeToAlignment()
        subscribeToFontName()
        subscribeToFontSize()
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
            textView.stepRichTextIndent(points: points)
        case .stepSuperscript: break
        case .toggleStyle: break
        case .undoLatestChange:
            textView.undoLatestChange()
            syncContextWithTextView()
        case .setColor(let color, let richTextColor):
            setColor(color, for: richTextColor)
        case .setHighlightedRange(let range):
            setHighlightedRange(to: range)
        case .setHighlightingStyle(let style):
            textView.highlightingStyle = style
        case .pasteImage(let image):
            pasteImage(image)
        case .pasteImages(let images):
            pasteImages(images)
        case .pasteText(let text):
            pasteText(text)
        case .selectRange(let range):
            setSelectedRange(to: range)
        case .setAttributedString(let attributedString):
            setAttributedString(to: attributedString)
        case .setStyle(let style, let newValue):
            setStyle(style, to: newValue)
        }
    }

    func subscribeToAlignment() {
        richTextContext.$textAlignment
            .sink(
                receiveValue: { [weak self] in
                    self?.textView.setRichTextAlignment($0)
                }
            )
            .store(in: &cancellables)
    }

    func subscribeToFontName() {
        richTextContext.$fontName
            .sink(
                receiveValue: { [weak self] in
                    self?.textView.setRichTextFontName($0)
                }
            )
            .store(in: &cancellables)
    }

    func subscribeToFontSize() {
        richTextContext.$fontSize
            .sink(
                receiveValue: { [weak self] in
                    self?.textView.setRichTextFontSize($0)
                }
            )
            .store(in: &cancellables)
    }

    func subscribeToIsEditingText() {
        richTextContext.$isEditingText
            .sink(
                receiveValue: { [weak self] in
                    self?.setIsEditing(to: $0)
                }
            )
            .store(in: &cancellables)
    }
}

extension RichTextCoordinator {

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
        let back = textView.richTextColor(.background, at: range) ?? .clear
        let fore = textView.richTextColor(.foreground, at: range) ?? .textColor
        highlightedRangeOriginalBackgroundColor = back
        highlightedRangeOriginalForegroundColor = fore
        let style = textView.highlightingStyle
        let background = ColorRepresentable(style.backgroundColor)
        let foreground = ColorRepresentable(style.foregroundColor)
        textView.setRichTextColor(.background, to: background, at: range)
        textView.setRichTextColor(.foreground, to: foreground, at: range)
    }

    func setIsEditing(to newValue: Bool) {
        if newValue == textView.isFirstResponder { return }
        if newValue {
#if iOS || os(visionOS)
            textView.becomeFirstResponder()
#else
            print("macOS currently doesn't resign first responder.")
#endif
        } else {
#if iOS || os(visionOS)
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
        let hasStyle = textView.richTextStyles.hasStyle(style)
        if newValue == hasStyle { return }
        textView.setRichTextStyle(style, to: newValue)
    }
}

extension ColorRepresentable {

    #if iOS || os(tvOS) || os(visionOS)
    static var textColor: ColorRepresentable { .label }
    #endif
}
#endif
