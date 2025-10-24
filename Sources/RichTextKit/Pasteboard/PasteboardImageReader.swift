//
//  PasteboardImageReader.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-31.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

/// This protocol can be implemented by types that can fetch an image or multiple
/// images from the pasteboard.
public protocol PasteboardImageReader {

    /// Get the first image in the pasteboard, if any.
    var image: ImageRepresentable? { get }

    /// Get all images in the pasteboard.
    var images: [ImageRepresentable]? { get }
}

public extension PasteboardImageReader {

    /// Check whether or not the pasteboard han any images.
    var hasImages: Bool {
        guard let images = images else { return false }
        return !images.isEmpty
    }
}

#if iOS || os(visionOS)
import UIKit

extension UIPasteboard: PasteboardImageReader {}
#endif

#if macOS
import AppKit

extension NSPasteboard: PasteboardImageReader {}

public extension NSPasteboard {

    /// Get the first image in the pasteboard, if any.
    var image: ImageRepresentable? {
        images?.first
    }

    /// Get all images in the pasteboard.
    var images: [ImageRepresentable]? {
        readObjects(forClasses: [NSImage.self]) as? [NSImage]
    }
}
#endif
