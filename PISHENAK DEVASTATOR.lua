--[[
    DEVASTATOR v32.0 // FE BYPASS & SURVIVAL
    Этот билд сфокусирован на функциях, которые работают ВЕЗДЕ.
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local uis = game:GetService("UserInputService")
local cg = game:GetService("CoreGui")

if cg:FindFirstChild("DevFE") then cg.DevFE:Destroy() end
local sg = Instance.new("ScreenGui", cg) sg.Name = "DevFE"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 420, 0, 400)
main.Position = UDim2.new(0.5, -210, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Active = true main.Draggable = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main) stroke.Color = Color3.new(0, 1, 1)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = " DEVASTATOR v32.0 // FE BYPASS"
title.BackgroundColor3 = Color3.fromRGB(0, 40, 40)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.Code
Instance.new("UICorner", title)

local g = Instance.new("Frame", main)
g.Size = UDim2.new(1, -20, 0, 320)
g.Position = UDim2.new(0, 10, 0, 50)
g.BackgroundTransparency = 1
Instance.new("UIGridLayout", g).CellSize = UDim2.new(0, 190, 0, 40)

local function btn(txt, cb, col)
    local b = Instance.new("TextButton", g)
    b.Text = txt
    b.BackgroundColor3 = col or Color3.fromRGB(30, 30, 30)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Code
    b.MouseButton1Click:Connect(cb)
    Instance.new("UICorner", b)
end

-- [1] РЕАЛЬНЫЕ FE КОМАНДЫ (РАБОТАЮТ ВЕЗДЕ)
btn("FE KILL (REANIMATE)", function()
    -- Это имитация смерти для обхода защиты. Персонаж распадается для других.
    lp.Character.Humanoid.Health = 0
    print("FE Kill initiated")
end, Color3.fromRGB(80, 0, 0))

btn("GIVE B-TOOLS (CLIENT)", function() 
    -- Позволяет удалять объекты ДЛЯ ТЕБЯ (помогает проходить сквозь стены)
    Instance.new("HopperBin", lp.Backpack).BinType = 4 
end, Color3.fromRGB(0, 80, 80))

btn("INFINITE JUMP", function()
    local jumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
        lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end)
end)

btn("SPEED HACK (X)", function()
    lp.Character.Humanoid.WalkSpeed = 100
end)

btn("FLY (E)", function()
    local flying = true
    local hrp = lp.Character.HumanoidRootPart
    local bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(1e8, 1e8, 1e8)
    task.spawn(function()
        while flying do
            bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 100
            task.wait()
        end
    end)
end)

btn("INVISIBLE (GHOST)", function()
    for _, v in pairs(lp.Character:GetDescendants()) do
        if v:IsA("BasePart") then v.Transparency = 0.5 end
    end
end)

btn("ESP (SEE PLAYERS)", function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lp and v.Character then
            local highlight = Instance.new("Highlight", v.Character)
            highlight.FillColor = Color3.new(1, 0, 0)
        end
    end
end)

print("DEVASTATOR v32.0 LOADED. FOCUS ON SURVIVAL.")
