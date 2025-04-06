//
//  Stepper+RichTextParagraphValue.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2025-04-04.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension Stepper {
    
    /// Creates a stepper for a paragraph style value in the
    /// provided rich text context.
    init<ValueType: Hashable & Strideable & Comparable & SignedNumeric>(
        forValue value: WritableKeyPath<NSMutableParagraphStyle, ValueType>,
        in context: RichTextContext,
        step: ValueType.Stride,
        label: @escaping () -> Label
    ) {
        self.init(
            value: context.paragraphStyleValueBinding(for: value),
            step: step,
            label: label
        )
    }
    
    /// Creates a stepper for a paragraph style value in the
    /// provided paragraph style.
    init<ValueType: Hashable & Strideable & Comparable & SignedNumeric>(
        forValue value: WritableKeyPath<NSMutableParagraphStyle, ValueType>,
        in paragraph: Binding<NSMutableParagraphStyle>,
        step: ValueType.Stride,
        label: @escaping () -> Label
    ) {
        self.init(
            value: .init {
                paragraph.wrappedValue[keyPath: value]
            } set: { newValue in
                paragraph.wrappedValue[keyPath: value] = newValue
            },
            step: step,
            label: label
        )
    }
}

#Preview {

    struct Preview: View {
        
        let keypath: KeyPath<NSParagraphStyle, CGFloat> = \.lineSpacing
        let writableKeypath: WritableKeyPath<NSMutableParagraphStyle, CGFloat> = \.lineSpacing

        @StateObject var context = RichTextContext()
        
        var value: Double {
            context.paragraphStyleValue(for: keypath)
        }

        var body: some View {
            VStack {
                Text(String(format: "%.1f", value))
                Stepper(forValue: writableKeypath, in: context, step: 1) {
                    Text("Context")
                }
                Stepper(forValue: writableKeypath, in: $context.paragraphStyle, step: 1) {
                    Text("Context")
                }
            }
        }
    }

    return Preview()
}
