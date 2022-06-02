//
//  RichTextFormat.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation
import UniformTypeIdentifiers

/**
 Oribi can can handle both plain .txt and .rtf files as well
 as `NSKeyedArchiver` archived .ow data files.
 */
public enum RichTextFormat: String, CaseIterable, Equatable, Identifiable {
    
    /// Archived data that's persisted with a keyed archiver.
    case richTextKit
    
    /// Plain data is persisted as plain text.
    case plainText
    
    /// RTF data is persisted as formatted text.
    case rtf
}

public extension RichTextFormat {
    
    /**
     The format's unique identifier.
     */
    var id: String { rawValue }
    
    /**
     The formats that a format can be converted to.
     */
    var convertableFormats: [RichTextFormat] {
        switch self {
        case .richTextKit: return [.rtf, .plainText]
        case .plainText: return [.richTextKit, .rtf]
        case .rtf: return [.richTextKit, .plainText]
        }
    }
    
    /**
     The format's standard file extension.
     */
    var standardFileExtension: String {
        switch self {
        case .richTextKit: return "rtk"
        case .plainText: return "txt"
        case .rtf: return "rtf"
        }
    }
    
    /**
     Whether or not the format supports images.
     */
    var supportsImages: Bool {
        switch self {
        case .richTextKit: return true
        case .plainText: return false
        case .rtf: return false
        }
    }
    
    /**
     The format's uniform type.
     */
    var uniformType: UTType {
        switch self {
        case .richTextKit: return .richTextKit
        case .plainText: return .plainText
        case .rtf: return .rtf
        }
    }
}
