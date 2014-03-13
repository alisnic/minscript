exports.DEBUG = true

exports.ast = (code)->
  parser.parse(code)

exports.generate = (ast, ctx="exports")->
  (new MinContext(ctx)).emit(ast)

exports.compile = (code)->
  ast       = exports.ast(code)
  namespace = ast.filter((s)-> s[0] is 'ns')[0]
  cleanAst  = ast.filter (s)-> s[0] isnt 'ns'

  js = if namespace
    wrap namespace[1].value, exports.generate(cleanAst)
  else
    exports.generate(cleanAst)

  console.log(ast) if exports.DEBUG
  console.log(js) if exports.DEBUG
  js

exports.eval = (code)->
  eval exports.compile(code)
