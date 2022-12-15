//
//  View+ViewDebug.swift
//  Demo
//
//  Created by Daniel Saidi on 2022-12-15.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension View {

    /**
     Make the view draw a random background color every time
     it's redrawn, but only if `ViewDebug.isEnabled` is true.
     */
    @ViewBuilder
    func viewDebug() -> some View {
        if ViewDebug.isEnabled {
            self.background(Color.random())
        } else {
            self
        }
    }
}
