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

    // Track if we're currently handling an action to prevent recursive updates
    private static var isHandlingAction = false
    
    func handle(_ action: RichTextAction?) {
        guard let action else { return }
        
        // Prevent recursive action handling
        guard !Self.isHandlingAction else {
            return
        }
        
        Self.isHandlingAction = true
        defer { Self.isHandlingAction = false }
        
        switch action {
        case .copy: textView.copySelection()
        case .deleteSelectedText:
            textView.deleteText(in: textView.selectedRange)
        case .deleteText(let range):
            textView.deleteText(in: range)
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
        case .replaceSelectedText(let text):
            textView.replaceText(in: textView.selectedRange, with: text)
        case .replaceText(let range, let text):
            textView.replaceText(in: range, with: text)
        case .selectRange(let range):
            setSelectedRange(to: range)
        case .setAlignment(let alignment):
            // Debounce rapid alignment updates
            let currentTime = ProcessInfo.processInfo.systemUptime
            if currentTime - Self.lastAlignmentTime < Self.updateThreshold {
                return
            }
            Self.lastAlignmentTime = currentTime
            
            // Only update if alignment actually changed
            if textView.richTextAlignment == alignment {
                return
            }
            
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
            let undoManager = textView.undoManager
            undoManager?.registerUndo(withTarget: textView, handler: {
                $0.toggleRichTextStyle(style)
            })
            undoManager?.setActionName(style.title)
            setStyle(style, to: newValue)
        case .stepFontSize(let points):
            textView.stepRichTextFontSize(points: points)
            syncContextWithTextView()
        case .stepIndent(let points):
            textView.stepRichTextIndent(points: points)
        case .stepLineSpacing(let points):
            textView.stepRichTextLineSpacing(points: points)
        case .stepSuperscript(let points):
            textView.stepRichTextSuperscriptLevel(points: points)
        case .toggleStyle(let style):
            let undoManager = textView.undoManager
            undoManager?.registerUndo(withTarget: textView, handler: {
                $0.toggleRichTextStyle(style)
            })
            undoManager?.setActionName(style.title)
            textView.toggleRichTextStyle(style)
        case .undoLatestChange:
            textView.undoLatestChange()
            syncContextWithTextView()
        case .setHeaderLevel(let level):
            textView.setHeaderLevel(level)
        case .updateFontScale(let scale):
            textView.updateFontScale(to: scale)
        }
        textView.setCustomToolButtonFrameOrigin()
    }
}

extension RichTextCoordinator {

    func paste<T: RichTextInsertable>(_ data: RichTextInsertion<T>) {
        if let data = data as? RichTextInsertion<ImageRepresentable> {
            pasteImage(data)
        } else if let data = data as? RichTextInsertion<[ImageRepresentable]> {
            pasteImages(data)
        } else if let data = data as? RichTextInsertion<String> {
            pasteText(data)
        } else {
        }
    }

    func pasteImage(_ data: RichTextInsertion<ImageRepresentable>) {
        textView.pasteImage(
            data.content,
            at: data.index,
            moveCursorToPastedContent: data.moveCursor
        )
    }

    func pasteImages(_ data: RichTextInsertion<[ImageRepresentable]>) {
        textView.pasteImages(
            data.content,
            at: data.index,
            moveCursorToPastedContent: data.moveCursor
        )
    }

    func pasteText(_ data: RichTextInsertion<String>) {
        textView.pasteText(
            data.content,
            at: data.index,
            moveCursorToPastedContent: data.moveCursor
        )
    }

    // Track the last update time to prevent rapid repeated updates
    private static var lastUpdateTime: TimeInterval = 0
    private static var lastAlignmentTime: TimeInterval = 0
    private static let updateThreshold: TimeInterval = 0.1 // 100ms
    
    func setAttributedString(to newValue: NSAttributedString?) {
        guard let newValue else {
            return
        }
        
        // Debounce rapid updates
        let currentTime = ProcessInfo.processInfo.systemUptime
        if currentTime - Self.lastUpdateTime < Self.updateThreshold {
            return
        }
        Self.lastUpdateTime = currentTime
        
        // Compare strings to avoid unnecessary updates
        if textView.attributedString.string == newValue.string {
            // Only update if there are link changes
            var hasLinkChanges = false
            let fullRange = NSRange(location: 0, length: newValue.length)
            
            newValue.enumerateAttribute(.link, in: fullRange, options: []) { newLink, range, _ in
                let oldLink = textView.attributedString.attribute(.link, at: range.location, effectiveRange: nil)
                // Compare links safely by checking if either is nil or if they're different
                if let newLinkObj = newLink as? NSObject,
                   let oldLinkObj = oldLink as? NSObject {
                    if !newLinkObj.isEqual(oldLinkObj) {
                        hasLinkChanges = true
                    }
                } else if (newLink == nil) != (oldLink == nil) {
                    // One is nil and the other isn't
                    hasLinkChanges = true
                }
            }
            
            if !hasLinkChanges {
                return
            }
        }
        
        // Store current selection
        let currentRange = textView.selectedRange
        
        // Apply the update
        textView.setRichText(newValue)
        
        // Restore selection if possible
        if currentRange.location + currentRange.length <= newValue.length {
            textView.selectedRange = currentRange
        }
        
    }

    // TODO: This code should be handled by the component
    func setColor(_ color: RichTextColor, to val: ColorRepresentable) {
        var applyRange: NSRange?
        if textView.hasSelectedRange {
            applyRange = textView.selectedRange
        }
        guard let attribute = color.attribute else { return }
        if let applyRange {
            textView.setRichTextColor(color, to: val, at: applyRange)
        } else {
            textView.setRichTextAttribute(attribute, to: val)
        }
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

    func setIsEditable(to newValue: Bool) {
        #if iOS || macOS || os(visionOS)
        if newValue == textView.isEditable { return }
        textView.isEditable = newValue
        #endif
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
