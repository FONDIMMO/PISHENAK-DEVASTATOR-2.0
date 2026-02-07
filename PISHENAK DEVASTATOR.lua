--[[
    DEVASTATOR v27.5 // TARGET SELECTOR
    ФУНКЦИЯ: Позволяет выбирать конкретный эвент из списка 58 найденных.
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local cg = game:GetService("CoreGui")

if cg:FindFirstChild("DevTarget") then cg.DevTarget:Destroy() end
local sg = Instance.new("ScreenGui", cg) sg.Name = "DevTarget"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 520, 0, 550)
main.Position = UDim2.new(0.5, -260, 0.5, -275)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Active = true main.Draggable = true
Instance.new("UICorner", main)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = " DEVASTATOR v27.5 // SELECT TARGET"
title.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.Code
Instance.new("UICorner", title)

-- ПОЛЕ ВВОДА ID
local inp = Instance.new("TextBox", main)
inp.Size = UDim2.new(1, -20, 0, 35)
inp.Position = UDim2.new(0, 10, 0, 50)
inp.PlaceholderText = "ВВЕДИ ID НЕБА (например: 109251560)"
inp.Text = ""
inp.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inp.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", inp)

-- СПИСОК ЦЕЛЕЙ (SCROLL)
local t_list = Instance.new("ScrollingFrame", main)
t_list.Size = UDim2.new(1, -20, 0, 300)
t_list.Position = UDim2.new(0, 10, 0, 95)
t_list.BackgroundColor3 = Color3.new(0, 0, 0)
local t_lay = Instance.new("UIListLayout", t_list)

local function log_btn(remote)
    local b = Instance.new("TextButton", t_list)
    b.Size = UDim2.new(1, 0, 0, 30)
    b.Text = "TRY: " .. remote.Name
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Code
    
    b.MouseButton1Click:Connect(function()
        b.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        local id = "rbxassetid://" .. inp.Text
        -- Пробуем сменить небо через ЭТОТ конкретный эвент
        pcall(function() remote:FireServer(882, id) end)
        pcall(function() remote:FireServer(id) end)
        print("Tested: " .. remote.Name)
    end)
end

-- КНОПКА ЗАПОЛНЕНИЯ СПИСКА
local refresh = Instance.new("TextButton", main)
refresh.Size = UDim2.new(1, -20, 0, 40)
refresh.Position = UDim2.new(0, 10, 1, -50)
refresh.Text = "FIND ALL 58 TARGETS"
refresh.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
refresh.TextColor3 = Color3.new(1, 1, 1)
refresh.MouseButton1Click:Connect(function()
    for _, v in pairs(t_list:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then log_btn(v) end
    end
end)

log("READY. USE REFRESH TO SEE TARGETS.")
