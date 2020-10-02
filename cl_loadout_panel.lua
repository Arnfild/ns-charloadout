local PANEL = {}

local PLUGIN = PLUGIN

function PANEL:Init()
	self.name = self:Add("DLabel")
	self.name:Dock(TOP)
	self.name:SetTall(48)
	self.name:SetContentAlignment(7)
	self.name:SetFont("nutVendorButtonFont")
	self.name:SetTextColor(color_white)
	self.name:SetTextInset(8, 4)
	self.name.Paint = function(name, w, h)
		surface.SetDrawColor(0, 0, 0, 100)
		surface.DrawRect(0, 0, w, h)
	end

	self.points = 100
	self.pointsLabel = self:Add("DLabel")
	self.pointsLabel:SetText("")
	self.pointsLabel:Dock(TOP)
	self.pointsLabel:SetFont("nutVendorSmallFont")
	self.pointsLabel:SetContentAlignment(7)
	self.pointsLabel:SetTall(28)
	self.pointsLabel:SetTextInset(10, 0)
	self.pointsLabel:SetTextColor(Color(255, 255, 255, 200))
	self.pointsLabel.Paint = self.name.Paint

	self.items = self:Add("DScrollPanel")
	self.items:Dock(FILL)
end

function PANEL:setName(name)
	self.name:SetText(name)
end

function PANEL:setPoints(points)
	self.points = points

	self.pointsLabel:SetText(L("charLoadout_pointsAvailable") .. self.points)
end


function PANEL:Paint(w, h)
	surface.SetDrawColor(0, 0, 0, 0)
	surface.DrawRect(0, 0, w, h)
end

vgui.Register("nutLoadoutPanel", PANEL, "DPanel")
