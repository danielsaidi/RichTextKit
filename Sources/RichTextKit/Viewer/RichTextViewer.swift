//
//  RichTextViewer.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-03-28.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(tvOS) || os(visionOS)
import SwiftUI

/// This view can be used to display rich text without being
/// able to edit it.
public struct RichTextViewer: View {

    public init(_ text: String) {
        self.init(NSAttributedString(string: text))
    }

    public init(_ text: NSAttributedString) {
        self.text = text
        self.context = .init()
        context.isEditable = false
    }

    private let text: NSAttributedString
    private let context: RichTextContext

    public var body: some View {
        RichTextEditor(text: .constant(text), context: context)
    }
}
#endif
