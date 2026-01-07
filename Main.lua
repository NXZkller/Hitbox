if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

getgenv().HitboxSize = 20 -- Tamaño recomendado para TTK
getgenv().HitboxEnabled = true
getgenv().HitboxVisible = true
getgenv().EspEnabled = false

if CoreGui:FindFirstChild("XenoHitboxSystem") then
    CoreGui:FindFirstChild("XenoHitboxSystem"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XenoHitboxSystem"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 180, 0, 200)
MainFrame.Position = UDim2.new(0.5, -90, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "Hitbox: " .. getgenv().HitboxSize
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local BtnPlus = Instance.new("TextButton")
BtnPlus.Size = UDim2.new(0, 70, 0, 35)
BtnPlus.Position = UDim2.new(0.05, 0, 0.25, 0)
BtnPlus.Text = "+"
BtnPlus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BtnPlus.TextColor3 = Color3.new(0, 1, 0)
BtnPlus.Parent = MainFrame

local BtnMinus = Instance.new("TextButton")
BtnMinus.Size = UDim2.new(0, 70, 0, 35)
BtnMinus.Position = UDim2.new(0.55, 0, 0.25, 0)
BtnMinus.Text = "-"
BtnMinus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BtnMinus.TextColor3 = Color3.new(1, 0, 0)
BtnMinus.Parent = MainFrame

local BtnVis = Instance.new("TextButton")
BtnVis.Size = UDim2.new(0, 160, 0, 35)
BtnVis.Position = UDim2.new(0.05, 0, 0.50, 0)
BtnVis.Text = "Visible: SI"
BtnVis.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
BtnVis.TextColor3 = Color3.new(1, 1, 1)
BtnVis.Parent = MainFrame

local BtnEsp = Instance.new("TextButton")
BtnEsp.Size = UDim2.new(0, 160, 0, 35)
BtnEsp.Position = UDim2.new(0.05, 0, 0.75, 0)
BtnEsp.Text = "ESP: NO"
BtnEsp.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
BtnEsp.TextColor3 = Color3.new(1, 1, 1)
BtnEsp.Parent = MainFrame

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

BtnPlus.MouseButton1Click:Connect(function()
    getgenv().HitboxSize = getgenv().HitboxSize + 5
    Title.Text = "Hitbox: " .. getgenv().HitboxSize
end)

BtnMinus.MouseButton1Click:Connect(function()
    if getgenv().HitboxSize > 5 then
        getgenv().HitboxSize = getgenv().HitboxSize - 5
    end
    Title.Text = "Hitbox: " .. getgenv().HitboxSize
end)

BtnVis.MouseButton1Click:Connect(function()
    getgenv().HitboxVisible = not getgenv().HitboxVisible
    BtnVis.Text = getgenv().HitboxVisible and "Visible: SI" or "Visible: NO"
end)

BtnEsp.MouseButton1Click:Connect(function()
    getgenv().EspEnabled = not getgenv().EspEnabled
    BtnEsp.Text = getgenv().EspEnabled and "ESP: SI" or "ESP: NO"
end)

-- Bucle de alto rendimiento para Proyectiles y Habilidades (TTK FIX)
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        pcall(function()
            if player ~= LocalPlayer and player.Character then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                local hum = player.Character:FindFirstChild("Humanoid")
                
                if root and hum and hum.Health > 0 then
                    -- Ajustes para que las habilidades detecten el golpe
                    root.Size = Vector3.new(getgenv().HitboxSize, getgenv().HitboxSize, getgenv().HitboxSize)
                    root.Transparency = getgenv().HitboxVisible and 0.8 or 1
                    root.Color = Color3.fromRGB(150, 150, 150)
                    root.Shape = Enum.PartType.Block
                    
                    -- PROPIEDADES PARA HABILIDADES LANZADAS:
                    root.CanCollide = false
                    root.CanTouch = true    -- Detecta contacto físico (Espadas)
                    root.CanQuery = true    -- Detecta Raycasts (Proyectiles como la X de TTK)
                    root.Massless = true
                    
                    -- Forzar que la hitbox sea la pieza principal de colisión
                    if root:FindFirstChild("TouchInterest") == nil then
                        Instance.new("TouchInterest", root)
                    end
                end
            end
        end)
    end
end)
