--!strict

local Vide = require("@game/ReplicatedStorage/Packages/vide")
local Button = require("./Button")
local Theme = require("./Theme")

local UserInputService = game:GetService("UserInputService")

type Source<T> = Vide.Source<T>

export type MenuOption = {
	read label: string,
	read disabled: (() -> boolean)?,
	read activated: () -> (),
}

export type MenuProps = {
	read icon: string?,
	read label: string?,
	read tooltip: string?,
	read disabled: (() -> boolean)?,
	read options: { MenuOption },
}

local function never(): boolean
	return false
end

local function isInside(object: GuiObject, position: Vector3): boolean
	local topLeft = object.AbsolutePosition
	local bottomRight = topLeft + object.AbsoluteSize
	local insideX = position.X >= topLeft.X and position.X <= bottomRight.X
	local insideY = position.Y >= topLeft.Y and position.Y <= bottomRight.Y
	return insideX and insideY
end

local function Option(props: MenuOption, order: number, open: Source<boolean>): TextButton
	local isDisabled = props.disabled or never
	local hovered = Vide.source(false)

	return Vide.create("TextButton")({
		Name = props.label,
		LayoutOrder = order,
		Size = UDim2.new(1, 0, 0, Theme.optionHeight),
		AutoButtonColor = false,
		BackgroundColor3 = Theme.hover,
		Text = props.label,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Theme.text,
		Font = Theme.font,
		TextSize = Theme.textSize,

		BackgroundTransparency = function(): number
			return if hovered() and not isDisabled() then 0 else 1
		end,

		TextTransparency = function(): number
			return if isDisabled() then Theme.disabledTransparency else 0
		end,

		MouseEnter = function(): ()
			hovered(true)
		end,

		MouseLeave = function(): ()
			hovered(false)
		end,

		Activated = function(): ()
			if isDisabled() then
				return
			end
			open(false)
			props.activated()
		end,

		Vide.create("UICorner")({ CornerRadius = Theme.cornerRadius }),
		Vide.create("UIPadding")({
			PaddingLeft = UDim.new(0, Theme.padding),
			PaddingRight = UDim.new(0, Theme.padding),
		}),
	})
end

local function Menu(props: MenuProps): TextButton
	local isDisabled = props.disabled or never
	local open = Vide.source(false)

	local menuButton = Button({
		icon = props.icon,
		label = props.label,
		tooltip = props.tooltip,
		disabled = props.disabled,
		selected = function(): boolean
			return open()
		end,
		activated = function(): ()
			open(not open())
		end,
	})

	Vide.effect(function(): ()
		if isDisabled() then
			open(false)
		end
	end)

	Vide.show(open, function(): Frame
		local options: { TextButton } = {}
		for order, optionProps in props.options do
			table.insert(options, Option(optionProps, order, open))
		end

		local dropdown = Vide.create("Frame")({
			Name = "dropdown",
			Position = UDim2.new(0, 0, 1, Theme.gap * 2),
			Size = UDim2.fromOffset(Theme.menuWidth, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Theme.menuBackground,

			Vide.create("UICorner")({ CornerRadius = Theme.cornerRadius }),
			Vide.create("UIStroke")({ Color = Theme.stroke }),
			Vide.create("UIPadding")({
				PaddingTop = UDim.new(0, Theme.gap),
				PaddingBottom = UDim.new(0, Theme.gap),
				PaddingLeft = UDim.new(0, Theme.gap),
				PaddingRight = UDim.new(0, Theme.gap),
			}),
			Vide.create("UIListLayout")({
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
			options,

			Parent = menuButton,
		})

		local outsideClick = UserInputService.InputBegan:Connect(function(input: InputObject): ()
			local isPointer = input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			if not isPointer then
				return
			end
			if isInside(dropdown, input.Position) or isInside(menuButton, input.Position) then
				return
			end
			open(false)
		end)

		Vide.cleanup(outsideClick)
		Vide.cleanup(dropdown)
		return dropdown
	end)

	return menuButton
end

return Menu
