//
//  RichTextDataError.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-04.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This enum represents errors that can be thrown when getting
 rich text data for a certain format.
 */
public enum RichTextDataError: Error {

    case invalidArchivedData(in: Data)
    case invalidPlainTextData(in: Data)
    case invalidData(in: String)
}
