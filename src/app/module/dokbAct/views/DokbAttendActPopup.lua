--
-- Author: TsingZhang@boyaa.com
-- Date: 2016-05-30 20:45:42
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: DokbAttendActPopup.lua Create && Reconstruct By TsingZhang.
--

local ResultAttendPopup = import(".DokbAttendActResultPopup")

local PANEL_WIDTH = 520
local PANEL_HEIGHT = 360

local DokbAttendActPopup = class("DokbAttendActPopup", nk.ui.Panel)

function DokbAttendActPopup:ctor(gemData)
	-- body
	self:setNodeEventEnabled(true)

	self.super.ctor(self, {PANEL_WIDTH, PANEL_HEIGHT})

	self.gemId_ = gemData.id

	local decShinyMagrinTop = 8

	local gemShinyDec = display.newSprite("#dokb_decGemShiny.png")
	gemShinyDec:pos(0, PANEL_HEIGHT / 2 - gemShinyDec:getContentSize().height / 2 - decShinyMagrinTop)
		:addTo(self)

	local gemImgCntMagrinTop = 82
	self.gemImg_ = display.newSprite()
		:pos(0, PANEL_HEIGHT / 2 - gemImgCntMagrinTop)
		:addTo(self)

	self.gemImgLoaderId_ = nk.ImageLoader:nextLoaderId()
	nk.ImageLoader:loadAndCacheImage(self.gemImgLoaderId_, gemData.propsurl or "", handler(self, self.onGemImgLoadComplete_))

	local labelParam = {
		fontSize = 0,
		color = display.COLOR_WHITE
	}


	labelParam.fontSize = 24
	labelParam.color = display.COLOR_WHITE
	
	local gemNameMagrinImg = 55
	self.gemName_ = display.newTTFLabel({text = gemData.props or "Gem Name.", size = labelParam.fontSize, color = labelParam.color, align =
		ui.TEXT_ALIGN_CENTER})
	self.gemName_:pos(0, PANEL_HEIGHT / 2 - gemImgCntMagrinTop - gemNameMagrinImg - self.gemName_:getContentSize().height / 2)
		:addTo(self)

	local infoDivLineGapCnt = 12
	local infoDivLineShownHeight = 2

	local gemAtdInfoDivLine = display.newScale9Sprite("#dokb_decAtdActDivLine.png", 0, infoDivLineGapCnt,
		cc.size(PANEL_WIDTH, infoDivLineShownHeight))
		:addTo(self)

	local currencyTipStr = nil
	if gemData.price then
		--todo
		currencyTipStr = bm.LangUtil.getText("DOKB", "ATTENED_COST", bm.formatBigNumber(gemData.price.point or 0), bm.formatBigNumber(gemData.price.money or 0))
	else
		currencyTipStr = bm.LangUtil.getText("DOKB", "ATTENED_COST", 0, 0)
	end

	labelParam.fontSize = 20
	labelParam.color = display.COLOR_WHITE

	local costInfoLblMagrinTop = 5
	self.ensureAtdCostInfo_ = display.newTTFLabel({text = currencyTipStr, size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
	self.ensureAtdCostInfo_:pos(0, gemAtdInfoDivLine:getPositionY() - costInfoLblMagrinTop - self.ensureAtdCostInfo_:getContentSize().height / 2)
		:addTo(self)

	local peopRemainLblMagrinTop = 2
	self.peopRestInfo_ = display.newTTFLabel({text = bm.LangUtil.getText("DOKB", "ATTENDED_PEOPREST", (gemData.total or 0) - (gemData.nowcount or 0)), size = labelParam.fontSize,
		color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
	self.peopRestInfo_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
	self.peopRestInfo_:pos(- self.ensureAtdCostInfo_:getContentSize().width / 2, self.ensureAtdCostInfo_:getPositionY() - self.ensureAtdCostInfo_:getContentSize().height / 2 -
		peopRemainLblMagrinTop - self.peopRestInfo_:getContentSize().height / 2)
		:addTo(self)

	-- Dent Area Bottom --
	local dentBotStencil = {
		x = 5,
		y = 1,
		width = 113,
		height = 80
	}

	local dentBotAreaSizeH = 82
	local dentBotBorH = 5
	local dentBotBlock = display.newScale9Sprite("#common_bgDentPanelBot.png", 0, - PANEL_HEIGHT / 2 + dentBotAreaSizeH / 2 + dentBotBorH, cc.size(PANEL_WIDTH, dentBotAreaSizeH),
		cc.rect(dentBotStencil.x, dentBotStencil.y, dentBotStencil.width, dentBotStencil.height))
		:addTo(self)

	local atdActBtnSize = {
		width = 142,
		height = 50
	}

	labelParam.fontSize = 22
	labelParam.color = display.COLOR_WHITE

	self.attendActBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnGreenRigOutl.png", pressed = "#common_btnGreenRigOutl.png", disabled = "#common_btnGreyLitRigOut.png"},
		{scale9 = true})
		:setButtonSize(atdActBtnSize.width, atdActBtnSize.height)
		:setButtonLabel(display.newTTFLabel({text = bm.LangUtil.getText("DOKB", "ATTENED_ENSURE"), size = labelParam.fontSize, color = labelParam.color, align =
			ui.TEXT_ALIGN_CENTER}))
		:onButtonClicked(buttontHandler(self, self.onAttendBtnCallBack_))
		:pos(PANEL_WIDTH / 2, dentBotAreaSizeH / 2)
		:addTo(dentBotBlock)

	self.attendActBtn_:setButtonEnabled(false)
	self.attendActBtnEnable = true

	local argTipsChkBtnMagrinBotArea = 10
	local argTermsChkLblOffSetX = 25

	local argTermsChkBtnSize = {
		width = 26,
		height = 26
	}

	labelParam.fontSize = 18
	labelParam.color = display.COLOR_WHITE

	self.argTermsChkBtn_ = cc.ui.UICheckBoxButton.new({off = "#dokb_ckbtnAgrTerms_unSel.png", on = "#dokb_ckbtnAgrTerms_sel.png"}, {scale9 = false})
		:setButtonLabel(display.newTTFLabel({text = bm.LangUtil.getText("DOKB", "ATTENDED_ARGTERM"), size = labelParam.fontSize, color = labelParam.color, align =
			ui.TEXT_ALIGN_CENTER}))
		:setButtonLabelOffset(argTermsChkLblOffSetX, 0)
		:onButtonStateChanged(buttontHandler(self, self.onArgTermsChkBtnCallBack_))
		:align(display.LEFT_CENTER)

	local argTermsLabel = self.argTermsChkBtn_:getButtonLabel()
	local argTermViewWidth = argTermsChkBtnSize.width + argTermsLabel:getContentSize().width + argTermsChkLblOffSetX

	self.argTermsChkBtn_:pos(- argTermViewWidth / 2, dentBotBlock:getPositionY() + dentBotAreaSizeH / 2 + argTipsChkBtnMagrinBotArea + argTermsChkBtnSize.height / 2)
		:addTo(self)

	self.argTermsChkBtn_:setButtonSelected(true)

	self:addCloseBtn()
end

function DokbAttendActPopup:onGemImgLoadComplete_(success, sprite)
	-- body
	if success then
		--todo
		local tex = sprite:getTexture()
		local texSize = tex:getContentSize()

		-- local gemFrameShownSize = {
		-- 	width = 160,
		-- 	height = 100
		-- }

		local gemFrameShownWidth = 142
		if self and self.gemImg_ then
			--todo
			self.gemImg_:setTexture(tex)
			self.gemImg_:setTextureRect(cc.rect(0, 0, texSize.width, texSize.height))

			-- self.gemImg_:setScaleX(gemFrameShownSize.width / texSize.width)
			-- self.gemImg_:setScaleY(gemFrameShownSize.height / texSize.height)

			self.gemImg_:scale(gemFrameShownWidth / texSize.width)
		end
	end
end

function DokbAttendActPopup:onAttendBtnCallBack_(evt)
	-- body
	if self.attendActBtnEnable then
		--todo
		self.attendActBtnEnable = false

		self.reqAttendActReqId_ = nk.http.attendActDokb(self.gemId_, function(retData)
			-- body
			-- dump(retData, "attendActDokb.data :=================")

			if self.attendActCallBack_ then
				--todo
				self.attendActCallBack_()
			end

			nk.userData["aUser.money"] = retData.money
			nk.userData["match.point"] = retData.point

			ResultAttendPopup.new({code = retData.treatureCode or "000000", type = 1}):showPanel()

			self.attendActBtnEnable = true

			if self and self.hidePanel_ then
				--todo
				self:hidePanel_()
			end

		end, function(errData)
			-- body
			dump(errData, "attendActDokb.errData :==================")

			self.reqAttendActReqId_ = nil
			if errData.errorCode == - 1 then
				--todo
				nk.TopTipManager:showTopTip(bm.LangUtil.getText("DOKB", "ATTENDED_FAILD_NOTENOUGH_PEOP"))

				bm.EventCenter:dispatchEvent(nk.eventNames.DOKB_LOTRY_LOAD_NEXTROUND_RERESHDATA)
			elseif errData.errorCode == - 2 then
				--todo
				nk.TopTipManager:showTopTip(bm.LangUtil.getText("DOKB", "ATTENED_FAILD_FINISHED"))

				bm.EventCenter:dispatchEvent(nk.eventNames.DOKB_LOTRY_LOAD_NEXTROUND_RERESHDATA)
			elseif errData.errorCode == - 3 then
				--todo
				nk.TopTipManager:showTopTip(bm.LangUtil.getText("DOKB", "ATTENED_FAILD_EXPIRED"))

				bm.EventCenter:dispatchEvent(nk.eventNames.DOKB_LOTRY_LOAD_NEXTROUND_RERESHDATA)
			elseif errData.errorCode == - 4 then
				--todo
				ResultAttendPopup.new({type = 3}):showPanel()
			elseif errData.errorCode == - 5 then
				--todo
				ResultAttendPopup.new({type = 2}):showPanel()
			else
				nk.TopTipManager:showTopTip(bm.LangUtil.getText("COMMON", "BAD_NETWORK"))
			end

			self.attendActBtnEnable = true
			
			if self and self.hidePanel_ then
				--todo
				self:hidePanel_()
			end
		end)
	end
	
	-- ResultAttendPopup.new({code = 12234, type = 3}):showPanel()
end

function DokbAttendActPopup:onArgTermsChkBtnCallBack_(evt)
	-- body
	if evt.state == "on" then
		--todo
		self.attendActBtn_:setButtonEnabled(true)
	else
		self.attendActBtn_:setButtonEnabled(false)
	end
end

function DokbAttendActPopup:showPanel(popEvtCallback, attendActCallBack)
	-- body
	self.popEvtCallBack_ = popEvtCallback
	self.attendActCallBack_ = attendActCallBack

	nk.PopupManager:addPopup(self)
end

function DokbAttendActPopup:onShowed()
	-- body
	if self and self.popEvtCallBack_ then
		--todo
		self.popEvtCallBack_()
	end
end

function DokbAttendActPopup:onEnter()
	-- body
end

function DokbAttendActPopup:onExit()
	-- body
	nk.ImageLoader:cancelJobByLoaderId(self.gemImgLoaderId_)

	if self.reqAttendActReqId_ then
		--todo
		nk.http.cancel(self.reqAttendActReqId_)
	end
end

function DokbAttendActPopup:onCleanup()
	-- body
end

return DokbAttendActPopup