
local itemList = {}

function IruTrack_showItemTrackerFrame()
    IruTrack_itemTracker:Show();
    print('BIEM');
end

function IruTrack_populateItemList()
    
    print('POPULATE');
    for k, v in pairs(IruTrack_itemDB) do
        local item = CreateFrame("Frame", "IruTrack_item" .. k, self, "IruTrack_itemTemplate");
        if k == 1 then
            item:SetPoint("TOP", "IruTrack_itemTracker_content", "TOP", 0, -3);
        else
            item:SetPoint("TOP", "IruTrack_item" .. k-1, "BOTTOM", 0, -3);
        end
        item:SetParent("IruTrack_itemTracker_content");
        item.link:SetText(select(2,GetItemInfo(v.itemID)));
        itemList[k] = item;
    end
        
    print('NOG EEN BIEM!');

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
            IruTrack_showItemTrackerFrame();
            IruTrack_populateItemList();
            self:RegisterEvent("ZONE_CHANGED_NEW_AREA");
        end
    end
    if event == "ZONE_CHANGED_NEW_AREA" then
        print('HOI');
        print(GetRealZoneText());
    end
end
