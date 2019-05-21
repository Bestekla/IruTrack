local itemlist = {};

local itemSettings = CreateFrame("Frame", "itemSettingsFrame", UIParent, "IruTrack_itemSettingsTemplate");
itemSettings:SetScript("OnEvent", function(self, event, ...) return self[event] and self[event](self, ...) end)
itemSettings:Show();
itemSettings:RegisterEvent("ADDON_LOADED");
itemSettings.content.list:SetScript("OnMouseWheel", itemSettings_OnMouseWheel);
itemSettings.content.list:EnableMouseWheel(true);


function itemSettings_OnMouseWheel(self, delta)
    print("scroll!!");
    local newValue = self:GetVerticalScroll() - (delta * 20);
    
    if (newValue < 0) then
        newValue = 0;
    elseif (newValue > self:GetVerticalScrollRange()) then
        newValue = self:GetVerticalScrollRange();
    end
    
    self:SetVerticalScroll(newValue);
end

function itemSettings:createItemButtons()

    if IruTrack_ItemsForChar ~= nil then
        fnr = 1;
        for k, v in ipairs(IruTrack_ItemsForChar) do
            print(fnr);
            local item = CreateFrame("Button", "IruTrack_itemButton" .. fnr, self, "IruTrack_itemButtonTemplate");
            if fnr == 1 then
                item:SetPoint("TOP", itemSettings.content.list.items, "TOP", 0, -1);
            else
                item:SetPoint("TOP", "IruTrack_itemButton" .. fnr-1, "BOTTOM", 0, -1);
            end
            item:SetParent(itemSettings.content.list.items);
            local itemLink = select(2,GetItemInfo(v.itemID)) or v.itemID;
            item.link:SetText(itemLink);
            item.itemID = v.itemID;
            --item:Hide();
            itemlist[fnr] = item;
            fnr = fnr+1;
        end
    end
end

function itemSettings:ADDON_LOADED(name)
    if name == "IruTrack" then
        self:UnregisterEvent("ADDON_LOADED");
        itemSettings:createItemButtons();
    end
end