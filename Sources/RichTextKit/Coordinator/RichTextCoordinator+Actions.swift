//
//  RichTextCoordinator+Actions.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(tvOS) || os(visionOS)
import SwiftUI

extension RichTextCoordinator {

    func handle(_ action: RichTextAction?) {
        guard let action else { return }
        switch action {
        case .copy: textView.copySelection()
        case .dismissKeyboard:
            textView.resignFirstResponder()
        case .pasteImage(let image):
            pasteImage(image)
        case .pasteImages(let images):
            pasteImages(images)
        case .pasteText(let text):
            pasteText(text)
        case .print:
            break
        case .redoLatestChange:
            textView.redoLatestChange()
            syncContextWithTextView()
        case .selectRange(let range):
            setSelectedRange(to: range)
        case .setAlignment(let alignment):
            textView.setRichTextAlignment(alignment)
        case .setAttributedString(let string):
            setAttributedString(to: string)
        case .setColor(let color, let newValue):
            setColor(color, to: newValue)
        case .setHighlightedRange(let range):
            setHighlightedRange(to: range)
        case .setHighlightingStyle(let style):
            textView.highlightingStyle = style
        case .setStyle(let style, let newValue):
            setStyle(style, to: newValue)
        case .stepFontSize(let points):
            textView.stepRichTextFontSize(points: points)
        case .stepIndent(let points):
            textView.stepRichTextIndent(points: points)
        case .stepLineSpacing(let points):
            textView.stepRichTextLineSpacing(points: points)
        case .stepSuperscript(let points):
            textView.stepRichTextSuperscriptLevel(points: points)
        case .toggleStyle(let style):
            textView.toggleRichTextStyle(style)
        case .undoLatestChange:
            textView.undoLatestChange()
            syncContextWithTextView()
        }
    }
}

extension RichTextCoordinator {

    func pasteImage(_ data: RichTextInsertion<ImageRepresentable>?) {
        guard let data = data else { return }
        textView.pasteImage(
            data.content,
            at: data.at,
            moveCursorToPastedContent: data.moveCursor
        )
    }

    func pasteImages(_ data: RichTextInsertion<[ImageRepresentable]>?) {
        guard let data = data else { return }
        textView.pasteImages(
            data.content,
            at: data.at,
            moveCursorToPastedContent: data.moveCursor
        )
    }

    func pasteText(_ data: RichTextInsertion<String>?) {
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
    public static var textColor: ColorRepresentable { .label }
    #endif
}
#endif
