#if os(macOS)
import AppKit
#else
import UIKit
#endif

public final class RichTextLayoutManager: NSLayoutManager {
    public override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
#if os(macOS)
    public override func processEditing(
        for textStorage: NSTextStorage, 
        edited editMask: NSTextStorageEditActions, 
        range newCharRange: NSRange, 
        changeInLength delta: Int, 
        invalidatedRange invalidatedCharRange: NSRange
    ) {
        super.processEditing(
            for: textStorage, 
            edited: editMask, 
            range: newCharRange, 
            changeInLength: delta, 
            invalidatedRange: invalidatedCharRange
        )
        drawCustomAttributes(forGlyphRange: textStorage.richTextRange, at: .zero)
    }
#else
    public override func processEditing(
        for textStorage: NSTextStorage,
        edited editMask: NSTextStorage.EditActions,
        range newCharRange: NSRange,
        changeInLength delta: Int,
        invalidatedRange invalidatedCharRange: NSRange
    ) {
        super.processEditing(
            for: textStorage,
            edited: editMask,
            range: newCharRange,
            changeInLength: delta,
            invalidatedRange: invalidatedCharRange
        )
        drawCustomAttributes(forGlyphRange: textStorage.richTextRange, at: .zero)
    }
#endif
    
    
    private func drawCustomAttributes(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        let characterRange = characterRange(forGlyphRange: glyphsToShow, actualGlyphRange: nil)
        renderLinks(in: characterRange, at: origin)
    }
 
    private func renderLinks(in characterRange: NSRange, at origin: CGPoint) {
        textStorage?.enumerateAttribute(
            .customLink,
            in: characterRange,
            using: { [weak textStorage] value, range, _ in
                if let value = value as? CustomLinkAttributes, let link = value.link {
                    textStorage?.addAttribute(.link, value: link, range: range)
                    textStorage?.addAttribute(.foregroundColor, value: value.color, range: range)
                }
            }
        )
    }
}
