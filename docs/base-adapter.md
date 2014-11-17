# Base Adapter
All accord adapters inherit from a base adapter. So, the options documented here will work with all the other adapters (unless otherwise noted).

## Supported Methods
Not all compilers implement the full list of methods, but these are the ones they _can_ support. Check the docs for the specific adapter to find out what methods it supports.
 - `render`
 - `compile`
 - `compileClient`
 - `clientHelpers`

In addition, anything that supports a particular method (other than `clientHelpers`) will automatically support the "file" version of that method. For example, if it supports `render`, it will support `renderFile`.

## Options
All all adapters support these options.

### Filename
 - key: `filename`
 - type: `String`
 - default: The filename that's passed to `compileFile`, otherwise `undefined`.

If you use the `compile` or `render` function, but you also happen to know the filename of the file that's being compiled, you can pass it in the `options` object as `filename`. By providing the filename, it will usually improve error reporting, but it varies depending on the compiler.

If you pass the filename to the function (as with `renderFile`, `compileFile`, and `compileFileClient`) then `filename` will be set for you.

## Templating Engine Options
All templating engine adapters support these options

### Data
 - key: `data`
 - type: `Object`
 - default: `undefined`

The data that gets passed to the template. Generally, the properties of this object become locals within the template, but specific templates may handle them differently.

## Misc Options
These options are supported by more than one adapter, but aren't supported by all adapters or a particular type of adapter.

### Plugins
- key: `plugins`
- type: `Array`
- default: `[]`

These are sometimes called "extensions", but we call them plugins to prevent confusion with the term "file extensions". Several adapters have plugin interfaces that let you extend the functionality of a given engine (like [nib](https://github.com/visionmedia/nib) does for [Stylus](https://github.com/LearnBoost/stylus)). Normally these are passed to the engine by `require`ing them and then passing the resulting function to the engine directly through whatever mechanism the engine defines.

Adapters do include options for passing these plugin functions directly, but passing a function through those options will disable parallel processing in [accord-parallel](https://github.com/slang800/accord-parallel) because parallel processing requires us to be able to sterilize all options into text so we can pass them between processes. So, we encourage you to use the `plugins` option whenever possible.

The `plugins` option defines an array of plugin objects. The order of the plugins in this array will be the same as the order in which they are passed to the engine (in case the order matters). Each plugin object has the following properties:
- `name`
  The name of the plugin. This will be used to `require` the plugin from within the adapter.
- `path` (optional)
  If you need to use a particular installation of an engine (rather than the one that `require` resolves to automatically), or an engine that isn't an npm module, then pass the path to it here.
- `args` (optional)
  Many plugins, when required, export a function that needs to be called with whatever options you want to pass. If this is `undefined` then accord will assume that the plugin doesn't export a function that needs to be called. If this is defined then whatever the plugin exports will be called with the array of args in the same way that [apply()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/apply) passes its array of args. If the exported function needs to be called with no args, then set this to an empty array.
