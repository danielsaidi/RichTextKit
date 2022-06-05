//
//  RichTextViewRepresentable+Pasting.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-05.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

public extension RichTextViewRepresentable {

    /**
     Paste an image into the text view, at a certain index.

     - Parameters:
       - image: The image to paste.
       - index: The index to paste at.
       - moveCursorToPastedContent: Whether or not to move the cursor to the end of the pasted content, by default `false`.
     */
    func pasteImage(
        _ image: ImageRepresentable,
        at location: Int,
        moveCursorToPastedContent: Bool = false) {
//        guard validateImageInsert(with: imagePasteConfiguration) else { return }
//        guard let data = image.richTextData else { return }
//        let locationAfterPaste = location + 2   // Add the number of inserted "items"
//        let font = currentFont ?? .standardRichTextFont
//        guard let compressed = ImageRepresentable(data: data) else { return }
//        let attachment = ImageAttachment(image: compressed)
//        attachment.bounds = attachmentBounds(for: compressed)
//        let attachmentString = NSAttributedString(attachment: attachment)
//        let content = NSMutableAttributedString(attributedString: attributedString)
//        content.insert(NSAttributedString(string: "\n"), at: location)
//        content.insert(attachmentString, at: location)
//        attributedString = content
//        DispatchQueue.main.async {
//            self.selectedRange = NSRange(location: locationAfterPaste, length: 0)
//            self.setCurrentFont(font)
//        }
    }

    /**
     Paste images into the text view, at a certain index.

     - Parameters:
       - images: The images to paste.
       - index: The index to paste at.
       - moveCursorToPastedContent: Whether or not to move the cursor to the end of the pasted content, by default `false`.
     */
    func pasteImages(
        _ images: [ImageRepresentable],
        at index: Int,
        moveCursorToPastedContent: Bool = false
    ) {
        images.reversed().forEach {
            pasteImage($0, at: index, moveCursorToPastedContent: moveCursorToPastedContent)
        }
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
        let text = NSMutableAttributedString(string: text)
        let content = NSMutableAttributedString(attributedString: attributedString)
        let font = content.font(at: selectedRange) ?? .standardRichTextFont
        let fontRange = NSRange(location: 0, length: text.length)
        text.setFont(to: font, at: fontRange)
        content.insert(text, at: index)
        setRichText(content)
        if moveCursorToPastedContent {
            moveInputCursor(to: index + text.length)
        }
    }
}
