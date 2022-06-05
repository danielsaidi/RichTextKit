//
//  RichTextImageInsertConfiguration.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This enum can be used to configure the image drop and paste
 behavior of a ``RichTextView``.
 
 This configuration is needed, since .txt and .rtf documents
 don't support images, and a rich text view doesn't know the
 format of the string that it contains.
 */
public enum RichTextImageInsertConfiguration: Equatable {
    
    /// Image inserting is disabled
    case disabled
    
    /// Image inserting is enabled but aborts with a warning
    case disabledWithWarning(title: String, message: String)
    
    /// Image inserting is enabled
    case enabled
}
