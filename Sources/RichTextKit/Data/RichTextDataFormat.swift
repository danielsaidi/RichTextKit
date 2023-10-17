//
//  RichTextDataFormat.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation
import UniformTypeIdentifiers

/**
 This enum specifies rich text data formats.
 
 Different formats handle rich text in different ways.

 For instance, ``rtf`` supports rich text attributes, styles,
 formatting etc. while ``plainText`` only handles plain text.
 ``archivedData`` lets you archive text and attachments into
 a binary archive, which is convenient if you stick to Apple
 platforms, but restricts how the data can be used elsewhere.

 The ``archivedData`` format uses `rtk` a file extension, as
 well as a `UTType.archivedData` uniform type. You can use a
 ``RichTextDataFormat/vendorArchivedData(id:fileExtension:fileFormatText:uniformType:)``
 value to specify custom formats.

 Remember to configure your app for handling the UTTypes you
 want to support, as well as the file extensions you want to
 open with the app. Have a look at the demo app for examples.
 */
public enum RichTextDataFormat: Equatable, Identifiable {
    
    /// Archived data that's persisted with a keyed archiver.
    case archivedData
    
    /// Plain data is persisted as plain text.
    case plainText

    /// RTF data is persisted as formatted text.
    case rtf

    /// A vendor-specific archived data format.
    case vendorArchivedData(
        id: String,
        fileExtension: String,
        fileFormatText: String,
        uniformType: UTType)
}

public extension Collection where Element == RichTextDataFormat {

    /// Get all library supported data formats.
    static var libraryFormats: [RichTextDataFormat] {
        RichTextDataFormat.libraryFormats
    }
}

public extension RichTextDataFormat {

    /// Get all library supported data formats.
    static var libraryFormats: [RichTextDataFormat] {
        [.archivedData, .plainText, .rtf]
    }
    
    /// The format's unique identifier.
    var id: String {
        switch self {
        case .archivedData: return "archivedData"
        case .plainText: return "plainText"
        case .rtf: return "rtf"
        case .vendorArchivedData(let id, _, _, _): return id
        }
    }
    
    /// The formats that a format can be converted to.
    var convertibleFormats: [RichTextDataFormat] {
        switch self {
        case .vendorArchivedData: return Self.libraryFormats.removing(.archivedData)
        default: return Self.libraryFormats.removing(self)
        }
    }

    /// The format's file format display text.
    var fileFormatText: String {
        switch self {
        case .archivedData: return RTKL10n.fileFormatRtk.text
        case .plainText: return RTKL10n.fileFormatTxt.text
        case .rtf: return RTKL10n.fileFormatRtf.text
        case .vendorArchivedData(_, _, let text, _): return text
        }
    }

    /// Whether or not the format is an archived data type.
    var isArchivedDataFormat: Bool {
        switch self {
        case .archivedData: return true
        case .plainText: return false
        case .rtf: return false
        case .vendorArchivedData: return true
        }
    }
    
    /// The format's standard file extension.
    var standardFileExtension: String {
        switch self {
        case .archivedData: return "rtk"
        case .plainText: return "txt"
        case .rtf: return "rtf"
        case .vendorArchivedData(_, let ext, _, _): return ext
        }
    }
    
    /// Whether or not the format supports images.
    var supportsImages: Bool {
        switch self {
        case .archivedData: return true
        case .plainText: return false
        case .rtf: return false
        case .vendorArchivedData: return true
        }
    }
    
    /// The format's uniform type.
    var uniformType: UTType {
        switch self {
        case .archivedData: return .archivedData
        case .plainText: return .plainText
        case .rtf: return .rtf
        case .vendorArchivedData(_, _, _, let type): return type
        }
    }
}

private extension Collection where Element == RichTextDataFormat {

    func removing(_ format: RichTextDataFormat) -> [RichTextDataFormat] {
        filter { $0 != format }
    }
}
