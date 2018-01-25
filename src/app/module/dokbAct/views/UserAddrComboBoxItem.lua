--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-04-12 15:35:33
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: UserAddrComboBoxItem.lua Create && Reconstructed By Tsing7x.
--
local ITEM_WIDTH = 118
local ITEM_HEIGHT = 25

local UserAddrComboBoxItem = class("UserAddrComboBoxItem", bm.ui.ListItem)

function UserAddrComboBoxItem:ctor()
	-- body
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	self:setNodeEventEnabled(true)

	UserAddrComboBoxItem.super.ctor(self, ITEM_WIDTH, ITEM_HEIGHT)

	-- self.itemBg_ = display.newScale9Sprite("#userAddr_denItem_unSel.png", ITEM_WIDTH / 2, ITEM_HEIGHT / 2, cc.size(ITEM_WIDTH,
	-- 	ITEM_HEIGHT))
	-- 	:addTo(self)
	local labelParam = {
		fontSize = 0,
		color = display.COLOR_WHITE
	}

	labelParam.fontSize = 20

	local btnLblColorNor = display.COLOR_BLUE
	local btnLblColorPre = display.COLOR_WHITE

	self.itemBgBtn_ = cc.ui.UIPushButton.new({normal = "#userAddr_denItem_nor.png", pressed = "#userAddr_denItem_pre.png", disabled = "#userAddr_denItem_nor.png"},
		{scale9 = true})
		:setButtonSize(ITEM_WIDTH, ITEM_HEIGHT)
		:setButtonLabel("normal", display.newTTFLabel({text = "name.", size = labelParam.fontSize, color = btnLblColorNor, align = ui.TEXT_ALIGN_CENTER}))
		:setButtonLabel("pressed", display.newTTFLabel({text = "name.", size = labelParam.fontSize, color = btnLblColorPre, align = ui.TEXT_ALIGN_CENTER}))
		:onButtonPressed(function(evt)
			-- body
			self.btnPressedX_ = evt.x
			self.btnClickCanceled_ = false
		end)
		:onButtonRelease(function(evt)
			-- body
			if math.abs(evt.x - self.btnPressedX_) > 2 then
				self.btnClickCanceled_ = true
			end
		end)
		:onButtonClicked(function(evt)
			-- body
			if not self.btnClickCanceled_ and self:getParent():getCascadeBoundingBox():containsPoint(cc.p(evt.x, evt.y)) then
				--todo
				nk.SoundManager:playSound(nk.SoundManager.CLICK_BUTTON)
				self:selectHandler_(evt)
			end
		end)
		:pos(ITEM_WIDTH / 2, ITEM_HEIGHT / 2)
		:addTo(self)

	self.itemBgBtn_:setTouchSwallowEnabled(false)
	self.itemBgBtn_:setButtonEnabled(false)
end

function UserAddrComboBoxItem:onDataSet(dataChanged, data)
	-- body
	if dataChanged then
		--todo
		self.data_ = data
		self.itemBgBtn_:getButtonLabel("normal"):setString(self.data_.title)
		self.itemBgBtn_:getButtonLabel("pressed"):setString(self.data_.title)

		self.itemBgBtn_:setButtonEnabled(true)
	end
end

function UserAddrComboBoxItem:selectHandler_(evt)
	-- body
	self:dispatchEvent({name="ITEM_EVENT", type="DROPDOWN_LIST_SELECT", data = self.data_})
end

function UserAddrComboBoxItem:onEnter()
	-- body
end

function UserAddrComboBoxItem:onExit()
	-- body
end

function UserAddrComboBoxItem:onCleanup()
	-- body
end

return UserAddrComboBoxItem