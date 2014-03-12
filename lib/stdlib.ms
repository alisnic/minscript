(namespace :std)

(defn map (ary, cb)
  (Array.prototype.map.call ary cb))

(defn reduce (first ary cb)
  (Array.prototype.reduce.call ary cb first))

(defn str ()
  (let strings (map arguments #(String %1))
  (reduce '' strings #(+ %1 %2)))