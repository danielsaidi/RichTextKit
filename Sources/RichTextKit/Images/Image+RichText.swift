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
    
    static let bold = symbol("bold")
    static let italic = symbol("italic")
    static let underline = symbol("underline")
    
    static let textAlignmentCenter = symbol("text.aligncenter")
    static let textAlignmentJustify = symbol("text.justify")
    static let textAlignmentLeft = symbol("text.alignleft")
    static let textAlignmentRight = symbol("text.alignright")
}

private extension Image {

    static func symbol(_ name: String) -> Image {
        Image(systemName: name)
    }
}


struct Image_RichText_Previews: PreviewProvider {

    static var previews: some View {
        VStack(spacing: 20) {
            Image.bold
            Image.italic
            Image.underline
            Image.textAlignmentCenter
            Image.textAlignmentJustify
            Image.textAlignmentLeft
            Image.textAlignmentRight
        }
    }
}
