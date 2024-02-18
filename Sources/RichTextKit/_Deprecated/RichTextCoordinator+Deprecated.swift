#if iOS || macOS || os(tvOS) || os(visionOS)
import SwiftUI

public extension RichTextCoordinator {

    @available(*, deprecated, renamed: "context")
    var richTextContext: RichTextContext {
        context
    }
}
#endif
