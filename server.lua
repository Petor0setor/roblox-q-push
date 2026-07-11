local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local pushEvent = ReplicatedStorage:FindFirstChild("PushPlayersEvent")
if not pushEvent then
	pushEvent = Instance.new("RemoteEvent")
	pushEvent.Name = "PushPlayersEvent"
	pushEvent.Parent = ReplicatedStorage
end

local RADIUS = 15          
local PUSH_FORCE = 500     
local NO_COLLIDE_TIME = 2  

local function makeNoCollide(model)
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
		end
	end
end

pushEvent.OnServerEvent:Connect(function(player)
	local character = player.Character
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
					local pushVelocity = (direction * PUSH_FORCE) + Vector3.new(0, 120, 0)
					
					humanoid:ChangeState(Enum.HumanoidStateType.Physics)
					
					local attachment = Instance.new("Attachment")
					attachment.Parent = hrp
					
					local linearVelocity = Instance.new("LinearVelocity")
					linearVelocity.MaxForce = math.huge
					linearVelocity.VectorVelocity = pushVelocity
					linearVelocity.Attachment0 = attachment
					linearVelocity.Parent = hrp
					
					game:GetService("Debris"):AddItem(linearVelocity, 0.2)
					game:GetService("Debris"):AddItem(attachment, 0.2)
					
					task.spawn(function()
						local timeLeft = NO_COLLIDE_TIME
						while timeLeft > 0 do
							makeNoCollide(object)
							timeLeft -= task.wait()
						end
						if humanoid then
							humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
						end
					end)
				end
			end
		end
	end
end)
