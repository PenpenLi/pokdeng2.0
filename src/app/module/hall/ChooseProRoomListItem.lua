--
-- Author: TsingZhang@boyaa.com
-- Date: 2016-05-11 16:44:17
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: ChooseProRoomListItem.lua By TsingZhang, Compatiable For GrabRoomChoose && CashRoomChoose.
--

local ITEMINFO_MAGRIN_GAP = 24 * nk.widthScale
local INFOICON_GAP_LABEL = 4

local ChooseProRoomListItem = class("ChooseProRoomListItem", bm.ui.ListItem)

function ChooseProRoomListItem:ctor()
	-- body
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	self:setNodeEventEnabled(true)

	local roomChoseLeftOprPanelModel = display.newSprite("#hall_auxBgPanel_left.png")
	local roomChoseLeftOprPanelCalSize = roomChoseLeftOprPanelModel:getContentSize()

	local ownerRectMagrinBorder = 2

	local itemSizeHeight = 80
	local itemSize = cc.size(display.width - roomChoseLeftOprPanelCalSize.width - ownerRectMagrinBorder * 2, itemSizeHeight)

	ChooseProRoomListItem.super.ctor(self, itemSize.width, itemSize.height)

	local itemBgPanelStencil = {
		x = 91,
		y = 10,
		width = 510,
		height = 70
	}

	local itemBgSizeHAdj = 2
	self.itemBg_ = display.newScale9Sprite("#roomChos_roomListBgItem.png", itemSize.width / 2, itemSize.height / 2, cc.size(itemSize.width,
		itemSize.height + itemBgSizeHAdj * 2), cc.rect(itemBgPanelStencil.x, itemBgPanelStencil.y, itemBgPanelStencil.width, itemBgPanelStencil.height))
		:addTo(self)

	itemBgSize = self.itemBg_:getContentSize()

	-- Init Default Views --
	local avatarBgPosXCalib = 34
	local avatarBg = display.newSprite("#roomChos_roomCashAvatar.png")
	avatarBg:pos(ITEMINFO_MAGRIN_GAP + avatarBgPosXCalib, itemBgSize.height / 2)
		:addTo(self.itemBg_)

	self.avatar_ = display.newSprite()
		:pos(avatarBg:getContentSize().width / 2, avatarBg:getContentSize().height / 2)
		:addTo(avatarBg)

	self.userAvatarLoaderId_ = nk.ImageLoader:nextLoaderId()

	-- Init LableParam --
	local labelParam = {
		fontSize = 0,
		color = display.COLOR_WHITE
	}

	-- labelParam.fontSize = 20
	-- labelParam.color = display.COLOR_WHITE

	-- self.noDealerHint_ = display.newTTFLabel({text = "空庄", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
	-- 	:pos(avatarBg:getContentSize().width / 2, avatarBg:getContentSize().height / 2)
	-- 	:addTo(avatarBg)

	local anteMoneyInfoPosXCalib = 20

	labelParam.fontSize = 25
	labelParam.color = display.COLOR_RED

	self.currencyIcon = display.newSprite("#roomChos_roomCashIcCurrency.png")
	self.anteMoney_ = display.newTTFLabel({text = "0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})

	local anteMoneyInfoSizeWidth = self.currencyIcon:getContentSize().width + self.anteMoney_:getContentSize().width + INFOICON_GAP_LABEL

	local anteMoneyInfoPosX = ITEMINFO_MAGRIN_GAP * 3 + avatarBgPosXCalib * 2 + anteMoneyInfoPosXCalib
	self.currencyIcon:pos(anteMoneyInfoPosX - (anteMoneyInfoSizeWidth - self.currencyIcon:getContentSize().width) / 2, itemBgSize.height / 2)
		:addTo(self.itemBg_)

	self.anteMoney_:pos(anteMoneyInfoPosX + (anteMoneyInfoSizeWidth - self.anteMoney_:getContentSize().width) / 2, itemBgSize.height / 2)
		:addTo(self.itemBg_)

	local minToGrabLblPosXCailb = 62
	labelParam.fontSize = 22
	labelParam.color = display.COLOR_WHITE

	local minToGrabCurryLblPosX = ITEMINFO_MAGRIN_GAP * 5 + avatarBgPosXCalib * 2 + anteMoneyInfoPosXCalib * 2 + minToGrabLblPosXCailb
	self.minToGrabCurry_ = display.newTTFLabel({text = "0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
		:pos(minToGrabCurryLblPosX, itemBgSize.height / 2)
		:addTo(self.itemBg_)

	local entryGateLblPosXCalib = 45

	local entryGateCurryLblPosX = ITEMINFO_MAGRIN_GAP * 7 + avatarBgPosXCalib * 2 + anteMoneyInfoPosXCalib * 2 + minToGrabLblPosXCailb * 2 +
		entryGateLblPosXCalib
	self.entryThre_ = display.newTTFLabel({text = "0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
		:pos(entryGateCurryLblPosX, itemBgSize.height / 2)
		:addTo(self.itemBg_)

	local onlineNumInfoPosXCalib = 52

	labelParam.fontSize = 24
	labelParam.color = display.COLOR_GREEN

	self.onlineIcon = display.newSprite("#roomChos_roomListIcOnlineNum.png")
	self.onlineNum_ = display.newTTFLabel({text = "0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})

	local onlineInfoSizeWidth = self.onlineIcon:getContentSize().width + self.onlineNum_:getContentSize().width + INFOICON_GAP_LABEL

	local onlineNumInfoPosX = ITEMINFO_MAGRIN_GAP * 9 + avatarBgPosXCalib * 2 + anteMoneyInfoPosXCalib * 2 + minToGrabLblPosXCailb * 2 +
		entryGateLblPosXCalib * 2 + onlineNumInfoPosXCalib

	self.onlineIcon:pos(onlineNumInfoPosX - (onlineInfoSizeWidth - self.onlineIcon:getContentSize().width) / 2, itemBgSize.height / 2)
		:addTo(self.itemBg_)

	self.onlineNum_:pos(onlineNumInfoPosX + (onlineInfoSizeWidth - self.onlineNum_:getContentSize().width) / 2, itemBgSize.height / 2)
		:addTo(self.itemBg_)

	local btnSizeWidth = 160
	self.roomEntryBtn_ = cc.ui.UIPushButton.new({normal = "#roomChos_roomListEntry.png", pressed = "#roomChos_roomListEntry.png",
		disabled = "#roomChos_roomListEntry.png"}, {scale9 = false})
		:onButtonClicked(handler(self, self.onEntryRoomCallBack_))
		:pos(itemBgSize.width - btnSizeWidth / 2, itemBgSize.height / 2)
		:addTo(self.itemBg_)

	self.roomEntryBtn_:setTouchSwallowEnabled(false)
	self.roomEntryBtn_:setButtonEnabled(false)
end

function ChooseProRoomListItem:onDataSet(isChanged, data)
	-- body
	-- dump(data, "ChooseProRoomListItem:onDataSet.data :==========================")
	
	if isChanged then
		--todo
		local itemBgSize = self.itemBg_:getContentSize()

		local avatarBgPosXCalib = 34
		local anteMoneyInfoPosXCalib = 20
		local minToGrabLblPosXCailb = 62
		local entryGateLblPosXCalib = 45

		local anteMoneyInfoPosX = ITEMINFO_MAGRIN_GAP * 3 + avatarBgPosXCalib * 2 + anteMoneyInfoPosXCalib

		self.anteMoney_:setString(bm.formatBigNumber(data.basechip or 0))

		local anteMoneyInfoSizeWidth = self.currencyIcon:getContentSize().width + self.anteMoney_:getContentSize().width + INFOICON_GAP_LABEL

		self.currencyIcon:pos(anteMoneyInfoPosX - (anteMoneyInfoSizeWidth - self.currencyIcon:getContentSize().width) / 2, itemBgSize.height / 2)
		self.anteMoney_:pos(anteMoneyInfoPosX + (anteMoneyInfoSizeWidth - self.anteMoney_:getContentSize().width) / 2, itemBgSize.height / 2)

		self.minToGrabCurry_:setString(bm.formatBigNumber(data.minante or 0))
		self.entryThre_:setString(bm.formatBigNumber(data.door or 0))

		local onlineNumInfoPosXCalib = 52
		local onlineNumInfoPosX = ITEMINFO_MAGRIN_GAP * 9 + avatarBgPosXCalib * 2 + anteMoneyInfoPosXCalib * 2 + minToGrabLblPosXCailb * 2 +
			entryGateLblPosXCalib * 2 + onlineNumInfoPosXCalib

		self.onlineNum_:setString(tostring(data.userCount or 0) .. "/" .. (data.seatcout or 10))

		local onlineInfoSizeWidth = self.onlineIcon:getContentSize().width + self.onlineNum_:getContentSize().width + INFOICON_GAP_LABEL

		self.onlineIcon:pos(onlineNumInfoPosX - (onlineInfoSizeWidth - self.onlineIcon:getContentSize().width) / 2, itemBgSize.height / 2)
		self.onlineNum_:pos(onlineNumInfoPosX + (onlineInfoSizeWidth - self.onlineNum_:getContentSize().width) / 2, itemBgSize.height / 2)
		
		if not data.userinfo or string.len(data.userinfo) < 5 then
			--todo
			self.avatar_:hide()
			-- self.sexIcon_:hide()
			-- self.noDealerHint_:show()
		else
			local userinfoData = json.decode(data.userinfo)
			if userinfoData then
				--todo
				-- self.noDealerHint_:hide()
				self.avatar_:show()
				-- self.sexIcon_:show()

				local imgUrl = userinfoData.mavatar
				if not imgUrl or string.len(imgUrl) <= 5 then
					--todo
					if checkint(userinfoData.msex) ~= 1 then
			            self:onAvatarLoadComplete_(true, display.newSprite("#common_female_avatar.png"))
			            -- self.sexIcon_:setSpriteFrame(display.newSpriteFrame("female_icon.png"))
			        else
			            self:onAvatarLoadComplete_(true, display.newSprite("#common_female_avatar.png"))
			            -- self.sexIcon_:setSpriteFrame(display.newSpriteFrame("male_icon.png"))
			        end
				else
					if string.find(imgUrl, "facebook") then
		                if string.find(imgUrl, "?") then
		                    imgUrl = imgUrl .. "&width=100&height=100"
		                else
		                    imgUrl = imgUrl .. "?width=100&height=100"
		                end
		            end

		            nk.ImageLoader:loadAndCacheImage(self.userAvatarLoaderId_, imgUrl, handler(self, self.onAvatarLoadComplete_), 
		                nk.ImageLoader.CACHE_TYPE_USER_HEAD_IMG)
				end
			end
		end

		self.roomEntryBtn_:setButtonEnabled(true)
		-- self.roomEntryBtn_:setTouchSwallowEnabled(true)
	end
end

function ChooseProRoomListItem:onAvatarLoadComplete_(success, sprite)
	-- body
	if success then
		local tex = sprite:getTexture()
        local texSize = tex:getContentSize()

		local avatarShownBorden = 60
        if self and self.avatar_ then
            --todo
            self.avatar_:setTexture(tex)
            self.avatar_:setTextureRect(cc.rect(0, 0, texSize.width, texSize.height))

            if texSize.width >= texSize.height then
            	--todo
            	self.avatar_:scale(avatarShownBorden / texSize.width)
            else
            	self.avatar_:scale(avatarShownBorden / texSize.height)
            end
        end
    end
end

function ChooseProRoomListItem:onEntryRoomCallBack_(evt)
	-- body
	self:dispatchEvent({name="ITEM_EVENT", data = self.data_})
end

function ChooseProRoomListItem:onEnter()
	-- body
end

function ChooseProRoomListItem:onExit()
	-- body
	nk.ImageLoader:cancelJobByLoaderId(self.userAvatarLoaderId_)
	self.userAvatarLoaderId_ = nil
end

function ChooseProRoomListItem:onCleanup()
	-- body
end

return ChooseProRoomListItem