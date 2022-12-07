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
 This enum specifies rich text formats that handle rich text
 in different ways.

 For instance, ``rtf`` supports rich text attributes, styles,
 formatting etc. while ``plainText`` only handles plain text.
 ``archivedData`` lets you archive text and attachments into
 a binary archive, which is convenient if you stick to Apple
 platforms, but restricts how the data can be used elsewhere.

 The reason for having ``archivedData`` is to let you handle
 images in a more convenient way. Since ``plainText`` has no
 image support and ``rtf`` requires additional handling (the
 RTFD format handles attachments by storing them in a folder,
 using a special format), ``archivedData`` store attachments
 within the attributed string. The archiver however uses the
 Apple `NSKeyedArchiver` and `NSKeyedUnarchiver` which means
 that it's more limited when it comes to data portability.

 ``archivedData`` uses `rtk` as file extension, as well as a
 custom `UTType.archivedData` uniform type. You can create a
 ``vendorArchivedData(id:fileExtension:uniformType:)`` value
 if you want to use custom file extensions and uniform types
 in your app. Don't forget to configure your app accordingly.
 */
public enum RichTextDataFormat: Equatable, Identifiable {
    
    /// Archived data that's persisted with a keyed archiver.
    case archivedData
    
    /// Plain data is persisted as plain text.
    case plainText
    
    /// RTF data is persisted as formatted text.
    case rtf

    /// A vendor-specific archived data format.
    case vendorArchivedData(id: String, fileExtension: String, uniformType: UTType)
}

public extension RichTextDataFormat {
    
    /**
     The format's unique identifier.
     */
    var id: String {
        switch self {
        case .archivedData: return "archivedData"
        case .plainText: return "plainText"
        case .rtf: return "rtf"
        case .vendorArchivedData(let id, _, _): return id
        }
    }
    
    /**
     The formats that a format can be converted to.
     */
    var convertableFormats: [RichTextDataFormat] {
        switch self {
        case .archivedData: return [.rtf, .plainText]
        case .plainText: return [.archivedData, .rtf]
        case .rtf: return [.archivedData, .plainText]
        case .vendorArchivedData: return [.rtf, .plainText]
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
        case .vendorArchivedData(_, let fileExtension, _): return fileExtension
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
        case .vendorArchivedData: return true
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
        case .vendorArchivedData(_, _, let type): return type
        }
    }
}
