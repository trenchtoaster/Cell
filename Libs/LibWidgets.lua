local addonName, addon = ...
local L = addon.L
-- local LPP = LibStub:GetLibrary("LibPixelPerfect")

-----------------------------------------
-- Color
-----------------------------------------
local colors = {
	grey = {s="|cFFB2B2B2", t={.7, .7, .7}},
	yellow = {s="|cFFFFD100", t= {1, .82, 0}},
	orange = {s="|cFFFFC0CB", t= {1, .65, 0}},
	firebrick = {s="|cFFFF3030", t={1, .19, .19}},
	skyblue = {s="|cFF00CCFF", t={0, .8, 1}},
	chartreuse = {s="|cFF80FF00", t={.5, 1, 0}},
}

local class = select(2, UnitClass("player"))
local classColor = {s="|cCCB2B2B2", t={.7, .7, .7}}
if class then
	classColor.t[1], classColor.t[2], classColor.t[3], classColor.s = GetClassColor(class)
	classColor.s = "|c"..classColor.s
end

-----------------------------------------
-- Font
-----------------------------------------
local font_title_name = strupper(addonName).."_FONT_WIDGET_TITLE"
local font_title_disable_name = strupper(addonName).."_FONT_WIDGET_TITLE_DISABLE"
local font_name = strupper(addonName).."_FONT_WIDGET"
local font_disable_name = strupper(addonName).."_FONT_WIDGET_DISABLE"

local font_title = CreateFont(font_title_name)
font_title:SetFont(GameFontNormal:GetFont(), 14)
font_title:SetTextColor(1, 1, 1, 1)
font_title:SetShadowColor(0, 0, 0)
font_title:SetShadowOffset(1, -1)
font_title:SetJustifyH("CENTER")

local font_title_disable = CreateFont(font_title_disable_name)
font_title_disable:SetFont(GameFontNormal:GetFont(), 14)
font_title_disable:SetTextColor(.4, .4, .4, 1)
font_title_disable:SetShadowColor(0, 0, 0)
font_title_disable:SetShadowOffset(1, -1)
font_title_disable:SetJustifyH("CENTER")

local font = CreateFont(font_name)
font:SetFont(GameFontNormal:GetFont(), 13)
font:SetTextColor(1, 1, 1, 1)
font:SetShadowColor(0, 0, 0)
font:SetShadowOffset(1, -1)
font:SetJustifyH("CENTER")

local font_disable = CreateFont(font_disable_name)
font_disable:SetFont(GameFontNormal:GetFont(), 13)
font_disable:SetTextColor(.4, .4, .4, 1)
font_disable:SetShadowColor(0, 0, 0)
font_disable:SetShadowOffset(1, -1)
font_disable:SetJustifyH("CENTER")

-- local font_large = CreateFont(font_large_name)
-- font_large:SetFont(GameFontNormal:GetFont(), 14)
-- font_large:SetTextColor(1, 1, 1, 1)
-- font_large:SetShadowColor(0, 0, 0)
-- font_large:SetShadowOffset(1, -1)
-- font_large:SetJustifyH("CENTER")

-- local font_large_disable = CreateFont(font_large_disable_name)
-- font_large_disable:SetFont(GameFontNormal:GetFont(), 14)
-- font_large_disable:SetTextColor(.4, .4, .4, 1)
-- font_large_disable:SetShadowColor(0, 0, 0)
-- font_large_disable:SetShadowOffset(1, -1)
-- font_large_disable:SetJustifyH("CENTER")

-----------------------------------------
-- seperator
-----------------------------------------
function addon:CreateSeparator(text, parent, width, color)
	if not color then color = {t={classColor.t[1], classColor.t[2], classColor.t[3], .5}, s=classColor.s} end
	if not width then width = parent:GetWidth()-10 end

	local fs = parent:CreateFontString(nil, "OVERLAY", font_title_name)
	fs:SetJustifyH("LEFT")
	fs:SetTextColor(color.t[1], color.t[2], color.t[3])
	fs:SetText(text)


	local line = parent:CreateTexture()
	line:SetSize(width, 1)
	line:SetColorTexture(unpack(color.t))
	line:SetPoint("TOPLEFT", fs, "BOTTOMLEFT", 0, -2)
	local shadow = parent:CreateTexture()
	shadow:SetSize(width, 1)
	shadow:SetColorTexture(0, 0, 0, 1)
	shadow:SetPoint("TOPLEFT", line, 1, -1)

	return fs
end

-----------------------------------------
-- Frame
-----------------------------------------
function addon:StylizeFrame(frame, color, borderColor)
	if not color then color = {.1, .1, .1, .9} end
	if not borderColor then borderColor = {0, 0, 0, 1} end

	frame:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1})
    frame:SetBackdropColor(unpack(color))
	frame:SetBackdropBorderColor(unpack(borderColor))
end

function addon:CreateFrame(name, parent, width, height, isTransparent)
	local f = CreateFrame("Frame", name, parent)
	f:Hide()
	if not isTransparent then addon:StylizeFrame(f) end
	f:EnableMouse(true)
	if width and height then f:SetSize(width, height) end
	return f
end

local function SetTooltip(widget, anchor, x, y, ...)
	local tooltips = {...}

	if #tooltips ~= 0 then
		widget:HookScript("OnEnter", function()
			CellTooltip:SetOwner(widget, anchor or "ANCHOR_TOP", x or 0, y or 0)
            CellTooltip:AddLine(tooltips[1])
            for i = 2, #tooltips do
                CellTooltip:AddLine("|cffffffff" .. tooltips[i])
            end
            CellTooltip:Show()
		end)
		widget:HookScript("OnLeave", function()
			CellTooltip:Hide()
		end)
	end
end

-----------------------------------------
-- Button
-----------------------------------------
function addon:CreateButton(parent, text, buttonColor, size, noBorder, fontNormal, fontDisable, ...)
	local b = CreateFrame("Button", nil, parent)
	if parent then b:SetFrameLevel(parent:GetFrameLevel()+1) end
	b:SetText(text)
	b:SetSize(unpack(size))

	local color, hoverColor
	if buttonColor == "red" then
		color = {.6, .1, .1, .6}
		hoverColor = {.6, .1, .1, 1}
	elseif buttonColor == "red-hover" then
		color = {.1, .1, .1, 1}
		hoverColor = {.6, .1, .1, 1}
	elseif buttonColor == "green" then
		color = {.1, .6, .1, .6}
		hoverColor = {.1, .6, .1, 1}
	elseif buttonColor == "green-hover" then
		color = {.1, .1, .1, 1}
		hoverColor = {.1, .6, .1, 1}
	elseif buttonColor == "cyan" then
		color = {0, .9, .9, .6}
		hoverColor = {0, .9, .9, 1}
	elseif buttonColor == "blue" then
		color = {0, .5, .8, .6}
		hoverColor = {0, .5, .8, 1}
	elseif buttonColor == "blue-hover" then
		color = {.1, .1, .1, 1}
		hoverColor = {0, .5, .8, 1}
	elseif buttonColor == "yellow" then
		color = {.7, .7, 0, .6}
		hoverColor = {.7, .7, 0, 1}
	elseif buttonColor == "yellow-hover" then
		color = {.1, .1, .1, 1}
		hoverColor = {.7, .7, 0, 1}
	elseif buttonColor == "class" then
		color = {classColor.t[1], classColor.t[2], classColor.t[3], .3}
		hoverColor = {classColor.t[1], classColor.t[2], classColor.t[3], .6}
	elseif buttonColor == "class-hover" then
		color = {.1, .1, .1, 1}
		hoverColor = {classColor.t[1], classColor.t[2], classColor.t[3], .6}
	elseif buttonColor == "chartreuse" then
		color = {.5, 1, 0, .6}
		hoverColor = {.5, 1, 0, .8}
	elseif buttonColor == "magenta" then
		color = {.6, .1, .6, .6}
		hoverColor = {.6, .1, .6, 1}
	elseif buttonColor == "transparent" then -- drop down item
		color = {0, 0, 0, 0}
		hoverColor = {.5, 1, 0, .7}
	elseif buttonColor == "transparent-white" then -- drop down item
		color = {0, 0, 0, 0}
		hoverColor = {.4, .4, .4, .7}
	elseif buttonColor == "transparent-light" then -- drop down item
		color = {0, 0, 0, 0}
		hoverColor = {.5, 1, 0, .5}
	elseif buttonColor == "transparent-class" then -- drop down item
		color = {0, 0, 0, 0}
		hoverColor = {classColor.t[1], classColor.t[2], classColor.t[3], .6}
	elseif buttonColor == "none" then
		color = {0, 0, 0, 0}
	else
		color = {.1, .1, .1, .7}
		hoverColor = {.5, 1, 0, .6}
	end

	-- keep color & hoverColor
	b.color = color
	b.hoverColor = hoverColor

	local s = b:GetFontString()
	if s then
		s:SetWordWrap(false)
		-- s:SetWidth(size[1])
		s:SetPoint("LEFT")
		s:SetPoint("RIGHT")
	end
	
	if noBorder then
		b:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
	else
		b:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1, insets = {left=1,top=1,right=1,bottom=1}})
	end
	
	if buttonColor and string.find(buttonColor, "transparent") then -- drop down item
		-- b:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
		if s then
			s:SetJustifyH("LEFT")
			s:SetPoint("LEFT", 5, 0)
			s:SetPoint("RIGHT", -5, 0)
		end
		b:SetBackdropBorderColor(1, 1, 1, 0)
		b:SetPushedTextOffset(0, 0)
	else
		-- local bg = b:CreateTexture(nil, "BACKGROUND")
		-- bg:SetAllPoints(b)
		-- bg:SetColorTexture(0, 0, 0, 1)

    	b:SetBackdropBorderColor(0, 0, 0, 1)
		b:SetPushedTextOffset(0, -1)
	end


	b:SetBackdropColor(unpack(color)) 
	b:SetDisabledFontObject(fontDisable or font_disable)
    b:SetNormalFontObject(fontNormal or font)
	b:SetHighlightFontObject(fontNormal or font)
	
	if buttonColor ~= "none" then
		b:SetScript("OnEnter", function(self) self:SetBackdropColor(unpack(self.hoverColor)) end)
		b:SetScript("OnLeave", function(self) self:SetBackdropColor(unpack(self.color)) end)
	end

	-- click sound
	b:SetScript("PostClick", function() PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON) end)

	SetTooltip(b, "ANCHOR_TOPLEFT", 0, 3, ...)

	return b
end

-----------------------------------------
-- Button Group
-----------------------------------------
function addon:CreateButtonGroup(func, ...)
	local buttons = {...}
	local function HighlightButton(target)
		for _, b in ipairs(buttons) do
			if target == b.target then
				b:SetBackdropColor(unpack(b.hoverColor))
				b:SetScript("OnEnter", function()
					if b.ShowTooltip then b.ShowTooltip() end
				end)
				b:SetScript("OnLeave", function()
					if b.HideTooltip then b.HideTooltip() end
				end)
			else
				b:SetBackdropColor(unpack(b.color))
				b:SetScript("OnEnter", function() 
					if b.ShowTooltip then b.ShowTooltip() end
					b:SetBackdropColor(unpack(b.hoverColor))
				end)
				b:SetScript("OnLeave", function() 
					if b.HideTooltip then b.HideTooltip() end
					b:SetBackdropColor(unpack(b.color))
				end)
			end
		end
	end
	
	for _, b in ipairs(buttons) do
		b:SetScript("OnClick", function()
			HighlightButton(b.target)
			func(b.target)
		end)
	end
	
	buttons.HighlightButton = HighlightButton

	return buttons
end

-----------------------------------------
-- check button
-----------------------------------------
function addon:CreateCheckButton(parent, label, onClick, ...)
	-- InterfaceOptionsCheckButtonTemplate --> FrameXML\InterfaceOptionsPanels.xml line 19
	-- OptionsBaseCheckButtonTemplate -->  FrameXML\OptionsPanelTemplates.xml line 10
	
	local cb = CreateFrame("CheckButton", nil, parent)
	cb.onClick = onClick
	cb:SetScript("OnClick", function(self)
		PlaySound(self:GetChecked() and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
		if cb.onClick then cb.onClick(self:GetChecked() and true or false, self) end
	end)
	
	cb.label = cb:CreateFontString(nil, "ARTWORK", font_name)
	cb.label:SetText(label)
	cb.label:SetPoint("LEFT", cb, "RIGHT", 5, 0)
	-- cb.label:SetTextColor(classColor.t[1], classColor.t[2], classColor.t[3])
	
	cb:SetSize(14, 14)
	cb:SetHitRectInsets(0, -cb.label:GetStringWidth(), 0, 0)

	cb:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1})
	cb:SetBackdropColor(.1, .1, .1, .9)
	cb:SetBackdropBorderColor(0, 0, 0, 1)

	local checkedTexture = cb:CreateTexture(nil, "ARTWORK")
	checkedTexture:SetColorTexture(classColor.t[1], classColor.t[2], classColor.t[3], .7)
	checkedTexture:SetPoint("CENTER")
	checkedTexture:SetSize(12, 12)
	
	cb:SetCheckedTexture(checkedTexture)
	-- cb:SetHighlightTexture([[Interface\AddOns\Cell\Media\CheckBox\CheckBox-Highlight-16x16]], "ADD")
	-- cb:SetDisabledCheckedTexture([[Interface\AddOns\Cell\Media\CheckBox\CheckBox-DisabledChecked-16x16]])
	
	SetTooltip(cb, "ANCHOR_TOPLEFT", 0, 1, ...)

	return cb
end

-----------------------------------------
-- editbox
-----------------------------------------
function addon:CreateEditBox(parent, width, height, isNumeric, font)
	if not font then font = font_name end

	local eb = CreateFrame("EditBox", nil, parent)
	addon:StylizeFrame(eb, {.1, .1, .1, .9})
	eb:SetFontObject(font)
	eb:SetMultiLine(false)
	eb:SetMaxLetters(0)
	eb:SetJustifyH("LEFT")
	eb:SetJustifyV("CENTER")
	eb:SetWidth(width or 0)
	eb:SetHeight(height or 0)
	eb:SetTextInsets(5, 5, 0, 0)
	eb:SetAutoFocus(false)
	eb:SetNumeric(isNumeric)
	eb:SetScript("OnEscapePressed", function() eb:ClearFocus() end)
	eb:SetScript("OnEnterPressed", function() eb:ClearFocus() end)
	eb:SetScript("OnEditFocusGained", function() eb:HighlightText() end)
	eb:SetScript("OnEditFocusLost", function() eb:HighlightText(0, 0) end)
	eb:SetScript("OnDisable", function() eb:SetTextColor(.7, .7, .7, 1) end)
	eb:SetScript("OnEnable", function() eb:SetTextColor(1, 1, 1, 1) end)

	return eb
end

-----------------------------------------
-- slider 2020-08-25 02:49:16
-----------------------------------------
-- Interface\FrameXML\OptionsPanelTemplates.xml, line 76, OptionsSliderTemplate
function addon:CreateSlider(name, parent, low, high, width, step, onValueChangedFn)
    local slider = CreateFrame("Slider", nil, parent)
    slider:SetMinMaxValues(low, high)
	slider:SetValue(low)
    slider:SetValueStep(step)
	slider:SetObeyStepOnDrag(true)
	slider:SetOrientation("HORIZONTAL")
	slider:SetSize(width, 10)

	addon:StylizeFrame(slider)
	
	local nameText = slider:CreateFontString(nil, "OVERLAY", font_name)
	nameText:SetText(name)
	nameText:SetPoint("BOTTOM", slider, "TOP", 0, 2)

	local currentText = slider:CreateFontString(nil, "OVERLAY", font_name)
	currentText:SetText(slider:GetValue())
	currentText:SetPoint("TOP", slider, "BOTTOM")

	local lowText = slider:CreateFontString(nil, "OVERLAY", font_name)
	lowText:SetText(colors.grey.s..low)
	lowText:SetPoint("TOPLEFT", slider, "BOTTOMLEFT")

	local hightText = slider:CreateFontString(nil, "OVERLAY", font_name)
	hightText:SetText(colors.grey.s..high)
	hightText:SetPoint("TOPRIGHT", slider, "BOTTOMRIGHT")

	local tex = slider:CreateTexture(nil, "ARTWORK")
	tex:SetColorTexture(classColor.t[1], classColor.t[2], classColor.t[3], .7)
	tex:SetSize(8, 8)
	slider:SetThumbTexture(tex)
	slider:SetScript("OnEnter", function()
		tex:SetColorTexture(classColor.t[1], classColor.t[2], classColor.t[3], 1)
	end)
	slider:SetScript("OnLeave", function()
		tex:SetColorTexture(classColor.t[1], classColor.t[2], classColor.t[3], .7)
	end)
	
    -- if tooltip then slider.tooltipText = tooltip end

	local oldValue
	slider:SetScript("OnValueChanged", function(self, value, userChanged)
		if oldValue == value then return end
		oldValue = value

		currentText:SetText(value)
        if userChanged and onValueChangedFn then onValueChangedFn(value) end
	end)
	
	
	return slider
end

------------------------------------------------
-- dropdown menu 2020-08-25 02:49:53
------------------------------------------------
function addon:CreateDropdownMenu(parent, width)
	local menu = CreateFrame("Frame", nil, parent)
	menu:SetSize(width, 20)
	menu:EnableMouse(true)
	menu:SetFrameLevel(5)
	addon:StylizeFrame(menu)
	
	-- button: open/close menu list
	menu.button = addon:CreateButton(menu, "", "transparent-class", {18 ,20})
	addon:StylizeFrame(menu.button)
	menu.button:SetPoint("RIGHT")
	menu.button:SetFrameLevel(6)
	menu.button:SetNormalTexture([[Interface\AddOns\Cell\Media\dropdown]])
	menu.button:SetPushedTexture([[Interface\AddOns\Cell\Media\dropdown-pushed]])
	menu.button:SetDisabledTexture([[Interface\AddOns\Cell\Media\dropdown-disabled]])

	-- selected item
	menu.text = menu:CreateFontString(nil, "OVERLAY", font_name)
	menu.text:SetJustifyV("MIDDLE")
	menu.text:SetJustifyH("LEFT")
	menu.text:SetWordWrap(false)
	menu.text:SetPoint("TOPLEFT", 5, -1)
	menu.text:SetPoint("BOTTOMRIGHT", -19, 1)
	
	-- item list
	local list = CreateFrame("Frame", nil, menu)
	addon:StylizeFrame(list, {.1, .1, .1, 1})
	list:SetPoint("TOP", menu, "BOTTOM", 0, -2)
	list:SetFrameLevel(7) -- top of its strata
	list:SetSize(width, 5)
	list:Hide()
	
	local hightlightTexture = CreateFrame("Frame", nil, list)
	hightlightTexture:SetBackdrop({edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1})
	hightlightTexture:SetBackdropBorderColor(unpack(classColor.t))

	-- keep all menu item buttons
	menu.items = {}

	-- selected text -> SavedVariable
	menu.selected = ""
	
	function menu:SetSelected(text)
		menu.text:SetText(text ~= "" and text or "-")
		menu.selected = text

		if text ~= "" then
			for _, b in pairs(menu.items) do
				if b.text == text then
					hightlightTexture:ClearAllPoints()
					hightlightTexture:SetAllPoints(b)
					break
				end
			end
		end
	end

	function menu:SetSelectedItem(itemNum)
		local b = menu.items[itemNum]
		menu.text:SetText(b.text)
		menu.selected = text

		hightlightTexture:ClearAllPoints()
		hightlightTexture:SetAllPoints(b)
	end

	function menu:ClearItems()
		for _, b in pairs(menu.items) do
			b:SetParent(nil)
			b:ClearAllPoints()
			b:Hide()
		end
		table.wipe(menu.items)
		hightlightTexture:ClearAllPoints()
		menu:SetSelected("")
	end
	
	-- items = {{["text"] = (string), ["onClick"] = (function)}}
	function menu:SetItems(items)
		menu:ClearItems()
		local last = nil
		for _, item in pairs(items) do
			local b = addon:CreateButton(list, item.text, "transparent-class", {width-2 ,18}, true)
			table.insert(menu.items, b)
			b.text = item.text

			b:SetScript("OnClick", function()
				PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
				menu:SetSelected(item.text)
				list:Hide()
				if item.onClick then item.onClick(item.text) end
			end)
			
			-- SetPoint
			if last then
				b:SetPoint("TOP", last, "BOTTOM", 0, 0)
			else
				b:SetPoint("TOPLEFT", 1, -1)
			end
			last = b
		end

		if #menu.items == 0 then
			list:SetHeight(5)
		else
			list:SetHeight(2 + #menu.items*18)
		end
	end

	function menu:AddItem(item)
		local b = addon:CreateButton(list, item.text, "transparent-class", {width-2 ,18}, true)
		table.insert(menu.items, b)
		b.text = item.text

		b:SetScript("OnClick", function()
			PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
			menu:SetSelected(item.text)
			list:Hide()
			if item.onClick then item.onClick(item.text) end
		end)

		if #menu.items ~= 0 then
			b:SetPoint("TOP", menu.items[#menu.items-1], "BOTTOM", 0, 0)
		else
			b:SetPoint("TOPLEFT", 1, -1)
		end
		list:SetHeight(2 + #menu.items*18)
	end

	-- remove current selected item from list
	function menu:RemoveCurrentItem()
		for i = 1, #menu.items do
			if menu.selected  == menu.items[i].text then
				-- set next button position
				if menu.items[i+1] then
					menu.items[i+1]:SetPoint(menu.items[i]:GetPoint(1))
				end
				-- hide item
				menu.items[i]:SetParent(nil)
				menu.items[i]:ClearAllPoints()
				menu.items[i]:Hide()
				-- remove from table
				table.remove(menu.items, i)
				-- reset selected
				menu.selected = ""
				break
			end
		end

		menu.text:SetText("-")
		if #menu.items == 0 then
			list:SetHeight(5)
		else
			list:SetHeight(2 + #menu.items*18)
		end
	end

	-- set current item button 
	function menu:SetCurrentItem(item)
		for _, b in pairs(menu.items) do
			if menu.selected == b.text then
				b.text = item.text
				b:SetText(item.text)
				b:SetScript("OnClick", function()
					PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
					menu:SetSelected(item.text)
					list:Hide()
					if item.onClick then item.onClick(item.text) end
				end)
				break
			end
		end
		-- update current selected text
		menu:SetSelected(item.text)
	end

	function menu:Close()
		list:Hide()
	end
	
	function menu:SetEnabled(f)
		menu.button:SetEnabled(f)
	end
	
	-- scripts
	menu.button:HookScript("OnClick", function()
		if list:IsShown() then list:Hide() else list:Show() end
	end)
	
	menu:SetScript("OnShow", function()
		list:Hide()
	end)

	menu:SetScript("OnHide", function()
		list:Hide()
	end)
	
	return menu
end

------------------------------------------------
-- texture dropdown menu
------------------------------------------------
function addon:CreateTextureDropdown(parent, width)
	local menu = CreateFrame("Frame", nil, parent)
	menu:SetSize(width, 20)
	menu:EnableMouse(true)
	menu:SetFrameLevel(5)
	addon:StylizeFrame(menu)
	
	-- button: open/close menu list
	menu.button = addon:CreateButton(menu, "", "transparent-class", {18 ,20})
	addon:StylizeFrame(menu.button)
	menu.button:SetPoint("RIGHT")
	menu.button:SetFrameLevel(6)
	menu.button:SetNormalTexture([[Interface\AddOns\Cell\Media\dropdown]])
	menu.button:SetPushedTexture([[Interface\AddOns\Cell\Media\dropdown-pushed]])
	menu.button:SetDisabledTexture([[Interface\AddOns\Cell\Media\dropdown-disabled]])

	-- selected item
	menu.text = menu:CreateFontString(nil, "OVERLAY", font_name)
	menu.text:SetJustifyV("MIDDLE")
	menu.text:SetJustifyH("LEFT")
	menu.text:SetWordWrap(false)
	menu.text:SetPoint("TOPLEFT", 5, -1)
	menu.text:SetPoint("BOTTOMRIGHT", -18, 1)

	menu.texture = menu:CreateTexture(nil, "ARTWORK")
	menu.texture:SetPoint("TOPLEFT", 1, -1)
	menu.texture:SetPoint("BOTTOMRIGHT", -18, 1)
	menu.texture:SetVertexColor(1, 1, 1, .7)
	
	-- item list
	local list = CreateFrame("Frame", nil, menu)
	addon:StylizeFrame(list, {.1, .1, .1, 1})
	list:SetPoint("TOP", menu, "BOTTOM", 0, -2)
	list:SetFrameLevel(7) -- top of its strata
	list:SetSize(width, 5)
	list:Hide()
	
	local hightlightTexture = CreateFrame("Frame", nil, list)
	hightlightTexture:SetBackdrop({edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1})
	hightlightTexture:SetBackdropBorderColor(unpack(classColor.t))

	-- keep all menu item buttons
	menu.items = {}

	-- selected text -> SavedVariable
	menu.selected = ""
	
	function menu:SetSelected(text, texture)
		menu.text:SetText(text)
		menu.texture:SetTexture(texture)
		menu.selected = text

		for _, b in pairs(menu.items) do
			if b.text == text then
				hightlightTexture:ClearAllPoints()
				hightlightTexture:SetAllPoints(b)
				break
			end
		end
	end

	function menu:ClearItems()
		for _, b in pairs(menu.items) do
			b:SetParent(nil)
			b:ClearAllPoints()
			b:Hide()
		end
		table.wipe(menu.items)
		hightlightTexture:ClearAllPoints()
		menu:SetSelected("Cell ".._G.DEFAULT, "Interface\\AddOns\\Cell\\Media\\statusbar.tga")
	end
	
	-- items = {{["text"] = (string), ["texture"] = (string), ["onClick"] = (function)}}
	function menu:SetItems(items)
		menu:ClearItems()
		local last = nil
		for _, item in pairs(items) do
			local b = addon:CreateButton(list, item.text, "transparent-class", {width-2 ,18}, true)
			table.insert(menu.items, b)
			b.text = item.text

			b.texture = b:CreateTexture(nil, "ARTWORK")
			b.texture:SetPoint("TOPLEFT", 1, -1)
			b.texture:SetPoint("BOTTOMRIGHT", -1, 1)
			b.texture:SetTexture(item.texture)
			b.texture:SetVertexColor(1, 1, 1, .7)

			b:SetScript("OnClick", function()
				PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
				menu:SetSelected(item.text, item.texture)
				list:Hide()
				if item.onClick then item.onClick(item.text) end
			end)
			
			-- SetPoint
			if last then
				b:SetPoint("TOP", last, "BOTTOM", 0, 0)
			else
				b:SetPoint("TOPLEFT", 1, -1)
			end
			last = b
		end

		if #menu.items == 0 then
			list:SetHeight(5)
		else
			list:SetHeight(2 + #menu.items*18)
		end
	end

	function menu:Close()
		list:Hide()
	end
	
	function menu:SetEnabled(f)
		menu.button:SetEnabled(f)
	end
	
	-- scripts
	menu.button:HookScript("OnClick", function()
		if list:IsShown() then list:Hide() else list:Show() end
	end)
	
	menu:SetScript("OnShow", function()
		list:Hide()
	end)

	menu:SetScript("OnHide", function()
		list:Hide()
	end)
	
	return menu
end

-----------------------------------------
-- mask
-----------------------------------------
function addon:CreateMask(parent, text, points) -- points = {topleftX, topleftY, bottomrightX, bottomrightY}
	if not parent.mask then -- not init
		parent.mask = CreateFrame("Frame", nil, parent)
		addon:StylizeFrame(parent.mask, {.15, .15, .15, .6}, {0, 0, 0, 0})
		parent.mask:SetFrameStrata("HIGH")
		parent.mask:SetFrameLevel(100)
		parent.mask:EnableMouse(true) -- can't click-through

		parent.mask.text = parent.mask:CreateFontString(nil, "OVERLAY", font_title_name)
		parent.mask.text:SetTextColor(1, .2, .2)
		parent.mask.text:SetPoint("CENTER")

		-- parent.mask:SetScript("OnUpdate", function()
		-- 	if not parent:IsVisible() then
		-- 		parent.mask:Hide()
		-- 	end
		-- end)
	end

	if not text then text = "" end
	parent.mask.text:SetText(text)

	parent.mask:ClearAllPoints() -- prepare for SetPoint()
	if points then
		local tlX, tlY, brX, brY = unpack(points)
		parent.mask:SetPoint("TOPLEFT", tlX, tlY)
		parent.mask:SetPoint("BOTTOMRIGHT", brX, brY)
	else
		parent.mask:SetAllPoints(parent) -- anchor points are set to those of its "parent"
	end
	parent.mask:Show()
end

-----------------------------------------
-- create popup (delete/edit/... confirm) with mask
-----------------------------------------
function addon:CreateConfirmPopup(parent, width, text, onAccept, hasEditBox, mask)
	if not parent.confirmPopup then -- not init
		parent.confirmPopup = CreateFrame("Frame", nil, parent)
		parent.confirmPopup:SetSize(width, 100)
		addon:StylizeFrame(parent.confirmPopup, {.07, .07, .07, .95}, {classColor.t[1], classColor.t[2], classColor.t[3], .7})
		parent.confirmPopup:SetFrameStrata("DIALOG")
		parent.confirmPopup:SetFrameLevel(2)
		parent.confirmPopup:Hide()
		
		parent.confirmPopup:SetScript("OnHide", function()
			parent.confirmPopup:Hide()
			-- hide mask
			if mask and parent.mask then parent.mask:Hide() end
		end)

		parent.confirmPopup:SetScript("OnShow", function ()
			C_Timer.After(.2, function()
				parent.confirmPopup:SetScript("OnUpdate", nil)
			end)
		end)
		
		parent.confirmPopup.text = parent.confirmPopup:CreateFontString(nil, "OVERLAY", font_title_name)
		parent.confirmPopup.text:SetWordWrap(true)
		parent.confirmPopup.text:SetSpacing(3)
		parent.confirmPopup.text:SetJustifyH("CENTER")
		parent.confirmPopup.text:SetPoint("TOPLEFT", 5, -8)
		parent.confirmPopup.text:SetPoint("TOPRIGHT", -5, -8)

		-- yes
		parent.confirmPopup.button1 = addon:CreateButton(parent.confirmPopup, L["Yes"], "green", {35, 15})
		-- button1:SetPoint("BOTTOMRIGHT", -45, 0)
		parent.confirmPopup.button1:SetPoint("BOTTOMRIGHT", -34, 0)
		parent.confirmPopup.button1:SetBackdropBorderColor(classColor.t[1], classColor.t[2], classColor.t[3], .7)
		-- no
		parent.confirmPopup.button2 = addon:CreateButton(parent.confirmPopup, L["No"], "red", {35, 15})
		parent.confirmPopup.button2:SetPoint("LEFT", parent.confirmPopup.button1, "RIGHT", -1, 0)
		parent.confirmPopup.button2:SetBackdropBorderColor(classColor.t[1], classColor.t[2], classColor.t[3], .7)
	end

	if hasEditBox then
		if not parent.confirmPopup.editBox then
			parent.confirmPopup.editBox = addon:CreateEditBox(parent.confirmPopup, width-40, 20)
			parent.confirmPopup.editBox:SetPoint("TOP", parent.confirmPopup.text, "BOTTOM", 0, -5)
			parent.confirmPopup.editBox:SetAutoFocus(true)
			parent.confirmPopup.editBox:SetScript("OnHide", function()
				parent.confirmPopup.editBox:SetText("")
			end)
		else
			parent.confirmPopup.editBox:Show()
		end
	elseif parent.confirmPopup.editBox then
		parent.confirmPopup.editBox:Hide()
	end

	if mask then -- show mask?
		if not parent.mask then
			addon:CreateMask(parent)
		else
			parent.mask:Show()
		end
	end

	parent.confirmPopup.button1:SetScript("OnClick", function()
		if onAccept then onAccept(parent.confirmPopup) end
		-- hide mask
		if mask and parent.mask then parent.mask:Hide() end
		parent.confirmPopup:Hide()
	end)

	parent.confirmPopup.button2:SetScript("OnClick", function()
		-- hide mask
		if mask and parent.mask then parent.mask:Hide() end
		parent.confirmPopup:Hide()
	end)
	
	parent.confirmPopup:SetWidth(width)
	parent.confirmPopup.text:SetText(text)

	-- update height
	parent.confirmPopup:SetScript("OnUpdate", function(self, elapsed)
		local newHeight = parent.confirmPopup.text:GetStringHeight() + 30
		if hasEditBox then newHeight = newHeight + 30 end
		parent.confirmPopup:SetHeight(newHeight)
	end)

	parent.confirmPopup:ClearAllPoints() -- prepare for SetPoint()
	parent.confirmPopup:Show()

	return parent.confirmPopup
end

-----------------------------------------
-- popup edit box
-----------------------------------------
function addon:CreatePopupEditBox(parent, width, func, multiLine)
	if not addon.popupEditBox then
		local eb = CreateFrame("EditBox", addonName.."PopupEditBox")
		addon.popupEditBox = eb
		eb:Hide()
		eb:SetWidth(width)
		eb:SetAutoFocus(true)
		eb:SetFontObject(font)
		eb:SetJustifyH("LEFT")
		eb:SetMultiLine(true)
		eb:SetMaxLetters(255)
		eb:SetTextInsets(5, 5, 3, 4)
		eb:SetPoint("TOPLEFT")
		eb:SetPoint("TOPRIGHT")
		addon:StylizeFrame(eb, {.1, .1, .1, 1}, {classColor.t[1], classColor.t[2], classColor.t[3], 1})
		
		eb:SetScript("OnHide", function()
			eb:Hide() -- hide self when parent hides
		end)

		eb:SetScript("OnEscapePressed", function()
			eb:SetText("")
			eb:Hide()
		end)

		function eb:ShowEditBox(text)
			eb:SetText(text)
			eb:Show()
		end

		local tipsText = eb:CreateFontString(nil, "OVERLAY", font_name)
		tipsText:SetPoint("TOPLEFT", eb, "BOTTOMLEFT", 2, -1)
		tipsText:SetJustifyH("LEFT")
		-- tipsText:SetText("|cff777777"..L["Shift+Enter: add a new line\nEnter: apply\nESC: discard"])

		function eb:SetTips(text)
			tipsText:SetText(text)
		end

		local tipsBackground = CreateFrame("Frame", nil, eb)
		tipsBackground:SetPoint("TOPLEFT", eb, "BOTTOMLEFT")
		tipsBackground:SetPoint("TOPRIGHT", eb, "BOTTOMRIGHT")
		tipsBackground:SetPoint("BOTTOM", tipsText, 0, -2)
		-- tipsBackground:SetHeight(41)
		tipsBackground:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
		tipsBackground:SetBackdropColor(.1, .1, .1, .9)
		tipsBackground:SetFrameStrata("HIGH")
	end
	
	addon.popupEditBox:SetScript("OnEnterPressed", function(self)
		if multiLine and IsShiftKeyDown() then -- new line
			self:Insert("\n")
		else
			func(self:GetText())
			self:Hide()
			self:SetText("")
		end
	end)

	-- set parent(for hiding) & size
	addon.popupEditBox:ClearAllPoints()
	addon.popupEditBox:SetParent(parent)
	addon.popupEditBox:SetWidth(width)
	addon.popupEditBox:SetFrameStrata("DIALOG")

	return addon.popupEditBox
end

-----------------------------------------
-- cascaded menu
-----------------------------------------
local menu = addon:CreateFrame(addonName.."CascadedMenu", UIParent, 100, 20)
addon.menu = menu
tinsert(UISpecialFrames, menu:GetName())
menu:SetBackdropColor(.12, .12, .12, 1)
menu:SetBackdropBorderColor(classColor.t[1], classColor.t[2], classColor.t[3], 1)
menu:SetFrameStrata("TOOLTIP")
menu.items = {}

-- items: menu items table
-- itemTable: table to store item buttons --> menu/submenu
-- itemParent: menu/submenu
-- level: menu level, 0, 1, 2, 3, ...
local function CreateItemButtons(items, itemTable, itemParent, level)
	itemParent:SetScript("OnHide", function(self) self:Hide() end)

	for i, item in pairs(items) do
		local b
		if itemTable[i] and itemTable[i]:GetObjectType() == "Button" then
			b = itemTable[i]
			b:SetText(item.text)
			if level == 0 then b:Show() end -- show valid top menu buttons
		else
			b = addon:CreateButton(itemParent, item.text, "transparent-class", {98 ,18}, true)
			tinsert(itemTable, b)
			if i == 1 then
				b:SetPoint("TOPLEFT", 1, -1)
				b:SetPoint("RIGHT", -1, 0)
			else
				b:SetPoint("TOPLEFT", itemTable[i-1], "BOTTOMLEFT")
				b:SetPoint("RIGHT", itemTable[i-1])
			end
		end

		if item.textColor then
			b:GetFontString():SetTextColor(unpack(item.textColor))
		end

		if item.icon then
			if not b.icon then
				b.icon = b:CreateTexture(nil, "ARTWORK")
				b.icon:SetPoint("LEFT", b, 5, 0)
				b.icon:SetSize(14, 14)
				b.icon:SetTexCoord(.08, .92, .08, .92)
			end
			b.icon:SetTexture(item.icon)
			b.icon:Show()
			b:GetFontString():SetPoint("LEFT", b.icon, "RIGHT", 5, 0)
		else
			if b.icon then b.icon:Hide() end
			b:GetFontString():SetPoint("LEFT", 5, 0)
		end

		if level > 0 then
			b:Hide()
			b:SetScript("OnHide", function(self) self:Hide() end)
		end
		
		if item.children then
			-- create sub menu level+1
			if not menu[level+1] then
				-- menu[level+1] parent == menu[level]
				menu[level+1] = addon:CreateFrame(addonName.."CascadedSubMenu"..level, level == 0 and menu or menu[level], 100, 20)
				menu[level+1]:SetBackdropColor(.12, .12, .12, 1)
				menu[level+1]:SetBackdropBorderColor(classColor.t[1], classColor.t[2], classColor.t[3], 1)
				-- menu[level+1]:SetScript("OnHide", function(self) self:Hide() end)
			end

			if not b.childrenSymbol then
				b.childrenSymbol = b:CreateFontString(nil, "OVERLAY", font_name)
				b.childrenSymbol:SetText("|cFF777777>")
				b.childrenSymbol:SetPoint("RIGHT", -5, 0)
			end
			b.childrenSymbol:Show()

			CreateItemButtons(item.children, b, menu[level+1], level+1) -- itemTable == b, insert children to its table
			
			b:SetScript("OnEnter", function()
				b:SetBackdropColor(unpack(b.hoverColor))

				menu[level+1]:Hide()

				menu[level+1]:ClearAllPoints()
				menu[level+1]:SetPoint("TOPLEFT", b, "TOPRIGHT", 2, 1)
				menu[level+1]:Show()

				for _, b in ipairs(b) do
					b:Show()
				end
			end)
		else
			if b.childrenSymbol then b.childrenSymbol:Hide() end

			b:SetScript("OnEnter", function()
				b:SetBackdropColor(unpack(b.hoverColor))

				if menu[level+1] then menu[level+1]:Hide() end
			end)

			b:SetScript("OnClick", function()
				PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
				menu:Hide()
				if item.onClick then item.onClick(item.text) end
			end)
		end
	end

	-- update menu/submenu height
	itemParent:SetHeight(2 + #items*18)
end

function menu:SetItems(items)
	-- clear topmenu
	for _, b in pairs({menu:GetChildren()}) do
		if b:GetObjectType() == "Button" then
			b:Hide()
		end
	end
	-- create buttons
	CreateItemButtons(items, menu.items, menu, 0)
end

function menu:SetWidths(...)
	local widths = {...}
	menu:SetWidth(widths[1])
	if #widths == 1 then
		for _, m in ipairs(menu) do
			m:SetWidth(widths[1])
		end
	else
		for i, m in ipairs(menu) do
			if widths[i+1] then m:SetWidth(widths[i+1]) end
		end
	end
end

function menu:ShowMenu()
	for i, m in ipairs(menu) do
		m:Hide()
	end
	menu:Show()
end

function menu:SetMenuParent(parent)
	menu:SetParent(parent)
	menu:SetFrameStrata("TOOLTIP")
end

-----------------------------------------------------------------------------------
-- create scroll frame (with scrollbar & content frame) 2017-07-17 08:40:41
-----------------------------------------------------------------------------------
function addon:CreateScrollFrame(parent, top, bottom, color, border)
	-- create scrollFrame & scrollbar seperately (instead of UIPanelScrollFrameTemplate), in order to custom it
	local scrollFrame = CreateFrame("ScrollFrame", parent:GetName().."ScrollFrame", parent)
	parent.scrollFrame = scrollFrame
	top = top or 0
	bottom = bottom or 0
	scrollFrame:SetPoint("TOPLEFT", 0, top) 
	scrollFrame:SetPoint("BOTTOMRIGHT", 0, bottom)

	if color then
		addon:StylizeFrame(scrollFrame, color, border)
	end

	function scrollFrame:Resize(newTop, newBottom)
		top = newTop
		bottom = newBottom
		scrollFrame:SetPoint("TOPLEFT", 0, top) 
		scrollFrame:SetPoint("BOTTOMRIGHT", 0, bottom)
	end
	
	-- content
	local content = CreateFrame("Frame", nil, scrollFrame)
	content:SetSize(scrollFrame:GetWidth(), 20)
	scrollFrame:SetScrollChild(content)
	scrollFrame.content = content
	-- content:SetFrameLevel(2)
	
	-- scrollbar
	local scrollbar = CreateFrame("Frame", nil, scrollFrame)
	scrollbar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", 2, 0)
	scrollbar:SetPoint("BOTTOMRIGHT", scrollFrame, 7, 0)
	scrollbar:Hide()
	addon:StylizeFrame(scrollbar, {.1, .1, .1, .8})
	scrollFrame.scrollbar = scrollbar
	
	-- scrollbar thumb
	local scrollThumb = CreateFrame("Frame", nil, scrollbar)
	scrollThumb:SetWidth(5) -- scrollbar's width is 5
	scrollThumb:SetHeight(scrollbar:GetHeight())
	scrollThumb:SetPoint("TOP")
	addon:StylizeFrame(scrollThumb, {classColor.t[1], classColor.t[2], classColor.t[3], .8})
	scrollThumb:EnableMouse(true)
	scrollThumb:SetMovable(true)
	scrollThumb:SetHitRectInsets(-5, -5, 0, 0) -- Frame:SetHitRectInsets(left, right, top, bottom)
	
	-- reset content height manually ==> content:GetBoundsRect() make it right @OnUpdate
	function scrollFrame:ResetHeight()
		content:SetHeight(20)
	end
	
	-- reset to top, useful when used with DropDownMenu (variable content height)
	function scrollFrame:ResetScroll()
		scrollFrame:SetVerticalScroll(0)
	end
	
	-- local scrollRange -- ACCURATE scroll range, for SetVerticalScroll(), instead of scrollFrame:GetVerticalScrollRange()
	function scrollFrame:VerticalScroll(step)
		local scroll = scrollFrame:GetVerticalScroll() + step
		-- if CANNOT SCROLL then scroll = -25/25, scrollFrame:GetVerticalScrollRange() = 0
		-- then scrollFrame:SetVerticalScroll(0) and scrollFrame:SetVerticalScroll(scrollFrame:GetVerticalScrollRange()) ARE THE SAME
		if scroll <= 0 then
			scrollFrame:SetVerticalScroll(0)
		elseif  scroll >= scrollFrame:GetVerticalScrollRange() then
			scrollFrame:SetVerticalScroll(scrollFrame:GetVerticalScrollRange())
		else
			scrollFrame:SetVerticalScroll(scroll)
		end
	end

	-- to remove/hide widgets "widget:SetParent(nil)" MUST be called!!!
	scrollFrame:SetScript("OnUpdate", function()
		-- set content height, check if it CAN SCROLL
		content:SetHeight(select(4, content:GetBoundsRect()))
	end)
	
	-- stores all widgets on content frame
	local autoWidthWidgets = {}

	function scrollFrame:ClearContent()
		for _, c in pairs({content:GetChildren()}) do
			c:SetParent(nil)  -- or it will show (OnUpdate)
			c:ClearAllPoints()
			c:Hide()
		end
		wipe(autoWidthWidgets)
		scrollFrame:ResetHeight()
	end

	function scrollFrame:Reset()
		scrollFrame:ResetScroll()
		scrollFrame:ClearContent()
	end
	
	function scrollFrame:SetWidgetAutoWidth(widget)
		table.insert(autoWidthWidgets, widget)
	end
	
	-- on width changed, make the same change to widgets
	scrollFrame:SetScript("OnSizeChanged", function()
		-- change widgets width (marked as auto width)
		for i = 1, #autoWidthWidgets do
			autoWidthWidgets[i]:SetWidth(scrollFrame:GetWidth())
		end
		
		-- update content width
		content:SetWidth(scrollFrame:GetWidth())
	end)

	-- check if it can scroll
	content:SetScript("OnSizeChanged", function()
		-- set ACCURATE scroll range
		-- scrollRange = content:GetHeight() - scrollFrame:GetHeight()

		-- set thumb height (%)
		local p = scrollFrame:GetHeight() / content:GetHeight()
		p = tonumber(string.format("%.3f", p))
		if p < 1 then -- can scroll
			scrollThumb:SetHeight(scrollbar:GetHeight()*p)
			-- space for scrollbar
			scrollFrame:SetPoint("BOTTOMRIGHT", parent, -7, bottom)
			scrollbar:Show()
		else
			scrollFrame:SetPoint("BOTTOMRIGHT", parent, 0, bottom)
			scrollbar:Hide()
		end
	end)

	-- DO NOT USE OnScrollRangeChanged to check whether it can scroll.
	-- "invisible" widgets should be hidden, then the scroll range is NOT accurate!
	-- scrollFrame:SetScript("OnScrollRangeChanged", function(self, xOffset, yOffset) end)
	
	-- dragging and scrolling
	scrollThumb:SetScript("OnMouseDown", function(self, button)
		if button ~= 'LeftButton' then return end
		local offsetY = select(5, scrollThumb:GetPoint(1))
		local mouseY = select(2, GetCursorPosition())
		local currentScroll = scrollFrame:GetVerticalScroll()
		self:SetScript("OnUpdate", function(self)
			--------------------- y offset before dragging + mouse offset
			local newOffsetY = offsetY + (select(2, GetCursorPosition()) - mouseY)
			
			-- even scrollThumb:SetPoint is already done in OnVerticalScroll, but it's useful in some cases.
			if newOffsetY >= 0 then -- @top
				scrollThumb:SetPoint("TOP")
				newOffsetY = 0
			elseif (-newOffsetY) + scrollThumb:GetHeight() >= scrollbar:GetHeight() then -- @bottom
				scrollThumb:SetPoint("TOP", 0, -(scrollbar:GetHeight() - scrollThumb:GetHeight()))
				newOffsetY = -(scrollbar:GetHeight() - scrollThumb:GetHeight())
			else
				scrollThumb:SetPoint("TOP", 0, newOffsetY)
			end
			local vs = (-newOffsetY / (scrollbar:GetHeight()-scrollThumb:GetHeight())) * scrollFrame:GetVerticalScrollRange()
			scrollFrame:SetVerticalScroll(vs)
		end)
	end)

	scrollThumb:SetScript("OnMouseUp", function(self)
		self:SetScript("OnUpdate", nil)
	end)
	
	scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
		local scrollP = scrollFrame:GetVerticalScroll()/scrollFrame:GetVerticalScrollRange()
		local yoffset = -((scrollbar:GetHeight()-scrollThumb:GetHeight())*scrollP)
		scrollThumb:SetPoint("TOP", 0, yoffset)
	end)
	
	local step = 25
	function scrollFrame:SetScrollStep(s)
		step = s
	end
	
	-- enable mouse wheel scroll
	scrollFrame:EnableMouseWheel(true)
	scrollFrame:SetScript("OnMouseWheel", function(self, delta)
		if delta == 1 then -- scroll up
			scrollFrame:VerticalScroll(-step)
		elseif delta == -1 then -- scroll down
			scrollFrame:VerticalScroll(step)
		end
	end)
	
	return scrollFrame
end

-----------------------------------------
-- binding button
-----------------------------------------
local function CreateGrid(parent, text, width)
	local grid = CreateFrame("Button", nil, parent)
	grid:SetFrameLevel(6)
	grid:SetSize(width, 20)
	grid:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1})
	grid:SetBackdropColor(0, 0, 0, 0) 
	grid:SetBackdropBorderColor(0, 0, 0, 1)

	-- to avoid SetText("") -> GetFontString() == nil
	grid.text = grid:CreateFontString(nil, "OVERLAY", font_name)
	grid.text:SetWordWrap(false)
	grid.text:SetJustifyH("LEFT")
	grid.text:SetPoint("LEFT", 5, 0)
	grid.text:SetPoint("RIGHT", -5, 0)
	grid.text:SetText(text)

	function grid:SetText(s)
		grid.text:SetText(s)
	end

	function grid:GetText()
		return grid.text:GetText()
	end

	function grid:IsTruncated()
		return grid.text:IsTruncated()
	end

	grid:RegisterForClicks("LeftButtonUp", "RightButtonUp")

	grid:SetScript("OnEnter", function() 
		grid:SetBackdropColor(classColor.t[1], classColor.t[2], classColor.t[3], .15)
		parent:Highlight()
	end)

	grid:SetScript("OnLeave", function()
		grid:SetBackdropColor(0, 0, 0, 0)
		parent:Unhighlight()
	end)

	return grid
end

function addon:CreateBindingButton(parent, modifier, bindKey, bindType, bindAction)
	local b = CreateFrame("Button", nil, parent)
	b:SetFrameLevel(5)
	b:SetSize(100, 20)
	b:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1})
	b:SetBackdropColor(.12, .12, .12, 1) 
    b:SetBackdropBorderColor(0, 0, 0, 1)

	function b:Highlight()
		b:SetBackdropColor(classColor.t[1], classColor.t[2], classColor.t[3], .1)
	end

	function b:Unhighlight()
		b:SetBackdropColor(.12, .12, .12, 1)
	end

	local keyGrid = CreateGrid(b, modifier..bindKey, 127)
	b.keyGrid = keyGrid
	keyGrid:SetPoint("LEFT")

	local typeGrid = CreateGrid(b, bindType, 65)
	b.typeGrid = typeGrid
	typeGrid:SetPoint("LEFT", keyGrid, "RIGHT", -1, 0)

	local actionGrid = CreateGrid(b, bindAction, 100)
	b.actionGrid = actionGrid
	actionGrid:SetPoint("LEFT", typeGrid, "RIGHT", -1, 0)
	actionGrid:SetPoint("RIGHT")

	if actionGrid:IsTruncated() then
		SetTooltip(actionGrid, "ANCHOR_TOPLEFT", 1, 0, L["Action"], bindAction)
	end

	function b:SetBorderColor(...)
		keyGrid:SetBackdropBorderColor(...)
		typeGrid:SetBackdropBorderColor(...)
		actionGrid:SetBackdropBorderColor(...)
	end

	function b:SetChanged(isChanged)
		if isChanged then
			b:SetBorderColor(classColor.t[1], classColor.t[2], classColor.t[3], 1)
		else
			b:SetBorderColor(0, 0, 0, 1)
		end
	end

	return b
end