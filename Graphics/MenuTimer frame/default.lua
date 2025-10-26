local t=Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
	LoadActor("TimerLabel (doubleres)") .. {
		OnCommand=function(self)
			self:SetTextureFiltering(false):addy(-38);
		end,
	};
};


return t;
