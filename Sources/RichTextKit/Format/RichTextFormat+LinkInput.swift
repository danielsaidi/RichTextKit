//
//  RichTextFormat+LinkInput.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-04-30.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

import Foundation
import SwiftUI

public extension RichTextFormat {
    
    @available(iOS 15.0, macOS 12.0, *)
    struct LinkInput: View {
        
        public init(
            context: RichTextContext,
            isPresented: Binding<Bool>
        ) {
            self.context = context
            self._isPresented = isPresented
            self._urlString = State(initialValue: "")
            self._text = State(initialValue: context.selectedText ?? "")
        }
        
        private let context: RichTextContext
        @Binding private var isPresented: Bool
        @State private var urlString: String
        @State private var text: String
        
        public var body: some View {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("URL")
                        .foregroundStyle(.secondary)
                    TextField("", text: $urlString)
                        .textFieldStyle(.roundedBorder)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Text")
                        .foregroundStyle(.secondary)
                    TextField("", text: $text)
                        .textFieldStyle(.roundedBorder)
                }
                
                HStack(spacing: 12) {
                    Spacer()
                    Button("Cancel") {
                        isPresented = false
                    }
                    Button("OK") {
                        context.setLink(url: urlString, text: text)
                        isPresented = false
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(urlString.isEmpty)
                }
            }
            .padding()
            .frame(width: 400)
        }
    }
}
