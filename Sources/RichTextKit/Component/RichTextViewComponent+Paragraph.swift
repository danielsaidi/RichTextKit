//
//  RichTextViewComponent+Paragraph.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-01-17.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

public extension RichTextViewComponent {

    /// Get the paragraph style.
    var richTextParagraphStyle: NSMutableParagraphStyle? {
        richTextAttribute(.paragraphStyle)
    }
}
