--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-05-22 11:46:35
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: MyProptyAffixProdItem.lua Create By Tsing7x.
--

local LoadGiftController = import("app.module.store.LoadGiftControl")

local MyProptyAffixProdItem = class("MyProptyAffixProdItem", function()
	-- body
	return display.newNode()
end)

function MyProptyAffixProdItem:ctor()
	-- body
	self:setNodeEventEnabled(true)

	self.itemBg_ = display.newSprite("#usrInfo_bgItemAffixPropty.png")
		:addTo(self)

	local bgItemSizeCal = self.itemBg_:getContentSize()

	local itemTitleBgWidthFix = 10
	local itemTitleBgSize = {
		width = bgItemSizeCal.width - itemTitleBgWidthFix * 2,
		height = 32
	}

	local itemTitleBgMagrinTop = 12
	local itemTitleBg = display.newScale9Sprite("#usrInfo_bgProdTitle.png", bgItemSizeCal.width / 2, bgItemSizeCal.height - itemTitleBgMagrinTop - itemTitleBgSize.height / 2,
		cc.size(itemTitleBgSize.width, itemTitleBgSize.height))
		:addTo(self.itemBg_)

	local labelParam = {
		fontSize = 0,
		color = display.COLOR_BLACK
	}

	labelParam.fontSize = 20
	labelParam.color = display.COLOR_WHITE
	self.itemTitle_ = display.newTTFLabel({text = "Title", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
		:pos(itemTitleBgSize.width / 2, itemTitleBgSize.height / 2)
		:addTo(itemTitleBg)

	self.itemImg_ = display.newSprite()
		:pos(bgItemSizeCal.width / 2, bgItemSizeCal.height / 2)
		:addTo(self.itemBg_)

	self.itemImgLoaderId_ = nk.ImageLoader:nextLoaderId()

	local numBgMgrinRight = 30
	local numBgPaddingBot = 45

	self.itemNumBg_ = display.newSprite("#usrInfo_bgRewNum.png")
	local itemNumBgSizeCal = self.itemNumBg_:getContentSize()

	self.itemNumBg_:pos(bgItemSizeCal.width - numBgMgrinRight - itemNumBgSizeCal.width / 2, itemNumBgSizeCal.height / 2 + numBgPaddingBot)
		:addTo(self.itemBg_)

	labelParam.fontSize = 15
	labelParam.color = display.COLOR_WHITE
	self.itemNum_ = display.newTTFLabel({text = "x0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
		:pos(itemNumBgSizeCal.width / 2, itemNumBgSizeCal.height / 2)
		:addTo(self.itemNumBg_)

	labelParam.fontSize = 24
	labelParam.color = display.COLOR_WHITE

	local itemDescMagrinBot = 10
	self.itemDesc_ = display.newTTFLabel({text = "Item Desc", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
	self.itemDesc_:pos(bgItemSizeCal.width / 2, self.itemDesc_:getContentSize().height / 2 + itemDescMagrinBot)
		:addTo(self.itemBg_)

	local oprBtnWidthFix = 7

	local oprBotBtnSize = {
		width = bgItemSizeCal.width - oprBtnWidthFix * 2,
		height = 34
	}

	local oprBtnMagrinBot = 8
	self.botOprBtn_ = cc.ui.UIPushButton.new({normal = "#common_modTransparent.png", pressed = "#common_modTransparent.png", disabled = "#common_modTransparent.png"},
		{scale9 = true})
		:setButtonSize(oprBotBtnSize.width, oprBotBtnSize.height)
		:onButtonClicked(buttontHandler(self, self.onOprBtnBotCallBack_))
		:pos(bgItemSizeCal.width / 2, oprBotBtnSize.height / 2 + oprBtnMagrinBot)
		:addTo(self.itemBg_)

	self.botOprBtn_:setTouchSwallowEnabled(false)
	self.botOprBtn_:setButtonEnabled(false)
end

function MyProptyAffixProdItem:onItemImgLoaded_(success, sprite)
	-- body
	if success then
		--todo
		local itemImgShownSize = {
			width = 120,
			height = 80
		}
		local tex = sprite:getTexture()
        local texSize = tex:getContentSize()

        if self and self.itemImg_ then
        	--todo
        	self.itemImg_:setTexture(tex)
		    self.itemImg_:setTextureRect(cc.rect(0, 0, texSize.width, texSize.height))

		    local scaleX = itemImgShownSize.width / texSize.width
		    local scaleY = itemImgShownSize.height / texSize.height

		    self.itemImg_:scale(scaleX < scaleY and scaleX or scaleY)
        end
	else
		dump("MyProptyAffixProdItem:onItemImgLoaded_.Wrong!")
	end
end

function MyProptyAffixProdItem:onGiftUrlGet_(imgUrl)
	-- body
	if imgUrl ~= nil and string.len(imgUrl) >= 5 then
		--todo
		-- self.giftImgUrl_ = imgUrl
		nk.ImageLoader:loadAndCacheImage(self.itemImgLoaderId_, imgUrl, handler(self, self.onItemImgLoaded_), nk.ImageLoader.CACHE_TYPE_GIFT)
	else
		dump("Get giftUrl Wrong!")
	end
end

function MyProptyAffixProdItem:onGiftNameGet(giftName)
	-- body
	self.itemDesc_:setString(giftName or "Item Desc.")
end

function MyProptyAffixProdItem:setItemData(data)
	-- body
	if data then
		--todo
		
		self.itemActionCallBack_ = data.callback_
		-- Type Props
		if data.type_ == 1 then
			--todo
			self.itemNumBg_:show()

			local propsData = nk.Props:getPropDataByPnid(data.pnid)
			self.itemData_ = propsData

			if self.itemData_ then
				--todo
				self.itemTitle_:setString(self.itemData_.name or "Title.")
				self.itemNum_:setString("x" .. (data.pcnter or 0))

				local itemNumLblSizeWidthCal = self.itemNum_:getContentSize().width
				local itemNumMagrinBgHoriz = 5

				if itemNumLblSizeWidthCal + itemNumMagrinBgHoriz * 2 > self.itemNumBg_:getContentSize().width then
					--todo
					self.itemNumBg_:setScaleX((itemNumLblSizeWidthCal + itemNumMagrinBgHoriz * 2) / self.itemNumBg_:getContentSize().width)
				end

				nk.ImageLoader:loadAndCacheImage(self.itemImgLoaderId_, self.itemData_.image or "", handler(self, self.onItemImgLoaded_),
					nk.ImageLoader.CACHE_TYPE_GIFT)

				self.itemDesc_:setString("使用")
				self.botOprBtn_:setButtonEnabled(true)
			end

		-- Type Gift
		elseif data.type_ == 2 then
			--todo
			self.botOprBtn_:setButtonEnabled(false)
			bm.TouchHelper.new(self.itemBg_, handler(self, self.onItemTouched_))
			self.itemBg_:setTouchSwallowEnabled(false)

			self.itemNumBg_:hide()

			bm.EventCenter:addEventListener(nk.eventNames.USERINFO_GIFTSEL_CHANGED, handler(self, self.checkUsrGiftId))

			if data.giftId_ then
				--todo
				self.giftPid_ = tonumber(data.giftId_)
				local giftExpireDayNum = data.giftExpireTime_ or 0

				self.getGiftUrlId_ = LoadGiftController:getInstance():getGiftUrlById(self.giftPid_, handler(self, self.onGiftUrlGet_))
				self.getGiftNameId_ = LoadGiftController:getInstance():getGiftNameById(self.giftPid_, handler(self, self.onGiftNameGet))
				
				self.itemTitle_:setString(tostring(giftExpireDayNum) .. "天过期")

				if self.giftPid_ == nk.userData["aUser.gift"] then
					--todo
					self.isSelfSelected_ = true
					self.itemBg_:setSpriteFrame("usrInfo_bgItemAffixProptySel.png")
				else
					if self.isSelfSelected_ then
						--todo
						self.isSelfSelected_ = false
						self.itemBg_:setSpriteFrame("usrInfo_bgItemAffixPropty.png")
					end
				end
			end
		end
	end
end

function MyProptyAffixProdItem:onItemTouched_(target, evt)
	-- body
	if evt == bm.TouchHelper.CLICK then
		--todo
		self.isSelfSelected_ = true
		if self.giftPid_ ~= nk.userData["aUser.gift"] then
			--todo
			nk.userData["aUser.gift"] = self.giftPid_
			bm.EventCenter:dispatchEvent({name = nk.eventNames.USERINFO_GIFTSEL_CHANGED, data = self.giftPid_})
		end
	end
end

function MyProptyAffixProdItem:onOprBtnBotCallBack_(evt)
	-- body
	self.botOprBtn_:setButtonEnabled(false)

	if self.itemActionCallBack_ then
		--todo
		self.itemActionCallBack_(self.itemData_)
	end

	if self and self.botOprBtn_ then
		--todo
		self.botOprBtn_:setButtonEnabled(true)
	end
end

function MyProptyAffixProdItem:checkUsrGiftId(evt)
	-- body
	if evt.data == self.giftPid_ then
		--todo
		self.itemBg_:setSpriteFrame("usrInfo_bgItemAffixProptySel.png")
	else
		if self.isSelfSelected_ then
			--todo
			self.itemBg_:setSpriteFrame(display.newSpriteFrame("usrInfo_bgItemAffixPropty.png"))
			self.isSelfSelected_ = false
		end
	end
end

function MyProptyAffixProdItem:getItemSizeCal()
	-- body
	local itemBgSizeCal = self.itemBg_:getContentSize()

	return itemBgSizeCal
end

function MyProptyAffixProdItem:onEnter()
	-- body
end

function MyProptyAffixProdItem:onExit()
	-- body
	nk.ImageLoader:cancelJobByLoaderId(self.itemImgLoaderId_)
end

function MyProptyAffixProdItem:onCleanup()
	-- body
end

return MyProptyAffixProdItem