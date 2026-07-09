-- ====================================================================
-- ОБЪЕДИНЕННЫЙ СКРИПТ (ДЛЯ РАЗРАБОТКИ СОБСТВЕННОЙ ИГРЫ В ROBLOX STUDIO)
-- ====================================================================

-- 1. СЕРВЕРНАЯ ЧАСТЬ (Создание события и логика толчка)
if game:GetService("RunService"):IsServer() then
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    local pushEvent = Instance.new("RemoteEvent")
    pushEvent.Name = "PushEvent"
    pushEvent.Parent = ReplicatedStorage

    local RADIUS = 25               
    local DISTANCE = 150            
    local HEIGHT = 40               

    pushEvent.OnServerEvent:Connect(function(player)
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        
        local params = OverlapParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {character}
        
        local parts = workspace:GetPartBoundsInRadius(character.HumanoidRootPart.Position, RADIUS, params)
        local pushed = {}
        
        for _, part in ipairs(parts) do
            local model = part:FindFirstAncestorOfClass("Model")
            if model and model:FindFirstChildOfClass("Humanoid") then
                local targetRoot = model:FindFirstChild("HumanoidRootPart")
                if targetRoot and not pushed[targetRoot] then
                    pushed[targetRoot] = true
                    local dir = (targetRoot.Position - character.HumanoidRootPart.Position)
                    local dirH = Vector3.new(dir.X, 0, dir.Z).Unit
                    targetRoot.CFrame = targetRoot.CFrame + (dirH * DISTANCE) + Vector3.new(0, HEIGHT, 0)
                end
            end
        end
    end)

-- 2. КЛИЕНТСКАЯ ЧАСТЬ (Отслеживание клавиши Q)
else
    local UserInputService = game:GetService("UserInputService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local pushEvent = ReplicatedStorage:WaitForChild("PushEvent")
    local COOLDOWN = 1
    local isCooldown = false

    UserInputService.InputBegan:Connect(function(input, chat)
        if chat then return end
        if input.KeyCode == Enum.KeyCode.Q and not isCooldown then
            isCooldown = true
            pushEvent:FireServer()
            task.wait(COOLDOWN)
            isCooldown = false
        end
    end)
end
