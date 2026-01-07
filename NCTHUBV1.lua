--==================================================
-- NCT HUB | GRAVITY STYLE UI (DELTA / SKIBX)
-- Owner : CongThanhios
-- Type  : FULL UI + CORE (SAFE)
--==================================================

--==================== WAIT LOAD ====================
if not game:IsLoaded() then
    game.Loaded:Wait()
end

--==================== SERVICES =====================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

--==================== CLEAN OLD UI =================
pcall(function()
    local old = game.CoreGui:FindFirstChild("NCT_HUB_UI")
    if old then old:Destroy() end
end)

--==================== SCREEN GUI ===================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NCT_HUB_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

--==================== MAIN FRAME ===================
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromScale(0.65, 0.65)
Main.Position = UDim2.fromScale(0.175, 0.175)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,16)

--==================== SIDEBAR ======================
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.fromScale(0.23, 1)
Sidebar.BackgroundColor3 = Color3.fromRGB(14,14,14)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0,16)

local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.Padding = UDim.new(0,6)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.VerticalAlignment = Enum.VerticalAlignment.Center

--==================== PAGE HOLDER ==================
local Holder = Instance.new("Frame", Main)
Holder.Size = UDim2.fromScale(0.77, 1)
Holder.Position = UDim2.fromScale(0.23, 0)
Holder.BackgroundTransparency = 1

local Pages = {}

--==================== TAB FUNCTION =================
local function CreateTab(name, icon)
    local Button = Instance.new("TextButton", Sidebar)
    Button.Size = UDim2.fromScale(0.9, 0.07)
    Button.Text = icon .. "  " .. name
    Button.Font = Enum.Font.GothamSemibold
    Button.TextSize = 14
    Button.TextColor3 = Color3.new(1,1,1)
    Button.BackgroundColor3 = Color3.fromRGB(26,26,26)
    Button.BorderSizePixel = 0
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0,10)

    local Page = Instance.new("Frame", Holder)
    Page.Size = UDim2.fromScale(1,1)
    Page.Visible = false
    Page.BackgroundTransparency = 1

    Button.MouseButton1Click:Connect(function()
        for _,p in pairs(Pages) do
            p.Visible = false
        end
        Page.Visible = true
    end)

    table.insert(Pages, Page)
    return Page
end

--==================== TABS =========================
local Home     = CreateTab("Home","🏠")
local Farming  = CreateTab("Farming","⚔")
local Boss     = CreateTab("Boss","👑")
local Sea      = CreateTab("Sea Event","🌊")
local Teleport = CreateTab("Teleport","📍")
local Setting  = CreateTab("Setting","⚙")

Pages[1].Visible = true

--==================== GLOBAL FLAGS =================
_G.AutoFarmLevel = false
_G.AutoBoss = false
_G.AutoSeaEvent = false

--==================== HOME PAGE ====================
do
    local Title = Instance.new("TextLabel", Home)
    Title.Size = UDim2.fromScale(1,0.25)
    Title.Text = "NCT HUB\nGravity Style UI\nDelta / Skibx Ready"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22
    Title.TextColor3 = Color3.new(1,1,1)
    Title.BackgroundTransparency = 1
end

--==================== FARMING PAGE =================
do
    local Toggle = Instance.new("TextButton", Farming)
    Toggle.Size = UDim2.fromScale(0.5,0.1)
    Toggle.Position = UDim2.fromScale(0.05,0.05)
    Toggle.Text = "Auto Farm Level : OFF"
    Toggle.Font = Enum.Font.Gotham
    Toggle.TextSize = 14
    Toggle.TextColor3 = Color3.new(1,1,1)
    Toggle.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Instance.new("UICorner", Toggle)

    Toggle.MouseButton1Click:Connect(function()
        _G.AutoFarmLevel = not _G.AutoFarmLevel
        Toggle.Text = "Auto Farm Level : " .. (_G.AutoFarmLevel and "ON" or "OFF")
    end)
end

--==================== BOSS PAGE ====================
do
    local Toggle = Instance.new("TextButton", Boss)
    Toggle.Size = UDim2.fromScale(0.5,0.1)
    Toggle.Position = UDim2.fromScale(0.05,0.05)
    Toggle.Text = "Auto Boss : OFF"
    Toggle.Font = Enum.Font.Gotham
    Toggle.TextSize = 14
    Toggle.TextColor3 = Color3.new(1,1,1)
    Toggle.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Instance.new("UICorner", Toggle)

    Toggle.MouseButton1Click:Connect(function()
        _G.AutoBoss = not _G.AutoBoss
        Toggle.Text = "Auto Boss : " .. (_G.AutoBoss and "ON" or "OFF")
    end)
end

--==================== SEA EVENT PAGE ===============
do
    local Toggle = Instance.new("TextButton", Sea)
    Toggle.Size = UDim2.fromScale(0.5,0.1)
    Toggle.Position = UDim2.fromScale(0.05,0.05)
    Toggle.Text = "Auto Sea Event : OFF"
    Toggle.Font = Enum.Font.Gotham
    Toggle.TextSize = 14
    Toggle.TextColor3 = Color3.new(1,1,1)
    Toggle.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Instance.new("UICorner", Toggle)

    Toggle.MouseButton1Click:Connect(function()
        _G.AutoSeaEvent = not _G.AutoSeaEvent
        Toggle.Text = "Auto Sea Event : " .. (_G.AutoSeaEvent and "ON" or "OFF")
    end)
end

--==================== TELEPORT PAGE =================
do
    local Label = Instance.new("TextLabel", Teleport)
    Label.Size = UDim2.fromScale(1,0.15)
    Label.Text = "Teleport UI (placeholder)"
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 16
    Label.TextColor3 = Color3.new(1,1,1)
    Label.BackgroundTransparency = 1
end

--==================== SETTING PAGE =================
do
    local Label = Instance.new("TextLabel", Setting)
    Label.Size = UDim2.fromScale(1,0.15)
    Label.Text = "UI / Performance Settings"
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 16
    Label.TextColor3 = Color3.new(1,1,1)
    Label.BackgroundTransparency = 1
end

--==================== CORE LOOP ====================
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if _G.AutoFarmLevel then
                -- logic gắn sau
            end
            if _G.AutoBoss then
                -- logic gắn sau
            end
            if _G.AutoSeaEvent then
                -- logic gắn sau
            end
        end)
    end
end)

--==================== END SCRIPT ===================
