//
//  RichTextImageAttachment.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-05.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if iOS || os(tvOS) || os(visionOS)
import UIKit
#endif

#if macOS
import AppKit
#endif

#if iOS || macOS || os(tvOS) || os(visionOS)
import UniformTypeIdentifiers

/**
 This custom attachment type inherits `NSTextAttachment` and
 aims to solve multi-platform image attachment problems.

 When using `NSTextAttachment` directly, any images added by
 iOS can't be loaded on macOS, and vice versa. To solve this,
 this custom attachment class uses the `contents` data, then
 overrides `image` on iOS and `attachmentCell` on macOS.

 This is probably the wrong way to solve this problem, but I
 haven't been able to find another way. If we set `image` on
 a plain `NSTextAttachment`, it can add and load attachments
 on the same platform, but fails on other platforms.

 Another problem with `NSTextAttachment`, is that it results
 in large files, since it by default doesn't specify uniform
 type identifier or compression, which makes it handle image
 attachments as huge png data. This attachment allows you to
 easily use jpg with a custom compression rate instead.

 # WARNING

 If we use ``RichTextDataFormat/archivedData`` to persist an
 image attachment, we'll use `NSKeyedArchiver` to archive it
 and `NSKeyedUnarchiver` to unarchive it. This requires that
 the types within the archive data still exist when the data
 is unarchived. If any type is missing, you must register an
 unarchiver class replacement like this:

 ```
 let unarchiver = NSKeyedUnarchiver()
 unarchiver.setClass(MyNewAttachment.self, forClassName: "...")`
 ```

 You'll see the name of the missing class in the unarchiving
 error, so just use that name as the class name.
 */
@preconcurrency @MainActor
open class RichTextImageAttachment: NSTextAttachment {

    /**
     Create a custom image attachment with an JPEG image and
     no image compression.

     - Parameters:
       - image: The image to add to the attachment.
     */
    public convenience init(
        jpegImage image: ImageRepresentable
    ) {
        self.init(jpegImage: image, compressionQuality: 1.0)
    }

    /**
     Create a custom image attachment with an JPEG image and
     a custom compression rate.

     - Parameters:
       - image: The image to add to the attachment.
       - compressionQuality: The percentage rate to apply.
     */
    public convenience init(
        jpegImage image: ImageRepresentable,
        compressionQuality: CGFloat = 0.7
    ) {
        let data = image.jpegData(compressionQuality: compressionQuality)
        self.init(jpegData: data)
        contents = data
    }

    /**
     Create a custom image attachment with PNG data.

     Note that using PNG data may result in large file sizes.
     */
    public convenience init(
        jpegData data: Data?
    ) {
        self.init(data: data, ofType: UTType.jpeg.identifier)
    }

    /**
     Create a custom image attachment with PNG data.

     Note that using PNG data may result in large file sizes.
     */
    public convenience init(
        pngData data: Data?
    ) {
        self.init(data: data, ofType: UTType.png.identifier)
    }

    /**
     Create a custom image attachment using plain image data
     and a custom uniform type.

     - Parameters:
       - data: The data to add to the attachment.
       - type: The uniform type to use, e.g. `UTType.jpeg`.
     */
    public convenience init(
        data contentData: Data?,
        ofType type: UTType
    ) {
        self.init(data: contentData, ofType: type.identifier)
    }

    /**
     Create a custom image attachment using plain image data
     and a custom uniform type.

     - Parameters:
       - data: The data to add to the attachment.
       - uti: The uniform type identifier, e.g. `UTType.jpeg.identifier`
     */
    public override init(
        data contentData: Data?,
        ofType uti: String?
    ) {
        super.init(data: contentData, ofType: uti)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    /**
     Whether or not the attachment supports secure coding.

     This attachment type supports secure coding by default.
     */
    public override class var supportsSecureCoding: Bool { true }

    #if iOS || os(tvOS) || os(visionOS)
    /**
     Get or set the attachment image.

     This will use the underlying functionality to setup the
     attachment in a way that makes it multi-platform.
     */
    public override var image: UIImage? {
        get {
            guard let data = contents else { return nil }
            return ImageRepresentable(data: data)
        }
        set {
            super.image = newValue
        }
    }
    #endif

    #if macOS
    /**
     Get or set the attachment image.

     This will use the underlying functionality to setup the
     attachment in a way that makes it multi-platform.
     */
    public override var attachmentCell: NSTextAttachmentCellProtocol? {
        get {
            guard
                let data = contents,
                let image = ImageRepresentable(data: data)
            else { return nil }
            return MainActor.assumeIsolated {
                NSTextAttachmentCell(imageCell: image)
            }
        }
        set {
            super.attachmentCell = newValue
        }
    }
    #endif
}
#endif
