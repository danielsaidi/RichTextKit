//
//  RichTextDataError.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-04.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This enum represents rich text data-related errors.
 */
public enum RichTextDataError: Error {

    case invalidArchivedData(in: Data)
    case invalidPlainTextData(in: Data)
    case invalidData(in: String)
}
