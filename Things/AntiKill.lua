local Pièges = game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("Pi\195\168ges")

local targets = {
    Pièges:FindFirstChild("LavaTower"),
    Pièges:FindFirstChild("LocalNPC10_AI"),
    Pièges:FindFirstChild("LocalNPC12_AI"),
    Pièges:FindFirstChild("LocalNPC15_AI"),
    Pièges:FindFirstChild("LocalNPC15_World2_AI"),
    Pièges:FindFirstChild("LocalNPC9_AI"),
    Pièges:FindFirstChild("LocalNPC_MacaronMonster_AI"),
    Pièges:FindFirstChild("MovingWalls"),
    Pièges:WaitForChild("World2"):GetChildren()[12],
    Pièges:ByPath("World3.LocalNPC_LolMonster_AI") or (Pièges:FindFirstChild("World3") and Pièges.World3:FindFirstChild("LocalNPC_LolMonster_AI"))
}

for _, script in ipairs(targets) do
    if script then
        script:Destroy()
    end
end
