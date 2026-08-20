--!strict

local Button = require("@self/Button")
local Menu = require("@self/Menu")
local Separator = require("@self/Separator")
local Toggle = require("@self/Toggle")
local Toolbar = require("@self/Toolbar")

export type ButtonProps = Button.ButtonProps
export type MenuOption = Menu.MenuOption
export type MenuProps = Menu.MenuProps
export type ToggleProps = Toggle.ToggleProps
export type ToolbarProps = Toolbar.ToolbarProps

local VideToolbar = {
	Toolbar = Toolbar,
	Button = Button,
	Toggle = Toggle,
	Separator = Separator,
	Menu = Menu,
}

return VideToolbar
