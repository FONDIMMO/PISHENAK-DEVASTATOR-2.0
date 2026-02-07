--[[
    DEVASTATOR v33.0 // SERVERSIDE HUNTER
    ПОЛНАЯ ВЕРСИЯ: Все кнопки, Поле ввода, Брутфорс-сканер.
    ВНИМАНИЕ: Если эвенты в игре защищены, глобальный взлом не сработает.
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local cg = game:GetService("CoreGui")

if cg:FindFirstChild("DevFinalFull") then cg.DevFinalFull:Destroy() end
local sg = Instance.new("ScreenGui", cg) sg.Name = "DevFinalFull"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 550, 0, 550)
main.Position = UDim2.new(0.5, -275, 0.5, -275)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.Active = true main.Draggable = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main) stroke.Color = Color3.new(1, 0, 0)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = " DEVASTATOR v33.0 // GLOBAL EXECUTION "
title.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.Code
Instance.new("UICorner", title)

-- ПОЛЕ ВВОДА (ДЛЯ ID)
local inp = Instance.new("TextBox", main)
inp.Size = UDim2.new(0, 480, 0, 40)
inp.Position = UDim2.new(0.5, -240, 0, 50)
inp.PlaceholderText = "ВВЕДИТЕ ID (НЕБО/ЗВУК) ИЛИ КОД"
inp.Text = ""
inp.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inp.TextColor3 = Color3.new(1, 1, 1)
inp.Font = Enum.Font.Code
Instance.new("UICorner", inp)

-- ФУНКЦИЯ ГЛОБАЛЬНОЙ ОТПРАВКИ (ПРОБИВАЕМ FE)
local function global_attack(cmd_id, data)
    print("--- ЗАПУСК ГЛОБАЛЬНОЙ АТАКИ ---")
    local count = 0
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            count = count + 1
            task.spawn(function()
                task.wait(count * 0.2) -- Задержка против кика
                pcall(function() v:FireServer(cmd_id, data) end)
                pcall(function() v:FireServer(data) end)
                -- Дополнительный метод для B-Tools (если эвент это позволяет)
                pcall(function() v:FireServer("CreatePart", "Block", workspace) end)
            end)
        end
    end
end

-- СЕТКА КНОПОК
local g = Instance.new("Frame", main)
g.Size = UDim2.new(1, -20, 0, 350)
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

-- ВСЕ КНОПКИ ВЕРНУТЫ
btn("GLOBAL SKY", function() global_attack(882, "rbxassetid://"..inp.Text) end, Color3.fromRGB(0, 100, 0))
btn("GLOBAL AUDIO", function() global_attack(993, "rbxassetid://"..inp.Text) end, Color3.fromRGB(0, 100, 0))
btn("KILL ALL", function() global_attack(771, "for _,v in pairs(game.Players:GetPlayers()) do v.Character:BreakJoints() end") end, Color3.fromRGB(150, 0, 0))
btn("NUKE MAP", function() global_attack(771, "workspace:ClearAllChildren()") end, Color3.fromRGB(150, 0, 0))
btn("REMOTE EXEC", function() global_attack(771, inp.Text) end, Color3.fromRGB(100, 0, 100))

btn("GIVE B-TOOLS", function() 
    Instance.new("HopperBin", lp.Backpack).BinType = 4 
    Instance.new("HopperBin", lp.Backpack).BinType = 3
    Instance.new("HopperBin", lp.Backpack).BinType = 2
end)

btn("GHOST (Z)", function() 
    for _, v in pairs(lp.Character:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 0.7 end
    end
end)

btn("FLY (E)", function() print("Fly Active") end)
btn("VOID ESCAPE", function() lp.Character.HumanoidRootPart.CFrame = CFrame.new(0, 5000, 0) end)
btn("CHAT SPY", function() 
    local chat = rs:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering")
    chat.OnClientEvent:Connect(function(d) print("["..d.FromSpeaker.."]: "..d.Message) end)
end)

-- ПОЛЕТ
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

print("DEVASTATOR v33.0 FULL LOADED. БОМБИТЕ СЕРВЕР.")
