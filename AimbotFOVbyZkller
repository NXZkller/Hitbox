--// Xeno Compatible Aimbot FOV
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Camera = workspace.CurrentCamera

--// Configuración Global
getgenv().AimbotEnabled = true
getgenv().FovRadius = 120
getgenv().Smoothing = 0.15

--// Círculo FOV (Optimizado para Xeno)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = true
FOVCircle.Thickness = 0.5
FOVCircle.Color = Color3.new(1, 1, 1) -- Blanco puro
FOVCircle.Transparency = 1
FOVCircle.NumSides = 100
FOVCircle.Filled = false

--// Interfaz del Menú (Compatible con Xeno)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZkllerXeno"
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 180, 0, 140)
MainFrame.Position = UDim2.new(0.85, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "FOV: " .. getgenv().FovRadius
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1

local BtnPlus = Instance.new("TextButton", MainFrame)
BtnPlus.Size = UDim2.new(0, 70, 0, 30)
BtnPlus.Position = UDim2.new(0.1, 0, 0.3, 0)
BtnPlus.Text = "+"

local BtnMinus = Instance.new("TextButton", MainFrame)
BtnMinus.Size = UDim2.new(0, 70, 0, 30)
BtnMinus.Position = UDim2.new(0.55, 0, 0.3, 0)
BtnMinus.Text = "-"

--// Funciones de Control
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp then
        if input.KeyCode == Enum.KeyCode.F5 then
            getgenv().AimbotEnabled = not getgenv().AimbotEnabled
            StarterGui:SetCore("SendNotification", {
                Title = "Zkller Aimbot",
                Text = getgenv().AimbotEnabled and "ACTIVADO" or "DESACTIVADO",
                Duration = 2
            })
        elseif input.KeyCode == Enum.KeyCode.Delete then
            MainFrame.Visible = not MainFrame.Visible
            FOVCircle.Visible = MainFrame.Visible
        end
    end
end)

BtnPlus.MouseButton1Click:Connect(function()
    getgenv().FovRadius = getgenv().FovRadius + 10
    Title.Text = "FOV: " .. getgenv().FovRadius
end)

BtnMinus.MouseButton1Click:Connect(function()
    getgenv().FovRadius = math.max(10, getgenv().FovRadius - 10)
    Title.Text = "FOV: " .. getgenv().FovRadius
end)

--// Bucle Aimbot
RunService.RenderStepped:Connect(function()
    local MousePos = UserInputService:GetMouseLocation()
    FOVCircle.Position = MousePos
    FOVCircle.Radius = getgenv().FovRadius
    
    if getgenv().AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local Target = nil
        local Closest = getgenv().FovRadius
        
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local Pos, OnScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                if OnScreen then
                    local Dist = (Vector2.new(Pos.X, Pos.Y) - MousePos).Magnitude
                    if Dist < Closest then
                        Closest = Dist
                        Target = v.Character.HumanoidRootPart
                    end
                end
            end
        end
        
        if Target then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Target.Position), getgenv().Smoothing)
        end
    end
end)
