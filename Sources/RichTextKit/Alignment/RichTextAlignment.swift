//
//  RichTextAlignment.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This enum defines supported rich text alignments.
 
 The enum makes the alignment type identifiable and diffable.
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
    
    /// Justified text alignment.
    case justified

    /// Right text alignment.
    case right
}

public extension RichTextAlignment {

    /// The unique ID of the alignment.
    var id: String { rawValue }
    
    /// The standard icon to use for the alignment.
    var icon: Image { nativeAlignment.icon }
    
    /// The standard title to use for the alignment.
    var title: String { nativeAlignment.title }

    /// The native alignment of the alignment.
    var nativeAlignment: NSTextAlignment {
        switch self {
        case .left: return .left
        case .right: return .right
        case .center: return .center
        case .justified: return .justified
        }
    }
}

public extension NSTextAlignment {
    
    /// The standard icon to use for the alignment.
    var icon: Image {
        switch self {
        case .left: return .richTextAlignmentLeft
        case .right: return .richTextAlignmentRight
        case .center: return .richTextAlignmentCenter
        case .justified: return .richTextAlignmentJustified
        default: return .richTextAlignmentLeft
        }
    }
    
    /// The standard title to use for the alignment.
    var title: String {
        titleCase.text
    }
    
    /// The standard title to use for the alignment.
    var titleCase: RTKL10n {
        switch self {
        case .left: return RTKL10n.textAlignmentLeft
        case .right: return RTKL10n.textAlignmentRight
        case .center: return RTKL10n.textAlignmentCentered
        case .justified: return RTKL10n.textAlignmentJustified
        default: return RTKL10n.textAlignmentLeft
        }
    }
}
