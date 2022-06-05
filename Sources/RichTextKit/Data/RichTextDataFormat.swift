//
//  RichTextDataFormat.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation
import UniformTypeIdentifiers

/**
 This enum specifies various rich text formats that are used
 in different ways by the library.

 This is a convenience type that's used by many of the types
 in the library. You are not forced to use it, but it can be
 useful when you want to save and files, generate share data
 etc. using the functionality that the library provides.

 The reason for having the ``archivedData`` is to provide an
 additional way to handle images. .txt files doesn't support
 images at all and .rtf requires special handling, where the
 RTFD format handles file attachments like images by storing
 them in a sub folder, using a special format.

 The ``archivedData`` format will instead keep the rich text
 attachments within the rich text and use the Apple specific
 `NSKeyedArchiver` and `NSKeyedUnarchiver` types to create a
 certain kind of rich text data, that can only be handled by
 these archiver classes. It's convenient, but more limited.
 */
public enum RichTextDataFormat: String, CaseIterable, Equatable, Identifiable {
    
    /// Archived data that's persisted with a keyed archiver.
    case archivedData
    
    /// Plain data is persisted as plain text.
    case plainText
    
    /// RTF data is persisted as formatted text.
    case rtf
}

public extension RichTextDataFormat {
    
    /**
     The format's unique identifier.
     */
    var id: String { rawValue }
    
    /**
     The formats that a format can be converted to.
     */
    var convertableFormats: [RichTextDataFormat] {
        switch self {
        case .archivedData: return [.rtf, .plainText]
        case .plainText: return [.archivedData, .rtf]
        case .rtf: return [.archivedData, .plainText]
        }
    }
    
    /**
     The format's standard file extension.
     */
    var standardFileExtension: String {
        switch self {
        case .archivedData: return "rtk"
        case .plainText: return "txt"
        case .rtf: return "rtf"
        }
    }
    
    /**
     Whether or not the format supports images.

     For now, 
     */
    var supportsImages: Bool {
        switch self {
        case .archivedData: return true
        case .plainText: return false
        case .rtf: return false
        }
    }
    
    /**
     The format's uniform type.
     */
    var uniformType: UTType {
        switch self {
        case .archivedData: return .archivedData
        case .plainText: return .plainText
        case .rtf: return .rtf
        }
    }
}
