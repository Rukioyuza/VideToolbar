--!strict

local Theme = {
	background = Color3.fromRGB(30, 31, 36),
	stroke = Color3.fromRGB(58, 60, 68),
	hover = Color3.fromRGB(50, 52, 60),
	pressed = Color3.fromRGB(40, 42, 48),
	selected = Color3.fromRGB(52, 92, 168),
	selectedHover = Color3.fromRGB(64, 106, 184),
	separator = Color3.fromRGB(70, 72, 80),
	text = Color3.fromRGB(232, 233, 237),
	menuBackground = Color3.fromRGB(36, 37, 43),
	tooltipBackground = Color3.fromRGB(16, 16, 20),

	font = Enum.Font.BuilderSansMedium,
	textSize = 15,
	tooltipTextSize = 13,

	barHeight = 38,
	buttonHeight = 30,
	iconSize = 18,
	padding = 8,
	gap = 4,
	cornerRadius = UDim.new(0, 6),
	menuWidth = 180,
	optionHeight = 28,

	tooltipDelay = 0.5,
	disabledTransparency = 0.6,
}

return Theme
