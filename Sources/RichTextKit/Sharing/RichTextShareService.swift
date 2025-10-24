//
//  RichTextShareService.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-04.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

/// This protocol can be implemented by types that can share files and documents.
///
/// Sharing should be used to share the rich text to other apps, users etc. or send
/// it for printing. If you want to create a file copy using another rich text data format,
/// should use a ``RichTextExportService`` instead.
@preconcurrency @MainActor
public protocol RichTextShareService: AnyObject {

    /// Generate a share file with a certain name and rich text content, that uses
    /// a certain rich text data format.
    ///
    /// - Parameters:
    ///   - withName: The name of the shared file.
    ///   - content: The rich text content to share.
    ///   - format: The document format to use when sharing.
    func generateShareFile(
        withName fileName: String,
        content: NSAttributedString,
        format: RichTextDataFormat
    ) throws -> URL

    /// Generate a PDF share file with a certain name and rich text content.
    ///
    /// - Parameters:
    ///   - withName: The name of the shared file.
    ///   - content: The rich text content to share.
    func generatePdfShareFile(
        withName fileName: String,
        content: NSAttributedString
    ) throws -> URL
}
