//
//  RichTextExportService.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

/// This protocol can be implemented by types that can export rich text to files.
@preconcurrency @MainActor
public protocol RichTextExportService: AnyObject {

    /// Generate an export file with a name and content that uses a certain rich
    /// text data format.
    ///
    /// - Parameters:
    ///   - fileName: The preferred file name.
    ///   - content: The rich text content to export.
    ///   - format: The rich text format to use when exporting.
    func generateExportFile(
        withName fileName: String,
        content: NSAttributedString,
        format: RichTextDataFormat
    ) throws -> URL

    /// Generate a PDF export file with a name and content.
    ///
    /// - Parameters:
    ///   - fileName: The preferred file name.
    ///   - content: The rich text content to export.
    func generatePdfExportFile(
        withName fileName: String,
        content: NSAttributedString
    ) throws -> URL
}
