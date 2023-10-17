//
//  Image+RichText.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension Image {

    static let richTextActionCopy = symbol("doc.on.clipboard")
    static let richTextActionDismissKeyboard = symbol("keyboard.chevron.compact.down")
    static let richTextActionEdit = symbol("square.and.pencil")
    static let richTextActionExport = symbol("square.and.arrow.up.on.square")
    static let richTextActionPrint = symbol("printer")
    static let richTextActionRedo = symbol("arrow.uturn.forward")
    static let richTextActionShare = symbol("square.and.arrow.up")
    static let richTextActionUndo = symbol("arrow.uturn.backward")
    
    static let richTextAlignmentCenter = symbol("text.aligncenter")
    static let richTextAlignmentJustified = symbol("text.justify")
    static let richTextAlignmentLeft = symbol("text.alignleft")
    static let richTextAlignmentRight = symbol("text.alignright")
    
    static let richTextColorBackground = symbol("highlighter")
    static let richTextColorForeground = symbol("character")
    static let richTextColorStroke = symbol("a.square")
    static let richTextColorStrikethrough = symbol("strikethrough")
    
    static let richTextDocument = symbol("doc.text")
    static let richTextDocuments = symbol("doc.on.doc")

    static let richTextFont = symbol("textformat")
    static let richTextFontSizeDecrease = symbol("minus")
    static let richTextFontSizeIncrease = symbol("plus")

    static let richTextFormat = symbol("textformat")
    static let richTextFormatBrush = symbol("paintbrush")

    static let richTextIndentDecrease = symbol("decrease.indent")
    static let richTextIndentIncrease = symbol("increase.indent")

    static let richTextStyleBold = symbol("bold")
    static let richTextStyleItalic = symbol("italic")
    static let richTextStyleStrikethrough = symbol("strikethrough")
    static let richTextStyleUnderline = symbol("underline")

    static let richTextSuperscriptDecrease = symbol("textformat.subscript")
    static let richTextSuperscriptIncrease = symbol("textformat.superscript")
}

private extension Image {

    static func symbol(_ name: String) -> Image {
        Image(systemName: name)
    }
}
