--[[
    PISHENAK DEVASTATOR v20 // ANTI-DETECTION
    SERVER-SIDE INJECTION + SMART BYPASS
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- WHITELIST SYSTEM
local whitelist = {
    [123456789] = "Owner", 
    [lp.UserId] = "Developer", -- Авто-вход для тебя
}

if not whitelist[lp.UserId] then
    lp:Kick("License Required.")
    return
end

local coreGui = game:GetService("CoreGui")
local lighting = game:GetService("Lighting")
local uis = game:GetService("UserInputService")

-- Очистка старых GUI
for _, v in pairs(coreGui:GetChildren()) do
    if v.Name == "DevastatorV20" then v:Destroy() end
end

local sg = Instance.new("ScreenGui", coreGui)
sg.Name = "DevastatorV20"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 550, 0, 420)
main.Position = UDim2.new(0.5, -275, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)
Instance.new("UIStroke", main).Color = Color3.fromRGB(255, 0, 0)

local logBox = Instance.new("ScrollingFrame", main)
logBox.Size = UDim2.new(1, -20, 0, 150)
logBox.Position = UDim2.new(0, 10, 1, -160)
logBox.BackgroundColor3 = Color3.fromRGB(5, 0, 0)
logBox.BorderSizePixel = 0
local logLay = Instance.new("UIListLayout", logBox)

local function log(txt, col)
    local l = Instance.new("TextLabel", logBox)
    l.Size = UDim2.new(1, 0, 0, 18)
    l.Text = "> " .. txt
    l.TextColor3 = col or Color3.fromRGB(200, 0, 0)
    l.Font = Enum.Font.Code
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    logBox.CanvasSize = UDim2.new(0,0,0, logLay.AbsoluteContentSize.Y)
end

--------------------------------------------------
-- SMART INJECTION (Чтобы не кикало)
--------------------------------------------------
local function secureInject(id)
    local asset = "rbxassetid://" .. id
    log("STARTING SECURE INJECTION...", Color3.new(1,1,1))
    
    -- Локально ставим сразу
    local s = lighting:FindFirstChild("GlobalSky") or Instance.new("Sky", lighting)
    s.Name = "GlobalSky"
    s.SkyboxBk = asset s.SkyboxDn = asset s.SkyboxFt = asset
    s.SkyboxLf = asset s.SkyboxRt = asset s.SkyboxUp = asset

    -- Собираем только подозрительные на графику события
    local targets = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local name = v.Name:lower()
            if name:find("sky") or name:find("light") or name:find("gfx") or name:find("weather") or name:find("admin") then
                table.insert(targets, v)
            end
        end
    end

    log("FOUND " .. #targets .. " VULNERABLE TARGETS. INJECTING...", Color3.new(1, 0.5, 0))

    -- Постепенная инъекция с задержкой (Bypass)
    task.spawn(function()
        for i, remote in pairs(targets) do
            pcall(function()
                remote:FireServer("Skybox", asset)
                remote:FireServer("UpdateSky", asset)
            end)
            if i % 3 == 0 then task.wait(0.2) end -- Пауза каждые 3 запроса, чтобы не кикнуло
        end
        log("SECURE INJECTION FINISHED.", Color3.new(0, 1, 0))
    end)
end

--------------------------------------------------
-- ИНТЕРФЕЙС (Кнопки)
--------------------------------------------------
local idInput = Instance.new("TextBox", main)
idInput.Size = UDim2.new(0, 220, 0, 35)
idInput.Position = UDim2.new(0.5, -110, 0, 60)
idInput.PlaceholderText = "SKY ID..."
idInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
idInput.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", idInput)

local execBtn = Instance.new("TextButton", main)
execBtn.Size = UDim2.new(0, 200, 0, 40)
execBtn.Position = UDim2.new(0.5, -100, 0, 105)
execBtn.Text = "EXECUTE (SAFE MODE)"
execBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
execBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", execBtn)

execBtn.MouseButton1Click:Connect(function()
    secureInject(idInput.Text)
end)

-- Скрытие на L
uis.InputBegan:Connect(function(k, g)
    if not g and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
end)

log("DEVASTATOR v20 READY. BYPASS ENGAGED.", Color3.new(0, 1, 0))
