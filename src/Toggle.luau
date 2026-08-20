--!strict

local Vide = require("@game/ReplicatedStorage/Packages/vide")
local Button = require("./Button")

type Source<T> = Vide.Source<T>

export type ToggleProps = {
	read icon: string?,
	read label: string?,
	read tooltip: string?,
	read disabled: (() -> boolean)?,
	read value: Source<boolean>,
}

local function Toggle(props: ToggleProps): TextButton
	local value = props.value

	return Button({
		icon = props.icon,
		label = props.label,
		tooltip = props.tooltip,
		disabled = props.disabled,
		selected = function(): boolean
			return value()
		end,
		activated = function(): ()
			value(not value())
		end,
	})
end

return Toggle
