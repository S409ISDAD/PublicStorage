-- Precision Wood Teleporter for Lumber Tycoon 2
-- Select one piece of wood and place it precisely where you want

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local LocalPlayer = Player
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Mouse = Player:GetMouse()

-- Selection variables
local selectedWood = nil
local selectionEnabled = false

-- Preview variables
local previewMode = false
local previewPart = nil
local currentRotationY = 0
local currentRotationX = 90  -- Start flat (90 degrees on X-axis)
local currentRotationZ = 0
local previewCFrame = CFrame.new(0, 0, 0)
local rotationAxis = "Z" -- Default to Z-axis rotation
local previewLocked = false  -- Track if preview position is locked

-- Grid snapping variables
local gridSnappingEnabled = true  -- Default enabled
local rotationSnapDegrees = 15  -- Snap to 15 degree increments (24 positions in 360°)

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PrecisionWoodTeleporterGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 180)
MainFrame.Position = UDim2.new(0.5, -140, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local DropShadow = Instance.new("ImageLabel")
DropShadow.Name = "DropShadow"
DropShadow.BackgroundTransparency = 1
DropShadow.Position = UDim2.new(0, -15, 0, -15)
DropShadow.Size = UDim2.new(1, 30, 1, 30)
DropShadow.ZIndex = 0
DropShadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
DropShadow.ImageTransparency = 0.5
DropShadow.ScaleType = Enum.ScaleType.Slice
DropShadow.SliceCenter = Rect.new(10, 10, 10, 10)
DropShadow.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Fix bottom corners of title bar
local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 12)
TitleFix.Position = UDim2.new(0, 0, 1, -12)
TitleFix.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🪵 Precision Wood Teleporter"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Close Button (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Hover effect for close button
CloseButton.MouseEnter:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
end)

CloseButton.MouseLeave:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, -30, 0, 30)
StatusLabel.Position = UDim2.new(0, 15, 0, 50)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "No wood selected"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

-- Grid Snap Toggle
local GridSnapButton = Instance.new("TextButton")
GridSnapButton.Name = "GridSnapButton"
GridSnapButton.Size = UDim2.new(0, 120, 0, 25)
GridSnapButton.Position = UDim2.new(1, -135, 0, 52)
GridSnapButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
GridSnapButton.BorderSizePixel = 0
GridSnapButton.Text = "📐 Snap: ON"
GridSnapButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GridSnapButton.TextSize = 11
GridSnapButton.Font = Enum.Font.GothamBold
GridSnapButton.AutoButtonColor = false
GridSnapButton.Parent = MainFrame

local GridSnapCorner = Instance.new("UICorner")
GridSnapCorner.CornerRadius = UDim.new(0, 6)
GridSnapCorner.Parent = GridSnapButton

-- Grid snap toggle handler
GridSnapButton.MouseButton1Click:Connect(function()
    gridSnappingEnabled = not gridSnappingEnabled
    if gridSnappingEnabled then
        GridSnapButton.Text = "📐 Snap: ON"
        GridSnapButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        print("Rotation snapping enabled (15° increments)")
    else
        GridSnapButton.Text = "📐 Snap: OFF"
        GridSnapButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
        print("Rotation snapping disabled")
    end
end)

-- Hover effect for grid snap button
GridSnapButton.MouseEnter:Connect(function()
    if gridSnappingEnabled then
        GridSnapButton.BackgroundColor3 = Color3.fromRGB(120, 220, 120)
    else
        GridSnapButton.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
    end
end)

GridSnapButton.MouseLeave:Connect(function()
    if gridSnappingEnabled then
        GridSnapButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    else
        GridSnapButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    end
end)

-- Toggle Selection Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 250, 0, 35)
ToggleButton.Position = UDim2.new(0, 15, 0, 85)
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "Enable Selection"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.AutoButtonColor = false
ToggleButton.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

-- Hover effects for toggle button
ToggleButton.MouseEnter:Connect(function()
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 130, 210)
end)

ToggleButton.MouseLeave:Connect(function()
    if selectionEnabled then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
    else
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
    end
end)

-- Place Button (initially hidden)
local PlaceButton = Instance.new("TextButton")
PlaceButton.Name = "PlaceButton"
PlaceButton.Size = UDim2.new(0, 250, 0, 35)
PlaceButton.Position = UDim2.new(0, 15, 0, 125)
PlaceButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
PlaceButton.BorderSizePixel = 0
PlaceButton.Text = "📍 Place Wood"
PlaceButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PlaceButton.TextSize = 14
PlaceButton.Font = Enum.Font.GothamBold
PlaceButton.Visible = false
PlaceButton.AutoButtonColor = false
PlaceButton.Parent = MainFrame

local PlaceCorner = Instance.new("UICorner")
PlaceCorner.CornerRadius = UDim.new(0, 8)
PlaceCorner.Parent = PlaceButton

-- Hover effects for place button
PlaceButton.MouseEnter:Connect(function()
    PlaceButton.BackgroundColor3 = Color3.fromRGB(60, 210, 110)
end)

PlaceButton.MouseLeave:Connect(function()
    PlaceButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
end)

-- Preview instruction label
local PreviewLabel = Instance.new("TextLabel")
PreviewLabel.Name = "PreviewLabel"
PreviewLabel.Size = UDim2.new(1, 0, 0, 50)
PreviewLabel.Position = UDim2.new(0, 0, 1, 10)
PreviewLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
PreviewLabel.BorderSizePixel = 0
PreviewLabel.Text = "🖱️ Click/Tap to Lock Position\n🔄 Hold R/RB to Rotate | ✅ RT to Place"
PreviewLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
PreviewLabel.TextSize = 11
PreviewLabel.Font = Enum.Font.GothamBold
PreviewLabel.Visible = false
PreviewLabel.Parent = MainFrame

local PreviewCorner = Instance.new("UICorner")
PreviewCorner.CornerRadius = UDim.new(0, 8)
PreviewCorner.Parent = PreviewLabel

-- Rotation Axis Indicator
local AxisLabel = Instance.new("TextLabel")
AxisLabel.Name = "AxisLabel"
AxisLabel.Size = UDim2.new(1, 0, 0, 25)
AxisLabel.Position = UDim2.new(0, 0, 1, 65)
AxisLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
AxisLabel.BorderSizePixel = 0
AxisLabel.Text = "Current Axis: Z"
AxisLabel.TextColor3 = Color3.fromRGB(100, 100, 255)
AxisLabel.TextSize = 12
AxisLabel.Font = Enum.Font.GothamBold
AxisLabel.Visible = false
AxisLabel.Parent = MainFrame

local AxisCorner = Instance.new("UICorner")
AxisCorner.CornerRadius = UDim.new(0, 8)
AxisCorner.Parent = AxisLabel

-- Mobile Rotation Controls Container
local RotationControls = Instance.new("Frame")
RotationControls.Name = "RotationControls"
RotationControls.Size = UDim2.new(0, 280, 0, 90)
RotationControls.Position = UDim2.new(0.5, -140, 0.7, 0)
RotationControls.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
RotationControls.BorderSizePixel = 0
RotationControls.Visible = false
RotationControls.Parent = ScreenGui

local RotationCorner = Instance.new("UICorner")
RotationCorner.CornerRadius = UDim.new(0, 12)
RotationCorner.Parent = RotationControls

-- Rotate Button (R)
local RotateButton = Instance.new("TextButton")
RotateButton.Name = "RotateButton"
RotateButton.Size = UDim2.new(1, -20, 0, 35)
RotateButton.Position = UDim2.new(0, 10, 0, 10)
RotateButton.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
RotateButton.BorderSizePixel = 0
RotateButton.Text = "🔄 Rotate (Hold)"
RotateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RotateButton.TextSize = 14
RotateButton.Font = Enum.Font.GothamBold
RotateButton.AutoButtonColor = false
RotateButton.Parent = RotationControls

local RotateCorner = Instance.new("UICorner")
RotateCorner.CornerRadius = UDim.new(0, 8)
RotateCorner.Parent = RotateButton

-- Axis Buttons Container
local AxisButtons = Instance.new("Frame")
AxisButtons.Name = "AxisButtons"
AxisButtons.Size = UDim2.new(1, -20, 0, 35)
AxisButtons.Position = UDim2.new(0, 10, 0, 50)
AxisButtons.BackgroundTransparency = 1
AxisButtons.Parent = RotationControls

-- X Axis Button
local XButton = Instance.new("TextButton")
XButton.Name = "XButton"
XButton.Size = UDim2.new(0.32, -5, 1, 0)
XButton.Position = UDim2.new(0, 0, 0, 0)
XButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
XButton.BorderSizePixel = 0
XButton.Text = "X"
XButton.TextColor3 = Color3.fromRGB(255, 255, 255)
XButton.TextSize = 14
XButton.Font = Enum.Font.GothamBold
XButton.Parent = AxisButtons

local XCorner = Instance.new("UICorner")
XCorner.CornerRadius = UDim.new(0, 8)
XCorner.Parent = XButton

-- Y Axis Button
local YButton = Instance.new("TextButton")
YButton.Name = "YButton"
YButton.Size = UDim2.new(0.32, -5, 1, 0)
YButton.Position = UDim2.new(0.34, 0, 0, 0)
YButton.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
YButton.BorderSizePixel = 0
YButton.Text = "Y"
YButton.TextColor3 = Color3.fromRGB(255, 255, 255)
YButton.TextSize = 14
YButton.Font = Enum.Font.GothamBold
YButton.Parent = AxisButtons

local YCorner = Instance.new("UICorner")
YCorner.CornerRadius = UDim.new(0, 8)
YCorner.Parent = YButton

-- Z Axis Button
local ZButton = Instance.new("TextButton")
ZButton.Name = "ZButton"
ZButton.Size = UDim2.new(0.32, -5, 1, 0)
ZButton.Position = UDim2.new(0.68, 0, 0, 0)
ZButton.BackgroundColor3 = Color3.fromRGB(80, 80, 200)
ZButton.BorderSizePixel = 0
ZButton.Text = "Z"
ZButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ZButton.TextSize = 14
ZButton.Font = Enum.Font.GothamBold
ZButton.Parent = AxisButtons

local ZCorner = Instance.new("UICorner")
ZCorner.CornerRadius = UDim.new(0, 8)
ZCorner.Parent = ZButton

-- Make GUI Draggable
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Update status display
local function updateStatus()
    if selectedWood then
        local woodName = selectedWood.Parent.Name or "Unknown"
        StatusLabel.Text = "✓ Selected: " .. woodName
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        PlaceButton.Visible = true
        ToggleButton.Text = "Clear Selection"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
    else
        StatusLabel.Text = "No wood selected"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        PlaceButton.Visible = false
        if selectionEnabled then
            ToggleButton.Text = "Disable Selection"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
        else
            ToggleButton.Text = "Enable Selection"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
        end
    end
end

-- Check if part is wood
local function isWood(part)
    if not part:IsA("BasePart") then return false end
    local model = part.Parent
    if not model then return false end
    
    -- Check for Owner value
    local owner = model:FindFirstChild("Owner")
    if not owner then return false end
    
    -- Check if owner is LocalPlayer
    if owner.Value ~= LocalPlayer then return false end
    
    -- Check if it's wood (has TreeClass)
    local treeClass = model:FindFirstChild("TreeClass")
    if not treeClass then return false end
    
    return true
end

-- Add highlight to selected wood
local function highlightWood(model, selected)
    local highlight = model:FindFirstChild("SelectionHighlight")
    
    if selected then
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "SelectionHighlight"
            highlight.Adornee = model
            highlight.FillColor = Color3.fromRGB(255, 200, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 150, 0)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = model
        end
    else
        if highlight then
            highlight:Destroy()
        end
    end
end

-- Mouse/Touch handler for selection
local function handleSelection(position)
    if not selectionEnabled then return end
    if previewMode then return end
    
    -- Get target at touch/click position
    local unitRay = workspace.CurrentCamera:ScreenPointToRay(position.X, position.Y)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {Character}
    
    local raycastResult = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, raycastParams)
    
    if raycastResult then
        local target = raycastResult.Instance
        
        if isWood(target) then
            local model = target.Parent
            
            -- Clear previous selection
            if selectedWood then
                highlightWood(selectedWood.Parent, false)
            end
            
            selectedWood = model:FindFirstChild("WoodSection") or model:FindFirstChild("Main") or model:FindFirstChildOfClass("Part")
            highlightWood(model, true)
            updateStatus()
            print("Selected wood: " .. model.Name)
        end
    end
end

-- Mouse click handler
Mouse.Button1Down:Connect(function()
    handleSelection(UserInputService:GetMouseLocation())
end)

-- Touch handler for mobile
UserInputService.TouchTap:Connect(function(touchPositions, gameProcessed)
    if gameProcessed then return end
    if #touchPositions > 0 then
        handleSelection(touchPositions[1])
    end
end)

-- Toggle selection button
ToggleButton.MouseButton1Click:Connect(function()
    if selectedWood then
        -- Clear selection
        highlightWood(selectedWood.Parent, false)
        selectedWood = nil
        selectionEnabled = false
        updateStatus()
        print("Selection cleared")
    else
        selectionEnabled = not selectionEnabled
        updateStatus()
        
        if selectionEnabled then
            print("Selection enabled - click on wood to select it")
        else
            print("Selection disabled")
        end
    end
end)

-- Create preview part
local function createPreview()
    -- Clear existing preview
    if previewPart then
        previewPart:Destroy()
    end
    
    if not selectedWood then return end
    
    -- Create preview part matching the selected wood
    previewPart = Instance.new("Part")
    previewPart.Name = "PreviewWood"
    previewPart.Size = selectedWood.Size
    previewPart.Anchored = true
    previewPart.CanCollide = false
    previewPart.Transparency = 0.5
    previewPart.Color = Color3.fromRGB(0, 255, 255)
    previewPart.Material = Enum.Material.Neon
    previewPart.Parent = workspace
    
    -- Add outline
    local outline = Instance.new("SelectionBox")
    outline.Adornee = previewPart
    outline.Color3 = Color3.fromRGB(0, 200, 255)
    outline.LineThickness = 0.05
    outline.Parent = previewPart
    
    -- Start with 90 degree rotation on X-axis to make it flat
    currentRotationX = 90
end

-- Rotation snapping function
local function snapRotation(rotation)
    if not gridSnappingEnabled then return rotation end
    
    -- Snap to nearest increment
    return math.floor(rotation / rotationSnapDegrees + 0.5) * rotationSnapDegrees
end

-- Update preview position
local function updatePreview()
    if not previewMode or not previewPart then return end
    if previewLocked then return end  -- Don't update position if locked
    
    local inputPosition
    
    -- Check if using touch or mouse
    if UserInputService.TouchEnabled then
        local touches = UserInputService:GetTouchPosition()
        if touches and #touches > 0 then
            inputPosition = touches[1]
        end
    end
    
    -- Fallback to mouse if no touch input
    if not inputPosition then
        inputPosition = UserInputService:GetMouseLocation()
    end
    
    -- Get world position from screen position
    local unitRay = workspace.CurrentCamera:ScreenPointToRay(inputPosition.X, inputPosition.Y)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {Character, previewPart}
    
    local raycastResult = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, raycastParams)
    
    if raycastResult then
        local hitPosition = raycastResult.Position
        
        -- Apply rotations with snapping (always flat with Z rotation)
        local snappedZ = snapRotation(currentRotationZ)
        
        local rotationCFrame = CFrame.Angles(
            math.rad(currentRotationX),
            math.rad(currentRotationY),
            math.rad(snappedZ)
        )
        
        previewCFrame = CFrame.new(hitPosition) * rotationCFrame
        previewPart.CFrame = previewCFrame
    end
end

-- Update preview rotation only (when locked)
local function updatePreviewRotation()
    if not previewMode or not previewPart or not previewLocked then return end
    
    -- Apply rotations with snapping while keeping position locked
    local snappedZ = snapRotation(currentRotationZ)
    
    local rotationCFrame = CFrame.Angles(
        math.rad(currentRotationX),
        math.rad(currentRotationY),
        math.rad(snappedZ)
    )
    
    previewPart.CFrame = CFrame.new(previewCFrame.Position) * rotationCFrame
end

-- Handle rotation input for different axes
local isRotating = false

-- Mobile Rotation Button
RotateButton.MouseButton1Down:Connect(function()
    if not previewMode then return end
    isRotating = true
    RotateButton.BackgroundColor3 = Color3.fromRGB(120, 120, 220)
end)

RotateButton.MouseButton1Up:Connect(function()
    isRotating = false
    RotateButton.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
end)

-- Mobile Axis Buttons
XButton.MouseButton1Click:Connect(function()
    if not previewMode then return end
    rotationAxis = "X"
    AxisLabel.Text = "Current Axis: X"
    AxisLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    XButton.BackgroundColor3 = Color3.fromRGB(220, 100, 100)
    YButton.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
    ZButton.BackgroundColor3 = Color3.fromRGB(80, 80, 200)
    print("Rotation axis: X")
end)

YButton.MouseButton1Click:Connect(function()
    if not previewMode then return end
    rotationAxis = "Y"
    AxisLabel.Text = "Current Axis: Y"
    AxisLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    XButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
    YButton.BackgroundColor3 = Color3.fromRGB(100, 220, 100)
    ZButton.BackgroundColor3 = Color3.fromRGB(80, 80, 200)
    print("Rotation axis: Y")
end)

ZButton.MouseButton1Click:Connect(function()
    if not previewMode then return end
    rotationAxis = "Z"
    AxisLabel.Text = "Current Axis: Z"
    AxisLabel.TextColor3 = Color3.fromRGB(100, 100, 255)
    XButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
    YButton.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
    ZButton.BackgroundColor3 = Color3.fromRGB(100, 100, 220)
    print("Rotation axis: Z")
end)

-- Continuous rotation while button is held or R key is pressed
RunService.RenderStepped:Connect(function()
    if previewMode and isRotating then
        if rotationAxis == "Y" then
            currentRotationY = currentRotationY + 2
            if currentRotationY >= 360 then currentRotationY = 0 end
        elseif rotationAxis == "X" then
            currentRotationX = currentRotationX + 2
            if currentRotationX >= 360 then currentRotationX = 0 end
        elseif rotationAxis == "Z" then
            currentRotationZ = currentRotationZ + 2
            if currentRotationZ >= 360 then currentRotationZ = 0 end
        end
        
        if previewLocked then
            updatePreviewRotation()
        else
            updatePreview()
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Switch rotation axis with keyboard
    if previewMode then
        if input.KeyCode == Enum.KeyCode.X then
            rotationAxis = "X"
            AxisLabel.Text = "Current Axis: X"
            AxisLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            XButton.BackgroundColor3 = Color3.fromRGB(220, 100, 100)
            YButton.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
            ZButton.BackgroundColor3 = Color3.fromRGB(80, 80, 200)
            print("Rotation axis: X")
        elseif input.KeyCode == Enum.KeyCode.Y then
            rotationAxis = "Y"
            AxisLabel.Text = "Current Axis: Y"
            AxisLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            XButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
            YButton.BackgroundColor3 = Color3.fromRGB(100, 220, 100)
            ZButton.BackgroundColor3 = Color3.fromRGB(80, 80, 200)
            print("Rotation axis: Y")
        elseif input.KeyCode == Enum.KeyCode.Z then
            rotationAxis = "Z"
            AxisLabel.Text = "Current Axis: Z"
            AxisLabel.TextColor3 = Color3.fromRGB(100, 100, 255)
            XButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
            YButton.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
            ZButton.BackgroundColor3 = Color3.fromRGB(100, 100, 220)
            print("Rotation axis: Z")
        elseif input.KeyCode == Enum.KeyCode.R or input.KeyCode == Enum.KeyCode.ButtonR1 then
            -- R key or RB button (Right Bumper)
            isRotating = true
            RotateButton.BackgroundColor3 = Color3.fromRGB(120, 120, 220)
        elseif input.KeyCode == Enum.KeyCode.ButtonX then
            -- X button on gamepad - switch to X axis
            rotationAxis = "X"
            AxisLabel.Text = "Current Axis: X"
            AxisLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            XButton.BackgroundColor3 = Color3.fromRGB(220, 100, 100)
            YButton.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
            ZButton.BackgroundColor3 = Color3.fromRGB(80, 80, 200)
            print("Rotation axis: X")
        elseif input.KeyCode == Enum.KeyCode.ButtonY then
            -- Y button on gamepad - switch to Y axis
            rotationAxis = "Y"
            AxisLabel.Text = "Current Axis: Y"
            AxisLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            XButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
            YButton.BackgroundColor3 = Color3.fromRGB(100, 220, 100)
            ZButton.BackgroundColor3 = Color3.fromRGB(80, 80, 200)
            print("Rotation axis: Y")
        elseif input.KeyCode == Enum.KeyCode.ButtonB then
            -- B button on gamepad - switch to Z axis
            rotationAxis = "Z"
            AxisLabel.Text = "Current Axis: Z"
            AxisLabel.TextColor3 = Color3.fromRGB(100, 100, 255)
            XButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
            YButton.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
            ZButton.BackgroundColor3 = Color3.fromRGB(100, 100, 220)
            print("Rotation axis: Z")
        end
    end
    
    -- Xbox controller selection with A button
    if selectionEnabled and not previewMode then
        if input.KeyCode == Enum.KeyCode.ButtonA then
            -- Simulate a raycast from center of screen for gamepad
            local camera = workspace.CurrentCamera
            local screenCenter = camera.ViewportSize / 2
            local unitRay = camera:ScreenPointToRay(screenCenter.X, screenCenter.Y)
            
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            raycastParams.FilterDescendantsInstances = {Character}
            
            local raycastResult = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, raycastParams)
            
            if raycastResult then
                local target = raycastResult.Instance
                
                if isWood(target) then
                    local model = target.Parent
                    
                    -- Clear previous selection
                    if selectedWood then
                        highlightWood(selectedWood.Parent, false)
                    end
                    
                    selectedWood = model:FindFirstChild("WoodSection") or model:FindFirstChild("Main") or model:FindFirstChildOfClass("Part")
                    highlightWood(model, true)
                    updateStatus()
                    print("Selected wood: " .. model.Name)
                end
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.R or input.KeyCode == Enum.KeyCode.ButtonR1 then
        isRotating = false
        RotateButton.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
    end
end)

-- Monitor Right Trigger (RT/R2) for placement
RunService.RenderStepped:Connect(function()
    if previewMode then
        local rightTrigger = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1)
        
        for _, input in ipairs(rightTrigger) do
            if input.KeyCode == Enum.KeyCode.ButtonR2 then
                if input.Position.Z > 0.5 then  -- Trigger pressed more than 50%
                    -- Handle lock/placement
                    if not previewLocked then
                        previewLocked = true
                        PreviewLabel.Text = "🔄 Hold RB to Rotate | ✅ RT to Place"
                        print("Position locked! Press RT again to place")
                        task.wait(0.3)  -- Debounce
                    else
                        placeWood()
                        task.wait(0.3)  -- Debounce
                    end
                end
            end
        end
    end
end)

-- Place the wood
local function placeWood()
    if not selectedWood then return end
    
    print("Placing wood...")
    
    local model = selectedWood.Parent
    local part = selectedWood
    
    -- Ensure we're close enough
    if (Character.HumanoidRootPart.Position - part.Position).Magnitude > 25 then
        Character.HumanoidRootPart.CFrame = part.CFrame
        task.wait(0.05)  -- Reduced from 0.1
    end
    
    -- Use the dragging function to get network ownership (faster)
    for i = 1, 30 do  -- Reduced from 50
        task.wait(0.03)  -- Reduced from 0.05
        ReplicatedStorage.Interaction.ClientIsDragging:FireServer(model)
    end
    
    -- Move to target position with faster retry logic
    local maxAttempts = 150  -- Reduced from 200
    local targetReached = false
    
    for i = 1, maxAttempts do
        part.CFrame = previewCFrame
        
        -- Check if we're close to target
        if (part.Position - previewCFrame.Position).Magnitude < 1 then
            targetReached = true
            break
        end
        
        task.wait(0.005)  -- Reduced from 0.01 for faster placement
    end
    
    if targetReached then
        print("Wood placed successfully!")
    else
        warn("Wood placement may not be exact, retrying...")
        
        -- Final retry with teleport
        if (Character.HumanoidRootPart.Position - part.Position).Magnitude > 25 then
            Character.HumanoidRootPart.CFrame = part.CFrame
            task.wait(0.05)
        end
        
        -- Final burst of CFrame updates
        for i = 1, 80 do  -- Reduced from 100
            part.CFrame = previewCFrame
        end
        
        print("Wood placement completed!")
    end
    
    -- Clean up
    if previewPart then
        previewPart:Destroy()
        previewPart = nil
    end
    
    highlightWood(model, false)
    selectedWood = nil
    
    previewMode = false
    selectionEnabled = false
    previewLocked = false
    PreviewLabel.Visible = false
    AxisLabel.Visible = false
    RotationControls.Visible = false
    isRotating = false
    updateStatus()
end

-- Place button clicked
PlaceButton.MouseButton1Click:Connect(function()
    if not selectedWood then return end
    
    previewMode = true
    selectionEnabled = false
    previewLocked = false
    PreviewLabel.Visible = true
    AxisLabel.Visible = true
    RotationControls.Visible = true
    currentRotationX = 90  -- Start flat
    currentRotationY = 0
    currentRotationZ = 0
    rotationAxis = "Z"  -- Default to Z-axis
    AxisLabel.Text = "Current Axis: Z"
    AxisLabel.TextColor3 = Color3.fromRGB(100, 100, 255)
    
    -- Highlight Z button as default
    XButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
    YButton.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
    ZButton.BackgroundColor3 = Color3.fromRGB(100, 100, 220)
    
    createPreview()
    
    print("Preview mode activated - move mouse/finger to position")
    print("Click/tap once to lock position OR Press RT to lock")
    print("Hold rotation button, press R, or hold RB to rotate on Z-axis")
    print("Press X, Y, Z keys or gamepad buttons to switch rotation axis")
    print("Click/tap again or press RT to place")
    
    -- Connect preview update
    local previewConnection
    previewConnection = RunService.RenderStepped:Connect(function()
        if previewMode then
            updatePreview()
        else
            previewConnection:Disconnect()
        end
    end)
    
    -- Wait for first click/tap to lock position
    local clickConnection
    local touchConnection
    
    local function handlePlacementClick()
        if not previewLocked then
            -- First click: Lock the position
            previewLocked = true
            PreviewLabel.Text = "🔄 Hold R Button to Rotate | ✅ Click/Tap to Place"
            print("Position locked! Now you can rotate and click again to place")
        else
            -- Second click: Place the wood
            placeWood()
            if clickConnection then clickConnection:Disconnect() end
            if touchConnection then touchConnection:Disconnect() end
        end
    end
    
    clickConnection = Mouse.Button1Down:Connect(function()
        if previewMode then
            handlePlacementClick()
        end
    end)
    
    touchConnection = UserInputService.TouchTap:Connect(function(touchPositions, gameProcessed)
        if gameProcessed then return end
        if previewMode then
            handlePlacementClick()
        end
    end)
end)

-- Initialize
updateStatus()
print("Precision Wood Teleporter loaded!")
print("Click 'Enable Selection' and click on wood to select it")
