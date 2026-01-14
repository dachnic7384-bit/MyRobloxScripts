-- Bee Swarm Simulator PRO Auto-Farm v3.0
-- Автор: dachnic7384-bit
-- GitHub: https://github.com/dachnic7384-bit/MyRobloxScripts

if not game:IsLoaded() then
    game.Loaded:Wait()
end

print("=========================================")
print("🐝 BEE SWARM PRO AUTO-FARM v3.0")
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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local BeeSwarm = {}

-- =========== АВТО-ФАРМ НА ПОЛЕ ===========
BeeSwarm.CurrentField = "Sunflower"
BeeSwarm.AutoFarmRunning = false
BeeSwarm.AutoQuestRunning = false
BeeSwarm.FarmConnection = nil

-- Координаты центров полей
BeeSwarm.Fields = {
    ["Sunflower"] = {
        Center = Vector3.new(-44, 4, -264),
        Radius = 60,
        Flowers = {"Sunflower"}
    },
    ["Mushroom"] = {
        Center = Vector3.new(108, 5, -197),
        Radius = 60,
        Flowers = {"Mushroom"}
    },
    ["Blue Flower"] = {
        Center = Vector3.new(-129, 5, 83),
        Radius = 60,
        Flowers = {"Blue Flower"}
    },
    ["Clover"] = {
        Center = Vector3.new(213, 4, 108),
        Radius = 70,
        Flowers = {"Clover"}
    },
    ["Spider"] = {
        Center = Vector3.new(211, 6, -129),
        Radius = 70,
        Flowers = {"Spider"}
    },
    ["Bamboo"] = {
        Center = Vector3.new(-354, 29, -178),
        Radius = 80,
        Flowers = {"Bamboo"}
    },
    ["Pineapple"] = {
        Center = Vector3.new(-357, 28, 195),
        Radius = 80,
        Flowers = {"Pineapple"}
    },
    ["Strawberry"] = {
        Center = Vector3.new(391, 29, 127),
        Radius = 80,
        Flowers = {"Strawberry"}
    },
    ["Cactus"] = {
        Center = Vector3.new(406, 29, -249),
        Radius = 80,
        Flowers = {"Cactus"}
    },
    ["Pumpkin"] = {
        Center = Vector3.new(-7, 4, 8),
        Radius = 40,
        Flowers = {"Pumpkin"}
    }
}

-- Функция для поиска ближайшего цветка
function BeeSwarm:FindNearestFlower(fieldName)
    if not Workspace:FindFirstChild("Flowers") then return nil end
    
    local field = BeeSwarm.Fields[fieldName]
    if not field then return nil end
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local playerPos = character.HumanoidRootPart.Position
    local closestFlower = nil
    local closestDistance = math.huge
    
    for _, flower in pairs(Workspace.Flowers:GetChildren()) do
        if flower:FindFirstChild("Click") and flower:FindFirstChild("Flower") then
            -- Проверяем тип цветка
            local flowerType = flower.Name
            local isCorrectType = false
            
            for _, allowedType in pairs(field.Flowers) do
                if string.find(flowerType, allowedType) then
                    isCorrectType = true
                    break
                end
            end
            
            if isCorrectType then
                local flowerPos = flower.Flower.Position
                local distanceToField = (flowerPos - field.Center).Magnitude
                local distanceToPlayer = (flowerPos - playerPos).Magnitude
                
                -- Цветок должен быть в радиусе поля и не дальше 50 studs от игрока
                if distanceToField <= field.Radius and distanceToPlayer < 50 and distanceToPlayer < closestDistance then
                    closestFlower = flower
                    closestDistance = distanceToPlayer
                end
            end
        end
    end
    
    return closestFlower
end

-- Основная функция авто-фарма
function BeeSwarm:StartSmartAutoFarm()
    if BeeSwarm.AutoFarmRunning then return end
    
    BeeSwarm.AutoFarmRunning = true
    print("🌻 Умный авто-фарм запущен на поле: " .. BeeSwarm.CurrentField)
    
    BeeSwarm.FarmConnection = RunService.Heartbeat:Connect(function()
        if not BeeSwarm.AutoFarmRunning then return end
        
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        
        -- 1. Ищем ближайший цветок
        local flower = BeeSwarm:FindNearestFlower(BeeSwarm.CurrentField)
        
        if flower then
            local flowerPos = flower.Flower.Position
            local playerPos = character.HumanoidRootPart.Position
            local distance = (flowerPos - playerPos).Magnitude
            
            -- 2. Если далеко - идем к цветку
            if distance > 15 then
                character:MoveTo(flowerPos)
            else
                -- 3. Если близко - собираем
                fireclickdetector(flower.Click)
            end
        else
            -- 4. Если нет цветков - ходим по кругу на поле
            local field = BeeSwarm.Fields[BeeSwarm.CurrentField]
            if field then
                local angle = tick() * 2
                local radius = field.Radius * 0.7
                local targetPos = field.Center + Vector3.new(
                    math.cos(angle) * radius,
                    0,
                    math.sin(angle) * radius
                )
                character:MoveTo(targetPos)
            end
        end
    end)
end

function BeeSwarm:StopSmartAutoFarm()
    if BeeSwarm.FarmConnection then
        BeeSwarm.FarmConnection:Disconnect()
        BeeSwarm.FarmConnection = nil
    end
    BeeSwarm.AutoFarmRunning = false
    print("🌻 Умный авто-фарм остановлен")
end

-- =========== АВТО-КВЕСТЫ ===========
function BeeSwarm:StartAutoQuests()
    if BeeSwarm.AutoQuestRunning then return end
    
    BeeSwarm.AutoQuestRunning = true
    print("📜 Авто-квесты запущены")
    
    spawn(function()
        while BeeSwarm.AutoQuestRunning do
            task.wait(10) -- Проверяем квесты каждые 10 секунд
            
            -- Автоматически берем новые квесты
            pcall(function()
                -- Проверяем NPC для квестов
                local npcs = {"Black Bear", "Brown Bear", "Polar Bear", "Science Bear"}
                
                for _, npcName in pairs(npcs) do
                    local npc = Workspace:FindFirstChild(npcName)
                    if npc and npc:FindFirstChild("Click") then
                        -- Подходим к NPC
                        if LocalPlayer.Character then
                            LocalPlayer.Character:MoveTo(npc.PrimaryPart.Position)
                            task.wait(1)
                            
                            -- Берем квест
                            fireclickdetector(npc.Click)
                            task.wait(0.5)
                            
                            -- Выходим из диалога
                            ReplicatedStorage.Events.ConversationEnded:FireServer()
                        end
                    end
                end
            end)
        end
    end)
end

function BeeSwarm:StopAutoQuests()
    BeeSwarm.AutoQuestRunning = false
    print("📜 Авто-квесты остановлены")
end

-- =========== АВТО-КОНВЕРТАЦИЯ ===========
function BeeSwarm:StartAutoConvert()
    print("🍯 Авто-конвертация запущена")
    
    spawn(function()
        while true do
            task.wait(8) -- Каждые 8 секунд
            
            if not BeeSwarm.AutoFarmRunning then break end
            
            pcall(function()
                -- Простая конвертация без открытия GUI
                ReplicatedStorage.Events.ConvertPollenToHoney:FireServer()
            end)
        end
    end)
end

-- =========== ТЕЛЕПОРТ НА ПОЛЕ ===========
function BeeSwarm:SetField(fieldName)
    if BeeSwarm.Fields[fieldName] then
        BeeSwarm.CurrentField = fieldName
        
        if BeeSwarm.AutoFarmRunning then
            -- Если авто-фарм запущен - телепортируем на поле
            local field = BeeSwarm.Fields[fieldName]
            if LocalPlayer.Character then
                LocalPlayer.Character:MoveTo(field.Center)
            end
        end
        
        return "✅ Установлено поле: " .. fieldName
    end
    return "❌ Поле не найдено"
end

-- =========== ВИЗУАЛЬНЫЕ ЭФФЕКТЫ ===========
function BeeSwarm:CreateVisuals()
    -- Подсветка активного поля
    local field = BeeSwarm.Fields[BeeSwarm.CurrentField]
    if field then
        local highlight = Instance.new("Part")
        highlight.Name = "FieldVisual"
        highlight.Size = Vector3.new(field.Radius * 2, 1, field.Radius * 2)
        highlight.Position = field.Center + Vector3.new(0, 1, 0)
        highlight.Transparency = 0.7
        highlight.Color = Color3.fromRGB(255, 255, 0)
        highlight.Anchored = true
        highlight.CanCollide = false
        highlight.Parent = Workspace
        
        -- Окружность из частиц
        local particles = Instance.new("ParticleEmitter")
        particles.Parent = highlight
        particles.Rate = 50
        particles.Speed = NumberRange.new(5)
        particles.Lifetime = NumberRange.new(2)
        particles.Size = NumberSequence.new(0.5)
        particles.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0))
    end
end

function BeeSwarm:RemoveVisuals()
    local visual = Workspace:FindFirstChild("FieldVisual")
    if visual then
        visual:Destroy()
    end
end

-- =========== ОПТИМИЗАЦИЯ (без белого экрана) ===========
function BeeSwarm:OptimizeGame(enabled)
    if enabled then
        print("⚡ Оптимизация ВКЛ (без белого экрана)")
        
        -- Убираем только эффекты, не рендеринг
        local Lighting = game:GetService("Lighting")
        
        -- Сохраняем оригинальные настройки
        BeeSwarm.OriginalSettings = {
            FogEnd = Lighting.FogEnd,
            Brightness = Lighting.Brightness,
            GlobalShadows = Lighting.GlobalShadows
        }
        
        -- Оптимизируем
        Lighting.FogEnd = 100000
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
        
        -- Убираем частицы
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") then
                obj.Enabled = false
            end
        end
    else
        print("⚡ Оптимизация ВЫКЛ")
        
        -- Восстанавливаем настройки
        if BeeSwarm.OriginalSettings then
            local Lighting = game:GetService("Lighting")
            Lighting.FogEnd = BeeSwarm.OriginalSettings.FogEnd
            Lighting.Brightness = BeeSwarm.OriginalSettings.Brightness
            Lighting.GlobalShadows = BeeSwarm.OriginalSettings.GlobalShadows
        end
        
        -- Включаем частицы обратно
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") then
                obj.Enabled = true
            end
        end
    end
end

-- =========== СТАТИСТИКА ===========
function BeeSwarm:GetStats()
    pcall(function()
        local stats = LocalPlayer:WaitForChild("Stats", 5)
        if stats then
            print("=== СТАТИСТИКА ===")
            print("🍯 Мёд: " .. tostring(stats.Honey.Value))
            print("🌻 Пыльца: " .. tostring(stats.Pollen.Value))
            print("🎯 Токены: " .. tostring(stats.Tokens.Value))
            
            local hive = Workspace:FindFirstChild(LocalPlayer.Name .. "'s Hive")
            if hive then
                print("🐝 Пчёлы: " .. tostring(#hive.Bees:GetChildren()))
            end
            
            print("📍 Поле: " .. BeeSwarm.CurrentField)
            print("================")
        end
    end)
end

-- =========== ИНИЦИАЛИЗАЦИЯ ===========
function BeeSwarm:Notify()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🐝 Bee Swarm PRO v3.0",
        Text = "Умный авто-фарм загружен!\nF1 - вкл/выкл авто-фарм",
        Duration = 6,
        Icon = "rbxassetid://4439880892"
    })
end

BeeSwarm:Notify()
BeeSwarm:CreateVisuals()

return BeeSwarm
