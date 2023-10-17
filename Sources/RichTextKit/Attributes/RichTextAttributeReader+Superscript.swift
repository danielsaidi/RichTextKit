//
//  RichTextAttributeReader+Superscript.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2023-10-17.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

#if os(macOS)
import Foundation

public extension RichTextAttributeReader {

    /// Get the superscript level at a certain range.
    func richTextSuperscriptLevel(at range: NSRange) -> Int? {
        richTextAttribute(.superscript, at: range)
    }
}
#endif
