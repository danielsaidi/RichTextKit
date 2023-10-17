//
//  RichTextViewComponent+Pasting.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-05.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

public extension RichTextViewComponent {

    /**
     Paste an image into the text view, at a certain index.

     For now, pasting will automatically insert the image as
     a jpeg with a 0.7 compression quality. We should expand
     this to allow us to define format, compression etc. but
     for now this is hard coded and a future TODO.

     Pasting images only works on iOS, tvOS and macOS. Other
     platform will trigger an assertion failure.

     - Parameters:
       - image: The image to paste.
       - index: The index to paste at.
       - moveCursorToPastedContent: Whether or not to move the cursor to the end of the pasted content, by default `false`.
     */
    func pasteImage(
        _ image: ImageRepresentable,
        at index: Int,
        moveCursorToPastedContent: Bool = false
    ) {
        pasteImages(
            [image],
            at: index,
            moveCursorToPastedContent: moveCursorToPastedContent
        )
    }

    /**
     Paste images into the text view, at a certain index.

     Pasting images only works on iOS, tvOS and macOS. Other
     platform will trigger an assertion failure.

     - Parameters:
       - images: The images to paste.
       - index: The index to paste at.
       - moveCursorToPastedContent: Whether or not to move the cursor to the end of the pasted content, by default `false`.
     */
    func pasteImages(
        _ images: [ImageRepresentable],
        at index: Int,
        moveCursorToPastedContent move: Bool = false
    ) {
        #if os(iOS) || os(tvOS) || os(macOS)
        guard validateImageInsertion(for: imagePasteConfiguration) else { return }
        let items = images.count * 2   // The number of inserted "items" is the images and a newline for each
        let insertRange = NSRange(location: index, length: 0)
        let safeInsertRange = safeRange(for: insertRange)
        let isSelectedRange = (index == selectedRange.location)
        if isSelectedRange { deleteCharacters(in: selectedRange) }
        if move { moveInputCursor(to: index) }
        let fontSize = currentFontSize
        images.reversed().forEach { performPasteImage($0, at: index) }
        if move { moveInputCursor(to: safeInsertRange.location + items) }
        if move || isSelectedRange, let fontSize {
            DispatchQueue.main.async {
                self.setRichTextFontSize(fontSize)
                self.moveInputCursor(to: self.selectedRange.location)
            }
        }
        #else
        assertionFailure("Image pasting is not supported on this platform")
        #endif
    }

    /**
     Paste text into the text view, at a certain index.

     - Parameters:
       - text: The text to paste.
       - index: The text index to paste at.
       - moveCursorToPastedContent: Whether or not to move the cursor to the end of the pasted content, by default `false`.
     */
    func pasteText(
        _ text: String,
        at index: Int,
        moveCursorToPastedContent: Bool = false
    ) {
        let selected = selectedRange
        let isSelectedRange = (index == selected.location)
        let content = NSMutableAttributedString(attributedString: richText)
        let insertString = NSMutableAttributedString(string: text)
        let insertRange = NSRange(location: index, length: 0)
        let safeInsertRange = safeRange(for: insertRange)
        let safeMoveIndex = safeInsertRange.location + insertString.length
        let attributes = content.richTextAttributes(at: safeInsertRange)
        let attributeRange = NSRange(location: 0, length: insertString.length)
        let safeAttributeRange = safeRange(for: attributeRange)
        insertString.setRichTextAttributes(attributes, at: safeAttributeRange)
        content.insert(insertString, at: index)
        setRichText(content)
        if moveCursorToPastedContent {
            moveInputCursor(to: safeMoveIndex)
        } else if isSelectedRange {
            moveInputCursor(to: selected.location + text.count)
        }
    }
}

#if os(iOS) || os(tvOS) || os(macOS)
private extension RichTextViewComponent {

    func getAttachmentString(
        for image: ImageRepresentable
    ) -> NSMutableAttributedString? {
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        guard let compressed = ImageRepresentable(data: data) else { return nil }
        let attachment = RichTextImageAttachment(jpegData: data)
        attachment.bounds = attachmentBounds(for: compressed)
        return NSMutableAttributedString(attachment: attachment)
    }

    func performPasteImage(
        _ image: ImageRepresentable,
        at index: Int
    ) {
        let content = NSMutableAttributedString(attributedString: richText)
        guard let insertString = getAttachmentString(for: image) else { return }
        content.insert(NSAttributedString(string: "\n"), at: index)
        content.insert(insertString, at: index)
        setRichText(content)
    }
}
#endif
