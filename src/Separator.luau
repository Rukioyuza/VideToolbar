--!strict

local Vide = require("@game/ReplicatedStorage/Packages/vide")
local Theme = require("./Theme")

local function Separator(): Frame
	return Vide.create("Frame")({
		Name = "Separator",
		Size = UDim2.fromOffset(1, Theme.buttonHeight - Theme.gap * 2),
		BackgroundColor3 = Theme.separator,
		BorderSizePixel = 0,
	})
end

return Separator
