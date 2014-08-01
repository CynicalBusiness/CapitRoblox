-- ExtendedLibrary, a Lua function library by Matt (Wehttam664/NukesForKids) at Capit Software
-- This code is protected under the MIT license. See GitHub repository for full information.

-- Modification of this code may result in dysfunctionality of the library.
-- Support will only be offered to unmodified library files.

-- Function and Extension documentation is available on the GitHub repository.

print("ExtLibrary loaded.");
ExtLibrary = {}; ExtLibrary.__index = ExtLibrary;
function ExtLibrary.new()
	lib = {}; setmetatable(lib, ExtLibrary);
	return lib;
end

-- STRINGS --------
function ExtLibrary:split(str)
	local arr = {};
	for v in string.gmatch(str, "%S+") do
		table.insert(arr, v);
	end
	return arr;
end
function ExtLibrary:formatTime(sec)
	sec = sec or os.time();
	local hr = string.format("%02.f", math.floor(sec/3600));
	local mn = string.format("%02.f", math.floor((sec/60)-(hr*60)));
	local se = string.format("%02.f", math.floor(sec-(hr*3600)-(mn*60)));
	return hr..":"..mn..":"..se;
end
function ExtLibrary:echo(msg, level)
	level = level or "info"; lever:lower();
	local levels = {info="INFO", warning="WARN", 
		severe="SEVERE", fatal="FATAL", debug="DEBUG"};
	if not levels[level] then
		self:echo("Failed to resolve level '"..level..".", "warning");
		self:echo("Defauled to level 'info'", "warning");
		level = "info";
	end
	local curtime = self:formatTime();
	return "["..curtime.."] "..levels[level]..": "..msg;
end

-- MATH --------
function ExtLibrary:round(num, mult)
	mult = mult or 1;
	return math.floor((num/mult)+0.5)*mult;
end

-- GUI --------
function ExtLibrary:createPopup(player, background, foreground, dismissable)
	if not player then return end;
	background = background or Color3.new(51/255,51/255,51/255);
	foreground = foreground or Color3.new(1,1,1);
	dismissable = dismissble or true;
	local Popup = {}; Popup.__index=Popup;
	local pop = {}; setmetatable(pop,Popup);
	pop.player = player; pop.buttons = {};
	local pui = Instance.new("ScreenGui");
	pui.Parent = player.PlayerGui; pui.Name = "Popup";
	local fr = Instance.new("Frame"); fr.ZIndex = 5;
	fr.Parent = pui; fr.BackgroundColor3 = background;
	fr.BorderColor3 = Color3.new(0,0,0); fr.Visible = false;
	fr.Size = UDim2.new(0,400,0,200); fr.Position = UDim2.new(0.5,-200,0.5,-100);
	if (dismissable) then
		local ex = Instance.new("TextButton");
		ex.Size = UDim2.new(0,20,0,20); ex.Position = UDim2.new(1,-20,0,0);
		ex.BackgroundColor3 = Color3.new(102/255,51/255,51/255);
		ex.TextColor3 = Color3.new(1,1,1); ex.TextStrokeTransparency = 0;
		ex.Text = "X"; ex.BorderColor3 = Color3.new(0,0,0);
		ex.Parent = fr; ex.ZIndex = 6;
		ex.MouseButton1Down:connect(function () pui:Destory(); end);
	end;
	function Popup:addButton(text, callback,  color)
		color = color or Color3.new(51/255,51/255,102/255);
		callback = callback or (function (p) end); text = text or "OK";
		local btn = Instance.new("TextButton"); btn.ZIndex = 6;
		btn.BackgroundColor3 = color; btn.TextColor3 = Color3.new(1,1,1);
		btn.Text = text; btn.BorderColor3 = Color3.new(0,0,0);
		btn.TextStrokeTransparency = 0; btn.Parent = fr;
		btn.MouseButton1Down:connect(function () callback(player) end);
		table.insert(self.buttons,btn);
	end
	function Popup:display()
		local btns = #self.buttons;
		local sizeX = 1/btns;
		for i=1,btns do
			local posX = sizeX*(i-1);
			self.buttons[i].Size = UDim2.new(sizeX,-10,0,25);
			self.buttons[i].Position = UDim2.new(posX,5,1,-30);
			self.buttons[i].Visible = true;
		end;
		fr.Visible = true;
	end
	return pop;
end

return ExtLibrary.new();
