//
//  RichTextView+Setup.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-03-04.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

extension RichTextView {
    
    func setupSharedBehavior(
        with text: NSAttributedString,
        _ format: RichTextDataFormat
    ) {
        attributedString = .empty
        imageConfiguration = standardImageConfiguration(for: format)
        attributedString = text
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    func setup(_ theme: RichTextView.Theme) {
        guard richText.string.isEmpty else { return }
        font = theme.font
        textColor = theme.fontColor
        backgroundColor = theme.backgroundColor
    }
}
