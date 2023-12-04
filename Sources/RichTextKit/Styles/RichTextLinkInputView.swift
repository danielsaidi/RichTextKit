//
//  RichTextLinkContentView.swift
//
//
//  Created by Dominik Bucher on 04.12.2023.
//

import SwiftUI

public struct RichTextLinkInputView<Content: View>: View {
  
    @State var linkUrl: String
    let content: (String) -> Content
    
    public var body: some View {
        content(linkUrl)
    }
}
