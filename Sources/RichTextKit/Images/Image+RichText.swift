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

    static let richTextAlignmentCenter = symbol("text.aligncenter")
    static let richTextAlignmentJustified = symbol("text.justify")
    static let richTextAlignmentLeft = symbol("text.alignleft")
    static let richTextAlignmentRight = symbol("text.alignright")

    static let richTextStyleBold = symbol("bold")
    static let richTextStyleItalic = symbol("italic")
    static let richTextStyleUnderline = symbol("underline")

    static let richTextActionCopy = symbol("doc.on.clipboard")
    static let richTextActionEdit = symbol("square.and.pencil")
    static let richTextActionRedo = symbol("arrow.uturn.forward")
    static let richTextActionUndo = symbol("arrow.uturn.backward")
}

private extension Image {

    static func symbol(_ name: String) -> Image {
        Image(systemName: name)
    }
}


struct Image_RichText_Previews: PreviewProvider {

    static var previews: some View {
        VStack(spacing: 20) {
            alignmentPreviews
            Divider()
            stylePreviews
            Divider()
            actionPreviews
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

    static var stylePreviews: some View {
        HStack {
            Image.richTextStyleBold
            Image.richTextStyleItalic
            Image.richTextStyleUnderline
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
}
