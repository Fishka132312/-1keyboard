local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService") -- Используем для плавности, если нужно, но тут напрямую через CFrame
local LocalPlayer = Players.LocalPlayer

-- Создание GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoinFarmGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0.5, -100, 0.1, 0) -- Сверху по центру экрана
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 18
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Text = "Farm Coins: OFF"
toggleButton.BorderSizePixel = 0
toggleButton.Parent = screenGui

-- Скругление углов для красоты
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = toggleButton

-- Настройки
local COIN_FOLDER = workspace:WaitForChild("CoinBattleCoins")
local isFarming = false
local delayBetweenTp = 0.1 -- Задержка между телепортами (в секундах), чтобы античит не сразу кикнул

-- Функция для рекурсивного поиска всех деталей (монеток) в папке
local function getAllCoins(folder)
	local coins = {}
	for _, obj in ipairs(folder:GetDescendants()) do
		-- Проверяем, является ли объект партом (или MeshPart) и содержит ли в названии "Coin" (или просто берём все BasePart)
		if obj:IsA("BasePart") then
			table.insert(coins, obj)
		end
	end
	return coins
end

-- Логика телепорта
local function startFarming()
	while isFarming do
		local character = LocalPlayer.Character
		local rootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		
		if rootPart and humanoid and humanoid.Health > 0 then
			local coins = getAllCoins(COIN_FOLDER)
			
			if #coins == 0 then
				task.wait(0.5) -- Если монеток пока нет, ждем полсекунды
			else
				for _, coin in ipairs(coins) do
					if not isFarming then break end
					-- Проверяем существование монетки перед ТП
					if coin and coin.Parent then 
						-- Телепортируем игрока на позицию монетки
						rootPart.CFrame = coin.CFrame
						task.wait(delayBetweenTp) -- Пауза для подбора
					end
				end
			end
		else
			task.wait(1) -- Ждем возрождения, если персонаж погиб
		end
		task.wait()
	end
end

-- Клик по кнопке
toggleButton.MouseButton1Click:Connect(function()
	isFarming = not isFarming
	
	if isFarming then
		toggleButton.Text = "Farm Coins: ON"
		toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 100) -- Зеленый при включении
		task.spawn(startFarming)
	else
		toggleButton.Text = "Farm Coins: OFF"
		toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Серый при выключении
	end
end)
