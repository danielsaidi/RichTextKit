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
        indent: CGFloat? = nil,
        lineSpacing: CGFloat? = nil,
        listStyle: RichTextListStyle = .none
    ) {
        let style = style ?? .init()
        self.init()
        self.alignment = alignment?.nativeAlignment ?? style.alignment
        self.lineSpacing = lineSpacing ?? style.lineSpacing
        self.headIndent = indent ?? style.headIndent
        self.firstLineHeadIndent = (indent ?? style.headIndent) - (listStyle == .none ? 0 : 20)  // Add space for list marker
        
        // Configure list-specific formatting
        if listStyle != .none {
            self.tabStops = [NSTextTab(textAlignment: .left, location: indent ?? style.headIndent)]
            self.headIndent = (indent ?? style.headIndent) + 20  // Add indentation for list items
        }
    }
}

// MARK: - List Support

public extension NSMutableParagraphStyle {
    
    /// Configure the paragraph style for a list item
    func configureForList(_ style: RichTextListStyle, itemNumber: Int = 1) {
        switch style {
        case .none:
            // Reset list-specific formatting
            firstLineHeadIndent = headIndent
            tabStops = []
        case .ordered, .unordered:
            // Add space for list marker and configure indentation
            firstLineHeadIndent = headIndent - 20
            tabStops = [NSTextTab(textAlignment: .left, location: headIndent)]
        }
    }
}
