//
//  UTType+RichText.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import UniformTypeIdentifiers

public extension UTType {
    
    /// Uniform rich text types that RichTextKit supports.
    static let richTextTypes: [UTType] = [
        .archivedData,
        .rtf,
        .text,
        .plainText,
        .data
    ]
    
    /// The uniform type for ``RichTextFormat/archivedData``.
    static let archivedData = UTType(
        exportedAs: "com.richtextkit.archiveddata")
}

public extension Collection where Element == UTType {

    /// The uniforum types that rich text documents support.
    static var richTextTypes: [UTType] { UTType.richTextTypes }
}
