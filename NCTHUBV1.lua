task.spawn(function()
    while task.wait(0.3) do
        if not _G.AutoFarm then continue end

        pcall(function()
            local Character = player.Character
            local HRP = Character:WaitForChild("HumanoidRootPart")
            local Humanoid = Character:WaitForChild("Humanoid")

            CheckLevel()
            if not NameMon or not CFrameQ or not CFrameMon then return end

            -- Auto Buso
            if _G.AutoBuso and not Character:FindFirstChild("HasBuso") then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
            end

            -- Nhận quest
            if not player.PlayerGui.Main.Quest.Visible then
                Tween(CFrameQ)
                if (HRP.Position - CFrameQ.Position).Magnitude < 10 then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(
                        "StartQuest", NameQuest, QuestLv
                    )
                end
            else
                -- Tìm quái ĐÚNG CÁCH
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob.Name:find(NameMon) and mob:FindFirstChild("HumanoidRootPart") then
                        if mob.Humanoid.Health > 0 then
                            EquipTool()

                            -- Bay tới quái (KHÔNG kéo quái)
                            HRP.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)

                            -- Đánh thường
                            Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                            task.wait(0.1)
                            game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0))
                        end
                    end
                end
            end
        end)
    end
end)
