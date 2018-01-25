--
-- Author: TsingZhang@boyaa.com
-- Date: 2016-05-27 17:29:54
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: DokbActListTermItem.lua By TsingZhang.
--

local AttendActPopup = import(".views.DokbAttendActPopup")

local DokbActListTermItem = class("DokbActListTermItem", function()
	-- body
	return display.newNode()
end)

function DokbActListTermItem:ctor()
	-- body
	self:setNodeEventEnabled(true)

	self.termBg_ = display.newSprite("#dokb_bgActTermMain.png")
		:addTo(self)

	-- self.termBg_:setTouchEnabled(true)
	-- self.termBg_:setTouchSwallowEnabled(true)
	
	local termBgSize = self.termBg_:getContentSize()

	-- Init Default Label Param --
	local labelParam = {
		fontSize = 0,
		color = display.COLOR_WHITE
	}

	local stateFlagMagrinTop = 14
	self.termStateFlag_ = display.newSprite("#dokb_decActTermFlagGrey.png")
	self.termStateFlag_:pos(self.termStateFlag_:getContentSize().width / 2, termBgSize.height - stateFlagMagrinTop -
		self.termStateFlag_:getContentSize().height / 2)
		:addTo(self.termBg_)

	labelParam.fontSize = 19
	labelParam.color = display.COLOR_WHITE

	local waitTimeLblPosYOffSet = 8
	self.stateWaitTimeCount_ = display.newTTFLabel({text = "00:00", size = labelParam.fontSize, color = labelParam.color, align =
		ui.TEXT_ALIGN_CENTER})
		:pos(self.termStateFlag_:getContentSize().width / 2, self.termStateFlag_:getContentSize().height / 2 + waitTimeLblPosYOffSet)
		:addTo(self.termStateFlag_)
		:hide()

	local gemImgPaddingTop = 110

	-- local gemImgShownWidth = 142
	self.termGemFrame_ = display.newSprite()
		:pos(termBgSize.width / 2, termBgSize.height - gemImgPaddingTop)
		:addTo(self.termBg_)

	self.termGemFrameLoaderId_ = nk.ImageLoader:nextLoaderId()

	labelParam.fontSize = 26
	labelParam.color = display.COLOR_RED

	local termInfoNameCentOffSet = 25
	local gemNameLblMagrinIcon = 4

	self.termInfoIcName = display.newSprite("#dokb_icActTermGem.png")
	self.gemName_ = display.newTTFLabel({text = "Gem Name.", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})

	local termIconWidth = self.termInfoIcName:getContentSize().width
	local termNameLblWidth = self.gemName_:getContentSize().width

	local termInfoNameWidth = termIconWidth + termNameLblWidth + gemNameLblMagrinIcon

	self.termInfoIcName:pos(termBgSize.width / 2 - (termInfoNameWidth / 2 - termIconWidth / 2), termBgSize.height / 2 - termInfoNameCentOffSet)
		:addTo(self.termBg_)

	self.gemName_:pos(termBgSize.width / 2 + (termInfoNameWidth / 2 - termNameLblWidth / 2), termBgSize.height / 2 - termInfoNameCentOffSet)
		:addTo(self.termBg_)
	
	-- local termInfoMainMagrinLeft = 30

	local involInfoProBarParam = {
		bgWidth = 160,
        bgHeight = 7,
        fillWidth = 6,
        fillHeight = 5
	}

	local involProBarMagrinTop = 6
	self.involInfoProgress_ = nk.ui.ProgressBar.new("#dokb_prgLayer_infoInvol.png", "#dokb_prgFiller_infoInvol.png", involInfoProBarParam)
		:pos(termBgSize.width / 2 - involInfoProBarParam.bgWidth / 2, self.termInfoIcName:getPositionY() - self.termInfoIcName:getContentSize().height / 2 -
			involProBarMagrinTop - involInfoProBarParam.bgHeight)
		:addTo(self.termBg_)

	labelParam.fontSize = 16
	labelParam.color = display.COLOR_WHITE

	self.lotryNdPeopInfo_ = display.newTTFLabel({text = "0/0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
		:pos(termBgSize.width / 2, self.involInfoProgress_:getPositionY())
		:addTo(self.termBg_)

	labelParam.fontSize = 18
	labelParam.color = display.COLOR_WHITE

	local involInfoLabelMagrinTop = 10
	self.termInvolInfo_ = display.newTTFLabel({text = "Term Invol Info", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
	self.termInvolInfo_:pos(termBgSize.width / 2, self.involInfoProgress_:getPositionY() - involInfoLabelMagrinTop - self.termInvolInfo_:getContentSize().height / 2)
		:addTo(self.termBg_)

	labelParam.fontSize = 20
	labelParam.color = display.COLOR_WHITE

	local termAttPriceLblMagrinTop = 4
	self.termAttPrice_ = display.newTTFLabel({text = "Attend Curreny Tip.", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
	self.termAttPrice_:pos(termBgSize.width / 2, self.termInvolInfo_:getPositionY() - self.termInvolInfo_:getContentSize().height / 2 - termAttPriceLblMagrinTop -
		self.termAttPrice_:getContentSize().height / 2)
		:addTo(self.termBg_)

	local attendBtnSize = {
		width = 184,
		height = 54
	}

	labelParam.fontSize = 30
	labelParam.color = display.COLOR_WHITE

	local attendActBtnMagrinBot = 16

	self.attendActBtn_ = cc.ui.UIPushButton.new({normal = "#dokb_btnAttendAct.png", pressed = "#dokb_btnAttendAct.png", disabled =
		"#common_btnGreyLitRigOut.png"}, {scale9 = true})
		:setButtonSize(attendBtnSize.width, attendBtnSize.height)
		:setButtonLabel(display.newTTFLabel({text = "参与众筹", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
		:onButtonClicked(buttontHandler(self, self.onAttendActBtnCallBack_))
		:pos(termBgSize.width / 2, attendBtnSize.height / 2 + attendActBtnMagrinBot)
		:addTo(self.termBg_)

	self.attendActBtn_:setButtonEnabled(false)
	self.isAttendBtnEnable = true
end

function DokbActListTermItem:refreshTermItemUiData(data)
	-- body
	self.termData_ = data

	self.termItemId_ = data.id
	self.termId_ = data.termId_

	self.itemStatus_ = data.code or - 2

	-- Just For Test --
	-- self.itemStatus_ = - 1
	-- data.stime = 2607
	-- end --

	local stateFlagPath = {
		[- 2] = "dokb_decActTermFlagGrey.png",  -- Finished
		[- 1] = "dokb_decActTermFlagPurple.png",  -- Waiting For Next Round
		[1] = "dokb_decActTermFlagGreen.png"  -- Granting
	}

	nk.ImageLoader:loadAndCacheImage(self.termGemFrameLoaderId_, data.propsurl or "", handler(self, self.onGemFrameImgLoadComplete_))

	self.termStateFlag_:setSpriteFrame(display.newSpriteFrame(stateFlagPath[self.itemStatus_]))

	if self.tickDownShortAction_ then
		--todo
		self:stopAction(self.tickDownShortAction_)
		self.tickDownShortAction_ = nil
	end

	if self.tickDownLongAction_ then
		--todo
		self:stopAction(self.tickDownLongAction_)
		self.tickDownLongAction_ = nil
	end

	if self.itemStatus_ == 1 then
		--todo
		self.attendActBtn_:setButtonEnabled(true)
	else
		self.attendActBtn_:setButtonEnabled(false)
	end

	if self.itemStatus_ == - 1 then
		--todo
		-- State Waiting --
		self.timeCountDown = data.stime or 0

		self.stateWaitTimeCount_:show()
		self:startTimeTickDown()
	else
		self.stateWaitTimeCount_:hide()
	end

	self.gemName_:setString(data.props or "Gem Name.")

	local gemNameLblMagrinIcon = 4

	local termIconWidth = self.termInfoIcName:getContentSize().width
	local termNameLblWidth = self.gemName_:getContentSize().width

	local termInfoNameWidth = termIconWidth + termNameLblWidth + gemNameLblMagrinIcon

	self.termInfoIcName:setPositionX(self.termBg_:getContentSize().width / 2 - (termInfoNameWidth / 2 - termIconWidth / 2))
	self.gemName_:setPositionX(self.termBg_:getContentSize().width / 2 + (termInfoNameWidth / 2 - termNameLblWidth / 2))

	-- Record Joined Peop && Needed Peop To Grant --
	self.peopJoinedTimes_ = tonumber(data.nowcount or 0)
	self.lotryNdPeopTotalTimes_ = tonumber(data.total or 0)

	if self.itemStatus_ == - 2 then
		--todo
		self.lotryNdPeopInfo_:setString("0/0")
		self.involInfoProgress_:setValue(0)

		-- self.termInvolInfo_:setString("满0人次开奖(每日0/0次)")
	else
		self.lotryNdPeopInfo_:setString(tostring(self.peopJoinedTimes_) .. "/" .. self.lotryNdPeopTotalTimes_)
		self.involInfoProgress_:setValue(self.peopJoinedTimes_ / tonumber(data.total or 1))
	end

	self.termInvolInfo_:setString("满" .. self.lotryNdPeopTotalTimes_ .. "人次开奖(每日" .. (data.count or 0) .. "/" .. 
		(data.daycount or 0) .. "次)")

	if data.price then
		--todo
		-- local attendPrice = json.decode(data.price)
		self.termAttPrice_:setString(bm.LangUtil.getText("DOKB", "ATTENED_CURRENCY", bm.formatBigNumber(data.price.point or 0), bm.formatBigNumber(data.price.money or 0)))
	else
		self.termAttPrice_:setString(bm.LangUtil.getText("DOKB", "ATTENED_CURRENCY", 0, 0))
	end
end

function DokbActListTermItem:onGemFrameImgLoadComplete_(success, sprite)
	-- body
	if success then
		--todo
		local tex = sprite:getTexture()
		local texSize = tex:getContentSize()

		local gemFrameShownSize = {
			width = 138,
			height = 92
		}

		if self and self.termGemFrame_ then
			--todo
			self.termGemFrame_:setTexture(tex)
			self.termGemFrame_:setTextureRect(cc.rect(0, 0, texSize.width, texSize.height))

			-- self.termGemFrame_:setScaleX(gemFrameShownSize.width / texSize.width)
			-- self.termGemFrame_:setScaleY(gemFrameShownSize.height / texSize.height)
			self.termGemFrame_:scale(gemFrameShownSize.width / texSize.width)
		end
	end
end

function DokbActListTermItem:onAttendActBtnCallBack_(evt)
	-- body
	if self.isAttendBtnEnable then
		--todo
		self.isAttendBtnEnable = false
		-- self.attendActBtn_:setButtonEnabled(false)

		AttendActPopup.new(self.termData_):showPanel(function()
			-- body
			self.isAttendBtnEnable = true
			-- self.attendActBtn_:setButtonEnabled(true)
		end, function()
			-- body
			self.peopJoinedTimes_ = self.peopJoinedTimes_ + 1

			if self.peopJoinedTimes_ >= self.lotryNdPeopTotalTimes_ then
				--todo
				bm.EventCenter:dispatchEvent(nk.eventNames.DOKB_LOTRY_LOAD_NEXTROUND_RERESHDATA)
			else
				self.termData_.nowcount = self.peopJoinedTimes_

				self.lotryNdPeopInfo_:setString(tostring(self.peopJoinedTimes_) .. "/" .. self.lotryNdPeopTotalTimes_)
				self.involInfoProgress_:setValue(self.peopJoinedTimes_ / tonumber(self.termData_.total or 1))
			end
		end)
	end
end

function DokbActListTermItem:startTimeTickDown()
	-- body
	if self.timeCountDown < 3600 then
		--todo
		local time_str = bm.formatTimeStamp(1, self.timeCountDown)
		local minShown = nil
		local secShown = nil

		if time_str.min < 10 then
			--todo
			minShown = "0" .. time_str.min
		else
			minShown = tostring(time_str.min)
		end

		if time_str.sec < 10 then
			--todo
			secShown = "0" .. time_str.sec
		else
			secShown = tostring(time_str.sec)
		end
		-- Show Waiting Timing --
		self.stateWaitTimeCount_:setString(minShown .. ":" .. secShown)

		self.tickDownShortAction_ = self:schedule(function()
			-- body
			self.timeCountDown = self.timeCountDown - 1

			local time_str = bm.formatTimeStamp(1, self.timeCountDown)
			local minShown = nil
			local secShown = nil

			if time_str.min < 10 then
				--todo
				minShown = "0" .. time_str.min
			else
				minShown = tostring(time_str.min)
			end

			if time_str.sec < 10 then
				--todo
				secShown = "0" .. time_str.sec
			else
				secShown = tostring(time_str.sec)
			end

			self.stateWaitTimeCount_:setString(minShown .. ":" .. secShown)

			if self.timeCountDown <= 0 then
				--todo
				self:stopAction(self.tickDownShortAction_)
				self.tickDownShortAction_ = nil

				bm.EventCenter:dispatchEvent(nk.eventNames.DOKB_LOTRY_LOAD_NEXTROUND_RERESHDATA)
			end
		end, 1)
	else
		local timeTabel = bm.formatTimeStamp(2, self.timeCountDown)

		local remainTimeShownStr = nil
		local hourShown = nil
		local minShown = nil
		local secShown = nil

		if timeTabel.hour < 10 then
			--todo
			hourShown = "0" .. timeTabel.hour
		else
			hourShown = tostring(timeTabel.hour)
		end

		if timeTabel.min < 10 then
			--todo
			minShown = "0" .. timeTabel.min
		else
			minShown = tostring(timeTabel.min)
		end

		if timeTabel.sec < 10 then
			--todo
			secShown = "0" .. timeTabel.sec
		else
			secShown = tostring(timeTabel.sec)
		end

		self.stateWaitTimeCount_:setString(hourShown .. ":" .. minShown .. ":" .. secShown)

		self.tickDownLongAction_ = self:schedule(function()
			-- body
			self.timeCountDown = self.timeCountDown - 1

			if self.timeCountDown < 3600 then
				--todo
				self:stopAction(self.tickDownLongAction_)
				self.tickDownLongAction_ = nil

				local time_str = bm.formatTimeStamp(1, self.timeCountDown)
				local minShown = nil
				local secShown = nil

				if time_str.min < 10 then
					--todo
					minShown = "0" .. time_str.min
				else
					minShown = tostring(time_str.min)
				end

				if time_str.sec < 10 then
					--todo
					secShown = "0" .. time_str.sec
				else
					secShown = tostring(time_str.sec)
				end

				self.stateWaitTimeCount_:setString(minShown .. ":" .. secShown)

				self.tickDownShortAction_ = self:schedule(function()
					-- body
					self.timeCountDown = self.timeCountDown - 1

					local time_str = bm.formatTimeStamp(1, self.timeCountDown)
					local minShown = nil
					local secShown = nil

					if time_str.min < 10 then
						--todo
						minShown = "0" .. time_str.min
					else
						minShown = tostring(time_str.min)
					end

					if time_str.sec < 10 then
						--todo
						secShown = "0" .. time_str.sec
					else
						secShown = tostring(time_str.sec)
					end

					self.stateWaitTimeCount_:setString(minShown .. ":" .. secShown)

					if self.timeCountDown <= 0 then
						--todo
						self:stopAction(self.tickDownShortAction_)
						self.tickDownShortAction_ = nil

						bm.EventCenter:dispatchEvent(nk.eventNames.DOKB_LOTRY_LOAD_NEXTROUND_RERESHDATA)
					end
				end, 1)
			else

				local timeTabel = bm.formatTimeStamp(2, self.timeCountDown)

				local remainTimeShownStr = nil
				local hourShown = nil
				local minShown = nil
				local secShown = nil

				if timeTabel.hour < 10 then
					--todo
					hourShown = "0" .. timeTabel.hour
				else
					hourShown = tostring(timeTabel.hour)
				end

				if timeTabel.min < 10 then
					--todo
					minShown = "0" .. timeTabel.min
				else
					minShown = tostring(timeTabel.min)
				end

				if timeTabel.sec < 10 then
					--todo
					secShown = "0" .. timeTabel.sec
				else
					secShown = tostring(timeTabel.sec)
				end

				self.stateWaitTimeCount_:setString(hourShown .. ":" .. minShown .. ":" .. secShown)
			end
		end, 1)
	end
end

function DokbActListTermItem:onEnter()
	-- body
end

function DokbActListTermItem:onExit()
	-- body
	if self.termGemFrameLoaderId_ then
		--todo
		nk.ImageLoader:cancelJobByLoaderId(self.termGemFrameLoaderId_)
	end
	
	if self.tickDownShortAction_ then
		--todo
		self:stopAction(self.tickDownShortAction_)
		self.tickDownShortAction_ = nil
	end

	if self.tickDownLongAction_ then
		--todo
		self:stopAction(self.tickDownLongAction_)
		self.tickDownShortAction_ = nil
	end
end

function DokbActListTermItem:onCleanup()
	-- body
end

return DokbActListTermItem