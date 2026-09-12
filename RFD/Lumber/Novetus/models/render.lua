local x, y, model = ...
local window = game:service("HtmlService"):NewWindow(768, 768) 
if not game.Players.LocalPlayer then game.Players:createLocalPlayer(0):LoadCharacter() end
local b64 = game:service("ThumbnailGenerator"):click("PNG", x, y, model)

window.DocumentComplete:connect(function() 
	window:SetBody([==[<img src='data:image/png;base64, ]==] .. b64 .. [==[' style='width:100%' />]==]);
	window:Show()
end)
window:Navigate()