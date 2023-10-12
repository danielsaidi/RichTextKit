//
//  RichTextIndentPicker.swift
//  RichTextKit
//
//  Created by James Bradley on 2022-03-04.
//  Copyright © 2023 James Bradley. All rights reserved.
//

import SwiftUI

/**
 This picker can be used to pick a rich text indent change.

 This view returns a plain SwiftUI `Picker` view that can be
 styled and configured in all ways supported by SwiftUI.
 */
public struct RichTextIndentPicker: View {

    /**
     Create a rich text indent picker.

     - Parameters:
       - selection: The binding to update with the picker.
       - values: The pickable alignments, by default all available alignments.
     */
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
