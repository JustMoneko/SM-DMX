local t = Def.ActorFrame {
    Def.Sprite {
        Texture=THEME:GetPathG("", "Gameplay/TopFrameUnder.png"),
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, 0):valign(0)
        end,
    },
    
    Def.Sprite {
        Texture=THEME:GetPathG("", "Gameplay/TopFrame.png"),
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, 0):valign(0)
        end,
    },
    
    Def.Sprite {
        Texture=THEME:GetPathG("", "Gameplay/BottomFrame.png"),
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_HEIGHT):valign(1)
        end,
    },
}

t[#t+1] = Def.ActorFrame {
	Def.BitmapText {
		Font="_Score",
		Text="12345678",
		InitCommand=function(self) self:xy(SCREEN_CENTER_X - 288, SCREEN_HEIGHT - 32):halign(0) end,
	},
	
	Def.BitmapText {
		Font="_Low Res",
		Text="THIS IS A TEST - CREDIT(0)",
		InitCommand=function(self) self:Center() end,
	}
}

t[#t+1] = Def.ActorFrame {
    Def.Sprite {
        Texture=THEME:GetPathG("", "Gameplay/TopFrameHalo"),
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, 0):valign(0)
            :animate(false):setstate(0)
            :diffuseblink()
            :effectcolor1(Color.Invisible)
            :effectcolor2(Color.White)
            :effectclock("beat")
        end,
    },
    
    Def.Sprite {
        Texture=THEME:GetPathG("", "Gameplay/BottomFrameHalo"),
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_HEIGHT):valign(1)
            :animate(false):setstate(0)
            :diffuseblink()
            :effectcolor1(Color.Invisible)
            :effectcolor2(Color.White)
            :effectclock("beat")
        end,
    },
}

return t
