//
//  RichTextViewRepresentable+Images.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-05.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

public extension RichTextViewRepresentable {

    /**
     Get the attachment max size for a certain image.

     - Parameters:
       - image: The image to calculate max size for.
     */
    var imageAttachmentMaxSize: CGSize {
        let maxSize = imageConfiguration.maxImageSize
        let insetX = 2 * textContentInset.width
        let insetY = 2 * textContentInset.height
        let paddedFrame = frame.insetBy(dx: insetX, dy: insetY)
        let width = maxSize.width.width(in: paddedFrame)
        let height = maxSize.height.height(in: paddedFrame)
        return CGSize(width: width, height: height)
    }

    /**
     Get the attachment bounds for a certain image.

     - Parameters:
       - image: The image to calculate bounds for.
     */
    func attachmentBounds(for image: ImageRepresentable) -> CGRect {
        attributedString.attachmentBounds(
            for: image,
            maxSize: imageAttachmentMaxSize)
    }

    /**
     Get the attachment size for a certain image.

     - Parameters:
       - image: The image to calculate size for.
     */
    func attachmentSize(for image: ImageRepresentable) -> CGSize {
        richText.attachmentSize(
            for: image,
            maxSize: imageAttachmentMaxSize)
    }

    /**
     The image paste configuration to use by the view.
     */
    var imageDropConfiguration: RichTextImageInsertConfiguration {
        imageConfiguration.dropConfiguration
    }

    /**
     The image paste configuration to use by the view.
     */
    var imagePasteConfiguration: RichTextImageInsertConfiguration {
        imageConfiguration.pasteConfiguration
    }


    /**
     Validate that image drop will be performed. If not, the
     function will present a warning alert.

     - Parameters:
       - config: The image insert configuration to validate.
     */
    func validateImageInsertion(
        for config: RichTextImageInsertConfiguration
    ) -> Bool {
        switch config {
        case .disabled:
            return false
        case .disabledWithWarning(let title, let message):
            alert(title, message: message)
            return false
        case .enabled:
            return true
        }
    }
}
