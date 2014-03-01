vm      = require('vm')
fs      = require('fs')
util    = require('util')
parser  = require("./parser")
emitter = require("./emitter")


prompt = require 'prompt'
ctx    = vm.createContext()
ctx['console'] = console;

repl = ->
  prompt.get ['repl'], (err, result)->
    ast = parser.parse(result.repl)
    console.log ast
    js = emitter.emit(ast).join(";")
    console.log js
    console.log "=>", vm.runInContext(js, ctx)
    repl()

repl()
