//
//  ViewDebug.swift
//  Demo
//
//  Created by Daniel Saidi on 2022-12-15.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

final class ViewDebug {

    /**
     Make any view draw a random background color every time
     it's redrawn.
     */
    static var isEnabled = false
}

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

private extension Color {

    /**
     Generate a random color.

     - Parameters:
       - range: The random color range, by default `0...1`.
       - randomOpacity: Whether or not to randomize opacity as well, by default `false`.
     */
    static func random(
        in range: ClosedRange<Double> = 0...1,
        randomOpacity: Bool = false
    ) -> Color {
        Color(
            red: .random(in: range),
            green: .random(in: range),
            blue: .random(in: range),
            opacity: randomOpacity ? .random(in: 0...1) : 1
        )
    }
}
