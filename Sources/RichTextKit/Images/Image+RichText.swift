//
//  Image+RichText.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This extension defines rich text-specific images.
 */
public extension Image {

    static let richTextActionCopy = symbol("doc.on.clipboard")
    static let richTextActionDismissKeyboard = symbol("keyboard.chevron.compact.down")
    static let richTextActionEdit = symbol("square.and.pencil")
    static let richTextActionRedo = symbol("arrow.uturn.forward")
    static let richTextActionUndo = symbol("arrow.uturn.backward")

    static let richTextAlignmentCenter = symbol("text.aligncenter")
    static let richTextAlignmentJustified = symbol("text.justify")
    static let richTextAlignmentLeft = symbol("text.alignleft")
    static let richTextAlignmentRight = symbol("text.alignright")

    static let richTextColorBackground = symbol("highlighter")
    static let richTextColorForeground = symbol("character")

    static let richTextDocument = symbol("doc.text")
    static let richTextDocuments = symbol("doc.on.doc")

    static let richTextFont = symbol("textformat")
    static let richTextFontSizeDecrement = symbol("minus")
    static let richTextFontSizeIncrement = symbol("plus")

    static let richTextFormat = symbol("textformat")
    static let richTextFormatBrush = symbol("paintbrush")

    static let richTextMenuExport = symbol("square.and.arrow.up.on.square")
    static let richTextMenuPrint = symbol("printer")
    static let richTextMenuShare = symbol("square.and.arrow.up")

    static let richTextStyleBold = symbol("bold")
    static let richTextStyleItalic = symbol("italic")
    static let richTextStyleStrikethrough = symbol("strikethrough")
    static let richTextStyleUnderline = symbol("underline")
}

private extension Image {

    static func symbol(_ name: String) -> Image {
        Image(systemName: name)
    }
}

struct Image_RichText_Previews: PreviewProvider {

    static var previews: some View {
        VStack(spacing: 20) {
            actionPreviews
            alignmentPreviews
            fontPreviews
            formatPreviews
            menuPreviews
            stylePreviews
        }
    }

    static var actionPreviews: some View {
        HStack {
            Image.richTextActionCopy
            Image.richTextActionEdit
            Image.richTextActionRedo
            Image.richTextActionUndo
        }
    }

    static var alignmentPreviews: some View {
        HStack {
            Image.richTextAlignmentCenter
            Image.richTextAlignmentJustified
            Image.richTextAlignmentLeft
            Image.richTextAlignmentRight
        }
    }

    static var fontPreviews: some View {
        HStack {
            Image.richTextFont
            Image.richTextFontSizeDecrement
            Image.richTextFontSizeIncrement
        }
    }

    static var formatPreviews: some View {
        HStack {
            Image.richTextFormat
            Image.richTextFormatBrush
        }
    }

    static var menuPreviews: some View {
        HStack {
            Image.richTextMenuExport
            Image.richTextMenuShare
        }
    }

    static var stylePreviews: some View {
        HStack {
            Image.richTextStyleBold
            Image.richTextStyleItalic
            Image.richTextStyleStrikethrough
            Image.richTextStyleUnderline
        }
    }
}
