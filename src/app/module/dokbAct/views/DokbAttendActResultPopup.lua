--
-- Author: TsingZhang@boyaa.com
-- Date: 2016-05-31 15:05:36
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: DokbAttendActResultPopup.lua Create && Reconstructed By Tsing7x.
--
local PANEL_WIDTH = 520
local PANEL_HEIGHT = 360

local DokbAttendActResultPopup = class("DokbAttendActResultPopup", nk.ui.Panel)

-- @param resultData, resultData.code :LotryCode, Not Needed.; resultData.type :Result Type, Needed.
function DokbAttendActResultPopup:ctor(resultData)
	-- body
	self:setNodeEventEnabled(true)
	self.super.ctor(self, {PANEL_WIDTH, PANEL_HEIGHT})

	self:renderMainView(resultData)
	self:addCloseBtn()
end

function DokbAttendActResultPopup:renderMainView(data)
	-- body

	local labelParam = {
		fontSize = 0,
		color = display.COLOR_WHITE
	}

	local resultTips1 = nil
	local resultTips2 = nil

	local resultTipAreaPaddingTop = 72
	local resultTip1Magrin2 = 20

	local renderResultTipLblByType = {
		[1] = function()
			-- body
			labelParam.fontSize = 26
			labelParam.color = display.COLOR_WHITE

			resultTips1 = display.newTTFLabel({text = bm.LangUtil.getText("DOKB", "ATTRESULT_SUCC"), size = labelParam.fontSize, color = labelParam.color,
				align = ui.TEXT_ALIGN_CENTER})
			resultTips1:pos(0, PANEL_HEIGHT / 2 - resultTipAreaPaddingTop - resultTips1:getContentSize().height / 2)
				:addTo(self)

			labelParam.fontSize = 28
			labelParam.color = styles.FONT_COLOR.GOLDEN_TEXT

			resultTips2 = display.newTTFLabel({text = data.code or "000000", size = labelParam.fontSize, color = labelParam.color,
				align = ui.TEXT_ALIGN_CENTER})
			resultTips2:pos(0, resultTips1:getPositionY() - resultTips1:getContentSize().height / 2 - resultTip1Magrin2 - resultTips2:getContentSize().height / 2)
				:addTo(self)
		end,

		[2] = function()
			-- body
			labelParam.fontSize = 26
			labelParam.color = display.COLOR_WHITE

			local type2ResultTipPosAdj = 36
			resultTips1 = display.newTTFLabel({text = bm.LangUtil.getText("DOKB", "ATTRESULT_FAILD_CURRENCY_SHORT"), size = labelParam.fontSize, color = labelParam.color,
				align = ui.TEXT_ALIGN_CENTER})
			resultTips1:pos(0, PANEL_HEIGHT / 2 - resultTipAreaPaddingTop - resultTips1:getContentSize().height / 2 - type2ResultTipPosAdj)
				:addTo(self)
		end,

		[3] = function()
			-- body
			labelParam.fontSize = 26
			labelParam.color = display.COLOR_WHITE

			resultTips1 = display.newTTFLabel({text = bm.LangUtil.getText("DOKB", "ATTRESULT_FAILD_TIMEFULL"), size = labelParam.fontSize, color = labelParam.color,
				align = ui.TEXT_ALIGN_CENTER})
			resultTips1:pos(0, PANEL_HEIGHT / 2 - resultTipAreaPaddingTop - resultTips1:getContentSize().height / 2)
				:addTo(self)

			labelParam.fontSize = 28

			resultTips2 = display.newTTFLabel({text = bm.LangUtil.getText("DOKB", "ATTRESULT_CHANGE_ANOTHER"), size = labelParam.fontSize, color = labelParam.color,
				align = ui.TEXT_ALIGN_CENTER})
			resultTips2:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
			resultTips2:pos(resultTips1:getPositionX() - resultTips1:getContentSize().width / 2, resultTips1:getPositionY() - resultTips1:getContentSize().height / 2 -
				resultTip1Magrin2 - resultTips2:getContentSize().height / 2)
				:addTo(self)
		end
	}

	renderResultTipLblByType[data.type or 3]()

	-- Dent Area Bottom --
	local dentBotStencil = {
		x = 5,
		y = 1,
		width = 113,
		height = 80
	}

	local dentBotAreaSizeH = 80
	local dentBotBorH = 5

	local dentBotBlock = display.newScale9Sprite("#common_bgDentPanelBot.png", 0, - PANEL_HEIGHT / 2 + dentBotAreaSizeH / 2 + dentBotBorH, cc.size(PANEL_WIDTH,
		dentBotAreaSizeH), cc.rect(dentBotStencil.x, dentBotStencil.y, dentBotStencil.width, dentBotStencil.height))
		:addTo(self)

	local getKnwBtnSize = {
		width = 130,
		height = 46
	}

	labelParam.fontSize = 22
	labelParam.color = display.COLOR_WHITE

	self.getKnwBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnGreenRigOutl.png", pressed = "#common_btnGreenRigOutl.png", disabled = "#common_btnGreyLitRigOut.png"},
		{scale9 = true})
		:setButtonSize(getKnwBtnSize.width, getKnwBtnSize.height)
		:setButtonLabel(display.newTTFLabel({text = bm.LangUtil.getText("DOKB", "ATTRESULT_GETKNOWN"), size = labelParam.fontSize, color = labelParam.color, align =
			ui.TEXT_ALIGN_CENTER}))
		:onButtonClicked(buttontHandler(self, self.onGetKnwBtnCallBack_))
		:pos(PANEL_WIDTH / 2, dentBotAreaSizeH / 2)
		:addTo(dentBotBlock)

	local chkLotryTipsMagrinBot = 28

	labelParam.fontSize = 20
	labelParam.color = display.COLOR_WHITE

	local chkLotryTipLbl = display.newTTFLabel({text = bm.LangUtil.getText("DOKB", "ATTRESULT_CHECKNO_TIP"), size = labelParam.fontSize, color = labelParam.color, align =
		ui.TEXT_ALIGN_CENTER})
	chkLotryTipLbl:pos(0, - PANEL_HEIGHT / 2 + dentBotAreaSizeH + dentBotBorH + chkLotryTipsMagrinBot + chkLotryTipLbl:getContentSize().height / 2)
		:addTo(self)
end

function DokbAttendActResultPopup:onGetKnwBtnCallBack_(evt)
	-- body
	self.getKnwBtn_:setButtonEnabled(false)
	self:hidePanel_()
end

function DokbAttendActResultPopup:showPanel()
	-- body
	nk.PopupManager:addPopup(self)
end

function DokbAttendActResultPopup:onEnter()
	-- body
end

function DokbAttendActResultPopup:onExit()
	-- body
end

function DokbAttendActResultPopup:onCleanup()
	-- body
end

return DokbAttendActResultPopup