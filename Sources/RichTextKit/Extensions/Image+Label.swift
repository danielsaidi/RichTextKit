//
//  Image+Label.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-20.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

extension Image {

    /// Create a label from the icon.
    func label(_ title: String) -> some View {
        Label {
            Text(title)
        } icon: {
            self
        }
    }
}
