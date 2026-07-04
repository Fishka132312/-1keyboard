-- Сервисы Robloxвфвф31231313eqweqe
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- Защита от наложения (генерация уникального ID для этого запуска)
local scriptSessionId = HttpService and game:GetService("HttpService"):GenerateGUID(false) or tostring(math.random(1, 100000))
_G.CurrentFarmSession = scriptSessionId

-- Таблица твоих координат
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
    [46] = Vector3.new(-1433.27, 534.75, 759.82)
}

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

-- Основной цикл фарма
task.spawn(function()
    local isFirstRun = true
    local bv 

    while true do
        task.wait(0.1)

        -- Проверка: если этот скрипт устарел (запущен новый), полностью выходим из цикла
        if _G.CurrentFarmSession ~= scriptSessionId then 
            if bv then bv:Destroy() end
            break 
        end

        if _G.StartFarm3 then
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart", 5)

            if hrp then
                if not bv or bv.Parent ~= hrp then
                    bv = Instance.new("BodyVelocity")
                    bv.Velocity = Vector3.new(0, 0, 0)
                    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    bv.Parent = hrp
                end

                local startIndex = 1
                if isFirstRun then
                    startIndex = getClosestIndex(hrp)
                    isFirstRun = false
                end

                local totalDistance = getRemainingDistance(startIndex)
                if totalDistance == 0 then totalDistance = 1 end

                -- Погнали по точкам
                for i = startIndex, #points do
                    -- Двойная проверка на выключение фарма или перезапуск скрипта
                    if not _G.StartFarm3 or _G.CurrentFarmSession ~= scriptSessionId then break end

                    -- Новая фича: Если доехали до предпоследней точки и собираемся лететь на последнюю
                    if i == #points then
                        -- Сбрасываем физическую скорость, чтобы не улететь по инерции во время ожидания
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        
                        -- Ждем 5 секунд на предпоследней точке перед финальным рывком
                        task.wait(15) 
                    end

                    -- Ещё раз чекаем условия после 5-секундного ожидания
                    if not _G.StartFarm3 or _G.CurrentFarmSession ~= scriptSessionId then break end

                    local targetPos = points[i]
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
                    
                    task.spawn(function()
                        while tween.PlaybackState == Enum.PlaybackState.Playing and _G.StartFarm3 and _G.CurrentFarmSession == scriptSessionId do
                            touchNearbyParts(hrp)
                            task.wait(0.1)
                        end
                    end)

                    tween.Completed:Wait()
                end

                if bv then bv:Destroy() bv = nil end

                if _G.StartFarm3 and _G.CurrentFarmSession == scriptSessionId then
                    task.wait(1) 
                end
            end
        else
            if bv then bv:Destroy() bv = nil end
            isFirstRun = true
        end
    end
end)
