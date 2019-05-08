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

function IruTrack_clearItemList()
    for k, v in pairs(IruTrack_itemList) do
    	v.link:SetText("");
    	v:Hide();
    end
end

function IruTrack_populateItemList(zone)
    
    IruTrack_clearItemList();
    local fnr = 1;
    for k, v in pairs(IruTrack_itemDB) do
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
	for k, v in pairs(IruTrack_itemList) do
		if tonumber(IruTrack_itemList[k].link:GetText()) == itemID then
			IruTrack_itemList[k].link:SetText(select(2,GetItemInfo(itemID)));
		end
	end
end


function IruTrack_copyToSavedVariables()
	--localizedClass, englishClass, classIndex    = UnitClass("player");
end

function IruTrack_itemOnEnter(self, motion)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOM");
	if tonumber(self.link:GetText()) == nil then
		GameTooltip:SetHyperlink(self.link:GetText());
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
