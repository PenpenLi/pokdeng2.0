--
-- Author: TsingZhang@boyaa.com
-- Date: 2016-05-30 17:25:13
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: DokbMyRecListItem.lua Create && Reconstructed By Tsing7x.
--

local UserAddrComfirmPopup = import(".views.UserAddrComfirmPopup")

local ITEMSIZE = nil

local DokbMyRecListItem = class("DokbMyRecListItem", bm.ui.ListItem)

function DokbMyRecListItem:ctor()
	-- body
	self:setNodeEventEnabled(true)
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

	local dokbPageLeftOprPanelModel = display.newSprite("#hall_auxBgPanel_left.png")
	local dokbPageLeftOprPanelCalSize = dokbPageLeftOprPanelModel:getContentSize()

	local ownerMarinHoriz = 12
	local itemHeight = 70
	ITEMSIZE = cc.size(display.width - dokbPageLeftOprPanelCalSize.width - ownerMarinHoriz * 2,
		itemHeight)

	self.super.ctor(self, ITEMSIZE.width, ITEMSIZE.height)

	local itemBgSizeHFix = 1
	self.itemBg_ = display.newScale9Sprite("#common_modTransparent.png", ITEMSIZE.width / 2, ITEMSIZE.height / 2, cc.size(ITEMSIZE.width,
		ITEMSIZE.height - itemBgSizeHFix * 2))
		:addTo(self)

	local itemBgSizeH = self.itemBg_:getContentSize().height

	local itemInfoContSetcilMagrinHoriz = 80

	local itemInfoMagrinGap = (ITEMSIZE.width - itemInfoContSetcilMagrinHoriz * 2) / 4
	-- Init Default Label Param --
	local labelParam = {
		fontSize = 0,
		color = display.COLOR_WHITE
	}

	labelParam.fontSize = 18
	labelParam.color = display.COLOR_WHITE

	self.termId_ = display.newTTFLabel({text = "Term Id :0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
		:pos(ITEMSIZE.width / 2 - itemInfoMagrinGap * 2, itemBgSizeH / 2)
		:addTo(self.itemBg_)

	self.gemName_ = display.newTTFLabel({text = "Gem Name", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
		:pos(ITEMSIZE.width / 2 - itemInfoMagrinGap, itemBgSizeH / 2)
		:addTo(self.itemBg_)

	self.lotryCode_ = display.newTTFLabel({text = "Lotry Code", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
		:pos(ITEMSIZE.width / 2, itemBgSizeH / 2)
		:addTo(self.itemBg_)

	labelParam.fontSize = 20
	labelParam.color = display.COLOR_WHITE

	self.exprTime_ = display.newTTFLabel({text = "1970-01-00", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
		:pos(ITEMSIZE.width / 2 + itemInfoMagrinGap, itemBgSizeH / 2)
		:addTo(self.itemBg_)

	local getPrizeBtnSize = {
		width = 130,
		height = 45
	}

	labelParam.fontSize = 18
	labelParam.color = display.COLOR_WHITE

	-- Reuse AttendActBtn Dis --
	self.getPrizBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnGreenRigOutl.png", pressed = "#common_btnGreenRigOutl.png", disabled = 
		"#common_btnGreyLitRigOut.png"}, {scale9 = true})
		:setButtonSize(getPrizeBtnSize.width, getPrizeBtnSize.height)
		:setButtonLabel(display.newTTFLabel({text = "领取奖励", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
		:onButtonClicked(buttontHandler(self, self.onGetPrizBtnCallBack_))
		:pos(ITEMSIZE.width / 2 + itemInfoMagrinGap * 2, itemBgSizeH / 2)
		:addTo(self.itemBg_)

	self.getPrizBtn_:setButtonEnabled(false)
	self.isgetPrizBtnEnable = true
end

function DokbMyRecListItem:onDataSet(isChanged, data)
	-- body
	if isChanged then
		--todo
		if self.index_ % 2 == 0 then
			--todo
			local itemBgSizeHFix = 1

			self.itemBg_:setSpriteFrame(display.newSpriteFrame("dokb_bgRecInfoDent.png"))
			self.itemBg_:setContentSize(ITEMSIZE.width, ITEMSIZE.height - itemBgSizeHFix * 2)
		end

		self.gemId_ = data.id
		-- self.termNum_ = data.time
		-- self.myLotryCode_ = data.treasurecode
		self.gemType_ = data.type or 1 -- 1:Exchange Card; 2:Real Property
		self.awardId_ = data.rewardId

		self.prizStatus_ = data.status or 3  -- 1:UnGet Priz; 2:Getted Priz; 3:Has Expried

		self.termId_:setString(bm.LangUtil.getText("DOKB", "MYREC_TERM_NUM", data.time or "00001"))
		self.gemName_:setString(data.props or "Gem Name.")
		self.lotryCode_:setString(data.treasurecode or "Lotry Code.")
		self.exprTime_:setString(data.effectivetime or "1970-01-01")

		self:refrshGetPrizBtnUi(self.prizStatus_)
	end
end

function DokbMyRecListItem:refrshGetPrizBtnUi(status)
	-- body
	local refreshBtnByStatus = {

		-- Reuse AttendActBtn Dis --
		[1] = function()
			-- body
			self.getPrizBtn_:setButtonImage("normal", "#common_btnGreenRigOutl.png")
			self.getPrizBtn_:setButtonImage("pressed", "#common_btnGreenRigOutl.png")
			self.getPrizBtn_:setButtonImage("disabled", "#common_btnGreyLitRigOut.png")

			self.getPrizBtn_:setButtonEnabled(true)

			self.getPrizBtn_:getButtonLabel():setString(bm.LangUtil.getText("DOKB", "MYREC_GET_REWARD"))
		end,

		[2] = function()
			-- body
			self.getPrizBtn_:setButtonImage("normal", "#common_btnYellowRigOutl.png")
			self.getPrizBtn_:setButtonImage("pressed", "#common_btnYellowRigOutl.png")
			self.getPrizBtn_:setButtonImage("disabled", "#common_btnGreyLitRigOut.png")

			self.getPrizBtn_:setButtonEnabled(true)

			self.getPrizBtn_:getButtonLabel():setString(bm.LangUtil.getText("DOKB", "MYREC_GETTED"))
		end,

		[3] = function()
			-- body
			self.getPrizBtn_:setButtonImage("normal", "#common_btnGreenRigOutl.png")
			self.getPrizBtn_:setButtonImage("pressed", "#common_btnGreenRigOutl.png")
			self.getPrizBtn_:setButtonImage("disabled", "#common_btnGreyLitRigOut.png")

			self.getPrizBtn_:setButtonEnabled(false)
			self.getPrizBtn_:getButtonLabel():setString(bm.LangUtil.getText("DOKB", "MYREC_EXPIRED"))
		end
	}

	refreshBtnByStatus[status]()
end

function DokbMyRecListItem:onGetPrizBtnCallBack_(evt)
	-- body
	if self.isgetPrizBtnEnable then
		--todo
		self.isgetPrizBtnEnable = false
		-- self:reqGetMyRewardPriz()

		if self.prizStatus_ == 1 then
			--todo
			if self.gemType_ == 1 then
				--todo
				self:reqGetMyRewardPriz()
			elseif self.gemType_ == 2 then
				--todo
				UserAddrComfirmPopup.new():showPanel(handler(self, self.reqGetMyRewardPriz))
			end
		else
			self:dispatchEvent({name="ITEM_EVENT", data = self.data_})
			self.isgetPrizBtnEnable = true
		end
	end
end

function DokbMyRecListItem:reqGetMyRewardPriz()
	-- body

	self.reqGetMyRewardId_ = nk.http.getDokbMyReward(self.awardId_, function(retData)
		-- body
		-- dump(retData, "getDokbMyReward.data :==================")

		if self.gemType_ == 1 then
			--todo
			nk.ui.Dialog.new({titleText = bm.LangUtil.getText("DOKB", "MYREC_SUCC_GET_REWARD"), messageText = "PIN: " .. (retData.password or "ABC1234567"),
				secondBtnText = bm.LangUtil.getText("SCOREMARKET", "COPY"), callback = function (type)
		            if type == nk.ui.Dialog.SECOND_BTN_CLICK then
		            	nk.Native:setClipboardText(retData.password)
				        nk.TopTipManager:showTopTip(bm.LangUtil.getText("SCOREMARKET", "COPY_SUCCESS"))
		            end
		        end}):show()

		elseif self.gemType_ == 2 then
			--todo
			-- UserAddrComfirmPopup.new():showPanel()
			nk.TopTipManager:showTopTip(bm.LangUtil.getText("DOKB", "MYREC_GETTED_REWARD"))
		end

		self.prizStatus_ = 2

		self.isgetPrizBtnEnable = true

		if self and self.refrshGetPrizBtnUi then
			--todo
			self:refrshGetPrizBtnUi(self.prizStatus_)
		end

	end, function(errData)
		-- body
		self.reqGetMyRewardId_ = nil
		-- dump(errData, "getDokbMyReward.errData :====================")

		if errData.errorCode == - 2 then
			--todo
			nk.TopTipManager:showTopTip(bm.LangUtil.getText("DOKB", "MYREC_FAILD_EXPIRED"))

			self.prizStatus_ = 3

			if self and self.refrshGetPrizBtnUi then
				--todo
				self:refrshGetPrizBtnUi(self.prizStatus_)
			end

		else
			nk.TopTipManager:showTopTip(bm.LangUtil.getText("DOKB", "MYREC_FAILD_BAD_NETWORK"))
		end

		self.isgetPrizBtnEnable = true
	end)
end

function DokbMyRecListItem:onEnter()
	-- body
end

function DokbMyRecListItem:onExit()
	-- body
	if self.reqGetMyRewardId_ then
		--todo
		nk.http.cancel(self.reqGetMyRewardId_)
	end
end

function DokbMyRecListItem:onCleanup()
	-- body
end

return DokbMyRecListItem