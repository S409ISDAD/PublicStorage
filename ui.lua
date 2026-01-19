local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local function Tween(obj, info, properties)
    TweenService:Create(obj, info or TweenInfo.new(0.25, Enum.EasingStyle.Sine), properties):Play()
end

local function MakeDraggable(DragObject, MainFrame)
    local dragging, dragInput, dragStart, startPos

    DragObject.InputBegan:Connect(function(input)
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

    DragObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

function Library:CreateWindow(title, titleColor)
    title = title or "UI"
    titleColor = titleColor or Color3.new(1,1,1)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomLib"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("CoreGui")  -- change to PlayerGui if needed

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
    MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
    MainFrame.Size = UDim2.new(0.35, 0, 0.6, 0)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    -- TopBar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.Parent = MainFrame

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 8)
    TopCorner.Parent = TopBar

    MakeDraggable(TopBar, MainFrame)  -- <--- Only TopBar can drag

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "  " .. title   -- extra space as requested
    TitleLabel.TextColor3 = titleColor
    TitleLabel.TextSize = 22
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "Minimize"
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    MinimizeBtn.Position = UDim2.new(1, -40, 0.5, -15)
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Text = "—"
    MinimizeBtn.TextColor3 = Color3.new(1,1,1)
    MinimizeBtn.TextSize = 24
    MinimizeBtn.Parent = TopBar

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = MinimizeBtn

    -- Sidebar
    local SideBar = Instance.new("Frame")
    SideBar.Name = "SideBar"
    SideBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SideBar.Position = UDim2.new(0, 0, 0, 45)
    SideBar.Size = UDim2.new(0.32, 0, 1, -45)
    SideBar.Parent = MainFrame

    local SideUICorner = Instance.new("UICorner")
    SideUICorner.CornerRadius = UDim.new(0, 8)
    SideUICorner.Parent = SideBar

    local SectionLayout = Instance.new("UIListLayout")
    SectionLayout.Padding = UDim.new(0, 8)  -- small gap between sections
    SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SectionLayout.Parent = SideBar

    -- Main Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "Content"
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0.32, 5, 0, 50)
    ContentArea.Size = UDim2.new(0.68, -10, 1, -55)
    ContentArea.Parent = MainFrame

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0, 12)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Parent = ContentArea

    local window = {}
    local currentTab = nil
    local minimized = false
    local originalSize = MainFrame.Size
    local originalPos = MainFrame.Position

    -- Minimize logic
    MinimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized

        if minimized then
            Tween(MainFrame, nil, {Size = UDim2.new(0.35, 0, 0, 45)})
            Tween(ContentArea, nil, {Visible = false})
            Tween(SideBar, nil, {Visible = false})
            MinimizeBtn.Text = "+"
        else
            Tween(MainFrame, nil, {Size = originalSize})
            Tween(ContentArea, nil, {Visible = true})
            Tween(SideBar, nil, {Visible = true})
            MinimizeBtn.Text = "—"
        end
    end)

    function window:CreateSection(sectionName)
        local btn = Instance.new("TextButton")
        btn.Name = sectionName
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        btn.Size = UDim2.new(1, -12, 0, 40)
        btn.Font = Enum.Font.GothamSemibold
        btn.Text = sectionName
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextSize = 16
        btn.Parent = SideBar

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn

        local content = Instance.new("ScrollingFrame")
        content.Name = sectionName .. "_Content"
        content.BackgroundTransparency = 1
        content.BorderSizePixel = 0
        content.ScrollBarThickness = 6
        content.Size = UDim2.new(1, 0, 1, 0)
        content.CanvasSize = UDim2.new(0, 0, 0, 0)
        content.Visible = false
        content.Parent = ContentArea

        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 10)
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Parent = content

        list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            content.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 20)
        end)

        btn.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Visible = false
            end
            content.Visible = true
            currentTab = content

            -- Highlight active button (optional)
            for _, b in SideBar:GetChildren() do
                if b:IsA("TextButton") then
                    Tween(b, nil, {BackgroundColor3 = Color3.fromRGB(45,45,45)})
                end
            end
            Tween(btn, nil, {BackgroundColor3 = Color3.fromRGB(70,70,70)})
        end)

        local sectionObj = {}

        function sectionObj:CreateButton(text, desc, callback)
            local btnFrame = Instance.new("Frame")
            btnFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btnFrame.Size = UDim2.new(1, 0, 0, 50)
            btnFrame.Parent = content

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = btnFrame

            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 12, 0, 0)
            label.Size = UDim2.new(0.6, 0, 1, 0)
            label.Text = text or "Button"
            label.TextColor3 = Color3.new(1,1,1)
            label.TextSize = 18
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = btnFrame

            local actionBtn = Instance.new("TextButton")
            actionBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            actionBtn.Position = UDim2.new(0.75, 0, 0.15, 0)
            actionBtn.Size = UDim2.new(0.23, 0, 0.7, 0)
            actionBtn.Text = "Execute"
            actionBtn.TextColor3 = Color3.new(1,1,1)
            actionBtn.Font = Enum.Font.Gotham
            actionBtn.TextSize = 16
            actionBtn.Parent = btnFrame

            local btnCorner2 = Instance.new("UICorner")
            btnCorner2.CornerRadius = UDim.new(0, 6)
            btnCorner2.Parent = actionBtn

            actionBtn.MouseButton1Click:Connect(callback or function() end)

            return btnFrame
        end

        function sectionObj:CreateTextBox(placeholder, callback)
            local boxFrame = Instance.new("Frame")
            boxFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            boxFrame.Size = UDim2.new(1, 0, 0, 50)
            boxFrame.Parent = content

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = boxFrame

            local textBox = Instance.new("TextBox")
            textBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            textBox.Position = UDim2.new(0.02, 0, 0.15, 0)
            textBox.Size = UDim2.new(0.96, 0, 0.7, 0)
            textBox.PlaceholderText = placeholder or "Text"
            textBox.Text = ""
            textBox.TextColor3 = Color3.new(1,1,1)
            textBox.PlaceholderColor3 = Color3.fromRGB(150,150,150)
            textBox.TextSize = 16
            textBox.Font = Enum.Font.Gotham
            textBox.ClearTextOnFocus = false
            textBox.Parent = boxFrame

            local tbCorner = Instance.new("UICorner")
            tbCorner.CornerRadius = UDim.new(0, 6)
            tbCorner.Parent = textBox

            textBox.FocusLost:Connect(function(enterPressed)
                if enterPressed and callback then
                    callback(textBox.Text)
                end
            end)

            return textBox
        end

        function sectionObj:CreateSlider(name, default, min, max, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            sliderFrame.Size = UDim2.new(1, 0, 0, 60)
            sliderFrame.Parent = content

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = sliderFrame

            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 0.4, 0)
            label.Text = name or "Slider"
            label.TextColor3 = Color3.new(1,1,1)
            label.TextSize = 16
            label.Font = Enum.Font.Gotham
            label.Parent = sliderFrame

            local valueLabel = Instance.new("TextLabel")
            valueLabel.BackgroundTransparency = 1
            valueLabel.Position = UDim2.new(0.75, 0, 0, 0)
            valueLabel.Size = UDim2.new(0.25, 0, 0.4, 0)
            valueLabel.Text = tostring(default)
            valueLabel.TextColor3 = Color3.new(1,1,1)
            valueLabel.TextSize = 16
            valueLabel.Parent = sliderFrame

            local bar = Instance.new("Frame")
            bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            bar.Position = UDim2.new(0.05, 0, 0.55, 0)
            bar.Size = UDim2.new(0.9, 0, 0.15, 0)
            bar.Parent = sliderFrame

            local fill = Instance.new("Frame")
            fill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.Parent = bar

            local knob = Instance.new("Frame")
            knob.BackgroundColor3 = Color3.new(1,1,1)
            knob.Position = UDim2.new(1, -10, 0.5, -10)
            knob.Size = UDim2.new(0, 20, 0, 20)
            knob.AnchorPoint = Vector2.new(0.5, 0.5)
            knob.Parent = fill

            local knobCorner = Instance.new("UICorner")
            knobCorner.CornerRadius = UDim.new(1, 0)
            knobCorner.Parent = knob

            local dragging = false

            knob.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)

            knob.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            RunService.RenderStepped:Connect(function()
                if dragging then
                    local mousePos = UserInputService:GetMouseLocation()
                    local relative = math.clamp((mousePos.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * relative)

                    fill.Size = UDim2.new(relative, 0, 1, 0)
                    valueLabel.Text = tostring(value)

                    if callback then
                        callback(value)
                    end
                end
            end)

            return {Set = function(v)
                local rel = math.clamp((v - min) / (max - min), 0, 1)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                valueLabel.Text = tostring(v)
            end}
        end

        return sectionObj
    end

    -- Auto open first section if any
    task.delay(0.1, function()
        if #SideBar:GetChildren() > 0 then
            local first = SideBar:GetChildren()[1]
            if first:IsA("TextButton") then
                first:InputBegan:Fire(Enum.UserInputType.MouseButton1)
            end
        end
    end)

    return window
end

return Library
