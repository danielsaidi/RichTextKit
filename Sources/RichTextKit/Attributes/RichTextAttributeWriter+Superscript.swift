//
//  RichTextAttributeWriter+Superscript.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2023-10-17.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

#if os(macOS)
import Foundation

public extension RichTextAttributeWriter {

    /// Set the superscript level at a certain range.
    func setRichTextSuperscriptLevel(
        _ level: Int,
        at range: NSRange? = nil
    ) {
        setRichTextAttribute(.superscript, to: level)
    }
}
#endif
