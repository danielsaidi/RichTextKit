//
//  RichTextIndent.swift
//  RichTextKit
//
//  Created by James Bradley on 2022-03-04.
//  Copyright © 2023 James Bradley. All rights reserved.
//

import SwiftUI

/**
 This enum simplifies working with different text indents.
 */
public enum RichTextIndent: CaseIterable, Codable, Equatable, Identifiable {

    /**
     Initialize a rich text indent with a native indent.

     - Parameters:
       - indent: The native indent to use.
     */
//    public init(_ indent: CGFloat) {
//
//    }
    
    /// Reduce indent space.
    case decrease
    
    /// Increase indent space.
    case increase
}

public extension RichTextIndent {

    /**
     The unique ID of the indent.
     */
    var id: UUID { UUID() }
    
    /**
     The standard icon to use for the indent.
     */
    var icon: Image {
        switch self {
        case .decrease: return .richTextIndentDecrease
        case .increase: return .richTextIndentIncrease
        }
    }
}
