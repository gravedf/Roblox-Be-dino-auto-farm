local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
if not player.Character then player.CharacterAdded:Wait() end

local running = false
local tweenSpeed = 100
local moverConn = nil
local minimized = false
local normalSize = UDim2.new(0, 300, 0, 260)
local minimizedSize = UDim2.new(0, 300, 0, 38)

-- Store references to UI elements that need updating
local statusLbl, countLbl, speedLbl, sliderTrack, sliderFill, sliderKnob, speedValueLbl
-- Declare button variables globally
local startBtn, stopBtn

local function showInstagramNotification()
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = "InstagramNotification"
    notificationGui.ResetOnSpawn = false
    notificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    notificationGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Main notification frame with improved design
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Size = UDim2.new(0, 340, 0, 110)
    notificationFrame.Position = UDim2.new(1, 20, 0, 20)
    notificationFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    notificationFrame.BorderSizePixel = 0
    notificationFrame.ClipsDescendants = true
    notificationFrame.Parent = notificationGui
    
    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = notificationFrame
    
    -- Gradient background
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
    })
    gradient.Rotation = 90
    gradient.Parent = notificationFrame
    
    -- Stylish stroke/border
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 50, 100)
    stroke.Thickness = 2
    stroke.Transparency = 0.2
    stroke.Parent = notificationFrame
    
    -- Inner glow effect
    local innerGlow = Instance.new("ImageLabel")
    innerGlow.Size = UDim2.new(1, 0, 0, 30)
    innerGlow.Position = UDim2.new(0, 0, 0, 0)
    innerGlow.BackgroundTransparency = 1
    innerGlow.Image = "rbxassetid://3570695787"
    innerGlow.ImageColor3 = Color3.fromRGB(255, 50, 100)
    innerGlow.ImageTransparency = 0.85
    innerGlow.ScaleType = Enum.ScaleType.Slice
    innerGlow.SliceCenter = Rect.new(100, 100, 100, 100)
    innerGlow.Parent = notificationFrame
    
    -- Instagram logo/icon (replacing profile pic)
    local logoIcon = Instance.new("TextLabel")
    logoIcon.Size = UDim2.new(0, 50, 0, 50)
    logoIcon.Position = UDim2.new(0, 15, 0.5, -25)
    logoIcon.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
    logoIcon.BackgroundTransparency = 0.2
    logoIcon.Text = "📷"
    logoIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    logoIcon.Font = Enum.Font.GothamBold
    logoIcon.TextSize = 28
    logoIcon.Parent = notificationFrame
    
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 12)
    logoCorner.Parent = logoIcon
    
    -- Text container
    local textContainer = Instance.new("Frame")
    textContainer.Size = UDim2.new(1, -85, 1, 0)
    textContainer.Position = UDim2.new(0, 75, 0, 0)
    textContainer.BackgroundTransparency = 1
    textContainer.Parent = notificationFrame
    
    -- Title with gradient text effect
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 28)
    titleLabel.Position = UDim2.new(0, 0, 0, 15)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Follow me on Instagram"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = textContainer
    
    -- Username with @ symbol
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, 0, 0, 20)
    descLabel.Position = UDim2.new(0, 0, 0, 43)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = "@gravedf"
    descLabel.TextColor3 = Color3.fromRGB(255, 150, 200)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 15
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = textContainer
    
    -- Small description
    local smallDesc = Instance.new("TextLabel")
    smallDesc.Size = UDim2.new(1, 0, 0, 16)
    smallDesc.Position = UDim2.new(0, 0, 0, 63)
    smallDesc.BackgroundTransparency = 1
    smallDesc.Text = "Get updates and more!"
    smallDesc.TextColor3 = Color3.fromRGB(160, 160, 200)
    smallDesc.Font = Enum.Font.Gotham
    smallDesc.TextSize = 11
    smallDesc.TextXAlignment = Enum.TextXAlignment.Left
    smallDesc.Parent = textContainer
    
    -- Button frame
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, 0, 0, 36)
    buttonFrame.Position = UDim2.new(0, 0, 1, -46)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = textContainer
    
    -- Follow button with improved design
    local followButton = Instance.new("TextButton")
    followButton.Size = UDim2.new(0.65, -4, 1, 0)
    followButton.Position = UDim2.new(0, 0, 0, 0)
    followButton.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
    followButton.Text = "Follow"
    followButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    followButton.Font = Enum.Font.GothamBold
    followButton.TextSize = 14
    followButton.BorderSizePixel = 0
    followButton.Parent = buttonFrame
    
    local followCorner = Instance.new("UICorner")
    followCorner.CornerRadius = UDim.new(0, 8)
    followCorner.Parent = followButton
    
    
    -- Later button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0.3, -4, 1, 0)
    closeButton.Position = UDim2.new(0.7, 8, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    closeButton.Text = "Later"
    closeButton.TextColor3 = Color3.fromRGB(220, 220, 240)
    closeButton.Font = Enum.Font.Gotham
    closeButton.TextSize = 13
    closeButton.BorderSizePixel = 0
    closeButton.Parent = buttonFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton
    
    -- Slide in animation
    notificationFrame.Position = UDim2.new(1, 20, 0, 20)
    local slideIn = TweenService:Create(notificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -360, 0, 20)
    })
    slideIn:Play()
    
    -- Progress bar timer
    local disappearTimer = 12
    local countdownContainer = Instance.new("Frame")
    countdownContainer.Size = UDim2.new(1, 0, 0, 3)
    countdownContainer.Position = UDim2.new(0, 0, 1, -3)
    countdownContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    countdownContainer.BorderSizePixel = 0
    countdownContainer.Parent = notificationFrame
    
    local countdownFill = Instance.new("Frame")
    countdownFill.Size = UDim2.new(1, 0, 1, 0)
    countdownFill.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
    countdownFill.BorderSizePixel = 0
    countdownFill.Parent = countdownContainer
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 2)
    fillCorner.Parent = countdownFill
    
    local timerBar = TweenService:Create(countdownFill, TweenInfo.new(disappearTimer, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0)
    })
    timerBar:Play()
    
    -- Follow button click
    followButton.MouseButton1Click:Connect(function()
        setclipboard("https://www.instagram.com/gravedf/")
        followButton.BackgroundColor3 = Color3.fromRGB(50, 200, 90)
        followButton.Text = "Copied! ✓"
        
        -- Update glow color
        followGlow.ImageColor3 = Color3.fromRGB(50, 200, 90)
        
        task.wait(0.8)
        
        local slideOut = TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 20, 0, 20)
        })
        slideOut:Play()
        slideOut.Completed:Connect(function()
            notificationGui:Destroy()
        end)
    end)
    
    -- Close button click
    closeButton.MouseButton1Click:Connect(function()
        local slideOut = TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 20, 0, 20)
        })
        slideOut:Play()
        slideOut.Completed:Connect(function()
            notificationGui:Destroy()
        end)
    end)
    
    -- Auto disappear after timer
    task.wait(disappearTimer)
    if notificationGui and notificationGui.Parent then
        local slideOut = TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 20, 0, 20)
        })
        slideOut:Play()
        slideOut.Completed:Connect(function()
            notificationGui:Destroy()
        end)
    end
end

-- Rest of your code remains exactly the same from here...
local function getHRP()
    local char = player.Character
    if not char then return nil end
    for _, v in ipairs(char:GetChildren()) do
        if v.Name == "RootPart" and v:IsA("BasePart") and not v.Massless then
            return v
        end
    end
    return char.PrimaryPart
end

local function getClosestFood()
    local hrp = getHRP()
    if not hrp then return nil end
    local best, bestDist = nil, math.huge
    for _, food in CollectionService:GetTagged("Food") do
        if not food or not food.Parent then continue end
        local ok, pos = pcall(function()
            if food:IsA("Model") then return food:GetPivot().Position
            elseif food:IsA("BasePart") then return food.Position end
        end)
        if ok and pos then
            local d = (hrp.Position - pos).Magnitude
            if d < bestDist then
                bestDist = d
                best = { instance = food, position = pos }
            end
        end
    end
    return best
end

local function stopMover()
    if moverConn then moverConn:Disconnect(); moverConn = nil end
end

local function moveTo(targetPos)
    local reached = false
    stopMover()
    moverConn = RunService.Heartbeat:Connect(function(dt)
        local hrp = getHRP()
        if not hrp or not running then reached = true; stopMover(); return end
        local diff = targetPos - hrp.Position
        local dist = diff.Magnitude
        if dist < 2 then reached = true; stopMover(); return end
        local step = math.min(tweenSpeed * dt, dist)
        hrp.CFrame = CFrame.new(hrp.Position + diff.Unit * step)
    end)
    while not reached do task.wait(0.05) end
end

local gui = Instance.new("ScreenGui")
gui.Name = "FoodCollector"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- Main panel with glassmorphism effect
local panel = Instance.new("Frame")
panel.Size = normalSize
panel.Position = UDim2.new(0.5, -150, 0.5, -130)
panel.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
panel.BorderSizePixel = 0
panel.Active = true
panel.Draggable = true
panel.Parent = gui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 12)
panelCorner.Parent = panel

-- Subtle gradient overlay
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 20))
})
gradient.Rotation = 90
gradient.Parent = panel

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(70, 70, 120)
panelStroke.Thickness = 1.5
panelStroke.Transparency = 0.3
panelStroke.Parent = panel

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
titleBar.BackgroundTransparency = 0.2
titleBar.BorderSizePixel = 0
titleBar.Parent = panel

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -90, 1, 0)
titleText.Position = UDim2.new(0, 12, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Food Collector"
titleText.TextColor3 = Color3.fromRGB(240, 240, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 26, 0, 26)
minimizeBtn.Position = UDim2.new(1, -62, 0.5, -13)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = titleBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -32, 0.5, -13)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 70)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -24, 1, -50)
content.Position = UDim2.new(0, 12, 0, 44)
content.BackgroundTransparency = 1
content.Parent = panel

-- Status section with icons (using text as simple icons)
local statusIcon = Instance.new("TextLabel")
statusIcon.Size = UDim2.new(0, 20, 0, 20)
statusIcon.Position = UDim2.new(0, 0, 0, 2)
statusIcon.BackgroundTransparency = 1
statusIcon.Text = "●"
statusIcon.TextColor3 = Color3.fromRGB(255, 200, 60)
statusIcon.Font = Enum.Font.GothamBold
statusIcon.TextSize = 16
statusIcon.TextXAlignment = Enum.TextXAlignment.Left
statusIcon.Parent = content

statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, -25, 0, 22)
statusLbl.Position = UDim2.new(0, 20, 0, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "Status: Stopped"
statusLbl.TextColor3 = Color3.fromRGB(180, 180, 220)
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextSize = 13
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.Parent = content

-- Food count with icon
local foodIcon = Instance.new("TextLabel")
foodIcon.Size = UDim2.new(0, 20, 0, 18)
foodIcon.Position = UDim2.new(0, 0, 0, 24)
foodIcon.BackgroundTransparency = 1
foodIcon.Text = "🍔"
foodIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
foodIcon.Font = Enum.Font.Gotham
foodIcon.TextSize = 14
foodIcon.TextXAlignment = Enum.TextXAlignment.Left
foodIcon.Parent = content

countLbl = Instance.new("TextLabel")
countLbl.Size = UDim2.new(1, -25, 0, 18)
countLbl.Position = UDim2.new(0, 20, 0, 24)
countLbl.BackgroundTransparency = 1
countLbl.Text = "Food in world: 0"
countLbl.TextColor3 = Color3.fromRGB(140, 140, 200)
countLbl.Font = Enum.Font.Gotham
countLbl.TextSize = 12
countLbl.TextXAlignment = Enum.TextXAlignment.Left
countLbl.Parent = content

-- Speed display with modern styling
local speedContainer = Instance.new("Frame")
speedContainer.Size = UDim2.new(1, 0, 0, 30)
speedContainer.Position = UDim2.new(0, 0, 0, 48)
speedContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
speedContainer.BackgroundTransparency = 0.3
speedContainer.Parent = content

local speedContainerCorner = Instance.new("UICorner")
speedContainerCorner.CornerRadius = UDim.new(0, 8)
speedContainerCorner.Parent = speedContainer

local speedIcon = Instance.new("TextLabel")
speedIcon.Size = UDim2.new(0, 24, 1, 0)
speedIcon.Position = UDim2.new(0, 8, 0, 0)
speedIcon.BackgroundTransparency = 1
speedIcon.Text = "⚡"
speedIcon.TextColor3 = Color3.fromRGB(255, 200, 60)
speedIcon.Font = Enum.Font.Gotham
speedIcon.TextSize = 16
speedIcon.Parent = speedContainer

speedLbl = Instance.new("TextLabel")
speedLbl.Size = UDim2.new(0.5, -20, 1, 0)
speedLbl.Position = UDim2.new(0, 32, 0, 0)
speedLbl.BackgroundTransparency = 1
speedLbl.Text = "Speed"
speedLbl.TextColor3 = Color3.fromRGB(200, 200, 240)
speedLbl.Font = Enum.Font.Gotham
speedLbl.TextSize = 13
speedLbl.TextXAlignment = Enum.TextXAlignment.Left
speedLbl.Parent = speedContainer

speedValueLbl = Instance.new("TextLabel")
speedValueLbl.Size = UDim2.new(0.5, -10, 1, 0)
speedValueLbl.Position = UDim2.new(0.5, 10, 0, 0)
speedValueLbl.BackgroundTransparency = 1
speedValueLbl.Text = "100 studs/s"
speedValueLbl.TextColor3 = Color3.fromRGB(100, 200, 255)
speedValueLbl.Font = Enum.Font.GothamBold
speedValueLbl.TextSize = 13
speedValueLbl.TextXAlignment = Enum.TextXAlignment.Right
speedValueLbl.Parent = speedContainer

-- Modern slider design
local sliderContainer = Instance.new("Frame")
sliderContainer.Size = UDim2.new(1, 0, 0, 40)
sliderContainer.Position = UDim2.new(0, 0, 0, 84)
sliderContainer.BackgroundTransparency = 1
sliderContainer.Parent = content

-- Slider track with glow effect
sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(1, 0, 0, 6)
sliderTrack.Position = UDim2.new(0, 0, 0.5, -3)
sliderTrack.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
sliderTrack.BorderSizePixel = 0
sliderTrack.Parent = sliderContainer

local trackCorner = Instance.new("UICorner")
trackCorner.CornerRadius = UDim.new(1, 0)
trackCorner.Parent = sliderTrack

-- Glow effect for track
local trackGlow = Instance.new("ImageLabel")
trackGlow.Size = UDim2.new(1, 0, 1, 4)
trackGlow.Position = UDim2.new(0, 0, 0.5, -2)
trackGlow.BackgroundTransparency = 1
trackGlow.Image = "rbxassetid://3570695787"
trackGlow.ImageColor3 = Color3.fromRGB(90, 160, 255)
trackGlow.ImageTransparency = 0.8
trackGlow.ScaleType = Enum.ScaleType.Slice
trackGlow.SliceCenter = Rect.new(100, 100, 100, 100)
trackGlow.Parent = sliderTrack

-- Slider fill with gradient
sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(90, 160, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderTrack

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = sliderFill

local fillGradient = Instance.new("UIGradient")
fillGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 160, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 100, 255))
})
fillGradient.Rotation = 90
fillGradient.Parent = sliderFill

-- Modern knob with ring design
sliderKnob = Instance.new("TextButton")
sliderKnob.Size = UDim2.new(0, 24, 0, 24)
sliderKnob.Position = UDim2.new(0, -12, 0.5, -12)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderKnob.Text = ""
sliderKnob.BorderSizePixel = 0
sliderKnob.Parent = sliderContainer

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = sliderKnob

-- Inner ring
local knobRing = Instance.new("Frame")
knobRing.Size = UDim2.new(0, 18, 0, 18)
knobRing.Position = UDim2.new(0.5, -9, 0.5, -9)
knobRing.BackgroundColor3 = Color3.fromRGB(90, 160, 255)
knobRing.BorderSizePixel = 0
knobRing.Parent = sliderKnob

local ringCorner = Instance.new("UICorner")
ringCorner.CornerRadius = UDim.new(1, 0)
ringCorner.Parent = knobRing

-- Outer glow
local knobGlow = Instance.new("ImageLabel")
knobGlow.Size = UDim2.new(1, 4, 1, 4)
knobGlow.Position = UDim2.new(0.5, -14, 0.5, -14)
knobGlow.BackgroundTransparency = 1
knobGlow.Image = "rbxassetid://3570695787"
knobGlow.ImageColor3 = Color3.fromRGB(90, 160, 255)
knobGlow.ImageTransparency = 0.4
knobGlow.ScaleType = Enum.ScaleType.Slice
knobGlow.SliceCenter = Rect.new(100, 100, 100, 100)
knobGlow.Parent = sliderKnob

-- Hint text with better styling
local hintLbl = Instance.new("TextLabel")
hintLbl.Size = UDim2.new(1, 0, 0, 16)
hintLbl.Position = UDim2.new(0, 0, 0, 125)
hintLbl.BackgroundTransparency = 1
hintLbl.Text = "⬅️ Drag to adjust speed  ➡️"
hintLbl.TextColor3 = Color3.fromRGB(120, 120, 180)
hintLbl.Font = Enum.Font.Gotham
hintLbl.TextSize = 11
hintLbl.TextXAlignment = Enum.TextXAlignment.Center
hintLbl.Parent = content

local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, 0, 0, 40)
buttonContainer.Position = UDim2.new(0, 0, 0, 145)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = content

local function makeBtn(text, color, xOffset)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.48, -4, 1, 0)
    btn.Position = UDim2.new(xOffset, 0, 0, 0)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.Parent = buttonContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    return btn
end

-- Assign the buttons to the global variables
startBtn = makeBtn("Start", Color3.fromRGB(40, 180, 90), 0)
stopBtn = makeBtn("Stop", Color3.fromRGB(200, 60, 70), 0.52)

-- Function to update slider position based on speed
local function updateSliderPosition()
    local ratio = tweenSpeed / 1000
    sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
    sliderKnob.Position = UDim2.new(ratio, -12, 0.5, -12)
    speedValueLbl.Text = tweenSpeed .. " studs/s"
end

-- Initialize slider position
updateSliderPosition()

local dragging = false

-- Slider dragging
sliderKnob.MouseButton1Down:Connect(function()
    dragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
    
    local mousePos = UserInputService:GetMouseLocation()
    local trackPos = sliderTrack.AbsolutePosition
    local trackSize = sliderTrack.AbsoluteSize
    
    if trackSize.X <= 0 then return end
    
    local relativeX = mousePos.X - trackPos.X
    local ratio = math.clamp(relativeX / trackSize.X, 0, 1)
    
    tweenSpeed = math.max(10, math.floor(ratio * 1000))
    
    -- Smooth visual updates
    sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
    sliderKnob.Position = UDim2.new(ratio, -12, 0.5, -12)
    speedValueLbl.Text = tweenSpeed .. " studs/s"
    speedLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

-- Minimize functionality
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    
    if minimized then
        local sizeTween = TweenService:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = minimizedSize,
            Position = UDim2.new(0.5, -150, 0.5, -19)
        })
        sizeTween:Play()
        
        content.Visible = false
        minimizeBtn.Text = "+"
    else
        local sizeTween = TweenService:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = normalSize,
            Position = UDim2.new(0.5, -150, 0.5, -130)
        })
        sizeTween:Play()
        
        content.Visible = true
        minimizeBtn.Text = "−"
    end
end)

local function setStatus(msg, color)
    statusLbl.Text = "Status: " .. msg
    statusLbl.TextColor3 = color or Color3.fromRGB(180, 180, 220)
    -- Update status icon color
    statusIcon.TextColor3 = color or Color3.fromRGB(255, 200, 60)
end

local function collectLoop()
    while running do
        if not player.Character then
            player.CharacterAdded:Wait()
            task.wait(1)
            continue
        end

        local hrp = getHRP()
        if not hrp then
            setStatus("No RootPart...", Color3.fromRGB(220, 100, 100))
            task.wait(1)
            continue
        end

        local foodCount = #CollectionService:GetTagged("Food")
        countLbl.Text = "Food in world: " .. foodCount

        local food = getClosestFood()
        if not food or not food.instance or not food.instance.Parent then
            setStatus("No food nearby...", Color3.fromRGB(220, 180, 80))
            task.wait(0.3)
            continue
        end

        setStatus("Going to " .. food.instance.Name, Color3.fromRGB(80, 220, 120))
        moveTo(food.position)
    end
    setStatus("Stopped")
end

-- Now these will work because startBtn and stopBtn are global
startBtn.MouseButton1Click:Connect(function()
    if running then return end
    running = true
    setStatus("Running", Color3.fromRGB(80, 220, 120))
    task.spawn(collectLoop)
end)

stopBtn.MouseButton1Click:Connect(function()
    running = false
    stopMover()
    setStatus("Stopped")
end)

closeBtn.MouseButton1Click:Connect(function()
    running = false
    stopMover()
    gui:Destroy()
end)

setStatus("Stopped")

-- Update food count periodically
task.spawn(function()
    while gui.Parent do
        if content.Visible then
            local foodCount = #CollectionService:GetTagged("Food")
            countLbl.Text = "Food in world: " .. foodCount
        end
        task.wait(1)
    end
end)

task.wait(3)
showInstagramNotification()
