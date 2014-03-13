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
- Int
```clojure
(let foo 12) ;=> var foo = 12
```
- Float
```clojure
(let foo 1.12) ;=> var foo = 12
```
- Strings
```clojure
(let foo 'foo') ;=> var foo = 'foo'
(let foo :foo)  ;=> var foo = 'foo'
(let foo "foo") ;=> var foo = 'foo'
```
- Booleans
```clojure
(let yes true) ;=> var yes = true
(let no false) ;=> var no = false
```
- Null
```clojure
(let doom nil) ;=> var doom = null
(let doom null) ;=> var doom = null
```

## Functions
There are several ways to define a function in MinScript:

Anonymous function:
```clojure
(fn (a b) (+ a b)) ;=> function (a,b) { return a+b; }
```
Function as a local variable:
```clojure
(letfn foo (a b) (+ a b)) ;=> var foo = function (a,b) { return a+b; }
```
Short function notation: (like in clojure)
```clojure
(let sum #(%0 %1)) ;=> var sum = function () { return arguments[0]+arguments[1]; }
```
