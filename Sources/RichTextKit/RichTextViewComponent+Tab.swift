//
//  RichTextViewComponent+Tab.swift
//  RichTextKit
//
//  Created by James Bradley on 2023-03-04.
//  Copyright © 2023 James Bradley. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

public extension RichTextViewComponent {

    /**
     Use the selected range (if any) or text position to get
     the current rich text alignment.
     */
    var currentRichTextTab: RichTextTab? {
        let attribute: NSMutableParagraphStyle? = currentRichTextAttribute(.paragraphStyle)
        guard let style = attribute else { return nil }
        return RichTextTab(style.tabStops.count)
    }

    /**
     Use the selected range (if any) or text position to set
     the current rich text alignment.

     - Parameters:
       - alignment: The alignment to set.
     */
    func setCurrentRichTextTab(
        to tab: RichTextTab
    ) {
        if !hasTrimmedText {
            return setTextTabAtCurrentPosition(to: tab)
        }
//        setRichTextTab(to: tab, at: selectedRange)
    }
}

private extension RichTextViewComponent {

    /**
     Set the text alignment at the current position.
     */
    func setTextTabAtCurrentPosition(
        to tab: RichTextTab
    ) {
        let style = NSMutableParagraphStyle()
        style.tabStops = tab.nativeTab
        var attributes = currentRichTextAttributes
        attributes[.paragraphStyle] = style
        typingAttributes = attributes
    }
}
