--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-06-14 11:28:35
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: GiftPrdItem.lua Created By Tsing7x.
--

local LoadGiftController = import("..LoadGiftControl")

local GiftPrdItem = class("GiftPrdItem", function()
	-- body
	return display.newNode()
end)

function GiftPrdItem:ctor()
	-- body
	self:setNodeEventEnabled(true)

	self.bgScaleSize_ = .85
	self.itemBg_ = display.newSprite("#propGift_bgGiftItem.png")
		:addTo(self)
		:scale(self.bgScaleSize_)

	bm.TouchHelper.new(self.itemBg_, handler(self, self.onItemTouched_))
	self.itemBg_:setTouchSwallowEnabled(false)

	self.isSelfSelected_ = false

	local bgItemSizeCal = self.itemBg_:getContentSize()
	local bgItemSizeScale = cc.size(bgItemSizeCal.width * self.bgScaleSize_, bgItemSizeCal.height * self.bgScaleSize_)

	local itemTitleBgWidthFix = 5
	local itemTitleBgSize = {
		width = bgItemSizeScale.width - itemTitleBgWidthFix * 2,
		height = 32
	}

	local itemTitleBgMagrinTop = 16
	self.itemTitleBg_ = display.newScale9Sprite("#propGift_bgDentPrdGiftTitle.png", bgItemSizeCal.width / 2, bgItemSizeCal.height - itemTitleBgMagrinTop - itemTitleBgSize.height / 2,
		cc.size(itemTitleBgSize.width, itemTitleBgSize.height))
		:addTo(self.itemBg_)

	local labelParam = {
		fontSize = 0,
		color = display.COLOR_BLACK
	}

	labelParam.fontSize = 18
	labelParam.color = styles.FONT_COLOR.GOLDEN_TEXT
	self.prdPrice_ = display.newTTFLabel({text = "0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})

	labelParam.color = display.COLOR_GREEN
	self.prdExpirDayTime_ = display.newTTFLabel({text = "(0天)", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})

	local prdGiftTitleInfoGaps = 2
	local prdGiftTitleInfoWidth = self.prdPrice_:getContentSize().width + self.prdExpirDayTime_:getContentSize().width + prdGiftTitleInfoGaps

	self.prdPrice_:pos(itemTitleBgSize.width / 2 + (self.prdPrice_:getContentSize().width - prdGiftTitleInfoWidth) / 2, itemTitleBgSize.height / 2)
		:addTo(self.itemTitleBg_)

	self.prdExpirDayTime_:pos(itemTitleBgSize.width / 2 + (prdGiftTitleInfoWidth - self.prdExpirDayTime_:getContentSize().width) / 2, itemTitleBgSize.height / 2)
		:addTo(self.itemTitleBg_)

	self.prdFrameImg_ = display.newSprite()
		:pos(bgItemSizeCal.width / 2, bgItemSizeCal.height / 2)
		:addTo(self.itemBg_)

	self.prdGiftImgLoaderId_ = nk.ImageLoader:nextLoaderId()

	local prdNameDescLblMagrinBot = 10

	labelParam.fontSize = 24
	labelParam.color = display.COLOR_WHITE
	self.prdNameDesc_ = display.newTTFLabel({text = "Gift Name", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
	self.prdNameDesc_:pos(bgItemSizeCal.width / 2, self.prdNameDesc_:getContentSize().height / 2 + prdNameDescLblMagrinBot)
		:addTo(self.itemBg_)
end

function GiftPrdItem:onItemImgLoaded_(success, sprite)
	-- body
	if success then
		--todo
		local prdGiftImgShownSize = {
			width = 85,
			height = 64
		}

		local texture = sprite:getTexture()
		local texSize = texture:getContentSize()

		if self and self.prdFrameImg_ then
			--todo
			self.prdFrameImg_:setTexture(texture)
			self.prdFrameImg_:setTextureRect(cc.rect(0, 0, texSize.width, texSize.height))

			local scaleX = prdGiftImgShownSize.width / texSize.width
		    local scaleY = prdGiftImgShownSize.height / texSize.height

		    self.prdFrameImg_:scale(scaleX < scaleY and scaleX or scaleY)
		end
	else
		dump("GiftPrdItem:onItemImgLoaded_.Wrong!")
	end
end

function GiftPrdItem:onGiftUrlGet_(imgUrl)
	-- body
	if imgUrl ~= nil and string.len(imgUrl) >= 5 then
		--todo
		-- self.giftImgUrl_ = imgUrl
		nk.ImageLoader:loadAndCacheImage(self.prdGiftImgLoaderId_, imgUrl, handler(self, self.onItemImgLoaded_), nk.ImageLoader.CACHE_TYPE_GIFT)
	else
		dump("Get giftUrl Wrong!")
	end
end

function GiftPrdItem:setItemData(data)
	-- body
	if data then
		--todo
		self.itemActionCallBack_ = data.callback_
		self.giftPid_ = tonumber(data.pnid)

		self.prdPrice_:setString(data.money or "1")
		self.prdExpirDayTime_:setString("(" .. (data.expire or 1) .. "天)")

		local prdGiftTitleInfoGaps = 2
		local prdGiftTitleInfoWidth = self.prdPrice_:getContentSize().width + self.prdExpirDayTime_:getContentSize().width + prdGiftTitleInfoGaps

		local itemTitleBgSize = self.itemTitleBg_:getContentSize()

		self.prdPrice_:pos(itemTitleBgSize.width / 2 + (self.prdPrice_:getContentSize().width - prdGiftTitleInfoWidth) / 2, itemTitleBgSize.height / 2)
		self.prdExpirDayTime_:pos(itemTitleBgSize.width / 2 + (prdGiftTitleInfoWidth - self.prdExpirDayTime_:getContentSize().width) / 2, itemTitleBgSize.height / 2)

		self.prdNameDesc_:setString(data.name or "Gift Name.")

		self.getGiftUrlId_ = LoadGiftController:getInstance():getGiftUrlById(self.giftPid_, handler(self, self.onGiftUrlGet_))
		
		if data.isDefaultSel_ then
			--todo
			self.itemBg_:setSpriteFrame("propGift_bgGiftItemSel.png")

			self.isSelfSelected_ = true
		end
	end
end

function GiftPrdItem:onItemTouched_(target, evt)
	-- body
	if evt == bm.TouchHelper.CLICK then
		--todo
		if self.isSelfSelected_ then
			--todo
			return
		end

		self.isSelfSelected_ = true

		bm.EventCenter:dispatchEvent({name = nk.eventNames.STORE_GIFT_SELECT_CHANGE, data = self.giftPid_})

		if self.itemActionCallBack_ then
			--todo
			self.itemActionCallBack_(self.giftPid_)
		end
	end
end

function GiftPrdItem:checkGiftSelectChanged(evt)
	-- body
	if evt.data == self.giftPid_ then
		--todo
		self.itemBg_:setSpriteFrame("propGift_bgGiftItemSel.png")
	else
		if self.isSelfSelected_ then
			--todo
			self.itemBg_:setSpriteFrame("propGift_bgGiftItem.png")
			self.isSelfSelected_ = false
		end
	end
end

function GiftPrdItem:getItemSizeCal()
	-- body
	local retSize = nil

	local itemBgSize = self.itemBg_:getContentSize()
	retSize = cc.size(itemBgSize.width * self.bgScaleSize_, itemBgSize.height * self.bgScaleSize_)

	return retSize
end

function GiftPrdItem:onEnter()
	-- body
	bm.EventCenter:addEventListener(nk.eventNames.STORE_GIFT_SELECT_CHANGE, handler(self, self.checkGiftSelectChanged))
end

function GiftPrdItem:onExit()
	-- body
	if self.prdGiftImgLoaderId_ then
		--todo
		nk.ImageLoader:cancelJobByLoaderId(self.prdGiftImgLoaderId_)
	end

	bm.EventCenter:removeEventListenersByEvent(nk.eventNames.STORE_GIFT_SELECT_CHANGE)
end

function GiftPrdItem:onCleanup()
	-- body
end

return GiftPrdItem