-- Bee Swarm Auto-Farm v5.0 (Макрос версия)
-- Автор: dachnic7384-bit

if not game:IsLoaded() then
    game.Loaded:Wait()
end

print("=========================================")
print("🐝 BEE SWARM AUTO-FARM v5.0")
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
local RunService = game:GetService("RunService")

local AutoFarm = {}

-- =========== СОСТОЯНИЕ ===========
AutoFarm.Running = false
AutoFarm.CurrentField = "Sunflower"
AutoFarm.Connection = nil
AutoFarm.Walking = false
AutoFarm.AutoConvert = false

-- =========== ПОЛЯ ===========
AutoFarm.Fields = {
    ["Sunflower"] = {
        Center = Vector3.new(-44, 4, -264),
        Radius = 60
    },
    ["Mushroom"] = {
        Center = Vector3.new(108, 5, -197),
        Radius = 60
    },
    ["Blue Flower"] = {
        Center = Vector3.new(-129, 5, 83),
        Radius = 60
    },
    ["Clover"] = {
        Center = Vector3.new(213, 4, 108),
        Radius = 70
    },
    ["Spider"] = {
        Center = Vector3.new(211, 6, -129),
        Radius = 70
    }
}

-- =========== ПОЛУЧИТЬ ТЕКУЩИЙ КВЕСТ ===========
function AutoFarm:GetCurrentQuest()
    -- Простая проверка квеста (если есть доска квестов)
    local questBoard = Workspace:FindFirstChild("QuestBoard")
    if questBoard then
        return "Collect Pollen" -- Просто собирать пыльцу
    end
    return nil
end

-- =========== НАЙТИ БЛИЖАЙШИЙ ЦВЕТОК ===========
function AutoFarm:FindNearestFlower()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then 
        return nil 
    end
    
    local playerPos = character.HumanoidRootPart.Position
    local field = self.Fields[self.CurrentField]
    if not field then return nil end
    
    local closestFlower = nil
    local closestDistance = math.huge
    
    -- Ищем цветы в радиусе поля
    if Workspace:FindFirstChild("Flowers") then
        for _, flower in pairs(Workspace.Flowers:GetChildren()) do
            if flower:FindFirstChild("Flower") and flower:FindFirstChild("Click") then
                local flowerPos = flower.Flower.Position
                local distanceToField = (flowerPos - field.Center).Magnitude
                local distanceToPlayer = (flowerPos - playerPos).Magnitude
                
                -- Цветок должен быть в радиусе поля и не дальше 50 studs
                if distanceToField <= field.Radius and distanceToPlayer < 50 then
                    if distanceToPlayer < closestDistance then
                        closestFlower = flower
                        closestDistance = distanceToPlayer
                    end
                end
            end
        end
    end
    
    return closestFlower
end

-- =========== ЗАПУСТИТЬ АВТО-ФАРМ ===========
function AutoFarm:StartAutoFarm()
    if self.Running then return end
    
    self.Running = true
    print("✅ Авто-фарм запущен на поле: " .. self.CurrentField)
    
    self.Connection = RunService.Heartbeat:Connect(function()
        if not self.Running then return end
        
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        
        -- 1. Находим ближайший цветок
        local flower = self:FindNearestFlower()
        
        if flower then
            local flowerPos = flower.Flower.Position
            local playerPos = character.HumanoidRootPart.Position
            local distance = (flowerPos - playerPos).Magnitude
            
            -- 2. Если далеко - идем пешком
            if distance > 10 then
                if not self.Walking then
                    character:MoveTo(flowerPos)
                    self.Walking = true
                end
            else
                -- 3. Если близко - кликаем
                self.Walking = false
                fireclickdetector(flower.Click)
                task.wait(0.2) -- Пауза между кликами
            end
        else
            -- 4. Если цветков нет - ходим кругами по полю
            local field = self.Fields[self.CurrentField]
            if field then
                local angle = tick() * 0.3 -- Медленное движение
                local radius = field.Radius * 0.7
                local targetPos = field.Center + Vector3.new(
                    math.cos(angle) * radius,
                    0,
                    math.sin(angle) * radius
                )
                
                local playerPos = character.HumanoidRootPart.Position
                local distance = (targetPos - playerPos).Magnitude
                
                if distance > 5 then
                    if not self.Walking then
                        character:MoveTo(targetPos)
                        self.Walking = true
                    end
                else
                    self.Walking = false
                end
            end
        end
    end)
    
    -- Авто-конвертация если включена
    if self.AutoConvert then
        spawn(function()
            while self.Running and self.AutoConvert do
                task.wait(10) -- Каждые 10 секунд
                self:ConvertToHoney()
            end
        end)
    end
end

-- =========== ОСТАНОВИТЬ АВТО-ФАРМ ===========
function AutoFarm:StopAutoFarm()
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    self.Running = false
    self.Walking = false
    print("🛑 Авто-фарм остановлен")
end

-- =========== КОНВЕРТАЦИЯ ===========
function AutoFarm:ConvertToHoney()
    local events = game:GetService("ReplicatedStorage").Events
    local success = pcall(function()
        events.ConvertPollenToHoney:FireServer()
    end)
    
    if success then
        print("🍯 Конвертировано в мёд")
        return true
    end
    return false
end

-- =========== СМЕНИТЬ ПОЛЕ ===========
function AutoFarm:SetField(fieldName)
    if self.Fields[fieldName] then
        self.CurrentField = fieldName
        
        -- Если фарм запущен - идем на новое поле
        if self.Running and LocalPlayer.Character then
            local field = self.Fields[fieldName]
            LocalPlayer.Character:MoveTo(field.Center)
        end
        
        print("📍 Установлено поле: " .. fieldName)
        return true
    end
    return false
end

-- =========== ИНФОРМАЦИЯ ===========
function AutoFarm:GetStatus()
    print("=== СТАТУС ===")
    print("▶️ Работает: " .. tostring(self.Running))
    print("🌍 Поле: " .. self.CurrentField)
    print("🚶 Идет: " .. tostring(self.Walking))
    print("🍯 Авто-конвертация: " .. tostring(self.AutoConvert))
    print("==============")
end

-- =========== УВЕДОМЛЕНИЕ ===========
function AutoFarm:Notify()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🐝 Auto-Farm v5.0",
        Text = "Загружен! Макрос режим активен",
        Duration = 5,
        Icon = "rbxassetid://4439880892"
    })
end

AutoFarm:Notify()
return AutoFarm
