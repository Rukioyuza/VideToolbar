--!strict

local Vide = require("@game/ReplicatedStorage/Packages/vide")
local Theme = require("./Theme")

export type ToolbarProps = {
	read items: { GuiObject },
	read position: UDim2?,
	read anchorPoint: Vector2?,
}

local function Toolbar(props: ToolbarProps): Frame
	for order, item in props.items do
		item.LayoutOrder = order
	end

	return Vide.create("Frame")({
		Name = "Toolbar",
		Position = props.position,
		AnchorPoint = props.anchorPoint,
		Size = UDim2.fromOffset(0, Theme.barHeight),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = Theme.background,

		Vide.create("UICorner")({ CornerRadius = Theme.cornerRadius }),
		Vide.create("UIStroke")({ Color = Theme.stroke }),
		Vide.create("UIPadding")({
			PaddingLeft = UDim.new(0, Theme.gap),
			PaddingRight = UDim.new(0, Theme.gap),
		}),
		Vide.create("UIListLayout")({
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, Theme.gap),
		}),
		props.items,
	})
end

return Toolbar
