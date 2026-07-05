-- Сервисы Roblox
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

-- Защита от наложения (генерация уникального ID для этого запуска)
local scriptSessionId = HttpService and HttpService:GenerateGUID(false) or tostring(math.random(1, 100000))
_G.CurrentFarmSession = scriptSessionId

-- Переменная старта фарма (ПО УМОЛЧАНИЮ ВЫКЛЮЧЕНА)
_G.StartFarm3 = false

-- Таблица твоих координат пути
local points = {
    [1] = Vector3.new(-1429.73, -156.87, -832.64),
    [2] = Vector3.new(-1432.11, -91.55, -624.94),
    [3] = Vector3.new(-1426.61, -69.39, -536.87),
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
    [46] = Vector3.new(-1398.80, 532.87, 851.10),
    [47] = Vector3.new(-1168.67, 532.88, 805.23),
    [48] = Vector3.new(-1168.87, 532.87, 1278.25),
    [49] = Vector3.new(-1407.38, 532.87, 1251.53),
    [50] = Vector3.new(-1407.11, 532.88, 1332.87),
    [51] = Vector3.new(-1404.96, 532.87, 1401.65),
    [52] = Vector3.new(-1405.52, 540.87, 1490.85),
    [53] = Vector3.new(-1404.15, 442.87, 1475.77),
    [54] = Vector3.new(-1403.44, 414.14, 1480.85),
    [55] = Vector3.new(-1900.88, 423.17, 1471.63),
    [56] = Vector3.new(-1908.89, 442.87, 1491.20),
    [57] = Vector3.new(-1900.88, 423.17, 1471.63),
    [58] = Vector3.new(-2061.79, 427.09, 1481.41),
    [59] = Vector3.new(-2061.79, 442.87, 1487.17)
}

-- НАСТРОЙКА ДИНАМИЧЕСКИХ ЧЕКПОИНТОВ (Теперь это массив, UI считает всё автоматически)
local checkpointsConfig = {
    {
        pointIndex = 4,
        flag = "Stage1",
        waitTime = 2.0,
        checkpointPos = Vector3.new(-1481.60, -66.77, -517.38),
        description = "Stage 1 300M"
    },
    {
        pointIndex = 12,
        flag = "Stage2",
        waitTime = 5.0,
        checkpointPos = Vector3.new(-1479.76, -55.32, -17.36),
        description = "Stage 2 500M"
    },
    {
        pointIndex = 23,
        flag = "Stage3",
        waitTime = 10.0,
        checkpointPos = Vector3.new(-1476.55, 216.75, 329.53),
        description = "Stage 3 800M"
    },
    {
        pointIndex = 45,
        flag = "Stage4",
        waitTime = 20.0,
        checkpointPos = Vector3.new(-1430.01, 534.74, 760.78),
        description = "Stage 4 1.25B"
    },
    {
        pointIndex = 50,
        flag = "Stage5",
        waitTime = 30.0,
        checkpointPos = Vector3.new(-1432.41, 534.68, 1331.77),
        description = "Stage 5 2B"
    },
    {
        pointIndex = 59,
        flag = "Stage6",
        waitTime = 40.0,
        checkpointPos = Vector3.new(-2016.78, 444.72, 1462.82),
        description = "Stage 6 3.5B"
    }
}

-- Глобальная таблица с описаниями стейджей для UI скрипта
_G.StageDescriptions = {}
for _, config in ipairs(checkpointsConfig) do
    table.insert(_G.StageDescriptions, config.description)
end

-- Глобальная функция для переключения стейджей по их описанию
_G.SwitchToStage = function(targetDescription)
    for _, config in ipairs(checkpointsConfig) do
        -- Будет true только у того флага, чье описание совпало
        _G[config.flag] = (config.description == targetDescription)
    end
end

-- Инициализация: по умолчанию включаем первый стейдж из списка
if checkpointsConfig[1] then
    _G.SwitchToStage(checkpointsConfig[1].description)
end


-- Поиск ближайшей точки
local function getClosestIndex(hrp)
    local closestIndex = 1
    local minDistance = math.huge
    local playerPos = hrp.Position

    for i, point in ipairs(points) do
        local dist = (playerPos - point).Magnitude
        if dist < minDistance then
            minDistance = dist
            closestIndex = i
        end
    end
    return closestIndex
end

-- Расчет общей дистанции оставшегося пути
local function getRemainingDistance(startIndex)
    local totalDist = 0
    for i = startIndex, #points - 1 do
        totalDist = totalDist + (points[i] - points[i+1]).Magnitude
    end
    return totalDist
end

-- Функция принудительного триггера тач-партов
local function touchNearbyParts(hrp)
    if not firetouchpart then return end 
    
    local parts = workspace:GetPartBoundsInRadius(hrp.Position, 10)
    for _, part in ipairs(parts) do
        if part:FindFirstChildOfClass("TouchTransmitter") or part.Name:lower():find("checkpoint") or part.Name:lower():find("finish") then
            firetouchpart(hrp, part, 0)
            task.wait(0.01)
            firetouchpart(hrp, part, 1)
        end
    end
end

-- Вспомогательная функция для плавного твина к конкретной точке
local function tweenToPosition(hrp, targetPos, totalDistance, currentSessionId, humanoid)
    if not _G.StartFarm3 or _G.CurrentFarmSession ~= currentSessionId or humanoid.Health <= 0 then return false end

    local currentPos = hrp.Position
    local distance = (targetPos - currentPos).Magnitude
    local segmentTime = (distance / totalDistance) * 30
    if segmentTime <= 0 then segmentTime = 0.02 end

    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

    local targetCFrame = CFrame.new(targetPos - Vector3.new(0, 1.5, 0))
    local tweenInfo = TweenInfo.new(segmentTime, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    
    tween:Play()
    
    local touchLoop = true
    task.spawn(function()
        while tween.PlaybackState == Enum.PlaybackState.Playing and _G.StartFarm3 and _G.CurrentFarmSession == currentSessionId and humanoid.Health > 0 and touchLoop do
            touchNearbyParts(hrp)
            task.wait(0.1)
        end
    end)

    while tween.PlaybackState == Enum.PlaybackState.Playing do
        if not _G.StartFarm3 or _G.CurrentFarmSession ~= currentSessionId or humanoid.Health <= 0 then
            tween:Cancel()
            touchLoop = false
            return false
        end
        task.wait(0.05)
    end
    touchLoop = false
    return true
end

-- Основной цикл фарма
task.spawn(function()
    local bv 

    while true do
        task.wait(0.1)

        -- Проверка сессии
        if _G.CurrentFarmSession ~= scriptSessionId then 
            if bv then bv:Destroy() end
            break 
        end

        if _G.StartFarm3 then
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid", 5)
            local hrp = character:WaitForChild("HumanoidRootPart", 5)

            if hrp and humanoid and humanoid.Health > 0 then
                if not bv or bv.Parent ~= hrp then
                    bv = Instance.new("BodyVelocity")
                    bv.Velocity = Vector3.new(0, 0, 0)
                    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    bv.Parent = hrp
                end

                local startIndex = getClosestIndex(hrp)
                local totalDistance = getRemainingDistance(startIndex)
                if totalDistance == 0 then totalDistance = 1 end

                -- Бежим по точкам пути
                for i = startIndex, #points do
                    if not _G.StartFarm3 or _G.CurrentFarmSession ~= scriptSessionId or humanoid.Health <= 0 then break end

                    -- Твиним к текущей точке маршрута
                    local success = tweenToPosition(hrp, points[i], totalDistance, scriptSessionId, humanoid)
                    if not success then break end

                    -- Адаптивный поиск настроек чекпоинта для текущей точки маршрута
                    local config = nil
                    for _, cfg in ipairs(checkpointsConfig) do
                        if cfg.pointIndex == i then
                            config = cfg
                            break
                        end
                    end

                    -- Если чекпоинт для этой точки настроен и его флаг активен
                    if config and _G[config.flag] == true then
                        -- Останавливаем инерцию
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        
                        -- Умное ожидание времени, указанного в конфиге
                        local waited = 0
                        while waited < config.waitTime do
                            if not _G.StartFarm3 or _G.CurrentFarmSession ~= scriptSessionId or humanoid.Health <= 0 or not _G[config.flag] then 
                                break 
                            end
                            task.wait(0.1)
                            waited = waited + 0.1
                        end

                        -- Если условия всё ещё соблюдены — летим на сам чекпоинт
                        if _G.StartFarm3 and _G.CurrentFarmSession == scriptSessionId and humanoid.Health > 0 and _G[config.flag] then
                            -- Летим напрямую на координаты чекпоинта
                            tweenToPosition(hrp, config.checkpointPos, totalDistance, scriptSessionId, humanoid)
                            
                            -- Прерываем дальнейший полет по общей таблице (завершаем этот круг)
                            break
                        end
                    end
                end

                if bv then bv:Destroy() bv = nil end

                if humanoid.Health <= 0 then
                    task.wait(2)
                else
                    task.wait(1) 
                end
            else
                task.wait(1)
            end
        else
            if bv then bv:Destroy() bv = nil end
        end
    end
end)
