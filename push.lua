-- Улучшенный код с проверкой (замените старый код)
game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Xeno Push Script", Text = "Загрузка...", Duration = 3})

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "XenoPushGui"
-- Обход блокировки: пробуем CoreGui, если нет - PlayerGui
local success, err = pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not success then gui.Parent = player:WaitForChild("PlayerGui") end

local btn = Instance.new("TextButton")
btn.Parent = gui
btn.Size = UDim2.new(0, 150, 0, 50)
btn.Position = UDim2.new(0.1, 0, 0.5, 0)
btn.Text = "PUSH ENEMIES"
btn.Draggable = true

-- Логика нажатия (пример)
btn.MouseButton1Click:Connect(function()
    print("Push Activated")
end)
