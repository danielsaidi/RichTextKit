//
//  RichTextHighlightingStyle.swift
//  RichTextKit

//  Created by Daniel Saidi on 2022-06-04.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This struct can be used to style rich text highlighting.
 */
public struct RichTextHighlightingStyle: Equatable {
    
    /**
     Create a style instance.

     - Parameters:
       - backgroundColor: The background color to use for highlighted text.
       - foregroundColor: The foreground color to use for highlighted text.
     */
    public init(
        backgroundColor: Color = .clear,
        foregroundColor: Color = .accentColor
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
    
    /**
     The background color to use for highlighted text.
     */
    public let backgroundColor: Color
    
    /**
     The foreground color to use for highlighted text.
     */
    public let foregroundColor: Color
}

public extension RichTextHighlightingStyle {

    /**
     The standard rich text highlighting style, which uses a
     clear background color and an accent foreground color.
     
     You can override this value to change the global style.
     */
    static var standard = RichTextHighlightingStyle()
}
