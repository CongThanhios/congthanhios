--==================================================
-- NCT HUB | GRAVITY STYLE UI (DELTA / SKIBX)
-- Owner : CongThanhios
-- FULL UI + FULL CORE (SAFE)
--==================================================

-------------------- WAIT LOAD ----------------------
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-------------------- SERVICES -----------------------
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
repeat task.wait() until player.Character
repeat task.wait() until player:FindFirstChild("Data")
repeat task.wait() until player.Data:FindFirstChild("Level")

-------------------- CLEAN UI -----------------------
pcall(function()
    if game.CoreGui:FindFirstChild("NCT_HUB_UI") then
        game.CoreGui.NCT_HUB_UI:Destroy()
    end
end)

-------------------- GLOBAL -------------------------
_G.AutoFarmLevel = false
_G.AutoBoss = false
_G.AutoSeaEvent = false
_G.AutoBuso = true
_G.SelectWeapon = "Melee"

-------------------- SEA CHECK ----------------------
local Sea = 0
if game.PlaceId == 2753915549 then Sea = 1 end
if game.PlaceId == 4442272183 then Sea = 2 end
if game.PlaceId == 7449423635 then Sea = 3 end

-------------------- TWEEN --------------------------
local function TweenTo(cf)
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local dist = (hrp.Position - cf.Position).Magnitude
    TweenService:Create(
        hrp,
        TweenInfo.new(dist/300, Enum.EasingStyle.Linear),
        {CFrame = cf}
    ):Play()
end

-------------------- EQUIP --------------------------
local function EquipWeapon()
    for _,v in pairs(player.Backpack:GetChildren()) do
        if v:IsA("Tool") and (v.ToolTip == _G.SelectWeapon or v.Name == _G.SelectWeapon) then
            player.Character.Humanoid:EquipTool(v)
            break
        end
    end
end

-------------------- CHECK LEVEL (SEA 1) -------------
local NameMon, NameQuest, QuestLv, CFrameQ, CFrameMon
local function CheckLevel()
    local lv = player.Data.Level.Value
    if Sea == 1 then
        if lv <= 9 then
            NameMon="Bandit"
            NameQuest="BanditQuest1"
            QuestLv=1
            CFrameQ=CFrame.new(1060,16,1547)
            CFrameMon=CFrame.new(1038,41,1576)
        elseif lv <= 14 then
            NameMon="Monkey"
            NameQuest="JungleQuest"
            QuestLv=1
            CFrameQ=CFrame.new(-1601,36,153)
            CFrameMon=CFrame.new(-1448,50,63)
        end
    end
end

-------------------- UI -----------------------------
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "NCT_HUB_UI"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromScale(0.65,0.65)
Main.Position = UDim2.fromScale(0.175,0.175)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,16)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.fromScale(0.23,1)
Sidebar.BackgroundColor3 = Color3.fromRGB(14,14,14)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0,16)

local Holder = Instance.new("Frame", Main)
Holder.Size = UDim2.fromScale(0.77,1)
Holder.Position = UDim2.fromScale(0.23,0)
Holder.BackgroundTransparency = 1

local Pages = {}

local function CreateTab(name,icon)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.fromScale(0.9,0.07)
    btn.Text = icon.." "..name
    btn.BackgroundColor3 = Color3.fromRGB(26,26,26)
    btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner",btn)

    local page = Instance.new("Frame", Holder)
    page.Size = UDim2.fromScale(1,1)
    page.Visible = false
    page.BackgroundTransparency = 1

    btn.MouseButton1Click:Connect(function()
        for _,p in pairs(Pages) do p.Visible=false end
        page.Visible=true
    end)

    table.insert(Pages,page)
    return page
end

local Home = CreateTab("Home","🏠")
local Farming = CreateTab("Farming","⚔")
Pages[1].Visible = true

-------------------- HOME ---------------------------
local title = Instance.new("TextLabel", Home)
title.Size = UDim2.fromScale(1,0.3)
title.Text = "NCT HUB\nGravity Style\nDelta / Skibx"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.BackgroundTransparency = 1

-------------------- FARM TOGGLE --------------------
local btn = Instance.new("TextButton", Farming)
btn.Size = UDim2.fromScale(0.5,0.1)
btn.Position = UDim2.fromScale(0.05,0.05)
btn.Text = "Auto Farm : OFF"
btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
btn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",btn)

btn.MouseButton1Click:Connect(function()
    _G.AutoFarmLevel = not _G.AutoFarmLevel
    btn.Text = "Auto Farm : "..(_G.AutoFarmLevel and "ON" or "OFF")
end)

-------------------- CORE LOOP ----------------------
task.spawn(function()
    while task.wait(0.4) do
        if _G.AutoFarmLevel then
            pcall(function()
                CheckLevel()
                local char = player.Character
                local hrp = char.HumanoidRootPart

                if _G.AutoBuso and not char:FindFirstChild("HasBuso") then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
                end

                if not player.PlayerGui.Main.Quest.Visible then
                    TweenTo(CFrameQ)
                    if (hrp.Position - CFrameQ.Position).Magnitude < 15 then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer(
                            "StartQuest",NameQuest,QuestLv
                        )
                    end
                else
                    local mob = workspace.Enemies:FindFirstChild(NameMon)
                    if mob and mob:FindFirstChild("HumanoidRootPart") then
                        EquipWeapon()
                        mob.HumanoidRootPart.CanCollide=false
                        mob.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0,0,-3)
                    else
                        TweenTo(CFrameMon)
                    end
                end
            end)
        end
    end
end)

-------------------- ANTI AFK -----------------------
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

print("[NCT HUB] FULL GRAVITY SCRIPT LOADED")
