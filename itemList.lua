
local IruTrack_itemList = {}

function IruTrack_showItemTrackerFrame()
    IruTrack_itemTracker:Show();
    print('BIEM');
end

function IruTrack_createItemFrames()

	for fnr=1,10 do
        local item = CreateFrame("Frame", "IruTrack_item" .. fnr, self, "IruTrack_itemTemplate");
        if k == 1 then
            item:SetPoint("TOP", "IruTrack_itemTracker_content", "TOP", 0, -3);
        else
            item:SetPoint("TOP", "IruTrack_item" .. k-1, "BOTTOM", 0, -3);
        end
        item:SetParent("IruTrack_itemTracker_content");
        item:Hide();
        IruTrack_itemList[k] = item;
    end
end

function IruTrack_clearItemList()
	print('CLEAR');
    for k, v in pairs(IruTrack_itemList) do
    	v.link:SetText("");
    	v:Hide();
    end
end

function IruTrack_populateItemList(zone)
    
    IruTrack_clearItemList();
    print('POPULATE');
    local fnr = 1;
    for k, v in pairs(IruTrack_itemDB) do
    	if v.zone == zone and v.tracked == true then
    		local itemLink = select(2,GetItemInfo(v.itemID));
    		if itemLink == nil then
    			itemLink = v.itemID;
    		end
    		IruTrack_itemList[fnr].link:setText(itemLink);
    		IruTrack_itemList[fnr]:Show();
    		fnr++;
    	end
    end
        
    print('NOG EEN BIEM!');

end

function IruTrack_copyToSavedVariables()
	--localizedClass, englishClass, classIndex    = UnitClass("player");
end

function IruTrack_itemOnEnter(self, motion)
	if self.link then
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM");
		GameTooltip:SetHyperlink(self.link:GetText());
		GameTooltip:Show();
	end
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
            self:RegisterEvent("ZONE_CHANGED_NEW_AREA");
        end
    end
    if event == "ZONE_CHANGED_NEW_AREA" then
        print('HOI');
        IruTrack_populateItemList(GetRealZoneText());
    end

    --GET_ITEM_INFO_RECEIVED
end
