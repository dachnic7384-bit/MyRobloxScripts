-- Bee Swarm Simulator Safe Auto-Farm v2.0
-- Автор: dachnic7384-bit
-- GitHub: https://github.com/dachnic7384-bit/MyRobloxScripts

if not game:IsLoaded() then
    game.Loaded:Wait()
end

print("=========================================")
print("🐝 BEE SWARM SAFE AUTO-FARM")
print("📁 GitHub: github.com/dachnic7384-bit/MyRobloxScripts")
print("=========================================")

-- Проверка игры
if game.PlaceId ~= 1537690962 then
    warn("⚠️ Этот скрипт только для Bee Swarm Simulator!")
    return nil
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local BeeSwarm = {}

-- =========== БЕЗОПАСНЫЙ АВТО-ФАРМ ===========
BeeSwarm.AutoFarmRunning = false
BeeSwarm.AutoConvertRunning = false
BeeSwarm.AutoBoostRunning = false

-- Безопасный сбор цветов (через реальные клики)
function BeeSwarm:StartSafeAutoFarm()
    if BeeSwarm.AutoFarmRunning then return end
    
    BeeSwarm.AutoFarmRunning = true
    print("🌻 Безопасный авто-фарм запущен (макро-режим)")
    
    spawn(function()
        while BeeSwarm.AutoFarmRunning do
            -- Ждем между действиями
            task.wait(0.3)
            
            -- Ищем ближайший цветок
            local closestFlower = nil
            local closestDistance = math.huge
            
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local playerPos = LocalPlayer.Character.HumanoidRootPart.Position
                
                -- Ищем в Workspace.Flowers
                if Workspace:FindFirstChild("Flowers") then
                    for _, flower in pairs(Workspace.Flowers:GetChildren()) do
                        if flower:FindFirstChild("Click") and flower:FindFirstChild("Flower") then
                            local flowerPos = flower.Flower.Position
                            local distance = (playerPos - flowerPos).Magnitude
                            
                            if distance < 50 and distance < closestDistance then
                                closestFlower = flower
                                closestDistance = distance
                            end
                        end
                    end
                end
                
                -- Если нашли цветок - кликаем по нему
                if closestFlower then
                    -- Подходим ближе если нужно
                    if closestDistance > 10 then
                        LocalPlayer.Character:MoveTo(closestFlower.Flower.Position)
                        task.wait(0.5)
                    end
                    
                    -- Имитируем реальный клик мышкой
                    fireclickdetector(closestFlower.Click)
                    task.wait(0.1)
                else
                    -- Если нет цветков рядом - ходим кругами
                    local randomPos = Vector3.new(
                        math.random(-50, 50),
                        5,
                        math.random(-50, 50)
                    )
                    LocalPlayer.Character:MoveTo(randomPos)
                    task.wait(2)
                end
            end
        end
    end)
end

function BeeSwarm:StopSafeAutoFarm()
    BeeSwarm.AutoFarmRunning = false
    print("🌻 Безопасный авто-фарм остановлен")
end

-- =========== АВТО-КОНВЕРТАЦИЯ МЕДА ===========
function BeeSwarm:StartAutoConvert()
    if BeeSwarm.AutoConvertRunning then return end
    
    BeeSwarm.AutoConvertRunning = true
    print("🍯 Авто-конвертация запущена")
    
    spawn(function()
        while BeeSwarm.AutoConvertRunning do
            task.wait(5) -- Каждые 5 секунд
            
            -- Безопасная конвертация через GUI
            pcall(function()
                -- Открываем инвентарь
                game:GetService("ReplicatedStorage").Events.ToggleInventory:FireServer(true)
                task.wait(0.2)
                
                -- Конвертируем
                game:GetService("ReplicatedStorage").Events.ConvertPollenToHoney:FireServer()
                task.wait(0.2)
                
                -- Закрываем инвентарь
                game:GetService("ReplicatedStorage").Events.ToggleInventory:FireServer(false)
            end)
        end
    end)
end

function BeeSwarm:StopAutoConvert()
    BeeSwarm.AutoConvertRunning = false
    print("🍯 Авто-конвертация остановлена")
end

-- =========== АВТО-БУСТЫ ===========
function BeeSwarm:StartAutoBoost()
    if BeeSwarm.AutoBoostRunning then return end
    
    BeeSwarm.AutoBoostRunning = true
    print("⚡ Авто-бусты запущены")
    
    spawn(function()
        while BeeSwarm.AutoBoostRunning do
            task.wait(30) -- Каждые 30 секунд
            
            pcall(function()
                -- Используем бусты
                local boosts = {
                    "FieldBooster",
                    "PineapplePatchBooster", 
                    "StrawberryFieldBooster",
                    "BlueFlowerFieldBooster"
                }
                
                for _, boost in pairs(boosts) do
                    game:GetService("ReplicatedStorage").Events.PlayerActivatedBooster:FireServer(boost)
                    task.wait(0.5)
                end
            end)
        end
    end)
end

function BeeSwarm:StopAutoBoost()
    BeeSwarm.AutoBoostRunning = false
    print("⚡ Авто-бусты остановлены")
end

-- =========== ТЕЛЕПОРТЫ ===========
BeeSwarm.Fields = {
    ["Sunflower"] = Vector3.new(10, 5, -40),
    ["Mushroom"] = Vector3.new(60, 5, -20),
    ["Blue Flower"] = Vector3.new(30, 5, 40),
    ["Clover"] = Vector3.new(-20, 5, 60),
    ["Spider"] = Vector3.new(-60, 5, 20),
    ["Bamboo"] = Vector3.new(80, 5, -60),
    ["Pineapple"] = Vector3.new(-80, 5, -30),
    ["Strawberry"] = Vector3.new(40, 5, 80),
    ["Cactus"] = Vector3.new(-40, 5, -80),
    ["Pumpkin"] = Vector3.new(0, 5, 0)
}

function BeeSwarm:TeleportToField(fieldName)
    if BeeSwarm.Fields[fieldName] and LocalPlayer.Character then
        LocalPlayer.Character:MoveTo(BeeSwarm.Fields[fieldName])
        return "✅ Телепорт: " .. fieldName
    end
    return "❌ Поле не найдено"
end

-- =========== ЧИТЫ ===========
function BeeSwarm:SpeedHack(enabled)
    if enabled then
        print("⚡ Ускорение ВКЛ")
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 50
            LocalPlayer.Character.Humanoid.JumpPower = 100
        end
    else
        print("⚡ Ускорение ВЫКЛ")
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
            LocalPlayer.Character.Humanoid.JumpPower = 50
        end
    end
end

function BeeSwarm:NoClip(enabled)
    if enabled then
        print("👻 Ноклип ВКЛ")
        local noclipConnection
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        
        -- Сохраняем соединение для отключения
        BeeSwarm.NoClipConnection = noclipConnection
    else
        print("👻 Ноклип ВЫКЛ")
        if BeeSwarm.NoClipConnection then
            BeeSwarm.NoClipConnection:Disconnect()
        end
    end
end

-- =========== ИНФОРМАЦИЯ ===========
function BeeSwarm:GetStats()
    pcall(function()
        local stats = LocalPlayer:FindFirstChild("Stats")
        if stats then
            print("=== СТАТИСТИКА ===")
            print("🍯 Мёд: " .. tostring(stats.Honey.Value))
            print("🌻 Пыльца: " .. tostring(stats.Pollen.Value))
            print("🎯 Токены: " .. tostring(stats.Tokens.Value))
            print("🐝 Пчёлы: " .. tostring(#Workspace:FindFirstChild(LocalPlayer.Name .. "'s Hive").Bees:GetChildren()))
            print("================")
        end
    end)
end

-- =========== УВЕДОМЛЕНИЕ ===========
function BeeSwarm:Notify()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🐝 Bee Swarm Script v2.0",
        Text = "Безопасный авто-фарм загружен!",
        Duration = 5,
        Icon = "rbxassetid://4439880892"
    })
end

-- Запускаем уведомление
BeeSwarm:Notify()

return BeeSwarm
