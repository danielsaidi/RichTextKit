//
//  RichTextViewComponent+Images.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-05.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

public extension RichTextViewComponent {

    /// Get the attachment max size for a certain image.
    var imageAttachmentMaxSize: CGSize {
        let maxSize = imageConfiguration.maxImageSize
        let insetX = 2 * textContentInset.width
        let insetY = 2 * textContentInset.height
        let paddedFrame = frame.insetBy(dx: insetX, dy: insetY)
        let width = maxSize.width.width(in: paddedFrame)
        let height = maxSize.height.height(in: paddedFrame)
        return CGSize(width: width, height: height)
    }

    /// Get the attachment bounds for a certain image.
    func attachmentBounds(
        for image: ImageRepresentable
    ) -> CGRect {
        attributedString.attachmentBounds(
            for: image,
            maxSize: imageAttachmentMaxSize
        )
    }

    /// Get the attachment size for a certain image.
    func attachmentSize(for image: ImageRepresentable) -> CGSize {
        attributedString.attachmentSize(
            for: image,
            maxSize: imageAttachmentMaxSize
        )
    }

    /// Get the current image drop configuration.
    var imageDropConfiguration: RichTextImageInsertConfiguration {
        imageConfiguration.dropConfiguration
    }

    /// Get the current image paste configuration.
    var imagePasteConfiguration: RichTextImageInsertConfiguration {
        imageConfiguration.pasteConfiguration
    }


    /// Validate that image drop will be performed.
    func validateImageInsertion(
        for config: RichTextImageInsertConfiguration
    ) -> Bool {
        switch config {
        case .disabled:
            return false
        case .disabledWithWarning(let title, let message):
            alert(title: title, message: message)
            return false
        case .enabled:
            return true
        }
    }
}
