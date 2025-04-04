//
//  RichTextParagraphValuePicker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2025-04-04.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

import SwiftUI

/// This picker can be used to pick a paragraph value.
///
/// The `label` builder is used as the main picker label and
/// `valueLabel` as a label for each picker value.
public struct RichTextParagraphValuePicker<ValueType: Hashable, Label: View, ValueLabel: View>: View {
    
    public init(
        _ keyPath: WritableKeyPath<NSMutableParagraphStyle, ValueType>,
        context: RichTextContext,
        values: [ValueType]? = nil,
        label: @escaping () -> Label,
        valueLabel: @escaping (ValueType) -> ValueLabel
    ) {
        self.init(
            keyPath,
            binding: context.paragraphStyleValueBinding(for: keyPath),
            values: values,
            label: label,
            valueLabel: valueLabel
        )
    }
    
    public init(
        _ keyPath: WritableKeyPath<NSMutableParagraphStyle, ValueType>,
        binding: Binding<ValueType>,
        values: [ValueType]? = nil,
        label: @escaping () -> Label,
        valueLabel: @escaping (ValueType) -> ValueLabel
    ) {
        self.keyPath = keyPath
        self.binding = binding
        self.values = values
        self.label = label
        self.valueLabel = valueLabel
    }
    
    private let keyPath: WritableKeyPath<NSMutableParagraphStyle, ValueType>
    private let binding: Binding<ValueType>
    private let values: [ValueType]?
    private let label: () -> Label
    private let valueLabel: (ValueType) -> ValueLabel
    
    private var indexBinding: Binding<Int> {
        Binding<Int>(
            get: { pickerValues.firstIndex(of: binding.wrappedValue) ?? 0 },
            set: { binding.wrappedValue = pickerValues[$0] }
        )
    }
    
    private var pickerValues: [ValueType] {
        values ?? keyPath.defaultPickerValues ?? []
    }
    
    public var body: some View {
        Picker(selection: indexBinding) {
            ForEach(Array(pickerValues.enumerated()), id: \.offset) {
                valueLabel($0.element).tag($0.offset)
            }
        } label: {
            label()
        }
    }
}

#Preview {

    struct Preview: View {

        @State var alignment = NSTextAlignment.left
        @StateObject var context = RichTextContext()

        var body: some View {
            VStack {
                RichTextParagraphValuePicker(
                    \.alignment,
                     context: context
                ) {
                    Text("TEST")
                } valueLabel: { value in
                    value.defaultLabel
                }
                .labelStyle(.iconOnly)
                .pickerStyle(.segmented)
            }
        }
    }

    return Preview()
}
