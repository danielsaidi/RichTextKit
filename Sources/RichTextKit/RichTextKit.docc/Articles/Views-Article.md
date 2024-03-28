# Views

This article describes the RichTextKit view library.

@Metadata {
    
    @PageImage(
        purpose: card,
        source: "Page",
        alt: "Page icon"
    )
    
    @PageColor(blue)
}

There are many different SwiftUI views within the library besides the ``RichTextEditor`` and the platform-specific `RichTextView`. 

For instance, the ``RichTextAction``-specific ``RichTextAction/Button``, ``RichTextAction/ButtonGroup`` and ``RichTextAction/ButtonStack`` can be used to easily trigger actions from anywhere.

There are also type-specific views, like the ``RichTextAlignment``-specific ``RichTextAlignment/Picker``, which can be used to pick a rich text alignment.



## Available views

Below is a list of available views, grouped by purpose and listed by namespace.

@TabNavigator {
    
    @Tab("Essentials") {
        
        @Row {
            @Column {
                Essential Views
            }
            @Column(size: 3) {
                * ``RichTextEditor``
                * ``RichTextView``
                * ``RichTextViewer``
            }
        }
    }
        
    @Tab("Actions") {
        
        @Row {
            @Column {
                ``RichTextAction``
            }
            @Column(size: 3) {
                * ``RichTextAction/Button``
                * ``RichTextAction/ButtonGroup``
                * ``RichTextAction/ButtonStack``
            }
        }
    }
    
    @Tab("Style & Formatting") {
        
        @Row {
            @Column {
                ``RichTextAlignment``
            }
            @Column(size: 3) {
                * ``RichTextAlignment/Picker``
            }
        }
        
        @Row {
            @Column {
                ``RichTextColor``
            }
            @Column(size: 3) {
                * ``RichTextColor/Picker``
            }
        }
        
        @Row {
            @Column {
                ``RichTextFont``
            }
            @Column(size: 3) {
                * ``RichTextFont/Picker``
                * ``RichTextFont/ForEachPicker``
                * ``RichTextFont/ListPicker``
                * ``RichTextFont/SizePicker``
                * ``RichTextFont/SizePickerStack``
            }
        }
        
        @Row {
            @Column {
                ``RichTextLine``
            }
            @Column(size: 3) {
                * ``RichTextLine/SpacingPicker``
                * ``RichTextLine/SpacingPickerStack``
            }
        }
        
        @Row {
            @Column {
                ``RichTextStyle``
            }
            @Column(size: 2) {
                * ``RichTextStyle/Button``
                * ``RichTextStyle/Toggle``
                * ``RichTextStyle/ToggleGroup``
                * ``RichTextStyle/ToggleStack``
            }
        }
    }
    
    @Tab("Toolbars & Menus") {
        
        @Row {
            @Column {
                ``RichTextDataFormat``
            }
            @Column(size: 3) {
                * ``RichTextDataFormat/Menu``
            }
        }
        
        @Row {
            @Column {
                Keyboard
            }
            @Column(size: 3) {
                * ``RichTextKeyboardToolbar``
                * ``RichTextKeyboardToolbarMenu``
            }
        }
            
        @Row {
            @Column {
                Sharing
            }
            @Column(size: 3) {
                * ``RichTextShareMenu``
            }
        }
    }
    
    @Tab("Commands") {
        
        @Row {
            @Column {
                ``RichTextCommand``
            }
            @Column(size: 3) {
                * ``RichTextCommand/ActionButton``
                * ``RichTextCommand/ActionButtonGroup``
                * ``RichTextCommand/FormatMenu``
                * ``RichTextCommand/ShareMenu``
            }
        }
    }
}



## Styling & Configuration

Many of the RichTextKit views can be styled and configured with view modifiers, that can be applied anywhere in your view hierarchy.

For instance, to style or configure a ``RichTextKeyboardToolbar``, you can apply a `.richTextKeyboardToolbarConfig` or `-Style` modifier to your view hierarchy. 


[GitHub]: https://github.com/danielsaidi/RichTextKit
