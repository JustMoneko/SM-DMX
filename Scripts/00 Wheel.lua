local BannerPositions = {
	{x = 0, y = 0, z = 0, rotx = 0, roty = 0, rotz = 0},
	{x = 67, y = 100, z = -20, rotx = 15, roty = -5, rotz = 0},
	{x = 130, y = 200, z = -80, rotx = 30, roty = -10, rotz = 15},
}

function WheelTransform (self, OffsetFromCenter, ItemIndex, NumItems) 
    local Spacing = math.abs(math.sin(OffsetFromCenter / math.pi))
	local OffsetParabola = math.sqrt(math.abs(OffsetFromCenter))
	
	if BannerPositions[ItemIndex] == nil then 
		self:diffusealpha(0)
		return 
	end
	
    self:x(BannerPositions[ItemIndex].x)
	:y(BannerPositions[ItemIndex].y)
	:z(BannerPositions[ItemIndex].z)
	:rotationx(BannerPositions[ItemIndex].rotx)
	:rotationy(BannerPositions[ItemIndex].roty)
	:rotationz(BannerPositions[ItemIndex].rotz)
	
	self:diffusealpha(0.5)
end

--[[
	self:x(OffsetFromCenter * (250 - Spacing * 100))
    self:rotationy(clamp(OffsetFromCenter * 36, -85, 85))
    self:z(-math.abs(OffsetFromCenter))
    self:zoom(1)
]]