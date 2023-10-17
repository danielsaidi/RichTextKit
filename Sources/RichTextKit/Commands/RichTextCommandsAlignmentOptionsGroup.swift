//
//  RichTextCommandsAlignmentOptionsGroup.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-20.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This view defines `Commands` content for alignment options.
 */
public struct RichTextCommandsAlignmentOptionsGroup: View {

    public init() {}

    public var body: some View {
        ForEach(RichTextAlignment.allCases) {
            RichTextCommandButton(
                action: .setAlignment($0)
            )
        }
    }
}
