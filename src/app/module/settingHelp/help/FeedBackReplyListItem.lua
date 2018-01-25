--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-05-17 11:51:52
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: FeedBackReplyListItem.lua Create By Tsing7x.
--
local ITEMSIZE = nil
local QUESQMARK_SIZE = nil

local FeedBackReplyListItem = class("FeedBackReplyListItem", bm.ui.ListItem)

function FeedBackReplyListItem:ctor()
	-- body
	self:setNodeEventEnabled(true)
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

	local defaultItemDesignSize = {
		width = 592,
		height = 82
	}

	ITEMSIZE = cc.size(defaultItemDesignSize.width, defaultItemDesignSize.height)
	self.super.ctor(self, ITEMSIZE.width, ITEMSIZE.height)

	local labelParam = {
		fontSize = 0,
		color = display.COLOR_BLACK
	}

	local quesQMarkIcMagrinLeftRight = 6
	self.quesQMarkIc_ = display.newSprite("#help_icQMarkRecord.png")
	QUESQMARK_SIZE = self.quesQMarkIc_:getContentSize()

	self.quesQMarkIc_:pos(quesQMarkIcMagrinLeftRight + QUESQMARK_SIZE.width / 2, ITEMSIZE.height - QUESQMARK_SIZE.height / 2)
		:addTo(self)

	local userQuesLblShownWidth = ITEMSIZE.width - quesQMarkIcMagrinLeftRight * 2 - QUESQMARK_SIZE.width
	labelParam.fontSize = 22
	labelParam.color = cc.c3b(0x64, 0x9a, 0xc9)  -- Color Ques

	self.userQuesLabel_ = display.newTTFLabel({text = "Question :", size = labelParam.fontSize, color = labelParam.color, dimensions = cc.size(userQuesLblShownWidth,
		0), align = ui.TEXT_ALIGN_LEFT})
	self.userQuesLabel_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
	self.userQuesLabel_:pos(quesQMarkIcMagrinLeftRight * 2 + QUESQMARK_SIZE.width, ITEMSIZE.height - self.userQuesLabel_:getContentSize().height / 2)
		:addTo(self)

	local cusReplyLblShiftQuesLbl = 5
	local cusReplyLblShownWidth = ITEMSIZE.width - quesQMarkIcMagrinLeftRight * 2 - QUESQMARK_SIZE.width - cusReplyLblShiftQuesLbl

	labelParam.color = cc.c3b(0x64, 0x9a, 0xc9)  -- Color CusReply

	self.cusReplyLabel_ = display.newTTFLabel({text = "Reply :", size = labelParam.fontSize, color = labelParam.color, dimensions = cc.size(cusReplyLblShownWidth,
		0), align = ui.TEXT_ALIGN_LEFT})
	self.cusReplyLabel_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
	self.cusReplyLabel_:pos(quesQMarkIcMagrinLeftRight * 2 + QUESQMARK_SIZE.width + cusReplyLblShiftQuesLbl, ITEMSIZE.height - QUESQMARK_SIZE.height -
		self.cusReplyLabel_:getContentSize().height / 2)
		:addTo(self)
end

function FeedBackReplyListItem:onDataSet(dataChanged, data)
	-- body
	if dataChanged then
		--todo
		self.userQuesLabel_:setString(data.content or "Question. :")
		local userQuesLblContSize = self.userQuesLabel_:getContentSize()

		self.cusReplyLabel_:setString(data.answer or "Reply. :")
		local cusReplyLblContSize = self.cusReplyLabel_:getContentSize()

		local itemHeight = 0
		local cusReplyLblPaddingTop = 0
		if userQuesLblContSize.height <= QUESQMARK_SIZE.height then
			--todo
			cusReplyLblPaddingTop = QUESQMARK_SIZE.height
			itemHeight = QUESQMARK_SIZE.height + cusReplyLblContSize.height
		else
			cusReplyLblPaddingTop = userQuesLblContSize.height
			itemHeight = userQuesLblContSize.height + cusReplyLblContSize.height
		end

		ITEMSIZE = cc.size(ITEMSIZE.width, itemHeight)
		self:setContentSize(ITEMSIZE)
		
		self.quesQMarkIc_:setPositionY(ITEMSIZE.height - QUESQMARK_SIZE.height / 2)
		self.userQuesLabel_:setPositionY(ITEMSIZE.height - userQuesLblContSize.height / 2)
		self.cusReplyLabel_:setPositionY(ITEMSIZE.height - cusReplyLblPaddingTop - cusReplyLblContSize.height / 2)

		self:dispatchEvent({name = "RESIZE"})
	end
end

function FeedBackReplyListItem:onEnter()
	-- body
end

function FeedBackReplyListItem:onExit()
	-- body
end

function FeedBackReplyListItem:onCleanup()
	-- body
end

return FeedBackReplyListItem