//
//  Label+Init.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-20.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

extension Label where Icon == Image, Title == Text {

    init(_ title: String, _ image: Image) {
        self.init {
            Text(title)
        } icon: {
            image
        }
    }
}
