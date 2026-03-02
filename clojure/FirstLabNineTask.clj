(ns sum-project.core
  "Функция для рекурсивного суммирования чисел во вложенных списках")

(defn sum-nested
  "Рекурсивно обходит вложенные коллекции и суммирует все числа"
  [coll]
  (cond
    (number? coll) coll
    (sequential? coll)
      (reduce + 0 (map sum-nested coll))
    :else 0)) 

(defn -main
  [& args]
  (println "=== Тестирование sum-nested ===")
  (println "[1 2 3] →" (sum-nested [1 2 3]))
  (println "[1 [2 3] [4 [5]]] →" (sum-nested [1 [2 3] [4 [5]]]))
  (println "[] →" (sum-nested []))
  (println "[1 \"x\" 2] →" (sum-nested [1 "x" 2]))