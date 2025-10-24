//
//  ListPicker.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2021-08-20.
//  Copyright © 2021-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

struct ListPicker<Item: Identifiable, ItemView: View>: View {

    init(
        items: [Item],
        selection: Binding<Item>,
        animatedSelection: Bool = false,
        dismissAfterPick: Bool = true,
        listItem: @escaping ItemViewBuilder
    ) {
        self.init(
            sections: [ListPickerSection(title: "", items: items)],
            selection: selection,
            animatedSelection: animatedSelection,
            dismissAfterPick: dismissAfterPick,
            listItem: listItem)
    }

    init(
        sections: [ListPickerSection<Item>],
        selection: Binding<Item>,
        animatedSelection: Bool = false,
        dismissAfterPick: Bool = true,
        listItem: @escaping ItemViewBuilder
    ) {
        self.sections = sections
        self.selection = selection
        self.animatedSelection = animatedSelection
        self.dismissAfterPick = dismissAfterPick
        self.listItem = listItem
    }

    private let sections: [ListPickerSection<Item>]
    private let selection: Binding<Item>
    private let animatedSelection: Bool
    private let dismissAfterPick: Bool
    private let listItem: ItemViewBuilder

    typealias ItemViewBuilder = (_ item: Item, _ isSelected: Bool) -> ItemView

    var body: some View {
        List {
            ForEach(sections) { section in
                Section(header: section.header) {
                    ForEachPicker(
                        items: section.items,
                        selection: selection,
                        animatedSelection: animatedSelection,
                        dismissAfterPick: dismissAfterPick,
                        listItem: listItem
                    )
                }
            }
        }
    }
}
