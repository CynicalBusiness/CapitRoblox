-- ExtendedLibrary, a Lua function library by Matt (Wehttam664/NukesForKids) at Capit Software
-- This code is protected under the MIT license. See GitHub repository for full information.

-- Modification of this code may result in dysfunctionality of the library.
-- Support will only be offered to unmodified library files.

-- Function and Extension documentation is available on the GitHub repository.

-- INIT --------
ExtLibrary = {}; ExtLibrary.__index = ExtLibrary;
function ExtLibrary.new()
	lib = {}; setmetatable(lib, ExtLibrary);
	lib.exts = {}; lib.global = {};
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
	repeat sec=sec-86400 until sec<=86400;
	local hr = string.format("%02.f", math.floor(sec/3600));
	local mn = string.format("%02.f", math.floor((sec/60)-(hr*60)));
	local se = string.format("%02.f", math.floor(sec-(hr*3600)-(mn*60)));
	hr=hr-7; if hr<0 then hr=hr+24 end;
	return hr..":"..mn..":"..se;
end
function ExtLibrary:echo(msg, level)
	level = level or "info"; level:lower();
	local levels = {info="INFO", warning="WARN", 
		severe="SEVERE", fatal="FATAL", debug="DEBUG"};
	if not levels[level] then
		self:echo("Failed to resolve level '"..level..".", "warning");
		self:echo("Defauled to level 'info'", "warning");
		level = "info";
	end
	local curtime = self:formatTime();
	tag = "["..curtime.."] "..levels[level]..": "..msg;
	print(tag); return tag;
end
function ExtLibrary:strcolAdd(collection, str)
	if (collection~="") then
		return collection.." "..str;
	else
		return str;
	end
end
function ExtLibrary:strcolSub(collection, str)
	local arr = self:split(collection);
	local removed = "";
	for i=1,#arr do
		if arr[i]==str then
			removed = table.remove(arr, i);
		end
	end
	return table.concat(arr, " "), removed;
end
function ExtLibrary:strcolContains(collection, str)
	local arr = self:split(collection);
	for i=1,#arr do
		if arr[i]==str then
			return true;
		end
	end
	return false;
end
function ExtLibrary:strcolNum(collection)
	return table.getn(self:split(collection));
end

-- TABLES --------
function ExtLibrary:tableContains(tbl, value)
	for _,v in pairs(tbl) do
		if v == value then
			return true;
		end
	end
	return false;
end

function ExtLibrary:getIndexOf(tbl, value)
	for i=1,#tbl do
		if tbl[i]==value then
			return i;
		end
	end
	return 0;
end

-- SETS --------
function ExtLibrary:createMap()
	if not classtype then return end;
	lib = self;
	Map = {};
	Map.__index = Map;
	set = {}; setmetatable(set, Map);
	set.keys = {}; set.values = {}; set.size=0; 
	set.keyclass = keyclass; self.valclass = valclass;
	function Map:put(k,v)
		local index = lib:getIndexOf(self.keys, k);
		if (index==0) then
			table.insert(self.keys, k);
			table.insert(self.values, v);
		else
			table.insert(self.values, index);
		end
		self.size = self.size+1;
	end
	function Map:delete(k)
		local index = lib:getIndexOf(self.keys, k);
		if (index>0) then
			table.remove(self.keys, index);
			table.remove(self.values, index);
			self.size = self.size-1;
		end
	end
	function Map:getKeys()
		return self.keys;
	end
	function Map:getValues()
		return self.values;
	end
	function Map:size()
		return self.size();
	end
	function Map:getAll()
		local i = 0;
		return function ()
				i=i+1;
				if i<self.size then return self.keys[i], self.values[i] end;
			end
	end
	function Map:getAt(index)
		return self.values[index];
	end
	function Map:getKeyAt(index)
		return self.keys[index];
	end
	function Map:containsKey(k)
		return lib:tableContains(self.keys, k);
	end
	function Map:containsValue(v)
		return lib:tableContains(self.values, v);
	end
	function Map:get(k)
		local index = lib:getIndexOf(self.keys, k);
		if (index~=0) then
			return self.values[index];
		else
			return nil;	
		end
	end
	function Map:addFrom(map)
		for k,v in self:getAll() do
			self:put(k,v);
		end
	end
	function Map:equals(map)
		if (self:size()==map:size()) then
			for i=1,self:size() do
				if (self:getKeyAt(i)~=map:getKeyAt(i)) or (self:getAt(i)~=map:getAt(i)) then
					return false;
				end
			end
			return true;
		end
		return false;
	end
	function Map:__tostring()
		local parts = {};
		for k,v in self:getAll() do
			table.insert(parts, tostring(k).."="..tostring(v));
		end
		return "Map<"..self.keyclass..","..self.valclass..":"..self.size..">{"..table.concat(parts, ", ").."}";
	end
	
	-- STATIC
	function Map.__add(map1, map2)
		return map1:addFrom(map2);
	end
	function Map.__eq(map1, map2)
		return map1:equals(map2);	
	end
	return set;
end

-- MATH --------
function ExtLibrary:round(num, mult)
	mult = mult or 1;
	return math.floor((num/mult)+0.5)*mult;
end

-- GUI --------
function ExtLibrary:createPopup(player, text, dismissable, background, foreground)
	if not player and text then return end;
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
		ex.MouseButton1Down:connect(function () pui:remove(); end);
	end;
	local txt = Instance.new("TextLabel"); txt.ZIndex = 6;
	txt.BackgroundTransparency = 1; txt.TextColor3 = foreground;
	txt.TextStrokeTransparency = 0; txt.Size = UDim2.new(1,0,1,-35);
	txt.TextWrapped = true; txt.TextScaled = true;
	txt.Text = text; txt.Font = "SourceSansBold";
	txt.Parent = fr; txt.Visible = true;
	self:echo("Popup successfully created for "..player.Name..".");
	function Popup:hide()
		pui:remove();
	end
	function Popup:addButton(btntext, callback,  color)
		color = color or Color3.new(51/255,51/255,102/255);
		callback = callback or (function (p) end); btntext = btntext or "Button";
		local btn = Instance.new("TextButton"); btn.ZIndex = 6;
		btn.BackgroundColor3 = color; btn.TextColor3 = Color3.new(1,1,1);
		btn.Text = btntext; btn.BorderColor3 = Color3.new(0,0,0);
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

-- EXTENSIONS --------
function ExtLibrary:registerExtension(ext)
	if not ext then return end;
	if (ext:IsA("ModuleScript")) then
		self.exts[ext.Name]=ext;
		self:echo("Successfully hooked extension '"..ext.Name.."'.");
	else
		self:echo("Failed to hook extension: '"..ext.Name.."' is not a valid extension.");
	end
end
function ExtLibrary:getExtension(name)
	if (self.exts[name] and self.exts[name]:IsA("ModuleScript")) then
		return require(self.exts[name]);
	else
		self:echo("Extension '"..name.."' is missing or invalid.");
		return (function () end);
	end
end

-- GLOBAL TABLE --------
function ExtLibrary:putGlobal(key, value)
	self.global[key]=value;
	return value;
end
function ExtLibrary:getGlobal(key)
	return self.global[key];
end
function ExtLibrary:unsetGlobal(key)
	local val = self.global[key];
	self:putGlobal(key,nil);
	return val;
end
function ExtLibrary:clearGlobal()
	self.global = {};
end
function ExtLibrary:getGlobal()
	return self.global;
end

-- WRAPUP --------
local library = ExtLibrary.new();
require(script.Preloads)(library);
library:echo("ExtLibrary successfully loaded.");
return library;
