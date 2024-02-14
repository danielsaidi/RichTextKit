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
    typealias Index = Int
    let content: T
    let at: Index
    let moveCursor: Bool
}
