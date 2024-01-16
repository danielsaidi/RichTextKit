//
//  RichTextView+Config.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-01-16.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(tvOS) || os(visionOS)
import SwiftUI

public extension RichTextView {

    /**
     This type can be used to configure a ``RichTextEditor``.
     */
    struct Configuration {

        /**
         Create a custom configuration.

         - Parameters:
           - isScrollingEnabled: Whether or not the editor should scroll, by default `true`.
         */
        public init(
            isScrollingEnabled: Bool = true
        ) {
            self.isScrollingEnabled = isScrollingEnabled
        }

        /// Whether or not the editor should scroll.
        public var isScrollingEnabled: Bool
    }
}

public extension RichTextView.Configuration {

    /// Get a standard rich text editor configuration.
    static var standard: Self { .init() }
}
#endif
