-- GUI для MyRobloxScripts
-- Автор: dachnic7384-bit

local GUI = {}

function GUI:LoadRayfield()
    -- Загружаем библиотеку для GUI
    local success, Rayfield = pcall(function()
        return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    end)
    
    if not success then
        warn("❌ Не удалось загрузить Rayfield!")
        return nil
    end
    
    return Rayfield
end

function GUI:CreateMainWindow()
    local Rayfield = self:LoadRayfield()
    if not Rayfield then return end
    
    local Window = Rayfield:CreateWindow({
        Name = "MyRobloxScripts 🎮",
        LoadingTitle = "Загрузка...",
        LoadingSubtitle = "by dachnic7384-bit",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "MyScriptConfig"
        },
        Discord = {
            Enabled = false,
            Invite = ""
        },
        KeySystem = false
    })
    
    -- Вкладка "Основное"
    local MainTab = Window:CreateTab("Основное", 4483362458)
    
    MainTab:CreateButton({
        Name = "🟢 Активировать скрипт",
        Callback = function()
            local myscript = loadstring(game:HttpGet("https://raw.githubusercontent.com/dachnic7384-bit/MyRobloxScripts/main/main.lua"))()
            if myscript then
                myscript:Hello()
            end
        end
    })
    
    MainTab:CreateButton({
        Name = "👥 Список игроков",
        Callback = function()
            local myscript = loadstring(game:HttpGet("https://raw.githubusercontent.com/dachnic7384-bit/MyRobloxScripts/main/main.lua"))()
            if myscript then
                myscript:GetPlayerInfo()
            end
        end
    })
    
    MainTab:CreateToggle({
        Name = "👁️ Включить ESP",
        CurrentValue = false,
        Flag = "ESP_Toggle",
        Callback = function(value)
            local myscript = loadstring(game:HttpGet("https://raw.githubusercontent.com/dachnic7384-bit/MyRobloxScripts/main/main.lua"))()
            if myscript then
                if value then
                    myscript:SimpleESP()
                else
                    myscript:RemoveESP()
                end
            end
        end
    })
    
    -- Вкладка "Настройки"
    local SettingsTab = Window:CreateTab("Настройки", 4483362458)
    
    SettingsTab:CreateSlider({
        Name = "🚶 Скорость ходьбы",
        Range = {16, 100},
        Increment = 1,
        Suffix = "studs/s",
        CurrentValue = 25,
        Flag = "WalkSpeed",
        Callback = function(value)
            local myscript = loadstring(game:HttpGet("https://raw.githubusercontent.com/dachnic7384-bit/MyRobloxScripts/main/main.lua"))()
            if myscript then
                print(myscript:SetWalkspeed(value))
            end
        end
    })
    
    SettingsTab:CreateButton({
        Name = "🔄 Обновить скрипт",
        Callback = function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "MyRobloxScripts",
                Text = "Скрипт обновлен!",
                Duration = 3
            })
        end
    })
    
    return Window
end

-- Автоматически создаем окно при загрузке
GUI:CreateMainWindow()

return GUI
