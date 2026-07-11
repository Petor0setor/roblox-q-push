-- Проверяем, чтобы кнопка не создавалась дважды при повторном запуске
if game:GetService("CoreGui"):FindFirstChild("XenoPushGui") then
    game:GetService("CoreGui").XenoPushGui:Destroy()
end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local RADIUS = 15          -- Радиус действия кнопки (в стадах)
local PUSH_FORCE = 400     -- Сила толчка (можно увеличить)
local NO_COLLIDE_TIME = 2  -- Время полета сквозь стены (в секундах)

-- Функция отключения коллизий (чтобы пролетать сквозь стены)
local function makeNoCollide(model)
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- Логика отталкивания вокруг твоего персонажа
local function doPush()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local originPosition = character.HumanoidRootPart.Position

    for _, object in ipairs(Workspace:GetChildren()) do
        if object:IsA("Model") and object ~= character then
            local hrp = object:FindFirstChild("HumanoidRootPart")
            local humanoid = object:FindFirstChildOfClass("Humanoid")
            
            if hrp and humanoid and humanoid.Health > 0 then
                local distance = (hrp.Position - originPosition).Magnitude
                
                if distance <= RADIUS then
                    local direction = (hrp.Position - originPosition).Unit
                    local pushVelocity = (direction * PUSH_FORCE) + Vector3.new(0, 100, 0)
                    
                    -- Принудительно меняем скорость объекта (работает в эксплоитах)
                    hrp.AssemblyLinearVelocity = pushVelocity
                    
                    -- Включаем полет сквозь стены
                    task.spawn(function()
                        local timeLeft = NO_COLLIDE_TIME
                        while timeLeft > 0 do
                            makeNoCollide(object)
                            timeLeft -= task.wait()
                        end
                    end)
                end
            end
        end
    end
end

-- ==========================================
-- СОЗДАНИЕ ГУИ КНОПКИ (ОНА ПОЯВИТСЯ НА ЭКРАНЕ)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XenoPushGui"
ScreenGui.Parent = game:GetService("CoreGui") -- Код Xeno прячет GUI сюда
ScreenGui.ResetOnSpawn = false

local TextButton = Instance.new("TextButton")
TextButton.Parent = ScreenGui
TextButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Темно-серый цвет кнопки
TextButton.Position = UDim2.new(0.05, 0, 0.4, 0)         -- Позиция на экране (слева по центру)
TextButton.Size = UDim2.new(0, 150, 0, 50)               -- Размер кнопки
TextButton.Font = Enum.Font.SourceSansBold
TextButton.Text = "PUSH ENEMIES"                         -- Текст на кнопке
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)   -- Белый цвет текста
TextButton.TextSize = 18

-- Скругление углов кнопки для красоты
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = TextButton

-- Делаем так, чтобы кнопку можно было перетаскивать мышкой по экрану
TextButton.Active = true
TextButton.Draggable = true

-- Привязываем функцию толчка к клику на эту кнопку
TextButton.MouseButton1Click:Connect(function()
    doPush()
end)
