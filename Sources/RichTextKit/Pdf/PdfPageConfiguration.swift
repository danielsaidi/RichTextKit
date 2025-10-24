//
//  PdfPageConfiguration.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import CoreGraphics

/// This error can be thrown when creating PDF data.
public struct PdfPageConfiguration: Equatable {

    /// Create a PDF page configuration.
    ///
    /// - Parameters:
    ///   - pageSize: The page size in points.
    ///   - pageMargins: The page margins, by default `72`.
    public init(
        pageSize: CGSize = CGSize(width: 595.2, height: 841.8),
        pageMargins: PdfPageMargins = .init(all: 72)) {
        self.pageSize = pageSize
        self.pageMargins = pageMargins
    }

    /// The page size in points.
    public var pageSize: CGSize

    /// The page margins.
    public var pageMargins: PdfPageMargins
}

public extension PdfPageConfiguration {

    /// The standard PDF page configuration.
    static var standard: Self { .init() }
}

public extension PdfPageConfiguration {

    /// Get the paper rectangle.
    var paperRect: CGRect {
        CGRect(x: 0, y: 0, width: pageSize.width, height: pageSize.height)
    }

    /// Get the printable rectangle.
    var printableRect: CGRect {
        CGRect(
            x: pageMargins.left,
            y: pageMargins.top,
            width: pageSize.width - pageMargins.left - pageMargins.right,
            height: pageSize.height - pageMargins.top - pageMargins.bottom)
    }
}
