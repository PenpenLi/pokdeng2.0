--
-- Author: TsingZhang@boyaa.com
-- Date: 2016-04-06 10:38:41
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: FirChargePayGuidePop Create && Reconstructed By TsingZhang.
--

local UserCrash = import("app.module.userCrash.UserCrash")
local StorePopup = import("app.module.store.StorePopup")

local FirChrgPgController = import(".FirChrgPgController")

local FirChargePayGuidePopup = class("FirChargePayGuidePopup", function()
	-- body
	return display.newNode()
end)

-- @Param sceneType : 1.nor, 0.bankRupt. 2.chipLess--
function FirChargePayGuidePopup:ctor(sceneType)
	-- body
	self:setNodeEventEnabled(true)

	self.controller_ = FirChrgPgController.new(self)
	self.sType_ = sceneType or 1
	display.addSpriteFrames("chargeFirstFav_texture.plist", "chargeFirstFav_texture.png", handler(self, self.onFirChgTextureLoaded))
end

function FirChargePayGuidePopup:onFirChgTextureLoaded(fileName, imgName)
	-- body
	self.background_ = display.newSprite("#chgFir_bgMainPanel.png")
		:addTo(self)

	self.background_:setTouchEnabled(true)
	self.background_:setTouchSwallowEnabled(true)

	local bgPanelSize = self.background_:getContentSize()

	local bgTitlePosYAdj = 5
	local bgTitleBarLeftHalf = display.newSprite("#chgFir_decTitleLeft.png")
	bgTitleBarLeftHalf:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_RIGHT])
	bgTitleBarLeftHalf:pos(bgPanelSize.width / 2, bgPanelSize.height - bgTitlePosYAdj)
		:addTo(self.background_)

	local bgTitleBarRightHalf = bgTitleBarLeftHalf:clone()
	bgTitleBarRightHalf:flipX(true)
	bgTitleBarRightHalf:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
	bgTitleBarRightHalf:pos(bgPanelSize.width / 2, bgPanelSize.height - bgTitlePosYAdj)
		:addTo(self.background_)

	local labelParam = {
		fontSize = 0,
		color = display.COLOR_BLACK
	}

	local getTitleSprPathBySceneType = {
		[0] = "#chgFir_titleDesc_bankRupt.png",
		[1] = "#chgFir_titleDesc_nor.png",
		[2] = "#chgFir_titleDesc_chipLess.png"
	}

	local titlePosYAdjust = 5
	local titleDescSpr = display.newSprite(getTitleSprPathBySceneType[self.sType_])
		:pos(bgPanelSize.width / 2, bgPanelSize.height + titlePosYAdjust)
		:addTo(self.background_)

	local closeBtn = cc.ui.UIPushButton.new({normal = "#common_btnPanelClose.png", pressed = "#common_btnPanelClose.png", disabled = "#common_btnPanelClose.png"},
		{scale9 = false})
		:onButtonClicked(buttontHandler(self, self.onCloseBtnCallBack_))
		:pos(bgPanelSize.width, bgPanelSize.height)
		:addTo(self.background_)

	local decGiftPackMagrins = {
		left = 25,
		bottom = 35
	}

	local decGiftPack = display.newSprite("#chgFir_decGiftPack.png")
	decGiftPack:pos(decGiftPackMagrins.left + decGiftPack:getContentSize().width / 2, decGiftPackMagrins.bottom + decGiftPack:getContentSize().height / 2)
		:addTo(self.background_)

	local rewItemIconPosX = 350
	local rewItemGapBgMid = 8
	local rewItemMagrinEachVert = 60

	local rewItemIconChip = display.newSprite("#chgFir_icChip.png")
		:pos(rewItemIconPosX, bgPanelSize.height / 2 - rewItemGapBgMid + rewItemMagrinEachVert)
		:addTo(self.background_)

	local rewItemIconCash = display.newSprite("#chgFir_icCash.png")
		:pos(rewItemIconPosX, bgPanelSize.height / 2 - rewItemGapBgMid)
		:addTo(self.background_)

	labelParam.fontSize = 24
	labelParam.color = display.COLOR_WHITE

	local rewardItemDescMagrinLeft = 8
	self.rewItemChipDesc_ = display.newTTFLabel({text = "chips :0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
	self.rewItemChipDesc_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
	self.rewItemChipDesc_:pos(rewItemIconPosX + rewItemIconChip:getContentSize().width / 2 + rewardItemDescMagrinLeft, rewItemIconChip:getPositionY())
		:addTo(self.background_)

	self.rewItemCashDesc_ = display.newTTFLabel({text = "cash :0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
	self.rewItemCashDesc_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
	self.rewItemCashDesc_:pos(rewItemIconPosX + rewItemIconCash:getContentSize().width / 2 + rewardItemDescMagrinLeft, rewItemIconCash:getPositionY())
		:addTo(self.background_)

	local goBuyBtnFavSize = {
		width = 350,
		height = 70
	}

	local goBuyFavBtnMagrins = {
		right = 78,
		bottom = 52
	}

	labelParam.fontSize = 28
	labelParam.color = display.COLOR_WHITE

	self.goBuyFavBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnGreenRigOutl.png", pressed = "#common_btnGreenRigOutl.png", disabled = "#common_btnGreyLitRigOut.png"},
		{scale9 = true})
		:setButtonSize(goBuyBtnFavSize.width, goBuyBtnFavSize.height)
		:setButtonLabel(display.newTTFLabel({text = bm.LangUtil.getText("CPURCHGUIDE", "GETREWARD_BYPRICE", 0), size = labelParam.fontSize, color = labelParam.color, align =
			ui.TEXT_ALIGN_CENTER}))
		:onButtonClicked(buttontHandler(self, self.onBuyFavBtnCallBack_))
		:pos(bgPanelSize.width - goBuyFavBtnMagrins.right - goBuyBtnFavSize.width / 2, goBuyFavBtnMagrins.bottom + goBuyBtnFavSize.height / 2)
		:addTo(self.background_)

	self.goBuyFavBtn_:setButtonEnabled(false)

	self.loadingBar_ = nk.ui.Juhua.new()
		:addTo(self)

	self:loadPaymentData()
end

function FirChargePayGuidePopup:setLoadingBarEnabled(isLoading)
	-- body
	if isLoading then
		--todo
		if self then
			--todo
			if not self.loadingBar_ then
				--todo
				self.loadingBar_ = nk.ui.Juhua.new()
					:addTo(self)
			end
		end
	else
		if self and self.loadingBar_ then
			--todo
			self.loadingBar_:removeFromParent()
			self.loadingBar_ = nil
		end
	end
end

function FirChargePayGuidePopup:loadPaymentData()
	-- body
	self.controller_:getFirstChargePayment()
end

function FirChargePayGuidePopup:onPaymentDataGet(data)
	-- body
	self.loadingBar_:removeFromParent()
	self.loadingBar_ = nil

	self.rewItemChipDesc_:setString(bm.LangUtil.formatString(bm.LangUtil.getText("CPURCHGUIDE", "FIRCHRG_REWARDS")[1], bm.formatNumberWithSplit(data.pchips or 0)))
	self.rewItemCashDesc_:setString(bm.LangUtil.formatString(bm.LangUtil.getText("CPURCHGUIDE", "FIRCHRG_REWARDS")[2], bm.formatNumberWithSplit(data.pcoins or 0)))

	self.goBuyFavBtn_:setButtonLabelString(bm.LangUtil.getText("CPURCHGUIDE", "GETREWARD_BYPRICE", data.price or 0))
	self.goBuyFavBtn_:setButtonEnabled(true)
end

function FirChargePayGuidePopup:onPaymentDataWrong(errData)
	-- body
	nk.ui.Dialog.new({messageText = bm.LangUtil.getText("COMMON", "REQUEST_DATA_FAIL"), secondBtnText = bm.LangUtil.getText("COMMON", "RETRY"),
		callback = function(type)
            if type == nk.ui.Dialog.SECOND_BTN_CLICK then
                self.controller_:getFirstChargePayment()
            else
            	if self.loadingBar_ then
            		--todo
            		self.loadingBar_:removeFromParent()
					self.loadingBar_ = nil
            	end
            end
        end
    }):show()
end

function FirChargePayGuidePopup:onBuyFavBtnCallBack_(evt)
	-- body
	self.loadingBar_ = nk.ui.Juhua.new(nil, true)
		:addTo(self)
	self.controller_:purchaseRewardBag()

	self.state_ = nil
end

function FirChargePayGuidePopup:onCloseBtnCallBack_(evt)
	-- body
	self:hidePanel()
end

-- @Param :state 0.Needed BankRuptPop, nil.None Oper onCleanup, others.ChipNotEnough; 
-- quickPlayHandler.quickPlayFunc; inRoom.isInRoomFlag
function FirChargePayGuidePopup:showPanel(state, quickPlayHandler, inRoom)
	-- body
	self.state_ = state
	self.handler_ = quickPlayHandler
	self.inRoom_ = inRoom

	nk.PopupManager:addPopup(self)

	nk.http.reportFirstPayData(2, function(retData)
        -- body
        -- dump(retData, "reportFirstPayData.data :==================")
        
    end, function(errData)
        -- body
        dump(retData, "reportFirstPayData.errData :==================")
    end)
end

function FirChargePayGuidePopup:hidePanel()
	-- body
	nk.PopupManager:removePopup(self)
end

function FirChargePayGuidePopup:onShowed()
	-- body
end

function FirChargePayGuidePopup:onEnter()
	-- body
end

function FirChargePayGuidePopup:onExit()
	-- body
	self.controller_:dispose()

	if not self.state_ then
		--todo
		return
	end

	if self.state_ == 0 then
		--todo
		if nk.userData["aUser.bankMoney"] >= nk.userData.bankruptcyGrant.maxsafebox then
            local userCrash = UserCrash.new(0, 0, 0, 0, true, self.inRoom_)
            userCrash:show()

        else
        	local rewardTime = nk.userData.bankruptcyGrant.bankruptcyTimes + 1
	        local bankruptcyTimes = nk.userData.bankruptcyGrant.bankruptcyTimes
	        local rewardMoney = nk.userData.bankruptcyGrant.money[rewardTime] or 0
	        local limitDay = nk.userData.bankruptcyGrant.day or 1
	        local limitTimes = nk.userData.bankruptcyGrant.num or 0
	        local userCrash = UserCrash.new(bankruptcyTimes, rewardMoney, limitDay, limitTimes)
	        userCrash:show()
        end
	else
		local runningScene = nk.runningScene
		if (not runningScene) or (runningScene.name == nil) or runningScene.name == "RoomScene" then
			nk.ui.Dialog.new({hasCloseButton = false, messageText = bm.LangUtil.getText("ROOM", "SIT_DOWN_NOT_ENOUGH_MONEY"), firstBtnText =
				bm.LangUtil.getText("ROOM", "AUTO_CHANGE_ROOM"), secondBtnText = bm.LangUtil.getText("ROOM", "CHARGE_CHIPS"), callback = function (type)
		            if type == nk.ui.Dialog.FIRST_BTN_CLICK then
		            	if self.handler_ then
		            		--todo
		            		if self.handler_ == - 1 then
		            			--todo
		            			nk.TopTipManager:showTopTip(bm.LangUtil.getText("HALL", "PERSONAL_ROOM_CANT_CHANGEROOM"))
		            		else
		            			self.handler_()
		            		end
		            	else
		            		nk.server:quickPlay()
		            	end
		            elseif type == nk.ui.Dialog.SECOND_BTN_CLICK then
		                	StorePopup.new():showPanel()
		                end
		            end
		        }
		    ):show() 
	    else
	    	nk.ui.Dialog.new({hasCloseButton = true, hasFirstButton = false, messageText = bm.LangUtil.getText("ROOM", "SIT_DOWN_NOT_ENOUGH_MONEY"), secondBtnText =
	    		bm.LangUtil.getText("ROOM", "CHARGE_CHIPS"), callback = function (type)
		            if type == nk.ui.Dialog.FIRST_BTN_CLICK then
		            	if self.handler_ then
		            		--todo
		            		self.handler_()
		            	else
		            		nk.server:quickPlay()
		            	end
		            elseif type == nk.ui.Dialog.SECOND_BTN_CLICK then
		                	StorePopup.new():showPanel()
		                end
		            end
		    	}
		    ):show() 
	    end

	end
end

function FirChargePayGuidePopup:onCleanup()
	-- body
	display.removeSpriteFramesWithFile("chargeFirstFav_texture.plist", "chargeFirstFav_texture.png")
	nk.schedulerPool:delayCall(function()
	    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
	end, 0.1)
end

return FirChargePayGuidePopup