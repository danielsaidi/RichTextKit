//
//  RichTextAlignmentPicker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This picker can be used to pick a rich text alignment.

 This view returns a plain SwiftUI `Picker` view that can be
 styled and configured in all ways supported by SwiftUI.
 */
public struct RichTextAlignmentPicker: View {

    /**
     Create a rich text alignment picker.

     - Parameters:
       - selection: The binding to update with the picker.
       - values: The pickable alignments, by default all available alignments.
     */
    public init(
        selection: Binding<RichTextAlignment>,
        values: [RichTextAlignment] = RichTextAlignment.allCases
    ) {
        self._selection = selection
        self.values = values
    }

    let values: [RichTextAlignment]

    @Binding
    private var selection: RichTextAlignment
    
    public var body: some View {
        Picker("", selection: $selection) {
            ForEach(RichTextAlignment.allCases) {
                $0.icon.tag($0)
            }
        }.labelsHidden()
    }
}
