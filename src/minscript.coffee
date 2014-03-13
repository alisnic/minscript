parser  = require '../src/parser'
emitter = require '../src/emitter'
wrapper = require '../src/wrapper'

module.exports =
  compile: (code)->
    ast       = @ast(code)
    namespace = ast.filter((s)-> s[0] is 'ns')[0]
    throw "Missing namespace declaration" unless namespace

    cleanAst = ast.filter (s)-> s[0] isnt 'ns'
    wrapper.wrap namespace[1].value, @generate(cleanAst)

  ast: (code)->
    parser.parse(code)

  generate: (ast, ctx="exports")->
    emitter.init(ctx).emit(ast)
