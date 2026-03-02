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