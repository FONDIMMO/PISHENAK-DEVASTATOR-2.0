--[[
    DEVASTATOR v34.0 // FINAL OVERLORD
    ПОЛНЫЙ КОД: Поиск дыр, Брутфорс, Чат-спай, Полет.
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local cg = game:GetService("CoreGui")

if cg:FindFirstChild("DevFinal") then cg.DevFinal:Destroy() end
local sg = Instance.new("ScreenGui", cg) sg.Name = "DevFinal"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 520, 0, 520)
main.Position = UDim2.new(0.5, -260, 0.5, -260)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
main.Active = true main.Draggable = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main) stroke.Color = Color3.new(1, 0, 0)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = " DEVASTATOR v34.0 // OVERLORD "
title.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.Code
Instance.new("UICorner", title)

local inp = Instance.new("TextBox", main)
inp.Size = UDim2.new(0, 450, 0, 35)
inp.Position = UDim2.new(0.5, -225, 0, 50)
inp.PlaceholderText = "ВВЕДИ ID (НЕБО: 109251560)"
inp.Text = ""
inp.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inp.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", inp)

local function attack(id, val)
    local targets = 0
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            targets = targets + 1
            task.spawn(function()
                task.wait(targets * 0.2) -- Анти-кик задержка
                pcall(function() v:FireServer(id, val) end)
                pcall(function() v:FireServer(val) end)
            end)
        end
    end
end

local g = Instance.new("Frame", main)
g.Size = UDim2.new(1, -20, 0, 320)
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

-- КНОПКИ
btn("SKY (GLOBAL)", function() attack(882, "rbxassetid://"..inp.Text) end, Color3.fromRGB(0, 80, 0))
btn("AUDIO (GLOBAL)", function() attack(993, "rbxassetid://"..inp.Text) end, Color3.fromRGB(0, 80, 0))
btn("KILL ALL", function() attack(771, "for _,v in pairs(game.Players:GetPlayers()) do v.Character:BreakJoints() end") end, Color3.fromRGB(120, 0, 0))
btn("NUKE MAP", function() attack(771, "workspace:ClearAllChildren()") end, Color3.fromRGB(150, 0, 0))
btn("GIVE TOOLS", function() Instance.new("HopperBin", lp.Backpack).BinType = 4 end)
btn("GHOST (Z)", function() for _,v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.Transparency = 0.5 end end end)
btn("CHAT SPY", function() 
    local c = rs:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering")
    c.OnClientEvent:Connect(function(d) print("["..d.FromSpeaker.."]: "..d.Message) end)
end)
btn("VOID ESCAPE", function() lp.Character.HumanoidRootPart.CFrame = CFrame.new(0, 5000, 0) end)

-- FLY (E)
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
    elseif k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
end)
