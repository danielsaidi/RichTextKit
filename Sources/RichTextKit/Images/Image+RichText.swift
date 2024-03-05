//
//  Image+RichText.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension Image {

    static let richTextCopy = symbol("doc.on.clipboard")
    static let richTextDismissKeyboard = symbol("keyboard.chevron.compact.down")
    static let richTextEdit = symbol("square.and.pencil")
    static let richTextExport = symbol("square.and.arrow.up.on.square")
    static let richTextPrint = symbol("printer")
    static let richTextRedo = symbol("arrow.uturn.forward")
    static let richTextShare = symbol("square.and.arrow.up")
    static let richTextUndo = symbol("arrow.uturn.backward")

    static let richTextAlignmentCenter = symbol("text.aligncenter")
    static let richTextAlignmentJustified = symbol("text.justify")
    static let richTextAlignmentLeft = symbol("text.alignleft")
    static let richTextAlignmentRight = symbol("text.alignright")

    static let richTextColorBackground = symbol("highlighter")
    static let richTextColorForeground = symbol("character")
    static let richTextColorReset = symbol("circle.slash")
    static let richTextColorStroke = symbol("a.square")
    static let richTextColorStrikethrough = symbol("strikethrough")
    static let richTextColorUnderline = symbol("underline")
    static let richTextColorUndefined = symbol("questionmark.app")

    static let richTextDocument = symbol("doc.text")
    static let richTextDocuments = symbol("doc.on.doc")

    static let richTextFont = symbol("textformat")
    static let richTextFontSizeDecrease = symbol("minus")
    static let richTextFontSizeIncrease = symbol("plus")

    static let richTextFormat = symbol("textformat")
    static let richTextFormatBrush = symbol("paintbrush")

    static let richTextIndentDecrease = symbol("decrease.indent")
    static let richTextIndentIncrease = symbol("increase.indent")

    static let richTextLineSpacing = symbol("arrow.up.and.down.text.horizontal")
    static let richTextLineSpacingDecrease = symbol("minus")
    static let richTextLineSpacingIncrease = symbol("plus")

    static let richTextSelection = symbol("123.rectangle.fill")

    static let richTextStyleBold = symbol("bold")
    static let richTextStyleItalic = symbol("italic")
    static let richTextStyleStrikethrough = symbol("strikethrough")
    static let richTextStyleUnderline = symbol("underline")

    static let richTextSuperscriptDecrease = symbol("textformat.subscript")
    static let richTextSuperscriptIncrease = symbol("textformat.superscript")
}

public extension Image {

    static func richTextStepFontSize(
        _ points: Int
    ) -> Image {
        points < 0 ?
            .richTextFontSizeDecrease :
            .richTextFontSizeIncrease
    }
    
    static func richTextStepIndent(
        _ points: Double
    ) -> Image {
        points < 0 ?
            .richTextIndentDecrease :
            .richTextIndentIncrease
    }
    
    static func richTextStepLineSpacing(
        _ points: Double
    ) -> Image {
        points < 0 ?
            .richTextLineSpacingDecrease :
            .richTextLineSpacingIncrease
    }

    static func richTextStepSuperscript(
        _ steps: Int
    ) -> Image {
        steps < 0 ?
            .richTextSuperscriptDecrease :
            .richTextSuperscriptIncrease
    }
}

extension Image {

    static func symbol(_ name: String) -> Image {
        .init(systemName: name)
    }
}
