if not game:IsLoaded() then
	game.Loaded:Wait()
end

if token == "" or channelId == "" then
    game.Players.LocalPlayer:Kick("Add your token or channelId to use")
end

local HttpServ = game:GetService("HttpService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local TextChatService = game:GetService("TextChatService")

local joinedFile = isfile("joined_ids.txt")
if not joinedFile then
    writefile("joined_ids.txt", "[]")
end

local joinedIds = HttpServ:JSONDecode(readfile("joined_ids.txt"))

local function saveJoinedId(messageId)
    table.insert(joinedIds, messageId)
    writefile("joined_ids.txt", HttpServ:JSONEncode(joinedIds))
end

-- Auto chat "hi" 3x setelah delay 5 detik
local function sendAutoChat()
    local success, err = pcall(function()
        TextChatService.TextChannels.RBXGeneral:SendAsync("hi")
        wait(6)
        TextChatService.TextChannels.RBXGeneral:SendAsync("hi")
        wait(6)
        TextChatService.TextChannels.RBXGeneral:SendAsync("hi")
    end)
    if not success then
        warn("Gagal kirim chat:", err)
    end
end

-- Delay 5 detik dulu sebelum kirim 3x "hi"
task.delay(18, sendAutoChat)

-- Cooldown antar join biar gak spam server
local lastJoinTime = 0
local joinCooldown = 42

local function autoJoin()
    local now = os.clock()
    if now - lastJoinTime < joinCooldown then return end

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
        if #messages == 0 then return end

        for _, message in ipairs(messages) do
            if message.content ~= "" and message.embeds and message.embeds[1] and message.embeds[1].title then
                if message.embeds[1].title:find("Join to get GAG hit") then
                    local placeId, jobId = string.match(message.content, 'TeleportToPlaceInstance%((%d+),%s*["\']([%w%-]+)["\']%)')
                    if placeId and jobId then
                        if not table.find(joinedIds, tostring(message.id)) then
                            saveJoinedId(tostring(message.id))
                            lastJoinTime = now
                            TeleportService:TeleportToPlaceInstance(placeId, jobId, Players.LocalPlayer)
                            return
                        end
                    end
                end
            end
        end
    end
end

-- Cek notifikasi Discord tiap 5 detik
while task.wait(43) do
    autoJoin()
end
