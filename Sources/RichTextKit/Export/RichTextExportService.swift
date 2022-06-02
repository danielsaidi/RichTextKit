//
//  RichTextExportService.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented by any classes that can be
 used to export documents.
 */
public protocol RichTextExportService: AnyObject {
    
    /**
     Generate a export file with a custom name and rich text
     content.
     
     - Parameters:
       - fileName: The preferred file name.
       - content: The rich text content to export.
       - format: The rich text format to use when exporting.
     */
    func generateExportFile(
        withName fileName: String,
        content: NSAttributedString,
        format: RichTextFormat
    ) throws -> URL
    
    /**
     Generate a PDF export file with a certain name and rich
     text content.
     
     - Parameters:
       - fileName: The preferred file name.
       - content: The rich text content to export.
     */
    func generatePdfExportFile(
        withName fileName: String,
        content: NSAttributedString
    ) throws -> URL
}
