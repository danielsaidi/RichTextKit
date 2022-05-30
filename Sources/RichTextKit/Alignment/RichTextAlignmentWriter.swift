//
//  RichTextAlignmentWriter.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

/**
 This protocol can be implemented any types that can provide
 extended rich text alignment writing capabilities.

 This protocol is implemented by `NSMutableAttributedString`
 as well as other library types.
 */
public protocol RichTextAlignmentWriter: RichTextAttributeWriter {}

extension NSMutableAttributedString: RichTextAlignmentWriter {}

public extension RichTextAlignmentWriter {

    /**
     Set the rich text alignment at the provided range.

     - Parameters:
       - alignment: The alignment to set.
       - range: The range for which to set the alignment.
     */
    func setRichTextAlignment(
        to alignment: RichTextAlignment,
        at range: NSRange
    ) {
        setRichTextAttribute(
            .paragraphStyle,
            to: alignment.foundationAlignment,
            at: range)
    }
}
