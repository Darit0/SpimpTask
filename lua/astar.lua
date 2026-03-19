-- Вспомогательная функция: абсолютное значение
local function abs(x)
    return x < 0 and -x or x
end

-- Эвристика: Манхэттенское расстояние (для сетки без диагоналей)
local function heuristic(a, b)
    return abs(a.x - b.x) + abs(a.y - b.y)
end

-- Структура узла
local function create_node(x, y, g, h, parent)
    return {
        x = x,
        y = y,
        g = g or 0, -- Стоимость пути от старта
        h = h or 0, -- Эвристика до финиша
        f = 0,      -- f = g + h
        parent = parent
    }
end