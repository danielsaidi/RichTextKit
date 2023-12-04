//
//  SwiftUIView.swift
//  
//
//  Created by Dominik Bucher on 04.12.2023.
//

import SwiftUI

public enum PresentationStyle {
    case sheet
    case alert
}

private struct PresentationContainer<Value, SheetContent: View>: ViewModifier {
    @Binding var data: Value?
    let style: PresentationStyle
    let sheetContent: (Value?) -> SheetContent
    let isPresented: Binding<Bool>
    
    private struct SheetContentContainer: View {
        @Binding var data: Value?
        let sheetContent: (Value?) -> SheetContent
        
        var body: some View {
            sheetContent(data)
        }
    }
    
    func body(content: Content) -> some View {
        switch style {
        case .sheet:
            content.sheet(isPresented: isPresented, content: {  SheetContentContainer(data: $data, sheetContent: sheetContent) })
        case .alert:
            content.alert(
                "",
                isPresented: isPresented,
                actions: {  SheetContentContainer(data: $data, sheetContent: sheetContent) }
            )
            
        }
    }
}


extension View {
    func presentationContainer<Value, SheetContent: View>(
        style: PresentationStyle, 
        data: Binding<Value?>, 
        isPresented: Binding<Bool>, 
        content: @escaping (Value?) -> SheetContent
    ) -> some View {
        self.modifier(PresentationContainer(data: data, style: style, sheetContent: content, isPresented: isPresented))
    }
}
