//
//  RichTextCommandButton.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2023-10-12.
//  Copyright © 2023 Daniel Saidi. All rights reserved.

import SwiftUI

/**
 This button can be used to trigger a ``RichTextCommand``.
 
 This renders a plain `Button`, which means that you can use
 and configure it as normal.
 */
public struct RichTextCommandButton: View {
    
    /**
     Create a rich text command button.
     
     - Parameters:
       - command: The command to trigger.
       - action: The action to trigger.
       - fillVertically: Whether or not fill up vertical space in a non-greedy way, by default `false`.
     */
    public init(
        command: RichTextCommand,
        action: @escaping () -> Void,
        fillVertically: Bool = false
    ) {
        self.command = command
        self.action = action
        self.fillVertically = fillVertically
    }
    
    private let command: RichTextCommand
    private let action: () -> Void
    private let fillVertically: Bool
    
    public var body: some View {
        Button(action: action) {
            command.icon
                .frame(maxHeight: fillVertically ? .infinity : nil)
                .contentShape(Rectangle())
        }
        .keyboardShortcut(for: command)
        .accessibilityLabel(command.localizedName)
    }
}

struct RichTextCommandButton_Previews: PreviewProvider {
    
    struct Preview: View {
        
        @StateObject
        private var context = RichTextContext()
        
        var body: some View {
            HStack {
                RichTextCommandButton(
                    command: .print,
                    action: {},
                    fillVertically: true
                )
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .buttonStyle(.bordered)
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
