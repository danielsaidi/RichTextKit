//
//  RichTextInsertion.swift
//  RichTextKit
//
//  Created by Dominik Bucher on 17.01.2024.
//

import Foundation

/// This protocol can be implemented by anything that can be
/// inserted into a rich text.
public protocol RichTextInsertable: Hashable, Equatable {}

extension String: RichTextInsertable {}
extension ImageRepresentable: RichTextInsertable {}
extension [ImageRepresentable]: RichTextInsertable {}
extension NSAttributedString: RichTextInsertable {}

/// This struct represents something that should be inserted
/// into a rich text attributed string.
public struct RichTextInsertion<T: RichTextInsertable>: Hashable, Equatable {
    
    /// Create a rich text insertion.
    ///
    /// - Parameters:
    ///   - content: The content to insert.
    ///   - index: The index at where to insert.
    ///   - moveCursor: Whether or not to move the cursor to the insertion point.
    public init(
        content: T,
        index: Int,
        moveCursor: Bool
    ) {
        self.content = content
        self.index = index
        self.moveCursor = moveCursor
    }
    
    /// The content to insert.
    public let content: T
    
    /// The index at where to insert.
    public let index: Int
    
    /// Whether or not to move the cursor to the insertion point.
    public let moveCursor: Bool
}

public extension RichTextInsertion {
    
    /// This is a shorthand for creating an image insertion.
    static func image(
        _ image: ImageRepresentable,
        at index: Int,
        moveCursor: Bool
    ) -> RichTextInsertion<ImageRepresentable> {
        .init(content: image, index: index, moveCursor: moveCursor)
    }
    
    /// This is a shorthand for creating an image insertion.
    static func images(
        _ images: [ImageRepresentable],
        at index: Int,
        moveCursor: Bool
    ) -> RichTextInsertion<[ImageRepresentable]> {
        .init(content: images, index: index, moveCursor: moveCursor)
    }
    
    /// This is a shorthand for creating a text insertion.
    static func text(
        _ text: String,
        at index: Int,
        moveCursor: Bool
    ) -> RichTextInsertion<String> {
        .init(content: text, index: index, moveCursor: moveCursor)
    }
}
