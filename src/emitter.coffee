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
      when 'bit_and'
        @generate(args).join("&")
      when 'bit_or'
        @generate(args).join("|")
      when 'bit_xor'
        @generate(args).join("^")
      when 'bit_not'
        "^#{grow(args[0])}"
      when 'bit_shift_left'
        @generate(args).join("<<")
      when 'bit_shift_right'
        @generate(args).join(">>")
      when 'bit_shit_zero_right'
        @generate(args).join(">>>")
      when 'fn'
        statements = rest(args)
        body = @generate(statements.slice(0, statements.length-1)).join(";\n")
        body = "#{body};\n" unless body.length is 0
        rtn  = @grow(last(statements))

        """
        function (#{args[0].join(',')}) {
          #{body}return #{rtn};
        }"""
      when 'try'
        catches = args.filter (a)->
          a[0] is 'catch'
        .map (c)=>
          """
          catch (#{@grow(c[1])}) {
            #{@emit(c[2..-1])}
          }"""
        .join(" ")

        finals = args.filter (a)->
          a[0] is 'finally'
        .map (c)=>
          """
          finally {
            #{@emit(c[1..-1])}
          }"""
        .join(" ")

        body = @emit(args.filter((a)-> a[0] isnt 'catch' and a[0] isnt 'finally'))

        """
        try {
          #{body}
        } #{catches} #{finals}
        """
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

        js = "(#{cond}) ? (#{body}) : "
        if elsebody.length
          js += "(#{elsebody})"
        else
          js += "null"

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
        "__$acc.push([#{@generate(args).join(',')}])"
      when 'loop'
        bind_names  = (v for v,i in args[0] when i % 2 is 0)
        bind_values = (v for v,i in args[0] when i % 2 is 1)

        shift = bind_names.map((n)-> "#{n} = __$args.shift()").join(";\n")
        vars  = bind_names.join(",")
        vals  = @generate(bind_values).join(',')

        statements = rest(args)
        body = @generate(statements.slice(0, statements.length-1)).join(";\n")
        body = "#{body};\n" unless body.length is 0
        rtn  = @grow(last(statements))

        """
        (function () {
          var #{vars}, __$args, __$acc, __$ret;
          __$acc = [[#{vals}]];

          while (__$acc.length) {
            __$args = __$acc.shift();
            #{shift};
            #{body}__$ret = #{rtn};
          }

          return __$ret;
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
          args[2].value.replace(/[\/\."']/g, '')
        else
          name.replace(/[\/\."']/g, '')

        "var #{normalized} = require(#{name})"
      when 'use'
        name = args[0].value.replace(/"/g, '')
        """
        (function (root) {
          for (var key in #{name})
            root[key] = #{name}[key]
        })(typeof global === 'undefined' ? window : global);
        """
      else
        "#{name}(#{@generate(args).join(',')})"
