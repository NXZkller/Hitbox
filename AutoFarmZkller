--// ZKLLER FULL RAID (COMPRA CON FRUTA BARATA + AUTO START + COMBATE)
--// Optimizado para Xeno

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

--// Configuración
getgenv().ZkllerRaidConfig = {
    Enabled = false,
    RaidType = "Flame", -- Raid inicial
    Distance = 8
}

--// FUNCIÓN PARA BUSCAR LA FRUTA MÁS BARATA
local function GetCheapestFruit()
    local cheapestFruit = nil
    local minPrice = math.huge
    
    -- Revisar el inventario (Backpack)
    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:find("Fruit") then
            -- Intentamos obtener el valor de la fruta (esto varía según la versión, usamos un chequeo estándar)
            -- Si no podemos leer el precio, elegimos frutas comunes conocidas
            local fruitName = tool.Name:lower()
            if fruitName:find("rocket") or fruitName:find("spin") or fruitName:find("chop") or fruitName:find("spring") then
                return tool.Name -- Retorna inmediatamente si encuentra una basura
            end
        end
    end
    return nil
end

--// FUNCIÓN PARA COMPRAR CHIP USANDO FRUTA
local function BuyChipWithFruit()
    local fruitToUse = GetCheapestFruit()
    
    if fruitToUse then
        -- Primero equipamos la fruta
        local tool = LocalPlayer.Backpack:FindFirstChild(fruitToUse)
        if tool then
            LocalPlayer.Character.Humanoid:EquipTool(tool)
            wait(0.5)
            -- Remote para comprar chip usando el item equipado
            ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsMaster", "ExchangeTicket", getgenv().ZkllerRaidConfig.RaidType)
            return true
        end
    else
        -- Si no hay fruta, intenta comprar con fragmentos por si acaso
        ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsMaster", "BuyChip", getgenv().ZkllerRaidConfig.RaidType)
        return true
    end
    return false
end

--// INTERFAZ PROFESIONAL
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 220, 0, 160)
Main.Position = UDim2.new(0.5, -110, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(30, 0, 0) -- Rojo oscuro (Peligro/Raid)
Main.Draggable = true
Main.Active = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "ZKLLER RAID BOT"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold

local BtnStart = Instance.new("TextButton", Main)
BtnStart.Size = UDim2.new(0, 180, 0, 50)
BtnStart.Position = UDim2.new(0.1, 0, 0.4, 0)
BtnStart.Text = "AUTO RAID (FRUIT)"
BtnStart.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
BtnStart.TextColor3 = Color3.new(1, 1, 1)

--// LÓGICA DE INICIO Y TELEPORT AL BOTÓN
local function StartRaidProcess()
    if BuyChipWithFruit() then
        wait(1)
        -- Teleport al botón de inicio (Cápsulas de Raid)
        local raidButton = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Circle")
        if raidButton then
            LocalPlayer.Character.HumanoidRootPart.CFrame = raidButton.CFrame
            wait(0.5)
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, raidButton, 0)
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, raidButton, 1)
        end
    end
end

--// BUCLE DE COMBATE (LIMPIAR ISLAS)
RunService.Stepped:Connect(function()
    if getgenv().ZkllerRaidConfig.Enabled then
        pcall(function()
            -- Buscar enemigos
            local target = nil
            local dist = math.huge
            for _, v in pairs(workspace:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                    -- Filtro para NPCs de Raid
                    if v.Name:find("Buster") or v.Name:find("Warrior") or v.Name:find("Commander") then
                        local mag = (LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                        if mag < dist then
                            target = v
                            dist = mag
                        end
                    end
                end
            end
            
            if target then
                -- Anti-Colisión
                for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
                -- Volar y Atacar
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, getgenv().ZkllerRaidConfig.Distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(999, 999))
            end
        end)
    end
end)

BtnStart.MouseButton1Click:Connect(function()
    getgenv().ZkllerRaidConfig.Enabled = not getgenv().ZkllerRaidConfig.Enabled
    if getgenv().ZkllerRaidConfig.Enabled then
        BtnStart.Text = "PROCESANDO..."
        StartRaidProcess()
    else
        BtnStart.Text = "AUTO RAID (FRUIT)"
    end
end)
