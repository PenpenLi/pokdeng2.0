--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-04-25 12:11:29
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: AdPromtPageItem.lua Create By Tsing7x.
--

local AdPromtPageItem = class("AdPromtPageItem", bm.ui.ListItem)

-- WIDTH && HEIGHT NEEDED! --
AdPromtPageItem.WIDTH = 242
AdPromtPageItem.HEIGHT = 242

function AdPromtPageItem:ctor()
	-- body
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	self:setNodeEventEnabled(true)

	self.itemBg_ = display.newScale9Sprite("#common_modRiAnGrey.png", 0, 0, cc.size(self.WIDTH, self.HEIGHT))
		:addTo(self)

	self.itemBg_:setTouchEnabled(true)
	self.itemBg_:setTouchSwallowEnabled(false)

	self.itemBg_:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch_))
end

function AdPromtPageItem:onDataSet(dataChanged, data)
	-- body
	if dataChanged then
		--todo
		local bgImg = data.adImg or "common_modTransparent.png"

		self.itemBg_:setSpriteFrame(display.newSpriteFrame(bgImg))
		self.itemBg_:setContentSize(self.WIDTH, self.HEIGHT)
	end
end

function AdPromtPageItem:onTouch_(evt)
	-- body
	if evt.name == "began" then
		--todo
		self.touchPosXSrc_ = evt.x
		return true
	elseif evt.name == "moved" then
		--todo
		self.touchPosXDes_ = evt.x
	elseif evt.name == "ended" or name == "cancelled" then
		--todo
		local touchMoveDistance = math.abs(self.touchPosXSrc_ - (self.touchPosXDes_ or self.touchPosXSrc_))

		if touchMoveDistance <= self.WIDTH / 10 then
			--todo
			self:dispatchEvent({name="ITEM_EVENT", data = self.data_})
		end
	end
end

function AdPromtPageItem:onEnter()
	-- body
end

function AdPromtPageItem:onExit()
	-- body
end

function AdPromtPageItem:onCleanup()
	-- body
end

return AdPromtPageItem