local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Tạo Cửa Sổ Chính
local Window = OrionLib:MakeWindow({
    Name = "NCT Hub | by CONGTHANHIOS", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "NCTHubConfig",
    IntroText = "Loading NCT Hub..."
})

-- TAB HOME
local HomeTab = Window:MakeTab({
	Name = "Tab Home",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

HomeTab:AddLabel("Information")
HomeTab:AddParagraph("Facebook Link","https://www.facebook.com/nguyencongthanh06")

HomeTab:AddButton({
	Name = "Sao chép link Facebook",
	Callback = function()
		setclipboard("https://www.facebook.com/nguyencongthanh06")
        -- Sửa tên thông báo thành NCT Hub cho đồng bộ
        OrionLib:MakeNotification({Name = "NCT Hub", Content = "Đã sao chép link FB!", Time = 5})
	end    
})

HomeTab:AddLabel("--- Server Status ---")
-- Tạo các Label để cập nhật động
local TimeLabel = HomeTab:AddLabel("Time: Updating...")
local MirageLabel = HomeTab:AddLabel("Mirage Island: Checking...")
local KitsuneLabel = HomeTab:AddLabel("Kitsune Island: Checking...")

-- Vòng lặp cập nhật thông tin Server (Thời gian & Đảo)
spawn(function()
    while true do
        task.wait(1)
        -- Cập nhật thời gian thực
        TimeLabel:Set("Time: " .. os.date("%X"))
        
        -- Kiểm tra Đảo Mirage (Logic cơ bản cho Blox Fruits)
        if game.Workspace:FindFirstChild("Mirage Island") then
            MirageLabel:Set("Mirage Island Status: ✅ Xuất hiện!")
        else
            MirageLabel:Set("Mirage Island Status: ❌ Chưa có")
        end

        -- Kiểm tra Đảo Kitsune
        if game.Workspace:FindFirstChild("Kitsune Island") then
            KitsuneLabel:Set("Kitsune Island Status: ✅ Xuất hiện!")
        else
            KitsuneLabel:Set("Kitsune Island Status: ❌ Chưa có")
        end
    end
end)

-- TAB FARMING
local FarmingTab = Window:MakeTab({ Name = "Tab Farming", Icon = "rbxassetid://4483345998" })

FarmingTab:AddToggle({
	Name = "Auto Farm Level",
	Default = false,
	Callback = function(Value)
		_G.AutoFarm = Value
		spawn(function()
			while _G.AutoFarm do
				task.wait()
				-- Bạn hãy dán Code Farm của game bạn vào đây
				-- Ví dụ: game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Attack")
			end
		end)
	end    
})

-- CÁC TAB CÒN LẠI
local SettingTab = Window:MakeTab({ Name = "Tab Setting", Icon = "rbxassetid://4483345998" })
local FishingTab = Window:MakeTab({ Name = "Tab Fishing", Icon = "rbxassetid://4483345998" })
local SeaEventTab = Window:MakeTab({ Name = "Tab Sea Event", Icon = "rbxassetid://4483345998" })
local FruitTab = Window:MakeTab({ Name = "Tab Fruit And Raid", Icon = "rbxassetid://4483345998" })
local TeleportTab = Window:MakeTab({ Name = "Tab Teleport", Icon = "rbxassetid://4483345998" })

-- Chống AFK (Để treo máy không bị văng)
local VirtualUser = game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

OrionLib:Init()