//
//  RichTextParagraphValueStepper.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2025-04-04.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

import SwiftUI

/// This stepper can be used to step a paragraph value.
///
/// The `label` builder is used as the main picker label.
public struct RichTextParagraphValueStepper<ValueType: Hashable & Strideable & Comparable & SignedNumeric, Label: View>: View {
    
    public init(
        _ keyPath: WritableKeyPath<NSMutableParagraphStyle, ValueType>,
        context: RichTextContext,
        step: ValueType.Stride,
        label: @escaping () -> Label
    ) {
        self.init(
            keyPath,
            binding: context.paragraphStyleValueBinding(for: keyPath),
            step: step,
            label: label
        )
    }
    
    public init(
        _ keyPath: WritableKeyPath<NSMutableParagraphStyle, ValueType>,
        binding: Binding<ValueType>,
        step: ValueType.Stride,
        label: @escaping () -> Label
    ) {
        self.keyPath = keyPath
        self.binding = binding
        self.step = step
        self.label = label
    }
    
    private let keyPath: WritableKeyPath<NSMutableParagraphStyle, ValueType>
    private let binding: Binding<ValueType>
    private let step: ValueType.Stride
    private let label: () -> Label
    
    public var body: some View {
        Stepper(value: binding, step: step, label: label)
    }
}

#Preview {

    struct Preview: View {

        @StateObject var context = RichTextContext()
        
        var value: Double {
            context.paragraphStyleValue(for: \.lineSpacing)
        }

        var body: some View {
            VStack {
                Text(String(format: "%.1f", value))
                RichTextParagraphValueStepper(
                    \.lineSpacing,
                     context: context,
                     step: 0.1
                ) {
                    Text("TEST")
                }
                .labelStyle(.iconOnly)
                .pickerStyle(.segmented)
            }
        }
    }

    return Preview()
}
