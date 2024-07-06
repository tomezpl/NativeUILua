-- exports("NativeUI", NativeUI)

-- Since I can't figure out a way to pass objects with functions between JS and Lua,
-- we'll store the actual pool and menu objects in here and just return indices to the JS.
pools = {}
poolCount = 0
menus = {}
menuCount = 0
menuItems = {}
menuItemCount = 0

function handleIndex(handle, kind)
    return tonumber(string.sub(handle, string.len(kind) + 1))
end

exports('_setEventListener', function(target, event, eventName)
    local targetType = nil
    local targetTable = nil

    if string.find(target, "menuPool") ~= nil then
        targetType = "menuPool"
        targetTable = pools
    elseif string.find(target, "menu") ~= nil then
        targetType = "menu"
        targetTable = menus
    elseif string.find(target, "menuItem") ~= nil then
        targetType = "menuItem"
        targetTable = menuItems
    end

    if event == 'OnListChange' and targetType ~= nil and targetTable ~= nil then 
        targetTable[handleIndex(target, targetType)].OnListChange = function(sender, item, index)
            local itemIndex = -1
            for i=1,menuItemCount do
                if menuItems[i] == item then
                    itemIndex = i
                end
            end
            TriggerEvent(eventName, sender, itemIndex, index)
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
exports("CreateListItem", function(name, options, defaultIndex, description)
    table.insert(menuItems, NativeUI.CreateListItem(name, options, defaultIndex, description))
    menuItemCount = menuItemCount + 1
    return "menuItem" .. menuItemCount
end)
exports("MenuPool:Add", function(menuPool, menu)
    pools[handleIndex(menuPool, "menuPool")]:Add(menus[handleIndex(menu, "menu")])
end)
exports("MenuPool:ProcessMenus", function (menuPool)
    pools[handleIndex(menuPool, "menuPool")]:ProcessMenus()
end)

exports("Menu:Visible", function (menu, visible)
    menus[handleIndex(menu, "menu")]:Visible(visible)
end)
exports("Menu:AddItem", function(menu, menuItem)
    menus[handleIndex(menu, "menu")]:AddItem(menuItems[handleIndex(menuItem, "menuItem")])
end)