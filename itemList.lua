require "itemDB"

local itemList = {}

function showItemTrackerFrame()
    IruTrack_itemTracker:Show();
    print('BIEM');
end

function populateItemList()
    local sName, sLink, iRarity, iLevel, iMinLevel, sType, sSubType, iStackCount = GetItemInfo(19019);
    IruTrack_item.link:SetText(sLink);
    print(sLink);
    print('NOG EEN BIEM!');
end