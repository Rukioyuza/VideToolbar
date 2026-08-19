--!strict

local Vide = require("@game/ReplicatedStorage/Packages/vide")
local Theme = require("./Theme")

local TextService = game:GetService("TextService")

export type ButtonProps = {
	read icon: string?,
	read label: string?,
	read tooltip: string?,
	read disabled: (() -> boolean)?,
	read selected: (() -> boolean)?,
	read activated: () -> (),
}

local UNBOUNDED = Vector2.new(math.huge, math.huge)

local function never(): boolean
	return false
end

local function measureWidth(icon: string?, label: string?): number
	if label == nil then
		return Theme.buttonHeight
	end

	local width = Theme.padding * 2
	if icon then
		width += Theme.iconSize + Theme.gap
	end
	local bounds = TextService:GetTextSize(label, Theme.textSize, Theme.font, UNBOUNDED)
	return width + math.ceil(bounds.X)
end

local function Tooltip(text: string): TextLabel
	return Vide.create("TextLabel")({
		Name = "Tooltip",
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 1, Theme.gap * 2),
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Theme.tooltipBackground,
		Text = text,
		TextColor3 = Theme.text,
		Font = Theme.font,
		TextSize = Theme.tooltipTextSize,

		Vide.create("UICorner")({ CornerRadius = Theme.cornerRadius }),
		Vide.create("UIPadding")({
			PaddingTop = UDim.new(0, Theme.gap),
			PaddingBottom = UDim.new(0, Theme.gap),
			PaddingLeft = UDim.new(0, Theme.padding),
			PaddingRight = UDim.new(0, Theme.padding),
		}),
	})
end

local function Button(props: ButtonProps): TextButton
	assert(props.icon ~= nil or props.label ~= nil, "Button needs an Icon, a Label or both")

	local isDisabled = props.disabled or never
	local isSelected = props.selected or never
	local hovered = Vide.source(false)
	local pressed = Vide.source(false)
	local tooltipShown = Vide.source(false)
	local pendingTooltip: thread? = nil

	local function cancelPendingTooltip(): ()
		if pendingTooltip then
			task.cancel(pendingTooltip)
			pendingTooltip = nil
		end
	end

	local function hideTooltip(): ()
		cancelPendingTooltip()
		tooltipShown(false)
	end

	Vide.cleanup(cancelPendingTooltip)

	local function showsHover(): boolean
		return hovered() and not isDisabled()
	end

	local function showsPress(): boolean
		return pressed() and not isDisabled()
	end

	local function contentTransparency(): number
		return if isDisabled() then Theme.disabledTransparency else 0
	end

	local iconImage = nil
	if props.icon then
		iconImage = Vide.create("ImageLabel")({
			Name = "Icon",
			LayoutOrder = 1,
			Size = UDim2.fromOffset(Theme.iconSize, Theme.iconSize),
			BackgroundTransparency = 1,
			Image = props.icon,
			ImageColor3 = Theme.text,
			ImageTransparency = contentTransparency,
		})
	end

	local labelText = nil
	if props.label then
		labelText = Vide.create("TextLabel")({
			Name = "Label",
			LayoutOrder = 2,
			Size = UDim2.fromScale(0, 1),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			Text = props.label,
			TextColor3 = Theme.text,
			TextTransparency = contentTransparency,
			Font = Theme.font,
			TextSize = Theme.textSize,
		})
	end

	local function tooltipVisible(): boolean
		return tooltipShown() and not isDisabled()
	end

	local tooltipChild = nil
	local tooltipText = props.tooltip
	if tooltipText then
		local text: string = tooltipText
		tooltipChild = Vide.show(tooltipVisible, function(): TextLabel
			return Tooltip(text)
		end)
	end

	return Vide.create("TextButton")({
		Name = props.label or "Button",
		Size = UDim2.fromOffset(measureWidth(props.icon, props.label), Theme.buttonHeight),
		AutoButtonColor = false,
		Text = "",

		BackgroundColor3 = function(): Color3
			if showsPress() then
				return Theme.pressed
			end
			if isSelected() and showsHover() then
				return Theme.selectedHover
			end
			if isSelected() then
				return Theme.selected
			end
			return Theme.hover
		end,

		BackgroundTransparency = function(): number
			if showsPress() or showsHover() or isSelected() then
				return 0
			end
			return 1
		end,

		MouseEnter = function(): ()
			hovered(true)
			if tooltipText and pendingTooltip == nil then
				pendingTooltip = task.delay(Theme.tooltipDelay, function(): ()
					pendingTooltip = nil
					tooltipShown(true)
				end)
			end
		end,

		MouseLeave = function(): ()
			hovered(false)
			pressed(false)
			hideTooltip()
		end,

		MouseButton1Down = function(): ()
			pressed(true)
		end,

		MouseButton1Up = function(): ()
			pressed(false)
		end,

		Activated = function(): ()
			hideTooltip()
			if isDisabled() then
				return
			end
			props.activated()
		end,

		Vide.create("UICorner")({ CornerRadius = Theme.cornerRadius }),
		Vide.create("Frame")({
			Name = "Content",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,

			Vide.create("UIListLayout")({
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, Theme.gap),
			}),
			iconImage,
			labelText,
		}),
		tooltipChild,
	})
end

return Button
