import Foundation

@available(*, deprecated, message: "Use RichTextDataReader instead")
public protocol RichTextDataWriter: RichTextDataReader {}

@available(*, deprecated, message: "Use RichTextDataReader instead")
extension NSAttributedString: RichTextDataWriter {}

@available(*, deprecated, message: "Use RichTextDataReader instead")
public extension RichTextDataWriter {

    @available(*, deprecated, renamed: "richTextData(for:)")
    func richTextData(with format: RichTextDataFormat) throws -> Data {
        try richTextData(for: format)
    }
}
