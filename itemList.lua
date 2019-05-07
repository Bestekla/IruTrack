
local itemList = {}

function showItemTrackerFrame()
    IruTrack_itemTracker:Show();
    print('BIEM');
end

function populateItemList()
    
    print('POPULATE');
    for k, v in pairs(IruTrack_itemDB) do
        local item = CreateFrame("Frame", "IruTrack_item" .. k, self, "IruTrack_itemTemplate");
        if k == 1 then
            item:SetPoint("TOP", "IruTrack_itemTracker_content", "TOP", 0, -3);
        else
            item:SetPoint("TOP", "IruTrack_item" .. k-1, "BOTTOM", 0, -3);
        end
        item.link:SetText(select(2,GetItemInfo(v.itemID)));
        item:SetFrameStrata("HIGH");
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