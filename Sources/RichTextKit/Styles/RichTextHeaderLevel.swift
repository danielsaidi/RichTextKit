//
//  RichTextHeaderLevel.swift
//  RichTextKit
//
//  Created by Rizwana Desai on 08/11/24.
//

import Foundation
import SwiftUICore

/**
 This enum represents various rich text format style, such as paragraph,
 heading1 and heading2, heading3.
 */

public enum RichTextHeaderLevel: CaseIterable {

    case paragraph
    case heading1
    case heading2
    case heading3

    public init(_ headerlevel: Int) {
        switch headerlevel {
        case 0: self = .paragraph
        case 1: self = .heading1
        case 2: self = .heading2
        case 3: self = .heading3
        default: self = .paragraph
        }
    }

    /// Initialize a header level from a font.
    /// The header level is determined by the font's point size:
    /// - Sizes >= 28 (heading1.fontSize - 2) -> heading1
    /// - Sizes >= 23 (heading2.fontSize - 2) -> heading2
    /// - Sizes >= 18 (heading3.fontSize - 2) -> heading3
    /// - All other sizes -> paragraph
    public init(_ font: FontRepresentable) {
        let size = font.pointSize
        
        // Find the first header level where the font size meets the minimum threshold
        if let headerLevel = Self.headerSizeThresholds.first(where: { size >= $0.size }) {
            self = headerLevel.level
        } else {
            self = .paragraph
        }
    }

    public var title: String {
        switch self {
        case .paragraph:
            "Paragraph"
        case .heading1:
            "Heading 1"
        case .heading2:
            "Heading 2"
        case .heading3:
            "Heading 3"
        }
    }

    // Using this value to set header level in paragraph style for attributed string
    public var value: Int {
        switch self {
        case .paragraph:
            0
        case .heading1:
            1
        case .heading2:
            2
        case .heading3:
            3
        }
    }

    public var font: FontRepresentable {
        switch self {
        case .heading1:
            return .standardRichTextFont.withSize(self.fontSize)
        case .heading2:
            return .standardRichTextFont.withSize(self.fontSize)
        case .heading3:
            return .standardRichTextFont.withSize(self.fontSize)
        default:
            return .standardRichTextFont
        }
    }

    /// The font size for each header level.
    /// These sizes are used when applying header styles.
    /// For detecting header levels from fonts, we use a threshold of (size - 2)
    /// to allow for some flexibility in font sizes.
    public var fontSize: CGFloat {
        switch self {
        case .heading1:
            return 28  // Threshold: 26
        case .heading2:
            return 24  // Threshold: 22
        case .heading3:
            return 20  // Threshold: 18
        case .paragraph:
            return 16
        }
    }

    /// The minimum font sizes for each header level.
    /// Any font size >= these values will be considered that header level.
    private static let headerSizeThresholds: [(level: RichTextHeaderLevel, size: CGFloat)] = [
        (.heading1, RichTextHeaderLevel.heading1.fontSize - 2),
        (.heading2, RichTextHeaderLevel.heading2.fontSize - 2),
        (.heading3, RichTextHeaderLevel.heading3.fontSize - 2)
    ]

}


