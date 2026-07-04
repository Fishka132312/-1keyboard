local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Проверяем, что это не одиночная игра в Studio
if #Players:GetPlayers() <= 1 then
    -- Если на сервере только вы, можно использовать Teleport, но в Studio это выдаст ошибку
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
else
    -- Перезаход на конкретный сервер по его JobId
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end
