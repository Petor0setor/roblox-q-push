-- Очищаем старые кнопки, чтобы они не накладывались друг на друга
if game:GetService("CoreGui"):FindFirstChild("MM2XenoGui") then
    game:GetService("CoreGui").MM2XenoGui:Destroy()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Создаем контейнер для интерфейса
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2XenoGui"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- КНОПКА 1: Телепорт к жертве (Для Убийцы)
local btn1 = Instance.new("TextButton")
btn1.Parent = ScreenGui
btn1.Size = UDim2.new(0, 220, 0, 50)
btn1.Position = UDim2.new(0.05, 0, 0.3, 0) -- Слева на экране
btn1.BackgroundColor3 = Color3.fromRGB(200, 40, 40) -- Красная
btn1.Font = Enum.Font.SourceSansBold
btn1.Text = "🔪 ТП к жертве (Маньяк)"
btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
btn1.TextSize = 16
btn1.Draggable = true -- Кнопку можно перетаскивать мышкой

-- КНОПКА 2: Сбежать от убийцы (Для Выжившего)
local btn2 = Instance.new("TextButton")
btn2.Parent = ScreenGui
btn2.Size = UDim2.new(0, 220, 0, 50)
btn2.Position = UDim2.new(0.05, 0, 0.38, 0) -- Чуть ниже первой
btn2.BackgroundColor3 = Color3.fromRGB(40, 160, 40) -- Зеленая
btn2.Font = Enum.Font.SourceSansBold
btn2.Text = "🛡️ Сбежать от Убийцы"
btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
btn2.TextSize = 16
btn2.Draggable = true

-- Скругление углов кнопок для красоты
local corner1 = Instance.new("UICorner", btn1)
corner1.CornerRadius = UDim.new(0, 8)
local corner2 = Instance.new("UICorner", btn2)
corner2.CornerRadius = UDim.new(0, 8)

-- 1. ЛОГИКА ПОИСКА УБИЙЦЫ (MURDER) ПО НАЛИЧИЮ НОЖА
local function getMurderer()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Проверяем нож в руках или в инвентаре
            local hasKnife = player.Character:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife")
            if hasKnife and player.Character:FindFirstChild("HumanoidRootPart") then
                return player
            end
        end
    end
    return nil
end

-- 2. ЛОГИКА ВЫБОРА СЛУЧАЙНОЙ ЖИВОЙ ЖЕРТВЫ
local function getRandomTarget()
    local targets = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            -- Проверяем, что игрок жив и это не убийца с ножом
            if humanoid and humanoid.Health > 0 then
                local isMurder = player.Character:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife")
                if not isMurder then
                    table.insert(targets, player)
                end
            end
        end
    end
    
    -- Выбираем случайного игрока из списка живых
    if #targets > 0 then
        return targets[math.random(1, #targets)]
    end
    return nil
end

-- АКТИВАЦИЯ КНОПКИ 1: ТП к выжившему (За спину)
btn1.MouseButton1Click:Connect(function()
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    
    local target = getRandomTarget()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        -- Телепортируем тебя ровно на 2 стада позади жертвы, чтобы сразу ударить ножом
        myChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
    end
end)

-- АКТИВАЦИЯ КНОПКИ 2: ТП подальше от маньяка
btn2.MouseButton1Click:Connect(function()
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    
    local murderer = getMurderer()
    if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
        -- Если убийца найден на карте, скрипт вычисляет направление и бросает тебя в противоположную сторону
        local direction = (myChar.HumanoidRootPart.Position - murderer.Character.HumanoidRootPart.Position).Unit
        -- Переносим тебя на 250 стадов в сторону от убийцы и на 30 стадов вверх (на крышу или спавн)
        myChar.HumanoidRootPart.CFrame = myChar.HumanoidRootPart.CFrame + (direction * 250) + Vector3.new(0, 30, 0)
    else
        -- Если убийца еще не достал нож, скрипт просто делает безопасный сейв на случайные координаты
        myChar.HumanoidRootPart.CFrame = myChar.HumanoidRootPart.CFrame + Vector3.new(math.random(-100, 100), 60, math.random(-100, 100))
    end
end)

-- Оповещение в чат об успешном старте
game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
    Text = "[MM2 Чит]: Кнопки успешно загружены! Можно играть.",
    Color = Color3.fromRGB(0, 255, 255),
    Font = Enum.Font.SourceSansBold
})
