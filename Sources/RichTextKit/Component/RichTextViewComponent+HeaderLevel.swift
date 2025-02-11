//
//  RichTextViewComponent+HeaderLevel.swift
//
//  Created by Rizwana Desai on 05/11/24.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

extension RichTextViewComponent {

    var richTextHeaderLevel: RichTextHeaderLevel? {
        guard let font = richTextFont else { return nil }
        return RichTextHeaderLevel(font)
    }

    func setHeaderLevel(_ level: RichTextHeaderLevel) {
        // For text insertion point (cursor), apply to typing attributes
        if selectedRange.length == 0 {
            #if canImport(UIKit)
            typingAttributes[.font] = level.font
            #elseif canImport(AppKit)
            typingAttributes[.font] = level.font
            #endif
            return
        }
        
        // For selected text, apply formatting to the selection
        registerUndo()
        setRichTextFontSize(level.fontSize)
    }
}

// Define header level attribute key
extension NSAttributedString.Key {
    static let headerLevel = NSAttributedString.Key("headerLevel")
}
