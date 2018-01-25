--
-- Author: TsingZhang@boyaa.com
-- Date: 2016-05-30 18:20:54
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: DokbActHelpPopup.lua By TsingZhang.
--

-- local PANEL_WIDTH = 622
-- local PANEL_HEIGHT = 402

local DokbActHelpPopup = class("DokbActHelpPopup", nk.ui.Panel)

function DokbActHelpPopup:ctor()
	-- body
	self:setNodeEventEnabled(true)
	self.super.ctor(self, self.SIZE_LARGE)

	-- labelParam = {
	-- 	fontSize = 0,
	-- 	color = display.COLOR_WHITE
	-- }

	-- local titleLbl = display.newTTFLabel({text = bm.LangUtil.getText("DOKB", "HELP_INSTRUCT"), size = labelParam.fontSize, color = labelParam.color, align =
	-- 	ui.TEXT_ALIGN_CENTER})
	
	local titleDec = display.newSprite("#dokb_tiDokbHelp.png")

	self:addPanelTitleBar(titleDec)

	local tipsAllStr = {
		[1] = {
			title = bm.LangUtil.getText("DOKB", "HELP_CONT_TITLES")[1],
			cont = {
				bm.LangUtil.getText("DOKB", "HELP_CONT_DETAIL1")
			}
		},

		[2] = {
			title = bm.LangUtil.getText("DOKB", "HELP_CONT_TITLES")[2],
			cont = bm.LangUtil.getText("DOKB", "HELP_CONT_DETAIL2")
		},

		tipsBot = bm.LangUtil.getText("DOKB", "HELP_TIPSBOT")
	}

	local tipsShownWidth = 752

	local tipsMagrins = {
		leftNor = 15,
		detailLeft = 48,
		firstTop = 16,
		titleContGap = 15,
		betweenSec = 30,
		contEach = 12,
		contentEnd = 18,
		pointLeft = 22
	}

	local tipsLblParam = {
		fontSizes = {
			title = 20,
			cont = 18,
			tipsBot = 20
		},
		colors = {
			title = display.COLOR_WHITE,
			cont = display.COLOR_WHITE,
			tipsBot = display.COLOR_WHITE
		}
	}

	local scrollContent = display.newNode()

	local container = display.newNode():addTo(scrollContent)

	local sumHeightContent = 0

	local tipsTitles = {}
	local tipsConts = {}

	local tipsBot = nil

	for i = 1, #tipsAllStr do
		tipsTitles[i] = display.newTTFLabel({text = tipsAllStr[i].title, size = tipsLblParam.fontSizes.title, color = tipsLblParam.colors.title,
			dimensions = cc.size(tipsShownWidth, 0), align = ui.TEXT_ALIGN_LEFT})
		tipsTitles[i]:setAnchorPoint(display.ANCHOR_POINTS[display.LEFT_TOP])

		tipsConts[i] = {}
		for j = 1, #tipsAllStr[i].cont do
			
			if i == #tipsAllStr then
				tipsShownWidth = tipsShownWidth - (tipsMagrins.detailLeft - tipsMagrins.pointLeft) - 6
			end

			tipsConts[i][j] = display.newTTFLabel({text = tipsAllStr[i].cont[j], size = tipsLblParam.fontSizes.cont, color = tipsLblParam.colors.cont,
				dimensions = cc.size(tipsShownWidth, 0), align = ui.TEXT_ALIGN_LEFT})
			tipsConts[i][j]:setAnchorPoint(display.ANCHOR_POINTS[display.LEFT_TOP])

			if i == #tipsAllStr and j == #tipsAllStr[#tipsAllStr].cont then
				--todo
				tipsShownWidth = 760
				tipsBot = display.newTTFLabel({text = tipsAllStr.tipsBot, size = tipsLblParam.fontSizes.cont, color = tipsLblParam.colors.cont,
					dimensions = cc.size(tipsShownWidth, 0), align = ui.TEXT_ALIGN_LEFT})
				tipsBot:setAnchorPoint(display.ANCHOR_POINTS[display.LEFT_TOP])
			end
		end

		local sumHeightAboveTitle = 0
		local sumHeightAboveCont = 0

		for j = 1, i do
			for k = 1, #tipsConts[j] do

				if j == 1 then
					--todo
					if k == 1 then
						--todo
						sumHeightAboveCont = sumHeightAboveCont + tipsTitles[j]:getContentSize().height + tipsMagrins.titleContGap
					else
						sumHeightAboveCont = sumHeightAboveCont + tipsConts[j][k - 1]:getContentSize().height + tipsMagrins.contEach
					end
				else
					if k == 1 then
						--todo
						sumHeightAboveTitle = sumHeightAboveCont + tipsConts[j - 1][#tipsConts[j - 1]]:getContentSize().height 
							+ tipsMagrins.betweenSec

						sumHeightAboveCont = sumHeightAboveTitle + tipsTitles[j]:getContentSize().height + tipsMagrins.titleContGap
					else
						sumHeightAboveCont = sumHeightAboveCont + tipsConts[j][k - 1]:getContentSize().height + tipsMagrins.contEach
					end
				end

				if j >= i then
					--todo
					if j == 1 then
						--todo
						tipsConts[j][k]:pos(tipsMagrins.leftNor, - sumHeightAboveCont - tipsMagrins.firstTop)
							:addTo(container)
					else

						local decPointPosYFix = 5
						local decPoint = display.newSprite("#dokb_decDot.png")
						decPoint:pos(tipsMagrins.pointLeft, - sumHeightAboveCont - tipsMagrins.firstTop - decPoint:getContentSize().height / 2 -
							decPointPosYFix)
							:addTo(container)

						tipsConts[j][k]:pos(tipsMagrins.detailLeft, - sumHeightAboveCont - tipsMagrins.firstTop)
							:addTo(container)
					end
				end

				if j == #tipsAllStr and k == #tipsConts[#tipsAllStr] then
					--todo
					tipsBot:pos(tipsMagrins.leftNor, - sumHeightAboveCont - tipsConts[j][k]:getContentSize().height - tipsMagrins.contentEnd - tipsMagrins.firstTop)
						:addTo(container)

					sumHeightContent = sumHeightAboveCont + tipsConts[j][k]:getContentSize().height + tipsBot:getContentSize().height + 
						tipsMagrins.contentEnd + tipsMagrins.firstTop * 2
				end
			end

			if j >= i then
				--todo
				tipsTitles[j]:pos(tipsMagrins.leftNor, - sumHeightAboveTitle - tipsMagrins.firstTop)
					:addTo(container)
			end
		end
	end

	local helpContListViewParam = {
		width = 770,
		height = 378
	}

	container:pos(- helpContListViewParam.width / 2, sumHeightContent / 2)

	local scrollViewPosAdj = {
		x = 0,
		y = 32
	}
	self.helpContScrollView_ = bm.ui.ScrollView.new({viewRect = cc.rect(- helpContListViewParam.width / 2, - helpContListViewParam.height / 2,
		helpContListViewParam.width, helpContListViewParam.height), scrollContent = scrollContent, direction = bm.ui.ScrollView.DIRECTION_VERTICAL})
        :pos(- scrollViewPosAdj.x, - scrollViewPosAdj.y)
        :addTo(self)

	self:addCloseBtn()
end

function DokbActHelpPopup:showPanel(popUpCallBack)
	-- body
	self.showedCallBack_ = popUpCallBack
	self:showPanel_()
end

function DokbActHelpPopup:onShowed()
	-- body
	if self and self.helpContScrollView_ then
		--todo
		self.helpContScrollView_:update()
	end
	
	if self and self.showedCallBack_ then
		--todo
		self.showedCallBack_()
	end
end

function DokbActHelpPopup:onEnter()
	-- body
end

function DokbActHelpPopup:onExit()
	-- body
end

function DokbActHelpPopup:onCleanup()
	-- body
end

return DokbActHelpPopup