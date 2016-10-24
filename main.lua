-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local localizer = require("Localizer");

localizer:setCulture(localizer.Culture.Polish);
print("-------------------------");
print("CULTURE: "..localizer.currentCulture);
print("someText: "..localizer:getTranslation("someText"));
print("mainMenu: "..localizer:getTranslation("mainMenu"));
print("play: "..localizer:getTranslation("play"));

localizer:setCulture(localizer.Culture.English);
print("-------------------------");
print("CULTURE: "..localizer.currentCulture);
print("someText: "..localizer:getTranslation("someText"));
print("mainMenu: "..localizer:getTranslation("mainMenu"));
print("play: "..localizer:getTranslation("play"));

localizer:setCulture(localizer.Culture.Ukrainian);
print("-------------------------");
print("CULTURE: "..localizer.currentCulture);
print("someText: "..localizer:getTranslation("someText"));
print("mainMenu: "..localizer:getTranslation("mainMenu"));
print("play: "..localizer:getTranslation("play"));
