//
//  StandardRichTextShareService.swift
//  OribiWriter
//
//  Created by Daniel Saidi on 2021-12-06.
//  Copyright © 2021 Oribi. All rights reserved.
//

import Foundation

/**
 This share service can be used to generate a share file for
 an attributed string with a certain format.

 Share files are by default written to the app caches folder.
 */
public class StandardRichTextShareService: RichTextShareService {

    /**
     Create a standard rich text share service.

     - Parameters:
       - urlResolver: The type to use to resolve file urls, by default `FileManager.default`.
       - directory: The directory to save the file in, by default `.cachesDirectory`.
     */
    public init(
        urlResolver: RichTextExportUrlResolver = FileManager.default,
        directory: FileManager.SearchPathDirectory = .cachesDirectory
    ) {
        self.urlResolver = urlResolver
        self.directory = directory
    }

    private let urlResolver: RichTextExportUrlResolver
    private let directory: FileManager.SearchPathDirectory
    
    /**
     Generate a file with a certain name, content and format.

     Share files will by default be added to the app's cache
     folder, which means that we don't have to care about if
     a file with the same name already exists.
     
     - Parameters:
       - fileName: The name of the shared file.
       - content: The rich text content to share.
       - format: The rich text format to use when exporting.
     */
    public func generateShareFile(
        withName fileName: String,
        content: NSAttributedString,
        format: RichTextDataFormat) throws -> URL {
        let fileUrl = try urlResolver.fileUrl(
            withName: fileName,
            extension: format.standardFileExtension,
            in: directory)
        let data = try content.richTextData(with: format)
        try data.write(to: fileUrl)
        return fileUrl
    }
    
    /**
     Generate a PDF share file with a certain text content.

     Share files will by default be added to the app's cache
     folder, which means that we don't have to care about if
     a file with the same name already exists.
     
     - Parameters:
       - fileName: The name of the shared file.
       - content: The rich text content to share.
     */
    public func generatePdfShareFile(
        withName fileName: String,
        content: NSAttributedString) throws -> URL {
        let fileUrl = try urlResolver.fileUrl(
            withName: fileName,
            extension: "pdf",
            in: directory)
        let data = try content.richTextPdfData()
        try data.write(to: fileUrl)
        return fileUrl
    }
}
