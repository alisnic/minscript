MinScript
=========

MinScript is a small and compact language that compiles to JS. It has a lisp
syntax.

```clojure
; hello.ms
(console.log "Hello World!")
```

```bash
❯ minscript hello.ms
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
(let foo 1.12) ;=> var foo = 12

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

## Functions
```clojure
; Anonymous function:
(fn (a b) (+ a b)) ;=> function (a,b) { return a+b; }

; Function as a local variable:
(letfn foo (a b) (+ a b)) ;=> var foo = function (a,b) { return a+b; }

; Short function notation: (like in clojure)
(let sum #(%0 %1)) ;=> var sum = function () { return arguments[0]+arguments[1]; }

; Getter function generator:
(map squares &:width); => map(squares,function () { return arguments[0].width; })

; Invocator function generator:
(map squares &&:area); => map(squares,function () { return arguments[0].area(); })
```
