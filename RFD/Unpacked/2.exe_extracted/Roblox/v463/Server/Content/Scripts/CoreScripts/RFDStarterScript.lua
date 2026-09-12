_G.RFD = {}

wait(3.000000)
local BaseUrl = game:GetService("ContentProvider").BaseUrl:lower()
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")

spawn(function()
    local Url = "rfd/data-transfer"
    local Results = {}
    local CallsJson = {}

    local c = 0
    while true do
        c = c + 1
        local ResultsJson = HttpService:JSONEncode(Results)
        CallsJson = HttpRbxApiService:PostAsync(Url, ResultsJson, Enum.ThrottlingPriority.Extreme)
        Results = {}
        for guid, data in next, HttpService:JSONDecode(CallsJson) do
            local path, args = data.path, data.args
            Results[guid] = _G.RFD[path](unpack(args))
            -- warn(path, unpack(args), Results[guid])
        end
    end
end)

game.Players.PlayerAdded:connect(function(Player)
    local Url = "rfd/is-player-allowed?userId=" .. Player.UserId
    if HttpRbxApiService:GetAsync(Url) == 'true' then
        return
    end
    Player:Kick('Player is not allowed.')
end)

do
game.workspace.FilteringEnabled = false
end

print('Initialised RFD server scripts.')
