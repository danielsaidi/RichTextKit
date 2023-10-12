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
    
    /// Reduce indent space.
    case decrease
    
    /// Increase indent space.
    case increase
}

public extension RichTextIndent {

    /// The indent's unique ID.
    var id: UUID { UUID() }
    
    /// The indent's standard icon.
    var icon: Image {
        switch self {
        case .decrease: return .richTextIndentDecrease
        case .increase: return .richTextIndentIncrease
        }
    }
}
