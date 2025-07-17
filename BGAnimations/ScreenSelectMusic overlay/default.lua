local StageAmount = PREFSMAN:GetPreference("SongsPerPlay")

local t = Def.ActorFrame {
    Def.Sprite {
        Texture=THEME:GetPathG("", "SelectMusic/Background.png"),
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X + 2, SCREEN_CENTER_Y - 10)
        end,
    },
	
	Def.Sprite {
        Texture=THEME:GetPathG("", "SelectMusic/SongSelect1.png"),
        InitCommand=function(self)
            self:Center()
			:diffusealpha(0.5)
        end,
    },
	
	Def.Sprite {
        Texture=THEME:GetPathG("", "MenuButtons 1x5 (doubleres).png"),
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X - 193, SCREEN_CENTER_Y + 205)
			:animate(false)
        end,
    },
	
	Def.Sprite {
        Texture=THEME:GetPathG("", "MenuButtons 1x5 (doubleres).png"),
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X + 199, SCREEN_CENTER_Y + 205)
			:animate(false)
        end,
    },
	
	Def.Sprite {
		Texture=THEME:GetPathG("", "SelectMusic/StageFrame (doubleres).png"),
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X + 492 - (StageAmount * 71), SCREEN_CENTER_Y - 200)
			:cropright((5 - StageAmount) * 0.2 - 0.001) -- Magic sauce
		end,
	}
}

t[#t+1] = Def.ActorFrame {
	Def.BitmapText {
		Font="_Impact Bold Normal",
		Text="WHATEVER",
		InitCommand=function(self) 
            self:xy(SCREEN_CENTER_X - 27, SCREEN_CENTER_Y - 60)
			:halign(0)
        end,
	},
    
    Def.BitmapText {
		Font="_Courier",
		Text="CAPTAIN JACK",
		InitCommand=function(self) 
            self:xy(SCREEN_CENTER_X - 27, SCREEN_CENTER_Y - 36)
			:halign(0)
        end,
	},
    
    Def.BitmapText {
		Font="_Impact Bold Normal",
		Text="142",
		InitCommand=function(self) 
            self:xy(SCREEN_CENTER_X + 288, SCREEN_CENTER_Y + 11)
        end,
	},
}

return t
