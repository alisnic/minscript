vm      = require 'vm'
fs      = require 'fs'
util    = require 'util'
prompt  = require 'prompt'

parser  = require './parser'
emitter = require './emitter'

ctx = vm.createContext()
ctx['console'] = console;

compile = ->
  #

repl = ->
  prompt.get ['repl'], (err, result)->
    ast = parser.parse(result.repl)
    console.log ast
    js = emitter.emit(ast).join(";")
    console.log js
    console.log "=>", vm.runInContext(js, ctx)
    repl()

console.log process.argv
