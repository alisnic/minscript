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

- [Language Reference](#language-reference)
    - [Comments](#comments)
    - [Data](#data)
    - [Conditions](#conditions)
    - [Loops](#loops)
    - [Try/Catch/Finally](#trycatchfinally)
    - [Functions](#functions)
    - [Objects](#objects)
    - [Arrays](#arrays)
    - [Chaining](#chaining)
    - [Namespace](#namespace)
    - [Instanciating JS objects](#instanciating-js-objects)

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
```clojure
; same if you know from many other lisps
(if true (alert 'true!') (alert 'reality has failed'))
;=> if (true) { alert('true!') } else { alert('reality has failed') }

; and same cond you know too
(cond
    (= 1 1) (alert 'good news!')
    (= 1 2) (alert 'bad news!')
    :else (alert 'whatever'))
;=> if (1===1) {
;       alert('good news!')
;   } else if (1===2) {
;       alert('bad news!')
;   } else if ("else") {
;       alert('whatever')
;   }
```

## Loops
```clojure
(letfn fac (x)
  (loop (n x f 1)
    (if (= n 1)
      f
      (recur (- n 1) (* f n)))))

; var fac = function (x) {
;   return (function () {
;     var n,f, __$args, __$acc, __$ret;
;     __$acc = [[x,1]];
;
;     while (__$acc.length) {
;       __$args = __$acc.shift();
;       n = __$args.shift();
;       f = __$args.shift();
;       __$ret = (n===1) ? (f) : (__$acc.push([n-1,f*n]));
;     }
;
;   return __$ret;
;   })();
; }

(fac 10) ;=> 3628800
```
## Try/Catch/Finally
```clojure
(try
     (/ 5 0)
     (catch ex (console.log ex))
     (finally 0))

; try {
;   5/0
; } catch (ex) {
;    console.log(ex)
; } finally {
;  0
; }
```

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
MinScript has 2 ways of defining a variable: `let` and `def`. (letfn and defn as well). `def` is the same as `let`
(it defines a local variable), except `def` will export that variable from module.
```clojure
(ns :answers)
(let local true) ; is local
(def ultimate 42) ; will be exported
```
This will generate the following JavaScript:
```javascript
(function(exports){

var local = true;
var ultimate = 42;
exports.ultimate = ultimate;

})(typeof exports === 'undefined' ? this["answers"]={} : exports);
```

## Instanciating JS Objects
```clojure
(let now (new Date))        ;=> var now = new Date()
(let ary (new Array 1 2 3)) ;=> var ary = new Array(1,2,3)
```
