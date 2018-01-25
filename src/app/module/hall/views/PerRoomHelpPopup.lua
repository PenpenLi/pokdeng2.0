--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-04-18 11:10:32
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: PerRoomHelpPopup.lua Create && Reconstructed By Tsing7x
--

local PerRoomHelpPopup = class("PerRoomHelpPopup", nk.ui.Panel)

function PerRoomHelpPopup:ctor()
	-- body
	self:setNodeEventEnabled(true)

	self.super.ctor(self, self.SIZE_LARGE)

	local labelParam = {
		fontSize = 0,
		color = display.COLOR_WHITE
	}

	labelParam.fontSize = 32
	labelParam.color = display.COLOR_WHITE

	local titleLbl = display.newTTFLabel({text = bm.LangUtil.getText("HALL", "PERSONAL_ROOM_HELP_TITLE"), size = labelParam.fontSize, color = labelParam.color,
		align = ui.TEXT_ALIGN_CENTER})

	self:addPanelTitleBar(titleLbl)

	local tipsFirstLineMagrinTop = 12
	local tipsTitleMagrinLeft = 25
	local tipsContMagrinLeft = 55
	local tipsMagrinEach = 8

	local tipsTitleDesc = bm.LangUtil.getText("HALL", "PERSONAL_ROOM_HELP_TIPS_TITLE")
	local tipsContDesc = bm.LangUtil.getText("HALL", "PERSONAL_ROOM_HELP_TIPS_CONT")

	local scrollContent = display.newNode()
	local container = display.newNode():addTo(scrollContent)

	local tipsTitleFontSize = 22
	local tipsTitleColor = display.COLOR_WHITE

	local tipsContFontSize = 20
	local tipsContColor = display.COLOR_WHITE

	local tipsContShownWidth = 765

	local sumHeightContent = 0

	local tipsTitle = {}
	local tipsCont = {}
	for i = 1, 4 do

		tipsTitle[i] = display.newTTFLabel({text = tipsTitleDesc[i], size = tipsTitleFontSize, color = tipsTitleColor, align = ui.TEXT_ALIGN_LEFT})
		tipsTitle[i]:setAnchorPoint(display.ANCHOR_POINTS[display.LEFT_TOP])

		tipsCont[i] = display.newTTFLabel({text = tipsContDesc[i], size = tipsContFontSize, color = tipsContColor, dimensions = 
			cc.size(tipsContShownWidth, 0), align = ui.TEXT_ALIGN_LEFT})
		tipsCont[i]:setAnchorPoint(display.ANCHOR_POINTS[display.LEFT_TOP])

		local sumHeightAboveTitle = 0
		local sumHeightAboveCont = 0

		for j = 1, i do

			if j == 1 then
				--todo

				sumHeightAboveCont = sumHeightAboveCont + tipsTitle[j]:getContentSize().height + tipsMagrinEach
			else
				sumHeightAboveTitle = sumHeightAboveTitle + tipsTitle[j - 1]:getContentSize().height + tipsCont[j - 1]:getContentSize().height
					+ tipsMagrinEach * 2

				sumHeightAboveCont = sumHeightAboveCont + tipsTitle[j]:getContentSize().height + tipsCont[j - 1]:getContentSize().height
					+ tipsMagrinEach * 2
			end
			
			if j == 4 then
				--todo
				sumHeightContent = sumHeightAboveCont + tipsCont[j]:getContentSize().height + tipsFirstLineMagrinTop * 2
			end
		end

		tipsTitle[i]:pos(tipsTitleMagrinLeft, - tipsFirstLineMagrinTop - sumHeightAboveTitle)
			:addTo(container)

		tipsCont[i]:pos(tipsContMagrinLeft, - tipsFirstLineMagrinTop - sumHeightAboveCont)
			:addTo(container)
	end

	local scrollViewParam = {
		width = 776,
		height = 378
	}

	local containerPosYFix = 0
	container:pos(- scrollViewParam.width / 2 , sumHeightContent / 2 + containerPosYFix)

	local scrollViewPosXFix, scrollViewPosYFix = 15, 34

	self.tipsContScrollView_ = bm.ui.ScrollView.new({viewRect = cc.rect(- scrollViewParam.width / 2, - scrollViewParam.height / 2, scrollViewParam.width,
		scrollViewParam.height), scrollContent = scrollContent, direction = bm.ui.ScrollView.DIRECTION_VERTICAL})
        :pos(- scrollViewPosXFix, - scrollViewPosYFix)
        :addTo(self)

 	self:addCloseBtn()
end

function PerRoomHelpPopup:showPanel()
	-- body
	self:showPanel_()
end

function PerRoomHelpPopup:onShowed()
	-- body
	self.tipsContScrollView_:update()
end

function PerRoomHelpPopup:onEnter()
	-- body
end

function PerRoomHelpPopup:onExit()
	-- body
end

function PerRoomHelpPopup:onCleanup()
	-- body
end

return PerRoomHelpPopup