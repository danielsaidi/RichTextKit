//
//  RichTextExportError.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

/// This enum defines errors that can be thrown when failing to export rich text.
public enum RichTextExportError: Error {

    /// This error occurs when no file could be generated at a certain url.
    case cantCreateFile(at: URL)

    /// This error occurs when no file could be generated in a certain directory.
    case cantCreateFileUrl(in: FileManager.SearchPathDirectory)
}
