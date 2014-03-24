# CoffeeScript
The CoffeeScript adapter API is almost exactly the same as the CoffeeScript JS API, making this an easy transition. The CoffeeScript JS API options are notoriously difficult to find anywhere online, so I've taken the liberty of listing out all the ones I could find here for you.

## Additional Options

### Bare
 - key: `bare`
 - type: `Boolean`
 - default: `false`

Compile without function closure

### Header
 - key: `header`
 - type: ``
 - default: ``

Inject a comment with the CoffeeScript version into all compiled files

### SourceMap
 - key: `sourceMap`
 - type: ``
 - default: ``

Generate a sourcemap on compile. requires `filename`

## Other Options I Don't Understand
While browsing the source, I cam across a few other options I didn't really get, and they are not documented anywhere. If anyone knows what these are, please contribute an explanation!

- `sandbox`
- `modulename`
- `shiftLine`
- `execPath`
