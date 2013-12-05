W = require 'when'
fs = require 'fs'
path = require 'path'

class Accord

  load: (name, lib) ->
    cpath = path.join(__dirname, 'adapters', name)

    # ensure compiler is supported
    if !fs.existsSync("#{cpath}.coffee") then throw new Error('compiler not supported')

    # get the compiler
    if lib
      compiler = lib
    else
      try
        compiler = require(name)
      catch err
        throw new Error(name + ' not found. make sure it has been installed!')

    # return the adapter with bound compiler
    return new (require(cpath))(compiler)

  supports: (name) ->
    fs.existsSync("#{path.join(__dirname, 'adapters', name)}.coffee")    

module.exports = new Accord
