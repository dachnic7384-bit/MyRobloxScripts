-- Bee Swarm Quest Auto-Farmer v4.0
-- Автор: dachnic7384-bit
-- GitHub: https://github.com/dachnic7384-bit/MyRobloxScripts

if not game:IsLoaded() then
    game.Loaded:Wait()
end

print("=========================================")
print("🐝 BEE SWARM QUEST FARMER v4.0")
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

local QuestFarmer = {}

-- =========== СОСТОЯНИЕ СКРИПТА ===========
QuestFarmer.Running = false
QuestFarmer.CurrentQuest = nil
QuestFarmer.CurrentField = "Sunflower"
QuestFarmer.QuestsCompleted = 0
QuestFarmer.Connection = nil
QuestFarmer.IsWalking = false

-- =========== НАСТРОЙКИ ПОЛЕЙ ===========
QuestFarmer.Fields = {
    ["Sunflower"] = {
        Center = Vector3.new(-44, 4, -264),
        Radius = 60,
        FlowerType = "Sunflower"
    },
    ["Mushroom"] = {
        Center = Vector3.new(108, 5, -197),
        Radius = 60,
        FlowerType = "Mushroom"
    },
    ["Blue Flower"] = {
        Center = Vector3.new(-129, 5, 83),
        Radius = 60,
        FlowerType = "Blue Flower"
    },
    ["Clover"] = {
        Center = Vector3.new(213, 4, 108),
        Radius = 70,
        FlowerType = "Clover"
    },
    ["Spider"] = {
        Center = Vector3.new(211, 6, -129),
        Radius = 70,
        FlowerType = "Spider"
    }
}

-- =========== ПОЛУЧЕНИЕ ТЕКУЩЕГО КВЕСТА ===========
function QuestFarmer:GetCurrentQuest()
    -- Получаем активный квест
    local questText = ""
    
    -- Проверяем доску квестов
    pcall(function()
        local questBoard = Workspace:FindFirstChild("QuestBoard")
        if questBoard then
            -- Получаем текст квеста
            for _, child in pairs(questBoard:GetChildren()) do
                if child:IsA("TextLabel") then
                    questText = child.Text
                    break
                end
            end
        end
    end)
    
    -- Парсим квест
    if questText:find("Sunflower") then
        return {Type = "Collect", Item = "Sunflower", Amount = self:ExtractAmount(questText)}
    elseif questText:find("Mushroom") then
        return {Type = "Collect", Item = "Mushroom", Amount = self:ExtractAmount(questText)}
    elseif questText:find("Blue Flower") then
        return {Type = "Collect", Item = "Blue Flower", Amount = self:ExtractAmount(questText)}
    elseif questText:find("Clover") then
        return {Type = "Collect", Item = "Clover", Amount = self:ExtractAmount(questText)}
    elseif questText:find("Spider") then
        return {Type = "Collect", Item = "Spider", Amount = self:ExtractAmount(questText)}
    elseif questText:find("Collect") or questText:find("Gather") then
        return {Type = "Collect", Item = self:DetectItem(questText), Amount = 100}
    else
        return nil
    end
end

function QuestFarmer:ExtractAmount(text)
    -- Извлекаем количество из текста квеста
    local amount = text:match("%d+")
    return amount and tonumber(amount) or 100
end

function QuestFarmer:DetectItem(text)
    -- Определяем предмет по тексту
    if text:find("pollen") or text:find("Pollen") then
        return "Pollen"
    end
    return "Sunflower" -- По умолчанию
end

-- =========== ПОИСК ПРЕДМЕТА ДЛЯ КВЕСТА ===========
function QuestFarmer:FindQuestItem()
    local quest = self.CurrentQuest
    if not quest then return nil end
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local playerPos = character.HumanoidRootPart.Position
    local closestFlower = nil
    local closestDistance = math.huge
    
    -- Определяем поле по типу квеста
    local targetField = nil
    for fieldName, fieldData in pairs(self.Fields) do
        if fieldData.FlowerType == quest.Item then
            targetField = fieldName
            break
        end
    end
    
    if not targetField then
        targetField = "Sunflower" -- По умолчанию
    end
    
    self.CurrentField = targetField
    local field = self.Fields[targetField]
    
    -- Ищем цветы на поле
    if Workspace:FindFirstChild("Flowers") then
        for _, flower in pairs(Workspace.Flowers:GetChildren()) do
            if flower:FindFirstChild("Click") and flower:FindFirstChild("Flower") then
                local flowerPos = flower.Flower.Position
                local distanceToField = (flowerPos - field.Center).Magnitude
                local distanceToPlayer = (flowerPos - playerPos).Magnitude
                
                -- Проверяем тип цветка
                local isCorrectType = string.find(flower.Name, quest.Item) ~= nil
                
                if isCorrectType and distanceToField <= field.Radius and distanceToPlayer < 80 then
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

-- =========== ПРОВЕРКА ИНВЕНТАРЯ ===========
function QuestFarmer:CheckInventory()
    -- Проверяем статистику пыльцы
    local stats = LocalPlayer:FindFirstChild("Stats")
    if stats then
        local pollen = stats:FindFirstChild("Pollen")
        if pollen and pollen.Value >= 1000 then
            return "FULL" -- Инвентарь полон
        end
    end
    return "OK"
end

-- =========== КОНВЕРТАЦИЯ МЕДА ===========
function QuestFarmer:ConvertToHoney()
    print("🍯 Конвертирую пыльцу в мёд...")
    
    local hive = Workspace:FindFirstChild(LocalPlayer.Name .. "'s Hive")
    if hive then
        -- Идем к улью
        local character = LocalPlayer.Character
        if character then
            character:MoveTo(hive.Position)
            task.wait(2) -- Ждем пока дойдем
        end
        
        -- Конвертируем
        pcall(function()
            ReplicatedStorage.Events.ConvertPollenToHoney:FireServer()
            task.wait(1)
        end)
    end
end

-- =========== ВЗЯТИЕ НОВОГО КВЕСТА ===========
function QuestFarmer:TakeNewQuest()
    print("📜 Ищу новый квест...")
    
    -- Идем к доске квестов
    local questBoard = Workspace:FindFirstChild("QuestBoard")
    if questBoard and LocalPlayer.Character then
        LocalPlayer.Character:MoveTo(questBoard.Position + Vector3.new(0, 0, -5))
        task.wait(2)
        
        -- Берем квест
        pcall(function()
            if questBoard:FindFirstChild("Click") then
                fireclickdetector(questBoard.Click)
                task.wait(1)
            end
        end)
    end
end

-- =========== ОСНОВНАЯ ЛОГИКА АВТО-ФАРМА ===========
function QuestFarmer:StartQuestFarmer()
    if self.Running then return end
    
    self.Running = true
    self.QuestsCompleted = 0
    print("🚀 Запускаю авто-квест фармер...")
    
    self.Connection = RunService.Heartbeat:Connect(function()
        if not self.Running then return end
        
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        
        -- 1. Получаем текущий квест
        if not self.CurrentQuest then
            self.CurrentQuest = self:GetCurrentQuest()
            if self.CurrentQuest then
                print("🎯 Текущий квест: " .. self.CurrentQuest.Item .. " x" .. self.CurrentQuest.Amount)
            else
                print("📜 Нет активного квеста, беру новый...")
                self:TakeNewQuest()
                task.wait(3)
                return
            end
        end
        
        -- 2. Проверяем инвентарь
        local inventoryStatus = self:CheckInventory()
        if inventoryStatus == "FULL" then
            print("🎒 Инвентарь полон! Конвертирую в мёд...")
            self:ConvertToHoney()
            task.wait(3)
            return
        end
        
        -- 3. Ищем предмет для квеста
        local targetFlower = self:FindQuestItem()
        
        if targetFlower then
            -- 4. Идем к цветку
            local flowerPos = targetFlower.Flower.Position
            local playerPos = character.HumanoidRootPart.Position
            local distance = (flowerPos - playerPos).Magnitude
            
            if distance > 10 then
                -- Нормальная ходьба к цветку
                if not self.IsWalking then
                    character:MoveTo(flowerPos)
                    self.IsWalking = true
                end
            else
                -- Достаточно близко, собираем
                self.IsWalking = false
                fireclickdetector(targetFlower.Click)
                task.wait(0.1)
                
                -- Проверяем завершение квеста
                local stats = LocalPlayer:FindFirstChild("Stats")
                if stats then
                    local questProgress = stats:FindFirstChild("QuestProgress")
                    if questProgress and questProgress.Value >= self.CurrentQuest.Amount then
                        print("✅ Квест выполнен! Иду сдавать...")
                        self.CurrentQuest = nil
                        self.QuestsCompleted = self.QuestsCompleted + 1
                        
                        -- Идем сдавать квест
                        local questBoard = Workspace:FindFirstChild("QuestBoard")
                        if questBoard then
                            character:MoveTo(questBoard.Position)
                            task.wait(3)
                        end
                    end
                end
            end
        else
            -- 5. Если нет цветков - ходим по полю
            local field = self.Fields[self.CurrentField]
            if field then
                local angle = tick() * 0.5 -- Медленный круг
                local radius = field.Radius * 0.6
                local targetPos = field.Center + Vector3.new(
                    math.cos(angle) * radius,
                    0,
                    math.sin(angle) * radius
                )
                
                local playerPos = character.HumanoidRootPart.Position
                local distance = (targetPos - playerPos).Magnitude
                
                if distance > 5 then
                    if not self.IsWalking then
                        character:MoveTo(targetPos)
                        self.IsWalking = true
                    end
                else
                    self.IsWalking = false
                end
            end
        end
    end)
end

function QuestFarmer:StopQuestFarmer()
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    self.Running = false
    self.IsWalking = false
    print("🛑 Авто-квест фармер остановлен")
end

-- =========== ИНФОРМАЦИЯ ===========
function QuestFarmer:GetStatus()
    local status = {
        Running = self.Running,
        CurrentQuest = self.CurrentQuest and self.CurrentQuest.Item or "Нет",
        CurrentField = self.CurrentField,
        QuestsCompleted = self.QuestsCompleted,
        IsWalking = self.IsWalking
    }
    
    print("=== СТАТУС ФАРМЕРА ===")
    print("▶️ Работает: " .. tostring(status.Running))
    print("🎯 Квест: " .. status.CurrentQuest)
    print("🌍 Поле: " .. status.CurrentField)
    print("✅ Выполнено: " .. status.QuestsCompleted .. " квестов")
    print("🚶 Идет: " .. tostring(status.IsWalking))
    print("=====================")
    
    return status
end

-- =========== ИНИЦИАЛИЗАЦИЯ ===========
function QuestFarmer:Notify()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🐝 Quest Auto-Farmer v4.0",
        Text = "Загружен! Только ходьба, без телепортов!\nF1 - вкл/выкл",
        Duration = 6,
        Icon = "rbxassetid://4439880892"
    })
end

QuestFarmer:Notify()

return QuestFarmer
