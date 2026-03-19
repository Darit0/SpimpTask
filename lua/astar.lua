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

-- Основная функция A*
local function a_star(start_pos, goal_pos, grid)
    local rows = #grid
    local cols = #grid[1]

    -- Открытый список (узлы, которые нужно проверить)
    local open_set = { create_node(start_pos.x, start_pos.y, 0, heuristic(start_pos, goal_pos)) }
    open_set[1].f = open_set[1].g + open_set[1].h

    -- Закрытый список (уже проверенные узлы). Используем таблицу как хэш-сет для скорости
    local closed_set = {}

    -- Направления: Вверх, Вниз, Влево, Вправо
    local neighbors_offset = {
        {x = 0, y = -1},
        {x = 0, y = 1},
        {x = -1, y = 0},
        {x = 1, y = 0}
    }

    while #open_set > 0 do
        -- 1. Найти узел с наименьшим F в открытом списке
        local current_index = 1
        local lowest_f = open_set[1].f

        for i = 2, #open_set do
            if open_set[i].f < lowest_f then
                lowest_f = open_set[i].f
                current_index = i
            end
        end

        local current = open_set[current_index]

        -- 2. Если это цель, восстанавливаем путь
        if current.x == goal_pos.x and current.y == goal_pos.y then
            local path = {}
            local temp = current
            while temp do
                table.insert(path, 1, {x = temp.x, y = temp.y})
                temp = temp.parent
            end
            return path
        end

        -- 3. Перемещаем текущий узел из open в closed
        table.remove(open_set, current_index)
        local key = current.x .. "," .. current.y
        closed_set[key] = true

        -- 4. Проверяем соседей
        for _, offset in ipairs(neighbors_offset) do
            local neighbor_x = current.x + offset.x
            local neighbor_y = current.y + offset.y

            -- Проверка границ карты
            if neighbor_x >= 1 and neighbor_x <= cols and neighbor_y >= 1 and neighbor_y <= rows then
                -- Проверка на стену (1 - стена, 0 - пол)
                if grid[neighbor_y][neighbor_x] ~= 1 then
                    local n_key = neighbor_x .. "," .. neighbor_y
                    
                    -- Если сосед уже в закрытом списке, пропускаем
                    if not closed_set[n_key] then
                        local temp_g = current.g + 1
                        local neighbor_node = nil

                        -- Ищем, есть ли сосед уже в открытом списке
                        for i, node in ipairs(open_set) do
                            if node.x == neighbor_x and node.y == neighbor_y then
                                neighbor_node = node
                                break
                            end
                        end

                        -- Если соседа нет в открытом или нашли путь дешевле
                        if not neighbor_node or temp_g < neighbor_node.g then
                            if not neighbor_node then
                                neighbor_node = create_node(neighbor_x, neighbor_y)
                                table.insert(open_set, neighbor_node)
                            end
                            
                            neighbor_node.parent = current
                            neighbor_node.g = temp_g
                            neighbor_node.h = heuristic(neighbor_node, goal_pos)
                            neighbor_node.f = neighbor_node.g + neighbor_node.h
                        end
                    end
                end
            end
        end
    end

    return nil -- Путь не найден
end

-- ТЕСТОВАЯ ЧАСТЬ
-- ==========================================

-- 1 = Стена, 0 = Проход
local map = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0},
    {0, 0, 1, 1, 0, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 1, 1, 1, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
}

local start_node = {x = 1, y = 1}
local goal_node = {x = 10, y = 8}

print("Запуск поиска пути...")
local path = a_star(start_node, goal_node, map)

if path then
    print("Путь найден! Длина: " .. #path)
    
    -- Рисуем карту с путем
    -- Создаем копию карты для отрисовки, чтобы не портить оригинал
    local display_map = {}
    for i, row in ipairs(map) do
        display_map[i] = {}
        for j, val in ipairs(row) do
            display_map[i][j] = val
        end
    end

    -- Помечаем путь символом '*'
    for _, p in ipairs(path) do
        -- Не помечаем старт и финиш стенами, если вдруг они совпали с логикой, 
        -- но в данном случае просто меняем 0 на *
        if display_map[p.y][p.x] == 0 then
            display_map[p.y][p.x] = '*' 
        end
    end
    
    -- Ставим обозначения старта и финиша
    display_map[start_node.y][start_node.x] = 'S'
    display_map[goal_node.y][goal_node.x] = 'E'

    print("\nКарта (S - Старт, E - Финиш, * - Путь, 1 - Стена):")
    for _, row in ipairs(display_map) do
        local line = ""
        for _, val in ipairs(row) do
            if val == 0 then line = line .. ". "
            elseif val == 1 then line = line .. "# "
            else line = line .. val .. " " end
        end
        print(line)
    end
else
    print("Путь не найден!")
end