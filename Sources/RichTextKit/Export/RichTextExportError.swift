//
//  RichTextExportError.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This enum defines errors that can be thrown when a file
 manager fails to perform export operations.
 */
public enum RichTextExportError: Error {

    /// This error occurs when no file could be generated at a certain url.
    case cantCreateFile(at: URL)

    /// This error occurs when no file could be generated in a certain directory.
    case cantCreateFileUrl(in: FileManager.SearchPathDirectory)
}
