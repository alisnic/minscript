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
(let foo 12) ;=> 12
```
- Float
```clojure
(let foo 1.12) ;=> 12
```
- Strings
```clojure
(let foo 'foo') ;=> 'foo'
(let foo :foo)  ;=> 'foo'
(let foo "foo") ;=> 'foo'
```
- Booleans
```clojure
(let yes true) ;=> true
(let no false) ;=> false
```
- Null
```clojure
(let doom nil) ;=> null
(let doom null) ;=> null
```

## Functions

