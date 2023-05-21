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
public enum RichTextIndent: CGFloat, CaseIterable, Codable, Equatable, Identifiable {
    
    /**
     Initialize a rich text indent with a native indent.
     
     - Parameters:
     - indent: The native indent to use.
     */
    init(_ indent: CGFloat) {
        self = indent >= 0 ? .increase : .decrease
    }
    
    /// Reduce indent space.
    case decrease = -30.0
    
    /// Increase indent space.
    case increase = 30.0
}

public extension RichTextIndent {
    
    /**
     The unique ID of the indent.
     */
    var id: CGFloat { rawValue }
    
    
    
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
