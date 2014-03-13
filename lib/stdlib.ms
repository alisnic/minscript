(ns :std)

(defn map (ary cb)
  (Array.prototype.map.call ary cb))

(defn reduce (ary cb first)
  (Array.prototype.reduce.call ary cb first))

(defn filter (ary cb)
  (Array.prototype.filter.call ary cb))

(defn str ()
  (let strings (map arguments #(String %1)))
  (reduce strings #(+ %1 %2) ''))

(defn puts ()
  (console.log (arguments.join ',')))

(puts (str 1 2 3 :vasea))
