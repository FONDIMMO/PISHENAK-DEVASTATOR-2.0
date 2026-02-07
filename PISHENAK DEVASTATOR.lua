-- УМНАЯ ИНЪЕКЦИЯ v20.1 (Исправление ID)
local function secureInject(id)
    -- Авто-исправление формата ID
    local asset = "rbxassetid://" .. id
    if not tonumber(id) then 
        log("ОШИБКА: ID должен состоять из цифр!", Color3.new(1,0,0))
        return 
    end

    log("ИНЪЕКЦИЯ ID: " .. id .. " ЗАПУЩЕНА", Color3.new(1,1,1))
    
    -- 1. ЛОКАЛЬНАЯ УСТАНОВКА (Чтобы ты сразу видел результат)
    local function applySky(parent)
        local s = parent:FindFirstChild("DevastatorSky") or Instance.new("Sky")
        s.Name = "DevastatorSky"
        s.Parent = parent
        s.SkyboxBk = asset s.SkyboxDn = asset s.SkyboxFt = asset
        s.SkyboxLf = asset s.SkyboxRt = asset s.SkyboxUp = asset
        s.SunTextureId = asset -- Дополнительный хаос: солнце тоже картинка
    end
    applySky(lighting)

    -- 2. ПОИСК УЯЗВИМЫХ СОБЫТИЙ
    local targets = {}
    for _, v in pairs(game:GetDescendants()) do
        pcall(function()
            if v:IsA("RemoteEvent") then
                local n = v.Name:lower()
                -- Расширенный поиск "дырявых" имен
                if n:find("sky") or n:find("light") or n:find("gfx") or n:find("env") or n:find("weather") or n:find("set") then
                    table.insert(targets, v)
                end
            end
        end)
    end

    -- 3. БЕЗОПАСНАЯ ОТПРАВКА (Bypass Anti-Cheat)
    task.spawn(function()
        for i, remote in pairs(targets) do
            pcall(function()
                -- Пробуем разные варианты аргументов (Bruteforce)
                remote:FireServer("Skybox", asset)
                remote:FireServer(asset)
                remote:FireServer("Update", {["Skybox"] = asset})
            end)
            
            if i % 2 == 0 then task.wait(0.3) end -- Задержка для обхода кика
        end
        log("ИНЪЕКЦИЯ ЗАВЕРШЕНА. Если небо не у всех - игра защищена.", Color3.new(0, 1, 0))
    end)
end
