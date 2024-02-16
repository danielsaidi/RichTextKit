//
//  PdfDataError.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-03.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

/// This error can be thrown when creating PDF data.
public enum PdfDataError: Error {

    /// The platform is not supported
    case unsupportedPlatform
}
