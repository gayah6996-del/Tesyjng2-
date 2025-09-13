-- Menu Module
local Menu = {
    isOpen = false,
    options = {},
    selectedIndex = 1
}

-- Initialize menu with options
function Menu:new(menuOptions)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.options = menuOptions or {}
    return obj
end

-- Open the menu
function Menu:open()
    self.isOpen = true
    self:display()
end

-- Close the menu
function Menu:close()
    self.isOpen = false
    print("Menu closed.")
end

-- Display menu options
function Menu:display()
    if not self.isOpen then return end
    
    print("--- MENU ---")
    for i, option in ipairs(self.options) do
        if i == self.selectedIndex then
            print("> " .. option)
        else
            print("  " .. option)
        end
    end
    print("------------")
end

-- Navigate menu
function Menu:navigate(direction)
    if not self.isOpen then return end
    
    if direction == "down" then
        self.selectedIndex = math.min(self.selectedIndex + 1, #self.options)
    elseif direction == "up" then
        self.selectedIndex = math.max(self.selectedIndex - 1, 1)
    end
    
    self:display()
end

-- Select current option
function Menu:select()
    if not self.isOpen then return end
    
    local selectedOption = self.options[self.selectedIndex]
    print("Selected: " .. selectedOption)
    self:close()
end

-- Example usage
local menuOptions = {"Start Game", "Options", "Exit"}
local gameMenu = Menu:new(menuOptions)

-- Simulate menu interactions
gameMenu:open()
gameMenu:navigate("down")
gameMenu:navigate("down")
gameMenu:select()
