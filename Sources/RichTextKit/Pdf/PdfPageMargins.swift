//
//  PdfPageMargins.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import CoreGraphics

/**
 This struct defines page margins for a PDF document.
 */
public struct PdfPageMargins: Equatable {

    /**
     Create PDF page margins.

     - Parameters:
       - top: The top margins.
       - left: The left margins.
       - bottom: The bottom margins.
       - right: The right margins.
     */
    public init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }

    /**
     Create PDF page margins.

     - Parameters:
       - horizontal: The horizontal margins.
       - vertical: The vertical margins.
     */
    public init(horizontal: CGFloat, vertical: CGFloat) {
        self.top = vertical
        self.left = horizontal
        self.bottom = vertical
        self.right = horizontal
    }

    /**
     Create PDF page margins.

     - Parameters:
       - all: The margins for all edges.
     */
    public init(all: CGFloat) {
        self.top = all
        self.left = all
        self.bottom = all
        self.right = all
    }
    
    /**
     The top margins.
     */
    public var top: CGFloat

    /**
     The left margins.
     */
    public var left: CGFloat

    /**
     The bottom margins.
     */
    public var bottom: CGFloat

    /**
     The right margins.
     */
    public var right: CGFloat
}
