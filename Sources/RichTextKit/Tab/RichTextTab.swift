//
//  RichTextTab.swift
//  RichTextKit
//
//  Created by James Bradley on 2022-03-04.
//  Copyright © 2023 James Bradley. All rights reserved.
//

import SwiftUI

/**
 This enum simplifies working with different text tabs.
 */
public enum RichTextTab: String, CaseIterable, Codable, Equatable, Identifiable {

    /**
     Initialize a rich text tab with a native tab.

     - Parameters:
       - tab: The native tab to use.
     */
    public init(_ tab: Int) {
        switch tab {
        case 0: self = .zero
        case 1: self = .single
        case 2: self = .double
        default: self = .zero
        }
    }
    
    /// Zero tab space
    case zero
    
    /// Single tab space.
    case single

    /// Double tab space.
    case double
}

public extension RichTextTab {

    /**
     The unique ID of the tab.
     */
    var id: String { rawValue }
    
    /**
     The standard icon to use for the tab.
     */
    var icon: Image {
        switch self {
        case .zero: return .richTextTabSingle
        case .single: return .richTextTabSingle
        case .double: return .richTextTabDouble
        }
    }

    /**
     The native tab of the tab.
     */
    var nativeTab: [NSTextTab] {
        switch self {
        case .zero: return [NSTextTab(textAlignment: NSTextAlignment.left, location: 0, options: [:])]
        case .single: return [NSTextTab(textAlignment: NSTextAlignment.left, location: 150, options: [:])]
        case .double: return [NSTextTab(textAlignment: NSTextAlignment.left, location: 300, options: [:])]
        }
    }
}
