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
        setRichTextFontSize(level.fontSize)
    }
}
