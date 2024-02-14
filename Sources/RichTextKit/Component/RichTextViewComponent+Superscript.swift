//
//  RichTextViewComponent+Color.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextViewComponent {

    /// Get the rich text superscript level at current range.
    var richTextSuperscriptLevel: Int? {
        #if macOS
        richTextAttribute(.superscript)
        #else
        nil
        #endif
    }

    /// Set the rich text superscript level at current range.
    func setRichTextSuperscriptLevel(to val: Int) {
        #if macOS
        setRichTextAttribute(.superscript, to: val)
        #else
        print("Unsupported platform")
        #endif
    }
    
    /// Step the rich text font size at current range.
    func stepRichTextSuperscriptLevel(points: Int) {
        let currentSize = richTextSuperscriptLevel ?? 0
        let newSize = currentSize + points
        setRichTextSuperscriptLevel(to: newSize)
    }
}
