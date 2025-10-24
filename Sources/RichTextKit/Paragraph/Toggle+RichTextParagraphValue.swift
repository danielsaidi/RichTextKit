//
//  Toggle+RichTextParagraphValue.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2025-04-04.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension Toggle {

    /// Creates a toggle for a certain paragraph style value in the provided context.
    init(
        forValue value: WritableKeyPath<NSMutableParagraphStyle, Bool>,
        in context: RichTextContext,
        label: @escaping () -> Label
    ) {
        self.init(
            isOn: context.paragraphStyleValueBinding(for: value),
            label: label
        )
    }

    /// Creates a toggle for a certain paragraph style in the provided paragraph.
    init(
        forValue value: WritableKeyPath<NSMutableParagraphStyle, Bool>,
        in paragraph: Binding<NSMutableParagraphStyle>,
        label: @escaping () -> Label
    ) {
        self.init(
            isOn: .init {
                paragraph.wrappedValue[keyPath: value]
            } set: { newValue in
                paragraph.wrappedValue[keyPath: value] = newValue
            },
            label: label
        )
    }
}

#Preview {

    struct Preview: View {

        let keypath: KeyPath<NSParagraphStyle, Bool> = \.allowsDefaultTighteningForTruncation
        let writableKeypath: WritableKeyPath<NSMutableParagraphStyle, Bool> = \.allowsDefaultTighteningForTruncation

        @StateObject var context = RichTextContext()

        var value: Bool {
            context.paragraphStyleValue(for: keypath)
        }

        var body: some View {
            VStack {
                Text("\(value)")
                Toggle(
                    forValue: writableKeypath,
                    in: context
                ) {
                    Text("Context")
                }
                Toggle(
                    forValue: writableKeypath,
                    in: $context.paragraphStyle
                ) {
                    Text("Paragraph")
                }
                .labelStyle(.iconOnly)
                #if !os(watchOS)
                .pickerStyle(.segmented)
                #endif
            }
        }
    }

    return Preview()
}
