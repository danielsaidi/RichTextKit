import SwiftUI
import Combine

/// This enum defines rich text actions that can be executed on a rich text editor.
///
/// It's also a namespace for action-related types, like ``RichTextAction/Button``.
public enum RichTextAction: Identifiable, Equatable, RichTextLabelValue {

    // Change background color
    case setColor(RichTextColor, ColorRepresentable)

    // Change highlighting style
    case setHighlightingStyle(RichTextHighlightingStyle)

    /// Set a certain ``RichTextStyle``.
    case setStyle(RichTextStyle, Bool)

    /// Toggle a certain style.
    case toggleStyle(_ style: RichTextStyle)

}

public extension RichTextAction {

    /// The action's unique identifier.
    var id: String { title }

    /// The action's standard icon.
    var icon: Image {
        switch self {
        case .copy: .richTextCopy
        case .deleteSelectedText: .richTextDelete
        case .deleteText: .richTextDelete
        case .dismissKeyboard: .richTextDismissKeyboard
        case .pasteImage: .richTextDocuments
        case .pasteImages: .richTextDocuments
        case .pasteText: .richTextDocuments
        case .print: .richTextPrint
        case .redoLatestChange: .richTextRedo
        case .replaceSelectedText: .richTextReplace
        case .replaceText: .richTextReplace
        case .selectRange: .richTextSelection
        case .setAlignment(let val): val.defaultIcon
        case .setAttributedString: .richTextDocument
        case .setColor(let color, _): color.icon
        case .setHighlightedRange: .richTextAlignmentCenter
        case .setHighlightingStyle: .richTextAlignmentCenter
        case .setParagraphStyle: .richTextAlignmentLeft
        case .setStyle(let style, _): style.icon
        case .stepFontSize(let val): .richTextStepFontSize(val)
        case .stepIndent(let val): .richTextStepIndent(val)
        case .stepLineSpacing(let val): .richTextStepLineSpacing(val)
        case .stepSuperscript(let val): .richTextStepSuperscript(val)
        case .toggleStyle(let val): val.icon
        case .undoLatestChange: .richTextUndo
        }
    }

    /// The localized label to use for the action.
    var label: some View {
        icon.label(title)
    }

    /// The localized title to use in the main menu.
    var menuTitle: String {
        menuTitleKey.text
    }

    /// The localized title key to use in the main menu.
    var menuTitleKey: RTKL10n {
        switch self {
        case .stepIndent(let points): .menuIndent(points)
        default: titleKey
        }
    }

    /// The localized action title.
    var title: String {
        titleKey.text
    }

    /// The localized action title key.
    var titleKey: RTKL10n {
        switch self {
        case .copy: .actionCopy
        case .deleteSelectedText: .actionDelete
        case .deleteText: .actionDelete
        case .dismissKeyboard: .actionDismissKeyboard
        case .pasteImage: .pasteImage
        case .pasteImages: .pasteImages
        case .pasteText: .pasteText
        case .print: .actionPrint
        case .redoLatestChange: .actionRedoLatestChange
        case .replaceSelectedText: .actionDelete
        case .replaceText: .actionDelete
        case .selectRange: .selectRange
        case .setAlignment(let alignment): alignment.defaultTitleKey
        case .setAttributedString: .setAttributedString
        case .setColor(let color, _): color.titleKey
        case .setHighlightedRange: .highlightedRange
        case .setHighlightingStyle: .highlightingStyle
        case .setParagraphStyle: .textAlignmentLeft
        case .setStyle(let style, _): style.titleKey
        case .stepFontSize(let points): .actionStepFontSize(points)
        case .stepIndent(let points): .actionStepIndent(points)
        case .stepLineSpacing(let points): .actionStepLineSpacing(points)
        case .stepSuperscript(let steps): .actionStepSuperscript(steps)
        case .toggleStyle(let style): style.titleKey
        case .undoLatestChange: .actionUndoLatestChange
        }
    }
}

// MARK: - Aliases

public extension RichTextAction {

    /// A name alias for `.redoLatestChange`.
    static var redo: RichTextAction { .redoLatestChange }

    /// A name alias for `.undoLatestChange`.
    static var undo: RichTextAction { .undoLatestChange }
}

public extension CGFloat {

    /// The default rich text indent step size.
    static var defaultRichTextIntentStepSize: CGFloat {
        30.0
    }
}

public extension UInt {

    /// The default rich text indent step size.
    static var defaultRichTextIntentStepSize: UInt {
        30
    }
}
