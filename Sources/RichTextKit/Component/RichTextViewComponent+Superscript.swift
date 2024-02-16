//
//  RichTextViewComponent+Color.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-02-14.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextViewComponent {

    /// Get the superscript level.
    var richTextSuperscriptLevel: Int? {
        #if macOS
        richTextAttribute(.superscript)
        #else
        nil
        #endif
    }

    /// Set the superscript level.
    func setRichTextSuperscriptLevel(to val: Int) {
        #if macOS
        setRichTextAttribute(.superscript, to: val)
        #else
        print("Unsupported platform")
        #endif
    }

    /// Step the superscript level.
    func stepRichTextSuperscriptLevel(points: Int) {
        let currentSize = richTextSuperscriptLevel ?? 0
        let newSize = currentSize + points
        setRichTextSuperscriptLevel(to: newSize)
    }
}
