local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Переменная активации (можешь менять её из других скриптов или консоли)
_G.StartFarm3 = false

-- Твои координаты
local points = {
    [1] = Vector3.new(-1455.15, -160.52, -850.64),
    [2] = Vector3.new(-1454.73, -110.51, -685.06),
    [3] = Vector3.new(-1451.07, -71.71, -561.84),
    [4] = Vector3.new(-1453.34, -69.39, -505.46),
    [5] = Vector3.new(-1453.84, -69.89, -450.48),
    [6] = Vector3.new(-1453.93, -60.17, -401.57),
    [7] = Vector3.new(-1453.81, -47.67, -383.90),
    [8] = Vector3.new(-1453.83, -56.89, -314.42),
    [9] = Vector3.new(-1456.05, -42.28, -234.74),
    [10] = Vector3.new(-1455.25, -56.89, -196.98),
    [11] = Vector3.new(-1455.74, -45.90, -151.51),
    [12] = Vector3.new(-1455.04, -56.89, -68.01),
    [13] = Vector3.new(-1454.91, -57.15, 2.74),
    [14] = Vector3.new(-1453.82, -52.74, 84.38),
    [15] = Vector3.new(-1453.82, 84.71, 84.38),
    [16] = Vector3.new(-1455.80, 90.11, 91.35),
    [17] = Vector3.new(-1476.01, 90.10, 95.73),
    [18] = Vector3.new(-1476.01, 211.19, 95.73),
    [19] = Vector3.new(-1459.42, 215.12, 129.82),
    [20] = Vector3.new(-1454.53, 221.76, 172.62),
    [21] = Vector3.new(-1453.85, 237.18, 206.90),
    [22] = Vector3.new(-1453.21, 218.99, 246.55),
    [23] = Vector3.new(-1453.09, 215.11, 306.34),
    [24] = Vector3.new(-1453.89, 214.86, 439.71),
    [25] = Vector3.new(-1455.21, 227.02, 481.31),
    [26] = Vector3.new(-1453.88, 214.07, 533.55),
    [27] = Vector3.new(-1453.69, 214.85, 627.58),
    [28] = Vector3.new(-1453.69, 368.06, 627.58),
    [29] = Vector3.new(-1452.07, 360.87, 595.15),
    [30] = Vector3.new(-1451.46, 368.40, 554.05),
    [31] = Vector3.new(-1453.71, 360.07, 500.98),
    [32] = Vector3.new(-1350.45, 359.87, 493.92),
    [33] = Vector3.new(-1250.35, 333.91, 493.64),
    [34] = Vector3.new(-1242.45, 312.90, 558.02),
    [35] = Vector3.new(-1237.85, 323.30, 599.81),
    [36] = Vector3.new(-1233.80, 328.71, 636.50),
    [37] = Vector3.new(-1243.81, 328.70, 677.73),
    [38] = Vector3.new(-1224.62, 330.95, 718.13),
    [39] = Vector3.new(-1218.35, 345.88, 834.12),
    [40] = Vector3.new(-1255.74, 349.66, 837.62),
    [41] = Vector3.new(-1364.23, 363.88, 841.41),
    [42] = Vector3.new(-1400.33, 359.00, 845.27),
    [43] = Vector3.new(-1404.48, 373.86, 724.70),
    [44] = Vector3.new(-1404.48, 544.43, 724.70),
    [45] = Vector3.new(-1405.09, 532.88, 759.29),
    [46] = Vector3.new(-1433.27, 534.75, 759.82)
}

local currentTween = nil
local wasEnabled = false
local forceStartFromFirst = false

-- Функция поиска индекса ближайшей точки
local function getClosestPointIndex(playerPos)
    local closestIndex = 1
    local minDistance = math.huge
    for i, point in ipairs(points) do
        local dist = (playerPos - point).Magnitude
        if dist < minDistance then
            minDistance = dist
            closestIndex = i
        end
    end
    return closestIndex
end

-- Основной цикл проверки
task.spawn(function()
    while true do
        task.wait(0.1)
        
        if _G.StartFarm3 then
            local character = LocalPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                local startIndex = 1
                
                -- Логика определения стартовой точки
                if not wasEnabled then
                    -- Если только что включили скрипт — ищем ближайшую
                    startIndex = getClosestPointIndex(hrp.Position)
                    wasEnabled = true
                elseif forceStartFromFirst then
                    -- Если это повторный круг — начинаем строго с 1-й
                    startIndex = 1
                    forceStartFromFirst = false
                else
                    -- Если путь прервался внутри цикла по другой причине, продолжаем
                    startIndex = getClosestPointIndex(hrp.Position)
                end
                
                -- Расчет общего расстояния оставшегося пути (для соблюдения тайминга в 25 сек)
                local totalDistance = 0
                local segments = {}
                
                -- 1. Расстояние от игрока до его первой целевой точки
                table.insert(segments, {from = hrp.Position, to = points[startIndex]})
                totalDistance = totalDistance + (hrp.Position - points[startIndex]).Magnitude
                
                -- 2. Расстояние по остальным точкам маршрута
                for i = startIndex, #points - 1 do
                    table.insert(segments, {from = points[i], to = points[i+1]})
                    totalDistance = totalDistance + (points[i] - points[i+1]).Magnitude
                end
                
                -- Скорость, при которой весь этот путь займет ровно 25 секунд
                local targetTime = 25
                local calculatedSpeed = totalDistance / targetTime
                
                -- Движение по сегментам
                local completedPath = true
                for _, segment in ipairs(segments) do
                    if not _G.StartFarm3 then 
                        completedPath = false
                        break 
                    end
                    
                    -- Считаем время для конкретного отрезка на основе общей скорости
                    local distance = (hrp.Position - segment.to).Magnitude
                    local duration = distance / calculatedSpeed
                    
                    if duration > 0 then
                        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
                        currentTween = TweenService:Create(hrp, {CFrame = CFrame.new(segment.to)}, tweenInfo)
                        currentTween:Play()
                        currentTween.Completed:Wait()
                    end
                end
                
                -- Если успешно долетели до 46-й точки
                if completedPath and _G.StartFarm3 then
                    task.wait(1) -- Ждем 1 секунду перед некст кругом
                    forceStartFromFirst = true -- Флаг, что следующий круг начнется с [1]
                end
            end
        else
            -- Если выключили тумблер — сбрасываем состояние и стопаем твин
            if wasEnabled then
                wasEnabled = false
                forceStartFromFirst = false
                if currentTween then
                    currentTween:Cancel()
                    currentTween = nil
                end
            end
        end
    end
end)
