--
-- Author: TsingZhang@boyaa.com
-- Date: 2016-05-30 15:39:45
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: DokbLotryRecListItem.lua By TsingZhang.
--
local ITEMSIZE = nil

local DokbLotryRecListItem = class("DokbLotryRecListItem", bm.ui.ListItem)

function DokbLotryRecListItem:ctor()
	-- body
	self:setNodeEventEnabled(true)

	local dokbPageLeftOprPanelModel = display.newSprite("#hall_auxBgPanel_left.png")
	local dokbPageLeftOprPanelCalSize = dokbPageLeftOprPanelModel:getContentSize()

	local ownerMarinHoriz = 10
	local itemHeight = 42
	ITEMSIZE = cc.size(display.width - dokbPageLeftOprPanelCalSize.width - ownerMarinHoriz * 2,
		itemHeight)

	self.super.ctor(self, ITEMSIZE.width, ITEMSIZE.height)

	-- Init Default LabelParam --
	local labelParam = {
		fontSize = 0,
		color = display.COLOR_WHITE
	}

	labelParam.fontSize = 18
	labelParam.color = display.COLOR_WHITE

	self.gemName_ = display.newTTFLabel({text = "Gem Name", size = labelParam.fontSize, color = labelParam.color,
		align = ui.TEXT_ALIGN_CENTER})
		:pos(ITEMSIZE.width / 10, ITEMSIZE.height / 2)
		:addTo(self)

	labelParam.fontSize = 20
	labelParam.color = display.COLOR_GREEN

	self.lotryCode_ = display.newTTFLabel({text = "Lotry Code", size = labelParam.fontSize, color = labelParam.color,
		align = ui.TEXT_ALIGN_CENTER})
		:pos(ITEMSIZE.width * 3 / 10, ITEMSIZE.height / 2)
		:addTo(self)

	labelParam.fontSize = 18
	labelParam.color = display.COLOR_WHITE

	self.awarderName_ = display.newTTFLabel({text = "Awarder Name", size = labelParam.fontSize, color = labelParam.color,
		align = ui.TEXT_ALIGN_CENTER})
		:pos(ITEMSIZE.width * 5 / 10, ITEMSIZE.height / 2)
		:addTo(self)

	labelParam.fontSize = 20
	labelParam.color = display.COLOR_WHITE

	self.myCodes_ = {}
	local codeLblWidth = {}

	for i = 1, 3 do
		if i == 3 then
			--todo
			self.myCodes_[i] = display.newTTFLabel({text = "My Code" .. i, size = labelParam.fontSize, color = labelParam.color,
				align = ui.TEXT_ALIGN_CENTER})
		else
			self.myCodes_[i] = display.newTTFLabel({text = "My Code" .. i .. ";", size = labelParam.fontSize, color = labelParam.color,
				align = ui.TEXT_ALIGN_CENTER})
		end

		codeLblWidth[i] = self.myCodes_[i]:getContentSize().width
	end

	local myCodesPosXShf = {- (codeLblWidth[1] + codeLblWidth[2]) / 2, 0, (codeLblWidth[2] + codeLblWidth[3]) / 2}

	for i = 1, #self.myCodes_ do
		self.myCodes_[i]:pos(ITEMSIZE.width * 4 / 5 + myCodesPosXShf[i], ITEMSIZE.height / 2)
			:addTo(self)
	end

	local dividLineHeight = 2
	local dividLineMagrinHoriz = 10
	local itemDividLine = display.newScale9Sprite("#dokb_divLineRecs.png", ITEMSIZE.width / 2, 0, cc.size(ITEMSIZE.width - dividLineMagrinHoriz * 2, dividLineHeight))
		:addTo(self)

end

function DokbLotryRecListItem:onDataSet(isChanged, data)
	-- body
	if isChanged then
		--todo
		-- self.gemId_ = data.id

		self.gemName_:setString(data.props or "Gem Name.")
		self.lotryCode_:setString(data.treatureCode or bm.LangUtil.getText("DOKB", "LOTRYREC_NOTOPEN"))
		self.awarderName_:setString(data.username or bm.LangUtil.getText("DOKB", "LOTRYREC_NOTOPEN"))

		-- just for test --
		-- data.mycode = {
		-- 	"BJ21545",
		-- 	"KK24536",
		-- 	"AK15255"
		-- }
		-- end --

		if data.mycode and #data.mycode > 0 then
			--todo
			for i = 1, #self.myCodes_ do
				self.myCodes_[i]:setString("")
				self.myCodes_[i]:setTextColor(display.COLOR_WHITE)
			end

			for i = 1, #data.mycode do

				if self.myCodes_[i] then
					--todo
					if i == #data.mycode then
						--todo
						self.myCodes_[i]:setString(data.mycode[i] or "")
					else
						self.myCodes_[i]:setString((data.mycode[i] or "") .. ";")
					end

					if data.treatureCode == data.mycode[i] then
						--todo
						self.myCodes_[i]:setTextColor(cc.c3b(205, 97, 99))
					end
				end
			end

			self:adjMyCodesLblPos(#data.mycode)
		else
			for i = 1, #self.myCodes_ do
				self.myCodes_[i]:setString("")
				self.myCodes_[i]:setTextColor(display.COLOR_WHITE)
			end

			self.myCodes_[1]:setString(bm.LangUtil.getText("DOKB", "LOTRYREC_NOTATTENED"))
			self:adjMyCodesLblPos(1)
		end
	end
end

function DokbLotryRecListItem:adjMyCodesLblPos(codeNum)
	-- body
	local adjMyCodesLblPosByCodeNum = {
			[1] = function()
				-- body
				self.myCodes_[1]:pos(ITEMSIZE.width * 4 / 5, ITEMSIZE.height / 2)
			end,

			[2] = function()
				-- body
				local codeWidth1 = self.myCodes_[1]:getContentSize().width
				local codeWidth2 = self.myCodes_[2]:getContentSize().width

				self.myCodes_[1]:pos(ITEMSIZE.width * 4 / 5 - codeWidth1 / 2, ITEMSIZE.height / 2)
				self.myCodes_[2]:pos(ITEMSIZE.width * 4 / 5 + codeWidth2 / 2, ITEMSIZE.height / 2)
			end,

			[3] = function()
				-- body
				local codeWidth = {}
				for i = 1, #self.myCodes_ do
					codeWidth[i] = self.myCodes_[i]:getContentSize().width
				end

				local myCodesPosXShf = {- (codeWidth[1] + codeWidth[2]) / 2, 0,	(codeWidth[2] + codeWidth[3]) / 2}

				for i = 1, #self.myCodes_ do
					self.myCodes_[i]:pos(ITEMSIZE.width * 4 / 5 + myCodesPosXShf[i], ITEMSIZE.height / 2)
				end
			end
		}

	if adjMyCodesLblPosByCodeNum[codeNum] then
		--todo
		adjMyCodesLblPosByCodeNum[codeNum]()
	end
	
end

function DokbLotryRecListItem:onEnter()
	-- body
end

function DokbLotryRecListItem:onExit()
	-- body
end

function DokbLotryRecListItem:onCleanup()
	-- body
end

return DokbLotryRecListItem