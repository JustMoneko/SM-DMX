local StageAmount = PREFSMAN:GetPreference("SongsPerPlay")

local t = Def.ActorFrame {
	-- Add timer functionality
	InitCommand=function(self)
		self:sleep(0.5):queuecommand("CheckTimer")
	end,
	
	CheckTimerCommand=function(self)
		if SCREENMAN:GetTopScreen():GetChild("Timer"):GetSeconds() <= 0 then
			self:queuecommand("TimerExpired")
		else
			self:sleep(0.5):queuecommand("CheckTimer")
		end
	end,
	
	TimerExpiredCommand=function(self)
		-- Set these or else we crash.
        GAMESTATE:SetCurrentPlayMode("PlayMode_Regular")
        GAMESTATE:SetCurrentStyle(GAMESTATE:GetNumSidesJoined() > 1 and "versus" or string.lower(ShortType(GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()))))
        SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
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
            self:Center():diffusealpha(0)
        end,
    },
	
	Def.Sprite {
		Texture=THEME:GetPathG("", "SelectMusic/StageFrame (doubleres).png"),
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X + 492 - (StageAmount * 71), SCREEN_CENTER_Y - 200)
			:cropright((5 - StageAmount) * 0.2 - 0.001) -- Magic sauce
		end,
	},
	
	LoadActor("SongDetails"),
	
	LoadActor("MusicWheel"),
	
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
}

return t
