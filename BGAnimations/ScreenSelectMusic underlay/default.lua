local StageAmount = PREFSMAN:GetPreference("SongsPerPlay")

local t = Def.ActorFrame {
	CurrentSongChangedMessageCommand=function(self)
		local Song = GAMESTATE:GetCurrentSong()
		
		if Song then
			self:GetChild("SongName"):settext(Song:GetDisplayMainTitle())
			self:GetChild("SongArtist"):settext(Song:GetDisplayArtist())
			self:GetChild("SongBPM"):settext(math.ceil(Song:GetDisplayBpms()[2]))
		else
			self:GetChild("SongName"):settext("")
			self:GetChild("SongArtist"):settext("")
			self:GetChild("SongBPM"):settext("")
		end
	end,
	
    Def.Sprite {
        Texture=THEME:GetPathG("", "SelectMusic/BackgroundEmpty.png"),
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X + 2, SCREEN_CENTER_Y - 10)
        end,
    },
	
	
	Def.Sprite {
        Texture=THEME:GetPathG("", "SelectMusic/SongSelect1.png"),
        InitCommand=function(self)
            self:Center()
			:diffusealpha(1)
        end,
    },
	
	
	Def.Sprite {
		Texture=THEME:GetPathG("", "SelectMusic/StageFrame (doubleres).png"),
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X + 492 - (StageAmount * 71), SCREEN_CENTER_Y - 200)
			:cropright((5 - StageAmount) * 0.2 - 0.001) -- Magic sauce
		end,
	},
	
	Def.Sprite {
        Texture=THEME:GetPathG("", "SelectMusic/SongInfoBar.png"),
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X + 2, SCREEN_CENTER_Y - 22)
			:diffusealpha(0.5)
        end,
    },
	
	Def.Sprite {
		Name="MenuButtonsP1",
        Texture=THEME:GetPathG("", "MenuButtons 1x5 (doubleres).png"),
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X - 193, SCREEN_CENTER_Y + 205)
			:animate(false)
        end,
    },
	
	Def.Sprite {
		Name="MenuButtonsP2",
        Texture=THEME:GetPathG("", "MenuButtons 1x5 (doubleres).png"),
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X + 199, SCREEN_CENTER_Y + 205)
			:animate(false)
        end,
    },
	
	Def.Sprite {
        Texture=THEME:GetPathG("", "TimerLabel (doubleres).png"),
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X - 274, SCREEN_CENTER_Y - 219)
			:animate(false)
        end,
    },
	
	Def.BitmapText {
		Name="SongName",
		Font="_Impact Bold Normal",
		Text="",
		InitCommand=function(self) 
            self:xy(SCREEN_CENTER_X - 27, SCREEN_CENTER_Y - 59)
			:halign(0)
        end,
	},
    
    Def.BitmapText {
		Name="SongArtist",
		Font="_Courier",
		Text="",
		InitCommand=function(self) 
            self:xy(SCREEN_CENTER_X - 27, SCREEN_CENTER_Y - 36)
			:halign(0)
        end,
	},
    
    Def.BitmapText {
		Name="SongBPM",
		Font="_Impact Bold Normal",
		Text="",
		InitCommand=function(self) 
            self:xy(SCREEN_CENTER_X + 288, SCREEN_CENTER_Y + 11)
        end,
	},
}

return t
