//
//  RichTextView+Config.swift
//  RichTextKit
//
//  Created by Dominik Bucher on 13.02.2024.
//

import Foundation

#if iOS || macOS || os(tvOS) || os(visionOS)
public extension RichTextView.Configuration {

    /// The standard rich text view configuration.
    ///
    /// You can set a new value to change the global default.
    static var standard = Self()
}
#endif
