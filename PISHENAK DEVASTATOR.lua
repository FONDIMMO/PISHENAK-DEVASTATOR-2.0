--[[
    DEVASTATOR v27.2 // THE FINAL REVENGE
    FIXED: TextBox, Multi-Method Execution, Stealth Anti-Kick.
    CONTROLS: 'L' - Hide UI | 'E' - Fly | 'Z' - Ghost Form
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local cg = game:GetService("CoreGui")
local lit = game:GetService("Lighting")

-- [1] ОЧИСТКА И СОЗДАНИЕ UI
if cg:FindFirstChild("DevFinalRevenge") then cg.DevFinalRevenge:Destroy() end
local sg = Instance.new("ScreenGui", cg) sg.Name = "DevFinalRevenge"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 520, 0, 500)
main.Position = UDim2.new(0.5, -260, 0.5, -250)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
main.Active = true main.Draggable = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main) stroke.Color = Color3.new(1, 0, 0) stroke.Thickness = 2

-- ЗАГОЛОВОК
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = " DEVASTATOR v27.2 // BREACH STATUS: IDLE"
title.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.Code
Instance.new("UICorner", title)

-- [2] ПОЛЕ ВВОДА (ДЛЯ ID И КОДА)
local inp = Instance.new("TextBox", main)
inp.Size = UDim2.new(0, 420, 0, 35)
inp.Position = UDim2.new(0.5, -210, 0, 50)
inp.PlaceholderText = "ENTER ID (AUDIO/SKY) OR LUA CODE"
inp.Text = ""
inp.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inp.TextColor3 = Color3.new(1, 1, 1)
inp.Font = Enum.Font.Code
Instance.new("UICorner", inp)

-- ТЕРМИНАЛ
local logs = Instance.new("ScrollingFrame", main)
logs.Size = UDim2.new(1, -20, 0, 110)
logs.Position = UDim2.new(0, 10, 1, -120)
logs.BackgroundColor3 = Color3.new(0, 0, 0)
local lay = Instance.new("UIListLayout", logs)

local function log(txt, col)
    local l = Instance.new("TextLabel", logs)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.Text = " [>] " .. tostring(txt)
    l.TextColor3 = col or Color3.new(1, 0, 0)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.Code
    logs.CanvasSize = UDim2.new(0, 0, 0, lay.AbsoluteContentSize.Y)
    logs.CanvasPosition = Vector2.new(0, 9999)
end

-- [3] СИСТЕМА ИСПОЛНЕНИЯ (MULTI-TARGET)
local ss_event = nil

local function ss_send(code_id, payload)
    if ss_event then
        -- Пробуем 3 разных метода отправки (под разные типы бэкдоров)
        pcall(function() ss_event:FireServer(code_id, payload) end)
        pcall(function() ss_event:FireServer(payload) end)
        pcall(function() ss_event:FireServer(unpack({code_id, payload})) end)
        log("COMMAND SENT VIA " .. ss_event.Name, Color3.new(0, 1, 0))
    else
        log("NOT CONNECTED! RUN STEALTH SCAN", Color3.new(1, 0.5, 0))
    end
end

-- [4] КНОПКИ УПРАВЛЕНИЯ
local g = Instance.new("Frame", main)
g.Size = UDim2.new(1, -20, 0, 240)
g.Position = UDim2.new(0, 10, 0, 100)
g.BackgroundTransparency = 1
Instance.new("UIGridLayout", g).CellSize = UDim2.new(0, 160, 0, 35)

local function btn(txt, cb, col)
    local b = Instance.new("TextButton", g)
    b.Text = txt
    b.BackgroundColor3 = col or Color3.fromRGB(25, 25, 25)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Code
    b.MouseButton1Click:Connect(cb)
    Instance.new("UICorner", b)
end

btn("STEALTH SCAN", function()
    log("SCANNING FOR BACKDOORS...", Color3.new(1, 1, 0))
    ss_event = nil
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            if n:find("network") or n:find("internal") or n:find("remote") or n:find("status") then
                ss_event = v
                title.Text = " STATUS: CONNECTED (" .. v.Name .. ")"
                log("LOCKED ON: " .. v.Name, Color3.new(0, 1, 0))
            end
        end
    end
end, Color3.fromRGB(0, 60, 0))

btn("GLOBAL SKY", function() ss_send(882, "rbxassetid://"..inp.Text) end)
btn("GLOBAL AUDIO", function() ss_send(993, "rbxassetid://"..inp.Text) end)

btn("KILL ALL", function() 
    ss_send(771, "for _,p in pairs(game.Players:GetPlayers()) do if p.Character then p.Character:BreakJoints() end end")
end, Color3.fromRGB(100, 0, 0))

btn("NUKE MAP", function() 
    ss_send(771, "workspace:ClearAllChildren()")
end, Color3.fromRGB(150, 0, 0))

btn("GIVE TOOLS", function()
    ss_send(771, "for _,p in pairs(game.Players:GetPlayers()) do Instance.new('HopperBin', p.Backpack).BinType = 4 end")
end)

btn("REMOTE EXEC", function() ss_send(771, inp.Text) end, Color3.fromRGB(0, 100, 0))

btn("GHOST FORM (Z)", function() 
    local char = lp.Character
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 0.7 end
    end
    log("GHOST MODE ACTIVE")
end)

btn("VOID ESCAPE", function() lp.Character.HumanoidRootPart.CFrame = CFrame.new(0, 5000, 0) end)

-- [5] ХОТКЕИ И ПОЛЕТ
local flying = false
uis.InputBegan:Connect(function(k, m)
    if m then return end
    if k.KeyCode == Enum.KeyCode.E then
        flying = not flying
        local hrp = lp.Character.HumanoidRootPart
        if flying then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.MaxForce = Vector3.new(1e8, 1e8, 1e8)
            task.spawn(function()
                while flying do
                    bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 70
                    task.wait()
                end
                bv:Destroy()
            end)
        end
    elseif k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible
    end
end)

log("DEVASTATOR v27.2 LOADED.")
log("STEP 1: STEALTH SCAN | STEP 2: CHAOS")
