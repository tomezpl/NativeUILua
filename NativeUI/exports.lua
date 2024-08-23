-- exports("NativeUI", NativeUI)

-- Since I can't figure out a way to pass objects with functions between JS and Lua,
-- we'll store the actual pool and menu objects in here and just return indices to the JS.
pools = {}
poolCount = 0
menus = {}
menuCount = 0
menuItems = {}
menuItemCount = 0
windows = {}
windowCount = 0
panels = {}
panelCount = 0

function handleIndex(handle, kind)
    return tonumber(string.sub(handle, string.len(kind) + 1))
end

exports('_setEventListener', function(target, event, eventName)
    local targetType = nil
    local targetTable = nil

    if string.find(target, "menuPool") ~= nil then
        targetType = "menuPool"
        targetTable = pools
    elseif string.find(target, "menuItem") ~= nil then
        targetType = "menuItem"
        targetTable = menuItems
    elseif string.find(target, "menu") ~= nil then
        targetType = "menu"
        targetTable = menus
    end

    if targetType ~= nil and targetTable ~= nil then
        if (string.find(event, 'OnListChange') ~= nil or string.find(event, 'OnSliderChange') ~= nil) then 
            targetTable[handleIndex(target, targetType)][event] = function(sender, item, index)
                local itemIndex = -1
                for i=1,menuItemCount do
                    if menuItems[i] == item then
                        itemIndex = i
                    end
                end
                -- We're sending nil instead of sender because it takes an enormous amount of time to serialize
                TriggerEvent(eventName, nil, "menuItem" .. itemIndex, index)
            end
        end

        if event == 'OnMenuChanged' then
            targetTable[handleIndex(target, targetType)][event] = function(parent, menu, forward) 
                local menuIndex = -1
                for i=1,menuCount do
                    if menus[i] == menu then
                        menuIndex = i
                    end
                end

                TriggerEvent(eventName, nil, "menu" .. menuIndex, forward)
            end
        end

        if event == 'OnMenuClosed' then
            targetTable[handleIndex(target, targetType)][event] = function()
                TriggerEvent(eventName)
            end
        end

        if event == 'OnItemSelect' then
            targetTable[handleIndex(target, targetType)][event] = function(sender, item, index)
                TriggerEvent(eventName, nil, nil, index)
            end
        end

        if event == 'Activated' then
            targetTable[handleIndex(target, targetType)][event] = function()
                -- Not sending any params as they're not needed atm
                TriggerEvent(eventName)
            end
        end
    end
end)


exports("CreatePool", function()
    table.insert(pools, NativeUI.CreatePool())
    poolCount = poolCount + 1
    return "menuPool" .. poolCount
end)
exports("CreateMenu", function(name, colour, width, height)
    table.insert(menus, NativeUI.CreateMenu(name, colour, width, height))
    menuCount = menuCount + 1
    return "menu" .. menuCount
end)
exports("CreateItem", function(...)
    table.insert(menuItems, NativeUI.CreateItem(...))
    menuItemCount = menuItemCount + 1
    return "menuItem" .. menuItemCount
end)
exports("CreateListItem", function(name, options, defaultIndex, description)
    table.insert(menuItems, NativeUI.CreateListItem(name, options, defaultIndex, description))
    menuItemCount = menuItemCount + 1
    return "menuItem" .. menuItemCount
end)
exports("CreateSliderItem", function(...)
    table.insert(menuItems, NativeUI.CreateSliderItem(...))
    menuItemCount = menuItemCount + 1
    return "menuItem" .. menuItemCount
end)
exports("CreateHeritageWindow", function(...)
    table.insert(windows, NativeUI.CreateHeritageWindow(...))
    windowCount = windowCount + 1
    return "window" .. windowCount
end)
exports("CreateColourPanel", function(...)
    table.insert(panels, NativeUI.CreateColourPanel(...))
    panelCount = panelCount + 1
    return "panel" .. panelCount
end)
exports("CreatePercentagePanel", function(...)
    table.insert(panels, NativeUI.CreatePercentagePanel(...))
    panelCount = panelCount + 1
    return "panel" .. panelCount
end)

exports("MenuPool:Add", function(menuPool, menu)
    pools[handleIndex(menuPool, "menuPool")]:Add(menus[handleIndex(menu, "menu")])
end)
exports("MenuPool:ProcessMenus", function (menuPool)
    pools[handleIndex(menuPool, "menuPool")]:ProcessMenus()
end)
exports("MenuPool:AddSubMenu", function (menuPool, parentMenu, ...)
    table.insert(menus, pools[handleIndex(menuPool, "menuPool")]:AddSubMenu(menus[handleIndex(parentMenu, "menu")], ...))
    menuCount = menuCount + 1
    return "menu" .. menuCount
end)

exports("Menu:Visible", function (menu, visible)
    menus[handleIndex(menu, "menu")]:Visible(visible)
end)
exports("Menu:AddItem", function(menu, menuItem)
    menus[handleIndex(menu, "menu")]:AddItem(menuItems[handleIndex(menuItem, "menuItem")])
end)
exports("Menu:AddWindow", function(menu, window) 
    menus[handleIndex(menu, "menu")]:AddWindow(windows[handleIndex(window, "window")])
end)
exports("Menu:Clear", function(menu)
    menus[handleIndex(menu, "menu")]:Clear()
end)

exports("Window:Index", function(window, index1, index2)
    windows[handleIndex(window, "window")]:Index(index1, index2)
end)

exports("MenuItem:Index", function(menuItem, index)
    return menuItems[handleIndex(menuItem, "menuItem")]:Index(index)
end)

exports("MenuListItem:Index", function(menuListItem, index)
    return menuItems[handleIndex(menuListItem, "menuItem")]:Index(index)
end)
exports("MenuListItem:IndexToItem", function(menuListItem, index)
    local item = menuItems[handleIndex(menuListItem, "menuItem")]
    for i = 1,menuItemCount do 
        if menuItems[i] == item then 
            return "menuItem" .. i
        end
    end
end)
exports("MenuListItem:AddPanel", function(menuListItem, panel)
    menuItems[handleIndex(menuListItem, "menuItem")]:AddPanel(panels[handleIndex(panel, "panel")])
end)
exports("MenuListItem:RemovePanelAt", function(menuListItem, panelIndex)
    menuItems[handleIndex(menuListItem, "menuItem")]:RemovePanelAt(panelIndex)
end)
exports("MenuListItem:getPanelValue", function(menuListItem, panelIndex)
    local panel = menuItems[handleIndex(menuListItem, "menuItem")].Panels[panelIndex]
    if panel ~= nil and panel.CurrentSelection ~= nil then
        return panel:CurrentSelection()
    end

    return nil
end)
exports("MenuListItem:doesPanelExist", function(menuListItem, panelIndex)
    local panel = menuItems[handleIndex(menuListItem, "menuItem")].Panels[panelIndex]
    return panel ~= nil
end)
exports("MenuListItem:getProp", function(menuListItem, propName)
    return menuItems[handleIndex(menuListItem, "menuItem")][propName]
end)
exports("MenuListItem:setProp", function(menuListItem, propName, propValue)
    menuItems[handleIndex(menuListItem, "menuItem")][propName] = propValue
end)