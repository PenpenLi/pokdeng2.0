--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-05-04 15:27:52
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: WheelWinResultPopup.lua Create && Reconst By Tsing7x.
--

local PANEL_WIDTH = 630
local PANEL_HEIGHT = 328

local WheelWinResultPopup = class("WheelWinResultPopup", nk.ui.Panel)

function WheelWinResultPopup:ctor(rewData, controller)
	-- body
	self:setNodeEventEnabled(true)
	self.super.ctor(self, {PANEL_WIDTH, PANEL_HEIGHT})

	self.controller_ = controller  -- Obligate For Later May Share Func

	local labelParam = {
		fontSize = 0,
		color = display.COLOR_BLACK
	}

	labelParam.fontSize = 32
	labelParam.color = styles.FONT_COLOR.GOLDEN_TEXT

	local titleMagrinTop = 42
	local rewWinDetTitle = display.newTTFLabel({text = "恭喜您,获得了" .. (rewData.desc or "rewName * 0"), size = labelParam.fontSize,
		color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
	rewWinDetTitle:pos(0, PANEL_HEIGHT / 2 - titleMagrinTop - rewWinDetTitle:getContentSize().height / 2)
		:addTo(self)

	local rewDecMagrinBot = 10
	local rewDecShiny = display.newSprite("#wheel_decRewardShiny.png")
	rewDecShiny:pos(0, - PANEL_HEIGHT / 2 + rewDecMagrinBot + rewDecShiny:getContentSize().height / 2)
		:addTo(self)

	local rewType = self:getRewCatByType((rewData.id or 0) + 1)

	local rewIcon = nil

	local rewIconMagrinDecCnt = 5
	if rewType == 1 then
		--todo
		rewIcon = display.newSprite("#wheel_decChipsReward.png")
	else
		rewIcon = display.newSprite("#wheel_decProp.png")
	end

	rewIcon:pos(rewDecShiny:getContentSize().width / 2, rewDecShiny:getContentSize().height / 2 + rewIconMagrinDecCnt)
		:addTo(rewDecShiny)

	self:addCloseBtn()
end

function WheelWinResultPopup:getRewCatByType(rewType)
	-- body
	-- Add Field rewType For Rew Val Adj,Use Id Temporary --
	if rewType <= 6 then
		--todo
		return 1  -- Type Chips
	else
		return 0 -- Type Props
	end
end

function WheelWinResultPopup:showPanel()
	-- body
	self:showPanel_()
end

function WheelWinResultPopup:onEnter()
	-- body
end

function WheelWinResultPopup:onExit()
	-- body
end

function WheelWinResultPopup:onCleanup()
	-- body
end

return WheelWinResultPopup