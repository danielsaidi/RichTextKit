//
//  RichTextTag.swift
//  RichTextKit
//
//  Created by James Bradley on 2023-03-23.
//  Copyright © 2023 James Bradley. All rights reserved.
//

#if os(iOS) || os(macOS) || os(tvOS)
import Combine
import SwiftUI

public extension NSUnderlineStyle {
    
    static var tagBasic: NSUnderlineStyle {
        return NSUnderlineStyle(rawValue: 0x11)
    }
    
}

#endif
