--Anti Adonis
for _, v in pairs(getgc(true)) do
    if pcall(function() return rawget(v, "indexInstance") end) and type(rawget(v, "indexInstance")) == "table" and (rawget(v, "indexInstance"))[1] == "kick" then
        v.tvk = { "kick", function() return game.Workspace:WaitForChild("") end }
    end
end

for _, v in next, getgc() do
    if typeof(v) == "function" and islclosure(v) and not isexecutorclosure(v) then
        local Constants = debug.getconstants(v)
        if table.find(Constants, "Detected") and table.find(Constants, "crash") then
            setthreadidentity(2)
            hookfunction(v, function()
                return task.wait(9e9)
            end)
            setthreadidentity(7)
        end
    end
end
--end of Anti Cheat

-- locals
local players = game:GetService("Players")
local teleportService = game:GetService("TeleportService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = replicatedStorage:WaitForChild("Remotes")
local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Data"):WaitForChild("UpdateHotbar")
local senv = getsenv(players.LocalPlayer.PlayerGui:WaitForChild("Inventory"):WaitForChild("InventoryHandle"))
local FireServer = senv._G.FireServer
local inventoryRemote = remotes.Information.InventoryManage
local localPlayer = players.LocalPlayer
local Moves = {}
local lp = game:GetService("Players").LocalPlayer
local variables = {
    ToDrop = {},
    DropToggle = false,
}
-- fuctions


local function GetUniqueToolNames()
    local uniqueToolNames = {}
    local toolsFolder = localPlayer.Backpack:FindFirstChild("Tools")
    if toolsFolder then
        for _, tool in ipairs(toolsFolder:GetChildren()) do
            if not table.find(uniqueToolNames, tool.Name) then
                table.insert(uniqueToolNames, tool.Name)
            end
        end
    end
    return uniqueToolNames
end
-- moves

-- Anti Afk
if getconnections then
    for _, v in next, getconnections(game:GetService("Players").LocalPlayer.Idled) do
        v:Disable()
    end
end

if not getconnections then
    game:GetService("Players").LocalPlayer.Idled:connect(
        function()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end
    )
end
--end

--main script

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/UnknowBest/Floppa/main/floppa.lua')))()
local Window = OrionLib:MakeWindow({
    Name = "Floppa Hub | Arcane Lineage",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "FloppaHub"
})
local Main = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://7733765398",
    PremiumOnly = false
})
local Automation = Window:MakeTab({
    Name = "Automatic",
    Icon = "rbxassetid://7733765398",
    PremiumOnly = false
})

Main:AddButton({
    Name = "Pickup All Plants",
    Callback = function()
        local avoidCFrame = CFrame.new(1465.6145, 48.1683693, -3372.54272, -0.406715393, 0, -0.913554907, 0, 1, 0,
            0.913554907, 0, -0.406715393)
        local trinkets = {}
        local originalLocation = lp.Character.HumanoidRootPart.CFrame

        for _, Trinket in pairs(game:GetService("Workspace").SpawnedItems:GetDescendants()) do
            if Trinket:IsA("Part") and Trinket.Name == "ClickPart" and Trinket.CFrame ~= avoidCFrame then
                table.insert(trinkets, Trinket)
            end
        end

        for _, Trinket in ipairs(trinkets) do
            lp.Character.HumanoidRootPart.CFrame = Trinket.CFrame
            task.wait(0.35)
            for _, v in pairs(game:GetService("Workspace").SpawnedItems:GetDescendants()) do
                if v:IsA("ClickDetector") and lp:DistanceFromCharacter(v.Parent.Position) <= 10 then
                    fireclickdetector(v)
                end
            end
        end
        lp.Character.HumanoidRootPart.CFrame = originalLocation
    end
})
function serverhop()
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    local Deleted = false

    function TPReturner()
        local Site;
        if foundAnything == "" then
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
        end
        local ID = ""
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            foundAnything = Site.nextPageCursor
        end
        local num = 0;
        for i,v in pairs(Site.data) do
            local Possible = true
            ID = tostring(v.id)
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for _,Existing in pairs(AllIDs) do
                    if num ~= 0 then
                        if ID == tostring(Existing) then
                            Possible = false
                        end
                    else
                        if tonumber(actualHour) ~= tonumber(Existing) then
                            local delFile = pcall(function()
                                -- delfile("NotSameServers.json")
                                AllIDs = {}
                                table.insert(AllIDs, actualHour)
                            end)
                        end
                    end
                    num = num + 1
                end
                if Possible == true then
                    table.insert(AllIDs, ID)
                    wait()
                    pcall(function()
                        -- writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                        wait()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                    end)
                    wait(4)
                end
            end
        end
    end

    function Teleport()
        while wait() do
            pcall(function()
                TPReturner()
                if foundAnything ~= "" then
                    TPReturner()
                end
            end)
        end
    end

    Teleport()
end
Main:AddButton({
    Name = "Server Hop",
    Default = false,
    Save = false,
Callback = function()
    serverhop()
end
})
Main:AddButton({
    Name = "Teleport To Merchant",
    Callback = function()
        if game:GetService("Workspace").NPCs:FindFirstChild("Mysterious Merchant") then
            lp.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").NPCs:FindFirstChild(
                "Mysterious Merchant").HumanoidRootPart.CFrame
        else
            OrionLib:MakeNotification({
                Name = "Mysterius Merchant Has Not Spawned",
                Content = "Can't Teleport To Mysterius Merchant, Has Not Appear",
                Image = "rbxassetid://7733765398",
                Time = 5
            })
        end
    end
})

local merchNotiEnabled = false
local merchNotifier = false
Automation:AddToggle({
    Name = "Merchant Notifier",
    Default = false,
    Save = true,
    Flag = "MerchantNoti",
    Callback = function(value)
        merchNotiEnabled = value
        if merchNotiEnabled then
            while merchNotiEnabled do
                task.wait()
                local merchant = game:GetService("Workspace").NPCs:FindFirstChild("Mysterious Merchant")
                if merchant then
                    OrionLib:MakeNotification({
                        Name = "Mysterious Merchant Detected",
                        Content = "The Mysterious Merchant Has Appear!",
                        Image = "rbxassetid://7733765398",
                        Time = 5
                    })
                    merchnotifier = true
                    task.wait(10)
                    merchnotifier = false
                end
            end
        end
    end
})

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Data"):WaitForChild("ClassMasteryData"):FireServer()
local playerGui = lp.PlayerGui
local classMastery = playerGui:WaitForChild("ClassMastery")
local main = classMastery:WaitForChild("Main")
local points = main:WaitForChild("Points")
Automation:AddToggle({
    Name = "Check Mastery Tree Points",
    Default = false,
    Save = false,
    Flag = "MasteryPoints",
    Callback = function(value)
        MasteryPoints = value
        if MasteryPoints then
            OrionLib:MakeNotification({
                Name = "Soul Points",
                Content = points.Text,
                Image = "rbxassetid://7733765398",
                Time = 10
            })
        end
    end
})
Automation:AddToggle({
    Name = "Mastery Point Notifier",
    Default = false,
    Save = true,
    Flag = "MasteryNotifier",
    Callback = function(Value)
        getgenv().MasteryNoti = Value

        lp.PlayerGui.ClassMastery.Main.Points:GetPropertyChangedSignal("Text"):Connect(function()
            if MasteryNoti then
                OrionLib:MakeNotification({
                    Name = "You Got Mastery Points ",
                    Image = "rbxassetid://7733765398",
                    Time = 10
                })
            end
        end)
    end
})
local Combat = Window:MakeTab({
    Name = "Combat",
    Icon = "rbxassetid://7733765398",
    PremiumOnly = false
})

local Floppa = false

function FloppaCollectItems()
    for _,v in pairs(workspace.Dropped:GetDescendants()) do
        if v.ClassName == "TouchTransmitter" then
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0) 
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 1) 
        end
    end
end
Automation:AddToggle({
    Name = "Pickup Items Dropped",
    Flag = "Floppa",
    Callback = function(Value)
        Floppa = Value
        if Floppa then
            while Floppa do
                FloppaCollectItems()
                task.wait()
            end
        end
    end
})
-- AutoDoch
Combat:AddToggle({
    Name = "AutoDodge",
    Default = false,
    Flag = "AutoDodge",
    Callback = function(Value)
        getgenv().AutoDodge = (Value)
        while AutoDodge do
            task.wait()
            local Floppa1 = {
                [1] = true,
                [2] = true
            }
            local Floppa2 = "DodgeMinigame"
            game:GetService("ReplicatedStorage").Remotes.Information.RemoteFunction:FireServer(Floppa1, Floppa2)
            task.wait()
        end
    end
})

Combat:AddToggle({
    Name = "Insta Auto-QTE",
    Default = false,
    Save = false,
    Flag = "AutoQTE",
    Callback = function(Value)
        getgenv().AutoQTE = (Value)
        local BaseClass = localPlayer.PlayerGui.StatMenu.Holder.ContentFrame.Stats.Body.RightColumn.Content.BaseClass.Type.Text
        while AutoQTE do
            task.wait()
            if BaseClass == "Wizard" then
                local Floppa1 = true
                local Floppa2 = "MagicQTE"
                game:GetService("ReplicatedStorage").Remotes.Information.RemoteFunction:FireServer(Floppa1, Floppa2)
                localPlayer.PlayerGui.Combat.MagicQTE.Visible = false
            elseif BaseClass == "Thief" then
                local Floppa1 = true
                local Floppa2 = "DaggerQTE"
                game:GetService("ReplicatedStorage").Remotes.Information.RemoteFunction:FireServer(Floppa1, Floppa2)
                localPlayer.PlayerGui.Combat.DaggerQTE.Visible = false
                -- Slayer
            elseif BaseClass == "Slayer" then
                local Floppa1 = true
                local Floppa2 = "SpearQTE"
                game:GetService("ReplicatedStorage").Remotes.Information.RemoteFunction:FireServer(Floppa1, Floppa2)
                localPlayer.PlayerGui.Combat.SpearQTE.Visible = false
                -- Fist
            elseif BaseClass == "Martial Artist" then
                local Floppa1 = true
                local Floppa2 = "FistQTE"
                game:GetService("ReplicatedStorage").Remotes.Information.RemoteFunction:FireServer(Floppa1, Floppa2)
                localPlayer.PlayerGui.Combat.FistQTE.Visible = false
                -- Sword
            elseif BaseClass == "Warrior" then
                local Floppa1 = true
                local Floppa2 = "SwordQTE"
                game:GetService("ReplicatedStorage").Remotes.Information.RemoteFunction:FireServer(Floppa1, Floppa2)
                localPlayer.PlayerGui.Combat.SwordQTE.Visible = false
                task.wait()
            end
        end
    end
})

Combat:AddToggle({
    Name = "Legit AutoQTE",
    Default = false,
    Save = true,
    Flag = "Value",
    Callback = function(Value)
        if not Value then return end

        _G.Settings = _G.Settings or {}
        local settings = _G.Settings
        settings["QTE Timer"] = 3
        local _timer = settings["QTE Timer"]
        local legitTimer = math.clamp(_timer, 0.2, 3)
        local baseToString = {
            ["Wizard"] = "MagicQTE",
            ["Thief"] = "DaggerQTE",
            ["Slayer"] = "SpearQTE",
            ["Material Artist"] = "FistQTE",
            ["Warrior"] = "SwordQTE"
        }
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local players = game:GetService("Players")
        local player = players.LocalPlayer

        local remotes = replicatedStorage:WaitForChild("Remotes")
        local actionRemote = remotes:WaitForChild("Information"):WaitForChild("RemoteEvent")

        local playerClass, breakTimer = nil, tick()

        local function getClass()
            while task.wait() do
                local result, class = pcall(function()
                    return player.PlayerGui.StatMenu.Holder.ContentFrame.Stats.Body.RightColumn.Content.BaseClass.Type.Text
                end)
                if result then
                    return class
                end
            end
        end
        local playerClass = getClass()

        if not playerClass or playerClass == "None" then
            warn("Player has no class!")

            while task.wait(2) do
                local class = getClass()

                if class ~= "None" then
                    print("Auto dodge setup")
                    playerClass = class
                    break
                end
            end
        end

        local classTranslation = baseToString[playerClass]
        local classUi = player.PlayerGui.Combat[classTranslation]

        classUi:GetPropertyChangedSignal("Visible"):Connect(function()
            local newValue = classUi.Visible
            if newValue then
                classUi.Visible = false
                task.wait(legitTimer)
                actionRemote:Fire(true, classTranslation)
            end
        end)
        player.CharacterAdded:Connect(function()
            local newClassUi = player.PlayerGui:WaitForChild("Combat"):WaitForChild(classTranslation)
            newClassUi:GetPropertyChangedSignal("Visible"):Connect(function()
                local newValue = newClassUi.Visible
                if newValue then
                    newClassUi.Visible = false
                    task.wait(legitTimer)
                    actionRemote:Fire(true, classTranslation) 
                end
            end)
        end)
       local oldFire = actionRemote.Fire
        actionRemote.Fire = function(self,...)
            oldFire(self,true)
        end
    end
}) 
-- Teleports
local Telepor = Window:MakeTab({
    Name = "Teleports",
    Icon = "rbxassetid://7733765398",
    PremiumOnly = false
})
Telepor:AddToggle({
    Name = "No Fall-DMG (This will Make you safe for Tp)",
    Default = true,
    Save = true,
    Flag = "NoFall",
    Callback = function(Value)
        getgenv().NoFall = (Value)

        local OldNameCall = nil
        OldNameCall = hookmetamethod(game, "__namecall", function(self,...)
            local Arg = {... }
            if self.Name == "EnviroEffects" and getgenv().NoFall then
                return
            end
            return OldNameCall(self,...)
        end)
    end
})
Telepor:AddDropdown({
    Name = "Spawns/Zones",
    Default = "",
    Options = { "Caldera", "Ruins/Sand Town","Volcano (Dragon Door)","Way of Life (Covenant)","Blades Of World (Covenant)","Fractured Realm","Tundra Door",},
    Callback = function(Value)
        if Value == "Caldera" then
            local Vector3End = Vector3.new(-221.396332, 46.5463257, -3328.51367)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
            tween:Play()
        elseif Value == "Ruins/Sand Town" then
            local Vector3End = Vector3.new(-2405.2, 42.8, -2977.7)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
            tween:Play()
        elseif Value == "Way of Life (Covenant)" then
            local Vector3End = Vector3.new(2612.2, 354.0, -3293.0)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
            tween:Play()
           elseif Value == "Blades Of World (Covenant)" then
            local Vector3End = Vector3.new(-2830.5, -35.4, -2118.4)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
            tween:Play()
        elseif Value == "Fractured Realm" then
            local Vector3End = Vector3.new(160.5, 232.1, 1192.0)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
            tween:Play()
        elseif Value == "Volcano (Dragon Door)" then
            local Vector3End = Vector3.new(-4768, 51, -3424)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
            tween:Play()
        elseif Value == "Tundra Door" then
            local Vector3End = Vector3.new(-17, 293, -5999)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
            tween:Play()
        end
    end
})


Telepor:AddDropdown({
    Name = "Misc",
    Default = "",
    Options = {"Floppa (Thanasius)", "BlackSmith", "Mark Npc","Sería(alchemist)","Merchant(Item Seller)","Atalar(Shard Fusioner)","Doctor(westwood)","The SoulMaster","Floppa Doctor"},
    Callback = function(Value)
    if Value == "BlackSmith" then
        local Vector3End = Vector3.new(2633.7, 386.4, -3687.0)
        local Time = 0
        local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
            TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
        tween:Play()
    elseif Value == "Mark Npc" then
        local Vector3End = Vector3.new(-67.9, 42.9, -3280.7)
        local Time = 0
        local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
            TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
        tween:Play()
    elseif Value == "Sería(alchemist)" then
        local Vector3End = Vector3.new(2585.1, 386.3, -4027.0)
        local Time = 0
        local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
            TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
        tween:Play()
    elseif Value == "Merchant(Item Seller)" then
        local Vector3End = Vector3.new(-147.9, 43.5, -3449.0)
        local Time = 0
        local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
            TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
        tween:Play()
    elseif Value == "Atalar(Shard Fusioner) " then
        local Vector3End = Vector3.new(-366.4, 43.8, -3390.5)
        local Time = 0
        local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
            TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
        tween:Play()

    elseif Value == "Doctor(westwood)" then
        local Vector3End = Vector3.new(2518.4, 386.3, -3625.0)
        local Time = 0
        local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
            TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
        tween:Play()
    elseif Value == "Floppa Doctor" then
        local Vector3End = Vector3.new(-1838.1, 47.5, -3187.6)
        local Time = 0
        local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
            TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
        tween:Play()
    elseif Value == "Floppa (Thanasius)" then
        local Vector3End = Vector3.new(1695, 12, -1654)
        local Time = 0
        local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
            TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
        tween:Play()
    end
end  
})


Telepor:AddDropdown({
    Name = "Enchants",
    Default = "",
    Options = { "Inferno Enchant Trigger", "Inferno Enchant End","Reaper Enchant","Midas Enchant","Lifesong Enchant","Cursed Enchant",},
    Callback = function(Value)
        if Value == "Inferno Enchant Trigger" then
            local Vector3End = Vector3.new(-4344, 74, -2090)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
            tween:Play()
        elseif Value == "Inferno Enchant End" then
            local Vector3End = Vector3.new(-4340, 67, -1587)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
            tween:Play()
        elseif Value == "Reaper Enchant" then
            local Vector3End = Vector3.new(-2402, 47,-3718)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
            tween:Play()
        elseif Value == "Midas Enchant" then
            local Vector3End = Vector3.new(-293, 44, -3176)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
            tween:Play()
        elseif Value == "Cursed Enchant" then
            local Vector3End = Vector3.new(1651, 54, -3480)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
            tween:Play()
        elseif Value == "Lifesong Enchant" then
            local Vector3End = Vector3.new(  5988, 53, -3467)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
            tween:Play()

        end
    end
    })
    -- Base Class Trainer
    Telepor:AddDropdown({
        Name = "Base Class Trainer",
        Default = "",
        Options = { "Ysa(Warrior)", "Tivek (Spear)","Boots(Thief)","Arandor(Wizzard)","Doran(Martial Artist)"},
        Callback = function(Value)  
        if Value == "Doran(Martial Artist)" then
            local Vector3End = Vector3.new(486.7, 116.9, -2654.2)
            local Time = 0
            elseif Value == "Arandor(Wizzard)" then
                local Vector3End = Vector3.new(593.8, 124.1, -3608.0)
                local Time = 0
                local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                    TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
                tween:Play()
            elseif Value == "Tivek (Spear)" then
                local Vector3End = Vector3.new(657.7, 97.2, -3984.5)
                local Time = 0
                local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                    TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
                tween:Play()
            elseif Value == "Ysa(Warrior)" then
                local Vector3End = Vector3.new(-472.4, 42.9, -3283.1)
                local Time = 0
                local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                    TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
                tween:Play()
          
            elseif Value == "Boots(Thief)" then
                local Vector3End = Vector3.new(-423.1, 42.9, -3529.1)
                local Time = 0
                local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                    TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
                tween:Play()
            end
        end
    })
-- Super class chaotic
Telepor:AddDropdown({
    Name = "Super Class Trainer (Chaotic)",
    Default = "",
    Options = { "DarkFist Trainer","Berserker Trainer","Ulys(Necromancer)","Orín(Impaler)","Inette(Assasin)"},
    Callback = function(Value)  
    if Value == "DarkFist Trainer" then
        local Vector3End = Vector3.new(1955.6, 32.3, -1420.0)
        local Time = 0
        local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
            TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
        tween:Play()
    elseif Value == "Berserker Trainer" then
            local Vector3End = Vector3.new(5349.8, -91.3, -3255.6)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
                tween:Play()    
        elseif Value == "Ulys(Necromancer)" then
            local Vector3End = Vector3.new(5950.9, 53.8, -2858.0)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
            tween:Play()
        elseif Value == "Orín(Impaler)" then
            local Vector3End = Vector3.new(2319.5, 385.7, -3622.0)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
            tween:Play()
        elseif Value == "Inette(Assasin)" then
            local Vector3End = Vector3.new(1181.3, -7.5, -2311.1)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
                tween:Play()
        end
    end
    })
-- Super Class Trainer (Oderly)
    Telepor:AddDropdown({
    Name = "Super Class Trainer (Oderly)",
    Default = "",
    Options = {"Paladin Trainer","Luther(Monk)",
    "Fernain(Saint)","Landrum(Elementalist)","Orkin(Ranger)"},
    Callback = function(Value)
    if Value == "Paladin Trainer" then
        local Vector3End = Vector3.new(-2515.8, 43.1, -2958.2)
        local Time = 0
        local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
            TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
        tween:Play()


    elseif Value == "Luther(Monk)" then
        local Vector3End = Vector3.new( -1693.2, 114.9, -2942.3)
        local Time = 0
        local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
            TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
        tween:Play()


    elseif Value == "Fernain(Saint)" then
        local Vector3End = Vector3.new(-2663.9, 121.9, -3432.0)
        local Time = 0
        local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
            TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
        tween:Play()

    elseif Value == "Landrum(Elementalist)" then
        local Vector3End = Vector3.new(-2572.7, 42.7, -2485.6)
        local Time = 0
        local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
            TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
        tween:Play()
    elseif Value == "Orkin(Ranger)" then
        local Vector3End = Vector3.new(2588.2, 386.3, -3175.8)
        local Time = 0
        local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
            TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
        tween:Play()
    elseif Value == "Thorin(Beastmaster)" then
        local Vector3End = Vector3.new(-814.2, 61.9, -2473.2)
        local Time = 0
        local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
            TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
        tween:Play()
    end
end

})
-- Super Class Trainer (Neutral)
Telepor:AddDropdown({
    Name = "Super Class Trainer (Neutral)",
    Default = "",
    Options = {"Gren(Brawler)","Aberon(Rogue)","Relan(Lancer)","Leoran(Blade dancer)","Ophelia(Hexer)"},
    Callback = function(Value)
        if Value == "Gren(Brawler)" then
             local Vector3End = Vector3.new(235.3, 98.6, -4652.1)
             local Time = 0
             local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                 TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
             tween:Play()
            elseif Value == "Relan(Lancer)" then
                local Vector3End = Vector3.new(-58.9, 159.1, -5605.8)
                local Time = 0
                local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                    TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
                tween:Play()
            elseif Value == "Aberon(Rogue)" then
                local Vector3End = Vector3.new(-2505.9, 43.6, -2862.3)
                local Time = 0
                local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                    TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
                tween:Play()
            elseif Value == "Leoran(Blade dancer)" then
                local Vector3End = Vector3.new(61.6, 113.5, -5364.3)
                local Time = 0
                local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                    TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
                tween:Play()
            elseif Value == "Ophelia(Hexer)" then
                local Vector3End = Vector3.new(-658.9, 42.7, -4196.1)
                local Time = 0
                local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                    TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
                tween:Play()
        end
    end

})
Telepor:AddDropdown({
    Name = "Mark Portals",
    Default = "",
    Options = { "Venia Orb 1", "Venia Orb 2","Venia Orb 3","Venia Orb 4"},
    Callback = function(Value)
        if Value == "Venia Orb 1" then
            local Vector3End = Vector3.new(-3174, -45, -2428)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
            tween:Play()
        elseif Value == "Venia Orb 2" then
            local Vector3End = Vector3.new(1709, 35, -2825)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
            tween:Play()
        elseif Value == "Venia Orb 3" then
            local Vector3End = Vector3.new(463, 138, -2683)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
            tween:Play()
        elseif Value == "Venia Orb 4" then
            local Vector3End = Vector3.new(-46, 293, -5944)
            local Time = 0
            local tween = game:GetService("TweenService"):Create(lp.Character.HumanoidRootPart,
                TweenInfo.new(Time), { CFrame = CFrame.new(Vector3End) })
            tween:Play()
        end
    end
 })
--Gui
local Dupe = Window:MakeTab({
    Name = "Dupe",
    Icon = "rbxassetid://7733765398",
    PremiumOnly = false
})
--Dupe 
local enabled = false
local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Data"):WaitForChild("UpdateHotbar")

Dupe:AddToggle({
    Name = "Enable Rollback",
    Default = false,
    Callback = function(state)
        enabled = state
        if enabled then
            coroutine.wrap(function()
                while enabled do
                    task.wait()
                    FireServer(remote, {[255] = "\255"})
                    FireServer(remote, {[2] = "\255"})
                    print("Rollback Setup")
                end
            end)()
        end
    end
})

-- Item Dropdown
local itemListDropdown = Dupe:AddDropdown({
    Name = "Items To Drop",
    Default = "",
    Options = GetUniqueToolNames(),
    Callback = function(Value)
        if variables.ToDrop[Value] then
            variables.ToDrop[Value] = nil
        else
            variables.ToDrop[Value] = Value
        end
    end
})

-- Refresh Button
local refreshButton = Dupe:AddButton({
    Name = "Refresh",
    Callback = function()
        itemListDropdown:Refresh(GetUniqueToolNames(), itemListDropdown.Value)
    end
})

-- Drop item
local currentItem = ""
Dupe:AddToggle({
    Name = "Drop Item",
    Default = false,
    Callback = function(Value)
        variables["DropToggle"] = Value
        if variables["DropToggle"] then
            currentItem = itemListDropdown.Value
            coroutine.wrap(function()
                while variables["DropToggle"] do
                    task.wait()
                    if currentItem ~= itemListDropdown.Value then
                        currentItem = itemListDropdown.Value
                    end
                    if currentItem ~= "" then
                        inventoryRemote:FireServer("Drop", currentItem)
                    end
                end
            end)()
        end
    end
})
--Rejoin 
Dupe:AddButton({
    Name = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId,game:GetService("Players").LocalPlayer)
    end
})
--Gui

local Credits = Window:MakeTab({
    Name = "Credits",
    Icon = "rbxassetid://7733765398",
    PremiumOnly = false
})
Credits:AddParagraph("Floppa | xalix2267","Owner of The Script and Developer")
Credits:AddParagraph("Mz | Mz#4822","Contributor and Developer of The Script")
Credits:AddParagraph("Unknow | IamNotUnknow#1003","Developer of The Script")
Credits:AddParagraph("Geo | Elgeo#2223","Tester of The Script")
Credits:AddParagraph("OneFool","Amazing Ui Modified")
Credits:AddParagraph("You","For Using my Script ❤")

OrionLib:Init()
