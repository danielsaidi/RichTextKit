//
//  RichTextData+Format.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation
import UniformTypeIdentifiers
    
/**
 This enum specifies rich text data formats.
 
 Different formats have different capabilities. For instance,
 ``rtf`` supports rich text, styles, etc., while ``plainText``
 only handles text. ``archivedData`` can archive text, image
 data and attachments in binary archives. This is convenient
 when only targeting Apple platforms, but restricts how data
 can be used elsewhere.
 
 ``archivedData`` uses an `rtk` file extension, as well as a
 `UTType.archivedData` uniform type. You can create a custom ``vendorArchivedData(id:fileExtension:fileFormatText:uniformType:)``
 value to specify a custom data format.
 
 Remember to configure your app for handling the UTTypes you
 want to support, as well as the file extensions you want to
 open with the app. Take a look at the demo app for examples.
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
        uniformType: UTType
    )
}

public extension Collection where Element == RichTextDataFormat {

    /// Get all library supported data formats.
    static var libraryFormats: [Element] {
        Element.libraryFormats
    }
}

public extension RichTextDataFormat {

    /// Get all library supported data formats.
    static var libraryFormats: [Self] {
        [.archivedData, .plainText, .rtf]
    }

    /// The format's unique identifier.
    var id: String {
        switch self {
        case .archivedData: "archivedData"
        case .plainText: "plainText"
        case .rtf: "rtf"
        case .vendorArchivedData(let id, _, _, _): id
        }
    }

    /// The formats that a format can be converted to.
    var convertibleFormats: [Self] {
        switch self {
        case .vendorArchivedData: Self.libraryFormats.removing(.archivedData)
        default: Self.libraryFormats.removing(self)
        }
    }

    /// The format's file format display text.
    var fileFormatText: String {
        switch self {
        case .archivedData: RTKL10n.fileFormatRtk.text
        case .plainText: RTKL10n.fileFormatTxt.text
        case .rtf: RTKL10n.fileFormatRtf.text
        case .vendorArchivedData(_, _, let text, _): text
        }
    }

    /// Whether or not the format is an archived data type.
    var isArchivedDataFormat: Bool {
        switch self {
        case .archivedData: true
        case .plainText: false
        case .rtf: false
        case .vendorArchivedData: true
        }
    }

    /// The format's standard file extension.
    var standardFileExtension: String {
        switch self {
        case .archivedData: "rtk"
        case .plainText: "txt"
        case .rtf: "rtf"
        case .vendorArchivedData(_, let ext, _, _): ext
        }
    }

    /// Whether or not the format supports images.
    var supportsImages: Bool {
        switch self {
        case .archivedData: true
        case .plainText: false
        case .rtf: false
        case .vendorArchivedData: true
        }
    }

    /// The format's uniform type.
    var uniformType: UTType {
        switch self {
        case .archivedData: .archivedData
        case .plainText: .plainText
        case .rtf: .rtf
        case .vendorArchivedData(_, _, _, let type): type
        }
    }
}

private extension Collection where Element == RichTextDataFormat {

    func removing(_ format: Element) -> [Element] {
        filter { $0 != format }
    }
}
