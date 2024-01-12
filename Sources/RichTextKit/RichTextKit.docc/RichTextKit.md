# ``RichTextKit``

RichTextKit helps you view and edit rich text in SwiftUI, UIKit and AppKit.



## Overview

![RichTextKit logo](Logo.png)

RichTextKit has a multi-platform SwiftUI `RichTextEditor` that can be added to any app. It supports text styles (bold, italic, underline, etc.), fonts and font sizes, colors, text alignments, image attachments, etc.

The `RichTextEditor` is powered by a UIKit/AppKit `RichTextView` that bridges the UIKit `UITextView` and AppKit `NSTextView` and adds APIs to make the view work similar on both platforms.



## Installation

RichTextKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/RichTextKit.git
```

If you prefer to not have external dependencies, you can also just copy the source code into your app.



## Getting started

The <doc:Getting-Started> article helps you get started with RichTextKit.



## Repository

For more information, source code, etc., visit the [project repository][Repository].



## License

RichTextKit is available under the MIT license. See the [LICENSE][License] file for more info.



## Topics

### Getting Started

- <doc:Getting-Started>

### Essentials

- ``RichTextEditor``
- ``RichTextView``
- ``RichTextContext``

### Foundation

- ``RichTextCoordinator``
- ``RichTextPresenter``
- ``RichTextReader``
- ``RichTextWriter``
- ``RichTextViewComponent``

### Actions

- ``RichTextAction``
- ``RichTextActionButton``
- ``RichTextActionButtonGroup``
- ``RichTextActionButtonStack``

### Alignment

- ``RichTextAlignment``
- ``RichTextAlignmentPicker``

### Attributes

- ``RichTextAttribute``
- ``RichTextAttributes``
- ``RichTextAttributeReader``
- ``RichTextAttributeWriter``

### Colors

- ``ColorRepresentable``
- ``RichTextColor``
- ``RichTextColorPicker``

### Commands

- ``RichTextCommandButton``
- ``RichTextCommandButtonGroup``
- ``RichTextCommandsAlignmentOptionsGroup``
- ``RichTextCommandsIndentOptionsGroup``
- ``RichTextCommandsFontSizeOptionsGroup``
- ``RichTextCommandsStyleOptionsGroup``
- ``RichTextFormatCommandMenu``
- ``RichTextShareCommandMenu``

### Data

- ``RichTextDataError``
- ``RichTextDataFormat``
- ``RichTextDataFormatMenu``
- ``RichTextDataReader``

### Export

- ``RichTextExportError``
- ``RichTextExportMenu``
- ``RichTextExportService``
- ``RichTextExportUrlResolver``
- ``StandardRichTextExportService``
- ``StandardRichTextExportUrlResolver``

### Focus

- ``RichTextContextFocusedValueKey``

### Fonts

- ``FontRepresentable``
- ``FontDescriptorRepresentable``
- ``FontTraitsRepresentable``
- ``StandardFontSizeProvider``
- ``RichTextFontPicker``
- ``RichTextFontPickerFont``
- ``RichTextFontForEachPicker``
- ``RichTextFontListPicker``
- ``RichTextFontSizePicker``
- ``RichTextFontSizePickerStack``

### Format

- ``RichTextFormatSheet``
- ``RichTextFormatSidebar``

### Images

- ``ImageRepresentable``
- ``RichTextImageAttachment``
- ``RichTextImageAttachmentManager``
- ``RichTextImageAttachmentSize``
- ``RichTextImageConfiguration``
- ``RichTextImageInsertConfiguration``

### Keyboard

- ``RichTextKeyboardToolbar``
- ``RichTextKeyboardToolbarMenu``
- ``RichTextKeyboardToolbarStyle``

### Localization

- ``RTKL10n``

### Pasteboard

- ``PasteboardImageReader``

### Pdf

- ``PdfDataError``
- ``PdfPageConfiguration``
- ``PdfPageMargins``
- ``RichTextPdfDataReader``

### Sharing

- ``RichTextNSSharingMenu``
- ``RichTextShareMenu``
- ``RichTextShareService``
- ``StandardRichTextShareService``

### Styles

- ``RichTextHighlightingStyle``
- ``RichTextStyle``
- ``RichTextStyleButton``
- ``RichTextStyleToggle``
- ``RichTextStyleToggleGroup``
- ``RichTextStyleToggleStack``



[License]: https://github.com/danielsaidi/RichTextKit/blob/master/LICENSE
[Repository]: https://github.com/danielsaidi/RichTextKit
