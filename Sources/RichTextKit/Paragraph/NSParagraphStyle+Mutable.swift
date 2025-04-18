//
//  NSMutableParagraphStyle+Mutable.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2025-04-04.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension NSMutableParagraphStyle {

    /// Create a mutable copy or a brand new instance.
    static var defaultMutable: NSMutableParagraphStyle {
        NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle ?? .init()
    }
}
