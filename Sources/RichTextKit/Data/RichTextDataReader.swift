//
//  RichTextDataReader.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-03.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented any types that can provide
 attributed string parsing of rich text-based data.

 This protocol uses public `NSAttributedString` initializers
 that are defined as extensions in the library, for instance:

 ```
 NSAttributedString(data: data, format: .rtf)
 NSAttributedString(archivedData: data)
 NSAttributedString(plainTextData: data)
 NSAttributedString(rtfData: data)
 ```

 These initializers are however omitted by the documentation
 for now.
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
        try NSAttributedString(data: data, format: format)
    }
}
