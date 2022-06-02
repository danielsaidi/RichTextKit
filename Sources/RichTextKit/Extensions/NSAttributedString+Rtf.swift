//
//  NSAttributedString+Rtf.swift
//  OribiRichTextKit
//
//  Created by Daniel Saidi on 2021-11-22.
//  Copyright © 2020 Oribi. All rights reserved.
//

import Foundation

public extension NSAttributedString {
    
    /**
     Try to create an attributed string from a data instance
     that must contain rtf formatted string data.
     */
    convenience init(rtfData data: Data) throws {
        var attributes = Self.rtfAttributes as NSDictionary?
        try self.init(
            data: data,
            options: [.characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: &attributes)
    }
    
    /**
     Try to get rtf data from the attributed string.
     */
    func rtfData() throws -> Data {
        try data(
            from: NSRange(location: 0, length: length),
            documentAttributes: Self.rtfAttributes)
    }
}

private extension NSAttributedString {
    
    static var rtfAttributes: [DocumentAttributeKey: Any] {
        [.documentType: NSAttributedString.DocumentType.rtf]
    }
}
