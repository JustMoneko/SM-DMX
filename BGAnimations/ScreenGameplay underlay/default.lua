local t = Def.ActorFrame {
    Def.Sprite {
        Texture=THEME:GetPathG("", "Gameplay/TopFrameShadow.png"),
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, 0):valign(0)
        end,
    },
    
    Def.Sprite {
        Texture=THEME:GetPathG("", "Gameplay/BottomFrameShadow.png"),
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_HEIGHT):valign(1)
        end,
    },
}

return t
