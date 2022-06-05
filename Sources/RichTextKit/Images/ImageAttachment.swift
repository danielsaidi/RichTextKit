//
//  ImageAttachment.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-05.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(iOS)
import UIKit
#endif

#if os(macOS)
import AppKit
#endif

#if os(iOS) || os(macOS)
import UniformTypeIdentifiers

/**
 This custom attachment type inherits `NSTextAttachment` and
 aims to solve multi-platform image attachment problems.
 
 When using `NSTextAttachment` directly, any images added by
 iOS can't be loaded on macOS, and vice versa. To solve this,
 this custom attachment class uses the `contents` data, then
 overrides `image` on iOS and `attachmentCell` on macOS.
 
 This is probably the wrong way to solve this problem, but I
 haven't been able to find another way. If we set the `image`
 property of a plain `NSTextAttachment`, it works to add and
 load the attachment on the same platform, but trying to use
 the attachment on other platforms will fail.

 Another problem with `NSTextAttachment`, is that it results
 in large files, since it by default doesn't specify uniform
 type identifier or compression, which makes it handle image
 attachments as (potentially) huge png data. This attachment
 allows you to easily use jpg with a custom compression rate
 instead, which results in much smaller files.
 
 # WARNING

 If we use ``RichTextDataFormat/archivedData`` to persist an
 image attachment in a string, we'll use an `NSKeyedArchiver`
 to archive the data and an `NSKeyedUnarchiver` to unarchive
 it. This requires that the attachment types that are stored
 into the archive data exist when the data is unarchived. If
 any type is missing, this unarchiving will fail. This means
 that if you later decide to use another library to handle a
 file that contains an ``ImageAttachment``, you must setup a
 custom class for the unarchiver, for instance:

 ```
 let unarchiver = NSKeyedUnarchiver()
 unarchiver.setClass(MyNewAttachment.self, forClassName: "...")`
 ```

 You'll see the name of the missing class in the unarchiving
 error, so just pop that name in as the class name.
 */
public class ImageAttachment: NSTextAttachment {

    /**
     Create a custom image attachment with an JPEG image and
     no image compression.

     - Parameters:
       - image: The image to use in the attachment.
     */
    public convenience init(jpegImage image: ImageRepresentable) {
        self.init(jpegImage: image, compressionQuality: 1.0)
    }

    /**
     Create a custom image attachment with an JPEG image and
     a custom compression rate.

     - Parameters:
       - image: The image to use in the attachment.
       - compressionQuality: The percentage rate to apply, by default `0.7`.
     */
    public init(
        jpegImage image: ImageRepresentable,
        compressionQuality: CGFloat = 0.7
    ) {
        let image = image.jpegData(compressionQuality: compressionQuality)
        super.init(data: image, ofType: UTType.jpeg.identifier)
        contents = image
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override init(data contentData: Data?, ofType uti: String?) {
        super.init(data: contentData, ofType: uti)
    }


    /**
     Whether or not the attachment supports secure coding.

     This attachment type supports secure coding by default.
     */
    public override class var supportsSecureCoding: Bool { true }

    
    #if os(iOS)
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
    
    #if os(macOS)
    /**
     Get or set the attachment image.

     This will use the underlying functionality to setup the
     attachment in a way that makes it multi-platform.
     */
    public override var attachmentCell: NSTextAttachmentCellProtocol? {
        get {
            guard let data = contents else { return nil }
            guard let image = ImageRepresentable(data: data) else { return nil }
            return NSTextAttachmentCell(imageCell: image)
        }
        set {
            super.attachmentCell = newValue
        }
    }
    #endif
}
#endif
