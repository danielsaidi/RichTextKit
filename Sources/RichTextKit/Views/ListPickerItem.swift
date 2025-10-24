//
//  ListPickerItem.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2021-08-20.
//  Copyright © 2021-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

protocol ListPickerItem: View {

    associatedtype Item: Equatable

    var item: Item { get }
    var isSelected: Bool { get }
}

extension ListPickerItem {

    var checkmark: some View {
        Image(systemName: "checkmark")
            .opacity(isSelected ? 1 : 0)
    }
}
