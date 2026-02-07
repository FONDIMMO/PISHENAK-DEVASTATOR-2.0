--[[
    PISHENAK DEVASTATOR v22 // FINAL PRIVATE BUILD
    ФУНКЦИИ: 
    - GLOBAL SKY (BYPASS ATTEMPT)
    - REMOTE SCANNER (ПОИСК УЯЗВИМОСТЕЙ)
    - ANTI-KICK (METATABLE HOOK)
    - AUDIO CRASH & VOID MAP
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

--------------------------------------------------
-- [1] СИСТЕМА ЗАЩИТЫ (WHITELIST)
--------------------------------------------------
local whitelist = {
    [lp.UserId] = "Developer", -- Твой ID (подхватится автоматически)
    -- [123456789] = "Customer_Name", -- Сюда добавляй ID покупателей
}

if not whitelist[lp.UserId] then
    lp:Kick("\n[DEVASTATOR ERROR]\nLicense Required.\nYour ID: " .. lp.UserId)
    return
end

--------------------------------------------------
-- [2] ГРАФИЧЕСКИЙ ИНТЕРФЕЙС (GUI)
--------------------------------------------------
local coreGui = game:GetService("CoreGui")
local lighting = game:GetService("Lighting")
local uis = game:GetService("UserInputService")

-- Удаление старой версии
for _, v in pairs(coreGui:GetChildren()) do
    if v.Name == "DevastatorV22" then v:Destroy() end
end

local sg = Instance.new("ScreenGui", coreGui)
sg.Name = "DevastatorV22"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 550, 0, 450)
main.Position = UDim2.new(0.5, -275, 0.5, -225)
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
title.Text = "DEVASTATOR v22 // LICENSED TO: " .. whitelist[lp.UserId]
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.Font = Enum.Font.Code
title.BackgroundColor3 = Color3.fromRGB(25, 0, 0)
Instance.new("UICorner", title)

-- Поле ввода ID
local idInput = Instance.new("TextBox", main)
idInput.Size = UDim2.new(0, 240, 0, 35)
idInput.Position = UDim2.new(0.5, -120, 0, 55)
idInput.PlaceholderText = "ENTER IMAGE ID..."
idInput.Text = ""
idInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
idInput.TextColor3 = Color3.new(1, 1, 1)
idInput.Font = Enum.Font.Code
Instance.new("UICorner", idInput)

-- Консоль
local logBox = Instance.new("ScrollingFrame", main)
logBox.Size = UDim2.new(1, -20, 0, 160)
logBox.Position = UDim2.new(0, 10, 1, -170)
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
-- [3] ФУНКЦИОНАЛ
--------------------------------------------------

-- 1. Anti-Kick (Обход блокировки клиентом)
local function enableAntiKick()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if tostring(method) == "Kick" or tostring(method) == "kick" then
            log("ANTI-KICK: BLOCKED ATTEMPT", Color3.new(1, 1, 0))
            return nil
        end
        return old(self, ...)
    end)
    setreadonly(mt, true)
    log("ANTI-KICK: ACTIVATED", Color3.new(0, 1, 0))
end

-- 2. Remote Scanner (Поиск дыр в сервере)
local function scanRemotes()
    log("SCANNING FOR SERVER HOLES...", Color3.new(1, 1, 1))
    local count = 0
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            count = count + 1
            log("FOUND: " .. v.Name, Color3.new(0, 1, 1))
        end
    end
    log("TOTAL REMOTES: " .. count, Color3.new(1, 1, 0))
end

-- 3. Global Sky Injection (Попытка смены неба для всех)
local function globalSky(id)
    if id == "" or not tonumber(id) then log("ERROR: INVALID ID", Color3.new(1,0,0)) return end
    local asset = "rbxassetid://" .. id
    log("STARTING INJECTION: " .. id, Color3.new(1,1,1))
    
    -- Локальная смена
    local s = lighting:FindFirstChild("DevastatorSky") or Instance.new("Sky", lighting)
    s.Name = "DevastatorSky"
    s.SkyboxBk = asset s.SkyboxDn = asset s.SkyboxFt = asset
    s.SkyboxLf = asset s.SkyboxRt = asset s.SkyboxUp = asset

    -- Попытка пробиться на сервер
    local targets = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            if n:find("sky") or n:find("light") or n:find("weather") or n:find("env") or n:find("admin") then
                table.insert(targets, v)
            end
        end
    end

    task.spawn(function()
        for i, remote in pairs(targets) do
            pcall(function()
                remote:FireServer("Skybox", asset)
                remote:FireServer(asset)
                remote:FireServer("UpdateSky", asset)
            end)
            if i % 2 == 0 then task.wait(0.5) end -- Задержка для обхода анти-спама
        end
        log("INJECTION COMPLETE. CHECK OTHER DEVICES.", Color3.new(0, 1, 0))
    end)
end

--------------------------------------------------
-- [4] КНОПКИ
--------------------------------------------------
local btnFrame = Instance.new("Frame", main)
btnFrame.Size = UDim2.new(1, -20, 0, 120)
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
addBtn("SCAN REMOTES", scanRemotes)
addBtn("EXECUTE GLOBAL SKY", function() globalSky(idInput.Text) end)
addBtn("CRASH AUDIO", function()
    log("AUDIO CHAOS STARTED", Color3.new(1,0,0))
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Sound") then v:Play() v.Volume = 10 end
    end
end)
addBtn("VOID WORKSPACE", function()
    log("MAP PURGE INITIATED", Color3.new(1,1,1))
    for _, v in pairs(workspace:GetChildren()) do
        if not v:FindFirstChild("Humanoid") and v.Name ~= "Terrain" then v:Destroy() end
    end
end)

-- Скрытие меню (L)
uis.InputBegan:Connect(function(k, g)
    if not g and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
end)

log("DEVASTATOR v22 LOADED. PRESS 'L' TO HIDE.")
