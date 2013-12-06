Stylus
======

The stylus compiler interface is one of the most abnormal and has gone through heavy modification to fit to the the accord model. These docs describe how to correctly use the accord stylus adapter.

### [set](http://learnboost.github.io/stylus/docs/js.html#setsetting-value)

In stylus, you can use `set()` to set options directly on the compiler. The only time you will really ever need to use this is to set `filename`, and if you are using the `renderFile` method this is done automatically for you. So you probably won't ever need this. But if you do, you can `set` options by dropping the key/value pairs directly into the accord options object.

```coffee
styl = accord.load('stylus')
styl.render('.test\n  foo: bar', { foo: 'bar', filename: 'none' })
  .catch((err) -> console.error(err))
  .done (css) ->  console.log(css)
```

### [define](http://learnboost.github.io/stylus/docs/js.html#definename-node)

`define()` lets you pass in variables that you can use in stylus. Pretty sweet. One thing to keep in mind is that stylus does not do a great job of typecasting values that are passed in. For example, if you're working with colors, you need to go through quite a process to get the right values in. Eventually we'd like to add better typecasting to the accord adapter to make life easier, but for now you'll have to do it the long way. Let's look at an example with some basic values passed through.

```coffee
styl = accord.load('stylus')
styl.render('.test\n  width: maxwidth\n  height: maxheight', { define: { maxwidth: 42, maxheight: 100 } })
  .catch((err) -> console.error(err))
  .done (css) ->  console.log(css)
```

So define always is an object. If you pass in anything other than an object, you'll get nasty results. You can pass as many key/value pairs as you want in the object, and each one will be defined.

### [include](http://learnboost.github.io/stylus/docs/js.html#includepath)

`include()` will set additional paths in stylus that you can `@import` from. For example, if you'd like to make a specific folder of stylus available within another totally separate folder, you don't have to use path-fu on every `@import` statement, you can just add the folder's path with an `include()` and then load it as if it was in the same folder. For this and the next couple functions, you can either pass a single value or an array of values and each will be included as a path.

```coffee
styl = accord.load('stylus')
styl.render('@import foobar', { include: __dirname + 'foobar' })
  .catch((err) -> console.error(err))
  .done (css) ->  console.log(css)
```

As mentioned earlier, if you want to include multiple paths, you can pass an array.

```coffee
styl = accord.load('stylus')
styl.render('@import baz', { include: [__dirname + 'foobar', __dirname + baz] })
  .catch((err) -> console.error(err))
  .done (css) ->  console.log(css)
```

### [import](http://learnboost.github.io/stylus/docs/js.html#importpath)

`import()` is exactly like include, except rather than just making the paths available, it will import all the files at the paths given automatically, so you don't have to use an `@import` at all in your stylus. It works the exact same as include, just a different name.

```coffee
styl = accord.load('stylus')

# single import
styl.render('mixin_from_foobar()', { import: __dirname + 'foobar' })
  .catch((err) -> console.error(err))
  .done (css) ->  console.log(css)

# multiple imports
styl.render('mixin_from_baz()', { import: [__dirname + 'foobar', __dirname + baz] })
  .catch((err) -> console.error(err))
  .done (css) ->  console.log(css)
```

### [use](http://learnboost.github.io/stylus/docs/js.html#usefn)

Taking it up one more level, `use()` allows you to pass through a function which gets the entire stylus object, so you can add any number of additional `define`s, `include`s, `import`s, and whatever other javascript transformers you want. Best suited for stylus plugins that need to be loaded cleanly and make a few manipulations in the pipeline. `use` works the same as `include` or `import`, it just expects a function or array of functions.

```coffee
some_plugin = require('some_plugin')
second_plugin = require('second_plugin')
styl = accord.load('stylus')

# single plugin
styl.render('plugin()', { use: some_plugin() })
  .catch((err) -> console.error(err))
  .done (css) ->  console.log(css)

# multiple plugins
styl.render('plugin()', { use: [some_plugin(), second_plugin()] })
  .catch((err) -> console.error(err))
  .done (css) ->  console.log(css)
```
