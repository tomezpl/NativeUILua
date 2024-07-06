-- exports("NativeUI", NativeUI)

-- Since I can't figure out a way to pass objects with functions between JS and Lua,
-- we'll store the actual pool and menu objects in here and just return indices to the JS.
pools = {}
poolCount = 0
menus = {}
menuCount = 0

exports("CreatePool", function()
    table.insert(pools, NativeUI.CreatePool())
    poolCount = poolCount + 1
    return poolCount
end)
exports("CreateMenu", function(name, colour, width, height)
    table.insert(menus, NativeUI.CreateMenu(name, colour, width, height))
    menuCount = menuCount + 1
    return menuCount
end)
exports("MenuPool:Add", function(menuPool, menu)
    pools[menuPool]:Add(menus[menu])
end)
exports("MenuPool:ProcessMenus", function (menuPool)
    pools[menuPool]:ProcessMenus()
end)

exports("Menu:Visible", function (menu, visible)
    menus[menu]:Visible(visible)
end)