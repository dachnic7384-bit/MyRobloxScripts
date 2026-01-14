-- Bee Swarm Simple Auto-Farm
-- Автор: dachnic7384-bit

if not game:IsLoaded() then
    game.Loaded:Wait()
end

print("🐝 Bee Swarm Auto-Farm загружен")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Глобальные переменные
_G.AutoFarmRunning = false
_G.AutoFarmConnection = nil
_G.CurrentField = "Sunflower"

-- Поля
local Fields = {
    ["Sunflower"] = Vector3.new(-44, 4, -264),
    ["Mushroom"] = Vector3.new(108, 5, -197),
    ["Blue Flower"] = Vector3.new(-129, 5, 83),
    ["Clover"] = Vector3.new(213, 4, 108),
    ["Spider"] = Vector3.new(211, 6, -129)
}

-- Найти цветок
function FindFlower()
    local char = LocalPlayer.Character
    if not char or not char.PrimaryPart then return nil end
    
    local pos = char.PrimaryPart.Position
    local closest = nil
    local dist = 999
    
    if Workspace:FindFirstChild("Flowers") then
        for _, flower in pairs(Workspace.Flowers:GetChildren()) do
            if flower:FindFirstChild("Flower") then
                local flowerPos = flower.Flower.Position
                local d = (pos - flowerPos).Magnitude
                if d < 50 and d < dist then
                    closest = flower
                    dist = d
                end
            end
        end
    end
    
    return closest
end

-- Запустить авто-фарм
function StartAutoFarm()
    if _G.AutoFarmRunning then return end
    
    _G.AutoFarmRunning = true
    print("✅ Авто-фарм запущен")
    
    _G.AutoFarmConnection = RunService.Heartbeat:Connect(function()
        if not _G.AutoFarmRunning then return end
        
        local char = LocalPlayer.Character
        if not char or not char.PrimaryPart then return end
        
        -- Ищем цветок
        local flower = FindFlower()
        
        if flower then
            -- Идем к цветку
            char:MoveTo(flower.Flower.Position)
            
            -- Кликаем
            if flower:FindFirstChild("Click") then
                fireclickdetector(flower.Click)
            end
        else
            -- Ходим по полю
            local fieldPos = Fields[_G.CurrentField]
            if fieldPos then
                local angle = tick() * 0.3
                local radius = 30
                local walkPos = fieldPos + Vector3.new(
                    math.cos(angle) * radius,
                    0,
                    math.sin(angle) * radius
                )
                char:MoveTo(walkPos)
            end
        end
    end)
end

-- Остановить авто-фарм
function StopAutoFarm()
    if _G.AutoFarmConnection then
        _G.AutoFarmConnection:Disconnect()
        _G.AutoFarmConnection = nil
    end
    _G.AutoFarmRunning = false
    print("🛑 Авто-фарм остановлен")
end

-- Конвертировать в мёд
function ConvertToHoney()
    local events = game:GetService("ReplicatedStorage").Events
    pcall(function()
        events.ConvertPollenToHoney:FireServer()
        print("🍯 Конвертировано в мёд")
    end)
end

-- Телепорт на поле
function TeleportToField(fieldName)
    if Fields[fieldName] and LocalPlayer.Character then
        _G.CurrentField = fieldName
        LocalPlayer.Character:MoveTo(Fields[fieldName])
        print("📍 Телепорт на поле: " .. fieldName)
    end
end

-- Уведомление
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🐝 Bee Swarm",
    Text = "Скрипт загружен!",
    Duration = 3,
})
