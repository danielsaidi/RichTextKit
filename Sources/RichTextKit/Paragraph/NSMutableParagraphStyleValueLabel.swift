//
//  NSMutableParagraphStyleValueLabel.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2025-04-06.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

import SwiftUI

/// This internal view is used by the Picker when building a
/// picker for a certain rich text paragraph value.
public struct NSMutableParagraphStyleValueLabel<ValueType: Hashable, ValueLabel: View>: View {
    
    let values: [ValueType]
    let valueLabel: (ValueType) -> ValueLabel
    
    public var body: some View {
        ForEach(Array(values.enumerated()), id: \.offset) {
            valueLabel($0.element).tag($0.offset)
        }
    }
}
