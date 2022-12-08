//
//  RichTextAlignment.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This enum simplifies working with different text alignments.
 */
public enum RichTextAlignment: String, CaseIterable, Codable, Equatable, Identifiable {

    /**
     Initialize a rich text alignment with a native aligment.

     - Parameters:
       - alignment: The native alignment to use.
     */
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

    /// Right text alignment.
    case right

    /// Justified text alignment.
    case justified
}

public extension RichTextAlignment {

    /**
     The unique ID of the alignment.
     */
    var id: String { rawValue }
    
    /**
     The standard icon to use for the alignment.
     */
    var icon: Image {
        switch self {
        case .left: return .richTextAlignmentLeft
        case .right: return .richTextAlignmentRight
        case .center: return .richTextAlignmentCenter
        case .justified: return .richTextAlignmentJustified
        }
    }

    /**
     The native alignment of the alignment.
     */
    var nativeAlignment: NSTextAlignment {
        switch self {
        case .left: return .left
        case .right: return .right
        case .center: return .center
        case .justified: return .justified
        }
    }
}
