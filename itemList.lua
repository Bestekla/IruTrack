require "itemDB"

local itemList = {}

function showItemTrackerFrame()
    IruTrack_itemTracker:Show();
    print('BIEM');
end

function populateItemList()
    local itemLink = select(2, GetItemInfo(19019));
    IruTrack_item.link:SetText(itemLink);
    print(itemLink);
    print('NOG EEN BIEM!');
end