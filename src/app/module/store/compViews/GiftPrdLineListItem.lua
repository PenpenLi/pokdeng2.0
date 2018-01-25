--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-06-14 11:13:49
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: GiftPrdLineListItem.lua Created && Constructed By Tsing7x.
--

local GiftPrdItem = import(".GiftPrdItem")

local GiftPrdLineListItem = class("GiftPrdLineListItem", bm.ui.ListItem)

function GiftPrdLineListItem:ctor(giftListData)
	-- body
	self:setNodeEventEnabled(true)

	local prdGiftItemModel = GiftPrdItem.new()
	prdGiftItemSizeCal = prdGiftItemModel:getItemSizeCal()

	local prdGiftItemGaps = {
		horiz = 4,
		vect = 8
	}

	local giftPrdLineItemSize = {
		width = prdGiftItemSizeCal.width * 4 + prdGiftItemGaps.horiz * 4,
		height = prdGiftItemSizeCal.height + prdGiftItemGaps.vect
	}

	self.super.ctor(self, giftPrdLineItemSize.width, giftPrdLineItemSize.height)

	self.giftPrdItems_ = {}
	for i = 1, 4 do
		self.giftPrdItems_[i] = GiftPrdItem.new()
			:pos((prdGiftItemSizeCal.width + prdGiftItemGaps.horiz) / 2 * (i * 2 - 1), (prdGiftItemGaps.vect + prdGiftItemSizeCal.height) / 2)
			:addTo(self)
			:hide()
	end
end

function GiftPrdLineListItem:onDataSet(changed, data)
	-- body
	if changed then
		--todo
		for i = 1, 4 do
			if data[i] then
				--todo
				data[i].callback_ = self.prdItemActionCallBack_

				self.giftPrdItems_[i]:show()
				self.giftPrdItems_[i]:setItemData(data[i])
			end
		end
	end
end

function GiftPrdLineListItem:setGiftPrdActionCallBack(callback)
	-- body
	self.prdItemActionCallBack_ = callback
end

function GiftPrdLineListItem:onEnter()
	-- body
end

function GiftPrdLineListItem:onExit()
	-- body
end

function GiftPrdLineListItem:onCleanup()
	-- body
end

return GiftPrdLineListItem