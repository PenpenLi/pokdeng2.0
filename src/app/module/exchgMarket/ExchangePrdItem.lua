--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-06-08 11:40:02
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: ExchangePrdItem.lua Created By Tsing7x.
--

local ExchangePrdItem = class("ExchangePrdItem", function()
	-- body
	return display.newNode()
end)

function ExchangePrdItem:ctor()
	-- body
	self:setNodeEventEnabled(true)

	self.itemBg_ = display.newSprite("#excMar_bgExcItem.png")
		:addTo(self)

	local bgItemSizeCal = self.itemBg_:getContentSize()

	local labelParam = {
		fontSize = 0,
		color = display.COLOR_BLACK
	}

	local prdTitleLblMagrinTop = 22
	
	labelParam.fontSize = 25
	labelParam.color = styles.FONT_COLOR.GOLDEN_TEXT
	self.itemPrdTitle_ = display.newTTFLabel({text = "Title", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
	self.itemPrdTitle_:pos(bgItemSizeCal.width / 2, bgItemSizeCal.height - prdTitleLblMagrinTop - self.itemPrdTitle_:getContentSize().height / 2)
		:addTo(self.itemBg_)

	self.prdImg_ = display.newSprite()
		:pos(bgItemSizeCal.width / 2, bgItemSizeCal.height / 2)
		:addTo(self.itemBg_)

	self.prdImgLoaderId_ = nk.ImageLoader:nextLoaderId()

	local prdItemDescLblMagrinBot = 16

	labelParam.fontSize = 22
	labelParam.color = display.COLOR_WHITE
	self.excCurrencyDesc_ = display.newTTFLabel({text = "0 Chip Exc", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
	self.excCurrencyDesc_:pos(bgItemSizeCal.width / 2, prdItemDescLblMagrinBot + self.excCurrencyDesc_:getContentSize().height / 2)
		:addTo(self.itemBg_)

	local botOprBtnSize = {
		width = bgItemSizeCal.width,
		height = 45
	}

	local botOprBtnPosYAdj = 6

	self.prdBotOprBtn_ = cc.ui.UIPushButton.new({normal = "#common_modTransparent.png", pressed = "#common_modTransparent.png", disabled =
		"#common_modTransparent.png"}, {scale9 = true})
		:setButtonSize(botOprBtnSize.width, botOprBtnSize.height)
		:onButtonClicked(buttontHandler(self, self.onPrdBotOprBtnCallBack_))
		:pos(bgItemSizeCal.width / 2, botOprBtnSize.height / 2 + botOprBtnPosYAdj)
		:addTo(self.itemBg_)

	self.prdBotOprBtn_:setTouchSwallowEnabled(false)
	self.prdBotOprBtn_:setButtonEnabled(false)
end

function ExchangePrdItem:onPrdImgLoaded_(success, sprite)
	-- body
	if success then
		--todo
		local tex = sprite:getTexture()
        local texSize = tex:getContentSize()

        if self and self.prdImg_ then
        	--todo
        	self.prdImg_:setTexture(tex)
		    self.prdImg_:setTextureRect(cc.rect(0, 0, texSize.width, texSize.height))

		    local prdImgShownSize = {
		    	width = 122,
		    	height = 94
			}

	        local scaleSizeX = prdImgShownSize.width / texSize.width
	        local scaleSizeY = prdImgShownSize.height / texSize.height

		    self.prdImg_:scale(scaleSizeX < scaleSizeY and scaleSizeX or scaleSizeY)
        end
	end
end

function ExchangePrdItem:setPrdItemData(data)
	-- body
	self.itemPrdTitle_:setString(data.giftname or "Title.")

	if string.len(data.imgurl or "") > 5 then
		--todo
		nk.ImageLoader:loadAndCacheImage(self.prdImgLoaderId_, data.imgurl, handler(self, self.onPrdImgLoaded_))
	end

	-- Remain Num --

	-- leftNum:setString(bm.LangUtil.getText("SCOREMARKET","EXCHANGE_LEFT_CNT",data.num))
 --    if tonumber(data.num) >99 then
 --        leftNum:setString(bm.LangUtil.getText("SCOREMARKET","GOODSFULL"))
 --    end
 --    if tonumber(data.num) ==0 then
 --        leftNum:setString(bm.LangUtil.getText("SCOREMARKET","NOLEFT"))
 --    end
 	local excCurrencyData = data.price

 	if checkint(excCurrencyData) > 0 then
 		--todo
 		if data.exchangeMethod == "chip" then
 			--todo
 			local chipNum = nil

 			if tonumber(excCurrencyData) < 100000 then
            	chipNum  = bm.formatNumberWithSplit(excCurrencyData)
            else
            	chipNum = bm.formatBigNumber(tonumber(excCurrencyData))
            end

            self.excCurrencyDesc_:setString(chipNum .. "筹码")
 		elseif data.exchangeMethod == "point" then
 			--todo
 			local cashNum = nil

            if tonumber(excCurrencyData) < 100000 then
            	cashNum  = bm.formatNumberWithSplit(excCurrencyData)
            else
            	cashNum = bm.formatBigNumber(tonumber(excCurrencyData))
            end

            self.excCurrencyDesc_:setString(cashNum .. "现金币")
 		end
 	else
 		local curCombinData = json.decode(excCurrencyData)

 		local excCurrencyStr = nil

 		if checkint(curCombinData.money) > 0  and checkint(curCombinData.point)>0 then
 			--todo
 			local chipNum = nil
 			local cashNum = nil

 			if tonumber(curCombinData.money) < 100000 then
 				--todo
 				chipNum  = bm.formatNumberWithSplit(curCombinData.money)
 			else
 				chipNum = bm.formatBigNumber(tonumber(curCombinData.money))
 			end

 			if tonumber(curCombinData.point) < 100000 then
 				--todo
 				cashNum  = bm.formatNumberWithSplit(curCombinData.point)
 			else
 				cashNum = bm.formatBigNumber(tonumber(curCombinData.point))
 			end

 			excCurrencyStr = chipNum .. "筹码 + " .. cashNum .. "现金币"

 		elseif checkint(curCombinData.point) > 0 and checkint(curCombinData.ticket) > 0 then
 			--todo
 			local cashNum = nil
 			local excTicketNum = nil

 			if tonumber(curCombinData.point) < 100000 then
 				--todo
 				cashNum  = bm.formatNumberWithSplit(curCombinData.point)
 			else
 				cashNum = bm.formatBigNumber(tonumber(curCombinData.point))
 			end

 			if tonumber(curCombinData.ticket) < 100000 then
 				--todo
 				excTicketNum  = bm.formatNumberWithSplit(curCombinData.ticket)
 			else
 				excTicketNum = bm.formatBigNumber(tonumber(curCombinData.ticket))
 			end

 			excCurrencyStr = cashNum .. "现金币 + " .. excTicketNum .. "兑换券"
 		else
 			excCurrencyStr = "0 筹码"
 		end

 		self.excCurrencyDesc_:setString(excCurrencyStr)
 	end

 	self.itemData_ = data

 	self.prdBotOprBtn_:setButtonEnabled(true)
end

function ExchangePrdItem:onPrdBotOprBtnCallBack_(evt)
	-- body
	if tonumber(self.itemData_.num) <= 0 then
		--todo
		nk.TopTipManager:showTopTip(bm.LangUtil.getText("SCOREMARKET", "NOLEFT"))
        return
	end

	self.prdBotOprBtn_:setButtonEnabled(false)
	if self.itemData_.excCallBack_ then
		--todo
		self.itemData_.excCallBack_(self.itemData_)
	end
	
	self.prdBotOprBtn_:setButtonEnabled(true)
end

function ExchangePrdItem:getItemSizeCal()
	-- body
	local itemBgSizeCal = self.itemBg_:getContentSize()

	return itemBgSizeCal
end

function ExchangePrdItem:onEnter()
	-- body
end

function ExchangePrdItem:onExit()
	-- body
	nk.ImageLoader:cancelJobByLoaderId(self.prdImgLoaderId_)
end

function ExchangePrdItem:onCleanup()
	-- body
end

return ExchangePrdItem