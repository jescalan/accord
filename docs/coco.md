Coco
====

Coco is a fork of coffeescript that tries to eliminate some pain points. It has a very similar compiler to that of coffeescript, with even fewer options. The options are not documented anywhere explicitly, but I found just two being used in the source, documented below:

- filename: used for error reporting, built in to `compileFile` in accord
- bare: compile without function closure

These options are passed as an object as usual.
