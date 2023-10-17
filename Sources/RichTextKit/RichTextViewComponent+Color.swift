//
//  RichTextViewComponent+Color.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextViewComponent {
    
    /// Get the current background color.
    var currentBackgroundColor: ColorRepresentable? {
        currentRichTextAttribute(.backgroundColor)
    }

    /// Get the current foreground color.
    var currentForegroundColor: ColorRepresentable? {
        currentRichTextAttribute(.foregroundColor)
    }
    
    /// Get the current stroke color.
    var currentStrokeColor: ColorRepresentable? {
        currentRichTextAttribute(.strokeColor)
    }

    /// Get the current strikethrough color.
    var currentStrikethroughColor: ColorRepresentable? {
        currentRichTextAttribute(.strikethroughColor)
    }

    /// Set the current background color.
    func setCurrentBackgroundColor(
        _ color: ColorRepresentable
    ) {
        setCurrentRichTextAttribute(.backgroundColor, to: color)
    }
    
    /// Set the current foreground color.
    func setCurrentForegroundColor(
        _ color: ColorRepresentable
    ) {
        setCurrentRichTextAttribute(.foregroundColor, to: color)
    }
    
    /// Set the current stroke color.
    func setCurrentStrokeColor(
        _ color: ColorRepresentable
    ) {
        setCurrentRichTextAttribute(.strokeColor, to: color)
    }
    
    /// Set the current strikethrough color.
    func setCurrentStrikethroughColor(
        _ color: ColorRepresentable
    ) {
        setCurrentRichTextAttribute(.strikethroughColor, to: color)
    }
}
