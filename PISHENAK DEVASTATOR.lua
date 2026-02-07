--[[
    DEVASTATOR v27.4 // SMART BYPASS
    ИСПРАВЛЕНО: Защита от кика при брутфорсе. 
    Теперь команды идут с задержкой, чтобы античит не сработал.
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local cg = game:GetService("CoreGui")
local lit = game:GetService("Lighting")

if cg:FindFirstChild("DevAntiKick") then cg.DevAntiKick:Destroy() end
local sg = Instance.new("ScreenGui", cg) sg.Name = "DevAntiKick"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 520, 0, 520)
main.Position = UDim2.new(0.5, -260, 0.5, -260)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Active = true main.Draggable = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main) stroke.Color = Color3.new(1, 0.5, 0)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = " DEVASTATOR v27.4 // STEALTH: ON"
title.BackgroundColor3 = Color3.fromRGB(60, 30, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.Code
Instance.new("UICorner", title)

local inp = Instance.new("TextBox", main)
inp.Size = UDim2.new(0, 420, 0, 35)
inp.Position = UDim2.new(0.5, -210, 0, 50)
inp.PlaceholderText = "ID НЕБА/АУДИО (НАПРИМЕР: 109251560)"
inp.Text = ""
inp.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inp.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", inp)

local logs = Instance.new("ScrollingFrame", main)
logs.Size = UDim2.new(1, -20, 0, 120)
logs.Position = UDim2.new(0, 10, 1, -130)
logs.BackgroundColor3 = Color3.new(0, 0, 0)
local lay = Instance.new("UIListLayout", logs)

local function log(txt, col)
    local l = Instance.new("TextLabel", logs)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.Text = " [GHOST]: " .. tostring(txt)
    l.TextColor3 = col or Color3.new(1, 0.5, 0)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.Code
    logs.CanvasSize = UDim2.new(0, 0, 0, lay.AbsoluteContentSize.Y)
    logs.CanvasPosition = Vector2.new(0, 9999)
end

-- SMART SEND (С ЗАДЕРЖКОЙ)
local function smart_bomb(id, val)
    log("STARTING SMART ATTACK...", Color3.new(1, 1, 0))
    local count = 0
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            count = count + 1
            task.spawn(function()
                task.wait(count * 0.2) -- ЗАДЕРЖКА 0.2 сек между каждым эвентом (Анти-кик)
                pcall(function() v:FireServer(id, val) end)
                pcall(function() v:FireServer(val) end)
            end)
            if count % 10 == 0 then log("TESTED " .. count .. " TARGETS...") end
        end
    end
    log("BOMBING FINISHED.", Color3.new(0, 1, 0))
end

local g = Instance.new("Frame", main)
g.Size = UDim2.new(1, -20, 0, 250)
g.Position = UDim2.new(0, 10, 0, 100)
g.BackgroundTransparency = 1
Instance.new("UIGridLayout", g).CellSize = UDim2.new(0, 160, 0, 35)

local function btn(txt, cb, col)
    local b = Instance.new("TextButton", g)
    b.Text = txt
    b.BackgroundColor3 = col or Color3.fromRGB(35, 35, 35)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Code
    b.MouseButton1Click:Connect(cb)
    Instance.new("UICorner", b)
end

btn("SKY (BYPASS)", function()
    smart_bomb(882, "rbxassetid://" .. inp.Text)
end, Color3.fromRGB(0, 60, 0))

btn("AUDIO (BYPASS)", function()
    smart_bomb(993, "rbxassetid://" .. inp.Text)
end, Color3.fromRGB(0, 60, 0))

btn("KILL ALL", function()
    smart_bomb(771, "for _,p in pairs(game.Players:GetPlayers()) do p.Character:BreakJoints() end")
end, Color3.fromRGB(100, 0, 0))

btn("GHOST (Z)", function()
    for _, v in pairs(lp.Character:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 0.8 end
    end
    log("GHOST ACTIVE")
end)

btn("VOID ESCAPE", function() lp.Character.HumanoidRootPart.CFrame = CFrame.new(0, 5000, 0) end)

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

log("DEVASTATOR v27.4 STEALTH LOADED.")
