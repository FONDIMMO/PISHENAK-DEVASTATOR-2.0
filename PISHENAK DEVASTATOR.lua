--[[
    DEVASTATOR v28.0 // CLEAN & POWERFUL
    HOTKEYS: 'L' - Menu | 'E' - Fly | 'Z' - Ghost
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local uis = game:GetService("UserInputService")
local cg = game:GetService("CoreGui")

-- [1] ИНТЕРФЕЙС
if cg:FindFirstChild("DevClean") then cg.DevClean:Destroy() end
local sg = Instance.new("ScreenGui", cg) sg.Name = "DevClean"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 450, 0, 400)
main.Position = UDim2.new(0.5, -225, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Active = true main.Draggable = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main) stroke.Color = Color3.new(1, 0, 0)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = " DEVASTATOR v28.0 // READY"
title.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.Code
Instance.new("UICorner", title)

-- [2] ОСНОВНЫЕ ФУНКЦИИ
local g = Instance.new("Frame", main)
g.Size = UDim2.new(1, -20, 0, 300)
g.Position = UDim2.new(0, 10, 0, 50)
g.BackgroundTransparency = 1
Instance.new("UIGridLayout", g).CellSize = UDim2.new(0, 135, 0, 40)

local function btn(txt, cb, col)
    local b = Instance.new("TextButton", g)
    b.Text = txt
    b.BackgroundColor3 = col or Color3.fromRGB(30, 30, 30)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Code
    b.MouseButton1Click:Connect(cb)
    Instance.new("UICorner", b)
end

-- КНОПКИ
btn("GIVE B-TOOLS", function() 
    Instance.new("HopperBin", lp.Backpack).BinType = 4
    Instance.new("HopperBin", lp.Backpack).BinType = 3
    Instance.new("HopperBin", lp.Backpack).BinType = 2
end, Color3.fromRGB(0, 80, 0))

btn("GHOST (Z)", function() 
    for _, v in pairs(lp.Character:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 0.7 end
    end
end)

btn("CHAT SPY", function()
    print("--- CHAT SPY ACTIVE ---")
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(data)
        print("[" .. data.FromSpeaker .. "]: " .. data.Message)
    end)
end, Color3.fromRGB(100, 0, 100))

btn("FULL BRIGHT", function()
    game:GetService("Lighting").Brightness = 2
    game:GetService("Lighting").ClockTime = 14
    game:GetService("Lighting").FogEnd = 100000
end)

btn("FPS BOOST", function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("DataModelMesh") or v:IsA("SpecialMesh") then v:Destroy() end
    end
end)

btn("VOID ESCAPE", function()
    lp.Character.HumanoidRootPart.CFrame = CFrame.new(0, 5000, 0)
end)

-- [3] ПОЛЕТ
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
                    bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 100
                    task.wait()
                end
                bv:Destroy()
            end)
        end
    elseif k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible
    end
end)
