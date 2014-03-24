# Jade
The jade adapter is used in just about the exact same as the jade public api, making this adapter a very easy transition. Jade takes the [options listed here under "options"](http://jade-lang.com/api/) and they are fed through directly.

Jade does support client-side templates, meaning `compileClient` and `compileFileClient` both work, returning stringified anonymous functions, and `clientHelpers` returns a string of javascript that must be in place in order for client-side templates to render properly.
