//
//  RichTextExportUrlResolver.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

/// This protocol can be implemented by types that can be used to generate urls,
/// e.g. when exporting files.
///
/// This protocol is implemented by the `FileManager` which is used by default.
public protocol RichTextExportUrlResolver {

    /// Try to generate a file url in a certain directory.
    ///
    /// - Parameters:
    ///   - fileName: The preferred file name.
    ///   - extension: The file extension.
    ///   - directory: The directory in which to generate an url.
    func fileUrl(
        withName fileName: String,
        extension: String,
        in directory: FileManager.SearchPathDirectory
    ) throws -> URL

    /// Try to generate a file url in a certain directory.
    ///
    /// - Parameters:
    ///   - fileName: The preferred file name.
    ///   - extension: The file extension.
    ///   - directory: The directory in which to generate an url.
    func uniqueFileUrl(
        withName fileName: String,
        extension: String,
        in directory: FileManager.SearchPathDirectory
    ) throws -> URL

    /// Get a unique url for the provided url to ensure that
    /// a file with the same name doesn't exist.
    ///
    /// - Parameters:
    ///   - url: The url to generate a unique url for.
    func uniqueUrl(for url: URL) -> URL
}
