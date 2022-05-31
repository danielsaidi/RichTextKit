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

    static let alignmentCenter = symbol("text.aligncenter")
    static let alignmentJustified = symbol("text.justify")
    static let alignmentLeft = symbol("text.alignleft")
    static let alignmentRight = symbol("text.alignright")

    static let bold = symbol("bold")
    static let italic = symbol("italic")
    static let underline = symbol("underline")

    static let edit = symbol("square.and.pencil")
    static let redo = symbol("arrow.uturn.forward")
    static let undo = symbol("arrow.uturn.backward")
}

private extension Image {

    static func symbol(_ name: String) -> Image {
        Image(systemName: name)
    }
}


struct Image_RichText_Previews: PreviewProvider {

    static var previews: some View {
        VStack(spacing: 20) {
            Image.alignmentCenter
            Image.alignmentJustified
            Image.alignmentLeft
            Image.alignmentRight
            Divider()
            Image.bold
            Image.italic
            Image.underline
            Divider()
            Image.edit
        }
    }
}
