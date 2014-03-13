exports.ast = (code)->
  parser.parse(code)

exports.generate = (ast, ctx="exports")->
  (new MinContext(ctx)).emit(ast)

exports.compile = (code)->
  ast       = exports.ast(code)
  namespace = ast.filter((s)-> s[0] is 'ns')[0]
  cleanAst  = ast.filter (s)-> s[0] isnt 'ns'

  if namespace
    wrap namespace[1].value, exports.generate(cleanAst)
  else
    exports.generate(cleanAst)

exports.eval = (code)->
  eval exports.compile(code)
