//
//  RichTextImageAttachmentManager.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-05.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import CoreGraphics
import Foundation

#if iOS || os(tvOS) || os(visionOS)
import UIKit
#endif

#if macOS
import AppKit
#endif

/// This protocol extends ``RichTextReader`` with functionality for handling
/// image attachments.
public protocol RichTextImageAttachmentManager: RichTextReader {}

extension NSAttributedString: RichTextImageAttachmentManager {}

public extension RichTextImageAttachmentManager {

    /// Get the attachment bounds of an image, given a max size.
    func attachmentBounds(
        for image: ImageRepresentable,
        maxSize: CGSize
    ) -> CGRect {
        let size = attachmentSize(for: image, maxSize: maxSize)
        return CGRect(origin: .zero, size: size)
    }

    /// Get the attachment size of an image, given a max size.
    func attachmentSize(
        for image: ImageRepresentable,
        maxSize: CGSize
    ) -> CGSize {
        let size = image.size
        let validWidth = size.width < maxSize.width
        let validHeight = size.height < maxSize.height
        let validSize = validWidth && validHeight
        if validSize { return image.size }
        let aspectWidth = maxSize.width / size.width
        let aspectHeight = maxSize.height / size.height
        let aspectRatio = min(aspectWidth, aspectHeight)
        let newSize = CGSize(
            width: size.width * aspectRatio,
            height: size.height * aspectRatio)
        return newSize
    }
}

#if iOS || macOS || os(tvOS) || os(visionOS)
public extension RichTextImageAttachmentManager {

    /// Auto-size all images attachments within a rich text, by applying a max size.
    func autosizeImageAttachments(maxSize: CGSize) {
        let range = NSRange(location: 0, length: richText.length)
        let safeRange = safeRange(for: range)
        richText.enumerateAttribute(.attachment, in: safeRange, options: []) { object, _, _ in
            guard let attachment = object as? NSTextAttachment else { return }
            guard let image = attachment.attachedImage else { return }
            let oldBounds = attachment.bounds
            let newBounds = attachmentBounds(for: image, maxSize: maxSize)
            if oldBounds == newBounds { return }
            attachment.bounds = newBounds
        }
    }
}
#endif
