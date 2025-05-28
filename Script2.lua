local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local TweenService = game:GetService("TweenService")


local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")


local ScreenGui = Instance.new("ScreenGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = playerGui


local frame = Instance.new("Frame")
frame.Parent = ScreenGui
frame.Size = UDim2.new(1,0,1,0)
frame.BackgroundTransparency = 0
frame.BackgroundColor3 = Color3.fromRGB(0,20,40)


local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1,0,1,0)
textLabel.BackgroundColor3 = Color3.fromRGB(0,20,40)
textLabel.Font = Enum.Font.GothamBold
textLabel.TextColor3 = Color3.new(.8,.8,.8)
textLabel.Text = "Loading Last-Hub \n\r This might take a few minutes"
textLabel.TextSize = 15
textLabel.Parent = frame

local loadingRing = Instance.new("ImageLabel")
loadingRing.Size = UDim2.new(0,256,0,256)
loadingRing.BackgroundTransparency = 1
loadingRing.Image = "rbxassetid://4965945816"
loadingRing.AnchorPoint = Vector2.new(0.5,0.5)
loadingRing.Position = UDim2.new(0.5,0,0.5,0)
loadingRing.Parent = frame

ReplicatedFirst:RemoveDefaultLoadingScreen()


local tweenInfo = TweenInfo.new(4,Enum.EasingStyle.Linear,Enum.EasingDirection.In,-1)
local tween = TweenService:Create(loadingRing,tweenInfo,{Rotation = 360})


tween:Play()

wait(120)
if not game:IsLoaded() then
  game.Loaded:Wait()
else
  loadstring(game:HttpGet("https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader2.lua"))()
end

loadingRing.Visible = false
frame:TweenPosition(UDim2.new(0,0,1,0),"InOut","Sine",2)

print("Loaded LoadingScreen")
print("Script Successful")
