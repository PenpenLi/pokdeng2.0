--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-06-08 11:22:44
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: ExcPrdLineListItem.lua Created By Tsing7x.
--

local ExchangePrdItem = import(".ExchangePrdItem")

local ExcPrdLineListItem = class("ExcPrdLineListItem", bm.ui.ListItem)

function ExcPrdLineListItem:ctor()
	-- body
	self:setNodeEventEnabled(true)

	local excPrdItemModel = ExchangePrdItem.new()
	local excPrdItemSize = excPrdItemModel:getItemSizeCal()

	local excPrdItemGaps = {
		horiz = 36,
		vect = 28
	}

	local excPrdLineItemSize = {
		width = excPrdItemSize.width * 3 + excPrdItemGaps.horiz * 3,
		height = excPrdItemSize.height + excPrdItemGaps.vect
	}

	self.super.ctor(self, excPrdLineItemSize.width, excPrdLineItemSize.height)
	
	self.excPrdItems_ = {}
	for i = 1, 3 do
		self.excPrdItems_[i] = ExchangePrdItem.new()
			:pos((excPrdItemSize.width + excPrdItemGaps.horiz) / 2 * (i * 2 - 1), excPrdLineItemSize.height / 2)
			:addTo(self)
			:hide()
	end
end

function ExcPrdLineListItem:onDataSet(isDataChange, data)
	-- body
	if isDataChange then
		--todo
		for i = 1, 3 do
			if data[i] then
				--todo
				data[i].excCallBack_ = self.excActionCallBack_

				self.excPrdItems_[i]:show()
				self.excPrdItems_[i]:setPrdItemData(data[i])
			end
		end
	end
end

function ExcPrdLineListItem:setExcActionCallBack(callback)
	-- body
	self.excActionCallBack_ = callback
end

function ExcPrdLineListItem:onEnter()
	-- body
end

function ExcPrdLineListItem:onExit()
	-- body
end

function ExcPrdLineListItem:onCleanup()
	-- body
end

return ExcPrdLineListItem