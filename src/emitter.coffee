map  = (ary, cb)-> Array::map.call(ary, cb)
rest = (ary)->     Array::slice.call(ary, 1)
last = (ary)-> ary[ary.length-1]

eachSlice = (ary, count, cb)->
  for i in [0...ary.length] by count
    cb ary[i...i+count]

group = (code)-> "(#{code})"

class MinContext
  constructor: (@exportTarget)->

  emit: (ast)-> @generate(ast).join(";\n")

  generate: (statements)->
    map statements, (s)=> @grow(s)

  grow: (statement)->
    return '' unless statement?
    return statement.value if statement.value? or statement.null
    return statement unless statement instanceof Array

    name = statement[0]
    args = rest(statement)

    switch name
      when '+', '-', '*', '/'
        @generate(args).join(name)
      when '='
        @generate(args).join("===")
      when 'fn'
        statements = rest(args)
        body = @generate(statements.slice(0, statements.length-1)).join(";\n")
        body = "#{body};\n" unless body.length is 0
        rtn  = @grow(last(statements))

        """
        function (#{args[0].join(',')}) {
          #{body}return #{rtn};
        }"""
      when 'let'
        slices = eachSlice args, 2, (slice)=>
          "#{@grow(slice[0])} = #{@grow(slice[1])}"

        "var #{slices.join(',')}"
      when 'letfn'
        @grow ['let', args[0], @grow(['fn'].concat(rest(args)))]
      when 'def'
        letjs = @grow(['let'].concat(args))
        "#{letjs};\n#{@exportTarget}.#{args[0]} = #{args[0]}"
      when 'defn'
        @grow ['def', args[0], @grow(['fn'].concat(rest(args)))]
      when 'if'
        cond      = @grow(args[0])
        body      = @grow(args[1])
        elsebody  = @grow(args[2])

        js = "if (#{cond}) {\n #{body} }"
        js += " else {\n #{elsebody} }" if elsebody.length
        js
      when 'cond'
        slices = eachSlice args, 2, (slice)=>
          "(#{@grow(slice[0])}) { #{@grow(slice[1])} }"

        "if #{slices.join(' else if ')}"
      when 'get'
        chain = @generate(rest(args)).map((e)-> "[#{e}]").join('')
        "#{@grow(args[0])}#{chain}"
      when 'set'
        chain = @generate(args[1..-2]).map((e)-> "[#{e}]").join('')
        "#{@grow(args[0])}#{chain} = #{@grow(last(args))}"
      when 'hash'
        slices = eachSlice args, 2, (slice)=>
          "#{@grow(slice[0])}:#{@grow(slice[1])}"

        "{#{slices.join(',')}}"
      when 'array'
        "[#{@generate(args).join(',')}]"
      when 'recur'
        "__$loop_acc.push([#{@generate(args).join(',')}])"
      when 'loop'
        bind_names  = (v for v,i in args[0] when i % 2 is 0)
        bind_values = (v for v,i in args[0] when i % 2 is 1)

        shift = bind_names.map((n)-> "#{n} = __$loop_args.shift()").join(";\n")
        vars  = bind_names.join(",")
        vals  = @generate(bind_values).join(',')

        """
        (function () {
          var #{vars}, __$loop_args, __$loop_acc;
          __$loop_acc = [[#{vals}]];

          while (__$loop_acc.length) {
            __$loop_args = __$loop_acc.shift();
            #{shift};
            #{@generate(rest(args)).join(';')}
          }
        })();
        """
      when 'new'
        "new #{args[0]}(#{@generate(rest(args)).join(',')})"
      when '->'
        target = @grow(args[0])
        chain = @generate(rest(args)).join(".")
        "#{target}.#{chain}"
      when 'require'
        name = args[0].value

        normalized = if args[1]?.value is '"as"' and args[2]?.value
          args[2].value.replace(/[\/\."]/g, '')
        else
          name.replace(/[\/\."]/g, '')

        "var #{normalized} = require(#{name})"
      else
        "#{name}(#{@generate(args).join(',')})"

exports.init = (exportTarget='this')-> new MinContext(exportTarget)
