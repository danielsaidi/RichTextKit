# Release Notes

RichTextKit will use semver after 1.0. 

Until then, deprecated features may be removed in the next minor version.



## 0.3

This release adds support for strikethrough and cleans up some 0.2 code.

This release also adds localization and accessibility to the various views.

### ✨ New Features

* `Bundle.richTextKit` is a new bundle extension that works in external previews.
* `RichTextAction` has a new `dismissKeyboard` action.
* `RichTextAction` has new `incrementFontSize` and `decrementFontSize` actions.
* `RichTextAction` has new `undo` and `redo` name aliases.
* `RichTextActionButton` has a new `fillVertically` parameter.
* `RichTextFormatSheet` is a new view that collects a bunch of text formatting controls.
* `RichTextFormatSidebar` is a new view that collects a bunch of text formatting controls.
* `RichTextKeyboardToolbar` is a new toolbar that can be used on iOS.
* `RichTextKeyboardToolbarMenu` is a new toolbar menu.
* `RichTextStyle` has a new `strikethrough` style.
* `RichTextStyleToggle` has a new `fillVertically` parameter.
* `RTKL10n` is a new enum with localized strings, which is used to localize multiple types.
* `View+KeyboardShortcuts` is a new view extension to simplify binding keyboard shortcuts to views.
* The various stack views now support 

### 💡 Behavior changes

* `RichTextActionButtonStack` and `RichTextStyleToggleStack` now fills vertically.
* `RichTextStyleButton` and `RichTextStyleToggle` now applies keyboard shortcuts.
* `RichTextStyleToggle` applies a toggle-like style to fallbacks on older OS versions.
* Many pickers, buttons and toggles apply a localized accessibility label.
* More buttons apply a rectangular content shape.

### 💥 Breaking Changes
    
* `RichTextActionButtonStack` no longer has default actions.
* `RichTextActionButtonStack` no longer has a bordered init parameter.
* `RichTextAlignmentPicker` no longer has title and segmented parameters.
* `RichTextFontSizePickerStack` no longer has a bordered init parameter.
* `RichTextFontSizePickerStack` now requires a `RichTextContext` instea dof a binding.


## 0.2

### ✨ New Features

* `Image` has new rich text-specific images.
* `NSImage` `cgImage` and `jpegData` are now public.
* `NSAttributedString` has a new `withBlackText()` extension.
* `NSAttributedString` has a new init extension file.
* `RichTextAction` is a new enum that defines rich text actions.
* `RichTextActionButton` is a new view that can trigger a RichTextAction.
* `RichTextActionButtonStack` is a new view that can list multiple RichTextActionButton views.
* `RichTextContext` has new bindings.
* `RichTextCoordinator` now subscribes to highlighting style changes.
* `RichTextCoordinator` `cancellables` are now public.
* `RichTextCoordinator` `resetHighlightedRangeAppearance()` is now public.
* `RichTextCoordinator` `text` is now mutable.
* `RichTextColorPicker` is a new color picker.
* `RichTextColorPickerStack` is a new view that can list multiple RichTextColorPicker views.
* `RichTextDataFormat` has a new vendor-specific data format.
* `RichTextFontSizePickerStack` is a new view that can list multiple RichTextFontSizePicker views.
* `RichTextImageAttachment` is now open for inheritance.
* `RichTextStyleButton` has a new button style.
* `RichTextStyleToggle` is a new style toggle button.
* `RichTextStyleToggleStack` is a new view that can list multiple RichTextStyleToggle views.
* `RichTextView` is now open for inheritance.
* `RichTextView` drop interaction functionality is now open. 
* `String` extensions have been made public.

### 💡 Behavior changes

* `RichTextAlignmentPicker` is now segmented by default.

### 🗑️ Deprecated

* `Font` picker components have been renamed with a `RichText` prefix.
* `FontSizePicker` `sizes` has been renamed to `values`.
* `PdfDataWriter` has been renamed to `PdfDataReader`.
* `RichTextAlignmentPicker` `alignments` has been renamed to `values`.
* `RichTextContext` `alignment` has been renamed to `textAlignment`.
* `RichTextContext` `standardHighlightingStyle` has been renamed to `highlightingStyle`.
* `RichTextCoordinator` `context` has been renamed to `richTextContext`.
* `RichTextDataWriter` `richTextData(with:)` has been renamed to `richTextData(for:)`.
* `RichTextViewRepresentable` has been renamed to `RichTextViewComponent`.

### 💥 Breaking Changes
  
* `RichTextView` alert function `title` parameter is no longer implicit.
* `RichTextViewRepresentable` `decrementFontSize` has been renamed to `decrementCurrentFontSize` and has no range parameter.
* `RichTextViewRepresentable` `incrementFontSize` has been renamed to `incrementCurrentFontSize` and has no range parameter.  



## 0.1.2

This is a small bugfix release.

### 🐛 Bugs

* `RichTextCoordinator` now subscribes to image pasting.



## 0.1.1

This is a small bugfix release.

### 🐛 Bugs

* `RichTextAlignmentWriter` now uses safe ranges to avoid occasional crashes.



## 0.1

This is the first beta release of RichTextKit.

The release includes the following.

### ✨ Foundational Types

* `RichTextView` is a replacement for `UITextView` and `NSTextView`.
* `RichTextEditor` is a SwiftUI view that embeds a `RichTextView`.
* `RichTextContext` is used to inspect and interact with a `RichTextEditor`.
* `RichTextCoordinator` is used by a `RichTextEditor` to keep the text view and context in sync.  

### ✨ Feature support

RichTextKit adds extensive support for a bunch of rich text features:

* Alignment
* Attributes
* Colors
* Data
* Export
* Fonts
* Images
* Pasteboard extensions
* Pdf
* Sharing
* Styles
* Views
