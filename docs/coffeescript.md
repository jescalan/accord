CoffeeScript
============

The coffeescript adapter api is almost exactly the same as the coffeescript js api, making this an easy transition. The coffeescript js api options are notiriously difficult to find anywhere online, so I've taken the liberty of listing out all the ones I could find here for you. 

- `bare`: compile without function closure
- `header`: inject a comment with the coffeescript version into all compiled files
- `sourceMap`: generate a sourcemap on compile. requires `filename`
- `filename`: for better error traces, highly recommended

### Other Options I Don't Understand

While browsing the source, I cam across a few other options I didn't really get, and they are not documented anywhere. If anyone knows what these are, please contribute an explanation!

- `sandbox`
- `modulename`
- `shiftLine`
- `execPath`
