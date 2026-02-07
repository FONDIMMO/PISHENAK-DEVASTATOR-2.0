-- [[ СКОПИРУЙ ВЕСЬ КОД НИЖЕ ]]
pcall(function()
    local p = game:GetService("Players")
    local lp = p.LocalPlayer
    local rs = game:GetService("ReplicatedStorage")
    local uis = game:GetService("UserInputService")
    local cg = game:GetService("CoreGui")

    -- Очистка старых версий
    if cg:FindFirstChild("DevReboot") then cg.DevReboot:Destroy() end
    
    local sg = Instance.new("ScreenGui", cg)
    sg.Name = "DevReboot"

    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 400, 0, 450)
    main.Position = UDim2.new(0.5, -200, 0.5, -225)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    main.Active = true
    main.Draggable = true
    Instance.new("UICorner", main)

    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = "DEVASTATOR v35.0 // REBOOT"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    Instance.new("UICorner", title)

    -- ПОЛЕ ВВОДА
    local inp = Instance.new("TextBox", main)
    inp.Size = UDim2.new(1, -20, 0, 35)
    inp.Position = UDim2.new(0, 10, 0, 50)
    inp.PlaceholderText = "ID (НЕБО/ЗВУК)"
    inp.Text = ""
    inp.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    inp.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", inp)

    -- ФУНКЦИЯ АТАКИ
    local function bomb(id, val)
        local c = 0
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") then
                c = c + 1
                task.spawn(function()
                    task.wait(c * 0.1)
                    pcall(function() v:FireServer(id, val) end)
                    pcall(function() v:FireServer(val) end)
                end)
            end
        end
    end

    -- КНОПКИ
    local g = Instance.new("Frame", main)
    g.Size = UDim2.new(1, -20, 0, 300)
    g.Position = UDim2.new(0, 10, 0, 100)
    g.BackgroundTransparency = 1
    local layout = Instance.new("UIGridLayout", g)
    layout.CellSize = UDim2.new(0, 180, 0, 35)

    local function btn(txt, cb)
        local b = Instance.new("TextButton", g)
        b.Text = txt
        b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.Code
        b.MouseButton1Click:Connect(cb)
        Instance.new("UICorner", b)
    end

    btn("SKY (GLOBAL)", function() bomb(882, "rbxassetid://"..inp.Text) end)
    btn("AUDIO (GLOBAL)", function() bomb(993, "rbxassetid://"..inp.Text) end)
    btn("KILL ALL", function() bomb(771, "for _,v in pairs(game.Players:GetPlayers()) do v.Character:BreakJoints() end") end)
    btn("NUKE", function() bomb(771, "workspace:ClearAllChildren()") end)
    btn("B-TOOLS", function() Instance.new("HopperBin", lp.Backpack).BinType = 4 end)
    btn("FLY (E)", function() print("Use E to fly") end)

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
        end
    end)

    print("--- DEVASTATOR ЗАПУЩЕН УСПЕШНО ---")
end)
