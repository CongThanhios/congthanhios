-- WAIT LOAD
repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
repeat task.wait() until player.Character
repeat task.wait() until player:FindFirstChild("Data")
repeat task.wait() until player.Data:FindFirstChild("Level")

-- UI
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({
    Name = "NCT Hub | Blox Fruit",
    SaveConfig = true,
    ConfigFolder = "NCTHub"
})

-- GLOBAL
_G.AutoFarm = false
_G.AutoBuso = true
_G.SelectWeapon = "Melee"

-- SEA
local Sea1 = game.PlaceId == 2753915549
local Sea2 = game.PlaceId == 4442272183
local Sea3 = game.PlaceId == 7449423635

-- TWEEN
function Tween(cf)
    local hrp = player.Character:WaitForChild("HumanoidRootPart")
    local dist = (cf.Position - hrp.Position).Magnitude
    game:GetService("TweenService"):Create(
        hrp,
        TweenInfo.new(dist/200, Enum.EasingStyle.Linear),
        {CFrame = cf}
    ):Play()
end

-- CHECK LEVEL (SEA 1 DEMO)
function CheckLevel()
    local lv = player.Data.Level.Value
    if Sea1 then
        if lv <= 9 then
            NameMon="Bandit"; NameQuest="BanditQuest1"; QuestLv=1
            CFrameQ=CFrame.new(1060,16,1547); CFrameMon=CFrame.new(1038,41,1576)
        elseif lv <= 14 then
            NameMon="Monkey"; NameQuest="JungleQuest"; QuestLv=1
            CFrameQ=CFrame.new(-1601,36,153); CFrameMon=CFrame.new(-1448,50,63)
        elseif lv <= 29 then
            NameMon="Gorilla"; NameQuest="JungleQuest"; QuestLv=2
            CFrameQ=CFrame.new(-1601,36,153); CFrameMon=CFrame.new(-1142,40,-515)
        end
    end
end

-- EQUIP
function EquipTool()
    for _,v in pairs(player.Backpack:GetChildren()) do
        if v:IsA("Tool") and (v.ToolTip == _G.SelectWeapon or v.Name == _G.SelectWeapon) then
            player.Character.Humanoid:EquipTool(v)
        end
    end
end

-- UI TAB
local Home = Window:MakeTab({Name="Home",Icon="rbxassetid://4483345998"})
Home:AddLabel("Owner: CONGTHANHIOS")

local Farm = Window:MakeTab({Name="Farm",Icon="rbxassetid://4483345998"})
Farm:AddToggle({
    Name="Auto Farm Level",
    Default=false,
    Callback=function(v) _G.AutoFarm=v end
})

-- FARM CORE (SAFE)
task.spawn(function()
    while task.wait(0.3) do
        if not _G.AutoFarm then continue end
        pcall(function()
            CheckLevel()
            if not NameMon then return end

            local char = player.Character
            local hrp = char.HumanoidRootPart
            local hum = char.Humanoid

            if _G.AutoBuso and not char:FindFirstChild("HasBuso") then
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
            end

            if not player.PlayerGui.Main.Quest.Visible then
                Tween(CFrameQ)
                if (hrp.Position - CFrameQ.Position).Magnitude < 10 then
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest",NameQuest,QuestLv)
                end
            else
                for _,mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob.Name:find(NameMon) and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                        EquipTool()
                        hrp.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                        task.wait(0.1)
                        game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0))
                    end
                end
            end
        end)
    end
end)

-- ANTI AFK
player.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

OrionLib:Init()
