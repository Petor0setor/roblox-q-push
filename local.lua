local button = script.Parent
local replicatedStorage = game:GetService("ReplicatedStorage")

local pushEvent = replicatedStorage:WaitForChild("PushPlayersEvent", 5)
if not pushEvent then
	pushEvent = Instance.new("RemoteEvent")
	pushEvent.Name = "PushPlayersEvent"
	pushEvent.Parent = replicatedStorage
end

button.MouseButton1Click:Connect(function()
	pushEvent:FireServer()
end)
