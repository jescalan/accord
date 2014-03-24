# LESS
LESS has a very simple public API with just a couple options, which [can be found here](https://github.com/less/less.js/#configuration). The accord adapter takes all the same options other than the minify option, which is redundant as it can be provided through [minify-css](minify-css.md). Filename is automatically filled in when using `renderFile`, so no need to provide it. Full example below:

```js
less = accord.load('less');
less.render('some less code', {
  paths: ['/path/to/folder/for/includes'],
  filename: 'foo.less'
});
```
