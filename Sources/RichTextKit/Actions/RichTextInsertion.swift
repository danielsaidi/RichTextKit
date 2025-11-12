//
//  RichTextInsertion.swift
//  RichTextKit
//
//  Created by Dominik Bucher on 17.01.2024.
//

import Foundation

public extension RichTextInsertion {

    /// The corresponding rich text action.
    var action: RichTextAction? {
        if let insertion = self as? RichTextInsertion<ImageRepresentable> {
            return .pasteImage(insertion)
        }
        if let insertion = self as? RichTextInsertion<[ImageRepresentable]> {
            return .pasteImages(insertion)
        }
        if let insertion = self as? RichTextInsertion<String> {
            return .pasteText(insertion)
        }
        return nil
    }
}

