# Data Formats

This article describes the various ``RichTextDataFormat``s that are supported by the platform.

@Metadata {
    
    @PageImage(
        purpose: card,
        source: "Page",
        alt: "Page icon"
    )
    
    @PageColor(blue)
}

In RichTextKit, the ``RichTextDataFormat`` type determines how rich text content is handled:

* ``RichTextDataFormat/archivedData`` uses an keyed archiving to persist rich text and image attachments into the text itself.
* ``RichTextDataFormat/rtf`` supports rich content but requires additional handling of images.
* ``RichTextDataFormat/plainText`` only supports plain text without formatting.
* ``RichTextDataFormat/vendorArchivedData(id:fileExtension:fileFormatText:uniformType:)`` can be used to define vendor-specific archived data, which you can use to use custom uniform types.

Note that ``RichTextDataFormat/archivedData`` is very capable, but not as portable as other formats. For instance, it may be hard to use on other platforms, since you need to unarchive the data.



## How to create an attributed string with a specific format 

RichTextKit has an `NSAttributedString` initializer that can be used to create a string value with a certain ``RichTextFormat``:

```
NSAttributedString(data: myData, format: .archivedData)
```


## How to get attributed string with a specific format 

A ``RichTextDataReader`` (a protocol implemented by `NSAttributedString` and other library types) can get rich text data for a specific ``RichTextFormat``, using the handy ``RichTextDataReader/richTextData(for:)`` function:

```
let data = richText.richTextData(for: .archivedData)
```


## Sharing & Exporting

You can share and export an attributed string in different formats. Just be careful when exporting a rich text to plain text, or archived data to rich text, since certain capabilities can be omitted. 
