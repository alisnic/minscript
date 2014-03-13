exports.ast = (code)->
  parser.parse(code)

exports.generate = (ast, ctx="exports")->
  (new MinContext(ctx)).emit(ast)

exports.compile = (code)->
  ast       = exports.ast(code)
  namespace = ast.filter((s)-> s[0] is 'ns')[0]
  throw "Missing namespace declaration" unless namespace

  cleanAst = ast.filter (s)-> s[0] isnt 'ns'
  wrap namespace[1].value, exports.generate(cleanAst)

exports.eval = (code)->
  eval exports.compile(code)
