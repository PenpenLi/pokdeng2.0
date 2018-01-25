--
-- Author: XT
-- Date: 2015-09-21 15:00:02
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: AnimUpScrollQueue.lua ReConstructed By Tsing7x.
--

local INFOSTRTAB_MAXSIZE = 10

local AnimUpScrollQueue = class("AnimUpScrollQueue", function()
	return display.newNode()
end)

-- AnimUpScrollQueue Widget Anchor :CENTER
function AnimUpScrollQueue:ctor(contentSize, lblSize, color)
	self:setNodeEventEnabled(true)

	self.index_ = 1
	self.isPlaying_ = false

	self.contentSize_ = contentSize or cc.size(300, 32)
	self.lblSize_ = lblSize or 16
	self.color_ = color or display.COLOR_WHITE

	local tipsInfoDisplayStencil = display.newDrawNode()
	tipsInfoDisplayStencil:drawPolygon{
		{- self.contentSize_.width / 2, - self.contentSize_.height / 2},
		{- self.contentSize_.width / 2, self.contentSize_.height / 2},
		{self.contentSize_.width / 2, self.contentSize_.height / 2},
		{self.contentSize_.width / 2, - self.contentSize_.height / 2}
	}

	self.clipNode_ = cc.ClippingNode:create()
		:addTo(self)

	self.clipNode_:setStencil(tipsInfoDisplayStencil)

	self.lbl1_ = display.newTTFLabel({text = "", color = self.color_, size = self.lblSize_,	dimensions = self.contentSize_,
		align  = ui.TEXT_ALIGN_LEFT})
		:addTo(self.clipNode_)

	self.lbl2_ = display.newTTFLabel({text = "", color = self.color_, size = self.lblSize_,	dimensions = self.contentSize_,
		align =  ui.TEXT_ALIGN_LEFT})
		:addTo(self.clipNode_)
end

-- Start Play Anim --
function AnimUpScrollQueue:startAnim()
	if not self.isPlaying_ then
		--todo
		self.isPlaying_ = true
		self:playerNext_()
	end
end

function AnimUpScrollQueue:playerNext_()
	if not self.data_ or #self.data_ <= 0 then
		return
	end

	local lblAnimOutTime = 0.5
	local lblAnimDisplayDelayTime = 3.0
	local lblAnimInTime = 1.0

	if self.lastLbl_ then
		self.lastLbl_:runAction(transition.sequence({cc.MoveTo:create(lblAnimOutTime, cc.p(0, self.contentSize_.height))}))
		transition.fadeOut(self.lastLbl_, {time = lblAnimOutTime})
	end
	
	local lbl = self:getIdleLbl()
	lbl:setString(self.data_[self.index_])

	lbl:pos(0, - self.contentSize_.height)
	lbl:runAction(transition.sequence({cc.MoveTo:create(lblAnimOutTime, cc.p(0, 0)), cc.DelayTime:create(lblAnimDisplayDelayTime),
		cc.CallFunc:create(handler(self, self.callbackPlayerNext_))}))

	transition.fadeIn(lbl, {time = lblAnimInTime})

	self.index_ = self.index_ + 1
	if self.index_ > INFOSTRTAB_MAXSIZE or self.index_ > #self.data_ then
		self.index_ = 1
	end
end

function AnimUpScrollQueue:callbackPlayerNext_()
	if self.isPlaying_ then
		self.lastLbl_ = self:getIdleLbl()
		self:playerNext_()
	end
end

-- Stop Anim --
function AnimUpScrollQueue:stopAnim()
	self.isPlaying_ = false

	self:stopAllActions()
end

-- Set InfoStr Queue. --
function AnimUpScrollQueue:setData(values)
	self.data_ = values
end

-- Add A New InfoStr --
function AnimUpScrollQueue:addMsg(msg)
	if not self.data_ then
		self.data_ = {}
	else
		if #self.data_ >= INFOSTRTAB_MAXSIZE then
			table.remove(self.data_, 1)

			self.index_ = self.index_ - 1
			if self.index_ < 1 then
				self.index_ = 1
			end
		end
	end

	table.insert(self.data_, msg)
end

-- Set Queue Size --
function AnimUpScrollQueue:setMaxSize(value)
	self.size_ = value or 1

	if self.size_ < 1 then
		self.size_ = 1
	end
end

function AnimUpScrollQueue:getIdleLbl()
	if not self.lastLbl_ then
		return self.lbl1_
	end

	if self.lastLbl_ == self.lbl1_ then
		return self.lbl2_
	else
		return self.lbl1_
	end
end

function AnimUpScrollQueue:onEnter()
	-- body
end

function AnimUpScrollQueue:onExit()
	-- body
end

function AnimUpScrollQueue:onCleanup()
	-- body
end

return AnimUpScrollQueue