return Def.ActorFrame{
    Def.Banner {
        SetMessageCommand=function(self, params)
            if params.Song then
                self:LoadFromSongBanner(params.Song):scaletoclipped(95, 71)
            end
        end
    },
}