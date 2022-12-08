//
//  RichTextAlignmentPicker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This picker can be used to pick a rich text alignment.

 This view returns a plain SwiftUI `Picker` view that can be
 styled and configured in all ways supported by SwiftUI.

 This picker will by default apply a segmented style, but it
 can be disabled using `segmented: false` in the initializer.
 */
public struct RichTextAlignmentPicker: View {

    /**
     Create a rich text alignment picker.

     - Parameters:
       - title: The optional picker title.
       - selection: The binding to update with the picker.
       - segmented: Whether or not to aply a segmented picker style, by default `true`.
       - values: The pickable alignments, by default all available alignments.
     */
    public init(
        title: String = "",
        selection: Binding<RichTextAlignment>,
        segmented: Bool = true,
        values: [RichTextAlignment] = RichTextAlignment.allCases
    ) {
        self.title = title
        self._selection = selection
        self.segmented = segmented
        self.values = values
    }

    let title: String
    let segmented: Bool
    let values: [RichTextAlignment]

    @Binding
    private var selection: RichTextAlignment
    
    public var body: some View {
        Picker(title, selection: $selection) {
            ForEach(RichTextAlignment.allCases) {
                $0.icon.tag($0)
            }
        }.segmented(if: segmented)
    }
}

private extension View {

    @ViewBuilder
    func segmented(if condition: Bool) -> some View {
        if condition {
            self.pickerStyle(.segmented)
        } else {
            self
        }
    }
}
