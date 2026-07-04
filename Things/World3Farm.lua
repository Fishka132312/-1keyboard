-- Сервисы Roblox
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- Таблица твоих координат
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

-- Функция для поиска ближайшей точки к игроку
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

-- Функция для расчета общей дистанции от стартового индекса до конца
local function getRemainingDistance(startIndex)
    local totalDist = 0
    for i = startIndex, #points - 1 do
        totalDist = totalDist + (points[i] - points[i+1]).Magnitude
    end
    return totalDist
end

-- Основной поток фарма
task.spawn(function()
    local isFirstRun = true

    while true do
        task.wait(0.1) -- Легкая задержка, чтобы не вешать процессор

        if _G.StartFarm3 then
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart", 5)

            if hrp then
                -- Определяем с какой точки начать твин
                local startIndex = 1
                if isFirstRun then
                    startIndex = getClosestIndex(hrp)
                    isFirstRun = false
                end

                -- Считаем общую дистанцию маршрута, чтобы распределить 25 секунд равномерно
                local totalDistance = getRemainingDistance(startIndex)
                if totalDistance == 0 then totalDistance = 1 end -- Защита от деления на 0

                hrp.Anchored = true -- Якорим, чтобы не сбивалась физика

                -- Бежим по точкам
                for i = startIndex, #points do
                    if not _G.StartFarm3 then break end -- Экстренная остановка, если выключили

                    local targetPos = points[i]
                    local currentPos = hrp.Position
                    local distance = (targetPos - currentPos).Magnitude

                    -- Вычисляем время для конкретного отрезка пути (пропорционально его длине)
                    local segmentTime = (distance / totalDistance) * 25
                    if segmentTime <= 0 then segmentTime = 0.05 end -- Минимальное время на точку

                    local tweenInfo = TweenInfo.new(segmentTime, Enum.EasingStyle.Linear)
                    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})
                    
                    tween:Play()
                    tween.Completed:Wait() -- Ждем окончания полета к точке
                end

                hrp.Anchored = false -- Разъякориваем в конце или при выключении

                -- Если фарм все еще включен, ждем 1 секунду перед новым кругом
                if _G.StartFarm3 then
                    task.wait(1)
                end
            end
        else
            -- Если фарм выключен, сбрасываем триггер первого раунда
            isFirstRun = true
        end
    end
end)
