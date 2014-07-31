-- Capit Software: Inserter's CoreScript.lua
-- Code protected by MIT license. Auhtored by Wehttam664

fetch = require(game.Lighting.AssetFetcher);
createMenu = fetch("lib", "create_menu");
bin = script.Parent; enabled=true;
player = bin.Parent.Parent;

function mouse1Fired(mouse)
	if (enabled) then
		-- TODO;
	end
end

function mouse2Fired(mouse)
	if (enabled) then
		
	end
end

bin.Selected:connect(function (mouse)
	print(player.Name.." selected insterter.");
	mouse.Button1Down:connect(function () mouse1Fired(mouse) end);
	mouse.Button2Down:connect(function () mouse2Fired(mouse) end);
end;

-- Check for missing parent;
repeat wait() until (not script) or (not script.Parent);
enabled=false;
