//
//  RichTextUserAction.swift
//
//
//  Created by Dominik Bucher on 07.12.2023.
//

import Foundation

enum RichTextUserInitiatedAction {
    case backgroundColor(ColorRepresentable)
    case foregroundColor(ColorRepresentable)
    case highlightedRange(NSRange?)
    case highlightingStyle(RichTextHighlightingStyle)
    case shouldPasteImage(Insertion<ImageRepresentable>)
    case shouldPasteImages(Insertion<[ImageRepresentable]>)
    case shouldPasteText(Insertion<String>)
    case shouldSelectRange(NSRange)
    case shouldSetAttributedString(NSAttributedString)
    case strikethroughColor(ColorRepresentable)
    case strokeColor(ColorRepresentable)
    case triggerAction(RichTextAction)
    case underlineColor(ColorRepresentable)
    case changeStyle(RichTextStyle, Bool)
}

extension String: Insertable {}
extension ImageRepresentable: Insertable {}
extension [ImageRepresentable]: Insertable {}
extension NSAttributedString: Insertable {}

protocol Insertable {}

struct Insertion<T: Insertable> {
    typealias Index = Int
    let content: T
    let at: Index
    let moveCursor: Bool
}
