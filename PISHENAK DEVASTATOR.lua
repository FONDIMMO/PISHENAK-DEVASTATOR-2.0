--[[
    DEVASTATOR v36.0 // STEALTH MODE
    ИСПРАВЛЕНО: Рандомные задержки для обхода детекторов спама.
]]

pcall(function()
    local p = game:GetService("Players")
    local lp = p.LocalPlayer
    local uis = game:GetService("UserInputService")
    local cg = game:GetService("CoreGui")

    if cg:FindFirstChild("DevStealth") then cg.DevStealth:Destroy() end
    local sg = Instance.new("ScreenGui", cg) sg.Name = "DevStealth"

    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 420, 0, 400)
    main.Position = UDim2.new(0.5, -210, 0.5, -200)
    main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    main.Active = true main.Draggable = true
    Instance.new("UICorner", main)
    local stroke = Instance.new("UIStroke", main) stroke.Color = Color3.new(0, 1, 0)

    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = " DEVASTATOR v36.0 // STEALTH ACTIVE "
    title.BackgroundColor3 = Color3.fromRGB(0, 50, 0)
    title.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", title)

    local inp = Instance.new("TextBox", main)
    inp.Size = UDim2.new(1, -20, 0, 35)
    inp.Position = UDim2.new(0, 10, 0, 50)
    inp.PlaceholderText = "ID (НАПРИМЕР: 109251560)"
    inp.Text = ""
    inp.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    inp.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", inp)

    -- ФУНКЦИЯ СКРЫТНОЙ АТАКИ
    local function stealth_attack(id, val)
        print("--- ЗАПУСК СКРЫТНОЙ ПРОВЕРКИ ---")
        local remotes = {}
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") then table.insert(remotes, v) end
        end

        task.spawn(function()
            for i, remote in pairs(remotes) do
                -- Случайная задержка от 0.5 до 1.5 секунд
                task.wait(math.random(5, 15) / 10) 
                print("Проверка эвента: " .. remote.Name)
                pcall(function() 
                    remote:FireServer(id, val)
                    remote:FireServer(val)
                end)
            end
        end)
    end

    local g = Instance.new("Frame", main)
    g.Size = UDim2.new(1, -20, 0, 250)
    g.Position = UDim2.new(0, 10, 0, 100)
    g.BackgroundTransparency = 1
    Instance.new("UIGridLayout", g).CellSize = UDim2.new(0, 190, 0, 40)

    local function btn(txt, cb)
        local b = Instance.new("TextButton", g)
        b.Text = txt
        b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.Code
        b.MouseButton1Click:Connect(cb)
        Instance.new("UICorner", b)
    end

    btn("SKY (STEALTH)", function() stealth_attack(882, "rbxassetid://"..inp.Text) end)
    btn("AUDIO (STEALTH)", function() stealth_attack(993, "rbxassetid://"..inp.Text) end)
    btn("GIVE B-TOOLS", function() Instance.new("HopperBin", lp.Backpack).BinType = 4 end)
    btn("VOID ESCAPE", function() lp.Character.HumanoidRootPart.CFrame = CFrame.new(0, 5000, 0) end)

    print("--- v36.0 ЗАГРУЖЕН. РАБОТАЙТЕ АККУРАТНО ---")
end)
