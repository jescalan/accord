# EJS
EJS's interface, like Jade's, is almost the exact same as accord's. It simply takes an object of options. You can see those options [here](https://github.com/visionmedia/ejs#options).

EJS supports client-side compiles as well. `compileClient` and `compileFileClient` method are both supported and return stringified anonymous functions. EJS requires a few helpers in order to correctly render client-side templates, which can be attained by running `clientHelpers`, which also returns a string of minfied javascript.
