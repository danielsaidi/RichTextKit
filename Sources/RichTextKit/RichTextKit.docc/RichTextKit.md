# ``RichTextKit``

RichTextKit is a Swift SDK that helps you use rich text in Swift and SwiftUI.


## Overview

![RichTextKit logo](Logo.png)

RichTextKit is a Swift SDK that helps you use rich text in Swift and SwiftUI.

RichTextKit has a multi-platform SwiftUI ``RichTextEditor`` that can be added to any app. The editor supports text styles (bold, italic, underline, etc.), fonts, font sizes, colors, text alignments, image attachments, and much more.

The ``RichTextEditor`` is powered by a multi-platform `RichTextView` that bridges `UITextView` and `NSTextView` and adds APIs to make them work more alike on all platforms.



## Installation

RichTextKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/RichTextKit.git
```



## Getting started

@Links(visualStyle: detailedGrid) {
    
    - <doc:Getting-Started>
    - <doc:Demo-Article>
}



## Repository

For more information, source code, etc., visit the [project repository](https://github.com/danielsaidi/RichTextKit).



## License

RichTextKit is available under the MIT license.



## Topics

### Getting Started

- <doc:Getting-Started>

### Articles

- <doc:Demo-Article>
- <doc:Context-Article>
- <doc:Format-Article>
- <doc:Views-Article>

### Essentials

These are the top-level types you should start looking at.

- ``RichTextEditor``
- ``RichTextView``
- ``RichTextContext``

### Foundation

- ``RichTextCoordinator``
- ``RichTextPresenter``
- ``RichTextReader``
- ``RichTextWriter``

### Actions

- ``RichTextAction``
- ``RichTextInsertable``
- ``RichTextInsertion``

### Alignment

- ``RichTextAlignment``

### Attributes

- ``RichTextAttribute``
- ``RichTextAttributes``
- ``RichTextAttributeReader``
- ``RichTextAttributeWriter``

### Colors

- ``ColorRepresentable``
- ``RichTextColor``

### Colors

- ``ColorRepresentable``
- ``RichTextColor``

### Commands

- ``RichTextCommand``

### Data

- ``RichTextDataError``
- ``RichTextDataFormat``
- ``RichTextDataReader``

### Editor

- ``RichTextEditorConfig``
- ``RichTextEditorStyle``

### Export

- ``RichTextExportError``
- ``RichTextExportMenu``
- ``RichTextExportService``
- ``RichTextExportUrlResolver``
- ``StandardRichTextExportService``
- ``StandardRichTextExportUrlResolver``

### Fonts

- ``FontRepresentable``
- ``FontDescriptorRepresentable``
- ``FontTraitsRepresentable``
- ``RichTextFont``
- ``StandardFontSizeProvider``

### Format

- ``RichTextFormat``

### Images

- ``ImageRepresentable``
- ``RichTextImageAttachment``
- ``RichTextImageAttachmentManager``
- ``RichTextImageAttachmentSize``
- ``RichTextImageConfiguration``
- ``RichTextImageInsertConfiguration``

### Keyboard

- ``RichTextKeyboardToolbar``
- ``RichTextKeyboardToolbarConfig``
- ``RichTextKeyboardToolbarMenu``
- ``RichTextKeyboardToolbarStyle``

### Line

- ``RichTextLine``

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

### Views

- ``RichTextLabelValue``
- ``TextViewRepresentable``



[License]: https://github.com/danielsaidi/RichTextKit/blob/master/LICENSE
[Repository]: https://github.com/danielsaidi/RichTextKit
