//
//  RichTextImageInsertConfiguration.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This enum can be used to configure the image drop and paste
 behavior of a ``RichTextView``.
 
 The configuration is needed, since ``RichTextDataFormat/rtf``
 and ``RichTextDataFormat/plainText`` doesn't support images
 and a text view does not know the format of the string that
 it contains.
 */
public enum RichTextImageInsertConfiguration: Equatable {
    
    /// Image inserting is disabled
    case disabled
    
    /// Image inserting is enabled but aborts with a warning
    case disabledWithWarning(title: String, message: String)
    
    /// Image inserting is enabled
    case enabled
}
