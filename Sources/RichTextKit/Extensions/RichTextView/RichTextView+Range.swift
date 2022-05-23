//
//  RichTextView+Range.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-24.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(macOS)
public extension RichTextView {

    /**
     Get whether or not the text view has a selected range.
     */
    var hasSelectedRange: Bool {
        selectedRange.length > 0
    }
}
#endif
