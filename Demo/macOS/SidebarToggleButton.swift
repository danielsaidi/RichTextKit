//
//  SidebarToggleButton.swift
//  Demo (macOS)
//
//  Created by Daniel Saidi on 2022-12-10.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This will not be needed when we bump the demo to the latest
 deployment targets and then use the new NavigationStackView.
 */
struct SidebarToggleButton: View {

    var body: some View {
        Button(action: toggleSidebar) {
            Image.sidebarLeading
        }
    }
}

private extension View {

    func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}
