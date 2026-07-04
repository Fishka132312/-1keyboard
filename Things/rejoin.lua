local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    -- Игнорируем нажатие, если игрок сейчас пишет в чат или открыл меню
    if gameProcessed then return end
    
    -- Проверяем, нажата ли клавиша Y
    if input.KeyCode == Enum.KeyCode.Y then
        local character = LocalPlayer.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local pos = humanoidRootPart.Position
                
                -- Выводим координаты в консоль. string.format округляет до двух знаков после запятой
                print(string.format("Текущие координаты: Vector3.new(%.2f, %.2f, %.2f)", pos.X, pos.Y, pos.Z))
            else
                warn("HumanoidRootPart не найден!")
            end
        end
    end
end)
