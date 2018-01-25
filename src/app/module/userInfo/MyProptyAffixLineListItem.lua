--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-05-22 15:18:26
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: MyProptyAffixLineListItem.lua Create By Tsing7x.
--

local MyProptyAffixProdItem = import(".MyProptyAffixProdItem")

local MyProptyAffixLineListItem = class("MyProptyAffixLineListItem", bm.ui.ListItem)

function MyProptyAffixLineListItem:ctor()
	-- body
	self:setNodeEventEnabled(true)

	local proptyProdItemModel = MyProptyAffixProdItem.new()

	local proptyProdItemSizeCal = proptyProdItemModel:getItemSizeCal()

	local proptyProdItemGaps = {
		horiz = 14,
		vect = 6
	}

	local proptyLineListItemSize = {
		width = proptyProdItemSizeCal.width * 3 + proptyProdItemGaps.horiz * 3,
		height = proptyProdItemSizeCal.height + proptyProdItemGaps.vect
	}

	self.super.ctor(self, proptyLineListItemSize.width, proptyLineListItemSize.height)

	self.proptyProdItems_ = {}
	for i = 1, 3 do
		self.proptyProdItems_[i] = MyProptyAffixProdItem.new()  -- PS: Not Use proptyProdItemModel:clone() May Not Clone Addtional Btn Evt
			:pos((proptyProdItemSizeCal.width + proptyProdItemGaps.horiz) / 2 * (i * 2 - 1), proptyLineListItemSize.height / 2)
			:addTo(self)
			:hide()
	end
end

function MyProptyAffixLineListItem:onDataSet(isDataChange, data)
	-- body
	if isDataChange then
		--todo
		for i = 1, 3 do
			if data[i] then
				--todo
				data[i].type_ = self.proptyType_
				data[i].callback_ = self.proptyActionCallBack_
				
				self.proptyProdItems_[i]:show()
				self.proptyProdItems_[i]:setItemData(data[i])
			end
		end
	end
end

-- @param type: type(type) = "number", 1.Type Props; 2.Type Gift.
function MyProptyAffixLineListItem:setProptyType(type)
	-- body
	self.proptyType_ = type
end

function MyProptyAffixLineListItem:setProptyActionCallBack(callback)
	-- body
	self.proptyActionCallBack_ = callback
end

function MyProptyAffixLineListItem:onEnter()
	-- body
end

function MyProptyAffixLineListItem:onExit()
	-- body
end

function MyProptyAffixLineListItem:onCleanup()
	-- body
end

return MyProptyAffixLineListItem