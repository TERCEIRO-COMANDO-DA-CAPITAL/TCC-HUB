--[[
    T.C.C HUB - FLUENT UI LIBRARY (V3)
    Baseada na arquitetura RedZ mas com Design Moderno
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local TCC_Lib = {
    Toggled = true,
    Accent = Color3.fromRGB(0, 120, 215), -- Azul Microsoft Fluent
    Tabs = {},
    Flags = {},
}

-- [ UTILITÁRIOS VISUAIS ]
local function ApplyAcrylic(frame)
    local blur = Instance.new("BlurEffect", game.Lighting)
    blur.Size = 20
    frame.BackgroundTransparency = 0.1
    return blur
end

function TCC_Lib:CreateWindow(options)
    local Title = options.Title or "T.C.C HUB"
    local SubTitle = options.SubTitle or "Fluent UI"

    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "TCC_Fluent"
    ScreenGui.IgnoreGuiInset = true

    -- Main Frame (Design Moderno)
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    
    local MainCorner = Instance.new("UICorner", Main)
    MainCorner.CornerRadius = UDim.new(0, 12)
    
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(40, 40, 40)
    Stroke.Thickness = 1.2

    -- Sidebar (Abas Modernas)
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 180, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)
    
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -60)
    TabContainer.Position = UDim2.new(0, 0, 0, 50)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 5)

    -- Header
    local Header = Instance.new("TextLabel", Sidebar)
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.Text = "  " .. Title
    Header.Font = Enum.Font.GothamBold
    Header.TextColor3 = Color3.new(1,1,1)
    Header.TextSize = 16
    Header.TextXAlignment = "Left"
    Header.BackgroundTransparency = 1

    -- Pages Container
    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.new(1, -190, 1, -20)
    Pages.Position = UDim2.new(0, 185, 0, 10)
    Pages.BackgroundTransparency = 1

    local Window = {}

    function Window:CreateTab(name, icon)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, -10, 0, 35)
        TabBtn.Position = UDim2.new(0, 5, 0, 0)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "        " .. name
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = "Left"
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local IconImg = Instance.new("ImageLabel", TabBtn)
        IconImg.Size = UDim2.new(0, 20, 0, 20)
        IconImg.Position = UDim2.new(0, 8, 0.5, -10)
        IconImg.Image = icon or "rbxassetid://10709752035"
        IconImg.BackgroundTransparency = 1
        IconImg.ImageColor3 = Color3.fromRGB(200, 200, 200)

        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.AutomaticCanvasSize = "Y"
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages:GetChildren()) do p.Visible = false end
            for _, b in pairs(TabContainer:GetChildren()) do 
                if b:IsA("TextButton") then
                    TweenService:Create(b, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
                end
            end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0, TextColor3 = Color3.new(1,1,1)}):Play()
        end)

        -- Criar Elementos (Toggle, Button, etc)
        local Elements = {}

        function Elements:CreateToggle(text, callback)
            local state = false
            local TglFrame = Instance.new("Frame", Page)
            TglFrame.Size = UDim2.new(1, -10, 0, 40)
            TglFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Instance.new("UICorner", TglFrame).CornerRadius = UDim.new(0, 6)
            
            local Label = Instance.new("TextLabel", TglFrame)
            Label.Text = text
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.TextColor3 = Color3.fromRGB(230, 230, 230)
            Label.Font = Enum.Font.Gotham; Label.TextSize = 14; Label.TextXAlignment = "Left"; Label.BackgroundTransparency = 1

            local Switch = Instance.new("Frame", TglFrame)
            Switch.Size = UDim2.new(0, 34, 0, 18)
            Switch.Position = UDim2.new(1, -44, 0.5, -9)
            Switch.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

            local Dot = Instance.new("Frame", Switch)
            Dot.Size = UDim2.new(0, 12, 0, 12)
            Dot.Position = UDim2.new(0, 3, 0.5, -6)
            Dot.BackgroundColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

            TglFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    state = not state
                    local goal = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
                    TweenService:Create(Dot, TweenInfo.new(0.2), {Position = goal}):Play()
                    TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = state and TCC_Lib.Accent or Color3.fromRGB(50, 50, 50)}):Play()
                    callback(state)
                end
            end)
        end

        return Elements
    end
    return Window
end

return TCC_Lib
