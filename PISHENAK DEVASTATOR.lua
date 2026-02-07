--[[
    PISHENAK DEVASTATOR v23 // PROJECT: OVERLORD
    STATUS: PREMIUM (FIXED FE-BYPASS ATTEMPTS)
    
    ИНСТРУКЦИЯ:
    1. Нажми 'L' чтобы скрыть/показать меню.
    2. Используй 'REMOTE SPY' для поиска скрытых событий сервера.
    3. 'EXECUTE GLOBAL SKY' пробует пробить FilteringEnabled (FE).
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

--------------------------------------------------
-- [1] WHITELIST (UserId)
--------------------------------------------------
local whitelist = {
    [lp.UserId] = "Developer", -- Твой ID подхватывается автоматически
}

if not whitelist[lp.UserId] then
    lp:Kick("\n[DEVASTATOR ERROR]\nLicense Required.\nYour ID: " .. lp.UserId)
    return
end

--------------------------------------------------
-- [2] ИНИЦИАЛИЗАЦИЯ ИНТЕРФЕЙСА
--------------------------------------------------
local coreGui = game:GetService("CoreGui")
local lighting = game:GetService("Lighting")
local uis = game:GetService("UserInputService")

for _, v in pairs(coreGui:GetChildren()) do
    if v.Name == "DevastatorV23" then v:Destroy() end
end

local sg = Instance.new("ScreenGui", coreGui)
sg.Name = "DevastatorV23"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 550, 0, 480)
main.Position = UDim2.new(0.5, -275, 0.5, -240)
main.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Thickness = 2

-- Заголовок
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "DEVASTATOR v23 // LICENSED: " .. whitelist[lp.UserId]
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.Font = Enum.Font.Code
title.BackgroundColor3 = Color3.fromRGB(25, 0, 0)
Instance.new("UICorner", title)

-- Ввод ID
local idInput = Instance.new("TextBox", main)
idInput.Size = UDim2.new(0, 260, 0, 35)
idInput.Position = UDim2.new(0.5, -130, 0, 55)
idInput.PlaceholderText = "ENTER SKY IMAGE ID..."
idInput.Text = ""
idInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
idInput.TextColor3 = Color3.new(1, 1, 1)
idInput.Font = Enum.Font.Code
Instance.new("UICorner", idInput)

-- Консоль логов
local logBox = Instance.new("ScrollingFrame", main)
logBox.Size = UDim2.new(1, -20, 0, 180)
logBox.Position = UDim2.new(0, 10, 1, -190)
logBox.BackgroundColor3 = Color3.fromRGB(5, 0, 0)
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
    logBox.CanvasSize = UDim2.new(0, 0, 0, logLay.AbsoluteContentSize.Y)
    logBox.CanvasPosition = Vector2.new(0, logLay.AbsoluteContentSize.Y)
end

--------------------------------------------------
-- [3] ГЛАВНЫЕ ФУНКЦИИ
--------------------------------------------------

-- 1. REMOTE SPY (ОТСЛЕЖИВАНИЕ СОБЫТИЙ СЕРВЕРА)
local spyActive = false
local function toggleSpy()
    spyActive = not spyActive
    log("REMOTE SPY: " .. (spyActive and "ON" or "OFF"), Color3.new(1, 1, 0))
    
    if spyActive then
        local mt = getrawmetatable(game)
        local old = mt.__namecall
        setreadonly(mt, false)
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if spyActive and self:IsA("RemoteEvent") and method == "FireServer" then
                log("SPY: " .. self.Name .. " fired!", Color3.new(0, 1, 1))
            end
            return old(self, ...)
        end)
        setreadonly(mt, true)
    end
end

-- 2. ANTI-KICK
local function enableAntiKick()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if tostring(method) == "Kick" or tostring(method) == "kick" then
            log("ANTI-KICK: BLOCKED SERVER KICK", Color3.new(1, 1, 0))
            return nil
        end
        return old(self, ...)
    end)
    setreadonly(mt, true)
    log("ANTI-KICK SYSTEM ACTIVE", Color3.new(0, 1, 0))
end

-- 3. GLOBAL SKY INJECTION (v23 IMPROVED)
local function globalSky(id)
    if id == "" or not tonumber(id) then log("ERROR: WRONG ID", Color3.new(1,0,0)) return end
    local asset = "rbxassetid://" .. id
    log("ATTEMPTING FE-BYPASS INJECTION...", Color3.new(1,1,1))
    
    -- Локально (всегда работает)
    local s = lighting:FindFirstChild("DevastatorSky") or Instance.new("Sky", lighting)
    s.Name = "DevastatorSky"
    s.SkyboxBk = asset s.SkyboxDn = asset s.SkyboxFt = asset
    s.SkyboxLf = asset s.SkyboxRt = asset s.SkyboxUp = asset

    -- Попытка пробиться на сервер через перебор
    local found = 0
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            if n:find("sky") or n:find("light") or n:find("weather") or n:find("env") or n:find("admin") then
                found = found + 1
                task.spawn(function()
                    pcall(function()
                        v:FireServer("Skybox", asset)
                        v:FireServer(asset)
                        v:FireServer("Update", asset)
                    end)
                end)
            end
        end
    end
    log("INJECTED INTO " .. found .. " REMOTES", Color3.new(1, 0.5, 0))
    log("CHECK SECOND DEVICE NOW", Color3.new(1, 1, 1))
end

--------------------------------------------------
-- [4] КНОПКИ МЕНЮ
--------------------------------------------------
local btnFrame = Instance.new("Frame", main)
btnFrame.Size = UDim2.new(1, -20, 0, 150)
btnFrame.Position = UDim2.new(0, 10, 0, 100)
btnFrame.BackgroundTransparency = 1
local grid = Instance.new("UIGridLayout", btnFrame)
grid.CellSize = UDim2.new(0, 170, 0, 35)

local function addBtn(txt, cb)
    local b = Instance.new("TextButton", btnFrame)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Code
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

addBtn("ACTIVATE ANTI-KICK", enableAntiKick)
addBtn("REMOTE SPY", toggleSpy)
addBtn("EXECUTE GLOBAL SKY", function() globalSky(idInput.Text) end)
addBtn("SCAN ALL REMOTES", function()
    local c = 0
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then c = c + 1 log("FOUND: " .. v.Name, Color3.new(0, 1, 1)) end
    end
    log("TOTAL: " .. c, Color3.new(1, 1, 0))
end)
addBtn("CRASH AUDIO", function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Sound") then v:Play() v.Volume = 10 end
    end
    log("AUDIO SPAM ACTIVE", Color3.new(1, 0, 0))
end)
addBtn("VOID WORLD", function()
    for _, v in pairs(workspace:GetChildren()) do
        if not v:FindFirstChild("Humanoid") and v.Name ~= "Terrain" then v:Destroy() end
    end
    log("WORLD PURGED", Color3.new(1, 1, 1))
end)

-- Скрытие на L
uis.InputBegan:Connect(function(k, g)
    if not g and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
end)

log("PISHENAK DEVASTATOR v23 LOADED", Color3.new(0, 1, 0))
log("PRESS 'L' TO TOGGLE MENU", Color3.new(1, 1, 1))
