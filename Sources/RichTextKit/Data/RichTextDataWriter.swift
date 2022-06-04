//
//  RichTextDataWriter.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-03.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented by ``RichTextReader``s, to
 make them able to get ``RichTextDataFormat`` formatted data
 for the current rich text.

 The protocol is implemented by `NSAttributedString` as well
 as other library types.
 */
public protocol RichTextDataWriter: RichTextReader {}

extension NSAttributedString: RichTextDataWriter {}

public extension RichTextDataWriter {

    /**
     Generate rich text data from the current rich text.

     - Parameters:
       - format: The data format to use.
     */
    func richTextData(with format: RichTextDataFormat) throws -> Data {
        switch format {
        case .archivedData: return try richTextArchivedData()
        case .plainText: return try richTextPlainTextData()
        case .rtf: return try richTextRtfData()
        }
    }

    /**
     Generate ``RichTextDataFormat/archivedData`` formatted data.
     */
    func richTextArchivedData() throws -> Data {
        try NSKeyedArchiver.archivedData(
            withRootObject: richText,
            requiringSecureCoding: false)
    }

    /**
     Generate ``RichTextDataFormat/plainText`` formatted data.
     */
    func richTextPlainTextData() throws -> Data {
        let string = richText.string
        guard let data = string.data(using: .utf8) else {
            throw RichTextDataError
                .invalidData(in: string)
        }
        return data
    }

    /**
     Generate ``RichTextDataFormat/rtf`` formatted data.
     */
    func richTextRtfData() throws -> Data {
        try richText.data(
            from: NSRange(location: 0, length: richText.length),
            documentAttributes: [
                .documentType: NSAttributedString.DocumentType.rtf
            ]
        )
    }
}
