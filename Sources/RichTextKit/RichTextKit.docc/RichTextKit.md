# ``RichTextKit``

RichTextKit is a Swift-based library that lets you work with rich text in UIKit, AppKit and SwiftUI.


## Overview

![SwiftKit logo](Logo.png)

RIchTextKit supports changing styles (bold, italic, underline), font, font sizes, colors, alignment etc. You can also drag and copy in images if you use a data format that allows it. 

RichTextKit is supported by and released with permission from [Oribi](https://oribi.se/en/) and used in [OribiWriter](https://oribi.se/en/apps/oribi-writer/), which is out on iOS and soon on macOS.



## Installation

RichTextKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/RichTextKit.git
```

or with CocoaPods:

```
pod RichTextKit
```



## Supported Platforms

RichTextKit supports `iOS 14`, `macOS 11`, `tvOS 14` and `watchOS 7`.



## About this documentation

The online documentation is currently iOS only. To generate documentation for other platforms, open the package in Xcode, select a simulator then run `Product/Build Documentation`.

Note that type extensions are not included in this documentation.



## License

RichTextKit is available under the MIT license. See the [LICENSE][License] file for more info.



## Topics

### Articles

- <doc:Getting-Started>

### Editors

- ``RichTextEditor``
- ``RichTextView``
- ``RichTextViewComponent``

### Foundation

- ``RichTextContext``
- ``RichTextCoordinator``
- ``RichTextPresenter``
- ``RichTextReader``
- ``RichTextWriter``

### Actions

- ``RichTextAction``
- ``RichTextActionButton``
- ``RichTextActionButtonStack``

### Alignment

- ``RichTextAlignment``
- ``RichTextAlignmentReader``
- ``RichTextAlignmentWriter``
- ``RichTextAlignmentPicker``

### Attributes

- ``RichTextAttribute``
- ``RichTextAttributes``
- ``RichTextAttributeReader``
- ``RichTextAttributeWriter``

### Colors

- ``ColorRepresentable``
- ``RichTextColorReader``
- ``RichTextColorWriter``
- ``RichTextColorPicker``
- ``RichTextColorPickerStack``

### Commands

- ``RichTextCommandsAlignmentOptionsGroup``
- ``RichTextCommandsFontSizeOptionsGroup``
- ``RichTextCommandsStyleOptionsGroup``
- ``RichTextFormatCommandMenu``

### Data

- ``RichTextDataError``
- ``RichTextDataFormat``
- ``RichTextDataFormatMenu``
- ``RichTextDataReader``
- ``RichTextDataWriter``

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
- ``RichTextFontReader``
- ``RichTextFontWriter``
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

### Images

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
- ``RichTextStyleReader``
- ``RichTextStyleWriter``
- ``RichTextStyleButton``
- ``RichTextStyleToggle``
- ``RichTextStyleToggleStack``
