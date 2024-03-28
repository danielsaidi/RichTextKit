//
//  ForEachPicker.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2022-03-17.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This is an internal version of the original that is defined
 and available in https://github.com/danielsaidi/swiftuikit.
 This will not be made public or documented for this library.
 */
struct ForEachPicker<Item: Identifiable, ItemView: View>: View {

    init(
        items: [Item],
        selection: Binding<Item>,
        animatedSelection: Bool = false,
        dismissAfterPick: Bool = false,
        listItem: @escaping ItemViewBuilder
    ) {
        self.items = items
        self.selection = selection
        self.animatedSelection = animatedSelection
        self.dismissAfterPick = dismissAfterPick
        self.listItem = listItem
    }

    private let items: [Item]
    private let selection: Binding<Item>
    private let animatedSelection: Bool
    private let dismissAfterPick: Bool
    private let listItem: ItemViewBuilder

    typealias ItemViewBuilder = (_ item: Item, _ isSelected: Bool) -> ItemView

    @Environment(\.dismiss)
    var dismiss

    var body: some View {
        ForEach(items) { item in
            Button {
                select(item)
            } label: {
                listItem(item, isSelected(item))
            }
            .buttonStyle(.plain)
        }
    }
}

private extension ForEachPicker {

    var selectedId: Item.ID {
        selection.wrappedValue.id
    }
}

private extension ForEachPicker {

    func isSelected(_ item: Item) -> Bool {
        selectedId == item.id
    }

    func select(_ item: Item) {
        if animatedSelection {
            selectWithAnimation(item)
        } else {
            selectWithoutAnimation(item)
        }
    }

    func selectWithAnimation(_ item: Item) {
        withAnimation {
            selectWithoutAnimation(item)
        }
    }

    func selectWithoutAnimation(_ item: Item) {
        selection.wrappedValue = item
        if dismissAfterPick {
            dismiss()
        }
    }
}
