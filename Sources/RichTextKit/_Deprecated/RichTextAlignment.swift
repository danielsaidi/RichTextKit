//
//  RichTextAlignment.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

@available(*, deprecated, message: "Use native NSTextAlignment directly instead.")
public enum RichTextAlignment: String, CaseIterable, Codable, Equatable, Identifiable, RichTextLabelValue {

    /// Create a rich text alignment with a native alignment.
    ///
    /// - Parameters:
    ///   - alignment: The native alignment to use.
    public init(_ alignment: NSTextAlignment) {
        switch alignment {
        case .left: self = .left
        case .right: self = .right
        case .center: self = .center
        case .justified: self = .justified
        default: self = .left
        }
    }

    /// Left text alignment.
    case left

    /// Center text alignment.
    case center

    /// Justified text alignment.
    case justified

    /// Right text alignment.
    case right
}

@available(*, deprecated, message: "Use native NSTextAlignment directly instead.")
public extension Collection where Element == RichTextAlignment {

    static var all: [Element] { RichTextAlignment.allCases }
}

@available(*, deprecated, message: "Use native NSTextAlignment directly instead.")
public extension RichTextAlignment {

    /// The unique alignment ID.
    var id: String { rawValue }

    /// The standard icon to use for the alignment.
    var icon: Image { nativeAlignment.defaultIcon }

    /// The standard title to use for the alignment.
    var title: String { nativeAlignment.defaultTitle }

    /// The standard title key to use for the alignment.
    var titleKey: RTKL10n { nativeAlignment.defaultTitleKey }

    /// The native alignment of the alignment.
    var nativeAlignment: NSTextAlignment {
        switch self {
        case .left: .left
        case .right: .right
        case .center: .center
        case .justified: .justified
        }
    }
}
