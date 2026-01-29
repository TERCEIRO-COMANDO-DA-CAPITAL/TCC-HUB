local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local Library = {
    Toggled = true,
    Accent = Color3.fromRGB(180, 0, 0), -- Dark Red
    ActiveTab = nil
}

-- Efeito Haptic (Vibração para Mobile)
local function Ripple(obj)
    spawn(function()
        local ripple = Instance.new("Frame", obj)
        ripple.BackgroundColor3 = Color3.new(1,1,1)
        ripple.BackgroundTransparency = 0.8
        ripple.ZIndex = 10
        Instance.new("UICorner", ripple).CornerRadius = UDim.new(1,0)
        ripple.Position = UDim2.new(0.5,0,0.5,0)
        TweenService:Create(ripple, TweenInfo.new(0.4), {Size = UDim2.new(1,50,1,50), BackgroundTransparency = 1}):Play()
        task.wait(0.4)
        ripple:Destroy()
    end)
end

function Library:CreateWindow(cfg)
    local MainUI = Instance.new("ScreenGui", CoreGui)
    MainUI.Name = "Nightwing_Ultra"

    -- Bolha Flutuante Glass
    local Float = Instance.new("ImageButton", MainUI)
    Float.Size = UDim2.new(0, 55, 0, 55)
    Float.Position = UDim2.new(0.1, 0, 0.2, 0)
    Float.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
    Float.Image = "rbxassetid://10723415535"
    Float.ImageColor3 = Library.Accent
    local FloatCorner = Instance.new("UICorner", Float)
    FloatCorner.CornerRadius = UDim.new(1,0)
    local FloatStroke = Instance.new("UIStroke", Float)
    FloatStroke.Color = Library.Accent
    FloatStroke.Thickness = 2

    -- Main Frame (Larga e AMOLED)
    local Main = Instance.new("CanvasGroup", MainUI)
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 650, 0, 420) -- Mais larga
    Main.Position = UDim2.new(0.5, -325, 0.5, -210)
    Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- AMOLED
    Main.BackgroundTransparency = 0.1
    Main.Visible = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
    
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Thickness = 1.2
    MainStroke.Color = Library.Accent
    MainStroke.ApplyStrokeMode = "Border"

    -- Blur Background (Glass Effect)
    local Blur = Instance.new("BlurEffect", game.Lighting)
    Blur.Size = 15
    Blur.Enabled = true

    -- Sidebar Glass
    local Side = Instance.new("Frame", Main)
    Side.Size = UDim2.new(0, 70, 1, -60)
    Side.Position = UDim2.new(0, 10, 0, 50)
    Side.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
    Side.BackgroundTransparency = 0.5
    Instance.new("UICorner", Side).CornerRadius = UDim.new(0, 12)
    
    local SideList = Instance.new("UIListLayout", Side)
    SideList.HorizontalAlignment = "Center"
    SideList.Padding = UDim.new(0, 15)
    Instance.new("UIPadding", Side).PaddingTop = UDim.new(0, 15)

    -- Container de Abas
    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -100, 1, -70)
    Container.Position = UDim2.new(0, 90, 0, 60)
    Container.BackgroundTransparency = 1

    -- Topbar
    local Top = Instance.new("Frame", Main)
    Top.Size = UDim2.new(1, 0, 0, 50)
    Top.BackgroundTransparency = 1
    
    local Title = Instance.new("TextLabel", Top)
    Title.Text = cfg.Title or "NIGHTWING"
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = "GothamBold"
    Title.TextColor3 = Library.Accent
    Title.TextSize = 20
    Title.TextXAlignment = "Left"
    Title.BackgroundTransparency = 1

    -- Logic Abrir/Fechar
    Float.MouseButton1Click:Connect(function()
        Library.Toggled = not Library.Toggled
        local targetSize = Library.Toggled and UDim2.new(0, 650, 0, 420) or UDim2.new(0, 0, 0, 0)
        TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
        Blur.Enabled = Library.Toggled
    end)

    local Tabs = {Count = 0}
    function Tabs:CreateTab(icon)
        Tabs.Count = Tabs.Count + 1
        local Btn = Instance.new("ImageButton", Side)
        Btn.Size = UDim2.new(0, 40, 0, 40)
        Btn.Image = icon
        Btn.BackgroundTransparency = 1
        Btn.ImageColor3 = (Tabs.Count == 1) and Library.Accent or Color3.fromRGB(100, 100, 100)
        
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = (Tabs.Count == 1)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 0
        Page.AutomaticCanvasSize = "Y"
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

        Btn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do v.Visible = false end
            for _, v in pairs(Side:GetChildren()) do 
                if v:IsA("ImageButton") then v.ImageColor3 = Color3.fromRGB(100, 100, 100) end
            end
            Page.Visible = true
            TweenService:Create(Btn, TweenInfo.new(0.3), {ImageColor3 = Library.Accent}):Play()
            Ripple(Btn)
        end)

        local Elements = {}

        -- Toggle Amoled Dark Red
        function Elements:CreateToggle(name, callback)
            local state = false
            local TFrame = Instance.new("Frame", Page)
            TFrame.Size = UDim2.new(1, -10, 0, 45)
            TFrame.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
            Instance.new("UICorner", TFrame).CornerRadius = UDim.new(0, 8)
            Instance.new("UIStroke", TFrame).Color = Color3.fromRGB(30, 0, 0)

            local L = Instance.new("TextLabel", TFrame)
            L.Text = name; L.Size = UDim2.new(1, 0, 1, 0); L.Position = UDim2.new(0, 15, 0, 0)
            L.TextColor3 = Color3.new(1,1,1); L.Font = "Gotham"; L.TextSize = 14; L.TextXAlignment = "Left"; L.BackgroundTransparency = 1

            local Switch = Instance.new("Frame", TFrame)
            Switch.Size = UDim2.new(0, 40, 0, 20); Switch.Position = UDim2.new(1, -50, 0.5, -10)
            Switch.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1,0)

            local Circle = Instance.new("Frame", Switch)
            Circle.Size = UDim2.new(0, 16, 0, 16); Circle.Position = UDim2.new(0, 2, 0.5, -8)
            Circle.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", Circle).CornerRadius = UDim.new(1,0)

            local B = Instance.new("TextButton", TFrame)
            B.Size = UDim2.new(1, 0, 1, 0); B.BackgroundTransparency = 1; B.Text = ""
            
            B.MouseButton1Click:Connect(function()
                state = not state
                local col = state and Library.Accent or Color3.fromRGB(30, 0, 0)
                local pos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                TweenService:Create(Switch, TweenInfo.new(0.3), {BackgroundColor3 = col}):Play()
                TweenService:Create(Circle, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = pos}):Play()
                callback(state)
                Ripple(TFrame)
            end)
        end

        function Elements:CreateSection(name)
            local S = Instance.new("TextLabel", Page)
            S.Text = "  " .. name:upper(); S.Size = UDim2.new(1, 0, 0, 30); S.Font = "GothamBold"
            S.TextColor3 = Library.Accent; S.TextSize = 12; S.TextXAlignment = "Left"; S.BackgroundTransparency = 1
        end

        return Elements
    end
    return Tabs
end

-- Exemplo de Execução
local Win = Library:CreateWindow({Title = "NIGHTWING HUB"})
local T1 = Win:CreateTab("rbxassetid://10734945638")
T1:CreateSection("Main Cheats")
T1:CreateToggle("Aimbot Ultra", function(v) end)
T1:CreateToggle("Fly Hack", function(v) end)
