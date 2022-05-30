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
 styled and adjusted in all ways supported by SwiftUI.
 */
public struct RichTextAlignmentPicker: View {

    /**
     Create a rich text alignment picker.

     - Parameters:
       - title: The optional picker title.
       - alignments: The pickable alignments.
       - selection: The binding to update with the picker.
     */
    public init(
        title: String = "",
        alignments: [RichTextAlignment] = RichTextAlignment.allCases,
        selection: Binding<RichTextAlignment>) {
        self.title = title
        self.alignments = alignments
        self._selection = selection
    }

    /**
     The optional picker title.
     */
    public let title: String

    /**
     The pickable alignments.
     */
    public let alignments: [RichTextAlignment]

    @Binding
    private var selection: RichTextAlignment
    
    public var body: some View {
        Picker(title, selection: $selection) {
            ForEach(RichTextAlignment.allCases) {
                $0.icon.tag($0)
            }
        }
    }
}
