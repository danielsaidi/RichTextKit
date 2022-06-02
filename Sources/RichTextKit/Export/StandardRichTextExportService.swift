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
       - fileManager: The file manager to use to create files, by default `.default`.
       - directory: The directory to save the file in, by default `.cachesDirectory`.
     */
    public init(
        fileManager: FileManager = .default,
        directory: FileManager.SearchPathDirectory = .cachesDirectory) {
        self.fileManager = fileManager
        self.directory = directory
    }
    
    private let fileManager: FileManager
    private let directory: FileManager.SearchPathDirectory
    
    /**
     Generate a file with a certain name, content and format.
     
     Unlike when sharing a file, exported file names must be
     unique, to avoid overwriting other files. This function
     will therefore make sure that the generated file url is
     unique before it exports it.
     
     - Parameters:
       - withName: The preferred name of the exported file.
       - content: The rich text content to export.
       - format: The rich text format to use when exporting.
     */
    public func generateExportFile(
        withName fileName: String,
        content: NSAttributedString,
        format: RichTextFormat) throws -> URL {
        let fileUrl = try fileManager.uniqueFileUrl(
            withName: fileName,
            extension: format.standardFileExtension,
            in: directory)
        let data = try content.data(for: format)
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
       - withName: The preferred name of the exported file.
       - content: The rich text content to export.
     */
    public func generatePdfExportFile(
        withName fileName: String, content: NSAttributedString) throws -> URL {
        let fileUrl = try fileManager.uniqueFileUrl(
            withName: fileName,
            extension: "pdf",
            in: directory)
        let data = try content.pdfData()
        try data.write(to: fileUrl)
        return fileUrl
    }
}
