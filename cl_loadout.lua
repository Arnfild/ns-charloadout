local PANEL = {}

local PLUGIN = PLUGIN

function PANEL:Init()
	if (IsValid(nut.gui.loadout)) then
		nut.gui.loadout.noSendExit = true
		nut.gui.loadout:Remove()
	end
	nut.gui.loadout = self

	self:GetParent():InvalidateParent()

	self.faction = self:GetParent():GetParent():GetFaction() or 0

	self.loadout = self:Add("nutLoadoutPanel")
	self.loadout:SetWide(self:GetParent():GetWide()/2)
	self.loadout:SetTall(ScrH() - self.loadout.y)
	self.loadout:setName(L("charLoadout_loadout"))
	self.loadout:setPoints(nut.config.get("loadoutPoints"))

	self.equipment = self:Add("nutLoadoutPanel")
	self.equipment:SetSize(self.loadout:GetSize())
	self.equipment:SetPos(self.loadout:GetWide(), self.loadout.y)
	self.equipment:setName(L("charLoadout_equipment"))

	self.items = {
		[self.loadout] = {},
		[self.equipment] = {}
	}

	self:initializeItems()
end

function PANEL:buyItem(itemType)
	if !self.items[self.equipment][itemType] then return end
	if !(self.loadout.points >= self.items[self.equipment][itemType].price) then return end

	self.items[self.equipment][itemType]:setQuantity(self.items[self.equipment][itemType].quantity - 1)

	local newQuantity = 1
	if self.items[self.loadout][itemType] and self.items[self.loadout][itemType].quantity then
		newQuantity = self.items[self.loadout][itemType].quantity + 1
	end
	self.loadout:setPoints(self.loadout.points - self.items[self.equipment][itemType].price)
	self:updateItem(itemType, self.loadout, self.items[self.equipment][itemType].price, newQuantity)
end

function PANEL:sellItem(itemType)
	if !self.items[self.loadout][itemType] then return end
	self.items[self.loadout][itemType]:setQuantity(self.items[self.loadout][itemType].quantity - 1)

	local newQuantity = 1
	if self.items[self.equipment][itemType] and self.items[self.equipment][itemType].quantity then
		newQuantity = self.items[self.equipment][itemType].quantity + 1
	end
	self.loadout:setPoints(self.loadout.points + self.items[self.loadout][itemType].price)
	self:updateItem(itemType, self.equipment, self.items[self.loadout][itemType].price, newQuantity)
end

function PANEL:initializeItems()
	for k, v in pairs( PLUGIN.charLoadout[self.faction] ) do
		self:updateItem(k, self.equipment, v.price, v.quantity)
	end
end

function PANEL:updateItem(itemType, parent, price, quantity)
	assert(isstring(itemType), "itemType must be a string")

	if (not self.items[parent]) then return end
	local panel = self.items[parent][itemType]
	
	if (not IsValid(panel)) then
		panel = parent.items:Add("nutLoadoutItem")
		panel:setItemType(itemType)
		panel:setIsSelling(parent == self.loadout, price)
		self.items[parent][itemType] = panel
	end


	if (not isnumber(quantity)) then
		quantity = 1
	end

	panel:setQuantity(quantity)

	return panel
end

function PANEL:ParseLoadoutTable()
	local parseTable = {}
	for k, v in pairs( self.items[self.loadout] ) do
		parseTable[k] = v.quantity
	end
	
	return parseTable
end

function PANEL:OnRemove()
end

vgui.Register("nutLoadout", PANEL, "EditablePanel")

if (IsValid(nut.gui.loadout)) then
	vgui.Create("nutLoadout")
end
