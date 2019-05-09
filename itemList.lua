local IruTrack_itemList = {}

function IruTrack_showItemTrackerFrame()
    IruTrack_itemTracker:Show();
end

function IruTrack_createItemFrames()

	for fnr=1,10 do
        local item = CreateFrame("Frame", "IruTrack_item" .. fnr, self, "IruTrack_itemTemplate");
        if fnr == 1 then
            item:SetPoint("TOP", "IruTrack_itemTracker_content", "TOP", 0, -3);
        else
            item:SetPoint("TOP", "IruTrack_item" .. fnr-1, "BOTTOM", 0, -3);
        end
        item:SetParent("IruTrack_itemTracker_content");
        item:Hide();
        IruTrack_itemList[fnr] = item;
    end
end

function IruTrack_findItem(itemID)
	local ret;
	for k, v in ipairs(IruTrack_ItemsForChar) do
		if v.itemID == itemID then
			ret = v;
		end
	end
	return ret;
end

function IruTrack_clearItemList()
    for k, v in pairs(IruTrack_itemList) do
    	v.link:SetText("");
    	v:Hide();
    end
end

function IruTrack_populateItemList(zone)
    
    IruTrack_clearItemList();
    local fnr = 1;
    for k, v in ipairs(IruTrack_ItemsForChar) do
    	if v.zone == zone and v.tracked == true then
    		local itemLink = select(2,GetItemInfo(v.itemID));
    		if itemLink == nil then
    			itemLink = v.itemID;
    		end
    		IruTrack_itemList[fnr].link:SetText(itemLink);
    		IruTrack_itemList[fnr]:Show();
    		fnr = fnr + 1;
    	end
    end
end

function IruTrack_updateItemInlist(itemID)
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

function IruTrack_setAdditionalTooltipInfo(itemLink)
    local itemID = select(2,strsplit(":", string.match(itemLink, "item[%-?%d:]+")));
    itemID = tonumber(itemID);
    local item = IruTrack_findItem(itemID);
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
		IruTrack_setAdditionalTooltipInfo(self.link:GetText());
	else
		GameTooltip:AddLine("This item has not been seen on the server yet, so instead it's ID is shown here.", true);
	end
		GameTooltip:Show();

end

function IruTrack_itemOnLeave(self, motion)
	GameTooltip:Hide();
end

function IruTrack_onLoad(self)
    self:RegisterEvent("ADDON_LOADED");
end
 
function IruTrack_handleEvent(self, event,  ...)

    if event == "ADDON_LOADED" then
        if select(1, ...) == "IruTrack" then
            self:UnregisterEvent("ADDON_LOADED");
            if IruTrack_ItemsForChar == nil then
            	IruTrack_initializeSavedVariables();
            end
            IruTrack_createItemFrames();
            IruTrack_showItemTrackerFrame();
            self:RegisterEvent("GET_ITEM_INFO_RECEIVED");
            self:RegisterEvent("ZONE_CHANGED_NEW_AREA");
            IruTrack_populateItemList(GetRealZoneText());
        end
    end
    if event == "ZONE_CHANGED_NEW_AREA" then
        IruTrack_populateItemList(GetRealZoneText());
    end
    if event == "GET_ITEM_INFO_RECEIVED" then
    	if select(2, ...) == true then
    		IruTrack_updateItemInlist(select(1, ...));
    	end
    end
end
