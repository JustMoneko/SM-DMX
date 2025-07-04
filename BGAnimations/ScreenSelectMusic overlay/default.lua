local t = Def.ActorFrame {
    Def.Sprite {
        Texture=THEME:GetPathG("", "SelectMusic/Background.png"),
        InitCommand=function(self)
            self:Center()
        end,
    },
}

t[#t+1] = Def.ActorFrame {
	Def.BitmapText {
		Font="_Impact Bold Normal",
		Text="the quick brown fox jumps over the lazy dog",
		InitCommand=function(self) 
            self:xy(16, 16):align(0, 0)
        end,
	},
    
    Def.BitmapText {
		Font="_Impact Bold Normal",
		Text="THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG",
		InitCommand=function(self) 
            self:xy(16, 48):align(0, 0)
        end,
	},
    
    Def.BitmapText {
		Font="_Impact Bold Normal",
		Text="0123456789 !#$%^&(){}[]-+=_",
		InitCommand=function(self) 
            self:xy(16, 80):align(0, 0)
        end,
	},
}

return t
