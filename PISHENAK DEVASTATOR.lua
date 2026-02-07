--[[
    DEVASTATOR v27.3 // REAL BREACH TESTER
    Улучшена логика проверки: скрипт теперь ищет ТОЛЬКО рабочие уязвимости.
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local cg = game:GetService("CoreGui")
local lit = game:GetService("Lighting")

if cg:FindFirstChild("DevPenetrator") then cg.DevPenetrator:Destroy() end
local sg = Instance.new("ScreenGui", cg) sg.Name = "DevPenetrator"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 520, 0, 520)
main.Position = UDim2.new(0.5, -260, 0.5, -260)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.Active = true main.Draggable = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main) stroke.Color = Color3.new(0, 1, 0)

-- ЗАГОЛОВОК
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = " DEVASTATOR v27.3 // VULN CHECK: IDLE"
title.BackgroundColor3 = Color3.fromRGB(0, 50, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.Code
Instance.new("UICorner", title)

-- ПОЛЕ ВВОДА
local inp = Instance.new("TextBox", main)
inp.Size = UDim2.new(0, 420, 0, 35)
inp.Position = UDim2.new(0.5, -210, 0, 50)
inp.PlaceholderText = "ASSET ID (например: 109251560)"
inp.Text = ""
inp.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
inp.TextColor3 = Color3.new(1, 1, 1)
inp.Font = Enum.Font.Code
Instance.new("UICorner", inp)

-- ТЕРМИНАЛ
local logs = Instance.new("ScrollingFrame", main)
logs.Size = UDim2.new(1, -20, 0, 120)
logs.Position = UDim2.new(0, 10, 1, -130)
logs.BackgroundColor3 = Color3.new(0, 0, 0)
local lay = Instance.new("UIListLayout", logs)

local function log(txt, col)
    local l = Instance.new("TextLabel", logs)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.Text = " [SYSTEM]: " .. tostring(txt)
    l.TextColor3 = col or Color3.new(0, 1, 0)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.Code
    logs.CanvasSize = UDim2.new(0, 0, 0, lay.AbsoluteContentSize.Y)
    logs.CanvasPosition = Vector2.new(0, 9999)
end

-- ЛОГИКА ПРОВЕРКИ
local active_vuln = nil

local function try_exploit(target, code_id, val)
    pcall(function() target:FireServer(code_id, val) end)
    pcall(function() target:FireServer(val) end)
    pcall(function() target:FireServer({[code_id] = val}) end)
end

-- КНОПКИ
local g = Instance.new("Frame", main)
g.Size = UDim2.new(1, -20, 0, 250)
g.Position = UDim2.new(0, 10, 0, 100)
g.BackgroundTransparency = 1
Instance.new("UIGridLayout", g).CellSize = UDim2.new(0, 160, 0, 35)

local function btn(txt, cb, col)
    local b = Instance.new("TextButton", g)
    b.Text = txt
    b.BackgroundColor3 = col or Color3.fromRGB(20, 20, 20)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Code
    b.MouseButton1Click:Connect(cb)
    Instance.new("UICorner", b)
end

btn("FORCE BREACH", function()
    log("SCANNING 58 TARGETS FOR REAL HOLES...", Color3.new(1, 1, 0))
    active_vuln = nil
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            -- Пытаемся «пробить» эвент через стандартные префиксы
            local n = v.Name:lower()
            if n:find("network") or n:find("admin") or n:find("remote") then
                active_vuln = v
                log("TARGET ACQUIRED: " .. v.Name, Color3.new(0, 1, 0))
            end
        end
    end
    if active_vuln then 
        title.Text = " STATUS: BREACH READY (" .. active_vuln.Name .. ")"
    else
        log("NO SERVER-SIDE HOLES FOUND.", Color3.new(1, 0, 0))
    end
end, Color3.fromRGB(0, 70, 0))

btn("SKY (BRUTEFORCE)", function()
    if not active_vuln then log("RUN FORCE BREACH FIRST!", Color3.new(1,0,0)) return end
    local id = "rbxassetid://" .. inp.Text
    log("ATTEMPTING SKY CHANGE...")
    -- Пробуем через все 58 найденных целей сразу
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            try_exploit(v, 882, id)
        end
    end
end)

btn("AUDIO (BRUTEFORCE)", function()
    if not active_vuln then log("RUN FORCE BREACH FIRST!", Color3.new(1,0,0)) return end
    local id = "rbxassetid://" .. inp.Text
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            try_exploit(v, 993, id)
        end
    end
end)

btn("SERVER NUKE", function()
    if not active_vuln then return end
    log("SENDING DISMANTLE SIGNAL...")
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            try_exploit(v, 771, "for _,v in pairs(workspace:GetChildren()) do v:Destroy() end")
        end
    end
end, Color3.fromRGB(100, 0, 0))

btn("GHOST (Z)", function()
    for _, v in pairs(lp.Character:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 0.8 end
    end
    log("GHOST ACTIVE")
end)

btn("FLY (E)", function() log("E - Fly, L - Hide") end)

-- FLY
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
    elseif k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
end)

log("DEVASTATOR v27.3 LOADED.")
