local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Список твоих координат
local points = {
    Vector3.new(-1454.61, -160.52, -854.80),
    Vector3.new(-1454.77, -69.39, -502.36),
    Vector3.new(-1453.18, -50.35, -371.23),
    Vector3.new(-1453.37, -56.89, -308.34),
    Vector3.new(-1454.89, -56.89, -197.12),
    Vector3.new(-1455.73, -57.14, 3.64),
    Vector3.new(-1454.53, -51.91, 84.43),
    Vector3.new(-1454.53, 87.34, 84.43),
    Vector3.new(-1476.05, 90.10, 95.25),
    Vector3.new(-1475.94, 215.11, 99.84),
    Vector3.new(-1454.28, 230.53, 206.06),
    Vector3.new(-1455.06, 214.87, 350.08),
    Vector3.new(-1455.92, 226.32, 494.15),
    Vector3.new(-1454.69, 214.86, 627.57),
    Vector3.new(-1454.57, 368.66, 627.43),
    Vector3.new(-1453.54, 360.87, 593.58),
    Vector3.new(-1451.47, 372.13, 548.90),
    Vector3.new(-1451.95, 360.07, 495.32),
    Vector3.new(-1358.46, 359.18, 493.93),
    Vector3.new(-1246.38, 334.38, 494.19),
    Vector3.new(-1240.66, 317.24, 575.42),
    Vector3.new(-1234.16, 328.70, 663.95),
    Vector3.new(-1218.73, 345.63, 832.74),
    Vector3.new(-1365.63, 364.03, 846.72),
    Vector3.new(-1399.19, 358.71, 847.24),
    Vector3.new(-1403.27, 373.90, 724.37),
    Vector3.new(-1403.27, 550.26, 724.37),
    Vector3.new(-1403.83, 532.88, 757.98),
    Vector3.new(-1433.45, 534.73, 758.77)
}

-- Функция для поиска индекса ближайшей точки к игроку
local function getClosestPointIndex(pos)
    local closestIndex = 1
    local minDistance = math.huge
    for i, point in ipairs(points) do
        local dist = (pos - point).Magnitude
        if dist < minDistance then
            minDistance = dist
            closestIndex = i
        end
    end
    return closestIndex
end

-- Функция для расчета общей длины пути от старого индекса до конца
local function getRemainingPathLength(startIndex, startPos)
    local length = 0
    local currentPos = startPos
    for i = startIndex, #points do
        length = length + (points[i] - currentPos).Magnitude
        currentPos = points[i]
    end
    return length
end

-- Основной цикл фермы
task.spawn(function()
    while true do
        task.wait(0.1)
        
        if _G.StartFarm3 then
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local root = character:WaitForChild("HumanoidRootPart")
            
            -- Определяем, откуда начинать движение при включении скрипта
            local startPos = root.Position
            local startIndex = getClosestPointIndex(startPos)
            
            -- Рассчитываем общую дистанцию оставшегося пути, чтобы лететь с равномерной скоростью за 20 сек
            local totalLength = getRemainingPathLength(startIndex, startPos)
            if totalLength == 0 then totalLength = 1 end -- Защита от деления на 0
            
            local speed = totalLength / 30 -- Скорость (студов в секунду)
            
            -- Перебираем точки начиная с ближайшей
            for i = startIndex, #points do
                if not _G.StartFarm3 then break end -- Экстренный выход, если выключили флаг
                
                local targetPos = points[i]
                local distance = (root.Position - targetPos).Magnitude
                local duration = distance / speed
                
                -- Анкорим RootPart, чтобы не было дерготни и проваливаний
                root.Anchored = true
                
                local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(targetPos)})
                
                tween:Play()
                tween.Completed:Wait()
            end
            
            -- Разанкориваем после завершения пути или выключения
            if root then root.Anchored = false end
            
            -- Если круг завершен и ферма всё еще включена — ждем 1 сек и сбрасываемся на 1-ю точку
            if _G.StartFarm3 then
                task.wait(1)
                -- В следующем цикле startIndex автоматически сбросится, так как мы будем считать от текущей (последней) позиции, 
                -- но чтобы принудительно начать с 1-й точки, мы можем просто позволить коду найти ближайшую (а это будет 29-я или 1-я). 
                -- Для железного сброса на 1-ю точку, мы телепортируем игрока поближе к 1-й точке.
                if root and _G.StartFarm3 then
                    root.CFrame = CFrame.new(points[1])
                end
            end
        end
    end
end)
