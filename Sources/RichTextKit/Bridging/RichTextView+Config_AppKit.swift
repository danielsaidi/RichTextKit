//
//  RichTextView+Config_AppKit.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-01-16.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

#if macOS
import Foundation

public extension RichTextView {

    /// This type can configure a ``RichTextEditor``.
    struct Configuration {

        /// Create a custom configuration
        /// 
        /// - Parameters:
        ///   - isScrollingEnabled: Whether the editor should scroll, by default `true`.
        ///   - isScrollBarsVisible: Whether the editor should show scrollbars, by default `isScrollingEnabled`.
        ///   - isContinuousSpellCheckingEnabled: Whether the editor spell-checks in realtime. Defaults to `true`.
        public init(
            isScrollingEnabled: Bool = true,
            isScrollBarsVisible: Bool? = nil,
            isContinuousSpellCheckingEnabled: Bool = true
        ) {
            self.isScrollingEnabled = isScrollingEnabled
            self.isScrollBarsVisible = isScrollBarsVisible ?? isScrollingEnabled
            self.isContinuousSpellCheckingEnabled = isContinuousSpellCheckingEnabled
        }

        /// Whether the editor should scroll.
        public var isScrollingEnabled: Bool

        /// Whether the editor should show scrollbars.
        public var isScrollBarsVisible: Bool

        /// Whether the editor spell-checks in realtime.
        public var isContinuousSpellCheckingEnabled: Bool
    }
}
#endif
