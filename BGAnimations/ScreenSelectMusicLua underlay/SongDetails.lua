local t = Def.ActorFrame {
	InitCommand=function(self)
		self:xy(SCREEN_CENTER_X + 3, SCREEN_CENTER_Y - 22)
	end,
	
	OnCommand=function(self)
		self:queuecommand("CurrentSongChanged")
	end,
	
	CurrentSongChangedMessageCommand=function(self)
		local Song = GAMESTATE:GetCurrentSong()
		
		if Song then
			self:GetChild("SongName")
                :settext(Song:GetDisplayMainTitle())
                :stoptweening()
                :cropright(1)
				:sleep(0.125)
                :linear(0.125)
                :cropright(0)
			self:GetChild("SongArtist")
                :settext(Song:GetDisplayArtist())
                :stoptweening()
                :cropright(1)
				:sleep(0.8)
                :linear(0.25)
                :cropright(0)
			self:GetChild("SongBPM")
                :stoptweening()
                :diffusealpha(0)
				:sleep(0.25)
                :diffusealpha(1)

			ChartArray = SongUtil.GetPlayableSteps(Song)
			
			if ChartArray[1] then
				local MildLevel = ChartArray[1]:GetMeter()
				if MildLevel > 8 then MildLevel = 8 end
				self:GetChild("MildStars"):visible(true):setstate(MildLevel - 1)
			else
				self:GetChild("MildStars"):visible(false)
			end
			
			if ChartArray[2] then
				local WildLevel = ChartArray[2]:GetMeter()
				if WildLevel < 5 then WildLevel = 5 end
				if WildLevel > 9 then WildLevel = 9 end
				self:GetChild("WildStars"):visible(true):setstate(WildLevel - 5)
			else
				self:GetChild("WildStars"):visible(false)
			end
		else
			self:GetChild("SongName"):settext("")
			self:GetChild("SongArtist"):settext("")
			self:GetChild("SongBPM"):settext("")
			self:GetChild("MildStars"):visible(false)
			self:GetChild("WildStars"):visible(false)
		end
	end,
	
	Def.Sprite {
        Texture=THEME:GetPathG("", "SelectMusic/SongInfoBar.png"),
		InitCommand=function(self)
			self:diffusealpha(0.75)
		end,
		CurrentSongChangedMessageCommand=function(self)
			self:stoptweening():diffusealpha(0):linear(0.125):diffusealpha(0.75)
		end,
    },
	
	Def.BitmapText {
		Name="SongName",
		Font="_Impact Bold Normal",
		Text="",
		InitCommand=function(self) 
            self:xy(-29, -40)
			:halign(0)
			:maxwidth(340)
			:SetTextureFiltering(false)
			:diffuse(color("#00ff84"))
        end,
	},
    
    Def.BitmapText {
		Name="SongArtist",
		Font="_Courier",
		Text="",
		InitCommand=function(self) 
            self:xy(-29, -14)
			:halign(0)
			:maxwidth(340)
			:SetTextureFiltering(false)
			:diffuse(color("#00ff84"))
        end,
	},
    
    Def.BitmapText {
		Name="SongBPM",
		Font="_Impact Bold Normal",
		InitCommand=function(self) 
            self:xy(285, 33)
			:diffuse(color("#00ff84"))
        end,
		CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				if song:IsDisplayBpmRandom() then
					self:settext("???")
				else
					self:settext(math.ceil(song:GetDisplayBpms()[2]))
				end;
			else
				self:settext("???");
			end;
		end,
	},
	
	Def.Sprite {
		Name="MildStars",
		Texture=THEME:GetPathG("", "SelectMusic/MildStars 1x8 (doubleres).png"),
		InitCommand=function(self)
			self:xy(43, 33)
			:animate(false)
		end,
		CurrentSongChangedMessageCommand=function(self)
			self:finishtweening():SetTextureFiltering(false):diffusealpha(0):sleep(0.125):diffusealpha(1):decelerate(0.05):zoomx(1.1):zoomy(2):decelerate(0.05):zoomx(1):zoomy(1)
		end,
	},
	
	Def.Sprite {
		Name="WildStars",
		Texture=THEME:GetPathG("", "SelectMusic/WildStars 1x5 (doubleres).png"),
		InitCommand=function(self)
			self:xy(181, 19)
			:animate(false)
		end,
		CurrentSongChangedMessageCommand=function(self)
			self:finishtweening():SetTextureFiltering(false):diffusealpha(0):sleep(0.125):diffusealpha(1):decelerate(0.05):zoomx(1.1):zoomy(2):decelerate(0.05):zoomx(1):zoomy(1)
		end,
	},
}

return t
