//
//  RichTextCommand+FontSizeOptionsGroup.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-20.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextCommand {
    
    /**
     This view renders font size command options.
     */
    struct FontSizeOptionsGroup: View {
        
        public init() {}
        
        public var body: some View {
            ActionButtonGroup(
                actions: [
                    .increaseFontSize(),
                    .decreaseFontSize()
                ]
            )
        }
    }
}
