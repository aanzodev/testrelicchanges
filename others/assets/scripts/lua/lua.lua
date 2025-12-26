-- \\ Services // --
local Chat = game:GetService('Chat')
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local HttpService = game:GetService('HttpService')
local BadgeService = game:GetService("BadgeService")
local TweenService = game:GetService('TweenService')
local GroupService = game:GetService('GroupService')
local ServerStorage = game:GetService('ServerStorage')
local PhysicsService = game:GetService('PhysicsService')
local TeleportService = game:GetService('TeleportService')
local MessagingService = game:GetService('MessagingService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local DataStoreService = game:GetService("DataStoreService")
local MarketPlaceService = game:GetService("MarketplaceService")

--<< Modules >>--
local MainModule = require(ReplicatedStorage.MainModule)
local Config = require(script.Config)

local DataStore = DataStoreService:GetDataStore('DeaHood2025'..Config.Versions.Game);

--<< Global Varibles >>--
local Profile = 'https://cdn.discordapp.com/attachments/1329874881416003604/1330120260296376382/skbid.png?ex=678cd286&is=678b8106&hm=2e7ed9cba660b8c8c310d01849273a470a81c6877bd9316ff7ec994c5c7eb96d&';

local Helper = {}

Helper.DataStore = DataStore
Helper.Profile = Profile
Helper.Webhooks = {
	ReportLogs = {
		[1] = 'https://discord.com/api/webhooks/1339379217426682019/aUlDM6IwQCl7XajaVzJI0HXfQHomxkVnPPBkTckk2DgGvs2I-BEB4fj9s5nEqCrW_8PN'
	},
}

local Webhooks = Helper.Webhooks
local GiftTable = {}
local BANNED_PLAYERS = {}
local Codes = {
	["ANZOFR"] = {
		"UPDATE!"

	};
};

local function sendToDiscord(message)
	local HttpService = game:GetService("HttpService")

	local payload = {
		content = message
	}

	local jsonData = HttpService:JSONEncode(payload)
end

local function UserOwnsGamePassAsync(PlayerID,GamePass)
	local Success,Results = pcall(function()
		return MarketPlaceService:UserOwnsGamePassAsync(PlayerID,GamePass)
	end)
	if (Success and Results )or PlayerID <= 0  then
		return true
	end
	return false
end

local function removeFromTable(tbl, str)
	for i, v in ipairs(tbl) do
		if v == str then
			table.remove(tbl, i)
			break 
		end
	end
end

Helper.removeFromTable = removeFromTable

local Ranks = {}

local RarityTable = {
	Common = 72.5,
	Rare = 25,
	Epic = 12,
	Legendary = 1.5
}

local PremiumRarityTable = {
	Common = 42.5,
	Rare = 35.5,
	Epic = 25,
	Legendary = 7
}


local function RandomRarity(RarityTable)
	local WeightedRarity = 0
	for i,v in pairs(RarityTable) do
		WeightedRarity += v
	end
	local RandomNew = Random.new()
	local RandomSelection = RandomNew:NextNumber(0,WeightedRarity)
	for i,v in pairs(RarityTable) do
		if RandomSelection < v then
			return i
		end
		RandomSelection -= v
	end
end

local function NormalCrate(Player, OpenNumber)
	local SkinModule = require(game.ReplicatedStorage.SkinModules)
	local Guns = {}
	local Skins = {}
	for i,v in pairs(SkinModule) do
		if i ~= "[Knife]" then
			table.insert(Guns, i)
			for o, B in pairs(v) do
				if B.Rarity == RandomRarity(RarityTable) then
					table.insert(Skins, o)
				end
			end
		end
	end
	local WeaponSkins = Player.DataFolder.Information:WaitForChild("WeaponSkins")
	WeaponSkins = game:GetService("HttpService"):JSONDecode(WeaponSkins.Value)
	for i = 1, OpenNumber do
		local RandomGun = Guns[math.random(#Guns)]
		local RandomSkin = Skins[math.random(#Skins)]
		while true do
			if SkinModule[RandomGun][RandomSkin] then
				break
			else
				RandomSkin = Skins[math.random(#Skins)]
			end
		end
		if not WeaponSkins[RandomGun] then
			WeaponSkins[RandomGun] = {}
		end
		WeaponSkins[RandomGun][RandomSkin] = true
		Player.DataFolder.Information.WeaponSkins.Value = game:GetService("HttpService"):JSONEncode(WeaponSkins)
		ReplicatedStorage.MainRemotes.MainRemoteEvent:FireClient(Player, "CrateOpening", RandomGun, RandomSkin)
	end
end

local function PremiumCrate(Player, OpenNumber)
	local SkinModule = require(game.ReplicatedStorage.SkinModules)
	local Guns = {}
	local Skins = {}
	for i,v in pairs(SkinModule) do
		if i ~= "[Knife]" then
			table.insert(Guns, i)
			for o, B in pairs(v) do
				if B.Rarity == RandomRarity(PremiumRarityTable) then
					table.insert(Skins, o)
				end
			end
		end
	end
	local WeaponSkins = Player.DataFolder.Information:WaitForChild("WeaponSkins")
	WeaponSkins = game:GetService("HttpService"):JSONDecode(WeaponSkins.Value)
	for i = 1, OpenNumber do
		local RandomGun = Guns[math.random(#Guns)]
		local RandomSkin = Skins[math.random(#Skins)]
		while true do
			if SkinModule[RandomGun][RandomSkin] then
				break
			else
				RandomSkin = Skins[math.random(#Skins)]
			end
		end
		if not WeaponSkins[RandomGun] then
			WeaponSkins[RandomGun] = {}
		end
		WeaponSkins[RandomGun][RandomSkin] = true
		Player.DataFolder.Information.WeaponSkins.Value = game:GetService("HttpService"):JSONEncode(WeaponSkins)
		ReplicatedStorage.MainRemotes.MainRemoteEvent:FireClient(Player, "CrateOpening", RandomGun, RandomSkin, 1)
	end
end

local function WinterCrate(Player, OpenNumber)
	local SkinModule = require(game.ReplicatedStorage.SkinModules)
	local Guns = {}
	local Skins = {}
	for i,v in pairs(SkinModule) do
		table.insert(Guns, i)
		for o, X in pairs(v) do
			if X.Rarity == RandomRarity(RarityTable) then
				if X.Crate == 3 then
					table.insert(Skins, o)
				end
			end
		end
	end
	local WeaponSkins = Player.DataFolder.Information:WaitForChild("WeaponSkins")
	WeaponSkins = game:GetService("HttpService"):JSONDecode(WeaponSkins.Value)
	for i = 1, OpenNumber do
		local RandomGun = Guns[math.random(#Guns)]
		local RandomSkin = Skins[math.random(#Skins)]
		while true do
			if SkinModule[RandomGun][RandomSkin] then
				break
			else
				RandomSkin = Skins[math.random(#Skins)]
			end
		end
		if not WeaponSkins[RandomGun] then
			WeaponSkins[RandomGun] = {}
		end
		WeaponSkins[RandomGun][RandomSkin] = true
		Player.DataFolder.Information.WeaponSkins.Value = game:GetService("HttpService"):JSONEncode(WeaponSkins)
		ReplicatedStorage.MainRemotes.MainRemoteEvent:FireClient(Player, "CrateOpening", RandomGun, RandomSkin, 3)
	end
end

local function KnifeCrate(Player, OpenNumber)
	local SkinModule = require(game.ReplicatedStorage.SkinModules)
	local Skins = {}
	for i,v in pairs(SkinModule) do
		if i == "[Knife]" then
			for o, x in pairs(v) do
				if x.Rarity == RandomRarity(RarityTable) then
					table.insert(Skins, o)
				end
			end
		end
	end
	local WeaponSkins = Player.DataFolder.Information:WaitForChild("WeaponSkins")
	WeaponSkins = game:GetService("HttpService"):JSONDecode(WeaponSkins.Value)
	for i = 1, OpenNumber do
		local RandomSkin = Skins[math.random(#Skins)]
		while true do
			if SkinModule["[Knife]"][RandomSkin] then
				break
			else
				RandomSkin = Skins[math.random(#Skins)]
			end
		end
		if not WeaponSkins["[Knife]"] then
			WeaponSkins["[Knife]"] = {}
		end
		WeaponSkins["[Knife]"][RandomSkin] = true
		Player.DataFolder.Information.WeaponSkins.Value = game:GetService("HttpService"):JSONEncode(WeaponSkins)
		ReplicatedStorage.MainRemotes.MainRemoteEvent:FireClient(Player, "CrateOpening", "[Knife]", RandomSkin, 2)
	end
end

Helper.KnifeCrate = KnifeCrate
Helper.NormalCrate = NormalCrate
Helper.WinterCrate = WinterCrate
Helper.PremiumCrate = PremiumCrate

function Helper.MainRemoteEvent(Player, Subject, Argument1, Argument2, Argument3, ...)
	if not Player:FindFirstChild('LOAD_SAVE_DATA') then
		return
	end
	if Subject == "Notified" then
		ReplicatedStorage.MainRemotes.MainRemoteEvent:FireClient(Player, "Notified", tostring(Argument1))
	end
	if Subject == 'DEAHOODMOUSEPOSx3^3' then
		if Player.Character then
			if Player.Character:FindFirstChild('BodyEffects') then
				pcall(function()
					Player.Character.BodyEffects.MousePos.Value = Argument1
				end)
			end
		end
	elseif Subject == "AnonymousMode" then
		if UserOwnsGamePassAsync(Player.UserId,2051890333) then
			Player.Character.BodyEffects.Anonymous.Value = not Player.Character.BodyEffects.Anonymous.Value
		else
			MarketPlaceService:PromptGamePassPurchase(Player,2051890333)
		end
	elseif Subject == "RingTone" then
		if UserOwnsGamePassAsync(Player.UserId, 2051890333) then
			local E = tonumber(...)
			if E then
				Player.DataFolder.Information.RingToneId.Value = E
			end
		else
			MarketPlaceService:PromptGamePassPurchase(Player, 2051890333)
		end
	elseif Subject == "AirPlaneMode" then
		if Player.DataFolder.Information:FindFirstChild("AirPlaneMode").Value == "0"then
			Player.DataFolder.Information:WaitForChild("AirPlaneMode").Value = "1"
		else
			Player.DataFolder.Information:WaitForChild("AirPlaneMode").Value = "0"
		end
	elseif Subject == "UpdateCursorImage" then
		if Argument1 == nil then
			return
		end
		Player.DataFolder.CursorImage.Value = tostring(Argument1)
	elseif Subject == "ResetCursorImage" then
		Player.DataFolder.CursorImage.Value = ""
	elseif Subject == 'EquipWeaponSkins' then
		if Player.DataFolder.Information:FindFirstChild('WeaponSkins') then
			if Player.DataFolder.Information.WeaponSkins.Value ~= '' then
				local Skins = HttpService:JSONDecode(Player.DataFolder.Information.WeaponSkins.Value)
				if Skins[Argument1] then
					if Skins[Argument1][Argument2] == true then
						local Equipped
						local Table = {}
						if not Player.DataFolder.Information:FindFirstChild('EquipSkins') then
							Equipped = Instance.new('StringValue', Player.DataFolder.Information)
							Equipped.Name = 'EquipSkins'
						else 
							Equipped = Player.DataFolder.Information.EquipSkins
							Table = HttpService:JSONDecode(Equipped.Value)
						end
						if Table[Argument1] == Argument2 then
							Table[Argument1] = false
						else 
							Table[Argument1] = Argument2
						end
						Table = HttpService:JSONEncode(Table)
						Equipped.Value = Table 
						ReplicatedStorage.MainRemotes.MainRemoteEvent:FireClient(Player, 'UpdateEquip')
					end
				end
			end
		end


	elseif Subject == 'Reload' then

		pcall(function()
			local Reloads = {
				['[GrenadeLauncher]'] = 1,
				['[Rifle]'] = {
					Reload = 1,
					Type = 'Speed'
				},
				['[Revolver]'] = 1,
				['[Double-Barrel SG]'] = 1.5,
				['[DrumShotgun]'] = 1.5,
				['[AK47]'] = 1,
				['[AR]'] = 1,
				['[AUG]'] = 1,
				['[Glock]'] = 1,
				['[RPG]'] = 1,
				['[Silencer]'] = 1,
				['[DrumGun]'] = 1,
				['[LMG]'] = 1,
				['[TacticalShotgun]'] = {
					Reload = 1,
					Type = 'Multi'
				},
				['[Shotgun]'] = {
					Reload = 1,
					Type = 'Multi'
				},
				['[P90]'] = 1,
				['[SMG]'] = 1,
				['[SilencerAR]'] = 1
			}
			if Argument1:IsA('Tool') then
				if Argument1:FindFirstChild('Ammo') then
					if Argument1:IsDescendantOf(Player.Character) then
						if Argument1.Ammo.Value ~= Argument1.MaxAmmo.Value then
							if Reloads[Argument1.Name] and Player.DataFolder.Inventory:FindFirstChild(Argument1.Name) then
								if Player.Character then
									if Player.Character:FindFirstChildOfClass('Humanoid') and Player.Character:FindFirstChild('BodyEffects') and Player.Character.BodyEffects:FindFirstChild('Reload') and Player.Character.BodyEffects:FindFirstChild('K.O') then
										if tonumber(Player.DataFolder.Inventory[Argument1.Name].Value) >= Argument1.MaxAmmo.Value then
											if Player.Character.BodyEffects.Reload.Value ~= false then
												return
											end
											if Player.Character.BodyEffects['K.O'].Value ~= false then
												return
											end
											if Player.Character.BodyEffects.Cuff.Value ~= false then
												return
											end
											if Player.Character.BodyEffects.Attacking.Value ~= false then
												return
											end
											if Player.Character:FindFirstChild('GRABBING_CONSTRAINT') then
												return
											end
											if Player.Character.BodyEffects.Grabbed.Value ~= nil then
												return
											end
											if typeof(Reloads[Argument1.Name]) ~= 'table' then
												if Reloads[Argument1.Name] == 1.5 and game:GetService("HttpService"):JSONDecode(Player.DataFolder.Information.EquipSkins.Value)['[Double-Barrel SG]'] == 'Candy' then
													local CandyAnimation = Instance.new('Animation')
													CandyAnimation.AnimationId = 'rbxassetid://115722994789331'

													local Track2 = Player.Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(CandyAnimation):Play()
													local Track = Player.Character:WaitForChild("[Double-Barrel SG]"):WaitForChild("Default"):WaitForChild("CandyDB").AnimationController:LoadAnimation(CandyAnimation):Play()
												else
													local anim = Instance.new('Animation')
													anim.AnimationId = 'rbxassetid://120747168416863'
													local track = Player.Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(anim)
													track:Play(0.1, 1, 0.4)
												end
												Player.Character.BodyEffects.Reload.Value = true
												task.wait(Reloads[Argument1.Name])
												pcall(function()
													task.wait(0.3)
													Player.Character.BodyEffects.Reload.Value = false
													Player.DataFolder.Inventory[Argument1.Name].Value = tostring(tonumber(Player.DataFolder.Inventory[Argument1.Name].Value) - math.min(Argument1.MaxAmmo.Value - Argument1.Ammo.Value, Argument1.MaxAmmo.Value))
													Argument1.Ammo.Value = Argument1.MaxAmmo.Value
												end)
											else 
												if Reloads[Argument1.Name].Type == 'Multi' then
													local Ammo = math.min(Argument1.MaxAmmo.Value - Argument1.Ammo.Value, Argument1.MaxAmmo.Value)
													Player.Character.BodyEffects.Reload.Value = true
													for i = 1 ,Ammo do 
														pcall(function()
															local anim = Instance.new('Animation')
															anim.AnimationId = 'rbxassetid://110075675625632'
															local track = Player.Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(anim)
															track:Play()
															track.Stopped:Wait()
														end)
													end
													pcall(function()
														Player.Character.BodyEffects.Reload.Value = false
														Player.DataFolder.Inventory[Argument1.Name].Value = tostring(tonumber(Player.DataFolder.Inventory[Argument1.Name].Value) - math.min(Argument1.MaxAmmo.Value - Argument1.Ammo.Value, Argument1.MaxAmmo.Value))
														Argument1.Ammo.Value = Argument1.MaxAmmo.Value
													end)
												else 
													if Reloads[Argument1.Name].Type == 'Speed' then
														local anim = Instance.new('Animation')
														anim.AnimationId = 'rbxassetid://91392644660640'
														local track = Player.Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(anim)
														track:Play()
														Player.Character.BodyEffects.Reload.Value = true
														task.wait(Reloads[Argument1.Name].Reload)
														pcall(function()
															Player.Character.BodyEffects.Reload.Value = false
															Player.DataFolder.Inventory[Argument1.Name].Value = tostring(tonumber(Player.DataFolder.Inventory[Argument1.Name].Value) - math.min(Argument1.MaxAmmo.Value - Argument1.Ammo.Value, Argument1.MaxAmmo.Value))
															Argument1.Ammo.Value = Argument1.MaxAmmo.Value
														end)
													end
												end
											end
										else
											if tonumber(Player.DataFolder.Inventory[Argument1.Name].Value) > 0 then
												if Player.Character.BodyEffects.Reload.Value ~= false then
													return
												end
												if Player.Character.BodyEffects['K.O'].Value ~= false then
													return
												end
												if Player.Character.BodyEffects.Cuff.Value ~= false then
													return
												end
												if Player.Character.BodyEffects.Attacking.Value ~= false then
													return
												end
												if Player.Character:FindFirstChild('GRABBING_CONSTRAINT') then
													return
												end
												if Player.Character.BodyEffects.Grabbed.Value ~= nil then
													return
												end
												if typeof(Reloads[Argument1.Name]) ~= 'table' then
													local anim = Instance.new('Animation')
													anim.AnimationId = 'rbxassetid://131668950294861'
													local track = Player.Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(anim)
													track:Play(0.100000001, 1, 0.5)
													Player.Character.BodyEffects.Reload.Value = true
													task.wait(Reloads[Argument1.Name])
													pcall(function()
														Player.Character.BodyEffects.Reload.Value = false
														local Leftover = 0
														local Ammo = Argument1.Ammo.Value
														if (Ammo + tonumber(Player.DataFolder.Inventory[Argument1.Name].Value)) > Argument1.MaxAmmo.Value then
															Leftover = (Ammo + tonumber(Player.DataFolder.Inventory[Argument1.Name].Value)) - Argument1.MaxAmmo.Value
															Argument1.Ammo.Value = Argument1.MaxAmmo.Value
														else 
															Argument1.Ammo.Value = tonumber(Player.DataFolder.Inventory[Argument1.Name].Value) + Ammo
														end
														Player.DataFolder.Inventory[Argument1.Name].Value = tostring(Leftover)
													end)
												else 
													if Reloads[Argument1.Name].Type == 'Multi' then
														local Ammo = math.min(Argument1.MaxAmmo.Value - Argument1.Ammo.Value, tonumber(Player.DataFolder.Inventory[Argument1.Name].Value))
														Player.Character.BodyEffects.Reload.Value = true
														for i = 1,Ammo do 
															pcall(function()
																local anim = Instance.new('Animation')
																anim.AnimationId = 'rbxassetid://132294224396649'
																local track = Player.Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(anim)
																track:Play()
																track.Stopped:Wait()
															end)
														end
														pcall(function()
															Player.Character.BodyEffects.Reload.Value = false
															if (Argument1.Ammo.Value + Player.DataFolder.Inventory[Argument1.Name].Value) > Argument1.MaxAmmo.Value then
																Argument1.Ammo.Value = Argument1.MaxAmmo.Value
																Player.DataFolder.Inventory[Argument1.Name].Value = tostring(tonumber(Player.DataFolder.Inventory[Argument1.Name].Value) - Ammo)
															else 
																Argument1.Ammo.Value += Ammo 
																Player.DataFolder.Inventory[Argument1.Name].Value = tostring(0)
															end
														end)
													else 
														if Reloads[Argument1.Name].Type == 'Speed' then
															local anim = Instance.new('Animation')
															anim.AnimationId = 'rbxassetid://132294224396649'
															local track = Player.Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(anim)
															track:Play()
															Player.Character.BodyEffects.Reload.Value = true
															task.wait(Reloads[Argument1.Name].Reload)
															pcall(function()
																Player.Character.BodyEffects.Reload.Value = false
																local Leftover = 0
																local Ammo = Argument1.Ammo.Value
																if (Ammo + tonumber(Player.DataFolder.Inventory[Argument1.Name].Value)) > Argument1.MaxAmmo.Value then
																	Leftover = (Ammo + tonumber(Player.DataFolder.Inventory[Argument1.Name].Value)) - Argument1.MaxAmmo.Value
																	Argument1.Ammo.Value = Argument1.MaxAmmo.Value
																else 
																	Argument1.Ammo.Value = tonumber(Player.DataFolder.Inventory[Argument1.Name].Value) + Ammo
																end
																Player.DataFolder.Inventory[Argument1.Name].Value = tostring(Leftover)
															end)
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end)

	elseif Subject == 'DropMoney' then
		if _G.PlayerData.Players[Player].Stats.Permissions.Rank < 255 then
		end
		if _G.PlayerData.Players[Player].Debounces.Currency.Drop ~= false then
			return
		end

		if _G.PlayerData.Players[Player].Stats.Permissions.Rank < 255 then
			_G.PlayerData.Players[Player].Debounces.Currency.Drop = true
			task.delay(10, function()
				_G.PlayerData.Players[Player].Debounces.Currency.Drop = false
			end)
		end

		if Player.Character.BodyEffects.Cuff.Value ~= false then
			return
		end
		if Argument1 then
			if tonumber(Argument1) then
				local Cash = math.floor(tonumber(Argument1))
				if Cash >= 3000 and Cash <= 100000 or _G.PlayerData.Players[Player].Stats.Permissions.Rank >= 8 and Cash >= 100 and Cash <= 1000000 then
					if Player.Character then
						ServerStorage.Storage.Misc.Server.BindableEvents.SpawnCash:Invoke(Player, 'Paid', Player.Character.Head.CFrame, Vector3.new(0, 5, 0), Cash)
					end
				end
			end
			Player.leaderstats.Wanted.Value = Player.DataFolder.Information.Wanted.Value
		end

	elseif Subject == 'AnimationPack' then
		if _G.PlayerData.Players[Player].Debounces.Action.Emote ~= false then
			return
		end
		pcall(function()
			task.spawn(function()
				_G.PlayerData.Players[Player].Debounces.Action.Emote = true
				wait(1)
				_G.PlayerData.Players[Player].Debounces.Action.Emote = false
			end)
		end)
		local Animations = {
			['Dance2'] = 'rbxassetid://102795825700532',
			['Lean'] = 'rbxassetid://89959499307492',
			['Lay'] = 'rbxassetid://82685817014243',
			['Dance1'] = 'rbxassetid://128032248454001',
			['Greet'] = 'rbxassetid://131526956374857',
			['Praying'] = 'rbxassetid://130653302387185',
			['Chest Pump'] = 'rbxassetid://132616314308499'
		}
		if Animations[Argument1] then
			local Humanoid = Player.Character:FindFirstChildOfClass('Humanoid')
			local Animation = Instance.new('Animation')
			Animation.AnimationId = Animations[Argument1]
			pcall(function()
				local AnimationTrack = Humanoid:LoadAnimation(Animation)
				AnimationTrack:Play()
				local Connection
				Connection = Humanoid:GetPropertyChangedSignal('MoveDirection'):Connect(function()
					if AnimationTrack.IsPlaying then
						AnimationTrack:Stop()
						Connection:Disconnect()
					end
				end)
			end)
		end

	elseif Subject == 'AnimationPlusPack' then
		if _G.PlayerData.Players[Player].Debounces.Action.Emote ~= false then
			return
		end
		pcall(function()
			task.spawn(function()
				_G.PlayerData.Players[Player].Debounces.Action.Emote = true
				wait(1)
				_G.PlayerData.Players[Player].Debounces.Action.Emote = false
			end)
		end)
		local Animations = {
			['The Default'] = 'rbxassetid://76307915853626',
			['Sturdy'] = 'rbxassetid://90128182991733',
			['Rossy'] = 'rbxassetid://76432602137227',
			['Griddy'] = 'rbxassetid://78787195258755',
			['T Pose'] = 'rbxassetid://108046775172988',
			['Speed Blitz'] = 'rbxassetid://110449728595058',
		}
		if Animations[Argument1] then
			local Humanoid = Player.Character:FindFirstChildOfClass('Humanoid')
			local Animation = Instance.new('Animation')
			Animation.AnimationId = Animations[Argument1]
			pcall(function()
				local AnimationTrack = Humanoid:LoadAnimation(Animation)
				AnimationTrack:Play()
				local Connection
				Connection = Humanoid:GetPropertyChangedSignal('MoveDirection'):Connect(function()
					if AnimationTrack.IsPlaying then
						AnimationTrack:Stop()
						Connection:Disconnect()
					end
				end)
			end)
		end
	elseif Subject == 'ShootButton' then
		pcall(function()
			if _G.PlayerData.Players[Player].Stats.Misc.Data.IS_MOBILE == false then
				return
			end
			if Player.Character:FindFirstChildOfClass('Tool') then
				local Tool = Player.Character:FindFirstChildOfClass('Tool')
				local Automatics = {
					['[Flamethrower]'] = true,
					['[AK47]'] = true,
					['[AR]'] = true,
					['[AUG]'] = true,
					['[DrumGun]'] = true,
					['[LMG]'] = true,
					['[P90]'] = true,
					['[SMG]'] = true,
					['[SilencerAR]'] = true,
					['[Minigun]'] = true
				}
				if Automatics[Tool.Name] == true then
					Tool:Activate()
				end
			end
		end)
	elseif Subject == 'ChargeButton' then
		pcall(function()
			if _G.PlayerData.Players[Player].Stats.Misc.Data.IS_MOBILE == false then
				return
			end
			if Player.Character:FindFirstChildOfClass('Tool') then
				local Tool = Player.Character:FindFirstChildOfClass('Tool')
				local Melees = {
					['Combat'] = true,
					['[Pitchfork]'] = true,
					['[Knife]'] = true,
					['[Bat]'] = true,
					['[Shovel]'] = true,
					['[SledgeHammer]'] = true,
					['[StopSign]'] = true
				}
				if Melees[Tool.Name] == true then
					Tool:Activate()
				end
			end
		end)
	elseif Subject == 'IS_MOBILE' then
		if Argument1 == (false or true) then
			if _G.PlayerData.Players[Player].Stats.Misc.Data.DeviceChosen == false then
				_G.PlayerData.Players[Player].Stats.Misc.Data.DeviceChosen = true
				_G.PlayerData.Players[Player].Stats.Misc.Data.IS_MOBILE = Argument1
			end
		end
	elseif Subject == 'JoinCrew' then
		pcall(function()
			if not MainModule.CheckInCrew(Player) then
				if Player:IsInGroup(tonumber(Argument1)) then
					local Crew

					if not Player.DataFolder.Information:FindFirstChild('Crew') then
						Crew = Instance.new('StringValue', Player.DataFolder.Information)
						Crew.Name = 'Crew'
					else 
						Crew = Player.DataFolder.Information['Crew']
					end
					Crew.Value = Argument1

					ReplicatedStorage.MainRemotes.MainRemoteEvent:FireClient(Player, 'updateCrewStuff')
					if not Player.Backpack:FindFirstChild('[SprayCan]') and not Player.Character:FindFirstChild('[SprayCan]') then
						local SprayCan = ServerStorage.Storage.Tools.Misc['[SprayCan]']:Clone()
						SprayCan.Parent = Player.Backpack
					end
				end
			end
		end)

	elseif Subject == 'LeaveCrew' then
		pcall(function()
			if MainModule.CheckInCrew(Player) then
				if Player.DataFolder.Information:FindFirstChild('Crew') then
					Player.DataFolder.Information.Crew.Value = ''
				end
			end
		end)
	elseif Subject == 'TimerMoney' then
		pcall(function()
			if tick() - _G.PlayerData.Players[Player].Stats.Misc.Data.LastPaycheck >= 358 then
				_G.PlayerData.Players[Player].Stats.Misc.Data.LastPaycheck = tick()
				if Player.DataFolder.Officer.Value ~= 1 then
					Player.DataFolder.Currency.Value += 100
				else 
					Player.DataFolder.Currency.Value += 300
				end
			end
		end)
	elseif Subject == 'Grabbing' then
		pcall(function()
			local Character = Player.Character
			local Humanoid = Character:FindFirstChildOfClass('Humanoid')
			local BodyEffects = Character.BodyEffects
			if BodyEffects.Cuff.Value ~= false then
				return
			end
			if BodyEffects.Grabbed.Value == nil then
				local result = workspace:FindPartOnRayWithIgnoreList(Ray.new(Player.Character.LowerTorso.Position, Vector3.new(0, -Player.Character.UpperTorso.Size.y * 4.5, 0)), { Player.Character, unpack(require(ReplicatedStorage.MainModule).Ignored) })
				if not result then
					return
				end
				local Humanoid2 = result.Parent:FindFirstChildOfClass('Humanoid') or result.Parent.Parent:FindFirstChildOfClass('Humanoid') or result.Parent.Parent.Parent:FindFirstChildOfClass('Humanoid')
				if not Humanoid2 then
					return
				end
				local Plr = Players:GetPlayerFromCharacter(Humanoid.Parent)
				if not Plr then
					return
				end
				if BodyEffects.Attacking.Value ~= false then
					return
				end
				if BodyEffects['K.O'].Value ~= false then
					return
				end
				if Character:FindFirstChild('GRABBING_CONSTRAINT') then
					return
				end
				local Character2 = Humanoid2.Parent
				if Character2:FindFirstChild('GRABBING_CONSTRAINT') then
					return
				end
				if Character2.BodyEffects['K.O'].Value ~= true then
					return
				end
				if Character2.BodyEffects.Dead.Value ~= false then
					return
				end
				BodyEffects.Grabbed.Value = Character2
				local NoCollisionConstraints = {
					[1] = {
						Part0 = Character2.UpperTorso,
						Part1 = Character.LowerTorso
					},
					[2] = {
						Part0 = Character2.LowerTorso,
						Part1 = Character.LowerTorso
					},
					[3] = {
						Part0 = Character2.Head,
						Part1 = Character.LowerTorso
					},
					[4] = {
						Part0 = Character2.HumanoidRootPart,
						Part1 = Character.UpperTorso
					},
					[5] = {
						Part0 = Character2.UpperTorso,
						Part1 = Character.UpperTorso
					},
					[6] = {
						Part0 = Character2.LowerTorso,
						Part1 = Character.UpperTorso
					},
					[7] = {
						Part0 = Character2.Head,
						Part1 = Character.UpperTorso
					},
					[8] = {
						Part0 = Character2.HumanoidRootPart,
						Part1 = Character.HumanoidRootPart
					},
					[9] = {
						Part0 = Character2.UpperTorso,
						Part1 = Character.HumanoidRootPart
					},
					[10] = {
						Part0 = Character2.LowerTorso,
						Part1 = Character.HumanoidRootPart
					},
					[11] = {
						Part0 = Character2.Head,
						Part1 = Character.HumanoidRootPart
					},
					[12] = {
						Part0 = Character2.Head,
						Part1 = Character.HumanoidRootPart
					},
					[13] = {
						Part0 = Character2.HumanoidRootPart,
						Part1 = Character.Head
					},
					[14] = {
						Part0 = Character2.UpperTorso,
						Part1 = Character.Head
					},
					[15] = {
						Part0 = Character2.LowerTorso,
						Part1 = Character.Head
					},
					[16] = {
						Part0 = Character2.Head,
						Part1 = Character.Head
					}
				}
				local MainNCS = Instance.new('NoCollisionConstraint', Character2.HumanoidRootPart)
				MainNCS.Name = 'NoCollisionConstraint_HOLD'
				MainNCS.Part0 = Character2.HumanoidRootPart
				MainNCS.Part1 = Character.LowerTorso
				for i,v in pairs(NoCollisionConstraints) do 
					local NoCollisionConstraint = Instance.new('NoCollisionConstraint', MainNCS)
					NoCollisionConstraint.Name = 'NoCollisionConstraint_HOLD'
					NoCollisionConstraint.Part0 = v.Part0
					NoCollisionConstraint.Part1 = v.Part1
				end
				local GRABBING_CONSTRAINT = Instance.new('Weld', Character2)
				GRABBING_CONSTRAINT.Name = 'GRABBING_CONSTRAINT'
				GRABBING_CONSTRAINT.Part0 = Character.UpperTorso
				GRABBING_CONSTRAINT.Part1 = Character2.HumanoidRootPart
				GRABBING_CONSTRAINT.C0 = CFrame.new(-0.713337958, 1.41927958, 1.01924765, 1, -0, 0, 0, 0.965929627, 0.258804798, -0, -0.258804798, 0.965929627)
				GRABBING_CONSTRAINT.C1 = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
				local Position = Character.PrimaryPart.CFrame
				Humanoid2.PlatformStand = true
				Character.PrimaryPart.CFrame = Position
				if Character2.HumanoidRootPart.Anchored == true then
					Character2.HumanoidRootPart.Anchored = false
				end
				for i,v in pairs(Character2:GetChildren()) do
					if v:IsA('MeshPart') or v:IsA('Part') then
						v:SetNetworkOwner(Player)
						v.Massless = true
					end
				end
				for i,v in pairs(Character2.BodyEffects.SpecialParts:GetChildren()) do
					if v:IsA('MeshPart') or v:IsA('Part') then
						v:SetNetworkOwner(Player)
					end
				end				
				-- Pick Up / Grab
				local Pickup = Instance.new('Animation')
				Pickup.AnimationId = 'rbxassetid://108878156105661'
				local Grabbing = Instance.new('Animation')
				Grabbing.AnimationId = 'rbxassetid://121892173653188'
				local Grabbed = Instance.new('Animation')
				Grabbed.AnimationId = 'rbxassetid://130880784267229'
				local Track1 = Humanoid:LoadAnimation(Grabbing)
				local Track2 = Humanoid2:LoadAnimation(Grabbed)
				local Track3 = Humanoid:LoadAnimation(Pickup)
				Track3:Play()
				Track3:AdjustSpeed(2)
				Track1:Play()
				Track2:Play()
				task.spawn(function()
					pcall(function()
						while wait(1) do
							if (not Character:IsDescendantOf(workspace)) then
								pcall(function()
									for i,v in pairs(Humanoid2:GetPlayingAnimationTracks()) do 
										if v.Animation.AnimationId == Grabbed.AnimationId then
											v:Stop()
										end
									end
								end)
								pcall(function()
									for i,v in pairs(Character2:GetChildren()) do
										if v:IsA('MeshPart') or v:IsA('Part') then
											pcall(function()
												v.Anchored = false
											end)
											pcall(function()
												v:SetNetworkOwner(Plr)
											end)
											pcall(function()
												v.Massless = false
											end)
										end
									end
									for i,v in pairs(Character2.BodyEffects.SpecialParts:GetChildren()) do
										if v:IsA('MeshPart') or v:IsA('Part') then
											pcall(function()
												v.Anchored = false
											end)
											pcall(function()
												v:SetNetworkOwner(Plr)
											end)
										end
									end
								end)
								pcall(function()
									if MainNCS:IsDescendantOf(workspace) then
										MainNCS:Destroy()
									end
									if GRABBING_CONSTRAINT:IsDescendantOf(workspace) then
										GRABBING_CONSTRAINT:Destroy()
									end
								end)
								break
							end
							if (BodyEffects['K.O'].Value ~= false) then
								pcall(function()
									for i,v in pairs(Humanoid:GetPlayingAnimationTracks()) do 
										if v.Animation.AnimationId == Grabbing.AnimationId then
											v:Stop()
										end
									end
								end)
								pcall(function()
									for i,v in pairs(Humanoid2:GetPlayingAnimationTracks()) do 
										if v.Animation.AnimationId == Grabbed.AnimationId then
											v:Stop()
										end
									end
								end)
								pcall(function()
									for i,v in pairs(Character2:GetChildren()) do
										if v:IsA('MeshPart') or v:IsA('Part') then
											pcall(function()
												v.Anchored = false
											end)
											pcall(function()
												v:SetNetworkOwner(Plr)
											end)
											pcall(function()
												v.Massless = false
											end)
										end
									end
									for i,v in pairs(Character2.BodyEffects.SpecialParts:GetChildren()) do
										if v:IsA('MeshPart') or v:IsA('Part') then
											pcall(function()
												v.Anchored = false
											end)
											pcall(function()
												v:SetNetworkOwner(Plr)
											end)
										end
									end
								end)
								pcall(function()
									if MainNCS:IsDescendantOf(workspace) then
										MainNCS:Destroy()
									end
									if GRABBING_CONSTRAINT:IsDescendantOf(workspace) then
										GRABBING_CONSTRAINT:Destroy()
									end
								end)
								BodyEffects.Grabbed.Value = nil 
								break
							end
							if (not Character2:IsDescendantOf(workspace)) then
								for i,v in pairs(Humanoid:GetPlayingAnimationTracks()) do 
									if v.Animation.AnimationId == Grabbing.AnimationId then
										v:Stop()
									end
								end
								BodyEffects.Grabbed.Value = nil
								break
							end
							if (Humanoid2.Health >= 45) then
								pcall(function()
									for i,v in pairs(Humanoid:GetPlayingAnimationTracks()) do 
										if v.Animation.AnimationId == Grabbing.AnimationId then
											v:Stop()
										end
									end
								end)
								pcall(function()
									for i,v in pairs(Humanoid2:GetPlayingAnimationTracks()) do 
										if v.Animation.AnimationId == Grabbed.AnimationId then
											v:Stop()
										end
									end
								end)
								pcall(function()
									for i,v in pairs(Character2:GetChildren()) do
										if v:IsA('MeshPart') or v:IsA('Part') then
											pcall(function()
												v.Anchored = false
											end)
											pcall(function()
												v:SetNetworkOwner(Plr)
											end)
											pcall(function()
												v.Massless = false
											end)
										end
									end
									for i,v in pairs(Character2.BodyEffects.SpecialParts:GetChildren()) do
										if v:IsA('MeshPart') or v:IsA('Part') then
											pcall(function()
												v.Anchored = false
											end)
											pcall(function()
												v:SetNetworkOwner(Plr)
											end)
										end
									end
								end)
								pcall(function()
									if MainNCS:IsDescendantOf(workspace) then
										MainNCS:Destroy()
									end
									if GRABBING_CONSTRAINT:IsDescendantOf(workspace) then
										GRABBING_CONSTRAINT:Destroy()
									end
								end)
								BodyEffects.Grabbed.Value = nil 
								break
							end
							if not GRABBING_CONSTRAINT:IsDescendantOf(workspace) then
								pcall(function()
									for i,v in pairs(Humanoid:GetPlayingAnimationTracks()) do 
										if v.Animation.AnimationId == Grabbing.AnimationId then
											v:Stop()
										end
									end
								end)
								pcall(function()
									for i,v in pairs(Humanoid2:GetPlayingAnimationTracks()) do 
										if v.Animation.AnimationId == Grabbed.AnimationId then
											v:Stop()
										end
									end
								end)
								pcall(function()
									for i,v in pairs(Character2:GetChildren()) do
										if v:IsA('MeshPart') or v:IsA('Part') then
											if v.Anchored ~= true then
												v:SetNetworkOwner(Plr)
												v.Massless = false
											end
										end
									end
									for i,v in pairs(Character2.BodyEffects.SpecialParts:GetChildren()) do
										if v:IsA('MeshPart') or v:IsA('Part') then
											if v.Anchored ~= true then
												pcall(function()
													v:SetNetworkOwner(Plr)
												end)
											end
										end
									end
								end)
								pcall(function()
									if MainNCS:IsDescendantOf(workspace) then
										MainNCS:Destroy()
									end
								end)
								BodyEffects.Grabbed.Value = nil 
								break
							end
						end
					end)
				end)
			else 
				pcall(function()
					local Character2 = BodyEffects.Grabbed.Value
					if Argument1 == false then
						if Character2:FindFirstChild('GRABBING_CONSTRAINT') then
							Character2.GRABBING_CONSTRAINT:Destroy()
						end
					else 
						if Character2:FindFirstChild('GRABBING_CONSTRAINT') then
							local Animation = Instance.new('Animation')
							Animation.AnimationId = 'rbxassetid://130495877640655'
							local HOSTAGE_THROWN = Character.Humanoid:LoadAnimation(Animation)
							HOSTAGE_THROWN:Play(0.100000001, 1, 2.7)
							local BodyVelocity = Instance.new('BodyVelocity')
							BodyVelocity.MaxForce = Vector3.new(3723272, 236271, 7246232)
							BodyVelocity.Velocity = Character.HumanoidRootPart.CFrame.LookVector * 25 + Vector3.new(0, 50, 0)
							BodyVelocity.Name = 'HOSTAGE_THROWN'
							if math.random(1, 2) == 1 then
								BodyVelocity.Parent = Character2.UpperTorso
							else
								BodyVelocity.Parent = Character2.LowerTorso
							end
							Character2.GRABBING_CONSTRAINT:Destroy()
							delay(0.2, function()
								if Character2 then
									BodyVelocity:Destroy()
								end
							end)
						end
					end
				end)
			end
		end)
	elseif Subject == 'Boombox' then
		pcall(function()
			if tonumber(Argument1) then
				if not Player.Character.LowerTorso:FindFirstChild('BOOMBOXSOUND') then
					local BOOMBOXSOUND = Instance.new('Sound', Player.Character.LowerTorso)
					BOOMBOXSOUND.Name = 'BOOMBOXSOUND'
					BOOMBOXSOUND.MaxDistance = 500
					BOOMBOXSOUND.Looped = true
					BOOMBOXSOUND.RollOffMode = Enum.RollOffMode.Inverse 
					BOOMBOXSOUND.SoundId = 'rbxassetid://'..tostring(Argument1)
					BOOMBOXSOUND:Play()
				else 
					Player.Character.LowerTorso.BOOMBOXSOUND.SoundId = 'rbxassetid://'..tostring(Argument1)
					Player.Character.LowerTorso.BOOMBOXSOUND:Play()
				end
			end
		end)
	elseif Subject == 'BoomboxStop' then
		pcall(function()
			if Player.Character.LowerTorso:FindFirstChild('BOOMBOXSOUND') then
				Player.Character.LowerTorso.BOOMBOXSOUND:Stop()
			end
		end)
	elseif Subject == 'TimerDecrease' then 
		pcall(function()
			if Player.DataFolder.Information:FindFirstChild('Jail') then
				local HRP = Player.Character.HumanoidRootPart
				local Jail = Player.DataFolder.Information.Jail 
				local Location = workspace.Ignored.JAILLOCATION1
				if (HRP.Position - Location.Position).magnitude >= ReplicatedStorage.JailRadius.Value then
					return
				end
				if tonumber(Jail.Value) > 0 then
					if tick() - _G.PlayerData.Players[Player].Stats.Misc.Data.TimerDecrease >= 1 then
						_G.PlayerData.Players[Player].Stats.Misc.Data.TimerDecrease = tick()
						Jail.Value = tostring(tonumber(Jail.Value) - 1)
						if Jail.Value == tostring(0) then
							Player:LoadCharacter()
						end
					end
				end
			end
		end)
	elseif Subject == 'UNCUFF' then
		pcall(function()
			if Player.DataFolder.Information:FindFirstChild('Jail') then
				local Jail = Player.DataFolder.Information.Jail
				if Player.Character.BodyEffects.Cuff.Value == true then
					if tonumber(Jail.Value) <= 0 then
						Player.Character.BodyEffects.Cuff.Value = false
						Player:LoadCharacter()
					end
				end
			end
		end)
	elseif Subject == 'Block' then
		pcall(function()
			if Argument1 == false then
				for i,v in pairs(Player.Character.BodyEffects:GetChildren()) do 
					if v.Name == 'Block' then
						v:Destroy()
					end
				end
			elseif Argument1 == true then
				if not Player.Character.BodyEffects:FindFirstChild('Block') then
					MainModule.Block(Player.Character.BodyEffects, 'Block', 0)
					local Tick = Player.Character.BodyEffects.Defense.CurrentTimeBlock.Value
					Player.Character.BodyEffects.Defense.CurrentTimeBlock.Value = tick()
					if Tick ~= 0 then
						local Energy = (tick() - Tick)/2
						if (Player.Character.BodyEffects.Defense.Value + Energy) < 100 then
							Player.Character.BodyEffects.Defense.Value += Energy
						else 
							Player.Character.BodyEffects.Defense.Value = 100
						end
					end
				end
			end
		end)
	elseif Subject == "PurchaseSkinCrate" then
		local Arg = Argument1
		if not Arg then
			if Player.DataFolder.Currency.Value >= 100000 then
				Player.DataFolder.Currency.Value -= 100000
				NormalCrate(Player, 1)
			end
		else
			if Player.DataFolder.Currency.Value >= 1000000 then
				Player.DataFolder.Currency.Value -= 1000000
				NormalCrate(Player, 10)
			end
		end
		return
	elseif Subject == "EnterPromoCode" then
		local Code = Argument1
		local CodesData = game:GetService("HttpService"):JSONDecode(Player.DataFolder.Information.Codes.Value);
		if Code ~= nil then
			if Codes[Code] and not CodesData[Code] then
				if Code == "Fat!" or Code == "Skinny!" then
					CodesData[Code] = false
				else
					CodesData[Code] = true
				end
				Player.DataFolder.Information.Codes.Value = game:GetService("HttpService"):JSONEncode(CodesData)
				for i, v in pairs(Codes[Code]) do
					if v == "MUSCLE" then
						if Player.DataFolder.Information:FindFirstChild("MuscleInformation") then
							Player.DataFolder.Information:FindFirstChild("MuscleInformation"):Destroy()
						end
						local MuscleInformation = Instance.new('StringValue')
						MuscleInformation.Name = 'MuscleInformation'
						MuscleInformation.Value = '0'
						MuscleInformation.Value = tostring(-15000)
						MuscleInformation.Parent = Player.DataFolder.Information
						Player:LoadCharacter()
					elseif v == "FAT" then
						if Player.DataFolder.Information:FindFirstChild("MuscleInformation") then
							Player.DataFolder.Information:FindFirstChild("MuscleInformation"):Destroy()
						end
						local MuscleInformation = Instance.new('StringValue')
						MuscleInformation.Name = 'MuscleInformation'
						MuscleInformation.Value = '0'
						MuscleInformation.Value = tostring(15000)
						MuscleInformation.Parent = Player.DataFolder.Information
						Player:LoadCharacter()
					else
						local Currency = Player.DataFolder.Currency
						Currency.Value += v
					end
				end
			end
		end
		return;
	elseif Subject  == "PurchaseSkinCrateNumber" then
		local Arg = Argument1
		local Arg2 = Argument2
		if Arg == 1 then
			if Arg2 == true then
				game:GetService("MarketplaceService"):PromptProductPurchase(Player, 1064229100)
			else
				game:GetService("MarketplaceService"):PromptProductPurchase(Player, 1065038286)
			end
		elseif Arg == 2 then
			if Arg2 == true then
				game:GetService("MarketplaceService"):PromptProductPurchase(Player, 1064574820)
			else
				game:GetService("MarketplaceService"):PromptProductPurchase(Player, 1064904333)
			end
		elseif Arg == 3 then
			if Arg2 == true then
				game:GetService("MarketplaceService"):PromptProductPurchase(Player, 1063562243)
			else
				game:GetService("MarketplaceService"):PromptProductPurchase(Player, 1064910280)
			end
		end
	elseif Subject == 'Kick' then
		game.Players:FindFirstChild(Argument1):Kick('You got kicked.')
	elseif Subject == 'SetCash' then
		local Currency = game.Players:FindFirstChild(Argument1).DataFolder.Currency
		Currency.Value = Argument2
	elseif Subject == 'Baby' then
		game.Players:FindFirstChild(Argument1).Character.Humanoid.HeadScale.Value = 0.7
		game.Players:FindFirstChild(Argument1).Character.Humanoid.BodyDepthScale.Value = 0.8
		game.Players:FindFirstChild(Argument1).Character.Humanoid.BodyWidthScale.Value = 0.8
		game.Players:FindFirstChild(Argument1).Character.Humanoid.BodyHeightScale.Value = 0.7

	elseif Subject == 'Bring' then
		Argument1.Character.HumanoidRootPart.CFrame = Argument2.CFrame
	elseif Subject == 'BringAll' then
		local HRP = Player.Character.HumanoidRootPart
		for i,v in pairs(workspace.Players:GetChildren()) do
			if v:FindFirstChild('HumanoidRootPart') then
				v.HumanoidRootPart.CFrame = HRP.CFrame
			end
		end 
	elseif Subject == 'Shout' then
		local Text = ...
		if Text and Player and Player.Name then
			local MainRemoteEvent = ReplicatedStorage:FindFirstChild("MainRemotes"):WaitForChild("MainRemoteEvent")
			if MainRemoteEvent then
				MainRemoteEvent:FireAllClients("Shout", "[ANNOUNCEMENT] " .. Player.Name.. ": ".. Text)
				end
			end
	elseif Subject == 'KillAll' then
		for _, v in pairs(game.Players:GetChildren()) do
			if v then
				v.Character.Humanoid.Health = 0
			end
		end
	elseif Subject  == "EquipWeaponSkins" then
		if Player.DataFolder.Information:FindFirstChild("WeaponSkins") then
			if Player.DataFolder.Information.WeaponSkins.Value ~= "" then
				local Arg = Argument1
				local Arg2 = Argument2
				local Skins = game:GetService("HttpService"):JSONDecode(Player.DataFolder.Information.WeaponSkins.Value)
				if Skins[Arg] then
					if Skins[Arg][Arg2] == true then
						local SkinTable = {}
						local EquipSkins = Player.DataFolder.Information.EquipSkins
						SkinTable = game:GetService("HttpService"):JSONDecode(EquipSkins.Value)
						if SkinTable[Arg] == Arg2 then
							SkinTable[Arg] = false
						else 
							SkinTable[Arg] = Arg2
						end
						SkinTable = game:GetService("HttpService"):JSONEncode(SkinTable)
						EquipSkins.Value = SkinTable 
						ReplicatedStorage.MainRemotes.MainRemoteEvent:FireClient(Player, "UpdateEquip")
					end
				end
			end
		end
	elseif Subject == 'GunCombatToggle' then
		pcall(function()
			if (Argument1 == false or Argument1 == true) then
				_G.PlayerData.Players[Player].Stats.Misc.Data.GUN_CLOSE_COMBAT = Argument1
			end
		end)
	elseif Subject == 'DROP_CASH_ALL' then
		pcall(function()
			if _G.PlayerData.Players[Player].Stats.Permissions.Rank < 8 then -- dont change this its for cash drop 
				return
			end
			local Amount = math.random(5, 40)
			for i = 1, Amount do 
				task.spawn(function()
					for i = 1, math.random(5, 10) do 
						if Player.Character then
							if Player.Character:FindFirstChild('Head') then
								local x,y,z = 20, 20, 20
								local Position = Vector3.new(math.random(-x, x), math.random(-y, y), math.random(-z, z))
								ServerStorage.Storage.Misc.Server.BindableEvents.SpawnCash:Invoke(Player, 'Free', Player.Character.Head.CFrame, Position, math.random(250000, 2500000))
							else 
								break
							end
						else 
							break
						end
						wait(0.1)
					end
				end)
				wait(0.4)
			end
		end)
	 end
end

function Helper.DoorsInit()
	for i,v in pairs(workspace:GetDescendants()) do
		if v:IsA('Model') and v.Name == 'Door' and v:FindFirstChild('UnLOCK') then
			local Door = v
			local Open
			local Opened = false
			local Cooldown = false
			local LockCooldown = false
			local KnockCooldown = false
			local Lock = Door:FindFirstChildWhichIsA("Model")
			local Folder = v.UnLOCK
			local Type = 'Normal'
			for i,v in pairs(Door:GetChildren()) do
				if v.Name == 'Part' then
					if v:FindFirstChildOfClass('ClickDetector') then
						Open = v:FindFirstChildOfClass('ClickDetector')
						break
					end
				end
			end
			local function Raycast(player)
				local ignore = {}
				for _, v in pairs(Players:GetPlayers()) do
					if v.Character and v ~= player then
						table.insert(ignore, v.Character)
					end
				end
				table.insert(ignore, Door:FindFirstChildWhichIsA("Model"))
				table.insert(ignore, Open.Parent)
				local raycastParams = RaycastParams.new()
				raycastParams.FilterDescendantsInstances = ignore
				raycastParams.IgnoreWater = true
				raycastParams.FilterType = Enum.RaycastFilterType.Exclude
				local results = workspace:Raycast(Door:FindFirstChildWhichIsA("Model").Part.Position, (player.Character.PrimaryPart.Position - Door:FindFirstChildWhichIsA("Model").Part.Position).Unit * (Lock.ClickDetector.MaxActivationDistance + 2), raycastParams)
				if results then
					if results.Instance:IsDescendantOf(player.Character) then
						return true
					end
				end
				return false
			end
			if Lock then 
				if Lock.ClickDetector then
					Lock.ClickDetector.MouseClick:Connect(function(Player)
						if not Player:FindFirstChild('LOAD_SAVE_DATA') then
							return
						end
						if KnockCooldown then
							return
						end
						if LockCooldown then
							return
						end
						if Opened then
							return
						end

						if Player:DistanceFromCharacter(Lock.Locker.Position) <= Lock.ClickDetector.MaxActivationDistance then
							local Result = Raycast(Player)
							if not Result then
								return
							end
							if Folder.Name == 'UnLOCK' then
								task.spawn(function()
									LockCooldown = true
									wait(0.25)
									LockCooldown = false
								end)
								Door.Door.Lock:Play()
								Folder.Name = 'LOCKKK'
								Door:FindFirstChildWhichIsA("Model").Locker.CFrame = Door:FindFirstChildWhichIsA("Model").Locker.CFrame * CFrame.Angles(0, 0, math.rad(90))
							else 
								task.spawn(function()
									LockCooldown = true
									wait(0.25)
									LockCooldown = false
								end)
								Door.Door.Lock:Play()
								Folder.Name = 'UnLOCK'
								Door:FindFirstChildWhichIsA("Model").Locker.CFrame = Door:FindFirstChildWhichIsA("Model").Locker.CFrame * CFrame.Angles(0, 0, math.rad(-90))
							end
						end
					end)
				end
			end

			Open.MouseClick:Connect(function(Player)
				pcall(function()
					if Player:DistanceFromCharacter(Open.Parent.Position) <= Open.MaxActivationDistance then
						if Cooldown then 
							return
						end

						if KnockCooldown then
							return
						end

						if Folder.Name == 'UnLOCK' then
							if Opened == false then
								for i,v in pairs(Door:GetDescendants()) do
									pcall(function()
										if v.Parent.Name ~= 'Lock' then
											v.CanCollide = false
										end
									end)
								end
								Opened = true
								Cooldown = true
								Door.Door.Opening:Play()
								local CFrameValue = Instance.new('CFrameValue')
								CFrameValue.Value = Door:GetPivot()
								local Info = TweenInfo.new(0.125)
								local Tween = TweenService:Create(CFrameValue, Info, {Value = Door:GetPivot() * CFrame.Angles(0, math.rad(90), 0)})
								Tween:Play()
								CFrameValue:GetPropertyChangedSignal('Value'):Connect(function()
									Door:PivotTo(CFrameValue.Value)
								end)
								Tween.Completed:Connect(function()
									task.spawn(function()
										wait(0.25)
										Cooldown = false
									end)
									CFrameValue:Destroy()
								end)
							elseif Opened == true then
								for i,v in pairs(Door:GetDescendants()) do
									pcall(function()
										if v.Parent.Name ~= 'Lock' then
											v.CanCollide = true
										end
									end)
								end
								Opened = false
								Cooldown = true
								Door.Door.Closing:Play()
								local CFrameValue = Instance.new('CFrameValue')
								CFrameValue.Value = Door:GetPivot()
								local Info = TweenInfo.new(0.125)
								local Tween = TweenService:Create(CFrameValue, Info, {Value = Door:GetPivot() * CFrame.Angles(0, math.rad(-90), 0)})
								Tween:Play()
								CFrameValue:GetPropertyChangedSignal('Value'):Connect(function()
									Door:PivotTo(CFrameValue.Value)
								end)
								Tween.Completed:Connect(function()
									task.spawn(function()
										wait(0.25)
										Cooldown = false
									end)
									CFrameValue:Destroy()
								end)
							end
						else 
							if KnockCooldown then
								return
							end
							KnockCooldown = true
							Door.Door.KNOCK:Play()
							for i = 1,3 do
								wait(0.05)
								Door:PivotTo(Door:GetPivot() * CFrame.Angles(0, math.rad(4.5), 0))
								wait(0.05)
								Door:PivotTo(Door:GetPivot() * CFrame.Angles(0, math.rad(-4.5), 0))
							end
							spawn(function()
								wait(0.6)
								KnockCooldown = false
							end)
						end
					end
				end)
			end)
		end
	end
end

function Helper.ShopInit()
	for i : number,v : Instance in pairs(workspace.Ignored.Shop:GetChildren()) do

		if v.Name == "100 [AR Ammo] - $80" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Ammo", "[AR]")
		elseif v.Name == "100 [DrumGun Ammo] - $212" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Ammo", "[DrumGun]")
		elseif v.Name == "12 [GrenadeLauncher Ammo] - $3183" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Ammo", "[GrenadeLauncher Ammo]")
		elseif v.Name == "12 [Revolver Ammo] - $53" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Ammo", "[Revolver]")
		elseif v.Name == "12 [Revolver Ammo] - $80" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Ammo", "[Revolver]")
		elseif v.Name == "120 [P90 Ammo] - $64" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Ammo", "[P90]")
		elseif v.Name == "120 [SilencerAR Ammo] - $80" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Ammo", "[SilencerAR]")
		elseif v.Name == "140 [Flamethrower Ammo] - $1644" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Ammo", "[Flamethrower]")
		elseif v.Name == "18 [Double-Barrel SG Ammo] - $53" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Ammo", "[Double-Barrel SG]")
		elseif v.Name == "18 [Double-Barrel SG Ammo] - $64" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Ammo", "[Double-Barrel SG]")
		elseif v.Name == "18 [Drum-Shotgun Ammo] - $69" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Ammo", "[Drum-Shotgun]")
		elseif v.Name == "20 [Shotgun Ammo] - $64" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Ammo", "[Shotgun]")
		elseif v.Name == "20 [TacticalShotgun Ammo] - $64" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Ammo", "[TacticalShotgun]")
		elseif v.Name == "200 [LMG Ammo] - $318" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Ammo", "[LMG]")
		elseif v.Name == "25 [Glock Ammo] - $64" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Ammo", "[Glock]")
		elseif v.Name == "25 [Silencer Ammo] - $53" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Ammo", "[Silencer]")
		elseif v.Name == "30 [Glock Ammo] - $64" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Ammo", "[Glock]")
		elseif v.Name == "5 [RPG Ammo] - $1061" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Ammo", "[RPG]")
		elseif v.Name == "5 [Rifle Ammo] - $265" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Ammo", "[Rifle]")
		elseif v.Name == "80 [SMG Ammo] - $64" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Ammo", "[SMG]")
		elseif v.Name == "90 [AK47 Ammo] - $85" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Ammo", "[AK47]")
		elseif v.Name == "90 [AUG Ammo] - $85" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Ammo", "[AUG]")
		elseif v.Name == "Boxing Moveset (Require: Max Box Stat) - $0" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Moveset", "Boxing")

		elseif v.Name == "[AK47] - $2387" then
			local Info = {
				Name = "[AK47]",
				StartingAmmo = "30"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[AR] - $1061" then
			local Info = {
				Name = "[AR]",
				StartingAmmo = "25"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[AUG] - $2069" then
			local Info = {
				Name = "[AUG]",
				StartingAmmo = "30"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[Basketball] - $106" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[Basketball]")
		elseif v.Name == "[Bat] - $265" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", '[Bat]')
		elseif v.Name == "[Bat] - $292" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", '[Bat]')
		elseif v.Name == "[Breathing Mask] - $64" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Mask", "[Breathing Mask]")
		elseif v.Name == "[BrownBag] - $27" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[BrownBag]")
		elseif v.Name == "[Camera] - $106" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[Camera]")
		elseif v.Name == "[Chicken] - $7" then 
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Food", "[Chicken]")
		elseif v.Name == "[Cranberry] - $3" then 
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Food", "[Cranberry]")
		elseif v.Name == "[Dea Milk] - $7" then 
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Food", "[Da Milk]")
		elseif v.Name == "[Default Moveset] - $0" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Moveset", "Default")	
		elseif v.Name == "[Donut] - $11" then 
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Food", "[Donut]")
		elseif v.Name == "[Donut] - $5" then 
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Food", "[Donut]")

		elseif v.Name == "[Double-Barrel SG] - $1432" then 
			local Info = {
				Name = "[Double-Barrel SG]",
				StartingAmmo = "30"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[Double-Barrel SG] - $1485" then 
			local Info = {
				Name = "[Double-Barrel SG]",
				StartingAmmo = "30"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[Drum-Shotgun] - $1167" then 
			local Info = {
				Name = "[Drum-Shotgun]",
				StartingAmmo = "30"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[DrumGun] - $3183" then 
			local Info = {
				Name = "[DrumGun]",
				StartingAmmo = "30"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[Fire Armor] - $2493" then
			local Info = {
				FireArmor = 200
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "FireArmor", Info)

		elseif v.Name == "[Fire Armor] - $2546" then
			local Info = {
				FireArmor = 200
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "FireArmor", Info)

		elseif v.Name == "[Firework] - $10609" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[Firework]")

		elseif v.Name == "[Flamethrower] - $15914" then 
			local Info = {
				Name = "[Flamethrower]",
				StartingAmmo = "70"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[Flashbang] - $583" then 
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[Flashbang]")
		elseif v.Name == "[Flashlight] - $11" then 
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[Flashlight]")
		elseif v.Name == "[Flowers] - $5" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Flowers")
		elseif v.Name == "[FoodsCart] - $16" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Vehicle", "[FoodsCart]")

		elseif v.Name == "[Glock] - $318" then 
			local Info = {
				Name = "[Glock]",
				StartingAmmo = "20"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[Glock] - $530" then 
			local Info = {
				Name = "[Glock]",
				StartingAmmo = "20"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[GrenadeLauncher] - $10609" then 
			local Info = {
				Name = "[GrenadeLauncher]",
				StartingAmmo = "6"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[Grenade] - $1326" then 
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[Grenade]")	
		elseif v.Name == "[Grenade] - $743" then 
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[Grenade]")
		elseif v.Name == "[Hamburger] - $11" then 
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Food", "[Hamburger]")
		elseif v.Name == "[Hamburger] - $5" then 
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Food", "[Hamburger]")
		elseif v.Name == "[HeavyWeights] - $265" then 
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[HeavyWeights]")
		elseif v.Name == "[High-Medium Armor] - $2440" then 	
			local Info = {
				Armor = 130
			}

			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Armor", Info)
		elseif v.Name == "[Full Armor] - $3639" then 	
			local Info = {
				Armor = 200
			}

			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Armor", Info)
		elseif v.Name == "[Hockey Mask] - $64" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Mask", "[Hockey Mask]")
		elseif v.Name == "[HotDog] - $8" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Food", "[HotDog]")
		elseif v.Name == "[Key] - $133" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[Key]")
		elseif v.Name == "[Knife] - $159" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[Knife]")

		elseif v.Name == "[LMG] - $3978" then 
			local Info = {
				Name = "[LMG]",
				StartingAmmo = "100"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[Lemonade] - $3" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Food", "[Lemonade]")
		elseif v.Name == "[Lettuce] - $5" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Food", "[Lettuce]")
		elseif v.Name == "[LockPicker] - $106" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[LockPicker]")
		elseif v.Name == "[LockPicker] - $133" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[LockPicker]")
		elseif v.Name == "[Meat] - $13" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Food", "[Meat]")

		elseif v.Name == "[Medium Armor] - $1061" then
			local Info = {
				Armor = 100
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Armor", Info)

		elseif v.Name == "[Medium Armor] - $1066" then
			local Info = {
				Armor = 100
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Armor", Info)

		elseif v.Name == "[Medium Armor] - $1326" then
			local Info = {
				Armor = 100
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Armor", Info)

		elseif v.Name == "[Medium Armor] - $1697" then
			local Info = {
				Armor = 100
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Armor", Info)

		elseif v.Name == "[Money Gun] - $824" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[Money Gun]")
		elseif v.Name == "[Ninja Mask] - $64" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Mask", "[Ninja Mask]")
		elseif v.Name == "[Surgeon Mask] - $27" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Mask", "[Surgeon Mask]")
		elseif v.Name == "[Old Phone] - $106" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Phone", "[Old Phone]")
		elseif v.Name == "[Orange Phone] - $424" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Phone", "[Orange Phone]")
		elseif v.Name == "[Original Phone] - $53" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Phone", "[Regular]")

		elseif v.Name == "[P90] - $1061" then 
			local Info = {
				Name = "[P90] ",
				StartingAmmo = "40"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[Paintball Mask] - $64" then 
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Mask", "[Paintball Mask]")
		elseif v.Name == "[Pencil] - $186" then 
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[Pencil]")
		elseif v.Name == "[PepperSpray] - $159" then 
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[PepperSpray]")
		elseif v.Name == "[PepperSpray] - $80" then 
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[PepperSpray]")
		elseif v.Name == "[PinkPhone] - $424" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Phone", "[PinkPhone]")
		elseif v.Name == "[Pitchfork] - $339" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[Pitchfork]")
		elseif v.Name == "[Pizza] - $11" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Food", "[Pizza]")
		elseif v.Name == "[Pizza] - $5" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Food", "[Pizza]")
		elseif v.Name == "[Popcorn] - $7" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Food", "[Popcorn]")
		elseif v.Name == "[Pumpkin Mask] - $64" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Mask", "[Pumpkin Mask]")

		elseif v.Name == "[P90] - $1061" then 
			local Info = {
				Name = "[P90] ",
				StartingAmmo = "40"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[RPG] - $21218" then 
			local Info = {
				Name = "[RPG]",
				StartingAmmo = "1"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[RPG] - $6365" then 
			local Info = {
				Name = "[RPG]",
				StartingAmmo = "1"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[Revolver] - $1379" then 
			local Info = {
				Name = "[Revolver]",
				StartingAmmo = "6"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[Revolver] - $1485" then 
			local Info = {
				Name = "[Revolver]",
				StartingAmmo = "6"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[Rifle] - $1644" then 
			local Info = {
				Name = "[Rifle]",
				StartingAmmo = "1"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[Riot Mask] - $64" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Mask", "[Riot Mask]")

		elseif v.Name == "[SMG] - $796" then 
			local Info = {
				Name = "[SMG]",
				StartingAmmo = "20"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[Shotgun] - $1326" then 
			local Info = {
				Name = "[Shotgun]",
				StartingAmmo = "5"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[Shovel] - $339" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[Shovel]")

		elseif v.Name == "[SilencerAR] - $1326" then 
			local Info = {
				Name = "[SilencerAR]",
				StartingAmmo = "30"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[Silencer] - $424" then 
			local Info = {
				Name = "[Silencer]",
				StartingAmmo = "15"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[Silencer] - $583" then 
			local Info = {
				Name = "[Silencer]",
				StartingAmmo = "15"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[Skull Mask] - $64" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Mask", "[Skull Mask]")
		elseif v.Name == "[SledgeHammer] - $371" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[SledgeHammer]")
		elseif v.Name == "[Starblox Latte] - $5" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Food", "[Starblox Latte]")
		elseif v.Name == "[StopSign] - $318" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[StopSign]")
		elseif v.Name == "Mask - $27" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Mask", "Mask")
		elseif v.Name == "[Taco] - $2" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Food", "[Taco]")
		elseif v.Name == "[Taco] - $4" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Food", "[Taco]")

		elseif v.Name == "[TacticalShotgun] - $1857" then 
			local Info = {
				Name = "[TacticalShotgun]",
				StartingAmmo = "6"
			}
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Weapon", Info)

		elseif v.Name == "[TearGas] - $5305" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[TearGas]")
		elseif v.Name == "[Tele] - $159" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Phone", "[Tele]")
		elseif v.Name == "[Weights] - $127" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Misc", "[Weights]")
		elseif v.Name == "[iPhoneB] - $637" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Phone", "[iPhoneB]")
		elseif v.Name == "[iPhoneG] - $637" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Phone", "[iPhoneG]")
		elseif v.Name == "[iPhoneP] - $637" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Phone", "[iPhoneP]")
		elseif v.Name == "[iPhone] - $637" then
			Helper.v7(v:FindFirstChildOfClass("ClickDetector"), "Phone", "[iPhone]")
		end
	end
end

function Helper.Load(Player)
	task.spawn(function()
		local __DELAY = 2
		task.wait(__DELAY)
		local Data = DataStore:GetAsync(Player.UserId)
		pcall(function()
			repeat wait() until Player.Character 
			if ReplicatedStorage.BattleRoyale.Starting.Value ~= false then
				Player:Kick('A crew war has already started')
				return
			end
			repeat wait() until not Player.Character:FindFirstChildOfClass('ForceField')
		end)
		
		table.insert(_G.PlayerData.Players, Player)
		_G.PlayerData.Players[Player] = {
			Saved = false,
			Debounces = {
				Currency = {
					Pickup = false,
					Drop = false
				},
				Action = {
					Action = false,
					Stomp = false,
					Emote = false,
					Police = false
				},
				Reports = {
					Reporting = false
				},
				Calling = {
					Calling = false
				},
				Buypads = {
					Vehicles = {
						['[SoloBike]'] = false,
						['[DuoBike]'] = false,
						['[FoodsCart]'] = false
					},
					Misc = {
						['[Flowers]'] = false
					}
				}
			},
			Stats = {
				Permissions = {
					IsInGroup = false,
					Kicked = false,
					ShazamClothes = {},
					Rank = 0,
					BanCooldown = 0,
					UnbanCooldown = 0,
					KickCooldown = 0,
					ServerIDCooldown = 0
				},
				Misc = {
					Data = {
						DataVersion = 1,
						IS_MOBILE = false,
						GUN_CLOSE_COMBAT = false,
						DeviceChosen = false,
						LastPaycheck = tick(),
						TimerDecrease = tick(),
						Drops = {},
					}
				}
			}
		}

		local Stats = Instance.new('Folder', Player)
		Stats.Name = 'leaderstats'

		local Wanted2 = Instance.new('IntValue', Stats)
		Wanted2.Name = 'Wanted'

		local DataFolder = Instance.new('Folder', Player)
		DataFolder.Name = 'DataFolder'

		local Inventory = Instance.new('Folder', DataFolder)
		Inventory.Name = 'Inventory'
		local Warning = Instance.new('IntValue', DataFolder)
		Warning.Name = 'Warning'

		local BankDeposit = Instance.new('IntValue', DataFolder)
		BankDeposit.Name = 'BankDeposit'

		local Currency = Instance.new('IntValue', DataFolder)
		Currency.Name = 'Currency'
		Currency.Value = 1200000

		local DataVersion = Instance.new('IntValue', DataFolder)
		DataVersion.Name = 'DataVersion'
		DataVersion.Value = 1

		local Information = Instance.new('Folder', DataFolder)
		Information.Name = 'Information'

		local FurnitureData = Instance.new("StringValue", Information)
		FurnitureData.Name  = "FurnitureData"
		FurnitureData.Value = '{}'

		local WeaponSkins = Instance.new('StringValue', Information)
		WeaponSkins.Name = 'WeaponSkins'
		WeaponSkins.Value = "{}"

		local EquipSkins = Instance.new('StringValue', Information)
		EquipSkins.Name = 'EquipSkins'
		EquipSkins.Value = "{}"

		local LowGFX = Instance.new('BoolValue', Information)
		LowGFX.Name = 'LowGFX'
		
		local AntiFling = Instance.new('BoolValue', Information)
		AntiFling.Name = 'AntiFling'

		local Headless = Instance.new('BoolValue', Information)
		Headless.Name = 'Headless'

		local Korblox = Instance.new('BoolValue', Information)
		Korblox.Name = 'Korblox'

		local MuteBoombox = Instance.new('BoolValue', Information)
		MuteBoombox.Name = 'MuteBoombox'

		local Wanted = Instance.new('IntValue', Information)
		Wanted.Name = 'Wanted'

		local Officer = Instance.new('IntValue', DataFolder)
		Officer.Name = 'Officer'

		local Codes = Instance.new("StringValue", DataFolder.Information)
		Codes.Name = "Codes"
		Codes.Value = game:GetService("HttpService"):JSONEncode({})

		local CursorImage = Instance.new('StringValue', DataFolder)
		CursorImage.Name = 'CursorImage'

		local GameplayTimer = Instance.new('NumberValue', Player)
		GameplayTimer.Name = 'GamePlayTimer'
		GameplayTimer.Value = tick()

		if Data then
			pcall(function()
				if Data.Data.Currency ~= nil then
					Currency.Value = Data.Data.Currency 
				end
			end)
			pcall(function()
				if Data.Data.CursorImage ~= nil then
					CursorImage.Value = Data.Data.CursorImage 
				end
			end)
			pcall(function()
				if Data.Data.FurnitureData ~= nil then
					FurnitureData.Value = Data.Data.FurnitureData 
				end
			end)
			pcall(function()
				if Data.Data.Codes ~= nil then
					Codes.Value = Data.Data.Codes 
				end
			end)
			pcall(function()
				if Data.Data.Warning ~= nil then
					Warning.Value = Data.Data.Warning
				end
			end)
			pcall(function()
				if Data.Data.BankDeposit ~= nil then
					BankDeposit.Value = Data.Data.BankDeposit
				end
			end)
			pcall(function()
				if Data.Information.Jail ~= nil then
					local Jail = Instance.new('StringValue', Information)
					Jail.Name = 'Jail'
					Jail.Value = Data.Information.Jail
				end
			end)
			pcall(function()
				if Data.Information.Muscle ~= nil then
					local MuscleInformation = Instance.new('StringValue', Information)
					MuscleInformation.Name = 'MuscleInformation'
					MuscleInformation.Value = Data.Information.Muscle
				end
			end)
			pcall(function()
				if Data.Information.SavedStomps ~= nil and Data.Information.SavedStomps ~= ''  then
					local SavedStomps = Instance.new('StringValue', Information)
					SavedStomps.Name = 'SavedStomps'
					SavedStomps.Value = Data.Information.SavedStomps
				end
			end)
			pcall(function()
				if Data.Information.EquipSkins ~= nil and Data.Information.WeaponSkins ~= '' and Data.Information.EquipSkins ~= ''  then
					EquipSkins.Name = 'EquipSkins'
					EquipSkins.Value = Data.Information.EquipSkins
				end
			end)
			pcall(function()
				if Data.Information.WeaponSkins ~= nil and Data.Information.WeaponSkins ~= '' then
					WeaponSkins.Name = 'WeaponSkins'
					WeaponSkins.Value = Data.Information.WeaponSkins
				end
			end)
			pcall(function()
				if Data.Information.LowGFX ~= nil then
					LowGFX.Name = 'LowGFX'
					LowGFX.Value = Data.Information.LowGFX
				end
			end)
			pcall(function()
				if Data.Information.AntiFling ~= nil then
					AntiFling.Name = 'AntiFling'
					AntiFling.Value = Data.Information.AntiFling
				end
			end)
			pcall(function()
				if Data.Information.Headless ~= nil then
					Headless.Name = 'Headless'
					Headless.Value = Data.Information.Headless
				end
			end)
			pcall(function()
				if Data.Information.Korblox ~= nil then
					Korblox.Name = 'Korblox'
					Korblox.Value = Data.Information.Korblox
				end
			end)
			pcall(function()
				if Data.Information.MuteBoombox ~= nil then
					MuteBoombox.Name = 'MuteBoombox'
					MuteBoombox.Value = Data.Information.MuteBoombox
				end
			end)
			pcall(function()
				if Data.Information.Wanted ~= nil then
					Wanted.Value = Data.Information.Wanted
					Wanted2.Value = Wanted.Value
				end
			end)
			pcall(function()
				if Data.Information.ArmorSave ~= nil then
					local ArmorSave = Instance.new('IntValue', Information)
					ArmorSave.Name = 'ArmorSave'
					ArmorSave.Value = Data.Information.ArmorSave
				end
			end)
			pcall(function()
				if Data.Information.FireArmorSave ~= nil then
					local FireArmorSave = Instance.new('IntValue', Information)
					FireArmorSave.Name = 'FireArmorSave'
					FireArmorSave.Value = Data.Information.FireArmorSave
				end
			end)
			if Data.Inventory ~= nil then
				for value, x in pairs(Data.Inventory) do
					local StringValue = Instance.new('StringValue', Inventory)
					StringValue.Name = value
					StringValue.Value = x
				end
			end
			pcall(function()
				if Data.Information.Log ~= nil and Data.Information.Log == 1 then
					local Log = Instance.new('StringValue', Information)
					Log.Name = 'Log'
					Log.Value = tostring(0)
				end
			end)
			pcall(function()
				if Data.DataVersion ~= nil then
					_G.PlayerData.Players[Player].Stats.Misc.Data.DataVersion = Data.DataVersion
				end
			end)
			pcall(function()
				if Data.Information.Crew ~= nil then
					local Crew = Instance.new('StringValue', Information)
					Crew.Name = 'Crew'
					if Player:IsInGroup(tonumber(Data.Information.Crew)) then
						Crew.Value = Data.Information.Crew
					end
				end
			end)
			pcall(function()
				if Data.Information.Ringtone ~= nil then
					local RingToneId = Instance.new('StringValue', Information)
					RingToneId.Name = 'RingToneId'
					RingToneId.Value = Data.Information.Ringtone
				end
			end)
			pcall(function()
				if Data.Information.AirPlaneMode ~= nil then
					local AirPlaneMode = Instance.new('StringValue', Information)
					AirPlaneMode.Name = 'AirPlaneMode'
					AirPlaneMode.Value = Data.Information.AirPlaneMode
				end
			end)
			pcall(function()
				if Data.Information.HouseSave ~= nil then
					local HouseSave = Instance.new('StringValue', Information)
					HouseSave.Name = 'HouseSave'
					HouseSave.Value = Data.Information.HouseSave
				end
			end)
			pcall(function()
				if Data.Information.BoxingValue ~= nil then
					local BoxingValue = Instance.new('StringValue', Information)
					BoxingValue.Name = 'BoxingValue'
					BoxingValue.Value = Data.Information.BoxingValue
				end
			end)
			pcall(function()
				if Player:IsInGroup(437692280) then
					_G.PlayerData.Players[Player].Stats.Permissions.IsInGroup = true
					_G.PlayerData.Players[Player].Stats.Permissions.Rank = Player:GetRankInGroup(437692280) 
				end
			end)
			pcall(function()
				if Data.Information.FightingStyle ~= nil then
					local FightingStyle = Instance.new('StringValue', Information)
					FightingStyle.Name = 'FightingStyle'
					FightingStyle.Value = Data.Information.FightingStyle
				end
			end)
		end
		local LOADED = Instance.new('Folder', Player)
		LOADED.Name = 'LOAD_SAVE_DATA'
	end)

	Player.CharacterAdded:Connect(function()
		repeat until Player.Character
		local Character = Player.Character
		repeat until Character:FindFirstChildOfClass('Humanoid')
		local Humanoid = Character:FindFirstChildOfClass('Humanoid')
		Humanoid:WaitForChild('BodyWidthScale').Value = 1
		Humanoid:WaitForChild('BodyDepthScale').Value = 1		
		Humanoid:WaitForChild('BodyHeightScale').Value = 1


		repeat task.wait() until Player:FindFirstChild('LOAD_SAVE_DATA')
		task.wait(1)
		if Character ~= Player.Character then
			return
		end

		local HumanoidDescription = Humanoid:GetAppliedDescription()

		if Character:FindFirstChildOfClass('ForceField') then
			Character:FindFirstChildOfClass('ForceField'):Destroy()
		end

		pcall(function()
			task.spawn(function()
				pcall(function()
					for i,v in pairs(Player.Backpack:GetChildren()) do
						if not v:FindFirstChild('OwnerTag') then
							local OwnerTag = Instance.new('ObjectValue', v)
							OwnerTag.Name = 'OwnerTag'
							OwnerTag.Value = Player
						end
					end
					Player.Backpack.ChildAdded:Connect(function(Child)
						if Child:IsA('Tool') then
							if not Child:FindFirstChild('OwnerTag') then
								local OwnerTag = Instance.new('ObjectValue', Child)
								OwnerTag.Name = 'OwnerTag'
								OwnerTag.Value = Player
							end
						end
					end)
				end)
			end)
			task.spawn(function()
				task.spawn(function()
					local Weave = Instance.new('Sound', Character:WaitForChild('HumanoidRootPart'))
					Weave.Name = 'Weave'
					Weave.SoundId = 'rbxassetid://231731980'
					Weave.Volume = 0.5
					Weave.Looped = false
					Weave.RollOffMode = Enum.RollOffMode.Inverse
				end)
				local LCUFF = ServerStorage.Storage.Misc.Character.Models.Cuffs.L.CUFF:Clone()
				local RCUFF = ServerStorage.Storage.Misc.Character.Models.Cuffs.L.CUFF:Clone()
				LCUFF.Massless = true
				RCUFF.Massless = true
				local LWELD, RWELD = Instance.new('Weld', LCUFF), Instance.new('Weld', RCUFF)
				LWELD.Part0 = Character:WaitForChild('LeftLowerArm')
				LWELD.Part1 = LWELD.Parent
				RWELD.Part0 = Character:WaitForChild('RightLowerArm')
				RWELD.Part1 = RWELD.Parent
				LCUFF.Parent = Character.LeftLowerArm
				RCUFF.Parent = Character.RightLowerArm
			end)
		end)
		if Player.DataFolder.Officer.Value == 1 then
			pcall(function()
				Character:SetPrimaryPartCFrame(workspace.Ignored.PoliceSpawn.CFrame)
				for i,v in pairs(Character:GetChildren()) do
					if v:IsA('Shirt') or v:IsA('Pants') then
						v:Destroy()
					end
				end
				for i,v in pairs(ServerStorage.Storage.Tools.Misc.Police:GetChildren()) do
					if v:IsA('Tool') then
						v:Clone().Parent = Player.Backpack
					end
				end
				local Shirt = Instance.new('Shirt', Character)
				Shirt.ShirtTemplate = 'rbxassetid://535806099'
				Shirt.Name = 'Shirt'
				local Pants = Instance.new('Pants', Character)
				Pants.PantsTemplate = 'rbxassetid://15224239'
				Pants.Name = 'Pants'
			end)
		end
		if Player.DataFolder.Information:FindFirstChild('Jail') then
			task.spawn(function()
				local Jail = Player.DataFolder.Information.Jail
				if tonumber(Jail.Value) > 0 then
					pcall(function()
						local JAILLOCATION = workspace.Ignored.JAILLOCATION1.CFrame
						Character:SetPrimaryPartCFrame(JAILLOCATION)
						Character:WaitForChild('BodyEffects').Cuff.Value = true
						Character:WaitForChild('LeftLowerArm').CUFF.Transparency = 0
						Character.LeftLowerArm.CUFF.Mesh.Scale = Character.LeftLowerArm.Size + Vector3.new(0, 0.051996, 0)
						Character:WaitForChild('RightLowerArm').CUFF.Transparency = 0
						Character.RightLowerArm.CUFF.Mesh.Scale = Character.RightLowerArm.Size + Vector3.new(0, 0.051996, 0)
						local Animation = Instance.new('Animation')
						Animation.AnimationId = 'rbxassetid://105161164090970'
						local Track = Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(Animation)
						Track:Play()
					end)
				end
			end)
			task.spawn(function()
				pcall(function()
					local Humanoid = Character:FindFirstChildOfClass('Humanoid')
					while wait(0.1) do
						if not Character then
							break
						end
						if Character.BodyEffects.Cuff.Value == true then
							if Character:FindFirstChildOfClass('Tool') then
								Humanoid:UnequipTools()
							end
						end
					end
				end)
			end)
		end

		if MainModule.CheckInCrew(Player) then
			if Player.DataFolder.Officer.Value ~= 1 then
				local SprayCan = ServerStorage.Storage.Tools.Misc['[SprayCan]']:Clone()
				SprayCan.Parent = Player.Backpack
			end
		end
		for i,v in pairs(workspace.MAP.Graffiti:GetChildren()) do
			if v.Name == Player.Name then
				v:Destroy()
			end
		end

		if Player.DataFolder.Information:FindFirstChild('Log') then
			if Player.DataFolder.Information.Log.Value == tostring(1) then
				local ResetTools = true
				if Player.DataFolder.Information:FindFirstChild('Jail') then
					local Jail = Player.DataFolder.Information.Jail
					if tonumber(Jail.Value) > 0 then
						ResetTools = false
					end
				end
				Player.DataFolder.Information.Log.Value = tostring(0)
			end
		end
		if Player.DataFolder.Information:FindFirstChild('ArmorSave') then
			Character:WaitForChild('BodyEffects').Armor.Value = Player.DataFolder.Information.ArmorSave.Value
		end
		Character.BodyEffects.Armor:GetPropertyChangedSignal('Value'):Connect(function()
			pcall(function()
				Player.DataFolder.Information.ArmorSave.Value = Character.BodyEffects.Armor.Value
			end)
		end)

		Character.Parent = workspace.Players
		local LOADED = Instance.new('Folder', Character)
		LOADED.Name = 'FULLY_LOADED_CHAR'
		task.spawn(function()
			require(ServerStorage.Storage.Misc.Server.Modules.Characters).SetupCharacter(Player.Character)
		end)

		task.spawn(function()
			local Weapons = {
				"[Double-Barrel SG]",
				"[Revolver]",
				"[TacticalShotgun]"
			}

			for _, Weapon in pairs(Weapons) do
				local InstanceCheck = Player.DataFolder.Inventory:FindFirstChild(Weapon)

				if InstanceCheck then
					InstanceCheck:Destroy()
				end
			end

			for _, Weapon in ipairs(Weapons) do
				local WeaponClone = ServerStorage.Storage.Tools.Weapons:FindFirstChild(Weapon):Clone()
				local Ammo, MaxAmmo = WeaponClone:FindFirstChild("Ammo"), WeaponClone:FindFirstChild("MaxAmmo")

				local StringValue = Instance.new("StringValue")
				StringValue.Name = WeaponClone.Name

				StringValue.Value = 999

				Ammo.Value = MaxAmmo.Value

				StringValue.Parent = Player.DataFolder.Inventory
				WeaponClone.Parent = Player.Backpack
			end
			
			ServerStorage.Storage["[Knife]"]:Clone().Parent = Player.Backpack
			ServerStorage.Storage.Wallet:Clone().Parent = Player.Backpack
		end)

		if Player.DataFolder.Information:FindFirstChild('MuscleInformation') then
			local Muscle = tonumber(Player.DataFolder.Information.MuscleInformation.Value)
			local Width = 1 + (Muscle * (1/400/75))
			local Depth = 1 + (Muscle * (1/400/75))
			local Height = 1
			if Muscle > 0 then
				Height = 1 + (Muscle * 0.00002)
			end

			local Headless = Player.DataFolder.Information:FindFirstChild("Headless")
			local Korblox = Player.DataFolder.Information:FindFirstChild("Korblox")

			if Headless and Headless.Value then
				HumanoidDescription.Head = 134082579
			end

			if Korblox and Korblox.Value then
				HumanoidDescription.RightLeg = 139607718
			end
			
			if Player.UserId ~= 4036211720 then 
				HumanoidDescription.BodyTypeScale = 0
				HumanoidDescription.WidthScale = Width
				HumanoidDescription.DepthScale = Depth
				HumanoidDescription.HeightScale = Height
				HumanoidDescription.ProportionScale = 0
				HumanoidDescription.HeadScale = 1
			end
		end

		Humanoid:ApplyDescription(HumanoidDescription)
	end)


	Player.Chatted:Connect(function(msg)
		if not Player:FindFirstChild('LOAD_SAVE_DATA') then
			return
		end
		if RunService:IsStudio() then 
			if msg:lower() == '.bringall' then
				pcall(function()
					local HRP = Player.Character.HumanoidRootPart
					for i,v in pairs(workspace.Players:GetChildren()) do 
						if v:FindFirstChild('HumanoidRootPart') then
							v.HumanoidRootPart.CFrame = HRP.CFrame
						end
					end
				end)
			end
		end

		if _G.PlayerData.Players[Player].Stats.Permissions.Rank >= 245 then
			if msg:lower() == 'shazam!' and not Player.Character:FindFirstChild("DANNY_MODE") then
				pcall(function()
					if not Player.Character then
						return
					end
					if not Player.Character.PrimaryPart then
						return
					end
					if not Player.Character:FindFirstChild('LowerTorso') then
						return
					end
					if not Player.Character:FindFirstChildOfClass('Humanoid') then
						return
					end
					local Humanoid = Player.Character:FindFirstChildOfClass('Humanoid')
					if not Player.Character.LowerTorso:FindFirstChild('lighting_bolt') then
						local Sound = Instance.new('Sound', Player.Character.LowerTorso)
						Sound.Name = 'lighting_bolt'
						Sound.SoundId = 'rbxassetid://821439273'
						Sound.Volume = 0.1
						local Distor = Instance.new('DistortionSoundEffect', Sound)

						Sound:Play()
					else
						Player.Character.LowerTorso['lighting_bolt']:Play()
					end
					local function Lightning(Character)
						local Lightning = ServerStorage.Storage.Tools.Admin.Powers.Shazam.Lightning:GetChildren()
						local Bolt = Lightning[math.random(1, #Lightning)]:Clone()
						local Orientation = Bolt.PrimaryPart.Orientation
						Bolt:SetPrimaryPartCFrame(CFrame.new(Character.PrimaryPart.Position) * CFrame.Angles(math.rad(Orientation.X), math.rad(Orientation.Y), math.rad(Orientation.Z)))
						Bolt.Parent = Character
						local Tween = TweenService:Create(Bolt.Lightning, TweenInfo.new(1.85, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 1})
						Tween:Play()
						Tween.Completed:Connect(function()
							delay(1, function()
								Bolt:Destroy()
							end)
						end)
					end
					if not Player.Backpack:FindFirstChild('Fly') and not Player.Character:FindFirstChild('Fly') then
						Lightning(Player.Character)
						local Outfit = ServerStorage.Storage.Tools.Admin.Powers.Shazam.Outfits:FindFirstChild(_G.PlayerData.Teams[Player.UserId].Shazam.Type)
						for i,v in pairs(Player.Character:GetChildren()) do 
							if (v:IsA('Shirt') or v:IsA('Pants')) then
								table.insert(_G.PlayerData.Players[Player].Stats.Permissions.ShazamClothes, {v, v.Parent})
								v.Parent = nil
							end
						end
						for i,v in pairs(Outfit:GetChildren()) do 
							v:Clone().Parent = Player.Character
						end
						Humanoid.MaxHealth = math.huge
						Humanoid.Health = Humanoid.MaxHealth

						local Fly = ServerStorage.Storage.Tools.Admin.Powers.Shazam.Fly:Clone()
						Fly.Parent = Player.Backpack
						local Hearing = ServerStorage.Storage.Tools.Admin.Powers.Shazam.Hearing:Clone()
						Hearing.Parent = Player.Backpack

						local SHAZAM_MODE = Instance.new("Folder")
						SHAZAM_MODE.Name = "SHAZAM_MODE"
						SHAZAM_MODE.Parent= Player.Character
					else 
						Lightning(Player.Character)
						if Player.Character:FindFirstChild("SHAZAM_MODE") then
							Player.Character:FindFirstChild("SHAZAM_MODE"):Destroy()
						end
						Humanoid.MaxHealth = 100
						Humanoid.Health = Humanoid.MaxHealth
						for i,v in pairs(Player.Backpack:GetChildren()) do 
							if v.Name == 'Fly' or v.Name == 'Hearing' then
								v:Destroy()
							end
						end
						for i,v in pairs(Player.Character:GetChildren()) do 
							if v.Name == 'Fly' then
								v.Parent = Player.Backpack
							end
							if v.Name == 'Hearing' then
								v.Parent = Player.Backpack
							end
							if (v.Name == 'Fly' or v:IsA('Shirt') or v:IsA('Pants') or v.Name == 'Cape' or v.Name == 'Hearing')  then
								v:Destroy()
							end
						end
						for i,v in pairs(_G.PlayerData.Players[Player].Stats.Permissions.ShazamClothes) do 
							v[1].Parent = v[2]
						end
						table.clear(_G.PlayerData.Players[Player].Stats.Permissions.ShazamClothes)
					end
				end)
			end
		end
	end)
end


function Helper.SaveData(Player, Banned, Method)
	if typeof(Player) == 'number' then
		if Banned == 'BAN' then
			local Data = DataStore:GetAsync(Player)
			if Data and Data.Banned.Banned == true then
				return false
			end
			if not Data then
				Data = {
					DataVersion = 1,
					Inventory = {},
					Banned = {
						Banned = false,
						Type = 'None',
						Temporary = {
							Timed = false,
							Time = 0
						}
					},
					Data = {
						Warning = 0,
						BankDeposit = 0,
						Currency = 1200000,
						Officer = 0,
						CursorImage = '',
					},
					Information = {
						Log = 0,
						Jail = nil,
						WeaponSkins = '{}',
						Codes = "{}",
						Muscle = nil,
						EquipSkins = '{}',
						SavedStomps = '{}',
						ArmorSave = nil,
						Crew = nil,
						Ringtone = nil,
						AirPlaneMode = nil,
						LowGFX = nil,
						Headless = nil,
						Korblox = nil,
						AntiFling = nil,
						MuteBoombox = nil,
						HouseSave = nil,
						BoxingValue = nil,
						FightingStyle = nil
					}
				}
			end
			Data.Banned.Banned = true
			Data.Banned.Type = 'ADMIN'
			DataStore:SetAsync(Player, Data)
			return true
		else 
			local Data = DataStore:GetAsync(Player)
			if Data then
				if Data.Banned.Banned == false then
					return false
				end
				Data.Banned.Banned = false
				Data.Banned.Type = 'None'
				DataStore:SetAsync(Player, Data)
				return true
			end
		end
	end
	if not Player:FindFirstChild('LOAD_SAVE_DATA') then
		return
	end
	if _G.PlayerData.Players[Player] == nil then
		return
	end
	if _G.PlayerData.Players[Player].Saved ~= false then
		return
	end
	local DataToSave = {
		DataVersion = _G.PlayerData.Players[Player].Stats.Misc.Data.DataVersion,
		Inventory = {},
		Banned = {
			Banned = false,
			Type = 'None',
			Temporary = {
				Timed = false,
				Time = 0
			}
		},
		Data = {
			Warning = Player.DataFolder.Warning.Value,
			BankDeposit = Player.DataFolder.BankDeposit.Value,
			Currency = Player.DataFolder.Currency.Value,
			CursorImage = Player.DataFolder.CursorImage.Value,
			Codes = Player.DataFolder.Information.Codes.Value,
			FurnitureData = Player.DataFolder.Information.FurnitureData.Value
		},
		Information = {
			Log = 0,
			Jail = nil,
			Muscle = nil,
			Wanted = 0,
			SavedStomps = '',
			EquipSkins = Player.DataFolder.Information.EquipSkins.Value,
			WeaponSkins = Player.DataFolder.Information.WeaponSkins.Value,
			ArmorSave = nil,
			FireArmorSave = nil,
			Crew = nil,
			Ringtone = nil,
			AirPlaneMode = nil,
			LowGFX = nil,
			Headless = nil,
			Korblox = nil,
			AntiFling = nil,
			MuteBoombox = nil,
			HouseSave = nil,
			BoxingValue = nil,
			FightingStyle = nil
		}
	}
	if Player.DataFolder.Information:FindFirstChild('Jail') then
		DataToSave.Information.Jail = Player.DataFolder.Information.Jail.Value
	end
	if Player.DataFolder.Information:FindFirstChild('WeaponSkins') then
		DataToSave.Information.WeaponSkins = Player.DataFolder.Information.WeaponSkins.Value
	end
	if Player.DataFolder.Information:FindFirstChild('EquipSkins') then
		DataToSave.Information.EquipSkins = Player.DataFolder.Information.EquipSkins.Value
	end
	if Player.DataFolder.Information:FindFirstChild('Codes') then
		DataToSave.Information.Codes = Player.DataFolder.Information.Codes.Value
	end
	if Player.DataFolder.Information:FindFirstChild('Wanted') then
		DataToSave.Information.Wanted = Player.DataFolder.Information.Wanted.Value
	end

	if Player.DataFolder.Information:FindFirstChild('MuscleInformation') then
		DataToSave.Information.Muscle = Player.DataFolder.Information.MuscleInformation.Value
	end
	if Player.DataFolder.Information:FindFirstChild('SavedStomps') then
		DataToSave.Information.SavedStomps = Player.DataFolder.Information.SavedStomps.Value
	end
	if Player.DataFolder.Information:FindFirstChild('ArmorSave') then
		DataToSave.Information.ArmorSave = Player.DataFolder.Information.ArmorSave.Value
	end
	if Player.DataFolder.Information:FindFirstChild('Crew') then
		DataToSave.Information.Crew = Player.DataFolder.Information.Crew.Value
	end
	if Player.DataFolder.Information:FindFirstChild('RingToneId') then
		DataToSave.Information.Ringtone = Player.DataFolder.Information.RingToneId.Value
	end
	if Player.DataFolder.Information:FindFirstChild('AirPlaneMode') then
		DataToSave.Information.AirPlaneMode = Player.DataFolder.Information.AirPlaneMode.Value
	end
	if Player.DataFolder.Information:FindFirstChild('LowGFX') then
		DataToSave.Information.LowGFX = Player.DataFolder.Information.LowGFX.Value
	end
	if Player.DataFolder.Information:FindFirstChild('AntiFling') then
		DataToSave.Information.AntiFling = Player.DataFolder.Information.AntiFling.Value
	end
	if Player.DataFolder.Information:FindFirstChild('Headless') then
		DataToSave.Information.Headless = Player.DataFolder.Information.Headless.Value
	end
	if Player.DataFolder.Information:FindFirstChild('Korblox') then
		DataToSave.Information.Korblox = Player.DataFolder.Information.Korblox.Value
	end
	if Player.DataFolder.Information:FindFirstChild('MuteBoombox') then
		DataToSave.Information.MuteBoombox = Player.DataFolder.Information.MuteBoombox.Value
	end
	if Player.DataFolder.Information:FindFirstChild('HouseSave') then
		DataToSave.Information.HouseSave = Player.DataFolder.Information.HouseSave.Value
	end
	if Player.DataFolder.Information:FindFirstChild('BoxingValue') then
		DataToSave.Information.BoxingValue = Player.DataFolder.Information.BoxingValue.Value
	end
	if Player.DataFolder.Information:FindFirstChild('FightingStyle') then
		DataToSave.Information.FightingStyle = Player.DataFolder.Information.FightingStyle.Value
	end
	for i,v in pairs(Player.DataFolder.Inventory:GetChildren()) do
		DataToSave.Inventory[v.Name] = v.Value
	end
	if Player.DataFolder.Information:FindFirstChild('Log') then
		DataToSave.Information.Log = 1
		if Player.DataFolder.Information.Log.Value == tostring(1) then
			for i,v in pairs(DataToSave.Inventory) do
				DataToSave.Inventory[i] = 0
			end
			DataToSave.Information.ArmorSave = 0
		end
	end
	for i,v in pairs(workspace.MAP.Graffiti:GetChildren()) do
		if v.Name == Player.Name then
			v:Destroy()
		end
	end
	for i,v in pairs(workspace.Vehicles:GetChildren()) do
		if v.Name == Player.Name..'BIKE' then
			v:Destroy()
		end
	end
	if Banned.Banned == true then
		if Banned.Type == 'AC' then
			local Webhook = Helper.Webhooks.BanLogs[1]
			pcall(function()
				HttpService:PostAsync(Webhook, HttpService:JSONEncode(
					{
						content = '`[ANTI-CHEAT BANNED]:` '..Player.UserId
					}),
					Enum.HttpContentType.ApplicationJson)
			end)
		end
	end
	DataToSave.Banned.Banned = Banned.Banned
	DataToSave.Banned.Type = Banned.Type
	_G.PlayerData.Players[Player].Saved = true
	local s, e = pcall(function()
		if Method == 1 then
			DataStore:UpdateAsync(Player.UserId, function(pastData)
				if pastData and pastData.DataVersion ~= _G.PlayerData.Players[Player].Stats.Misc.Data.DataVersion then
					return nil
				end
				DataToSave.DataVersion += 1
				return DataToSave
			end)
		else 
			DataStore:SetAsync(Player.UserId, DataToSave)
		end
	end)
	for i, v in pairs(_G.PlayerData.Players[Player]) do
		if v == Player then
			table.remove(_G.PlayerData.Players[Player], i)
		end
	end
	if e then
		error('Failed to save data for player '..Player.Name..'_'..Player.UserId..'! Error info: '..e)
	end
end

function Helper.v7(u1, u2, u3, ...)
	if u2 == "Weapon" then
		u1.MouseClick:Connect(function(Player)

			if not Player:FindFirstChild("LOAD_SAVE_DATA") then
				return;
			end;
			if not Player.Character:FindFirstChild("BodyEffects") then
				return;
			end;
			if not Player.Character.BodyEffects:FindFirstChild("Shop") then
				return;
			end;
			if Player.Character.BodyEffects.Shop.Value ~= false then
				return;
			end; 
			local l__boolean__1 = u1.Parent;
			if Player:DistanceFromCharacter(l__boolean__1.Head.Position) <= u1.MaxActivationDistance then
				if (not Player.Backpack:FindFirstChild(u3.Name) and not Player.Character:FindFirstChild(u3.Name)) then
					if Player.DataFolder.Currency.Value >= l__boolean__1.Price.Value then
						Player.Character.BodyEffects.Shop.Value = true;
						Player.DataFolder.Currency.Value -= l__boolean__1.Price.Value;
						local Gear = ServerStorage.Storage.Tools.Weapons[u3.Name]:Clone();
						Gear.Ammo.Value = Gear.MaxAmmo.Value;
						Gear.Parent = Player.Backpack;
						if not Player.DataFolder.Inventory:FindFirstChild(u3.Name) then
							local StringValue = Instance.new("StringValue", Player.DataFolder.Inventory);
							StringValue.Name = u3.Name;
							StringValue.Value = u3.StartingAmmo;
						else 
							Player.DataFolder.Inventory[u3.Name].Value = u3.StartingAmmo;
						end;
						wait(0.2);
						Player.Character.BodyEffects.Shop.Value = false;
					end;
				end;
			end;
		end);
	elseif u2 == "Ammo" then
		u1.MouseClick:Connect(function(Player)
			if not Player:FindFirstChild("LOAD_SAVE_DATA") then
				return;
			end;
			if not Player.Character:FindFirstChild("BodyEffects") then
				return;
			end;
			if not Player.Character.BodyEffects:FindFirstChild("Shop") then
				return;
			end;
			if Player.Character.BodyEffects.Shop.Value ~= false then
				return;
			end;
			local Part = u1.Parent;
			if Player:DistanceFromCharacter(Part.Head.Position) <= u1.MaxActivationDistance then
				if Player.Backpack:FindFirstChild(u3) then
					if Player.DataFolder.Currency.Value >= Part.Price.Value then
						Player.Character.BodyEffects.Shop.Value = true;
						Player.DataFolder.Currency.Value -= Part.Price.Value;
						Player.DataFolder.Inventory[u3].Value = tostring(tonumber(Player.DataFolder.Inventory[u3].Value) + Part.Amount.Value)
						task.wait(.7);
						Player.Character.BodyEffects.Shop.Value = false;
					end;
				end;
			end;
		end);
	elseif u2 == "Misc" then
		u1.MouseClick:Connect(function(Player)
			if not Player:FindFirstChild("LOAD_SAVE_DATA") then
				return;
			end;
			if not Player.Character:FindFirstChild("BodyEffects") then
				return;
			end;
			if not Player.Character.BodyEffects:FindFirstChild("Shop") then
				return;
			end;
			if Player.Character.BodyEffects.Shop.Value ~= false then
				return;
			end;
			local Part = u1.Parent;
			if Player:DistanceFromCharacter(Part.Head.Position) <= u1.MaxActivationDistance then
				local Undupeables = {
					["[Money Gun]"] = true;
				};
				local Dupeables = {
					["[Grenade]"] = true;
				};
				if Undupeables[u3] == true then
					if Player.Character:FindFirstChild(u3) then
						return
					end
				end
				if not Dupeables[u3] then
					local Count = 0;
					for i,v in pairs(Player.Backpack:GetChildren()) do
						if v.Name == u3 then
							Count += 1;
						end;
					end;
					for i,v in pairs(Player.Character:GetChildren()) do
						if v.Name == u3 then
							Count += 1;
						end;
					end;
					if Count >= 2 then
						return
					end;
				end;
				if (not Player.Backpack:FindFirstChild(u3) or Dupeables[u3] == true ) then
					if Player.DataFolder.Currency.Value >= Part.Price.Value then
						Player.Character.BodyEffects.Shop.Value = true;
						Player.DataFolder.Currency.Value -= Part.Price.Value;
						ServerStorage.Storage.Tools.Misc[u3]:Clone().Parent = Player.Backpack;
						task.wait(.7);
						Player.Character.BodyEffects.Shop.Value = false;
					end;
				end;
			end;
		end);
	elseif u2 == 'Armor' then
		u1.MouseClick:Connect(function(Player)
			if not Player:FindFirstChild('LOAD_SAVE_DATA') then
				return;
			end;
			if not Player.Character:FindFirstChild('BodyEffects') then
				return;
			end;
			if not Player.Character.BodyEffects:FindFirstChild('Shop') then
				return;
			end;
			if Player.Character.BodyEffects.Shop.Value ~= false then
				return;
			end;
			local Part = u1.Parent;
			if Player:DistanceFromCharacter(Part.Head.Position) <= u1.MaxActivationDistance then
				if Player.DataFolder.Currency.Value >= Part.Price.Value then
					if not Player.DataFolder.Information:FindFirstChild('ArmorSave') then
						local ArmorSave = Instance.new('IntValue', Player.DataFolder.Information);
						ArmorSave.Name = 'ArmorSave';
						ArmorSave.Value = u3.Armor;
						if Player.Character then
							Player.Character.BodyEffects.Armor.Value = ArmorSave.Value;
						end;
					else
						Player.DataFolder.Information.ArmorSave.Value = u3.Armor
						if Player.Character then
							Player.Character.BodyEffects.Armor.Value = Player.DataFolder.Information.ArmorSave.Value
						end
					end
					Player.Character.BodyEffects.Shop.Value = true
					Player.DataFolder.Currency.Value -= Part.Price.Value
					task.wait(.7)
					Player.Character.BodyEffects.Shop.Value = false
				end
			end
		end)
	elseif u2 == 'FireArmor' then
		u1.MouseClick:Connect(function(Player)
			if not Player:FindFirstChild('LOAD_SAVE_DATA') then
				return;
			end;
			if not Player.Character:FindFirstChild('BodyEffects') then
				return;
			end;
			if not Player.Character.BodyEffects:FindFirstChild('Shop') then
				return;
			end;
			if Player.Character.BodyEffects.Shop.Value ~= false then
				return;
			end;
			local Part = u1.Parent;
			if Player:DistanceFromCharacter(Part.Head.Position) <= u1.MaxActivationDistance then
				if Player.DataFolder.Currency.Value >= Part.Price.Value then
					if not Player.DataFolder.Information:FindFirstChild('FireArmorSave') then
						local FireArmorSave = Instance.new('IntValue', Player.DataFolder.Information);
						FireArmorSave.Name = 'FireArmorSave';
						FireArmorSave.Value = u3.FireArmor;
						if Player.Character then
							Player.Character.BodyEffects.FireArmor.Value = FireArmorSave.Value;
						end;
					else
						Player.DataFolder.Information.FireArmorSave.Value = u3.FireArmor
						if Player.Character then
							Player.Character.BodyEffects.FireArmor.Value = Player.DataFolder.Information.FireArmorSave.Value
						end
					end
					Player.Character.BodyEffects.Shop.Value = true
					Player.DataFolder.Currency.Value -= Part.Price.Value
					task.wait(.7)
					Player.Character.BodyEffects.Shop.Value = false
				end
			end
		end)
	elseif u2 == 'Furniture' then
		u1.MouseHoverEnter:Connect(function(Player)
			ReplicatedStorage.MainRemotes.MainRemoteEvent:FireClient(Player, 'AddSelectionToItem', true, u1.Parent)
		end)
		u1.MouseHoverLeave:Connect(function(Player)
			ReplicatedStorage.MainRemotes.MainRemoteEvent:FireClient(Player, 'AddSelectionToItem', false, u1.Parent)
		end)
		u1.MouseClick:Connect(function(Player) 
			if not Player:FindFirstChild('LOAD_SAVE_DATA') then
				return
			end
			if not Player.Character:FindFirstChild('BodyEffects') then
				return
			end
			if not Player.Character.BodyEffects:FindFirstChild('Shop') then
				return
			end
			if Player.Character.BodyEffects.Shop.Value ~= false then
				return
			end
			local Part = u1.Parent
			if Player:DistanceFromCharacter(Part.PrimaryPart.Position) <= u1.MaxActivationDistance then
				if Player.DataFolder.Currency.Value >= Part.Price.Value then
					if not Player.DataFolder.Information:FindFirstChild('FurnitureData') then
						local FurnitureData = Instance.new('StringValue', Player.DataFolder.Information)
						FurnitureData.Name = 'FurnitureData'
						FurnitureData.Value = HttpService:JSONEncode({})
					end
					local Value = Player.DataFolder.Information['FurnitureData']
					local DecodedTable = MainModule.DecodeFurnitureData(Player)
					if not DecodedTable[Part.Name] then
						DecodedTable[Part.Name] = 1
					else 
						DecodedTable[Part.Name] += 1
					end
					Value.Value = HttpService:JSONEncode(DecodedTable)
					ReplicatedStorage.MainRemotes.MainRemoteEvent:FireClient(Player, 'UpdateEdit')
					Player.Character.BodyEffects.Shop.Value = true
					Player.DataFolder.Currency.Value -= Part.Price.Value
					task.wait(.7)
					Player.Character.BodyEffects.Shop.Value = false
				end
			end
		end)
	elseif u2 == 'Food' then
		u1.MouseClick:Connect(function(Player)
			if not Player:FindFirstChild('LOAD_SAVE_DATA') then
				return
			end
			if not Player.Character:FindFirstChild('BodyEffects') then
				return
			end
			if not Player.Character.BodyEffects:FindFirstChild('Shop') then
				return
			end
			if Player.Character.BodyEffects.Shop.Value ~= false then
				return
			end
			local Count = 0
			for i,v in pairs(Player.Backpack:GetChildren()) do
				if v.Name == u3 then
					Count += 1
				end
			end
			for i,v in pairs(Player.Character:GetChildren()) do
				if v.Name == u3 then
					Count += 1
				end
			end
			if Count >= 2 then
				return
			end
			local Part = u1.Parent
			if Player:DistanceFromCharacter(Part.Head.Position) <= u1.MaxActivationDistance then
				if not Player.Backpack:FindFirstChild(u3) then
					if Player.DataFolder.Currency.Value >= Part.Price.Value then
						Player.Character.BodyEffects.Shop.Value = true
						Player.DataFolder.Currency.Value -= Part.Price.Value
						ServerStorage.Storage.Tools.Food[u3]:Clone().Parent = Player.Backpack
						task.wait(.7)
						Player.Character.BodyEffects.Shop.Value = false
					end
				end
			end
		end)
	elseif u2 == 'Mask' then
		u1.MouseClick:Connect(function(Player)
			if not Player:FindFirstChild('LOAD_SAVE_DATA') then
				return
			end
			if not Player.Character:FindFirstChild('BodyEffects') then
				return
			end
			if not Player.Character.BodyEffects:FindFirstChild('Shop') then
				return
			end
			if Player.Character.BodyEffects.Shop.Value ~= false then
				return
			end
			local Part = u1.Parent
			if Player:DistanceFromCharacter(Part.Head.Position) <= u1.MaxActivationDistance then
				if Player.DataFolder.Currency.Value >= Part.Price.Value then
					if (not Player.Backpack:FindFirstChild('Mask') and not Player.Character:FindFirstChild('Mask')) then
						ServerStorage.Storage.Tools.Misc.Mask:Clone().Parent = Player.Backpack
					end
					Player.Character.BodyEffects.Mask.Value = u3
					Player.Character.BodyEffects.Shop.Value = true
					Player.DataFolder.Currency.Value -= Part.Price.Value
					task.wait(.7)
					Player.Character.BodyEffects.Shop.Value = false
				end
			end
		end)
	elseif u2 == 'Phone' then
		u1.MouseClick:Connect(function(Player)
			if not Player:FindFirstChild('LOAD_SAVE_DATA') then
				return
			end
			if not Player.Character:FindFirstChild('BodyEffects') then
				return
			end
			if not Player.Character.BodyEffects:FindFirstChild('Shop') then
				return
			end
			if Player.Character.BodyEffects.Shop.Value ~= false then
				return
			end
			local Part = u1.Parent
			if Player:DistanceFromCharacter(Part.Head.Position) <= u1.MaxActivationDistance then
				if Player.DataFolder.Currency.Value >= Part.Price.Value then
					Player.Character.BodyEffects.Shop.Value = true
					Player.DataFolder.Currency.Value -= Part.Price.Value
					if not Player.DataFolder.Information:FindFirstChild('NewPhone') then
						local NewPhone = Instance.new('StringValue', Player.DataFolder.Information)
						NewPhone.Name = 'NewPhone'
						NewPhone.Value = u3 
					else 
						Player.DataFolder.Information.NewPhone.Value = u3
					end
					task.wait(.7)
					Player.Character.BodyEffects.Shop.Value = false
				end
			end
		end)
	elseif u2 == "Vehicle" then
		u1.MouseClick:Connect(function(Player)
			if not Player:FindFirstChild('LOAD_SAVE_DATA') then
				return
			end
			if not Player.Character:FindFirstChild('BodyEffects') then
				return
			end
			if not Player.Character.BodyEffects:FindFirstChild('Shop') then
				return
			end
			if Player.Character.BodyEffects.Shop.Value ~= false then
				return
			end
			if _G.PlayerData.Players[Player].Debounces.Helper.v7.Vehicles[u3] ~= false then
				return
			end
			local Part = u1.Parent
			if Player:DistanceFromCharacter(Part.Head.Position) <= u1.MaxActivationDistance then
				if Player.DataFolder.Currency.Value >= Part.Price.Value then
					task.spawn(function()
						_G.PlayerData.Players[Player].Debounces.Helper.v7.Vehicles[u3] = true
						task.wait(3)
						_G.PlayerData.Players[Player].Debounces.Helper.v7.Vehicles[u3] = false
					end)
					if not workspace.OldVehicles:FindFirstChild(Player.Name.."BIKE") then
						local Bike = ServerStorage.Storage.ServerSided.Vehicles[u3]:FindFirstChildOfClass("Model"):Clone()
						Bike.Name = Player.Name.."BIKE"
						Bike.Parent = workspace.Vehicles
					end
					Player.Character.BodyEffects.Shop.Value = true
					Player.DataFolder.Currency.Value -= Part.Price.Value
					task.wait(.3)
					Player.Character.BodyEffects.Shop.Value = false
				end
			end
		end)
	elseif u2 == 'Moveset' then
		u1.MouseClick:Connect(function(Player)
			if not Player:FindFirstChild('LOAD_SAVE_DATA') then
				return
			end
			if not Player.Character:FindFirstChild('BodyEffects') then
				return
			end
			if not Player.Character.BodyEffects:FindFirstChild('Shop') then
				return
			end
			if Player.Character.BodyEffects.Shop.Value ~= false then
				return
			end
			local Part = u1.Parent
			if Player:DistanceFromCharacter(Part.Head.Position) <= u1.MaxActivationDistance then
				task.spawn(function()
					Player.Character.BodyEffects.Shop.Value = true
					task.wait(0.4)
					Player.Character.BodyEffects.Shop.Value = false
				end)
				if u3 == 'Default' then
					if not Player.DataFolder.Information:FindFirstChild('FightingStyle') then
						local FightingStyle = Instance.new('StringValue', Player.DataFolder.Information)
						FightingStyle.Name = 'FightingStyle'
						FightingStyle.Value = u3 
					else 
						Player.DataFolder.Information.FightingStyle.Value = u3
					end
				else
					if u3 == 'Boxing' then
						if Player.DataFolder.Information:FindFirstChild('BoxingValue') then
							if Player.DataFolder.Information.BoxingValue.Value == tostring(ReplicatedStorage.MaxBoxing.Value) then
								if not Player.DataFolder.Information:FindFirstChild('FightingStyle') then
									local FightingStyle = Instance.new('StringValue', Player.DataFolder.Information)
									FightingStyle.Name = 'FightingStyle'
									FightingStyle.Value = u3 
								else 
									Player.DataFolder.Information.FightingStyle.Value = u3
								end
							end
						end
					end
				end
			end
		end)
	end
end

return Helper
