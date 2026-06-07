
pcall(function()
    game.CoreGui:FindFirstChild("HongSonChestUI"):Destroy()
end)

local Gui = Instance.new("ScreenGui")
Gui.Name = "HongSonChestUI"
Gui.ResetOnSpawn = false
Gui.Parent = game.CoreGui

local Auto = false
local running = false
local Main = Instance.new("Frame")
Main.Parent = Gui
Main.Size = UDim2.new(0, 300, 0, 160)
Main.Position = UDim2.new(0.05, 0, 0.25, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Main.BorderSizePixel = 0
Main.Active = true
pcall(function() Main.Draggable = true end)

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local Stroke = Instance.new("UIStroke")
Stroke.Parent = Main
Stroke.Thickness = 1.5
Stroke.Color = Color3.fromRGB(120, 120, 160)
local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -20, 0, 32)
Title.Position = UDim2.new(0, 10, 0, 8)
Title.Font = Enum.Font.GothamBold
Title.Text = "💎 HongSon Chest"
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextColor3 = Color3.new(1,1,1)
local Status = Instance.new("TextLabel")
Status.Parent = Main
Status.BackgroundTransparency = 1
Status.Size = UDim2.new(1, -20, 0, 20)
Status.Position = UDim2.new(0, 10, 0, 42)
Status.Font = Enum.Font.Gotham
Status.Text = "Status: OFF"
Status.TextSize = 14
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.TextColor3 = Color3.fromRGB(180,180,180)
local Toggle = Instance.new("TextButton")
Toggle.Parent = Main
Toggle.Size = UDim2.new(0, 220, 0, 48)
Toggle.Position = UDim2.new(0.5, -110, 1, -65)
Toggle.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
Toggle.Text = "OFF"
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 20
Toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 12)
local Close = Instance.new("TextButton")
Close.Parent = Main
Close.Size = UDim2.new(0, 28, 0, 28)
Close.Position = UDim2.new(1, -34, 0, 8)
Close.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 16
Close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Close).CornerRadius = UDim.new(1, 0)
local Minimize = Instance.new("TextButton")
Minimize.Parent = Main
Minimize.Size = UDim2.new(0, 28, 0, 28)
Minimize.Position = UDim2.new(1, -68, 0, 8)
Minimize.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
Minimize.Text = "-"
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 18
Minimize.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Minimize).CornerRadius = UDim.new(1, 0)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Parent = Gui
OpenBtn.Size = UDim2.new(0, 40, 0, 40)
OpenBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 90)
OpenBtn.Text = "+"
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 22
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.Visible = false
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

local function loop()
    task.spawn(function()
        while running do
            task.wait(0.2)

            local cam = workspace.CurrentCamera
            local char = cam.CameraSubject and cam.CameraSubject.Parent
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            if char then
                for _, v in ipairs(workspace:GetDescendants()) do
                    if not running then return end

                    if v.Name == "TreasureChest" and v:IsA("Model") then
                        local pos = v:FindFirstChild("Pos1", true)

                        if pos then
                            char:PivotTo(pos.CFrame + Vector3.new(0, 3, 0))

                            if hum then
                                hum.Jump = true
                            end

                            task.wait(0.5)
                        end
                    end
                end
            end
        end
    end)
end

local function setState(state)
    Auto = state

    if Auto then
        running = true
        Toggle.Text = "ON"
        Toggle.BackgroundColor3 = Color3.fromRGB(60, 180, 90)
        Status.Text = "Status: ON"
        loop()
    else
        running = false
        Toggle.Text = "OFF"
        Toggle.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
        Status.Text = "Status: OFF"
    end
end

Toggle.MouseButton1Click:Connect(function()
    setState(not Auto)
end)


Close.MouseButton1Click:Connect(function()
    running = false
    Auto = false
    Gui:Destroy()
end)


Minimize.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenBtn.Visible = false
end)

-- source : Nguyen Hong Son
