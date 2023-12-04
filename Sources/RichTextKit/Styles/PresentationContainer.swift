//
//  SwiftUIView.swift
//  
//
//  Created by Dominik Bucher on 04.12.2023.
//

import SwiftUI

public enum PresentationStyle {
    case sheet
    case push
    case alert
}

public struct PresentationContainer<Content: View>: View {
    let style: PresentationStyle
    let content: Content
    let isPresented: Binding<Bool>
    
    public init(style: PresentationStyle, isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.style = style
        self.isPresented = isPresented
        self.content = content()
    }
    
    public var body: some View {
        switch style {
        case .sheet:
            content.sheet(isPresented: isPresented, content: { content })
        case .push:
             NavigationLink(destination: content, isActive: isPresented, label: { EmptyView() })
        case .alert:
            Text("").alert("Enter URL", isPresented: isPresented, actions: {
                content
            })
        }
    }
}
