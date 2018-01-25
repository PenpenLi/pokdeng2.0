--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-03-23 15:52:32
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: ChoosePersonRoomListItem.lua Construct By Tsing7x.
--

local ITEMINFO_MARIN_EXTRA = 10 * nk.widthScale
local ITEMINFO_MAGRIN_GAP = 12 * nk.widthScale
local INFOICON_GAP_LABEL = 4

local ChoosePersonRoomListItem = class("ChoosePersonRoomListItem", bm.ui.ListItem)

function ChoosePersonRoomListItem:ctor()
	-- body
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	self:setNodeEventEnabled(true)

	local roomChoseLeftOprPanelModel = display.newSprite("#hall_auxBgPanel_left.png")
	local roomChoseLeftOprPanelCalSize = roomChoseLeftOprPanelModel:getContentSize()

	local ownerRectMagrinBorder = 2

	local itemSizeHeight = 82
	local itemSize = cc.size(display.width - roomChoseLeftOprPanelCalSize.width - ownerRectMagrinBorder * 2, itemSizeHeight)

	ChoosePersonRoomListItem.super.ctor(self, itemSize.width, itemSize.height)

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

	local labelParam = {
		fontSize = 0,
		color = display.COLOR_WHITE
	}

	-- Init Default Views --
	local roomIdPosXCalib = 38

	labelParam.fontSize = 24
	labelParam.color = display.COLOR_RED

	self.roomId_ = display.newTTFLabel({text = "0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
		:pos(ITEMINFO_MARIN_EXTRA + ITEMINFO_MAGRIN_GAP + roomIdPosXCalib, itemBgSize.height / 2)
		:addTo(self.itemBg_)

	local roomNamePosXCalib = 38

	labelParam.fontSize = 18
	labelParam.color = display.COLOR_WHITE

	self.roomName_ = display.newTTFLabel({text = "RoomName", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
		:pos(ITEMINFO_MARIN_EXTRA + ITEMINFO_MAGRIN_GAP * 3 + roomIdPosXCalib * 2 + roomNamePosXCalib, itemBgSize.height / 2)
		:addTo(self.itemBg_)

	local roomAntePosXCalib = 30

	self.roomAnte_ = display.newTTFLabel({text = "0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
		:pos(ITEMINFO_MARIN_EXTRA + ITEMINFO_MAGRIN_GAP * 5 + roomIdPosXCalib * 2 + roomNamePosXCalib * 2 + roomAntePosXCalib,
			itemBgSize.height / 2)
		:addTo(self.itemBg_)

	local minBuyInPosXCalib = 36

	self.minBuyIn_ = display.newTTFLabel({text = "0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
		:pos(ITEMINFO_MARIN_EXTRA + ITEMINFO_MAGRIN_GAP * 7 + roomIdPosXCalib * 2 + roomNamePosXCalib * 2 + roomAntePosXCalib * 2 +
			minBuyInPosXCalib, itemBgSize.height / 2)
		:addTo(self.itemBg_)

	local roomFeePosXCalib = 42

	self.roomFee_ = display.newTTFLabel({text = "0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
		:pos(ITEMINFO_MARIN_EXTRA + ITEMINFO_MAGRIN_GAP * 9 + roomIdPosXCalib * 2 + roomNamePosXCalib * 2 + roomAntePosXCalib * 2 +
			minBuyInPosXCalib * 2 + roomFeePosXCalib, itemBgSize.height / 2)
		:addTo(self.itemBg_)

	local pswStatePosXCalib = 10

	self.roomPswState_ = display.newSprite("#roomChos_icPerLock.png")
		:pos(ITEMINFO_MARIN_EXTRA + ITEMINFO_MAGRIN_GAP * 11 + roomIdPosXCalib * 2 + roomNamePosXCalib * 2 + roomAntePosXCalib * 2 +
			minBuyInPosXCalib * 2 + roomFeePosXCalib * 2 + pswStatePosXCalib, itemBgSize.height / 2)
		:addTo(self.itemBg_)
		-- :hide()

	local roomOnlineNumPosXCalib = 55

	labelParam.fontSize = 24
	labelParam.color = display.COLOR_RED

	self.onlineIcon = display.newSprite("#roomChos_roomListIcOnlineNum.png")
	self.onLineNum_ = display.newTTFLabel({text = "0/0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})

	local onlineInfoSizeWidth = self.onlineIcon:getContentSize().width + self.onLineNum_:getContentSize().width + INFOICON_GAP_LABEL

	local onlineNumInfoPosX = ITEMINFO_MARIN_EXTRA + ITEMINFO_MAGRIN_GAP * 13 + roomIdPosXCalib * 2 + roomNamePosXCalib * 2 + 
		roomAntePosXCalib * 2 + minBuyInPosXCalib * 2 + roomFeePosXCalib * 2 + pswStatePosXCalib * 2 + roomOnlineNumPosXCalib

	self.onlineIcon:pos(onlineNumInfoPosX - (onlineInfoSizeWidth - self.onlineIcon:getContentSize().width) / 2, itemBgSize.height / 2)
		:addTo(self.itemBg_)

	self.onLineNum_:pos(onlineNumInfoPosX + (onlineInfoSizeWidth - self.onLineNum_:getContentSize().width) / 2, itemBgSize.height / 2)
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

function ChoosePersonRoomListItem:onDataSet(isChanged, data)
	-- body
	if isChanged then
		--todo
		local itemBgSize = self.itemBg_:getContentSize()

		local roomIdPosXCalib = 38
		local roomNamePosXCalib = 38
		local roomAntePosXCalib = 30
		local minBuyInPosXCalib = 36
		local roomFeePosXCalib = 42
		local pswStatePosXCalib = 10
		local roomOnlineNumPosXCalib = 55

		self.roomId_:setString(data.tableID or "null")
		self.roomName_:setString(data.roomName or "null")
		self.roomAnte_:setString(bm.formatBigNumber(data.baseChip or 0))
		self.minBuyIn_:setString(bm.formatBigNumber(data.minAnte or 0))
		self.roomFee_:setString(bm.formatBigNumber(data.fee or 0))

		if checkint(data.hasPwd) == 1 then
			--todo
			self.roomPswState_:show()
		else
			self.roomPswState_:hide()
		end
		
		local onlineNumInfoPosX = ITEMINFO_MARIN_EXTRA + ITEMINFO_MAGRIN_GAP * 13 + roomIdPosXCalib * 2 + roomNamePosXCalib * 2 + 
			roomAntePosXCalib * 2 + minBuyInPosXCalib * 2 + roomFeePosXCalib * 2 + pswStatePosXCalib * 2 + roomOnlineNumPosXCalib

		self.onLineNum_:setString(tostring(data.userCount) .. "/9")

		local onlineInfoSizeWidth = self.onlineIcon:getContentSize().width + self.onLineNum_:getContentSize().width + INFOICON_GAP_LABEL

		self.onlineIcon:pos(onlineNumInfoPosX - (onlineInfoSizeWidth - self.onlineIcon:getContentSize().width) / 2, itemBgSize.height / 2)
		self.onLineNum_:pos(onlineNumInfoPosX + (onlineInfoSizeWidth - self.onLineNum_:getContentSize().width) / 2, itemBgSize.height / 2)

		self.roomEntryBtn_:setButtonEnabled(true)
	end
end

function ChoosePersonRoomListItem:onEntryRoomCallBack_(evt)
	-- body
	self:dispatchEvent({name="ITEM_EVENT", data = self.data_})
end

function ChoosePersonRoomListItem:onEnter()
	-- body
end

function ChoosePersonRoomListItem:onExit()
	-- body
end

function ChoosePersonRoomListItem:onCleanup()
	-- body
end
return ChoosePersonRoomListItem