//
//  NSParagraphStyle+Views.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2025-04-04.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension Image {
    
    /// Create a default icon for the provided key path.
    init?<ValueType>(for value: KeyPath<NSParagraphStyle, ValueType>) {
        guard let icon = value.defaultIcon else { return nil }
        self = icon
    }
}

public extension KeyPath where Root == NSParagraphStyle {
    
    /// The default icon for the key path.
    var defaultIcon: Image? {
        switch self {
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

public extension NSTextAlignment {
    
    /// The default icon for the text alignment.
    var defaultIcon: Image? {
        switch self {
        case .center: .richTextAlignmentCenter
        case .justified: .richTextAlignmentJustified
        case .left: .richTextAlignmentLeft
        case .natural: .richTextAlignmentLeft
        case .right: .richTextAlignmentRight
        @unknown default: .richTextUnknownValueType
        }
    }
    
    /// The default label for the text alignment.
    var defaultLabel: some View {
        Label {
            Text(title)
        } icon: {
            defaultIcon
        }
    }
}

@ViewBuilder
private func previewIcon<ValueType>(
    for keyPath: KeyPath<NSParagraphStyle, ValueType>,
    _ title: String
) -> some View {
    if let image = Image(for: keyPath) {
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
