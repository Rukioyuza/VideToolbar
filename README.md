<h1 align="left">VideToolbar</h1>

<p align="left">
  <img src="https://img.shields.io/badge/Roblox-181717?style=for-the-badge&logo=roblox&logoColor=white" />
  <img src="https://img.shields.io/badge/Luau-181717?style=for-the-badge&logo=luau&logoColor=00A2FF" />
  <img src="https://img.shields.io/badge/Vide-0.4.1-181717?style=for-the-badge" />
</p>

A toolbar component for Roblox UI, built with [Vide](https://github.com/centau/vide). Buttons, toggles, separators and dropdown menus in one horizontal bar.

---

### About

Every part is a plain Vide component that returns its instance, so a toolbar is written the same way as the rest of your Vide UI.

- **Buttons.** An icon, a label or both, with hover and pressed states.
- **Toggles.** Bound to a `Vide.source(boolean)`. A click flips the source, and setting the source elsewhere updates the button.
- **Separators.** A thin line between groups.
- **Menus.** A button that opens a dropdown of options. It closes on a choice or on a click outside.
- **Tooltips.** Shown below a button after the pointer rests on it.
- **Reactive disabling.** `disabled` takes any function that returns a boolean, such as a source or a derived condition.

---

### Usage

```luau
--!strict

local Vide = require("@game/ReplicatedStorage/Packages/vide")
local VideToolbar = require("@game/ReplicatedStorage/VideToolbar")

local Toolbar = VideToolbar.Toolbar
local Button = VideToolbar.Button
local Toggle = VideToolbar.Toggle
local Separator = VideToolbar.Separator
local Menu = VideToolbar.Menu

local function App(): ScreenGui
	local showGrid = Vide.source(true)
	local locked = Vide.source(false)

	return Vide.create("ScreenGui")({
		Toolbar({
			position = UDim2.new(0.5, 0, 0, 12),
			anchorPoint = Vector2.new(0.5, 0),
			items = {
				Button({
					label = "Save",
					tooltip = "Save the map",
					disabled = locked,
					activated = function(): ()
						print("Saved")
					end,
				}),
				Separator(),
				Toggle({ label = "Grid", tooltip = "Show the grid", value = showGrid }),
				Menu({
					label = "Edit",
					disabled = locked,
					options = {
						{
							label = "Undo",
							activated = function(): ()
								print("Undo")
							end,
						},
					},
				}),
				Separator(),
				Toggle({ label = "Lock", tooltip = "Lock editing", value = locked }),
			},
		}),
	})
end

Vide.mount(App, game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
```

Create the items inside the same component as the `Toolbar`, so they share its Vide scope and are cleaned up with it.

---

### Toolbar props

| Prop | Type | Purpose |
| --- | --- | --- |
| `items` | `{ GuiObject }` | The items, left to right. Each item's `LayoutOrder` is set to its place in the list |
| `position` | `UDim2?` | Position of the bar |
| `anchorPoint` | `Vector2?` | Anchor point of the bar |

The bar grows to fit its items. Any component that returns a `GuiObject` can be an item.

---

### Item props

`Button`, `Toggle` and `Menu` share these:

| Prop | Type | Purpose |
| --- | --- | --- |
| `icon` | `string?` | Image content id, such as an `rbxassetid://` |
| `label` | `string?` | Text shown on the button. At least one of `icon` and `label` is required |
| `tooltip` | `string?` | Text shown below the button on hover |
| `disabled` | `(() -> boolean)?` | The item dims and ignores clicks while this returns true |

Each one adds its own:

| Component | Prop | Type | Purpose |
| --- | --- | --- | --- |
| `Button` | `activated` | `() -> ()` | Called on click |
| `Button` | `selected` | `(() -> boolean)?` | Keeps the button highlighted while true |
| `Toggle` | `value` | `Vide.Source<boolean>` | The source the toggle shows and flips |
| `Menu` | `options` | `{ MenuOption }` | Each option has `label`, `activated` and an optional `disabled` |

`Separator()` takes no props.

---

### Theme

Colours, sizes and timings live in `src/Theme.luau`. Edit the file, or change the table before the toolbar is created.

| Field | Default | Purpose |
| --- | --- | --- |
| `barHeight` | `38` | Height of the bar in pixels |
| `buttonHeight` | `30` | Height of each button, and width of an icon only button |
| `iconSize` | `18` | Icon size in pixels |
| `font` | `BuilderSansMedium` | Font for labels, options and tooltips |
| `menuWidth` | `180` | Width of a dropdown |
| `tooltipDelay` | `0.5` | Seconds of hover before a tooltip appears |
| `disabledTransparency` | `0.6` | How much a disabled item fades |

---

### Install

1. Add Vide with [Wally](https://wally.run): `vide = "centau/vide@0.4.1"`, as in this repo's `wally.toml`, then run `wally install`. Or copy Vide's `src` folder into `ReplicatedStorage.Packages` as a ModuleScript named `vide`.
2. Put `src` in `ReplicatedStorage` as a ModuleScript named `VideToolbar`, with the other files as its children.
3. If Vide lives somewhere else, change the `@game/ReplicatedStorage/Packages/vide` require at the top of each file in `src`.

With [Rojo](https://rojo.space), `wally install` and then `rojo serve` sets all of this up from `default.project.json`.

---

### Example

`example/ToolbarExample.client.luau` mounts a toolbar with every kind of item into `PlayerGui`. The Rojo project places it in `StarterPlayerScripts`, so pressing Play shows it.
