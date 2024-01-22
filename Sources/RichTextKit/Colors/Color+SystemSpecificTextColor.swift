//
//  Color+SystemSpecificTextColor.swift
//
//
//  Created by Dominik Bucher on 22.01.2024.
//

import SwiftUI

extension Color {
#if macOS
    // on macOS
    static let systemSpecificTextColor: Color? = Color(NSColor.textColor)
#else
    static let systemSpecificTextColor: Color? = nil
#endif
}
