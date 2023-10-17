# ``RichTextKit``

RichTextKit helps you view and edit rich text in SwiftUI, UIKit and AppKit.


## Overview

![RichTextKit logo](Logo.png)

RichTextKit has a SwiftUI `RichTextEditor` that builds on a multi-platform `RichTextView` that supports text style (bold, italic, underline, strikethrough etc.), font, font sizes, text and background colors, text alignment, images etc.

RichTextKit supports `iOS 14`, `macOS 11`, `tvOS 14` and `watchOS 7`.



## Installation

RichTextKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/RichTextKit.git
```

If you prefer to not have external dependencies, you can also just copy the source code into your app.



## Getting started

The <doc:Getting-Started> article has a guide to help you get started with RichTextKit.



## Repository

For more information, source code, and to report issues, sponsor the project etc., visit the [project repository](https://github.com/danielsaidi/RichTextKit).



## About this documentation

The online documentation is currently iOS only. To generate documentation for other platforms, open the package in Xcode, select a simulator then run `Product/Build Documentation`.



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
