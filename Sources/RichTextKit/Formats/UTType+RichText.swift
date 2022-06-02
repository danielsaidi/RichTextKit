//
//  UTType+RichText.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import UniformTypeIdentifiers

public extension UTType {
    
    /**
     The uniforum types an Oribi rich text document supports.
     */
    static let richTextTypes: [UTType] = [
        .richTextKit,
        .rtf,
        .text,
        .plainText,
        .data
    ]
    
    /**
     The uniform type that is used by OribiWriter.
     */
    static let richTextKit = UTType(
        exportedAs: "com.richtextkit.format")
}

public extension Collection where Element == UTType {
    
    /**
     The uniforum types an Oribi rich text document supports.
     */
    static var oribiRichTextTypes: [UTType] { UTType.richTextTypes }
}
