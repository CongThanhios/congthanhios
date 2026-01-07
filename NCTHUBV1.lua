-- =========================
-- WAIT LOAD
-- =========================
repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
repeat task.wait() until player.Character
repeat task.wait() until player:FindFirstChild("Data")
repeat task.wait() until player.Data:FindFirstChild("Level")

-- =========================
-- GLOBAL
-- =========================
_G.AutoFarm = false
_G.AutoBuso = true
_G.SelectWeapon = "Melee"

-- =========================
-- SEA CHECK
-- =========================
local Sea1, Sea2, Sea3 = false, false, false
if game.PlaceId == 2753915549 then
    Sea1 = true
elseif game.PlaceId == 4442272183 then
    Sea2 = true
elseif game.PlaceId == 7449423635 then
    Sea3 = true
end

-- =========================
-- ORION UI
-- =========================
local OrionLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/shlexware/Orion/main/source"
))()

local Window = OrionLib:MakeWindow({
    Name = "NCT Hub | Delta & Skibx",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "NCTHub",
    IntroText = "Loading NCT Hub..."
})

-- =========================
-- HOME TAB
-- =========================
local HomeTab = Window:MakeTab({
    Name = "Home",
    Icon = "rbxassetid://4483345998"
})

HomeTab:AddLabel("Owner: CongThanhios")

local SeaText = Sea1 and "Sea 1" or Sea2 and "Sea 2" or Sea3 and "Sea 3" or "Unknown"

HomeTab:AddParagraph(
    "Thông Tin",
    "Level: "..player.Data.Level.Value..
    "\nSea: "..SeaText
)

-- COPY DISCORD (DELTA + SKIBX OK)
HomeTab:AddButton({
    Name = "📌 Copy Discord",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/yourlink")
        elseif toclipboard then
            toclipboard("https://discord.gg/yourlink")
        end
        OrionLib:MakeNotification({
            Name = "NCT Hub",
            Content = "Đã copy Discord!",
            Time = 3
        })
    end
})

-- =========================
-- FARM TAB
-- =========================
local FarmTab = Window:MakeTab({
    Name = "Farm",
    Icon = "rbxassetid://4483345998"
})

FarmTab:AddToggle({
    Name = "Auto Farm Level",
    Default = false,
    Callback = function(v)
        _G.AutoFarm = v
    end
})

-- =========================
-- TWEEN (AN TOÀN DELTA)
-- =========================
local TweenService = game:GetService("TweenService")
local function Tween(cf)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local dist = (hrp.Position - cf.Position).Magnitude
    local info = TweenInfo.new(dist / 150, Enum.EasingStyle.Linear)
    TweenService:Create(hrp, info, {CFrame = cf}):Play()
end

-- =========================
-- CHECK LEVEL
-- =========================
function CheckLevel()
    local lv = player.Data.Level.Value

    if Sea1 then
        if lv <= 9 then
            NameMon = "Bandit"
            NameQuest = "BanditQuest1"
            QuestLv = 1
            CFrameQ = CFrame.new(1060,16,1547)
            CFrameMon = CFrame.new(1038,41,1576)
        elseif lv <= 14 then
            NameMon = "Monkey"
            NameQuest = "JungleQuest"
            QuestLv = 1
            CFrameQ = CFrame.new(-1601,36,153)
            CFrameMon = CFrame.new(-1448,50,63)
        end
    end
end

-- =========================
-- EQUIP WEAPON
-- =========================
function EquipTool()
    for _,v in pairs(player.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            player.Character.Humanoid:EquipTool(v)
            break
        end
    end
end

-- =========================
-- AUTO FARM CORE (DELTA SAFE)
-- =========================
task.spawn(function()
    while task.wait(0.3) do
        if _G.AutoFarm then
            pcall(function()
                CheckLevel()

                -- BUSO
                if _G.AutoBuso and not player.Character:FindFirstChild("HasBuso") then
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
                end

                -- QUEST
                if not player.PlayerGui.Main.Quest.Visible then
                    Tween(CFrameQ)
                    if (player.Character.HumanoidRootPart.Position - CFrameQ.Position).Magnitude < 10 then
                        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                            "StartQuest", NameQuest, QuestLv
                        )
                    end
                else
                    for _,mob in pairs(workspace.Enemies:GetChildren()) do
                        if mob.Name == NameMon
                        and mob:FindFirstChild("HumanoidRootPart")
                        and mob.Humanoid.Health > 0 then

                            EquipTool()
                            player.Character.HumanoidRootPart.CFrame =
                                mob.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
                        end
                    end
                end
            end)
        end
    end
end)

-- =========================
-- INIT UI
-- =========================
OrionLib:Init()
