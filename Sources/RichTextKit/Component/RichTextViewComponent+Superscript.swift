//
//  RichTextViewComponent+Color.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

#if os(macOS)
import Foundation

public extension RichTextViewComponent {

    /// Get the rich text superscript level at current range.
    var richTextSuperscriptLevel: Int? {
        richTextAttribute(.superscript)
    }

    /// Set the rich text superscript level at current range.
    func setRichTextSuperscriptLevel(to val: Int) {
        setRichTextAttribute(.superscript, to: val)
    }
}
#endif
