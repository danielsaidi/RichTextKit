//
//  ListPickerItem.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2021-08-20.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This is an internal version of the original that is defined
 and available in https://github.com/danielsaidi/swiftuikit.
 This will not be made public or documented for this library.
 */
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
