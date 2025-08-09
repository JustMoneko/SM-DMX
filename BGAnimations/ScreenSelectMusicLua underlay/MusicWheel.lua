local WheelSize = 5
local WheelCenter = 3
local WheelItem = { Width = 95, Height = 71 }
local WheelItemPos = {
	{x = -78, y = -190, z = -80, rotx = -45, roty = 20, rotz = 30},
	{x = -48, y = -100, z = -20, rotx = -20, roty = 10, rotz = 6},
	{x = 0, y = 0, z = 0, rotx = 0, roty = 0, rotz = 0},
	{x = 67, y = 100, z = -20, rotx = 15, roty = -5, rotz = 0},
	{x = 130, y = 200, z = -80, rotx = 30, roty = -10, rotz = 15},
}

local Songs = {}
local Targets = {}

local SongIndex = LastSongIndex > 0 and LastSongIndex or 1
local GroupMainIndex = LastGroupMainIndex > 0 and LastGroupMainIndex or 1
local GroupSubIndex = LastGroupSubIndex > 0 and LastGroupSubIndex or 1

local IsBusy = false

function PlayableSongs(SongList)
	local SongTable = {}
	for Song in ivalues(SongList) do
        local Steps = SongUtil.GetPlayableSteps(Song)
		if #Steps > 0 then
			SongTable[#SongTable+1] = Song
		end
	end
	return SongTable
end

Songs = PlayableSongs(SONGMAN:GetAllSongs())

-- Update Songs item targets
local function UpdateItemTargets(val)
    for i = 1, WheelSize do
        Targets[i] = val + i - WheelCenter
        -- Wrap to fit to Songs list size
        while Targets[i] > #Songs do Targets[i] = Targets[i] - #Songs end
        while Targets[i] < 1 do Targets[i] = Targets[i] + #Songs end
    end
end

local function InputHandler(event)
	local pn = event.PlayerNumber
    if not pn then return end
    
    -- Don't want to move when releasing the button
    if event.type == "InputEventType_Release" then return end

    local button = event.GameButton
    
    -- If an unjoined player attempts to join and has enough credits, join them
    if (button == "Start" or button == "MenuStart" or button == "Center") and 
        not GAMESTATE:IsSideJoined(pn) and GAMESTATE:GetCoins() >= GAMESTATE:GetCoinsNeededToJoin() then
        GAMESTATE:JoinPlayer(pn)
        -- The command above does not deduct credits so we'll do it ourselves
        GAMESTATE:InsertCoin(-(GAMESTATE:GetCoinsNeededToJoin()))
        MESSAGEMAN:Broadcast("PlayerJoined", { Player = pn })
    else
		-- To avoid control from a player that has not joined, filter the inputs out
		if pn == PLAYER_1 and not GAMESTATE:IsPlayerEnabled(PLAYER_1) then return end
		if pn == PLAYER_2 and not GAMESTATE:IsPlayerEnabled(PLAYER_2) then return end

		if not IsBusy then
			if button == "Left" or button == "MenuLeft" or button == "DownLeft" then
				SongIndex = SongIndex - 1
				if SongIndex < 1 then SongIndex = #Songs end
				
				GAMESTATE:SetCurrentSong(Songs[SongIndex])
				UpdateItemTargets(SongIndex)
				MESSAGEMAN:Broadcast("Scroll", { Direction = -1 })

			elseif button == "Right" or button == "MenuRight" or button == "DownRight" then
				SongIndex = SongIndex + 1
				if SongIndex > #Songs then SongIndex = 1 end
				
				GAMESTATE:SetCurrentSong(Songs[SongIndex])
				UpdateItemTargets(SongIndex)
				MESSAGEMAN:Broadcast("Scroll", { Direction = 1 })
				
			elseif button == "Start" or button == "MenuStart" or button == "Center" then
				-- Save this for later
				LastSongIndex = SongIndex
				
				MESSAGEMAN:Broadcast("MusicWheelStart")

			elseif button == "Back" then
				SCREENMAN:GetTopScreen():Cancel()
			end
		end

		MESSAGEMAN:Broadcast("UpdateMusic")
	end
end

-- Manages banner on sprite
local function UpdateBanner(self, Song)
    self:LoadFromSongBanner(Song):scaletoclipped(WheelItem.Width, WheelItem.Height)
end

local t = Def.ActorFrame {
    InitCommand=function(self)
        self:xy(SCREEN_CENTER_X - 117, SCREEN_CENTER_Y - 34)
		:fov(90):SetDrawByZPosition(true)
        :vanishpoint(SCREEN_CENTER_X - 117, SCREEN_CENTER_Y - 34)
        UpdateItemTargets(SongIndex)
    end,

    OnCommand=function(self)
        GAMESTATE:SetCurrentSong(Songs[SongIndex])
        SCREENMAN:GetTopScreen():AddInputCallback(InputHandler)
    end,
	
	OffCommand=function(self)
		
	end,
    
    -- Race condition workaround (yuck)
    MusicWheelStartMessageCommand=function(self) self:sleep(0.01):queuecommand("Confirm") end,
    ConfirmCommand=function(self) MESSAGEMAN:Broadcast("SongChosen") end,

    -- These are to control the functionality of the music wheel
    SongChosenMessageCommand=function(self)
        self:stoptweening():playcommand("Busy")
    end,
    SongUnchosenMessageCommand=function(self)
        self:stoptweening():playcommand("NotBusy")
    end,
    
    BusyCommand=function(self) IsBusy = true end,
    NotBusyCommand=function(self) IsBusy = false end,
    
    -- Play song preview (thanks Luizsan)
    Def.Actor {
        CurrentSongChangedMessageCommand=function(self)
            SOUND:StopMusic()
            self:stoptweening():sleep(0.25):queuecommand("PlayMusic")
        end,
        
        PlayMusicCommand=function(self)
            local Song = GAMESTATE:GetCurrentSong()
            if Song then
                SOUND:PlayMusicPart(Song:GetMusicPath(), Song:GetSampleStart(), 
                Song:GetSampleLength(), 0, 1, true, false, false, Song:GetTimingData())
            end
        end
    },

    Def.Sound {
        File=THEME:GetPathS("MusicWheel", "change"),
        IsAction=true,
        ScrollMessageCommand=function(self) self:play() end
    },

    Def.Sound {
        File=THEME:GetPathS("Common", "Start"),
        IsAction=true,
        MusicWheelStartMessageCommand=function(self) self:play() end
    },
}

-- The Wheel: originally made by Luizsan
for i = 1, WheelSize do

    t[#t+1] = Def.ActorFrame{
        OnCommand=function(self)
            -- Load banner
            UpdateBanner(self:GetChild("Banner"), Songs[Targets[i]])

            -- Set initial position, Direction = 0 means it won't tween
            self:playcommand("Scroll", {Direction = 0})
        end,
		
		ForceUpdateMessageCommand=function(self)
			-- Load banner
            UpdateBanner(self:GetChild("Banner"), Songs[Targets[i]])
            
            --SCREENMAN:SystemMessage(GroupsList[GroupIndex].Name)

            -- Set initial position, Direction = 0 means it won't tween
            self:playcommand("Scroll", {Direction = 0})
		end,

        ScrollMessageCommand=function(self,param)
            self:stoptweening()

            -- Only tween if a direction was specified
            local tween = param and param.Direction and math.abs(param.Direction) > 0
            
            -- Adjust and wrap actor index
            i = i - param.Direction
            while i > WheelSize do i = i - WheelSize end
            while i < 1 do i = i + WheelSize end

            -- If it's an edge item, load a new banner. Edge items should never tween
            if i == 1 or i == WheelSize then
				UpdateBanner(self:GetChild("Banner"), Songs[Targets[i]])
            elseif tween then
                self:linear(0.25)
            end

            -- Animate!
			self:x(WheelItemPos[i].x)
			:y(WheelItemPos[i].y)
			:z(WheelItemPos[i].z)
			:rotationx(WheelItemPos[i].rotx)
			:rotationy(WheelItemPos[i].roty)
			:rotationz(WheelItemPos[i].rotz)
            self:GetChild("Index"):playcommand("Refresh")
        end,

        Def.Banner {
            Name="Banner",
			InitCommand=function(self)
				self:shadowlengthx(13)
				:shadowlengthy(9)
				:shadowcolor(color("#00000077"))
				--self:diffusealpha(0.5)
			end,
        },

        Def.BitmapText {
			Name="Index",
			Font="Common normal",
			RefreshCommand=function(self,param) self:settext(Targets[i]) end
		}
    }
end

return t
