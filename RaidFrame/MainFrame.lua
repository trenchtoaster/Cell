local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local LPP = LibStub:GetLibrary("LibPixelPerfect")

Cell.unitButtons = {
    ["solo"] = {},
    ["party"] = {},
    ["raid"] = {},
    ["npc"] = {},
}
-------------------------------------------------
-- CellMainFrame
-------------------------------------------------

local cellMainFrame = CreateFrame("Frame", "CellMainFrame", UIParent, "SecureFrameTemplate")
Cell.frames.mainFrame = cellMainFrame
cellMainFrame:SetIgnoreParentScale(true)
cellMainFrame:SetFrameStrata("LOW")
-- cellMainFrame:SetClampedToScreen(true)
-- cellMainFrame:SetClampRectInsets(0, 0, 15, 0)

local anchorFrame = CreateFrame("Frame", "CellAnchorFrame", cellMainFrame)
Cell.frames.anchorFrame = anchorFrame
anchorFrame:SetPoint("TOPLEFT", UIParent, "CENTER")
anchorFrame:SetSize(20, 10)
anchorFrame:SetMovable(true)
anchorFrame:SetClampedToScreen(true)

local function RegisterDragForMainFrame(frame)
    -- frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function()
        anchorFrame:StartMoving()
        anchorFrame:SetUserPlaced(false)
    end)
    frame:SetScript("OnDragStop", function()
        anchorFrame:StopMovingOrSizing()
        LPP:SavePixelPerfectPosition(anchorFrame, Cell.vars.currentLayoutTable["position"])
    end)
end

-------------------------------------------------
-- buttons
-------------------------------------------------
local options = Cell:CreateButton(cellMainFrame, "", "red", {20, 10}, false, true, nil, nil, nil, L["Options"])
options:SetPoint("TOPLEFT", anchorFrame)
options:SetFrameStrata("MEDIUM")
RegisterDragForMainFrame(options)
options:SetScript("OnClick", function()
    F:ShowOptionsFrame()
end)

local raid = Cell:CreateButton(cellMainFrame, "", "blue", {20, 10}, false, true, nil, nil, nil, L["Raid"])
raid:SetPoint("LEFT", options, "RIGHT", 1, 0)
raid:SetFrameStrata("MEDIUM")
RegisterDragForMainFrame(raid)
raid:SetScript("OnClick", function()
    F:ShowRaidRosterFrame()
end)

function F:UpdateFrameLock(locked)
    if locked then
        options:RegisterForDrag()
        raid:RegisterForDrag()
    else
        options:RegisterForDrag("LeftButton")
        raid:RegisterForDrag("LeftButton")
    end
end

-------------------------------------------------
-- raid setup
-------------------------------------------------
local raidSetupFrame = CreateFrame("Frame", "CellRaidSetupFrame", cellMainFrame)
Cell.frames.raidSetupFrame = raidSetupFrame
-- raidSetupFrame:SetPoint("LEFT", raid, "RIGHT", 5, 0)
raidSetupFrame:SetSize(70, 15)
raidSetupFrame:Hide()

local raidSetupText = raidSetupFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
raidSetupText:SetFont(raidSetupText:GetFont(), 12, "OUTLINE")
raidSetupText:SetShadowColor(0, 0, 0)
raidSetupText:SetShadowOffset(0, 0)
raidSetupText:SetPoint("CENTER")
raidSetupText:SetJustifyH("CENTER")

local tankIcon = "|TInterface\\AddOns\\Cell\\Media\\Roles\\TANK:0|t"
local healerIcon = "|TInterface\\AddOns\\Cell\\Media\\Roles\\HEALER:0|t"
local damagerIcon = "|TInterface\\AddOns\\Cell\\Media\\Roles\\DAMAGER:0|t"

function F:UpdateRaidSetup()
    raidSetupText:SetText(tankIcon..Cell.vars.role["TANK"]..healerIcon..Cell.vars.role["HEALER"]..damagerIcon..Cell.vars.role["DAMAGER"])
    raidSetupFrame:SetWidth(raidSetupText:GetWidth()+20)
end

-------------------------------------------------
-- group type changed
-------------------------------------------------
local function MainFrame_GroupTypeChanged(groupType)
    if groupType == "raid" then
        if CellDB["raidTools"]["showRaidSetup"] then raidSetupFrame:Show() end
        raid:Show()
    else
        raidSetupFrame:Hide()
        raid:Hide()
    end

    if groupType == "solo" then
        if CellDB["general"]["showSolo"] then
            options:Show()
        else
            options:Hide()
        end
    elseif groupType == "party" then
        if CellDB["general"]["showParty"] then
            options:Show()
        else
            options:Hide()
        end
    else -- raid
        options:Show()
    end
end
Cell:RegisterCallback("GroupTypeChanged", "MainFrame_GroupTypeChanged", MainFrame_GroupTypeChanged)

local function MainFrame_UpdateVisibility()
    if Cell.vars.groupType == "solo" then
        if CellDB["general"]["showSolo"] then
            options:Show()
        else
            options:Hide()
        end
    elseif Cell.vars.groupType == "party" then
        if CellDB["general"]["showParty"] then
            options:Show()
        else
            options:Hide()
        end
    end
end
Cell:RegisterCallback("UpdateVisibility", "MainFrame_UpdateVisibility", MainFrame_UpdateVisibility)

-------------------------------------------------
-- event
-------------------------------------------------
cellMainFrame:RegisterEvent("PET_BATTLE_OPENING_START")
cellMainFrame:RegisterEvent("PET_BATTLE_OVER")
cellMainFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PET_BATTLE_OPENING_START" then
        cellMainFrame:Hide()
    elseif event == "PET_BATTLE_OVER" then
        cellMainFrame:Show()
    end
end)

-------------------------------------------------
-- load & update
-------------------------------------------------
local function MainFrame_UpdateLayout(layout, which)
    F:Debug("|cffffff7fUpdateLayout:|r layout:" .. (layout or "nil") .. " which:" .. (which or "nil"))
    
    layout = Cell.vars.currentLayoutTable
    
    if not which or which == "size" then
        cellMainFrame:SetSize(unpack(layout["size"]))
    end

    if not which or which == "anchor" then
        cellMainFrame:ClearAllPoints()
        raid:ClearAllPoints()
        raidSetupFrame:ClearAllPoints()

        if layout["anchor"] == "BOTTOMLEFT" then
            cellMainFrame:SetPoint("BOTTOMLEFT", anchorFrame, "TOPLEFT", 0, 4)
            raid:SetPoint("BOTTOMLEFT", options, "BOTTOMRIGHT", 1, 0)
            raidSetupFrame:SetPoint("LEFT", raid, "RIGHT", 5, 0)
            
        elseif layout["anchor"] == "BOTTOMRIGHT" then
            cellMainFrame:SetPoint("BOTTOMRIGHT", anchorFrame, "TOPRIGHT", 0, 4)
            raid:SetPoint("BOTTOMRIGHT", options, "BOTTOMLEFT", -1, 0)
            raidSetupFrame:SetPoint("RIGHT", raid, "LEFT", -5, 0)
            
        elseif layout["anchor"] == "TOPLEFT" then
            cellMainFrame:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, -4)
            raid:SetPoint("TOPLEFT", options, "TOPRIGHT", 1, 0)
            raidSetupFrame:SetPoint("LEFT", raid, "RIGHT", 5, 0)
            
        elseif layout["anchor"] == "TOPRIGHT" then
            cellMainFrame:SetPoint("TOPRIGHT", anchorFrame, "BOTTOMRIGHT", 0, -4)
            raid:SetPoint("TOPRIGHT", options, "TOPLEFT", -1, 0)
            raidSetupFrame:SetPoint("RIGHT", raid, "LEFT", -5, 0)
        end
    end

    -- load position
    LPP:LoadPixelPerfectPosition(anchorFrame, Cell.vars.currentLayoutTable["position"])
end
Cell:RegisterCallback("UpdateLayout", "MainFrame_UpdateLayout", MainFrame_UpdateLayout)