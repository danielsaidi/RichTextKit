import Foundation

public extension RichTextDataWriter {

    @available(*, deprecated, renamed: "richTextData(for:)")
    func richTextData(with format: RichTextDataFormat) throws -> Data {
        try richTextData(for: format)
    }
}
