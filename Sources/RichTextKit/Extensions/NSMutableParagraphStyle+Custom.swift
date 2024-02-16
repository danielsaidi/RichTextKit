//
//  NSMutableParagraphStyle+Custom.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-02-16.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

extension NSMutableParagraphStyle {
    
    convenience init(
        from style: NSMutableParagraphStyle? = nil,
        alignment: RichTextAlignment? = nil,
        lineSpacing: CGFloat? = nil
    ) {
        let style = style ?? .init()
        self.init()
        self.alignment = alignment?.nativeAlignment ?? style.alignment
        self.lineSpacing = lineSpacing ?? style.lineSpacing
    }
}
