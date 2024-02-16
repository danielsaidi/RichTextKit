//
//  RichTextView+Config_AppKit.swift
//
//  Created by Dominik Bucher on 13.02.2024.
//

#if macOS
import Foundation

public extension RichTextView {

    /**
     This type can be used to configure a ``RichTextEditor``.
     */
    struct Configuration {

        /// Create a custom configuration
        /// - Parameters:
        ///   - isScrollingEnabled: Whether or not the editor should scroll, by default `true`.
        ///   - isContinuousSpellCheckingEnabled: Whether the editor spell-checks in realtime. Defaults to `true`.
        public init(
            isScrollingEnabled: Bool = true,
            isContinuousSpellCheckingEnabled: Bool = true
        ) {
            self.isScrollingEnabled = isScrollingEnabled
            self.isContinuousSpellCheckingEnabled = isContinuousSpellCheckingEnabled
        }

        /// Whether or not the editor should scroll.
        public var isScrollingEnabled: Bool
        
        /// Whether the editor spell-checks in realtime.
        public var isContinuousSpellCheckingEnabled: Bool
    }
}
#endif
