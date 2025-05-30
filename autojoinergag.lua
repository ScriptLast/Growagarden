if not game:IsLoaded() then
	game.Loaded:Wait()
end

if token == "" or channelId == "" then
    game.Players.LocalPlayer:Kick("Add your token or channelId to use")
end

local HttpServ = game:GetService("HttpService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local joinedFile = isfile("joined_ids.txt")
if not joinedFile then
    writefile("joined_ids.txt", "[]")
end

local joinedIds = HttpServ:JSONDecode(readfile("joined_ids.txt"))

local function saveJoinedId(messageId)
    table.insert(joinedIds, messageId)
    writefile("joined_ids.txt", HttpServ:JSONEncode(joinedIds))
end

-- Auto chat "hi" sekali saat player masuk
local function sendAutoChat()
    local TextChatService = game:GetService("TextChatService")
    local success, err = pcall(function()
        TextChatService.TextChannels.RBXGeneral:SendAsync("hi")
    end)
    if not success then
        warn("Gagal kirim chat:", err)
    end
end

-- Tunggu beberapa detik abis join buat kirim chat
task.delay(15, sendAutoChat)

local function autoJoin()
    local response = request({
        Url = "https://discord.com/api/v9/channels/"..channelId.."/messages?limit=10",
        Method = "GET",
        Headers = {
            ['Authorization'] = token,
            ['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36',
            ["Content-Type"] = "application/json"
        }
    })

    if response.StatusCode == 200 then
        local messages = HttpServ:JSONDecode(response.Body)
        if #messages == 0 then
            print("0 messages found")
            return
        end
        for _, message in ipairs(messages) do
            if message.content ~= "" and message.embeds and message.embeds[1] and message.embeds[1].title then
                if message.embeds[1].title:find("Join to get GAG hit") then
                    local placeId, jobId = string.match(message.content, 'TeleportToPlaceInstance%((%d+),%s*["\']([%w%-]+)["\']%)')
                    if placeId and jobId then
                        if not table.find(joinedIds, tostring(message.id)) then
                            saveJoinedId(tostring(message.id))
                            TeleportService:TeleportToPlaceInstance(placeId, jobId, Players.LocalPlayer)
                            return
                        end
                    end
                end
            end
        end
    else
        print("Response code is not 200. Is your token and channelid correct?")
    end
end

while wait(5) do
    autoJoin()
end
