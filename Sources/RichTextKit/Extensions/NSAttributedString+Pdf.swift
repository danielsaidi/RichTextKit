//
//  NSAttributedString+Pdf.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation
import CoreGraphics

/**
 This error can be thrown when calling `pdfData()` on an
 `NSAttributedString`.
 */
public enum NSAttributedStringPdfDataError: Error {
    
    /// The platform is not supported
    case unsupportedPlatform
}

public extension NSAttributedString {
    
    /**
     This typealias is used within the type to make the code
     more compact.
     */
    typealias PdfDataError = NSAttributedStringPdfDataError
    
    /**
     Try to generate PDF data for the attributed string.
     
     This function is currently only supported on iOS. Other
     platforms will throw `PdfDataError.unsupportedPlatform`.
     */
    func pdfData(configuration: PdfPageConfiguration = .standard) throws -> Data {
        #if os(iOS)
        try iosPdfData(for: configuration)
        #elseif os(macOS)
        try macosPdfData(for: configuration)
        #else
        throw NSAttributedStringPdfDataError.unsupportedPlatform
        #endif
    }
}

#if os(macOS)
import AppKit

private extension NSAttributedString {
    
    func macosPdfData(for configuration: PdfPageConfiguration) throws -> Data {
        do {
            let fileUrl = try macosPdfFileUrl()
            let printInfo = try macosPdfPrintInfo(
                for: configuration,
                fileUrl: fileUrl)
            
            let scrollView = NSTextView.scrollableTextView()
            scrollView.frame = configuration.paperRect
            let textView = scrollView.documentView as? NSTextView ?? NSTextView()
            sleepToPrepareTextView()
            textView.textStorage?.setAttributedString(self)
            
            let printOperation = NSPrintOperation(view: textView, printInfo: printInfo)
            printOperation.showsPrintPanel = false
            printOperation.showsProgressPanel = false
            printOperation.run()
            
            return try Data(contentsOf: fileUrl)
        } catch {
            throw(error)
        }
    }
    
    func macosPdfFileUrl() throws -> URL {
        let manager = FileManager.default
        let cacheUrl = try manager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return cacheUrl
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("pdf")
    }
    
    func macosPdfPrintInfo(
        for configuration: PdfPageConfiguration,
        fileUrl: URL) throws -> NSPrintInfo {
        let printOpts: [NSPrintInfo.AttributeKey: Any] = [
            .jobDisposition: NSPrintInfo.JobDisposition.save,
            .jobSavingURL: fileUrl]
        let printInfo = NSPrintInfo(dictionary: printOpts)
        printInfo.horizontalPagination = .fit
        printInfo.verticalPagination = .automatic
        printInfo.topMargin = configuration.pageMargins.top
        printInfo.leftMargin = configuration.pageMargins.left
        printInfo.rightMargin = configuration.pageMargins.right
        printInfo.bottomMargin = configuration.pageMargins.bottom
        printInfo.isHorizontallyCentered = false
        printInfo.isVerticallyCentered = false
        return printInfo
    }
    
    func sleepToPrepareTextView() {
        Thread.sleep(forTimeInterval: 0.1)
    }
}
#endif

#if os(iOS)
import UIKit

private extension NSAttributedString {
    
    func iosPdfData(for configuration: PdfPageConfiguration) throws -> Data {
        let pageRenderer = iosPdfPageRenderer(for: configuration)
        let paperRect = configuration.paperRect
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, paperRect, nil)
        let range = NSRange(location: 0, length: pageRenderer.numberOfPages)
        pageRenderer.prepare(forDrawingPages: range)
        let bounds = UIGraphicsGetPDFContextBounds()
        for i in 0  ..< pageRenderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            pageRenderer.drawPage(at: i, in: bounds)
        }
        UIGraphicsEndPDFContext()
        return pdfData as Data
    }
    
    func iosPdfPageRenderer(for configuration: PdfPageConfiguration) -> UIPrintPageRenderer {
        let printFormatter = UISimpleTextPrintFormatter(attributedText: self)
        let paperRect = NSValue(cgRect: configuration.paperRect)
        let printableRect = NSValue(cgRect: configuration.printableRect)
        let pageRenderer = UIPrintPageRenderer()
        pageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        pageRenderer.setValue(paperRect, forKey: "paperRect")
        pageRenderer.setValue(printableRect, forKey: "printableRect")
        return pageRenderer
    }
}
#endif
