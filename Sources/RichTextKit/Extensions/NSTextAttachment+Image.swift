//
//  NSTextAttachment+Image.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2023-06-01.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

#if os(iOS) || os(macOS) || os(tvOS)
public extension NSTextAttachment {

    /**
     Get an `image` value, if any, or use `contents` data to
     create a platform-specific image.

     This additional handling is needed since the `image` is
     not always available on certain platforms.
     */
    var attachedImage: ImageRepresentable? {
        if let image { return image }
        guard let contents else { return nil }
        return ImageRepresentable(data: contents)
    }
}
#endif
