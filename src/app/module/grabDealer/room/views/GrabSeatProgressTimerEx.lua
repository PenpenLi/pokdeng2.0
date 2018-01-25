
local GrabSeatProgressTimerEx = class("GrabSeatProgressTimerEx",function()
	return display.newNode()
end)


function GrabSeatProgressTimerEx:ctor(second)
	 self:setNodeEventEnabled(true)
	 self.second_ = second
    self.progressTimer_ = cc.ProgressTimer:create(cc.Sprite:create("test/circle_bg.png"))
   	self.progressTimer_:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    -- self.progressTimer_:setPosition(CCPointMake(100, s.height / 2))
	self:addChild(self.progressTimer_)	
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onEnterFrame))
end

function GrabSeatProgressTimerEx:onEnter()
	local fromto = cc.ProgressFromTo:create(self.second_, 100,0)
	self.progressTimer_:runAction(cc.RepeatForever:create(fromto))
	-- self.progressTimer_:setReverseProgress(true)
	self.progressTimer_:setReverseDirection(true)
	self:scheduleUpdate()
end



function GrabSeatProgressTimerEx:onEnterFrame(evt, isFastForward)
	self:setColor()

end



function GrabSeatProgressTimerEx:setPercentage(percentage)
	if self.progressTimer_ then
		self.progressTimer_:setPercentage(setPercentage)
	end
end


function GrabSeatProgressTimerEx:onExit()
	self:unscheduleUpdate()
end



function GrabSeatProgressTimerEx:dispose()
	self:unscheduleUpdate()
end


function GrabSeatProgressTimerEx:setColor()
	if self.progressTimer_ then
		local per = self.progressTimer_:getPercentage()
		if per > 50 then
			self.progressTimer_:setColor(cc.c3b(0x00, 0xff, 0x00))

		elseif per<= 50 and per >25 then
			self.progressTimer_:setColor(cc.c3b(0xff, 0xff, 0x00))
		else
			self.progressTimer_:setColor(cc.c3b(0xff, 0x00, 0x00))
		end
	end
end



return GrabSeatProgressTimerEx



