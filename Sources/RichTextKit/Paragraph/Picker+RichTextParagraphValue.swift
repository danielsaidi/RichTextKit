//
//  Picker+RichTextParagraphValue.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2025-04-04.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension Picker {

    /// Creates a picker for a certain paragraph style value
    /// in the provided rich text context.
    init<ValueType: Hashable, ValueLabel: View>(
        forValue value: WritableKeyPath<NSMutableParagraphStyle, ValueType>,
        in context: RichTextContext,
        values: [ValueType]? = nil,
        label: @escaping () -> Label,
        valueLabel: @escaping (ValueType) -> ValueLabel
    ) where SelectionValue == Int, Content == NSMutableParagraphStyleValueLabel<ValueType, ValueLabel> {
        let values = values ?? value.defaultPickerValues ?? []
        let binding = context.paragraphStyleValueBinding(for: value)
        let indexBinding = Self.indexBinding(for: values, binding: binding)
        self.init(selection: indexBinding) {
            Content(values: values, valueLabel: valueLabel)
        } label: {
            label()
        }
    }

    /// Creates a picker for a certain paragraph style value
    /// in the provided paragraph style.
    init<ValueType: Hashable, ValueLabel: View>(
        forValue value: WritableKeyPath<NSMutableParagraphStyle, ValueType>,
        in paragraph: Binding<NSMutableParagraphStyle>,
        values: [ValueType]? = nil,
        label: @escaping () -> Label,
        valueLabel: @escaping (ValueType) -> ValueLabel
    ) where SelectionValue == Int, Content == NSMutableParagraphStyleValueLabel<ValueType, ValueLabel> {
        let values = values ?? value.defaultPickerValues ?? []
        let binding: Binding<ValueType> = .init {
            paragraph.wrappedValue[keyPath: value]
        } set: { newValue in
            paragraph.wrappedValue[keyPath: value] = newValue
        }
        let indexBinding = Self.indexBinding(for: values, binding: binding)
        self.init(selection: indexBinding) {
            Content(values: values, valueLabel: valueLabel)
        } label: {
            label()
        }
    }
}

private extension Picker {

    static func indexBinding<ValueType: Hashable>(
        for values: [ValueType],
        binding: Binding<ValueType>
    ) -> Binding<Int> {
        .init(
            get: { values.firstIndex(of: binding.wrappedValue) ?? 0 },
            set: { binding.wrappedValue = values[$0] }
        )
    }
}

#Preview {

    struct Preview: View {

        typealias ValueType = NSTextAlignment
        let keypath: KeyPath<NSParagraphStyle, NSTextAlignment> = \.alignment
        let writableKeypath: WritableKeyPath<NSMutableParagraphStyle, NSTextAlignment> = \.alignment

        @State var alignment = ValueType.left
        @StateObject var context = RichTextContext()

        var value: ValueType {
            context.paragraphStyleValue(for: keypath)
        }

        var body: some View {
            VStack {
                Text("\(value)")
                Picker(forValue: writableKeypath, in: context) {
                    Text("Context")
                } valueLabel: { value in
                    value.defaultLabel
                }
                Picker(forValue: writableKeypath, in: $context.paragraphStyle) {
                    Text("Paragraph")
                } valueLabel: { value in
                    value.defaultLabel
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
