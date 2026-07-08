local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Создание GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoinFarmGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0.5, -100, 0.1, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 18
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Text = "Farm Coins: OFF"
toggleButton.BorderSizePixel = 0
toggleButton.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = toggleButton

-- Настройки
local COIN_FOLDER = workspace:WaitForChild("CoinBattleCoins")
local isFarming = false
local delayBetweenTp = 0.15 -- Чуть увеличил для надёжности подбора, можно снизить

-- Таблица для отслеживания уже посещенных монеток
local visitedCoins = {}

-- Получение всех уникальных монеток, на которых мы еще не были
local function getUnvisitedCoins(folder)
	local coins = {}
	for _, obj in ipairs(folder:GetDescendants()) do
		if obj:IsA("BasePart") then
			-- Проверяем, не прыгали ли мы уже на эту конкретную монетку
			if not visitedCoins[obj] then
				table.insert(coins, obj)
			end
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
			local coins = getUnvisitedCoins(COIN_FOLDER)
			
			if #coins == 0 then
				-- Если новых монеток нет, значит мы обошли вообще всё, что сейчас спавнилось.
				-- Очищаем историю, чтобы на несобранные (оставшиеся) монетки можно было прыгнуть заново.
				table.clear(visitedCoins)
				task.wait(0.3)
			else
				for _, coin in ipairs(coins) do
					if not isFarming then break end
					
					if coin and coin.Parent then 
						-- Добавляем монетку в список посещенных ДО телепорта, чтобы не спамить на неё
						visitedCoins[coin] = true
						
						rootPart.CFrame = coin.CFrame
						task.wait(delayBetweenTp)
					end
				end
			end
		else
			task.wait(1)
		end
		task.wait()
	end
end

-- Клик по кнопке
toggleButton.MouseButton1Click:Connect(function()
	isFarming = not isFarming
	
	if isFarming then
		toggleButton.Text = "Farm Coins: ON"
		toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
		task.spawn(startFarming)
	else
		toggleButton.Text = "Farm Coins: OFF"
		toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		table.clear(visitedCoins) -- Сбрасываем кэш при выключении
	end
end)
