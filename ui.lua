local Library = {}

function Library:Create(title, titleColor)
    titleColor = titleColor or Color3.new(1, 1, 1)
    
    -- Add space to title
    title = " " .. (title or "UI")
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CustomUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.BackgroundColor3 = Color3.new(0.133333, 0.133333, 0.133333)
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.37, 0, 0.29, 0)
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = mainFrame
    
    -- Top Bar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647)
    topBar.BorderSizePixel = 0
    topBar.Size = UDim2.new(1, 0, 0, 45)
    topBar.Parent = mainFrame
    
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 8)
    topCorner.Parent = topBar
    
    -- Fix corner at bottom
    local topFix = Instance.new("Frame")
    topFix.BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647)
    topFix.BorderSizePixel = 0
    topFix.Position = UDim2.new(0, 0, 0.5, 0)
    topFix.Size = UDim2.new(1, 0, 0.5, 0)
    topFix.Parent = topBar
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Text = title
    titleLabel.TextColor3 = titleColor
    titleLabel.TextSize = 24
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar
    
    -- Minimize Button
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "Minimize"
    minimizeBtn.BackgroundColor3 = Color3.new(0.133333, 0.133333, 0.133333)
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Position = UDim2.new(1, -40, 0.5, -15)
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Font = Enum.Font.SourceSansBold
    minimizeBtn.Text = "—"
    minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
    minimizeBtn.TextSize = 20
    minimizeBtn.Parent = topBar
    
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 6)
    minCorner.Parent = minimizeBtn
    
    -- Side Bar
    local sideBar = Instance.new("Frame")
    sideBar.Name = "SideBar"
    sideBar.BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647)
    sideBar.BorderSizePixel = 0
    sideBar.Position = UDim2.new(0, 0, 0, 45)
    sideBar.Size = UDim2.new(0, 150, 1, -45)
    sideBar.Parent = mainFrame
    
    local sideCorner = Instance.new("UICorner")
    sideCorner.CornerRadius = UDim.new(0, 8)
    sideCorner.Parent = sideBar
    
    -- Fix corner at top and right
    local sideFix1 = Instance.new("Frame")
    sideFix1.BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647)
    sideFix1.BorderSizePixel = 0
    sideFix1.Size = UDim2.new(1, 0, 0, 8)
    sideFix1.Parent = sideBar
    
    local sideFix2 = Instance.new("Frame")
    sideFix2.BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647)
    sideFix2.BorderSizePixel = 0
    sideFix2.Position = UDim2.new(1, -8, 0, 0)
    sideFix2.Size = UDim2.new(0, 8, 1, 0)
    sideFix2.Parent = sideBar
    
    -- Container for section buttons
    local sectionContainer = Instance.new("Frame")
    sectionContainer.BackgroundTransparency = 1
    sectionContainer.Position = UDim2.new(0, 5, 0, 10)
    sectionContainer.Size = UDim2.new(1, -10, 1, -20)
    sectionContainer.Parent = sideBar
    
    local sectionLayout = Instance.new("UIListLayout")
    sectionLayout.Padding = UDim.new(0, 8)
    sectionLayout.Parent = sectionContainer
    
    -- Main Content Area
    local mainContent = Instance.new("Frame")
    mainContent.Name = "Main"
    mainContent.BackgroundTransparency = 1
    mainContent.Position = UDim2.new(0, 155, 0, 50)
    mainContent.Size = UDim2.new(1, -160, 1, -55)
    mainContent.Parent = mainFrame
    
    -- Dragging
    local dragging, dragInput, dragStart, startPos
    local isMinimized = false
    local originalSize = mainFrame.Size
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Minimize functionality
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            minimizeBtn.Text = "+"
            mainFrame:TweenSize(UDim2.new(0, mainFrame.AbsoluteSize.X, 0, 45), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        else
            minimizeBtn.Text = "—"
            mainFrame:TweenSize(originalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        end
    end)
    
    -- Window object
    local Window = {
        Frame = mainFrame,
        Sections = {},
        CurrentSection = nil
    }
    
    function Window:Section(name)
        -- Create section button
        local sectionBtn = Instance.new("TextButton")
        sectionBtn.Name = name
        sectionBtn.BackgroundColor3 = Color3.new(0.129412, 0.129412, 0.129412)
        sectionBtn.BorderSizePixel = 0
        sectionBtn.Size = UDim2.new(1, 0, 0, 35)
        sectionBtn.Font = Enum.Font.SourceSansBold
        sectionBtn.Text = name
        sectionBtn.TextColor3 = Color3.new(1, 1, 1)
        sectionBtn.TextSize = 16
        sectionBtn.Parent = sectionContainer
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = sectionBtn
        
        -- Create section content frame
        local sectionFrame = Instance.new("ScrollingFrame")
        sectionFrame.Name = name .. "Content"
        sectionFrame.BackgroundTransparency = 1
        sectionFrame.BorderSizePixel = 0
        sectionFrame.Size = UDim2.new(1, 0, 1, 0)
        sectionFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        sectionFrame.ScrollBarThickness = 4
        sectionFrame.Visible = false
        sectionFrame.Parent = mainContent
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 10)
        contentLayout.Parent = sectionFrame
        
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            sectionFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
        end)
        
        -- Section button click
        sectionBtn.MouseButton1Click:Connect(function()
            for _, section in pairs(Window.Sections) do
                section.Frame.Visible = false
                section.Button.BackgroundColor3 = Color3.new(0.129412, 0.129412, 0.129412)
            end
            sectionFrame.Visible = true
            sectionBtn.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
            Window.CurrentSection = Section
        end)
        
        -- Show first section by default
        if #Window.Sections == 0 then
            sectionFrame.Visible = true
            sectionBtn.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
        end
        
        local Section = {
            Frame = sectionFrame,
            Button = sectionBtn
        }
        
        table.insert(Window.Sections, Section)
        
        function Section:Button(text, callback)
            local buttonFrame = Instance.new("Frame")
            buttonFrame.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
            buttonFrame.BorderSizePixel = 0
            buttonFrame.Size = UDim2.new(1, 0, 0, 40)
            buttonFrame.Parent = sectionFrame
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 6)
            frameCorner.Parent = buttonFrame
            
            local label = Instance.new("TextLabel")
            label.BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647)
            label.BorderSizePixel = 0
            label.Position = UDim2.new(0, 10, 0.5, -12)
            label.Size = UDim2.new(0.65, -15, 0, 24)
            label.Font = Enum.Font.SourceSans
            label.Text = text
            label.TextColor3 = Color3.new(1, 1, 1)
            label.TextSize = 16
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = buttonFrame
            
            local labelCorner = Instance.new("UICorner")
            labelCorner.CornerRadius = UDim.new(0, 4)
            labelCorner.Parent = label
            
            local btn = Instance.new("TextButton")
            btn.BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647)
            btn.BorderSizePixel = 0
            btn.Position = UDim2.new(0.65, 5, 0.5, -12)
            btn.Size = UDim2.new(0.35, -15, 0, 24)
            btn.Font = Enum.Font.SourceSans
            btn.Text = "Execute"
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.TextSize = 16
            btn.Parent = buttonFrame
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                if callback then
                    callback()
                end
            end)
        end
        
        function Section:TextBox(text, callback)
            local textBoxFrame = Instance.new("Frame")
            textBoxFrame.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
            textBoxFrame.BorderSizePixel = 0
            textBoxFrame.Size = UDim2.new(1, 0, 0, 40)
            textBoxFrame.Parent = sectionFrame
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 6)
            frameCorner.Parent = textBoxFrame
            
            local textBox = Instance.new("TextBox")
            textBox.BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647)
            textBox.BorderSizePixel = 0
            textBox.Position = UDim2.new(0, 10, 0.5, -12)
            textBox.Size = UDim2.new(1, -20, 0, 24)
            textBox.Font = Enum.Font.SourceSans
            textBox.PlaceholderText = text
            textBox.Text = ""
            textBox.TextColor3 = Color3.new(1, 1, 1)
            textBox.TextSize = 16
            textBox.Parent = textBoxFrame
            
            local boxCorner = Instance.new("UICorner")
            boxCorner.CornerRadius = UDim.new(0, 4)
            boxCorner.Parent = textBox
            
            textBox.FocusLost:Connect(function(enter)
                if callback then
                    callback(textBox.Text)
                end
            end)
        end
        
        function Section:Slider(text, min, max, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Size = UDim2.new(1, 0, 0, 50)
            sliderFrame.Parent = sectionFrame
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 6)
            frameCorner.Parent = sliderFrame
            
            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 10, 0, 5)
            label.Size = UDim2.new(1, -20, 0, 15)
            label.Font = Enum.Font.SourceSansBold
            label.Text = text .. ": " .. default
            label.TextColor3 = Color3.new(1, 1, 1)
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = sliderFrame
            
            local sliderBg = Instance.new("Frame")
            sliderBg.BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647)
            sliderBg.BorderSizePixel = 0
            sliderBg.Position = UDim2.new(0, 10, 0, 28)
            sliderBg.Size = UDim2.new(1, -20, 0, 12)
            sliderBg.Parent = sliderFrame
            
            local bgCorner = Instance.new("UICorner")
            bgCorner.CornerRadius = UDim.new(0, 6)
            bgCorner.Parent = sliderBg
            
            local sliderFill = Instance.new("Frame")
            sliderFill.BackgroundColor3 = Color3.new(0.3, 0.6, 1)
            sliderFill.BorderSizePixel = 0
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.Parent = sliderBg
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(0, 6)
            fillCorner.Parent = sliderFill
            
            local dragging = false
            
            local function update(input)
                local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * pos)
                sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                label.Text = text .. ": " .. value
                if callback then
                    callback(value)
                end
            end
            
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    update(input)
                end
            end)
            
            sliderBg.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input)
                end
            end)
        end
        
        return Section
    end
    
    return Window
end

return Library
