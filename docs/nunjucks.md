Nunjucks
====

The [nunjucks](http://jlongster.github.io/nunjucks/) adapter is somewhat opinionated to keep things consistent with the rest of the HTML compilers.

- When rendering or compiling files, the adapter assumes any extended templates are in the same directory as the file selected (similar to jade).
- All options (compiler-level and method-level)  share the same hash.  See the [Nunjucks documentation](http://jlongster.github.io/nunjucks/templating.html) for options.
- For render and renderFile, locals are passed to `options.locals`.
- Compile methods return Nunjuck's `renderString` function (documented [here](http://jlongster.github.io/nunjucks/api.html#renderstring)).

Nunjucks supports client-side templates, so use `compileClient` and `compileFileClient` at will - when [this issue](https://github.com/jlongster/nunjucks/issues/129) is resolved.  
