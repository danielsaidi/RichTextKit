//
//  RichTextCoordinatorIntegrationTests+UIKit.swift
//
//
//  Created by Dominik Bucher on 14.12.2023.
//
#if os(iOS)
import UIKit

import CoreGraphics
import SwiftUI
@testable import RichTextKit
import XCTest

final class RichTextCoordinatorIntegrationTests: XCTestCase {
    private var text: NSAttributedString!
    private var textBinding: Binding<NSAttributedString>!
    private var textView: RichTextView!
    private var textContext: RichTextContext!
    private var coordinator: RichTextCoordinator!
    
    static let initialAttributedString: NSAttributedString = {
        let text = NSMutableAttributedString(string: "This is red text")
        text.addAttributes([.foregroundColor: ColorRepresentable.red], range: text.richTextRange)
        text.addAttributes([.font: FontRepresentable.systemFont(ofSize: 16)], range: text.richTextRange)
        return text
    }()
    
    
    override func setUp() {
        super.setUp()
        
        text = Self.initialAttributedString
        textBinding = Binding(get: { self.text }, set: { self.text = $0 })
        textView = RichTextView(string: text)
        textContext = RichTextContext()
        coordinator = RichTextCoordinator(
            text: textBinding,
            textView: textView,
            richTextContext: textContext)
        textView.selectedRange = NSRange(location: 0, length: 0)
        textView.setup(with: text, format: .archivedData)
    }
    
    override func tearDown() {
        text = nil
        textBinding = nil
        textView = nil
        textContext = nil
        coordinator = nil
        
        super.tearDown()
    }
    
    private let firstTypingPart = "String without any attributes"
    private let imageToPaste = UIGraphicsImageRenderer(size: .init(width: 20, height: 20)).image { rendererContext in
        UIColor.gray.setFill()
        rendererContext.fill(CGRect(origin: .zero, size: .init(width: 20, height: 20)))
    }
    
    func test_behavior_whenInitialState_keepsConfiguration() {
        // When starting RichTextEditor we want to check if the font and color is set correctly.
        textContext.selectRange(.init(location: 0, length: Self.initialAttributedString.length))
        
        // Only ArchivedData textView format support images...
        coordinator.pasteImage(.init(content: imageToPaste, at: textView.richText.length, moveCursor: true))
        
        XCTAssertTrue(textView.richText.containsAttachments(in: textView.richTextRange))
        
        textView.simulateTyping(of: firstTypingPart)
        
        textContext.selectRange(NSRange(location: Self.initialAttributedString.length, length: firstTypingPart.count))
        XCTAssertEqual(textView.currentRichTextAttributes[.font] as? FontRepresentable, FontRepresentable.systemFont(ofSize: 16))
        XCTAssertEqual(textView.currentRichTextAttributes[.foregroundColor] as? ColorRepresentable, ColorRepresentable.red)
        
        textView.setRichTextStyle(.strikethrough, to: true, at: textView.selectedRange)
        XCTAssertEqual(textView.currentRichTextAttributes[.strikethroughStyle] as? Int, 1)
    }
}
#endif
