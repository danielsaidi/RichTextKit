//
//  RichTextLabelValue.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-01-22.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

/// This protocol can be implemented by any rich text label values.
public protocol RichTextLabelValue: Hashable {

    /// The value icon.
    var icon: Image { get }

    /// The value display title.
    var title: String { get }
}

public extension RichTextLabelValue {

    /// The standard label to use for the value.
    var label: some View {
        Label(
            title: { Text(title) },
            icon: { icon }
        )
        .tag(self)
    }
}
