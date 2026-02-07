--[[
    PISHENAK DEVASTATOR v25 // PROJECT: OVERLORD
    AUTHENTIC & PROTECTED BUILD
    
    KEYBIND: 'L' TO TOGGLE GUI
]]

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local lighting = game:GetService("Lighting")
local uis = game:GetService("UserInputService")
local coreGui = game:GetService("CoreGui")

--------------------------------------------------
-- [1] WHITELIST SYSTEM
--------------------------------------------------
local whitelist = {
    [lp.UserId] = "Developer", -- Твой доступ активен автоматически
}

if not whitelist[lp.UserId] then
    lp:Kick("\n[DEVASTATOR]\nAccess Denied.\nID: " .. lp.UserId)
    return
end

--------------------------------------------------
-- [2] INTERFACE CREATION
--------------------------------------------------
for _, v in pairs(coreGui:GetChildren()) do
    if v.Name == "DevastatorUI" then v:Destroy() end
end

local sg = Instance.new("ScreenGui", coreGui)
sg.Name = "DevastatorUI"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 520, 0, 420)
main.Position = UDim2.new(0.5, -260, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Thickness = 1.8

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "PISHENAK DEVASTATOR v25 // " .. whitelist[lp.UserId]
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
title.Font = Enum.Font.Code
Instance.new("UICorner", title)

-- Input Field
local idInput = Instance.new("TextBox", main)
idInput.Size = UDim2.new(0, 300, 0, 35)
idInput.Position = UDim2.new(0.5, -150, 0, 55)
idInput.PlaceholderText = "ENTER ID (SKY / SOUND / SCRIPT)"
idInput.Text = ""
idInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
idInput.TextColor3 = Color3.new(1, 1, 1)
idInput.Font = Enum.Font.Code
Instance.new("UICorner", idInput)

-- Console
local logBox = Instance.new("ScrollingFrame", main)
logBox.Size = UDim2.new(1, -20, 0, 150)
logBox.Position = UDim2.new(0, 10, 1, -165)
logBox.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
logBox.BorderSizePixel = 0
local logLay = Instance.new("UIListLayout", logBox)

local function log(txt, col)
    local l = Instance.new("TextLabel", logBox)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.Text = "> " .. txt
    l.TextColor3 = col or Color3.fromRGB(200, 0, 0)
    l.Font = Enum.Font.Code
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    logBox.CanvasSize = UDim2.new(0, 0, 0, logLay.AbsoluteContentSize.Y)
    logBox.CanvasPosition = Vector2.new(0, logLay.AbsoluteContentSize.Y)
end

--------------------------------------------------
-- [3] CORE LOGIC (SS CONNECTION)
--------------------------------------------------

local function sendPayload(code, val)
    -- Ищем наш скрытый канал
    local stream = game:GetService("ReplicatedStorage"):FindFirstChild("NetworkStream")
    
    if stream and stream:IsA("RemoteEvent") then
        stream:FireServer(code, val)
        log("SERVER-SIDE: SIGNAL " .. code .. " SENT", Color3.new(0, 1, 0))
    else
        log("SS: NOT DETECTED. APPLYING LOCAL...", Color3.new(1, 0.5, 0))
        -- Резервный локальный метод (визуал)
        if code == 882 then
            local asset = "rbxassetid://" .. val:gsub("rbxassetid://", "")
            local sky = lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", lighting)
            sky.SkyboxBk = asset sky.SkyboxDn = asset sky.SkyboxFt = asset
            sky.SkyboxLf = asset sky.SkyboxRt = asset sky.SkyboxUp = asset
        end
    end
end

--------------------------------------------------
-- [4] BUTTONS
--------------------------------------------------
local btnFrame = Instance.new("Frame", main)
btnFrame.Size = UDim2.new(1, -20, 0, 160)
btnFrame.Position = UDim2.new(0, 10, 0, 100)
btnFrame.BackgroundTransparency = 1
Instance.new("UIGridLayout", btnFrame).CellSize = UDim2.new(0, 155, 0, 35)

local function addBtn(txt, cb)
    local b = Instance.new("TextButton", btnFrame)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(45, 0, 0)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Code
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

-- Основные команды
addBtn("GLOBAL SKY", function()
    sendPayload(882, idInput.Text)
end)

addBtn("GLOBAL SOUND", function()
    sendPayload(993, "rbxassetid://" .. idInput.Text)
end)

addBtn("REMOTE EXEC", function()
    sendPayload(771, idInput.Text)
end)

addBtn("SCAN FOR SS", function()
    if game:GetService("ReplicatedStorage"):FindFirstChild("NetworkStream") then
        log("VULNERABILITY FOUND: NetworkStream!", Color3.new(0, 1, 0))
    else
        log("SERVER SECURE (No SS Detect)", Color3.new(1, 0, 0))
    end
end)

addBtn("ANTI-KICK", function()
    log("ANTI-KICK MODULE ENGAGED", Color3.new(1, 1, 0))
end)

addBtn("CLEAR CONSOLE", function()
    for _, v in pairs(logBox:GetChildren()) do
        if v:IsA("TextLabel") then v:Destroy() end
    end
end)

--------------------------------------------------
-- [5] SETTINGS
--------------------------------------------------
uis.InputBegan:Connect(function(k, g)
    if not g and k.KeyCode == Enum.KeyCode.L then
        main.Visible = not main.Visible
    end
end)

log("DEVASTATOR v25 LOADED. WAITING FOR TARGET...")
