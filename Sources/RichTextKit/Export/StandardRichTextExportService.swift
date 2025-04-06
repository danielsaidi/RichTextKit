//
//  StandardRichTextExportService.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

/// This service can be used to export rich text contents to
/// files with a certain format.
///
/// Files are by default written to an app's document folder.
/// It can be changed by providing another directory.
public class StandardRichTextExportService: RichTextExportService {

    /// Create a standard rich text export service.
    ///
    /// - Parameters:
    ///   - urlResolver: The type to use to resolve file urls, by default `FileManager.default`.
    ///   - directory: The directory to save the file in, by default `.documentDirectory`.
    public init(
        urlResolver: RichTextExportUrlResolver = FileManager.default,
        directory: FileManager.SearchPathDirectory = .documentDirectory
    ) {
        self.urlResolver = urlResolver
        self.directory = directory
    }

    private let urlResolver: RichTextExportUrlResolver
    private let directory: FileManager.SearchPathDirectory

    /// Generate an export file with a certain name, content,
    /// and format.
    ///
    /// Exported files will by default be exported to an app
    /// document folder. This means that we should give them
    /// a unique name to avoid overwriting any existing file.
    /// To achieve this, we use the `uniqueFileUrl` function
    /// of the url resolver, which will add a suffix until a
    /// file name is unique.
    ///
    /// - Parameters:
    ///   - fileName: The preferred name of the exported name.
    ///   - content: The rich text content to export.
    ///   - format: The rich text format to use when exporting.
    public func generateExportFile(
        withName fileName: String,
        content: NSAttributedString,
        format: RichTextDataFormat
    ) throws -> URL {
        let fileUrl = try urlResolver.uniqueFileUrl(
            withName: fileName,
            extension: format.standardFileExtension,
            in: directory)
        let data = try content.richTextData(for: format)
        try data.write(to: fileUrl)
        return fileUrl
    }

    /// Generate a PDF file with a certain name and content.
    ///
    /// Exported files will by default be exported to an app
    /// document folder. This means that we should give them
    /// a unique name to avoid overwriting any existing file.
    /// To achieve this, we use the `uniqueFileUrl` function
    /// of the url resolver, which will add a suffix until a
    /// file name is unique.
    ///
    /// - Parameters:
    ///   - fileName: The preferred file name.
    ///   - content: The rich text content to export.
    public func generatePdfExportFile(
        withName fileName: String,
        content: NSAttributedString
    ) throws -> URL {
        let fileUrl = try urlResolver.uniqueFileUrl(
            withName: fileName,
            extension: "pdf",
            in: directory)
        let data = try content.richTextPdfData()
        try data.write(to: fileUrl)
        return fileUrl
    }
}
