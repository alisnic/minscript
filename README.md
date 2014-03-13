MinScript
=========

MinScript is a small and compact language that compiles to JS. It has a lisp
syntax.

```clojure
; hello.ms
(console.log "Hello World!")
```

```bash
$ minscript hello.ms
Hello World!
```

# Language Reference
## Comments
```clojure
; this is a minscript comment
; just type them as much as you want
```

## Data
```clojure
; Numbers
(let foo 12) ;=> var foo = 12
(let foo 1.12) ;=> var foo = 1.12

; Strings
(let foo 'foo') ;=> var foo = 'foo'
(let foo :foo)  ;=> var foo = 'foo'
(let foo "foo") ;=> var foo = 'foo'

; Booleans
(let yes true) ;=> var yes = true
(let no false) ;=> var no = false

; Null
(let doom nil) ;=> var doom = null
(let doom null) ;=> var doom = null
```

## Conditions

## Loops

## Functions
```clojure
; Anonymous function:
(fn (a b) (+ a b)) ;=> function (a,b) { return a+b; }

; Function as a local variable:
(letfn foo (a b) (+ a b)) ;=> var foo = function (a,b) { return a+b; }

; Short function notation: (like in clojure)
(let sum #(+ %0 %1)) ;=> var sum = function () { return arguments[0]+arguments[1]; }

; Getter function generator:
(map squares &:width); => map(squares,function () { return arguments[0].width; })

; Invocator function generator:
(map squares &&:area); => map(squares,function () { return arguments[0].area(); })
```

## Objects
```clojure
; to define a object, just use the hash function
(let obj (hash :foo "bar")) ;=> var obj = {foo: "bar"}

; getting attributes
(let foo (get obj :foo)) ;=> var foo = obj["foo"]

; you can add more keys to deep access stuff
(let foo (get obj :foo :bar :baz)) ;=> var foo = obj["foo"]["bar"]["baz"]

; setting attributes
(set obj :foo 12) ;=> obj["foo"] = 12

; works deeply as well
(set obj :foo :bar :baz 12) ;=> obj["foo"]["bar"]["baz"] = 12
```

## Arrays
```clojure
; to create an array, just use the array function
(let ary (array 1 2 3)) ;=> var ary = [1,2,3]

; since JavaScript is so awesome and everything is a object,
; you can use the same get/set functions from object
(let first (get ary 0)) ;=> var first = ary[0]
(set ary 0 10) ;=> ary[0] = 10
```

## Chaining
```clojure
; you can chain invokations using the -> operator
(-> ($ :body)
    (attr :cool :yes)
    (css :color :black))
; => $('body').attr('cool', 'yes').css('color', 'black')

; alert the world about your awesomeness when you save a Backbone Model
(-> (model.save)
    (success #(alert 'the model has been saved')))
;=> model.save().success(function () { return alert('the model has been saved'); })

; some promises
(-> (ajax.ready)
    (then #(alert 'ready'))
    (then #(alert 'ready again'))

;=> ajax.ready().then(function () { return alert('ready'); }).then(function () { return alert('ready again'); })
```

## Namespace
