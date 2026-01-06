-- Gọi thư viện giao diện
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Tạo Cửa Sổ Chính
local Window = OrionLib:MakeWindow({
    Name = "NCT Hub | Blox Fruit", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "NCTHubConfig",
    IntroText = "Loading NCT Hub..."
})

-- BIẾN TOÀN CỤC (Variables)
_G.AutoFarm = false
_G.AutoBuso = true

-- HÀM DI CHUYỂN (TWEEN) - Giúp bay đến mục tiêu
function Tween(Target)
    local Distance = (Target.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    local Speed = 300 -- Tốc độ bay
    local TweenServ = game:GetService("TweenService")
    local Info = TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear)
    local Tween = TweenServ:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, Info, {CFrame = Target})
    Tween:Play()
end

-- HÀM KIỂM TRA LEVEL VÀ NHIỆM VỤ (Dựa trên banana.txt)
function CheckLevel()
    local Level = game:GetService("Players").LocalPlayer.Data.Level.Value
    -- Ví dụ Sea 1 (Bạn có thể thêm tiếp các đảo khác từ file banana.txt vào đây)
    if Level >= 1 and Level <= 9 then
        NameQuest = "BanditQuest1"
        QuestLv = 1
        NameMon = "Bandit"
        CFrameQ = CFrame.new(1060.9, 16.4, 1547.7)
        CFrameMon = CFrame.new(1038.5, 41.2, 1576.5)
    elseif Level >= 10 and Level <= 14 then
        NameQuest = "JungleQuest"
        QuestLv = 1
        NameMon = "Monkey"
        CFrameQ = CFrame.new(-1601.6, 36.8, 153.3)
        CFrameMon = CFrame.new(-1448.1, 50.8, 63.6)
    end
end

-- TAB HOME
local HomeTab = Window:MakeTab({ Name = "Tab Home", Icon = "rbxassetid://4483345998" })
HomeTab:AddLabel("Chủ sở hữu: CONGTHANHIOS")
HomeTab:AddButton({
    Name = "Sao chép Facebook",
    Callback = function()
        setclipboard("https://www.facebook.com/nguyencongthanh06")
        OrionLib:MakeNotification({Name = "NCT Hub", Content = "Đã sao chép!", Time = 3})
    end
})

-- TAB FARMING
local FarmingTab = Window:MakeTab({ Name = "Tab Farming", Icon = "rbxassetid://4483345998" })

FarmingTab:AddToggle({
    Name = "Auto Farm Level",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
    end    
})

-- LUỒNG XỬ LÝ AUTO FARM
spawn(function()
    while true do
        task.wait()
        if _G.AutoFarm then
            pcall(function()
                CheckLevel()
                -- Nếu chưa có quest thì đi nhận
                if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
                    Tween(CFrameQ)
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQ.Position).Magnitude <= 5 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
                    end
                else
                    -- Đã có quest, đi đánh quái
                    for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
                        if v.Name == NameMon and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            repeat
                                task.wait()
                                -- Tự bật Haki
                                if _G.AutoBuso and not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                                end
                                -- Gom quái và đánh
                                v.HumanoidRootPart.CanCollide = false
                                v.HumanoidRootPart.CFrame = CFrameMon
                                Tween(v.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0))
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Attack", v.HumanoidRootPart.CFrame)
                            until not _G.AutoFarm or v.Humanoid.Health <= 0
                        end
                    end
                    -- Nếu không tìm thấy quái trong Workspace thì bay tới chỗ quái spawn
                    Tween(CFrameMon)
                end
            end)
        end
    end
end)

-- CHỐNG AFK
game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

OrionLib:Init()
