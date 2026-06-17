-- ============================================
-- FLY SYSTEM - MOBILE FULL MENU
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- ============================================
-- FLY VARIABLES
-- ============================================
local FlyEnabled = false
local FlySpeed = 100
local FlyConnection = nil

-- Mobile input
local MoveX = 0
local MoveZ = 0
local MoveY = 0
local IsJumping = false

-- Fly components
local FlyLinearVelocity = nil
local FlyAlignOrientation = nil
local FlyAttachment = nil

-- ============================================
-- CREATE MENU UI
-- ============================================
local function CreateFlyMenu()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FlyMenu"
    screenGui.Parent = player.PlayerGui
    screenGui.ResetOnSpawn = false

    -- MAIN FRAME
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 320, 0, 480)
    mainFrame.Position = UDim2.new(0.5, -160, 0.5, -240)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BackgroundTransparency = 0.15
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = false
    mainFrame.Parent = screenGui

    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = mainFrame

    -- Shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://13160447275"
    shadow.ImageTransparency = 0.6
    shadow.ZIndex = -1
    shadow.Parent = mainFrame

    -- TITLE
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -40, 0, 50)
    title.Position = UDim2.new(0, 20, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "✈ FLY MODE"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame

    -- SEPARATOR
    local separator = Instance.new("Frame")
    separator.Size = UDim2.new(1, -40, 0, 2)
    separator.Position = UDim2.new(0, 20, 0, 70)
    separator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    separator.BackgroundTransparency = 0.3
    separator.Parent = mainFrame

    -- TOGGLE BUTTON
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleBtn"
    toggleBtn.Size = UDim2.new(1, -40, 0, 55)
    toggleBtn.Position = UDim2.new(0, 20, 0, 90)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    toggleBtn.Text = "▶ START FLY"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 18
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = mainFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = toggleBtn

    -- SPEED SLIDER
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Name = "SpeedLabel"
    speedLabel.Size = UDim2.new(1, -40, 0, 30)
    speedLabel.Position = UDim2.new(0, 20, 0, 165)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Speed: 100"
    speedLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    speedLabel.TextSize = 16
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.Parent = mainFrame

    local speedSlider = Instance.new("Frame")
    speedSlider.Name = "SpeedSlider"
    speedSlider.Size = UDim2.new(1, -40, 0, 6)
    speedSlider.Position = UDim2.new(0, 20, 0, 200)
    speedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    speedSlider.BackgroundTransparency = 0.5
    speedSlider.Parent = mainFrame

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = speedSlider

    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(0.5, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    fill.Parent = speedSlider

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    -- SPEED VALUE DISPLAY
    local speedValue = Instance.new("TextLabel")
    speedValue.Name = "SpeedValue"
    speedValue.Size = UDim2.new(0, 50, 0, 30)
    speedValue.Position = UDim2.new(1, -70, 0, 165)
    speedValue.BackgroundTransparency = 1
    speedValue.Text = "100"
    speedValue.TextColor3 = Color3.fromRGB(100, 150, 255)
    speedValue.TextSize = 16
    speedValue.TextXAlignment = Enum.TextXAlignment.Right
    speedValue.Font = Enum.Font.GothamBold
    speedValue.Parent = mainFrame

    -- STATUS
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -40, 0, 30)
    statusLabel.Position = UDim2.new(0, 20, 0, 220)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Status: ❌ Disabled"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.TextSize = 14
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = mainFrame

    -- CONTROL HINTS
    local hintFrame = Instance.new("Frame")
    hintFrame.Name = "HintFrame"
    hintFrame.Size = UDim2.new(1, -40, 0, 150)
    hintFrame.Position = UDim2.new(0, 20, 0, 270)
    hintFrame.BackgroundTransparency = 1
    hintFrame.Parent = mainFrame

    local hints = {
        {"🕹 Left Stick", "Move around", Color3.fromRGB(200, 200, 220)},
        {"⬆ Jump Button", "Fly up", Color3.fromRGB(100, 200, 255)},
        {"⬇ Hold? No", "Use Jump for up", Color3.fromRGB(255, 200, 100)}
    }

    for i, hint in ipairs(hints) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 40)
        row.Position = UDim2.new(0, 0, 0, (i-1) * 50)
        row.BackgroundTransparency = 1
        row.Parent = hintFrame

        local icon = Instance.new("TextLabel")
        icon.Size = UDim2.new(0, 40, 1, 0)
        icon.BackgroundTransparency = 1
        icon.Text = hint[1]
        icon.TextColor3 = hint[3]
        icon.TextSize = 18
        icon.TextXAlignment = Enum.TextXAlignment.Left
        icon.Font = Enum.Font.Gotham
        icon.Parent = row

        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(1, -40, 1, 0)
        desc.Position = UDim2.new(0, 40, 0, 0)
        desc.BackgroundTransparency = 1
        desc.Text = hint[2]
        desc.TextColor3 = Color3.fromRGB(150, 150, 170)
        desc.TextSize = 14
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Font = Enum.Font.Gotham
        desc.Parent = row
    end

    -- CLOSE BUTTON
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -55, 0, 10)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 24
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = mainFrame

    return screenGui, {
        mainFrame = mainFrame,
        toggleBtn = toggleBtn,
        speedSlider = speedSlider,
        fill = fill,
        speedLabel = speedLabel,
        speedValue = speedValue,
        statusLabel = statusLabel,
        closeBtn = closeBtn
    }
end

-- ============================================
-- FLY CORE FUNCTIONS
-- ============================================
local function SetupFlyComponents()
    -- Create Attachment
    FlyAttachment = Instance.new("Attachment")
    FlyAttachment.Parent = root

    -- Create LinearVelocity (fixed!)
    FlyLinearVelocity = Instance.new("LinearVelocity")
    FlyLinearVelocity.Parent = FlyAttachment
    FlyLinearVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    FlyLinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector -- CORRECT!
    FlyLinearVelocity.VectorVelocity = Vector3.new(0, 0, 0)
    FlyLinearVelocity.Attachment0 = FlyAttachment

    -- Create AlignOrientation
    FlyAlignOrientation = Instance.new("AlignOrientation")
    FlyAlignOrientation.Parent = FlyAttachment
    FlyAlignOrientation.MaxAngularVelocity = 15
    FlyAlignOrientation.MaxTorque = 10000
    FlyAlignOrientation.PrimaryAxisOnly = false
    FlyAlignOrientation.Attachment0 = FlyAttachment
    FlyAlignOrientation.RigidityEnabled = false
end

local function StartFly()
    if FlyEnabled then return end
    
    local char = player.Character
    if not char then return end
    
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    -- Setup fly components
    SetupFlyComponents()
    
    -- Disable animations
    local animate = char:FindFirstChild("Animate")
    if animate then
        animate.Disabled = true
    end
    
    -- Enable platform stand
    hum.PlatformStand = true
    
    FlyEnabled = true
    
    -- Connect RenderStepped
    FlyConnection = RunService.RenderStepped:Connect(function()
        if not FlyEnabled then return end
        
        local currentRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not currentRoot then return end
        
        local camera = workspace.CurrentCamera
        if not camera then return end
        
        -- Calculate movement direction
        local look = camera.CFrame.LookVector
        local right = camera.CFrame.RightVector
        
        -- Use mobile joystick input
        local moveX = MoveX
        local moveZ = MoveZ
        local moveY = MoveY
        
        -- Normalize horizontal movement
        local horizontalVec = Vector3.new(moveX, 0, moveZ)
        if horizontalVec.Magnitude > 0 then
            horizontalVec = horizontalVec.Unit
            moveX = horizontalVec.X
            moveZ = horizontalVec.Z
        end
        
        -- Calculate final velocity
        local vec = look * moveZ + right * moveX + Vector3.new(0, moveY, 0)
        
        if vec.Magnitude > 0 then
            vec = vec.Unit * FlySpeed
        end
        
        -- Apply velocity
        if FlyLinearVelocity then
            FlyLinearVelocity.VectorVelocity = vec
        end
        
        -- Align orientation
        if FlyAlignOrientation then
            if vec.Magnitude > 1 then
                local targetCF = CFrame.lookAt(currentRoot.Position, currentRoot.Position + vec)
                FlyAlignOrientation.CFrame = targetCF
            else
                FlyAlignOrientation.CFrame = camera.CFrame
            end
        end
    end)
    
    -- Update UI
    local menu = player.PlayerGui:FindFirstChild("FlyMenu")
    if menu then
        local toggleBtn = menu.MainFrame:FindFirstChild("ToggleBtn")
        if toggleBtn then
            toggleBtn.Text = "⏹ STOP FLY"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 50, 50)
        end
        
        local statusLabel = menu.MainFrame:FindFirstChild("StatusLabel")
        if statusLabel then
            statusLabel.Text = "Status: ✅ Flying"
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
    end
end

local function StopFly()
    if not FlyEnabled then return end
    
    FlyEnabled = false
    
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    
    -- Cleanup fly components
    if FlyLinearVelocity then
        FlyLinearVelocity:Destroy()
        FlyLinearVelocity = nil
    end
    
    if FlyAlignOrientation then
        FlyAlignOrientation:Destroy()
        FlyAlignOrientation = nil
    end
    
    if FlyAttachment then
        FlyAttachment:Destroy()
        FlyAttachment = nil
    end
    
    -- Restore humanoid
    local char = player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.PlatformStand = false
        end
        
        local animate = char:FindFirstChild("Animate")
        if animate then
            animate.Disabled = false
        end
    end
    
    -- Update UI
    local menu = player.PlayerGui:FindFirstChild("FlyMenu")
    if menu then
        local toggleBtn = menu.MainFrame:FindFirstChild("ToggleBtn")
        if toggleBtn then
            toggleBtn.Text = "▶ START FLY"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
        end
        
        local statusLabel = menu.MainFrame:FindFirstChild("StatusLabel")
        if statusLabel then
            statusLabel.Text = "Status: ❌ Disabled"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end
end

local function ToggleFly()
    if FlyEnabled then
        StopFly()
    else
        StartFly()
    end
end

-- ============================================
-- MOBILE INPUT HANDLING
-- ============================================
local function SetupMobileInput()
    -- Get joystick input from MoveDirection
    local function UpdateJoystick()
        local char = player.Character
        if not char then return end
        
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end
        
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0 then
            MoveX = moveDir.X
            MoveZ = -moveDir.Z  -- Roblox MoveDirection uses Z forward, we want -Z forward
        else
            MoveX = 0
            MoveZ = 0
        end
    end
    
    -- Listen to MoveDirection changes
    local connection
    connection = RunService.Heartbeat:Connect(function()
        UpdateJoystick()
    end)
    
    -- Handle Jump button (mobile jump = fly up)
    local function OnJumpRequested()
        if FlyEnabled then
            MoveY = 1
            -- Reset after a short time to prevent stuck
            task.wait(0.05)
            if FlyEnabled then
                MoveY = 0
            end
        end
    end
    
    -- Use UserInputService for jump detection
    UserInputService.JumpRequest:Connect(function()
        OnJumpRequested()
    end)
    
    -- Also handle keyboard for debugging on PC
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.Space then
            if FlyEnabled then
                MoveY = 1
            end
        elseif input.KeyCode == Enum.KeyCode.LeftControl then
            if FlyEnabled then
                MoveY = -1
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.Space then
            if FlyEnabled then
                MoveY = 0
            end
        elseif input.KeyCode == Enum.KeyCode.LeftControl then
            if FlyEnabled then
                MoveY = 0
            end
        end
    end)
    
    return connection
end

-- ============================================
-- CREATE AND SETUP MENU
-- ============================================
local function Initialize()
    -- Create UI
    local screenGui, uiElements = CreateFlyMenu()
    
    -- Setup slider
    local function UpdateSpeed(value)
        local normalized = math.clamp(value / 250, 0, 1)
        uiElements.fill.Size = UDim2.new(normalized, 0, 1, 0)
        FlySpeed = math.clamp(value, 10, 250)
        uiElements.speedValue.Text = tostring(math.floor(FlySpeed))
        uiElements.speedLabel.Text = "Speed: " .. tostring(math.floor(FlySpeed))
    end
    
    -- Slider dragging
    local dragging = false
    local function OnSliderClick(input)
        local pos = input.Position.X - uiElements.speedSlider.AbsolutePosition.X
        local width = uiElements.speedSlider.AbsoluteSize.X
        local normalized = math.clamp(pos / width, 0, 1)
        local value = normalized * 240 + 10
        UpdateSpeed(value)
    end
    
    uiElements.speedSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            OnSliderClick(input)
        end
    end)
    
    uiElements.speedSlider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    uiElements.speedSlider.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                         input.UserInputType == Enum.UserInputType.Touch) then
            OnSliderClick(input)
        end
    end)
    
    -- Toggle button
    uiElements.toggleBtn.MouseButton1Click:Connect(ToggleFly)
    
    -- Close button
    uiElements.closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        if FlyEnabled then
            StopFly()
        end
    end)
    
    -- Setup mobile input
    SetupMobileInput()
    
    -- Auto-start fly (optional, remove if you want manual start)
    -- StartFly()
end

-- ============================================
-- CHARACTER RESPAWN HANDLING
-- ============================================
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hum = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
    
    if FlyEnabled then
        StopFly()
    end
end)

-- ============================================
-- START
-- ============================================
Initialize()

print("✈ Fly Menu loaded successfully!")
print("Controls:")
print("  Left Stick: Move around")
print("  Jump Button: Fly up")
print("  No Up/Down buttons needed!")
