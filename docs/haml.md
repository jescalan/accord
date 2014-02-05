HAML
====

The haml compiler is very simply and fairly weak in comparison to other similar javascript templating engines like jade. It does not support any sort of layout system or includes, and it does not support client-side templates (yet). It's compile options are not documented, but here's what I could find in the source:

- `filename`: standard fare, used for reporting errors
- `cache`: boolean, used to cache templates. filename required to use this, default false

Haml also allows you to [extend it](https://github.com/visionmedia/haml.js#extending-haml) with custom filters and doctypes, although this functionality has not yet been added to the accord adapter due to low demand. If there is a need, open an issue and/or pull request and adding it should not be too much work.
