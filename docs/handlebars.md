# Handlebars
Handlebars has an interesting way of operating, and a very obtuse API for its compiler. There aren't really any compiler options, but you can [register helpers](https://github.com/wycats/handlebars.js/#block-helpers) or [partials](https://github.com/wycats/handlebars.js/#partials) on the compiler itself before rendering, or [override the public api](https://github.com/wycats/handlebars.js/blob/7f6ef1dd38794f12aee33c76c04f604a7651810b/lib/handlebars/compiler/javascript-compiler.js#L10) (which is not currently allowed as a aprt of accord's wrapper).

Accord accepts the special keys `partials` or `helpers` to be registered as an object with one or more key/value pairs, each representing a helper or partial, to the corresponding keys. For example:

```js
var hbs = accord.load('handlebars');

hbs.render("hello there {{ name }}", {
  helpers: { test: function(options){}, test2: function(options){} },
  partials: { foo: "<p>{{ bar }}" },
  name: 'foobar'
});
```

The handlebars adapter also supports client-side precompiled templates, meaning you can run `compileClient` and/or `compileFileClient` to get back a strinigifed anonymous function, `clientHelpers` returns a string of JavaScript helpers that must be included in any file that contains handlebars client-side templates in order for them to render correctly.
