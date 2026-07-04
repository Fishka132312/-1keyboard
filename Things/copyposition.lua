local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
-- Таблица для хранения сохраненных координат
local savedPositions = {}

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	-- Игнорируем нажатия, если игрок печатает в чат или открыл меню
	if gameProcessedEvent then return end
	
	-- Проверяем, что у игрока есть персонаж и живой HumanoidRootPart
	local character = player.Character
	local rootPart = character and character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	-- Нажатие на клавишу 'Y' — сохранение координат
	if input.KeyCode == Enum.KeyCode.Y then
		local currentPosition = rootPart.Position
		table.insert(savedPositions, currentPosition)
		print(string.format("Точка сохранена: X: %.2f, Y: %.2f, Z: %.2f", currentPosition.X, currentPosition.Y, currentPosition.Z))
	
	-- Нажатие на клавишу 'T' — вывод всех сохраненных точек
	elseif input.KeyCode == Enum.KeyCode.T then
		if #savedPositions == 0 then
			print("Вы еще не сохранили ни одной точки.")
			return
		end
		
		print("--- Список всех сохраненных точек ---")
		for index, pos in ipairs(savedPositions) do
			print(string.format("[%d] X: %.2f, Y: %.2f, Z: %.2f", index, pos.X, pos.Y, pos.Z))
		end
		print("-----------------------------------")
	end
end)
