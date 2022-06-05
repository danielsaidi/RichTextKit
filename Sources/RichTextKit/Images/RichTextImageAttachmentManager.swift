//
//  RichTextImageAttachmentManager.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-05.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import CoreGraphics
import Foundation

#if os(iOS) || os(tvOS)
import UIKit
#endif

#if os(macOS)
import AppKit
#endif

/**
 This protocol can be implemented any types that can provide
 additional image attachment capabilities.

 The protocol is implemented by `NSAttributedString` as well
 as other library types.
 */
public protocol RichTextImageAttachmentManager: RichTextReader {}

extension NSAttributedString: RichTextImageAttachmentManager {}

public extension RichTextImageAttachmentManager {

    /**
     Get the attachment bounds of an image, given a max size.
     */
    func attachmentBounds(
        for image: ImageRepresentable,
        maxSize: CGSize) -> CGRect {
        let size = attachmentSize(for: image, maxSize: maxSize)
        return CGRect(origin: .zero, size: size)
    }

    /**
     Get the attachment size of an image, given a max size.
     */
    func attachmentSize(
        for image: ImageRepresentable,
        maxSize: CGSize) -> CGSize {
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

#if os(iOS) || os(macOS) || os(tvOS)
public extension RichTextImageAttachmentManager {

    /**
     Auto-size all images attachments within a rich text, by
     applying a max image size.
     */
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

private extension NSTextAttachment {

    var attachedImage: ImageRepresentable? {
        if let image = self.image { return image }
        guard let imageData = self.contents else { return nil }
        return ImageRepresentable(data: imageData)
    }
}
#endif
