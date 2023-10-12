import Foundation

public extension RichTextAlignmentWriter {
    
    @available(*, deprecated, renamed: "setRichTextAlignment(_:at:)")
    func setRichTextAlignment(
        to alignment: RichTextAlignment,
        at range: NSRange
    ) {
        setRichTextAlignment(alignment, at: range)
    }
}
