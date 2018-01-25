--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-04-21 11:50:00
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: RegisterAwardControler.lua Reconstructed By Tsing7x.
--

local CommonRewardChipAnimation = import("app.login.CommonRewardChipAnimation")

local NewerPlayRewardPopup = import(".NewerPlayRewardPopup")

local instance = nil
local reqRetryTimes = 0

local RegisterAwardControler = class("RegisterAwardControler")

function RegisterAwardControler:ctor()
	self.schedulerPool_ = bm.SchedulerPool.new()

	self:addEvents()
	self:bindDataObserver()
end

function RegisterAwardControler:init(newerDay)

	self.newerDay_ = newerDay
	self:requestInit()
end

function RegisterAwardControler:requestInit()
	if self.isInit_ then
		return 
	end

	reqRetryTimes = 6
    local initFunc = nil
    initFunc = function()
		if self.initRequestId_ then
			-- return
			nk.http.cancel(self.initRequestId_)
			self.initRequestId_ = nil
		end

        self.initRequestId_ = nk.http.newerInit(function(retData)
            self.initRequestId_ = nil
            self.isInit_ = true

			self.remainTime_ = retData.diifToNext
			self.isNextRewardDone_ = retData.isNextDayTaskDone == 1

			if not retData.diifToNext or retData.diifToNext >= 999 then
				self.isPlayTaskFinish_ = true
			end

			bm.DataProxy:setData(nk.dataKeys.NEWER_GUIDE_DAY, self.newerDay_)
        end, function(errData)
            self.initRequestId_ = nil

            reqRetryTimes = reqRetryTimes - 1
            if reqRetryTimes > 0 then

                self.schedulerPool_:delayCall(function()
                    initFunc()
                end, 2)
            end
        end)
    end

    initFunc()
end

function RegisterAwardControler:requestPlayReward()

	reqRetryTimes = 6
    local playRewardFunc = nil
    playRewardFunc = function()
		if self.playRequestId_ then
			nk.http.cancel(self.playRequestId_)
			self.playRequestId_ = nil
		end

        self.playRequestId_ = nk.http.newerPlay(function(retData)
            self.playRequestId_ = nil
         	local addMoney = checkint(retData.addMoney)
         	local money = checkint(retData.money)

			self.remainTime_ = retData.diifToNext
			if not retData.diifToNext or retData.diifToNext >= 999 then
				self.isPlayTaskFinish_ = true
			end

			self:hideNewerTaskFinishIcon()

			local pdata = {}
			pdata.addMoney = addMoney
			pdata.isAnim = true

			if self.isPlayTaskFinish_ then
				pdata.contentFlag = 2
				pdata.nextAddMoney = 200000
			else
				pdata.contentFlag = 1
			end

			NewerPlayRewardPopup.new(pdata):showPanel()
        end, function(errData)
            self.playRequestId_ = nil
            reqRetryTimes = reqRetryTimes - 1

            if reqRetryTimes > 0 then
                self.schedulerPool_:delayCall(function()
                    playRewardFunc()
                end, 1)
            else
               self:hideNewerTaskFinishIcon()
            end
        end)
    end

    playRewardFunc()
end

function RegisterAwardControler:requestNextDayReward()
	reqRetryTimes = 6
    local nextDayFunc = nil

    nextDayFunc = function()
		if self.nextDayRequestId_ then
			nk.http.cancel(self.nextDayRequestId_)
			self.nextDayRequestId_ = nil
		end

        self.nextDayRequestId_ = nk.http.newerNextDayReward(function(retData)

	        self.nextDayRequestId_ = nil
			local addMoney = checkint(retData.addMoney)
			local money = checkint(retData.money)
			self.isNextRewardDone_ = true

			bm.DataProxy:setData(nk.dataKeys.NEWER_GUIDE_DAY, self.newerDay_)

			if addMoney > 0 then

				-- local runningScene = nk.runningScene

		        -- self.animNode_ = display.newNode()
			       --  :addTo(runningScene,100)
			       --  :pos(display.cx, display.cy)

	         --    local animation = CommonRewardChipAnimation.new()
	         --        :addTo(self.animNode_)

	         --    local changeChipAnim = nk.ui.ChangeChipAnim.new(checkint(addMoney))
	         --        :addTo(self.animNode_)  
	                
	            self.schedulerPool_:delayCall(function ()
		            nk.userData["aUser.money"] = nk.userData["aUser.money"] + addMoney

		            self:destoryAnim()
		            nk.TopTipManager:showTopTip(bm.LangUtil.getText("NEWER", "GET_REWARD_SUCC"))
	            end, 1.5)    
			end

		end, function(errData)
            self.nextDayRequestId_ = nil
            reqRetryTimes = reqRetryTimes - 1

            if reqRetryTimes > 0 then
                self.schedulerPool_:delayCall(function()
                    nextDayFunc()
                end, 1)
            end
        end)
    end

    nextDayFunc()
end

function RegisterAwardControler:sitStatusFunc(sitData)

	if 1 ~= self:getNewerDay() then
		return
	end

	if self.isPlayTaskFinish_ then
		return
	end 

	if "MatchRoomScene" == nk.runningScene.name or "RoomScene" == nk.runningScene.name then
		return
	end

	if not sitData then 
		return
	end

	local isSit = sitData.inSeat

    if isSit then
        self:sitDownFunc(sitData) 
    else 
        self:standUpFunc(sitData)
    end
end

function RegisterAwardControler:sitDownFunc(sitData)
	-- local isSit = sitData.inSeat
	-- local seatId = sitData.seatId
	-- local ctx = sitData.ctx

	if self:checkShowNewerTaskFinishIcon() then
		self:showNewerTaskFinishIcon(sitData)
	end
end

function RegisterAwardControler:standUpFunc(sitData)
	-- local isSit = sitData.inSeat
	-- local seatId = sitData.seatId
	-- local ctx = sitData.ctx

	self:hideNewerTaskFinishIcon()
end

function RegisterAwardControler:checkShowNewerTaskFinishIcon()
	if not self.isPlayTaskFinish_ and (self.remainTime_ and self.remainTime_ <= 0) then
		return true
	end

	return false
end

function RegisterAwardControler:showNewerTaskFinishIcon(sitData)
	if self.taskBtnNode_ then
		return
	end

	if not sitData then
		self:hideNewerTaskFinishIcon()
		return
	end

	-- local isSit = sitData.inSeat
	-- local seatId = sitData.seatId
	-- local ctx = sitData.ctx

	local seatView = ctx.seatManager:getSelfSeatView() 
	-- local seatViewSize = seatView:getContentSize()

	local taskBtnNodePosXSeat, taskBtnNodePosYSeat = - 100, 55
	local parent = seatView

	self.taskBtnNode_ = display.newNode()
		:pos(taskBtnNodePosXSeat, taskBtnNodePosYSeat)
		:addTo(parent, 100)

	display.newSprite("newerguide/newer_play_light.png")
		:addTo(self.taskBtnNode_)

	display.newSprite("newerguide/newer_play_start.png")
		:addTo(self.taskBtnNode_)

	 cc.ui.UIPushButton.new({normal = "newerguide/newer_play_up.png", pressed = "newerguide/newer_play_down.png"})
        :addTo(self.taskBtnNode_)
        :onButtonClicked(buttontHandler(self, self.onNewerTaskIconClick))

    self.taskBtnNode_:setNodeEventEnabled(true)
    self.taskBtnNode_.onCleanup = function()
    	self.taskBtnNode_ = nil
    end
end

function RegisterAwardControler:onNewerTaskIconClick()
	if 1 ~= self:getNewerDay() then
		return
	end

	if self.isPlayTaskFinish_ then
		return
	end

	self:requestPlayReward()
end

function RegisterAwardControler:hideNewerTaskFinishIcon()
	if self.taskBtnNode_ then
		self.taskBtnNode_:removeFromParent()
		self.taskBtnNode_ = nil
	end
end

function RegisterAwardControler:destoryAnim()
	if self.animNode_ then
		self.animNode_:removeFromParent()
		self.animNode_ = nil
	end
end

function RegisterAwardControler:getInstance()
    instance = instance or RegisterAwardControler.new()
    return instance
end

function RegisterAwardControler:setFirstRewardFlag(firstRewardFlag)
	self.firstRewardFlag_ = firstRewardFlag
end

function RegisterAwardControler:getFirstRewardFlag(firstRewardFlag)
	return self.firstRewardFlag_
end

function RegisterAwardControler:isRunning()
	return (checkint(self.newerDay_) > 0)
end

function RegisterAwardControler:getNewerDay()
	return (checkint(self.newerDay_))
end

function RegisterAwardControler:isNextRewardDone()
	return self.isNextRewardDone_
end

function RegisterAwardControler:onReportGameOver_(evt)
	if "MatchRoomScene" == nk.runningScene.name then
		return
	end

	local data = evt.data

	-- dump(data, "RegisterAwardControler:onReportGameOver_.evt.data :==================")

	if 1 ~= self:getNewerDay() then
		return
	end

	if self.isPlayTaskFinish_ then
		return
	end

	self.remainTime_ = self.remainTime_ - 1

	if self:checkShowNewerTaskFinishIcon() then
		
		self:showNewerTaskFinishIcon(data)
	end
end

function RegisterAwardControler:addEvents()
	if not self.gameOverHandler_ then
		self.gameOverHandler_ = bm.EventCenter:addEventListener(nk.DailyTasksEventHandler.REPORT_GAME_OVER, handler(self, self.onReportGameOver_))
	end
end

function RegisterAwardControler:bindDataObserver()
	if not self.onDataObserver_ then
		self.onDataObserver_ = bm.DataProxy:addDataObserver(nk.dataKeys.SIT_OR_STAND, handler(self, self.sitStatusFunc))
	end
end

function RegisterAwardControler:removeEvents()
	if self.gameOverHandler_ then
		bm.EventCenter:removeEventListener(self.gameOverHandler_)
		self.gameOverHandler_ = nil
	end
end

function RegisterAwardControler:unbindDataObserver()
	if self.onDataObserver_ then
		bm.DataProxy:removeDataObserver(nk.dataKeys.SIT_OR_STAND, self.onDataObserver_)
		self.onDataObserver_ = nil
	end
end

function RegisterAwardControler:dispose(clean)
	if self.schedulerPool_ then
		self.schedulerPool_:clearAll()
	end
	
	if self.initRequestId_ then
		nk.http.cancel(self.initRequestId_)
		self.initRequestId_ = nil
	end

	if self.playRequestId_ then
		nk.http.cancel(self.playRequestId_)
		self.playRequestId_ = nil
	end

	self:hideNewerTaskFinishIcon()

	self.isInit_ = nil
	self.newerDay_ = 0
	self.isPlayTaskFinish_ = nil
	self.isNextRewardDone_ = nil
	self.firstRewardFlag_ = nil
	self.remainTime_ = 999

	bm.DataProxy:setData(nk.dataKeys.NEWER_GUIDE_DAY, 0)

	self:destoryAnim()

	if clean then
		self:removeEvents()
		self:unbindDataObserver()
	end
end

return RegisterAwardControler