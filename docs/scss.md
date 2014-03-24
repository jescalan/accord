# SCSS
This adapter uses [node-sass](https://github.com/andrew/node-sass), an incredibly fast C binding to libsass. It is however limited in that it does not include ways to work with plugins and extensions that are as robust as the main ruby version, and that it only supports the scss syntax, and not sass.

## Additional Options
It has a pretty standard API, and uses the [options documented here](https://github.com/andrew/node-sass#options). Do not pass through `data` or `file`, as this will be overridden by accord's wrapper - everything else is fair game.

If you do want to include plugins, you can start moving towards this type of functionality using the `importPaths` option - by adding a folder to this path, you will make all its contents available for `@import`s into your scss files. While not quite as robust as stylus' options or sass-ruby's options, it will get the job done.
