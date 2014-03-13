(ns :std)
(require :fs)

(defn map (ary cb)
  (Array.prototype.map.call ary cb))

(defn reduce (ary cb first)
  (Array.prototype.reduce.call ary cb first))

(defn filter (ary cb)
  (Array.prototype.filter.call ary cb))

(defn str ()
  (let strings (map arguments #(String %0)))
  (reduce strings #(+ %0 %1) ''))

(defn join (ary char)
  (Array.prototype.join.call ary char))

(defn puts ()
  (console.log (join arguments ',')))

(defn each (ary cb)
  (Array.prototype.forEach.call ary cb))

(puts (str 1 2 3 :vasea))
(puts (fs.readdirSync '.'))
