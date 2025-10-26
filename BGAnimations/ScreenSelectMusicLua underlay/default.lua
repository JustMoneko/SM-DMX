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
		GAMESTATE:SetCurrentStyle(GAMESTATE:GetNumSidesJoined() > 1 and "versus" or "single")
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
	
	LoadActor("SelectDiff") .. {
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y + 122)
		end
	},
	
	Def.Sprite {
		Name="MenuButtonsP1",
        Condition=GAMESTATE:IsPlayerEnabled(PLAYER_1);
        Texture=THEME:GetPathG("", "MenuButtons 1x5 (doubleres).png"),
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X - 193, SCREEN_CENTER_Y + 205)
			:animate(false)
        end,
    },
	
	Def.Sprite {
		Name="MenuButtonsP2",
        Condition=GAMESTATE:IsPlayerEnabled(PLAYER_2);
        Texture=THEME:GetPathG("", "MenuButtons 1x5 (doubleres).png"),
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X + 199, SCREEN_CENTER_Y + 205)
			:animate(false)
        end,
    },
	Def.Sprite {
        Texture=THEME:GetPathG("", "SelectMusic/SongInfoBar.png"),
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X + 3, SCREEN_CENTER_Y - 22)
			self:cropright(0.76):faderight(0.05):diffusealpha(0.75)
		end,
		CurrentSongChangedMessageCommand=function(self)
			self:stoptweening():diffusealpha(0):linear(0.125):diffusealpha(0.75)
		end,
    },
	Def.Sprite {
        Texture=THEME:GetPathG("", "SelectMusic/HighlightedSongFrame 4x4 (doubleres).png"),
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X - 117, SCREEN_CENTER_Y - 33)
			self:SetTextureFiltering(false):diffusealpha(0):animate(false):SetAllStateDelays(0)
		end,
		CurrentSongChangedMessageCommand=function(self)
			self:stoptweening():diffusealpha(0):setstate(0):animate(false):sleep(1):diffusealpha(1):animate(true):SetAllStateDelays(0.055):sleep(0.75):queuecommand("Stop")
		end,
		StopCommand=function(self)
			self:setstate(15):animate(false):diffusealpha(0)
		end,
    },
	Def.Sprite {
        Texture=THEME:GetPathG("", "SelectMusic/cursor 2x1 (doubleres).png"),
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X - 117, SCREEN_CENTER_Y - 33)
			self:SetTextureFiltering(false):diffusealpha(0):animate(false)
		end,
		CurrentSongChangedMessageCommand=function(self)
			self:stoptweening():diffusealpha(0):sleep(1.625):diffusealpha(1):sleep(0.1):diffusealpha(0)
		end,
    },
	Def.Sprite {
        Texture=THEME:GetPathG("", "SelectMusic/cursor 2x1 (doubleres).png"),
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X - 117, SCREEN_CENTER_Y - 33)
			self:SetTextureFiltering(false):diffusealpha(0):animate(true):SetAllStateDelays(0.15)
		end,
		CurrentSongChangedMessageCommand=function(self)
			self:stoptweening():diffusealpha(0):sleep(1.65):diffusealpha(1)
		end,
    },
}

t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(Center;addx,-240;addy,-33);
		Def.Sprite {
		CurrentSongChangedMessageCommand=function(self)
			SongOrCourse = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse() or GAMESTATE:GetCurrentSong()
			if SongOrCourse and SongOrCourse:HasCDTitle() then
				self:visible(true)
				self:Load( GAMESTATE:GetCurrentSong():GetCDTitlePath() )
			else
				self:visible(true)
				self:Load( THEME:GetPathG("","new.png") )
			end
				self:finishtweening():SetTextureFiltering(false):diffusealpha(0):sleep(0.25):diffusealpha(1):decelerate(0.05):scaletofit(-60, -60, 60, 60):decelerate(0.05):scaletofit(-40, -40, 40, 40)
		end
	},
};
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(Center;addx,148;addy,-92);
	Def.Sprite {
		Name="HeaderText",
		Texture=THEME:GetPathG("", "SelectMusic/music_header.png"),
		OnCommand=function(self)
			self:SetTextureFiltering(false)
		end,
	},
};
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(Center;y,SCREEN_BOTTOM-11;zoom,0.6);
	Def.BitmapText {
		Name="WIP",
		Text="THIS IS A WORK IN PROGRESS!",
		OnCommand=function(self)
			self:SetTextureFiltering(false)
		end,
	},
	
};

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(Center;addy,-100);
	--SONG COUNTER
		LoadFont("Common normal")..{
			InitCommand=cmd(horizalign,left);
			CurrentSongChangedMessageCommand=function(self,params)
				local song = GAMESTATE:GetCurrentSong();
				if song then
					self:stoptweening();
					--It's probably not very efficient
					local num = 0
					local total = 0
					if isWheelCustom == true then
						--assert(params.index, "CurSongChanged is missing custom params!");
						num = scroller:get_index()
						total = 999
					else
						num = SCREENMAN:GetTopScreen():GetChild('MusicWheel'):GetCurrentIndex()+1;
						total = SCREENMAN:GetTopScreen():GetChild('MusicWheel'):GetNumItems();
					end
					self:settext( string.format("%.3i", num).."/"..string.format("%.3i", total) );
				end;
			end;
		};
};

return t
