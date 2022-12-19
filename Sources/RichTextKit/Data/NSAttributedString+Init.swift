//
//  File.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-03.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

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
        case .vendorArchivedData: try self.init(archivedData: data)
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
