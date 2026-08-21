--!strict

local Vide = require("@game/ReplicatedStorage/Packages/vide")
local VideToolbar = require("@game/ReplicatedStorage/VideToolbar")

local Players = game:GetService("Players")

local Toolbar = VideToolbar.Toolbar
local Button = VideToolbar.Button
local Toggle = VideToolbar.Toggle
local Separator = VideToolbar.Separator
local Menu = VideToolbar.Menu

local function App(): ScreenGui
	local placed = Vide.source(0)
	local showGrid = Vide.source(true)
	local snap = Vide.source(false)
	local locked = Vide.source(false)

	local function nothingToUndo(): boolean
		return placed() == 0
	end

	Vide.effect(function(): ()
		print(`Grid is {if showGrid() then "on" else "off"}, snapping is {if snap() then "on" else "off"}`)
	end)

	return Vide.create("ScreenGui")({
		Name = "ToolbarExample",
		ResetOnSpawn = false,

		Toolbar({
			position = UDim2.new(0.5, 0, 0, 12),
			anchorPoint = Vector2.new(0.5, 0),
			items = {
				Button({
					label = "Place",
					tooltip = "Place a block",
					disabled = locked,
					activated = function(): ()
						placed(placed() + 1)
						print(`Placed block {placed()}`)
					end,
				}),
				Separator(),
				Toggle({ label = "Grid", tooltip = "Show the grid", value = showGrid }),
				Toggle({ label = "Snap", tooltip = "Snap to the grid", value = snap, disabled = locked }),
				Separator(),
				Menu({
					label = "Edit",
					tooltip = "Edit the blocks you placed",
					disabled = locked,
					options = {
						{
							label = "Undo",
							disabled = nothingToUndo,
							activated = function(): ()
								placed(placed() - 1)
							end,
						},
						{
							label = "Clear all",
							disabled = nothingToUndo,
							activated = function(): ()
								placed(0)
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

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
Vide.mount(App, playerGui)
