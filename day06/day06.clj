(ns day06)

(def file "day06.in")

(defn read-input [file]
  (clojure.string/trim (slurp file)))

(defn invalid-window [window]
  (not (apply distinct? window)))

(defn part-1 [signal]
  (+ 4 (->> signal
       (partition 4 1)
       (take-while invalid-window)
       count)))

(defn part-2 [signal]
  (+ 14 (->> signal
       (partition 14 1)
       (take-while invalid-window)
       count)))

(defn -main []
  (let [input (read-input file)]
    (println (part-1 input))
    (println (part-2 input))))

(-main)
