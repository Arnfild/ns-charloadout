local PANEL = {}

local PLUGIN = PLUGIN

function PANEL:Init()
	self.title = self:addLabel(L("charLoadout_title"))

	self.total = nut.config.get("loadoutPoints")
	self.traits = {}

	self.charLoadout = {}
	self.available_points = self.total

	self:RemoveScrollBar()
end

function DScrollPanel:RemoveScrollBar()
	self:GetVBar():SetWide(0) -- If we don't do that, then it will still technically affect the render which will interfere with SetPos or Dock
end

function PANEL:onDisplay()
	-- We don't want this step to show up for factions that have no loadout
	if !PLUGIN.charLoadout[self:GetFaction()] then self:next() return end
    self:GetParent():GetParent():InvalidateParent(true)
    self:GetParent():InvalidateParent(true)
    
    -- DScrollPanel:Dock(FILL)
    self:Dock(FILL)
    self:InvalidateParent(true);
    -- Canvas:Dock(FILL); -no scroll anymore
    self:GetCanvas():Dock(FILL);
	self:GetCanvas():InvalidateParent(true)
	
    self.loadout = self:Add("nutLoadout")
    self.loadout:Dock(FILL)
    self.loadout:SetWide(self:GetWide());

end

function PANEL:GetFaction()
	return self:getContext("faction")
end

function PANEL:validate()
	-- Making sure it's not nil
	if !PLUGIN.charLoadout[self:GetFaction()] then 
		self:setContext("charLoadout", {}) 
		return 
	end

	self.charLoadout = self.loadout:ParseLoadoutTable()
	self:setContext("charLoadout", self.charLoadout)
end

function PANEL:onSkip()
	self:setContext("charLoadout", {})
end

vgui.Register("ns_charLoadout", PANEL, "nutCharacterCreateStep")