//
//  StandardRichTextExportService.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This export service can be used to export rich text content
 to a file with a certain format.

 Exported files are by default written to the app's document
 folder, to simplify converting between various file formats.
 If you mean to share, save or print the file, you can use a
 ``StandardRichTextShareService`` instead.
 */
public class StandardRichTextExportService: RichTextExportService {
    
    /**
     Create a standard rich text export service.
     
     - Parameters:
       - urlResolver: The type to use to resolve file urls, by default `FileManager.default`.
       - directory: The directory to save the file in, by default `.cachesDirectory`.
     */
    public init(
        urlResolver: ExportFileUrlResolver = FileManager.default,
        directory: FileManager.SearchPathDirectory = .cachesDirectory) {
        self.urlResolver = urlResolver
        self.directory = directory
    }
    
    private let urlResolver: ExportFileUrlResolver
    private let directory: FileManager.SearchPathDirectory
    
    /**
     Generate a file with a certain name, content and format.
     
     Unlike when sharing a file, exported file names must be
     unique, to avoid overwriting other files. This function
     will therefore make sure that the generated file url is
     unique before it exports it.
     
     - Parameters:
       - fileName: The preferred file name.
       - content: The rich text content to export.
       - format: The rich text format to use when exporting.
     */
    public func generateExportFile(
        withName fileName: String,
        content: NSAttributedString,
        format: RichTextFormat
    ) throws -> URL {
        let fileUrl = try urlResolver.uniqueFileUrl(
            withName: fileName,
            extension: format.standardFileExtension,
            in: directory)
        let data = try content.richTextData(with: format)
        try data.write(to: fileUrl)
        return fileUrl
    }
    
    /**
     Generate a PDF file with a certain name and content.

     Unlike when sharing a file, exported file names must be
     unique, to avoid overwriting other files. This function
     will therefore make sure that the generated file url is
     unique before it exports it.
     
     - Parameters:
       - fileName: The preferred file name.
       - content: The rich text content to export.
     */
    public func generatePdfExportFile(
        withName fileName: String,
        content: NSAttributedString
    ) throws -> URL {
        let fileUrl = try urlResolver.uniqueFileUrl(
            withName: fileName,
            extension: "pdf",
            in: directory)
        let data = try content.pdfData()
        try data.write(to: fileUrl)
        return fileUrl
    }
}
