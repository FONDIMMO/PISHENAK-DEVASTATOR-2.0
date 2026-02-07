--[[
    PISHENAK DEVASTATOR v19 // PROJECT: OVERLORD
    PRIVATE COMMERCIAL BUILD - DO NOT DISTRIBUTE
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

--------------------------------------------------
-- СИСТЕМА ЗАЩИТЫ (WHITELIST)
--------------------------------------------------
local whitelist = {
    [10254737530] = "Owner", -- Твой UserId (для примера)
    [987654321] = "Customer_1", -- UserId покупателя
    -- Сюда добавляй новых покупателей через запятую
}

if not whitelist[lp.UserId] then
    lp:Kick("\n[DEVASTATOR ERROR]\nЛицензия не найдена.\nВаш ID: " .. lp.UserId .. "\nКупите доступ в Discord.")
    return
end

print("Access Granted. Welcome, " .. whitelist[lp.UserId])

--------------------------------------------------
-- ОСНОВНОЙ СОФТ
--------------------------------------------------
local coreGui = game:GetService("CoreGui")
local lighting = game:GetService("Lighting")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")

-- Очистка старых интерфейсов
for _, v in pairs(coreGui:GetChildren()) do
    if v.Name == "DevastatorOverlord" then v:Destroy() end
end

local sg = Instance.new("ScreenGui", coreGui)
sg.Name = "DevastatorOverlord"

-- ГЛАВНОЕ ОКНО
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 550, 0, 420)
main.Position = UDim2.new(0.5, -275, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(5, 0, 0)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Thickness = 2

-- ЗАГОЛОВОК
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "DEVASTATOR v19 // OWNER: " .. whitelist[lp.UserId]
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.Font = Enum.Font.Code
title.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
Instance.new("UICorner", title)

-- ПОЛЕ ВВОДА ID НЕБА
local idInput = Instance.new("TextBox", main)
idInput.Size = UDim2.new(0, 220, 0, 35)
idInput.Position = UDim2.new(0.5, -110, 0, 60)
idInput.PlaceholderText = "ENTER SKY ID..."
idInput.Text = ""
idInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
idInput.TextColor3 = Color3.new(1,1,1)
idInput.Font = Enum.Font.Code
Instance.new("UICorner", idInput)

-- КОНСОЛЬ
local logBox = Instance.new("ScrollingFrame", main)
logBox.Size = UDim2.new(1, -20, 0, 150)
logBox.Position = UDim2.new(0, 10, 1, -160)
logBox.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
logBox.BorderSizePixel = 0
local logLay = Instance.new("UIListLayout", logBox)

local function log(txt, col)
    local l = Instance.new("TextLabel", logBox)
    l.Size = UDim2.new(1, 0, 0, 18)
    l.Text = "> " .. txt
    l.TextColor3 = col or Color3.fromRGB(255, 0, 0)
    l.Font = Enum.Font.Code
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    logBox.CanvasSize = UDim2.new(0,0,0, logLay.AbsoluteContentSize.Y)
    logBox.CanvasPosition = Vector2.new(0, logLay.AbsoluteContentSize.Y)
end

-- ANTI-KICK
local function enableAntiKick()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if tostring(method) == "Kick" or tostring(method) == "kick" then
            log("ANTI-KICK: BLOCKED SERVER KICK", Color3.fromRGB(255, 255, 0))
            return nil
        end
        return old(self, ...)
    end)
    setreadonly(mt, true)
    log("ANTI-KICK: SYSTEM BYPASS ACTIVE", Color3.fromRGB(0, 255, 0))
end

-- GLOBAL INJECTION
local function injectGlobalSky(id)
    local asset = "rbxassetid://" .. id
    log("ATTEMPTING SERVER-SIDE INJECTION...", Color3.new(1,1,1))
    local s = lighting:FindFirstChild("GlobalSky") or Instance.new("Sky", lighting)
    s.Name = "GlobalSky"
    s.SkyboxBk = asset s.SkyboxDn = asset s.SkyboxFt = asset
    s.SkyboxLf = asset s.SkyboxRt = asset s.SkyboxUp = asset
    
    local count = 0
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            count = count + 1
            v:FireServer("Sky", asset)
            v:FireServer("UpdateSky", asset)
            v:FireServer("AdminCommand", "sky", asset)
        end
    end
    log("SENT TO " .. count .. " REMOTES", Color3.fromRGB(255, 0, 0))
end

-- СЕТКА КНОПОК
local bFrame = Instance.new("Frame", main)
bFrame.Size = UDim2.new(1, -20, 0, 100)
bFrame.Position = UDim2.new(0, 10, 0, 105)
bFrame.BackgroundTransparency = 1
local grid = Instance.new("UIGridLayout", bFrame)
grid.CellSize = UDim2.new(0, 170, 0, 35)

local function addBtn(txt, callback)
    local b = Instance.new("TextButton", bFrame)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Code
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(callback)
end

addBtn("ACTIVATE ANTI-KICK", enableAntiKick)
addBtn("EXECUTE GLOBAL SKY", function() injectGlobalSky(idInput.Text) end)
addBtn("CRASH AUDIO", function()
    log("AUDIO SPAM ACTIVE", Color3.new(1,0,0))
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Sound") then v:Play() v.Volume = 10 end
    end
end)
addBtn("VOID WORLD", function()
    log("PURGING MAP...", Color3.new(1,1,1))
    for _, v in pairs(workspace:GetChildren()) do
        if not v:FindFirstChild("Humanoid") and v.Name ~= "Terrain" then v:Destroy() end
    end
end)

uis.InputBegan:Connect(function(k, g)
    if not g and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
end)

log("SYSTEM LOADED. LICENSED TO " .. lp.Name)
