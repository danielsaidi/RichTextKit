//
//  Image+RichTextParagraphStyle.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2025-04-04.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension Image {
    
    static func richTextParagraphStyleValue<ValueType>(
        _ keyPath: KeyPath<NSParagraphStyle, ValueType>
    ) -> Image? {
        switch keyPath {
        case \.alignment: .richTextAlignmentLeft
        case \.baseWritingDirection: .symbol("pencil.line")
        case \.firstLineHeadIndent: .symbol("increase.indent")
        case \.headIndent: .symbol("increase.indent")
        case \.lineHeightMultiple: .symbol("arrow.up.and.down.text.horizontal")
        case \.lineSpacing: .symbol("arrow.up.and.down.text.horizontal")
        case \.maximumLineHeight: .symbol("arrow.up.and.down.text.horizontal")
        case \.minimumLineHeight: .symbol("arrow.up.and.down.text.horizontal")
        default: nil
        }
    }
}

@ViewBuilder
private func previewIcon<ValueType>(
    for keyPath: KeyPath<NSParagraphStyle, ValueType>,
    _ title: String
) -> some View {
    if let image = Image.richTextParagraphStyleValue(keyPath) {
        Label {
            Text(title)
        } icon: {
            image
        }
    } else {
        EmptyView()
    }
}

#Preview {
    
    List {
        previewIcon(for: \.alignment, ".alignment")
        previewIcon(for: \.baseWritingDirection, ".baseWritingDirection")
        previewIcon(for: \.firstLineHeadIndent, ".firstLineHeadIndent")
        previewIcon(for: \.headIndent, ".headIndent")
        previewIcon(for: \.lineBreakMode, ".lineBreakMode")
        previewIcon(for: \.lineHeightMultiple, ".lineHeightMultiple")
        previewIcon(for: \.lineSpacing, ".lineSpacing")
        previewIcon(for: \.maximumLineHeight, ".maximumLineHeight")
        previewIcon(for: \.minimumLineHeight, ".minimumLineHeight")
    }
}
