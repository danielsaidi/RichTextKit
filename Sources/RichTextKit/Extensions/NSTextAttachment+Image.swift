//
//  NSTextAttachment+Image.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2023-06-01.
//  Copyright © 2023-2024 Daniel Saidi. All rights reserved.
//

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

#if iOS || macOS || os(tvOS) || os(visionOS)
public extension NSTextAttachment {

    /// Get an `image` value, or use `contents` to create a platform image.
    ///
    /// This is needed since the `image` is not always available on some platforms.
    var attachedImage: ImageRepresentable? {
        if let image { return image }
        guard let contents else { return nil }
        return ImageRepresentable(data: contents)
    }
}
#endif
