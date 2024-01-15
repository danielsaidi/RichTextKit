# Release Notes

RichTextKit will use semver after 1.0. 

Until then, minor updates may remove deprecated features and introduce breaking changes.



# 1.0

This version makes the `RichTextReader` types require a range, to make the `RichTextComponent` functions be able to use `nil` and default to the current position or selection.

This version will keep all deprecations, to serve as support when migrating from 0.x to 1.0. These deprecations will be removed in 1.1.

For older release notes, check out older tags.


### 🗑️ Deprecations 

* `RichTextReader` `.richTextRange` has been renamed to `.richTextFullRange`. 

### 💥 Breaking Changes

* `RichTextAttributeReader` `richTextAttribute` and `richTextAttributes` now require a range.



[DominikBucher12]: https://github.com/DominikBucher12
[Mcrich23]: https://github.com/Mcrich23
[msrutek-paylocity]: https://github.com/msrutek-paylocity
