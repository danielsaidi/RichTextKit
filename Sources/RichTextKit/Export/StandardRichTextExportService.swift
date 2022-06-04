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
 folder, since the intent should be to export rich text with
 another data format.
 */
public class StandardRichTextExportService: RichTextExportService {
    
    /**
     Create a standard rich text export service.
     
     - Parameters:
       - urlResolver: The type to use to resolve file urls, by default `FileManager.default`.
       - directory: The directory to save the file in, by default `.documentDirectory`.
     */
    public init(
        urlResolver: RichTextExportUrlResolver = FileManager.default,
        directory: FileManager.SearchPathDirectory = .documentDirectory
    ) {
        self.urlResolver = urlResolver
        self.directory = directory
    }
    
    private let urlResolver: RichTextExportUrlResolver
    private let directory: FileManager.SearchPathDirectory
    
    /**
     Generate a file with a certain name, content and format.

     Exported files will by default be exported to the app's
     document folder, which means that we should give them a
     unique name to avoid overwriting already existing files.

     To achieve this, we'll use the `uniqueFileUrl` function
     of the url resolver, which by default will add a suffix
     until the file name no longer exists.
     
     - Parameters:
       - fileName: The preferred name of the exported name.
       - content: The rich text content to export.
       - format: The rich text format to use when exporting.
     */
    public func generateExportFile(
        withName fileName: String,
        content: NSAttributedString,
        format: RichTextDataFormat
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

     Exported files will by default be exported to the app's
     document folder, which means that we should give them a
     unique name to avoid overwriting already existing files.

     To achieve this, we'll use the `uniqueFileUrl` function
     of the url resolver, which by default will add a suffix
     until the file name no longer exists.
     
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
        let data = try content.richTextPdfData()
        try data.write(to: fileUrl)
        return fileUrl
    }
}
