PLUGIN.name = "Character Loadout System"
PLUGIN.author = "Sample Name"
PLUGIN.desc = "Adds new character creation step that allows to configure the loadout."

local PLUGIN = PLUGIN
PLUGIN.charLoadout = PLUGIN.charLoadout or {}

nut.util.include("cl_loadout.lua")
nut.util.include("cl_loadout_panel.lua")
nut.util.include("cl_loadout_item.lua")
nut.util.include("cl_loadout_step.lua")

nut.config.add("loadoutPoints", 30, "The number of loadout points players have when creating a chracter.", nil, {
	data = {min = 1, max = 100},
	category = "charLoadout"
})

nut.char.registerVar("charLoadout", {
	default = {},
	isLocal = true,
	onValidate = function(value, data, client)
		if (value != nil) then
			if (type(value) == "table") then
				local pointsUsed = 0
				local pointsAvailable = nut.config.get("loadoutPoints")
				local forbiddenItem = false

				for k, v in pairs(value) do
					if !PLUGIN.charLoadout[data.faction][k] then
						forbiddenItem = true
					else
						pointsUsed = (pointsUsed + PLUGIN.charLoadout[data.faction][k].price * v)
					end
				end

				if (pointsUsed > pointsAvailable) or forbiddenItem then
					return false, "unknownError"
				end
			else
				return false, "unknownError"
			end
		end
	end
})

function PLUGIN:OnCharCreated(client, character, data)
	local loadoutData = data.charLoadout
	if table.IsEmpty(loadoutData) then return end

	for k, v in pairs(loadoutData) do
		for i = 1, v do
			character:getInv():add(k)
		end
	end
end

function PLUGIN:ConfigureCharacterCreationSteps(panel)
	-- Most likely we want it to be the last step, so... shush
	panel:addStep(vgui.Create("ns_charLoadout"), 99)
end

--[[
	faction = faction's enum, get it from your faction's file. Example: sh_citizen.lua from HL2RP. FACTION_CITIZEN = FACTION.index, where FACTION_CITIZEN is a enum
	id - proper item's id, get it from item's file name. Example: sh_bleach from HL2RP. bleach is an id
	price - number of points taken when adding this item to loadout
	quantity - how many of these items will player be able to take

	Use PLUGIN:RegisterLoadoutItem in PLUGIN:InitializedPlugins() below!

	All the data must correposnd the header explained above, otherwise you'll get nil index error
--]]
function PLUGIN:RegisterLoadoutItem(faction, id, price, quantity)
	PLUGIN.charLoadout[faction] = PLUGIN.charLoadout[faction] or {}
	PLUGIN.charLoadout[faction][id] = { 
		['price'] = price, 
		['quantity'] = quantity
	}
end

function PLUGIN:InitializedPlugins()
	--[[ Sample implementation for HL2RP schema
	self:RegisterLoadoutItem(FACTION_CP, "pistol", 10, 1)
	self:RegisterLoadoutItem(FACTION_CP, "smg", 20, 1)
	self:RegisterLoadoutItem(FACTION_CP, "health_vial", 5, 3)
	self:RegisterLoadoutItem(FACTION_CP, "health_kit", 10, 1)
	self:RegisterLoadoutItem(FACTION_CP, "flashlight", 0, 1)
	--]]
end