//
//  RichTextImageConfiguration.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This struct can be used to configure how images are handled
 in e.g. a ``RichTextView``.
 
 The paste and drop configurations should be `.disabled` for
 rich text formats that don't support inserting images, like
 .txt and .rtf (where images must be added to a sub-folder).
 */
public struct RichTextImageConfiguration {
    
    /**
     Create a rich text image configuration.
     
     - Parameters:
       - pasteConfiguration: The configuration to use when pasting images.
       - dropConfiguration: The configuration to use when dropping images.
       - maxImageSize: The max size to limit images in the text view to.
     */
    public init(
        pasteConfiguration: ImageInsertConfiguration,
        dropConfiguration: ImageInsertConfiguration,
        maxImageSize: (width: ImageAttachmentSize, height: ImageAttachmentSize)) {
        self.pasteConfiguration = pasteConfiguration
        self.dropConfiguration = dropConfiguration
        self.maxImageSize = maxImageSize
    }
    
    
    /**
     The image configuration to use when dropping images.
     */
    public var dropConfiguration: ImageInsertConfiguration
    
    /**
     The max size to limit images in the text view to.
     */
    public var maxImageSize: (width: ImageAttachmentSize, height: ImageAttachmentSize)
    
    /**
     The image configuration to use when pasting images.
     */
    public var pasteConfiguration: ImageInsertConfiguration
}

public extension RichTextImageConfiguration {
    
    /**
     Get a disabled image configuration.
     */
    static var disabled: RichTextImageConfiguration {
        RichTextImageConfiguration(
            pasteConfiguration: .disabled,
            dropConfiguration: .disabled,
            maxImageSize: (width: .frame, height: .frame)
        )
    }
}
