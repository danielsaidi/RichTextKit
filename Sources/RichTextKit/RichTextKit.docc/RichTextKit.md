# ``RichTextKit``

RichTextKit is a Swift-based library that lets you work with rich text in UIKit, AppKit and SwiftUI.


## Overview

![SwiftKit logo](Logo.png)

RIchTextKit supports changing styles (bold, italic, underline), font, font sizes, colors, alignment etc. You can also drag and copy in images if you use a data format that allows it. 

RichTextKit is supported by and released with permission from [Oribi](https://oribi.se/en/) and used in [OribiWriter](https://oribi.se/en/apps/oribi-writer/), which is out on iOS and soon on macOS.



## Supported Platforms

RichTextKit supports `iOS 14`, `macOS 11`, `tvOS 14` and `watchOS 7`.



## Installation

RichTextKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/RichTextKit.git
```

or with CocoaPods:

```
pod RichTextKit
```



## About this documentation

The online documentation is currently iOS only. To generate documentation for other platforms, open the package in Xcode, select a simulator then run `Product/Build Documentation`.

Note that type extensions are not included in this documentation.



## License

RichTextKit is available under the MIT license. See the [LICENSE][License] file for more info.



## Topics


### Articles

- <doc:Getting-Started>

### Rich Text Views

- ``RichTextEditor``
- ``RichTextView``
- ``RichTextViewComponent``

### Foundation

- ``RichTextContext``
- ``RichTextCoordinator``
- ``RichTextPresenter``
- ``RichTextReader``
- ``RichTextWriter``

### Attributes

- ``RichTextAttribute``
- ``RichTextAttributes``
- ``RichTextAttributeReader``
- ``RichTextAttributeWriter``

### Colors

- ``ColorRepresentable``
- ``RichTextColorReader``
- ``RichTextColorWriter``

### Data

- ``RichTextDataError``
- ``RichTextDataFormat``
- ``RichTextDataReader``
- ``RichTextDataWriter``

### Export

- ``RichTextExportError``
- ``RichTextExportService``
- ``RichTextExportUrlResolver``
- ``StandardRichTextExportService``
- ``StandardRichTextExportUrlResolver``

### Fonts

- ``FontRepresentable``
- ``FontDescriptorRepresentable``
- ``FontTraitsRepresentable``
- ``RichTextFontReader``
- ``RichTextFontWriter``
- ``StandardFontSizeProvider``

### Images

- ``ImageRepresentable``
- ``RichTextImageAttachment``
- ``RichTextImageAttachmentManager``
- ``RichTextImageAttachmentSize``
- ``RichTextImageConfiguration``
- ``RichTextImageInsertConfiguration``

### Pasteboard

- ``PasteboardImageReader``

### Pdf

- ``PdfDataError``
- ``PdfDataReader``
- ``PdfPageConfiguration``
- ``PdfPageMargins``

### Sharing

- ``RichTextShareService``
- ``StandardRichTextShareService``

### Styles

- ``RichTextHighlightingStyle``
- ``RichTextStyle``
- ``RichTextStyleReader``
- ``RichTextStyleWriter``

### Text Alignment

- ``RichTextAlignment``
- ``RichTextAlignmentReader``
- ``RichTextAlignmentWriter``

### Views - Buttons

- ``RichTextStyleButton``

### Views - Pickers

- ``RichTextAlignmentPicker``
- ``RichTextFontPicker``
- ``RichTextFontPickerFont``
- ``RichTextFontForEachPicker``
- ``RichTextFontListPicker``
- ``RichTextFontSizePicker``
- ``RichTextFontSizePickerGroup``

### Views - Toggles

- ``RichTextStyleToggle``
