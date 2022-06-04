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
 attributed string from ``RichTextDataFormat``-specific data.

 This protocol uses public `NSAttributedString` initializers
 that are defined as extensions in this library. They can be
 used directly, without using a data reader, but are for now
 omitted by the documentation engine.
 */
public protocol RichTextDataReader {}

public extension RichTextDataReader {

    /**
     Get rich text from ``RichTextDataFormat`` specific data.

     - Parameters:
       - data: The data to parse.
       - format: The data format to use.
     */
    func richText(
        from data: Data,
        format: RichTextDataFormat
    ) throws -> NSAttributedString {
        switch format {
        case .archivedData: return try NSAttributedString(archivedData: data)
        case .plainText: return try NSAttributedString(plainTextData: data)
        case .rtf: return try NSAttributedString(rtfData: data)
        }
    }
}

public extension NSAttributedString {

    /**
     Try to parse ``RichTextFormat`` data.

     - Parameters:
       - data: The data to initalize the string with.
       - format: The data format to use.
     */
    convenience init(
        data: Data,
        format: RichTextDataFormat
    ) throws {
        switch format {
        case .archivedData: try self.init(archivedData: data)
        case .plainText: try self.init(plainTextData: data)
        case .rtf: try self.init(rtfData: data)
        }
    }

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
            throw RichTextDataError.invalidArchivedData(in: data)
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
            throw RichTextDataError.invalidPlainTextData(in: data)
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
