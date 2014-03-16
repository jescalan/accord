# Base Adapter
All accord adapters inherit from a base adapter. So, the options documented here will work with all the other adapters (unless otherwise noted).

## Options

### Filename
 - key: `filename`
 - type: `String`
 - default: The filename that's passed to `compileFile`, otherwise `undefined`.

If you use the `compile` or `render` function, but you also happen to know the filename of the file that's being compiled, you can pass it in the `options` object as `filename`. By providing the filename, it will usually improve error reporting, but it varies depending on the compiler.

If you pass the filename to the function (as with `renderFile`, `compileFile`, and `compileFileClient`) then `filename` will be set for you.
