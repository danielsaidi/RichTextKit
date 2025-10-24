//
//  RichTextImageAttachmentSize.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import CoreGraphics

/// This enum defines various ways to size images in rich text.
public enum RichTextImageAttachmentSize {

    /// This size aims to make image fit the frame.
    case frame

    /// This size aims to make image fit the size in points.
    case points(CGFloat)
}

public extension RichTextImageAttachmentSize {

    /// The image's resulting height in a certain frame.
    func height(in frame: CGRect) -> CGFloat {
        switch self {
        case .frame: frame.height
        case .points(let points): points
        }
    }

    /// The image's resulting width in a certain frame.
    func width(in frame: CGRect) -> CGFloat {
        switch self {
        case .frame: frame.width
        case .points(let points): points
        }
    }
}
