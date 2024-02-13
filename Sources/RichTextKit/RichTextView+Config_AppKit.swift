//
//  RichTextView+Config_AppKit.swift
//  
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
        
        public init(
            isScrollingEnabled: Bool = true,
            isContinuousSpellCheckingEnabled: Bool = true
        ) {
            self.isScrollingEnabled = isScrollingEnabled
            self.isContinuousSpellCheckingEnabled = isContinuousSpellCheckingEnabled
        }
        
        /// Whether or not the editor should scroll.
        public var isScrollingEnabled: Bool
        public var isContinuousSpellCheckingEnabled: Bool
    }
}
#endif
