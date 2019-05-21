local IruTrack_itemList = {}

--init the tracker frame
local itemTracker = CreateFrame("Frame", "itemTrackerFrame", UIParent, "IruTrack_itemTrackerTemplate");
itemTracker:SetScript("OnEvent", function(self, event, ...) return self[event] and self[event](self, ...) end)
itemTracker:RegisterEvent("ADDON_LOADED");

function itemTracker:createItemFrames()

	for fnr=1,10 do
        local item = CreateFrame("Frame", "IruTrack_item" .. fnr, self, "IruTrack_itemTemplate");
        if fnr == 1 then
            item:SetPoint("TOP", "itemTrackerFrame_content", "TOP", 0, -3);
        else
            item:SetPoint("TOP", "IruTrack_item" .. fnr-1, "BOTTOM", 0, -3);
        end
        item:SetParent("itemTrackerFrame_content");
        item:Hide();
        IruTrack_itemList[fnr] = item;
    end
end

function itemTracker:findItem(itemID)
	local ret;
	for k, v in ipairs(IruTrack_ItemsForChar) do
		if v.itemID == itemID then
			ret = v;
		end
	end
	return ret;
end

function itemTracker:clearItemList()
    for k, v in pairs(IruTrack_itemList) do
    	v.link:SetText("");
    	v:Hide();
    end
end

function itemTracker:populateItemList(zone)
    
    itemTracker:clearItemList();
    local fnr = 1;
    for k, v in ipairs(IruTrack_ItemsForChar) do
    	if v.zone == zone and v.tracked == true then
    		local itemLink = select(2,GetItemInfo(v.itemID)) or v.itemID;
    		IruTrack_itemList[fnr].link:SetText(itemLink);
    		IruTrack_itemList[fnr]:Show();
    		fnr = fnr + 1;
    	end
    end
end

function itemTracker:updateItemInlist(itemID)
    for k, v in ipairs(IruTrack_itemList) do
        if tonumber(IruTrack_itemList[k].link:GetText()) == itemID then
            IruTrack_itemList[k].link:SetText(select(2,GetItemInfo(itemID)));
        end
    end
end


function IruTrack_initializeSavedVariables()
    local class = select(2, UnitClass("player"));
    IruTrack_ItemsForChar = {};
    for _, v in ipairs(IruTrack_itemDB) do
        for i,j in ipairs(v.classes) do
            if j == class then
                table.insert(IruTrack_ItemsForChar, v);
            end
        end
    end
end

function itemTracker:setAdditionalTooltipInfo(itemLink)
    local itemID = select(2,strsplit(":", string.match(itemLink, "item[%-?%d:]+")));
    itemID = tonumber(itemID);
    local item = itemTracker:findItem(itemID);
    local class = select(2, UnitClass("player"));
    local otherClasses = "";

    if item ~= nil then
        if item.source == "drop" then
            GameTooltip:AddLine("Dropped by:");
        elseif item.source == "quest" then
            GameTooltip:AddLine("Reward from:");
        end
        --competition "warning"
        if #item.classes > 1 then
            GameTooltip:AddLine("Item also wanted by:");
            for k, v in ipairs(item.classes) do
                if v ~= class then
                    otherClasses = otherClasses .. v .. " ";
                end
            end
            GameTooltip:AddLine(otherClasses);
        end
    end
end


function IruTrack_itemOnEnter(self, motion)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOM");
	if tonumber(self.link:GetText()) == nil then
		GameTooltip:SetHyperlink(self.link:GetText());
		itemTracker:setAdditionalTooltipInfo(self.link:GetText());
	else
		GameTooltip:AddLine("This item has not been seen on the server yet, so instead it's ID is shown here.", true);
	end
		GameTooltip:Show();

end

function IruTrack_itemOnLeave(self, motion)
	GameTooltip:Hide();
end

 
function itemTracker:ADDON_LOADED(name)
    if name == "IruTrack" then
        self:UnregisterEvent("ADDON_LOADED");
        if IruTrack_ItemsForChar == nil then
        	IruTrack_initializeSavedVariables();
        end
        itemTracker:createItemFrames()
        itemTracker:Show();
        self:RegisterEvent("GET_ITEM_INFO_RECEIVED");
        self:RegisterEvent("ZONE_CHANGED_NEW_AREA");
        itemTracker:populateItemList(GetRealZoneText());
    end
end


function itemTracker:ZONE_CHANGED_NEW_AREA()
    itemTracker:populateItemList(GetRealZoneText());
end

function itemTracker:GET_ITEM_INFO_RECEIVED(itemID, success)
    if success == true then
        itemTracker:updateItemInlist(itemID);
    end
end
