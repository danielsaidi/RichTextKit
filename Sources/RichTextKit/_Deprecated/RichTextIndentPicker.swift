//
//  RichTextIndentPicker.swift
//  RichTextKit
//
//  Created by James Bradley on 2022-03-04.
//  Copyright © 2023 James Bradley. All rights reserved.
//

import SwiftUI

@available(*, deprecated, message: "This is no longer used. Use a RichTextActionButtonGroup instead.")
public struct RichTextIndentPicker: View {

    public init(
        selection: Binding<RichTextIndent>,
        values: [RichTextIndent] = RichTextIndent.allCases
    ) {
        self._selection = selection
        self.values = values
    }

    let values: [RichTextIndent]

    @Binding
    private var selection: RichTextIndent
    
    public var body: some View {
        Picker("", selection: $selection) {
            ForEach(RichTextIndent.allCases) {
                $0.icon.tag($0)
            }
        }.labelsHidden()
    }
}
