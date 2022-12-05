//
//  RichTextViewRepresentable+Font.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import CoreGraphics
import Foundation

public extension RichTextViewRepresentable {

    /**
     Use the selected range (if any) or text position to get
     the current link URL.
     */
    var currentLink: URL? {
        currentRichTextAttributes[.link] as? URL
    }


    /**
     Use the selected range (if any) or text position to set
     the current font.

     - Parameters:
       - font: The font to set.
     */
    func setCurrentLink(to url: URL?) {
        setCurrentRichTextAttribute(.link, to: url)
    }
}
