//
//  ContentView.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//



import RichTextKit
import SwiftUI

struct ContentView: View {

    @State
    private var text = NSAttributedString(string: "test")

    @StateObject
    private var context = RichTextContext()

    var body: some View {
        VStack {
            RichTextEditor(text: $text, context: context)
                .cornerRadius(5)
                .frame(height: 100)
            Button("U") {
                context.isUnderlined.toggle()
            }
            .foregroundColor(context.isUnderlined ? .accentColor : .primary)
            .buttonStyle(.bordered)
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.3))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
