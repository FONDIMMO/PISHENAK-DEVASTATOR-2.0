--[[
    DEVASTATOR v27.0 // ULTIMATE STEALTH & INVISIBILITY
    FEATURES: Anti-Kick Scan, Character Ghosting, Server-Side Chaos.
    CONTROLS: 'L' - Menu | 'E' - Fly | 'Z' - Invisibility
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local cg = game:GetService("CoreGui")
local lit = game:GetService("Lighting")

-- [1] UI SETUP
if cg:FindFirstChild("DevGhostFinal") then cg.DevGhostFinal:Destroy() end
local sg = Instance.new("ScreenGui", cg) sg.Name = "DevGhostFinal"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 520, 0, 460)
main.Position = UDim2.new(0.5, -260, 0.5, -230)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main) stroke.Color = Color3.fromRGB(0, 255, 0) stroke.Thickness = 1

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = " DEVASTATOR v27.0 // GHOST MODE: OFF"
title.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.Code
Instance.new("UICorner", title)

local logs = Instance.new("ScrollingFrame", main)
logs.Size = UDim2.new(1, -20, 0, 100)
logs.Position = UDim2.new(0, 10, 1, -110)
logs.BackgroundColor3 = Color3.new(0, 0, 0)
local lay = Instance.new("UIListLayout", logs)

local function log(txt, col)
    local l = Instance.new("TextLabel", logs)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.Text = " [GHOST]: " .. tostring(txt)
    l.TextColor3 = col or Color3.new(0, 1, 0)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.Code
    l.TextXAlignment = Enum.TextXAlignment.Left
    logs.CanvasSize = UDim2.new(0, 0, 0, lay.AbsoluteContentSize.Y)
    logs.CanvasPosition = Vector2.new(0, 9999)
end

-- [2] ЯДРО ВЗЛОМА (STEALTH)
local ss_event = nil

local function ss_send(id, val)
    if ss_event then
        ss_event:FireServer(id, val)
        log("SS COMMAND EXECUTED", Color3.new(1, 1, 0))
    else
        log("NOT CONNECTED TO SERVER", Color3.new(1, 0, 0))
    end
end

local function ghostScan()
    log("INITIALIZING STEALTH SCAN...", Color3.new(1, 1, 0))
    ss_event = nil
    local remotes = 0
    
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            -- Пропускаем ловушки анти-читов
            if n:find("check") or n:find("ban") or n:find("kick") or n:find("honey") then continue end
            
            remotes = remotes + 1
            task.spawn(function()
                task.wait(remotes * 0.4) -- Задержка для обхода Rate Limit
                pcall(function()
                    v:FireServer(771, "print(' ')")
                end)
            end)
            
            if n:find("network") or n:find("internal") or n:find("remote") or n:find("event") then
                ss_event = v
                title.Text = " GHOST MODE: CONNECTED (" .. v.Name .. ")"
            end
        end
    end
    log("SCAN FINISHED. TARGETS: " .. remotes)
end

-- [3] НЕВИДИМОСТЬ (GHOST FORM)
local invisible = false
local function toggleInvis()
    local char = lp.Character
    if not char then return end
    invisible = not invisible
    
    if invisible then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = (v.Name == "HumanoidRootPart" and 1 or 0.8)
            end
        end
        log("INVISIBILITY: ON (GHOST)", Color3.new(1, 1, 1))
    else
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = (v.Name == "HumanoidRootPart" and 1 or 0)
            end
        end
        log("INVISIBILITY: OFF", Color3.new(1, 0, 0))
    end
end

-- [4] ИНТЕРФЕЙС КНОПОК
local g = Instance.new("Frame", main)
g.Size = UDim2.new(1, -20, 0, 200)
g.Position = UDim2.new(0, 10, 0, 50)
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

btn("STEALTH SCAN", ghostScan, Color3.fromRGB(0, 60, 0))
btn("GHOST FORM (Z)", toggleInvis, Color3.fromRGB(50, 50, 50))
btn("FLY (E)", function() log("Press E to Fly") end)
btn("GLOBAL SKY", function() ss_send(882, "rbxassetid://109251560") end)
btn("GLOBAL AUDIO", function() ss_send(993, "rbxassetid://1837824874") end)
btn("KILL ALL", function() ss_send(771, "for _,p in pairs(game.Players:GetPlayers()) do p.Character:BreakJoints() end") end, Color3.fromRGB(100, 0, 0))
btn("NUKE MAP", function() ss_send(771, "for _,v in pairs(workspace:GetChildren()) do if v:IsA('BasePart') then v:Destroy() end end") end, Color3.fromRGB(100, 0, 0))
btn("B-TOOLS", function() Instance.new("HopperBin", lp.Backpack).BinType = 4 log("B-Tools Given") end)

-- [5] ФИЗИКА (FLY)
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
                    bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 60
                    task.wait()
                end
                bv:Destroy()
            end)
        end
    elseif k.KeyCode == Enum.KeyCode.Z then toggleInvis()
    elseif k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible
    end
end)

log("DEVASTATOR v27.0 LOADED.")
log("USE 'Z' TO BECOME A GHOST.")
