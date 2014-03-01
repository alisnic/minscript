vm      = require('vm')
fs      = require('fs')
util    = require('util')
parser  = require("./parser")

map  = (ary, cb)-> Array::map.call(ary, cb)
rest = (ary)->     Array::slice.call(ary, 1)
last = (ary)-> ary[ary.length-1]

eachSlice = (ary, count, cb)->
  for i in [0...ary.length] by count
    cb ary[i...i+count]

group = (code)-> "(#{code})"

generate = (statements)->
  map(statements, grow)

grow = (statement)->
  return '' unless statement?
  return statement.value if statement.value? or statement.null
  return statement unless statement instanceof Array

  name = statement[0]
  args = rest(statement)

  switch name
    when '+', '-', '*', '/'
      generate(args).join(name)
    when '='
      generate(args).join("===")
    when 'let'
      slices = eachSlice args, 2, (slice)->
        "#{grow(slice[0])} = #{grow(slice[1])}"

      "var #{slices.join(',')}"
    when 'if'
      cond      = grow(args[0])
      body      = grow(args[1])
      elsebody  = grow(args[2])

      js = "if (#{cond}) { #{body} }"
      js += " else { #{elsebody} }" if elsebody.length
      js
    when 'when'
      cond = grow(args[0])
      "if (!#{cond}) { #{generate(rest(args)).join(';')} }"
    when 'cond'
      slices = eachSlice args, 2, (slice)->
        "(#{grow(slice[0])}) { #{grow(slice[1])} }"

      "if #{slices.join(' else if ')}"
    when 'get'
      chain = generate(rest(args)).map((e)-> "[#{e}]").join('')
      "#{grow(args[0])}#{chain}"
    when 'set'
      chain = generate(args[1..-2]).map((e)-> "[#{e}]").join('')
      "#{grow(args[0])}#{chain} = #{grow(last(args))}"
    when 'hash'
      slices = eachSlice args, 2, (slice)->
        "#{grow(slice[0])}:#{grow(slice[1])}"

      "{#{slices.join(',')}}"
    when 'array'
      "[#{generate(args).join(',')}]"
    when 'recur'
      rebind = grow ['set', 'i', args[0]]
      "continue;"
    when 'loop'
      bindings = grow ['let'].concat(args[0])
      "#{bindings}; while (true) { #{generate(rest(args)).join(';')} break; }"
    when 'fn'
      statements = rest(args)
      body = generate(statements.slice(0, statements.length-2)).join(";")
      body = "#{body};" unless body.length is 0
      rtn  = grow(last(statements))

      "function (#{args[0].join(',')}) { #{body}return #{rtn}; }"
    when 'letfn'
      grow ['let', args[0], grow(['fn'].concat(rest(args)))]
    else
      "#{name}(#{generate(args).join(',')});"

prompt = require 'prompt'
ctx    = vm.createContext()
ctx['console'] = console;

repl = ->
  prompt.get ['repl'], (err, result)->
    ast = parser.parse(result.repl)
    console.log ast
    js = generate(ast).join(";")
    console.log js
    console.log "=>", vm.runInContext(js, ctx)
    repl()

repl()
