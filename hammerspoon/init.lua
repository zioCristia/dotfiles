-- Require necessary Hammerspoon modules
local hotkey = require("hs.hotkey")
local application = require("hs.application")

-- Create the modal environment (F17 is used as the base modal trigger here)
local hyper = hotkey.modal.new({}, "F17")

-- Bind F18 so that holding it enters the modal, and releasing it exits
local function pressed() hyper:enter() end
local function released() hyper:exit() end
hotkey.bind({}, 'F18', pressed, released)

-- ==========================================
-- Application Bindings
-- ==========================================
hyper:bind({}, "t", function() application.launchOrFocus("Terminal") end)
hyper:bind({}, "c", function() application.launchOrFocus("Calendar") end)
hyper:bind({}, "f", function() application.launchOrFocus("Finder") end)
hyper:bind({}, "r", function() application.launchOrFocus("Google Chrome") end) 
hyper:bind({}, "n", function() application.launchOrFocus("Notes") end)
hyper:bind({}, "s", function() application.launchOrFocus("Safari") end)
hyper:bind({}, "y", function() application.launchOrFocus("Symphony") end)
hyper:bind({}, "u", function() application.launchOrFocus("Calculator") end)
hyper:bind({}, "p", function() application.launchOrFocus("Activity Monitor") end)
hyper:bind({}, "v", function() application.launchOrFocus("Visual Studio Code") end) 
hyper:bind({}, "z", function() application.launchOrFocus("Zed") end) 

-- ==========================================
-- Desktop / Space Switching (AppleScript Fix)
-- ==========================================
-- AppleScript key codes: 123 = Left, 124 = Right, 125 = Down, 126 = Up

hyper:bind({}, "h", function()
    hs.osascript.applescript('tell application "System Events" to key code 123 using control down')
end)

hyper:bind({}, "l", function()
    hs.osascript.applescript('tell application "System Events" to key code 124 using control down')
end)

hyper:bind({}, "k", function()
    hs.osascript.applescript('tell application "System Events" to key code 126 using control down')
end)

hyper:bind({}, "j", function()
    hs.osascript.applescript('tell application "System Events" to key code 125 using control down')
end)

 -- ==========================================
-- System & Hammerspoon Shortcuts
-- ==========================================
-- Reload Hammerspoon configuration
hyper:bind({ "cmd", "ctrl" }, "r", function() hs.reload() end)
hyper:bind({ "cmd", "shift" }, "r", function() hs.reload() end)

-- Show a brief alert when the config loads successfully
hs.alert.show("Hammerspoon config loaded")
