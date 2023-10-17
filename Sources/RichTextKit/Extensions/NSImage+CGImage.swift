//
//  NSImage+JpegData.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-05.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

#if canImport(AppKit)
import AppKit

public extension NSImage {

    /// Try to get a CoreGraphic image from the AppKit image.
    var cgImage: CGImage? {
        cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
}
#endif
