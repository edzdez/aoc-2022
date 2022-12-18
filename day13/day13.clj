(ns day13)

(defn parse-packet [s] (clojure.edn/read-string s))

(defn read-input [file]
  (->> file
       slurp
       clojure.string/split-lines
       (filter not-empty)
       (mapv parse-packet)))

(defn correct-order-comp [l r]
  (cond (and (empty? l) (empty? r)) 0
        (empty? l) -1
        (empty? r) 1
        (and (int? (first l)) (int? (first r)) (= (first l) (first r))) (recur (rest l) (rest r))
        (and (int? (first l)) (int? (first r))) (let [res (compare (first l) (first r))]
                                                  (if (= res 0) (recur (rest l) (rest r)) res))
        (and (vector? (first l)) (vector? (first r))) (let [res (correct-order-comp (first l) (first r))]
                                                        (if (= res 0) (recur (rest l) (rest r)) res))
        (int? (first l)) (recur (conj (vector (vector (first l))) (vec (rest l))) r)
        (int? (first r)) (recur l (conj (vector (vector (first r))) (vec (rest r))))))

(defn correct-order? [window]
  (correct-order-comp (first window) (second window)))

(defn part-1 [data]
  (->> data
       (partition 2 2)
       (mapv correct-order?)
       (keep-indexed #(if (= %2 -1) (+ 1 %1) nil))
       (reduce + 0)))

(defn part-2 [data]
  (let [ordered (->> (conj data [[2]] [[6]])
                     (sort correct-order-comp)
                     vec)
        i (+ (.indexOf ordered [[2]]) 1)
        j (+ (.indexOf ordered [[6]]) 1)]
    (* i j)))

(defn -main []
  (let [data (read-input "day13.in")]
    (println (part-1 data))
    (println (part-2 data))))

(-main)
