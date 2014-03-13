(ns :std)

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

(puts (str 1 2 3 :vasea))
