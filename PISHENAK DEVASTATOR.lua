--[[
    PISHENAK DEVASTATOR v20.1 // FULL PREMIUM BUILD
    FIXED: ID INJECTION, ANTI-KICK, FULL UI
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

--------------------------------------------------
-- СИСТЕМА ЗАЩИТЫ (WHITELIST)
--------------------------------------------------
local whitelist = {
    [lp.UserId] = "Developer", -- Твой ID подхватится автоматически
    [123456789] = "Customer_1", -- Сюда добавляй покупателей
}

if not whitelist[lp.UserId] then
    lp:Kick("\n[DEVASTATOR ERROR]\nLicense Not Found.\nYour ID: " .. lp.UserId)
    return
end

--------------------------------------------------
-- ИНИЦИАЛИЗАЦИЯ
--------------------------------------------------
local coreGui = game:GetService("CoreGui")
local lighting = game:GetService("Lighting")
local uis = game:GetService("UserInputService")

for _, v in pairs(coreGui:GetChildren()) do
    if v.Name == "DevastatorV20" then v:Destroy() end
end

local sg = Instance.new("ScreenGui", coreGui)
sg.Name = "DevastatorV20"

-- ГЛАВНОЕ ОКНО
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 550, 0, 420)
main.Position = UDim2.new(0.5, -275, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Thickness = 2

-- ЗАГОЛОВОК
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "DEVASTATOR v20.1 // USER: " .. whitelist[lp.UserId]
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.Font = Enum.Font.Code
title.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
Instance.new("UICorner", title)

-- ПОЛЕ ВВОДА ID
local idInput = Instance.new("TextBox", main)
idInput.Size = UDim2.new(0, 220, 0, 35)
idInput.Position = UDim2.new(0.5, -110, 0, 60)
idInput.PlaceholderText = "ВСТАВЬ ID НЕБА..."
idInput.Text = ""
idInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
idInput.TextColor3 = Color3.new(1,1,1)
idInput.Font = Enum.Font.Code
Instance.new("UICorner", idInput)

-- КОНСОЛЬ (LOGS)
local logBox = Instance.new("ScrollingFrame", main)
logBox.Size = UDim2.new(1, -20, 0, 150)
logBox.Position = UDim2.new(0, 10, 1, -160)
logBox.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
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

--------------------------------------------------
-- ЛОГИКА (ФУНКЦИИ)
--------------------------------------------------

-- ANTI-KICK
local function enableAntiKick()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if tostring(method) == "Kick" or tostring(method) == "kick" then
            log("ANTI-KICK: БЛОКИРОВКА КИКА", Color3.new(1, 1, 0))
            return nil
        end
        return old(self, ...)
    end)
    setreadonly(mt, true)
    log("ANTI-KICK СИСТЕМА АКТИВНА", Color3.new(0, 1, 0))
end

-- SECURE INJECTION (НЕБО)
local function secureInject(id)
    if id == "" or not tonumber(id) then 
        log("ОШИБКА: НЕВЕРНЫЙ ID", Color3.new(1,0,0))
        return 
    end
    
    local asset = "rbxassetid://" .. id
    log("ЗАПУСК ИНЪЕКЦИИ: " .. id, Color3.new(1,1,1))
    
    -- Локально
    local s = lighting:FindFirstChild("DevastatorSky") or Instance.new("Sky", lighting)
    s.Name = "DevastatorSky"
    s.SkyboxBk = asset s.SkyboxDn = asset s.SkyboxFt = asset
    s.SkyboxLf = asset s.SkyboxRt = asset s.SkyboxUp = asset

    -- Поиск Remotes
    local targets = {}
    for _, v in pairs(game:GetDescendants()) do
        pcall(function()
            if v:IsA("RemoteEvent") then
                local n = v.Name:lower()
                if n:find("sky") or n:find("light") or n:find("weather") or n:find("admin") then
                    table.insert(targets, v)
                end
            end
        end)
    end

    log("НАЙДЕНО СОБЫТИЙ: " .. #targets, Color3.new(1, 0.5, 0))

    task.spawn(function()
        for i, remote in pairs(targets) do
            pcall(function()
                remote:FireServer("Skybox", asset)
                remote:FireServer(asset)
                remote:FireServer("Update", {["Skybox"] = asset})
            end)
            if i % 2 == 0 then task.wait(0.4) end -- Задержка от кика
        end
        log("ИНЪЕКЦИЯ ЗАВЕРШЕНА", Color3.new(0, 1, 0))
    end)
end

--------------------------------------------------
-- КНОПКИ УПРАВЛЕНИЯ
--------------------------------------------------
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

addBtn("EXECUTE GLOBAL SKY", function()
    secureInject(idInput.Text)
end)

addBtn("CRASH ALL AUDIO", function()
    log("СПАМ ЗВУКОМ...", Color3.new(1,0,0))
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Sound") then v:Play() v.Volume = 10 end
    end
end)

addBtn("VOID WORKSPACE", function()
    log("УДАЛЕНИЕ КАРТЫ...", Color3.new(1,1,1))
    for _, v in pairs(workspace:GetChildren()) do
        if not v:FindFirstChild("Humanoid") and v.Name ~= "Terrain" then v:Destroy() end
    end
end)

-- СКРЫТИЕ (L)
uis.InputBegan:Connect(function(k, g)
    if not g and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
end)

log("DEVASTATOR v20.1 READY.", Color3.new(0, 1, 0))
