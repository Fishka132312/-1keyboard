local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "+1Keyboard", HidePremium = false, SaveConfig = true, ConfigFolder = "+1Keyboard"})

local scripts = {
    'World3Farm.lua',
}

local baseUrl = 'https://raw.githubusercontent.com/Fishka132312/-1keyboard/refs/heads/main/Things/'

task.spawn(function()
    for i, scriptName in ipairs(scripts) do
        local fullUrl = baseUrl .. scriptName
        
        local success, err = pcall(function()
            local code = game:HttpGet(fullUrl)
            if code then
                loadstring(code)()
            else
                warn("Не удалось получить код для: " .. scriptName)
            end
        end)
        
        if not success then
            warn("Ошибка при загрузке " .. scriptName .. ": " .. tostring(err))
        end
        
        task.wait(0.7) 
    end
end)

-------------------------Auto Farm---------------------------

local Tab = Window:MakeTab({
	Name = "Auto Farm",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddDropdown({
    Name = "Select Stage (Фарм до Чекпоинта)",
    Default = "1",
    Options = {"1", "2", "3", "4", "5", "6"},
    Callback = function(Value)
        -- Вызываем глобальную функцию переключения стейджа
        if _G.SwitchToStage then
            _G.SwitchToStage(Value)
            print("Активный стейдж изменен на: Stage" .. Value)
        else
            warn("Основной скрипт фарма еще не запущен!")
        end
    end    
})

Tab:AddToggle({
	Name = "World 3",
	Default = false,
	Callback = function(Value)
		_G.StartFarm3 = Value
	end    
})

Tab:AddButton({
	Name = "da",
	Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Fluxyyy333/HoshiOnTop/main/loader.lua"))()
  	end    
})

---------------------Test-----------------------
local Tab = Window:MakeTab({
	Name = "Test",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "Pos",
	Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/-1keyboard/refs/heads/main/Things/copyposition.lua'))()  
  	end    
})

Tab:AddButton({
	Name = "Rejoin",
	Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/-1keyboard/refs/heads/main/Things/rejoin.lua'))()  
  	end    
})

-------------------------Shader---------------------------

local Tab = Window:MakeTab({
	Name = "Shaders",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Section = Tab:AddSection({
	Name = "Shaders"
})

Tab:AddButton({
	Name = "Meowl Shaders",
	Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/coolgui/refs/heads/main/Things/Shaders/MeowlShaders.lua'))()  
  	end    
})

--------------------------------MISC-----------------------------

local Tab = Window:MakeTab({
	Name = "Misc",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Section = Tab:AddSection({
	Name = "Tools"
})

Tab:AddButton({
	Name = "Infinite Yield",
	Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Fishka132312/ignore-it/refs/heads/main/infiniteyield'))()
  	end    
})

Tab:AddButton({
	Name = "Destroy Gui",
	Callback = function()
    OrionLib:Destroy()
    end    
})

OrionLib:Init()
