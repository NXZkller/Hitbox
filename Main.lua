if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

getgenv().HitboxSize = 20
getgenv().HitboxVisible = true
getgenv().EspEnabled = false

-- Limpiar versiones anteriores
if CoreGui:FindFirstChild("XenoHitboxSystem") then
    CoreGui:FindFirstChild("XenoHitboxSystem"):Destroy()
end

-- Interfaz
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "XenoHitboxSystem"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 180, 0, 200)
MainFrame.Position = UDim2.new(0.5, -90, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Draggable = true
MainFrame.Active = true

local Corner = Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "Hitbox: " .. getgenv().HitboxSize
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold

local BtnPlus = Instance.new("TextButton", MainFrame)
BtnPlus.Size = UDim2.new(0, 70, 0, 35)
BtnPlus.Position = UDim2.new(0.05, 0, 0.25, 0)
BtnPlus.Text = "+"
BtnPlus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BtnPlus.TextColor3 = Color3.new(0, 1, 0)

local BtnMinus = Instance.new("TextButton", MainFrame)
BtnMinus.Size = UDim2.new(0, 70, 0, 35)
BtnMinus.Position = UDim2.new(0.55, 0, 0.25, 0)
BtnMinus.Text = "-"
BtnMinus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BtnMinus.TextColor3 = Color3.new(1, 0, 0)

local BtnVis = Instance.new("TextButton", MainFrame)
BtnVis.Size = UDim2.new(0, 160, 0, 35)
BtnVis.Position = UDim2.new(0.05, 0, 0.50, 0)
BtnVis.Text = "Visible: SI"
BtnVis.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
BtnVis.TextColor3 = Color3.new(1, 1, 1)

local BtnEsp = Instance.new("TextButton", MainFrame)
BtnEsp.Size = UDim2.new(0, 160, 0, 35)
BtnEsp.Position = UDim2.new(0.05, 0, 0.75, 0)
BtnEsp.Text = "ESP: NO"
BtnEsp.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
BtnEsp.TextColor3 = Color3.new(1, 1, 1)

-- Tecla RShift para ocultar
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Eventos de botones
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

-- Lógica de un solo Cubo Gris con daño total
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            pcall(function()
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    -- Un solo cubo gris
                    root.Size = Vector3.new(getgenv().HitboxSize, getgenv().HitboxSize, getgenv().HitboxSize)
                    root.Transparency = getgenv().HitboxVisible and 0.8 or 1
                    root.Color = Color3.fromRGB(150, 150, 150)
                    root.Shape = Enum.PartType.Block
                    root.CanCollide = false
                    root.CanTouch = true
                    root.CanQuery = true -- Necesario para habilidades

                    -- Forzar que el daño de habilidades cuente
                    if not root:FindFirstChild("TouchInterest") then
                        Instance.new("TouchInterest", root)
                    end
                end

                -- Mantener las demás partes pequeñas pero con CanTouch activo
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanTouch = true
                        part.CanQuery = true
                    end
                end
            end)
        end
    end
end)
