if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

getgenv().HitboxSize = 10
getgenv().HitboxEnabled = true

if CoreGui:FindFirstChild("XenoHitboxSystem") then
    CoreGui:FindFirstChild("XenoHitboxSystem"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XenoHitboxSystem"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 180, 0, 120)
MainFrame.Position = UDim2.new(0.5, -90, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "Hitbox: " .. getgenv().HitboxSize
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local BtnPlus = Instance.new("TextButton")
BtnPlus.Size = UDim2.new(0, 60, 0, 40)
BtnPlus.Position = UDim2.new(0.1, 0, 0.4, 0)
BtnPlus.Text = "+"
BtnPlus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BtnPlus.TextColor3 = Color3.new(0, 1, 0)
BtnPlus.Font = Enum.Font.GothamBold
BtnPlus.Parent = MainFrame

local BtnMinus = Instance.new("TextButton")
BtnMinus.Size = UDim2.new(0, 60, 0, 40)
BtnMinus.Position = UDim2.new(0.55, 0, 0.4, 0)
BtnMinus.Text = "-"
BtnMinus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BtnMinus.TextColor3 = Color3.new(1, 0, 0)
BtnMinus.Font = Enum.Font.GothamBold
BtnMinus.Parent = MainFrame

local function UpdateUI()
    Title.Text = "Hitbox: " .. getgenv().HitboxSize
end

BtnPlus.MouseButton1Click:Connect(function()
    getgenv().HitboxSize = getgenv().HitboxSize + 5
    UpdateUI()
end)

BtnMinus.MouseButton1Click:Connect(function()
    if getgenv().HitboxSize > 5 then
        getgenv().HitboxSize = getgenv().HitboxSize - 5
    else
        getgenv().HitboxSize = 2
    end
    UpdateUI()
end)

RunService.RenderStepped:Connect(function()
    if getgenv().HitboxEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            pcall(function()
                if player ~= LocalPlayer and player.Character then
                    local root = player.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.Size = Vector3.new(getgenv().HitboxSize, getgenv().HitboxSize, getgenv().HitboxSize)
                        root.Transparency = 0.8
                        root.Shape = Enum.PartType.Ball
                        root.Color = Color3.fromRGB(255, 0, 0)
                        root.CanCollide = false
                        root.Massless = true
                    end
                end
            end)
        end
    end
end)
