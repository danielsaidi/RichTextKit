//
//  RichTextDataReader.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-03.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented types that can generate an
 attributed string from ``RichTextFormat`` formatted data.

 The protocol provides functionality that uses public string
 extensions to generate strings from data.
 */
public protocol RichTextDataReader {}

public extension RichTextDataReader {

    /**
     Get rich text from rich text data with a certain format.

     - Parameters:
       - data: The data to parse.
       - format: The data format to use.
     */
    func richText(
        from data: Data,
        with format: RichTextFormat
    ) throws -> NSAttributedString {
        switch format {
        case .archivedData: return try richText(fromArchivedData: data)
        case .plainText: return try richText(fromPlainTextData: data)
        case .rtf: return try richText(fromRtfData: data)
        }
    }

    /**
     Get rich text from ``RichTextFormat/archivedData`` data.
     */
    func richText(
        fromArchivedData data: Data
    ) throws -> NSAttributedString {
        try NSAttributedString(archivedData: data)
    }

    /**
     Get rich text from ``RichTextFormat/plainText`` data.
     */
    func richText(
        fromPlainTextData data: Data
    ) throws -> NSAttributedString {
        try NSAttributedString(plainTextData: data)
    }

    /**
     Get rich text from ``RichTextFormat/rtf`` data.
     */
    func richText(
        fromRtfData data: Data
    ) throws -> NSAttributedString {
        try NSAttributedString(rtfData: data)
    }
}

public extension NSAttributedString {

    /**
     Try to parse ``RichTextFormat/archivedData`` data.

     The data must have been generated with `NSKeyedArchiver`
     and will be unarchived with a `NSKeyedUnarchiver`.

     - Parameters:
       - data: The data to initalize the string with.
     */
    convenience init(archivedData data: Data) throws {
        let unarchived = try NSKeyedUnarchiver.unarchivedObject(
            ofClass: NSAttributedString.self,
            from: data)
        guard let string = unarchived else {
            throw RichTextFormatDataError.invalidArchivedData(in: data)
        }
        self.init(attributedString: string)
    }

    /**
     Try to parse ``RichTextFormat/plainText`` data.

     - Parameters:
       - data: The data to initalize the string with.
     */
    convenience init(plainTextData data: Data) throws {
        let decoded = String(data: data, encoding: .utf8)
        guard let string = decoded else {
            throw RichTextFormatDataError.invalidPlainTextData(in: data)
        }
        let attributed = NSAttributedString(string: string)
        self.init(attributedString: attributed)
    }

    /**
     Try to parse ``RichTextFormat/rtf`` data.
     */
    convenience init(rtfData data: Data) throws {
        var attributes = Self.rtfDataAttributes as NSDictionary?
        try self.init(
            data: data,
            options: [.characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: &attributes)
    }
}

private extension NSAttributedString {

    static var rtfDataAttributes: [DocumentAttributeKey: Any] {
        [.documentType: NSAttributedString.DocumentType.rtf]
    }
}
