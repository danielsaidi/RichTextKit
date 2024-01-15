//
//  RichTextReader+Deprecated.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-01-15.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextReader {
    
    @available(*, deprecated, renamed: "richTextFullRange")
    var richTextRange: NSRange { richTextFullRange }
}
