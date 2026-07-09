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
