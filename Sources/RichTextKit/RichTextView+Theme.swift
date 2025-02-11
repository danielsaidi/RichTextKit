//
//  RichTextView+Theme.swift
//  RichTextKit
//
//  Created by Dominik Bucher on 13.02.2024.
//

#if iOS || macOS || os(tvOS) || os(visionOS)
import SwiftUI

public extension RichTextView {

    /// This type can configure a ``RichTextEditor`` theme.
    struct Theme {

        /// Create a custom configuration.
        ///
        /// - Parameters:
        ///   - font: default `.systemFont` of point size `16` (this differs on iOS and macOS).
        ///   - fontColor: default `.textColor`.
        ///   - backgroundColor: Color of whole textView default `.clear`.
        ///   - linkColor: The color to use for links, default is system link color.
        ///   - paragraphStyle: The paragraph style to use, default is standard paragraph style.
        public init(
            font: FontRepresentable = .systemFont(ofSize: 16),
            fontColor: ColorRepresentable = .textColor,
            backgroundColor: ColorRepresentable = .clear,
            linkColor: ColorRepresentable? = nil,
            paragraphStyle: NSParagraphStyle = NSParagraphStyle.default
        ) {
            self.font = font
            self.fontColor = fontColor
            self.backgroundColor = backgroundColor
            self.linkColor = linkColor
            self.paragraphStyle = paragraphStyle
        }

        public let font: FontRepresentable
        public let fontColor: ColorRepresentable
        public let backgroundColor: ColorRepresentable
        public let linkColor: ColorRepresentable?
        public let paragraphStyle: NSParagraphStyle
    }
}

public extension RichTextView.Theme {

    /// The standard rich text view theme.
    static var standard: Self { .init() }
}
#endif
