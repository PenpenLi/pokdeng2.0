--
-- Author: TsingZhang@boyaa.com
-- Date: 2016-05-26 10:49:38
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: AttendDokbView.lua Reconstructed By Tsing7x.
--

local HelpPopup = import("app.module.settingHelp.SettingHelpPopupMgr")
local ExcMarketView = import("app.module.exchgMarket.ExcMarketView")
local StorePopup = import("app.module.store.StorePopup")
local PayGuide = import("app.module.store.purchGuide.PayGuide")
local FirChargePayGuidePopup = import("app.module.store.firChrgGuide.FirChrgPayGuidePopup")
local AgnChargePayGuidePopup = import("app.module.store.agnChrgGuide.AgnChrgPayGuidePopup")
local SuonaUsePopup = import("app.module.suona.SuonaUsePopup")

local DokbActListTermItem = import(".DokbActListTermItem")
local LotryRecListItem = import(".DokbLotryRecListItem")
local MyRecListItem = import(".DokbMyRecListItem")

local UserAddrComfirmPopup = import(".views.UserAddrComfirmPopup")
local DokbHelpPopup = import(".views.DokbActHelpPopup")

-- Normal Const --
local AVATAR_TAG = 100

local DIVID_LINE_RIGHT1_TAG = 7
local DIVID_LINE_RIGHT2_TAG = 17

local TOPOPR_PANEL_HEIGHT = 0
local LEFTOPR_PANEL_WIDTH = 0

local AttendDokbView = class("AttendDokbView", function()
	-- body
	return display.newNode()
end)

function AttendDokbView:ctor(controller)
	-- body
	self.controller_ = controller
	self.controller_:setDisplayView(self)

	self:setNodeEventEnabled(true)

    -- Bg --
    local bgScale = self.controller_:getBgScale()    
    local roomChoseBg = display.newSprite("hall_auxSurMain_bg.jpg")
        :scale(bgScale)
        :addTo(self)
    
    self.topOpreationAreaNode_ = display.newNode()
        :addTo(self)

    local topOpreationPanelCalModel = display.newSprite("#hall_panelTop.png")
    local topOpreationPanelSizeCal = topOpreationPanelCalModel:getContentSize()

    TOPOPR_PANEL_HEIGHT = topOpreationPanelSizeCal.height

    local topOprAreaPanelStencil = {
        x = 233,
        y = 0,
        width = 660,
        height = 100
    }

    self.topOpreationPanel_ = display.newScale9Sprite("#hall_panelTop.png", 0, display.cy - topOpreationPanelSizeCal.height / 2,
        CCSize(display.width, topOpreationPanelSizeCal.height), cc.rect(topOprAreaPanelStencil.x, topOprAreaPanelStencil.y,
            topOprAreaPanelStencil.width, topOprAreaPanelStencil.height))
        :addTo(self.topOpreationAreaNode_)

    local back2HallBtnCalModel = display.newSprite("#hall_auxBtnReturn.png")
    local back2HallBtnTexSize = back2HallBtnCalModel:getContentSize()

    self.return2HallBtn_ = cc.ui.UIPushButton.new({normal = "#hall_auxBtnReturn.png", pressed = "#hall_auxBtnReturn.png", disabled = "#hall_auxBtnReturn.png"},
        {scale9 = false})
        :onButtonClicked(buttontHandler(self, self.onReturnBtnCallBack_))
        :align(display.CENTER_LEFT)
        :pos(0, topOpreationPanelSizeCal.height / 2)
        :addTo(self.topOpreationPanel_)

    local userAvatarMagrins = {
        top = 10,
        left = - 13
    }

    self.userAvatarRim_ = display.newSprite("#common_bg_userAvatar.png")
    self.userAvatarRim_:pos(back2HallBtnTexSize.width + self.userAvatarRim_:getContentSize().width / 2 + userAvatarMagrins.left,
        topOpreationPanelSizeCal.height - self.userAvatarRim_:getContentSize().height / 2 - userAvatarMagrins.top)
        :addTo(self.topOpreationPanel_, 0)

    local avatarShownSizeBorderLen = 60

    local defaultAvatarImgPosAdj = {
        x = 1,
        y = 0
    }
    local defaultAvatarImg = display.newSprite("#common_female_avatar.png")
    defaultAvatarImg:scale(avatarShownSizeBorderLen / defaultAvatarImg:getContentSize().width)
    defaultAvatarImg:pos(self.userAvatarRim_:getPositionX() + defaultAvatarImgPosAdj.x, self.userAvatarRim_:getPositionY() - defaultAvatarImgPosAdj.y)
        :addTo(self.topOpreationPanel_, 1, AVATAR_TAG)

    self.userAvatarLoaderId_ = nk.ImageLoader:nextLoaderId()

    local labelParam = {
        fontSize = 0,
        color = display.COLOR_WHITE
    }

    labelParam.fontSize = 28
    labelParam.color = display.COLOR_WHITE

    local userNameLblMagrins = {
        top = 16,
        left = 12
    }

    self.userName_ = ui.newTTFLabel({text = "Name", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.userName_:setAnchorPoint(display.ANCHOR_POINTS[display.LEFT_TOP])
    self.userName_:pos(self.userAvatarRim_:getPositionX() + self.userAvatarRim_:getContentSize().width / 2 + userNameLblMagrins.left,
        topOpreationPanelSizeCal.height - userNameLblMagrins.top)
        :addTo(self.topOpreationPanel_)

    local expPrgbarMagrins = {
        left = 16,
        top = 8
    }

    local expPrgbarParam = {
        bgWidth = 125 * nk.widthScale,
        bgHeight = 10,
        fillWidth = 12,
        fillHeight = 8
    }

    self.expPrgBar_ = nk.ui.ProgressBar.new("#hall_prgLayer_exp.png", "#hall_prgFiller_exp.png", expPrgbarParam)
        :pos(self.userName_:getPositionX(), self.userName_:getPositionY() - self.userName_:getContentSize().height - expPrgbarMagrins.top)
        :addTo(self.topOpreationPanel_)

    -- Init LabelUserLevel Param --
    labelParam.fontSize = 16
    labelParam.color = display.COLOR_WHITE

    local userLevelLblMagrins = {
        top = 5,
        left = 16
    }

    self.userLevel_ = ui.newTTFLabel({text = "LV0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.userLevel_:setAnchorPoint(display.ANCHOR_POINTS[display.LEFT_TOP])
    self.userLevel_:pos(self.userName_:getPositionX(), self.expPrgBar_:getPositionY() - userLevelLblMagrins.top)
        :addTo(self.topOpreationPanel_)

    -- Omit --
    labelParam.fontSize = 15
    labelParam.color = cc.c3b(35, 175, 157)

    self.userExpVal_ = ui.newTTFLabel({text = "0/0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.userExpVal_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_TOP])
    self.userExpVal_:pos(self.userName_:getPositionX() + expPrgbarParam.bgWidth * 2 / 3, self.userLevel_:getPositionY())
        :addTo(self.topOpreationPanel_)

    -- TopArea Center Area --
    local currencyDentGapCnt = 16 * nk.widthScale
    local currencyDentMagrinTop = 20
    local currnecyDentPosXShift = back2HallBtnTexSize.width / 2 + 10 * nk.widthScale

    local gameCurrencyChipDent = display.newSprite("#hall_dentCurrency.png")
    local gameCurrencyCashDent = display.newSprite("#hall_dentCurrency.png")

    gameCurrencyChipDent:pos(display.cx + currnecyDentPosXShift - currencyDentGapCnt / 2 - gameCurrencyChipDent:getContentSize().width / 2, topOpreationPanelSizeCal.height -
        currencyDentMagrinTop - gameCurrencyChipDent:getContentSize().height / 2)
        :addTo(self.topOpreationPanel_)

    gameCurrencyCashDent:pos(display.cx + currnecyDentPosXShift + currencyDentGapCnt / 2 + gameCurrencyCashDent:getContentSize().width / 2, gameCurrencyChipDent:getPositionY())
        :addTo(self.topOpreationPanel_)

    local currencyNumLblMagrinLeft = 5
    local currencyAddBtnMagrinRight = 5
    local currencyIconMagrinLeft = 2
    local currencyGetBtnSizeWidth = 40

    labelParam.fontSize = 24
    labelParam.color = cc.c3b(80, 169, 149)
    
    -- CurrencyChip --
    local chipIcon = display.newSprite("#hall_ic_chip.png")
    chipIcon:pos(chipIcon:getContentSize().width / 2 + currencyIconMagrinLeft, gameCurrencyChipDent:getContentSize().height / 2)
        :addTo(gameCurrencyChipDent)

    self.chipNum_ = ui.newTTFLabel({text = "0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.chipNum_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.chipNum_:pos(chipIcon:getPositionX() + chipIcon:getContentSize().width / 2 + currencyNumLblMagrinLeft, chipIcon:getPositionY())
        :addTo(gameCurrencyChipDent)

    self.chipGetBtn_ = cc.ui.UIPushButton.new({normal = "#hall_btnGetCurrency_nor.png", pressed = "#hall_btnGetCurrency_nor.png", disabled = "#hall_btnGetCurrency_nor.png"},
        {scale9 = false})
        :onButtonClicked(buttontHandler(self, self.onGetChipBtnCallBack_))
        :pos(gameCurrencyChipDent:getContentSize().width - currencyAddBtnMagrinRight - currencyGetBtnSizeWidth / 2, chipIcon:getPositionY())
        :addTo(gameCurrencyChipDent)

    -- CurrencyCash --
    local cashIcon = display.newSprite("#hall_ic_cash.png")
    cashIcon:pos(cashIcon:getContentSize().width / 2 + currencyIconMagrinLeft, gameCurrencyCashDent:getContentSize().height / 2)
        :addTo(gameCurrencyCashDent)

    self.cashNum_ = ui.newTTFLabel({text = "0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.cashNum_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.cashNum_:pos(cashIcon:getPositionX() + cashIcon:getContentSize().width / 2 + currencyNumLblMagrinLeft, cashIcon:getPositionY())
        :addTo(gameCurrencyCashDent)

    self.cashGetBtn_ = cc.ui.UIPushButton.new({normal = "#hall_btnGetCurrency_nor.png", pressed = "#hall_btnGetCurrency_nor.png", disabled = "#hall_btnGetCurrency_nor.png"},
        {scale9 = false})
        :onButtonClicked(buttontHandler(self, self.onGetCashBtnCallBack_))
        :pos(gameCurrencyCashDent:getContentSize().width - currencyAddBtnMagrinRight - currencyGetBtnSizeWidth / 2, cashIcon:getPositionY())
        :addTo(gameCurrencyCashDent)

    local rightOprBtnMagrinEach = 18
    -- Top Area Right --
    local setBtnSize = {
        width = 35,
        height = 28
    }

    self.exchangeBtn_ = cc.ui.UIPushButton.new({normal = "#hall_auxBtnExchange.png", pressed = "#hall_auxBtnExchange.png", disabled = "#hall_auxBtnExchange.png"},
        {scale9 = false})
        :onButtonClicked(buttontHandler(self, self.onExchangeBtnCallBack_))
        :pos(display.width - rightOprBtnMagrinEach - setBtnSize.width / 2, gameCurrencyChipDent:getPositionY())
        :addTo(self.topOpreationPanel_)

    local divdLine1PosAdj = {
        x = 0,
        y = 0
    }

    local divdLineRight1 = display.newSprite("#hall_divLine_topPanel.png")
    divdLineRight1:pos(self.exchangeBtn_:getPositionX() - setBtnSize.width / 2 - rightOprBtnMagrinEach - divdLineRight1:getContentSize().width / 2,
        self.exchangeBtn_:getPositionY() - divdLine1PosAdj.y)
        :addTo(self.topOpreationPanel_, 1, DIVID_LINE_RIGHT1_TAG)

    local addrBtnSize = {
        width = 40,
        height = 40
    }

    self.addrMsgBtn_ = cc.ui.UIPushButton.new({normal = "#hall_auxBtnFeedBack.png", pressed = "#hall_auxBtnFeedBack.png", disabled = "#hall_auxBtnFeedBack.png"},
        {scale9 = false})
        :onButtonClicked(buttontHandler(self, self.onAddrMsgBtnCallBack_))
        :pos(divdLineRight1:getPositionX() - divdLineRight1:getContentSize().width / 2 - rightOprBtnMagrinEach - addrBtnSize.width / 2,
            self.exchangeBtn_:getPositionY())
        :addTo(self.topOpreationPanel_)

    local leftOprTabAreaPanelModel = display.newSprite("#hall_auxBgPanel_left.png")
    local leftOprTabAreaPanelSizeCal = leftOprTabAreaPanelModel:getContentSize()

    LEFTOPR_PANEL_WIDTH = leftOprTabAreaPanelSizeCal.width

    -- Souna Msg Block --
    self.suonaMsgBroPanelNode_ = display.newNode()
        :addTo(self, 1)

    local suonaMsgPanelMagrinTop = - 8

    local suonaMsgPanelSize = {
        width = display.width - leftOprTabAreaPanelSizeCal.width,
        height = 30
    }

    local suonaPanelStencil = {
        x = 136,
        y = 2,
        width = 650,
        height = 26
    }

    local suonaMsgPanel = display.newScale9Sprite("#hall_bg_suonaMsg.png", leftOprTabAreaPanelSizeCal.width / 2, display.cy - topOpreationPanelSizeCal.height -
        suonaMsgPanelMagrinTop - suonaMsgPanelSize.height / 2, CCSize(suonaMsgPanelSize.width, suonaMsgPanelSize.height), cc.rect(suonaPanelStencil.x, suonaPanelStencil.y,
            suonaPanelStencil.width, suonaPanelStencil.height))
        :addTo(self.suonaMsgBroPanelNode_)

    local suonaSendBtnMagrinHoriz = 118 * nk.widthScale
    local suonaSendBtnSize = {
        width = 40,
        height = 24
    }

    self.suonaSendBtn_ = cc.ui.UIPushButton.new({normal = "#hall_btnSuonaSend_nor.png", pressed = "#hall_btnSuonaSend_nor.png", disabled = "#hall_btnSuonaSend_nor.png"},
        {scale9 = false})
        :onButtonClicked(buttontHandler(self, self.onSuonaSendBtnCallBack_))
        :pos(suonaSendBtnMagrinHoriz + suonaSendBtnSize.width / 2, suonaMsgPanelSize.height / 2)
        :addTo(suonaMsgPanel)

    local sounaChatLabelMagrinRight = 12
    local sounaChatLabelHeight = 36

    local chatInfoLabelStencil = display.newDrawNode()
    chatInfoLabelStencil:drawPolygon({
        {- suonaMsgPanelSize.width / 2 + suonaSendBtnMagrinHoriz + suonaSendBtnSize.width + sounaChatLabelMagrinRight, - sounaChatLabelHeight / 2}, 
        {- suonaMsgPanelSize.width / 2 + suonaSendBtnMagrinHoriz + suonaSendBtnSize.width + sounaChatLabelMagrinRight,  sounaChatLabelHeight / 2}, 
        {suonaMsgPanelSize.width / 2 - suonaSendBtnMagrinHoriz - suonaSendBtnSize.width - sounaChatLabelMagrinRight,  sounaChatLabelHeight / 2}, 
        {suonaMsgPanelSize.width / 2 - suonaSendBtnMagrinHoriz - suonaSendBtnSize.width - sounaChatLabelMagrinRight, - sounaChatLabelHeight / 2}
    })

    local suonaChatInfoLabelClipNode_ = cc.ClippingNode:create()
        :pos(suonaMsgPanelSize.width / 2, suonaMsgPanelSize.height / 2)
        :addTo(suonaMsgPanel)

    suonaChatInfoLabelClipNode_:setStencil(chatInfoLabelStencil)

    self.suonaChatMsgStrPosXSrc = suonaMsgPanelSize.width / 2 - suonaSendBtnMagrinHoriz - suonaSendBtnSize.width - sounaChatLabelMagrinRight
    self.suonaChatMsgStrPosXDes = - suonaMsgPanelSize.width / 2 + suonaSendBtnMagrinHoriz + suonaSendBtnSize.width + sounaChatLabelMagrinRight

    -- Omit --
    labelParam.fontSize = 22
    labelParam.color = display.COLOR_RED -- Need To Modify

    self.suonaChatInfo_ = ui.newTTFLabel({text = "", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.suonaChatInfo_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.suonaChatInfo_:pos(self.suonaChatMsgStrPosXSrc - self.suonaChatInfo_:getContentSize().width, 0)
        :addTo(suonaChatInfoLabelClipNode_)

    self.suonaChatInfo_:setOpacity(0)

    -- Dokb Help Entry --
    local helpBtnSize = {
        width = 32,
        height = 32
    }

    local helpBtnMagrinRight = 6
    local helpBtnMagrinTopOprArea = - 8

    self.dokbHelpBtn_ = cc.ui.UIPushButton.new({normal = "#roomChos_btnQMark.png", pressed = "#roomChos_btnQMark.png", disabled = "#roomChos_btnQMark.png"},
        {scale9 = false})
        :onButtonClicked(buttontHandler(self, self.onDokbHelpBtnCallBack_))
        :pos(display.width / 2 - helpBtnMagrinRight - helpBtnSize.width / 2, display.height / 2 - TOPOPR_PANEL_HEIGHT - helpBtnMagrinTopOprArea - helpBtnSize.height / 2)
        :addTo(self.suonaMsgBroPanelNode_)

    -- Init defaultLeftTabIdx_ && RoomNorConfDataSet State Here--
    self.defaultLeftTabIdx_ = nk.userData.DOKB_TAB or 1

    self.leftTabOprAreaNode_ = display.newNode()
        :addTo(self, 2)

    local tabPanelLeftSizeHAdj = 10
    local tabPanelLeftSize = cc.size(leftOprTabAreaPanelSizeCal.width, display.height - topOpreationPanelSizeCal.height + tabPanelLeftSizeHAdj)
    local tabOprPanelLeft = display.newScale9Sprite("#hall_auxBgPanel_left.png", - display.width / 2 + tabPanelLeftSize.width / 2,
        - (display.height / 2 - tabPanelLeftSize.height / 2), tabPanelLeftSize)
        :addTo(self.leftTabOprAreaNode_)

    local tabBtnIconImgKeysNor = {
        "#dokb_actTypeMain_unSel.png",
        "#dokb_actTypeLotryRec_unSel.png",
        "#dokb_actTypeMyRec_unSel.png"
    }

    local tabBtnIdxLabel = {
        "夺宝",
        "开奖",
        "我的"
    }

    self.tabBtnGroupLeft = nk.ui.CheckBoxButtonGroup.new()
    self.tabLeftBtns_ = {}

    labelParam.fontSize = 28
    labelParam.color = display.COLOR_BLUE  -- state Nor

    local leftBtnTexModel = display.newSprite("#hall_auxBgTabHili_sel.png")
    local leftBtnTexSizeCal = leftBtnTexModel:getContentSize()

    local tabBtnsMagrins = {
        top = 2,
        each = 5
    }

    local tabBtnIconPosYCenOffSet = 20
    local tabBtnLblPosYCenOffSet = 25

    for i = 1, #tabBtnIdxLabel do
        self.tabLeftBtns_[i] = cc.ui.UICheckBoxButton.new({on = "#hall_auxBgTabHili_sel.png", off = "#common_modTransparent.png"}, {scale9 = true})
            :setButtonSize(leftBtnTexSizeCal.width, leftBtnTexSizeCal.height)
            :pos(tabPanelLeftSize.width / 2, tabPanelLeftSize.height - tabBtnsMagrins.top - (i * 2 - 1) * leftBtnTexSizeCal.height / 2 -
                (i - 1) * tabBtnsMagrins.each)
            :addTo(tabOprPanelLeft)

        self.tabLeftBtns_[i].icon_ = display.newSprite(tabBtnIconImgKeysNor[i])
            :pos(0, tabBtnIconPosYCenOffSet)
            :addTo(self.tabLeftBtns_[i])

        self.tabLeftBtns_[i].label_ = display.newTTFLabel({text = tabBtnIdxLabel[i], size = labelParam.fontSize, color = labelParam.color,
            align = ui.TEXT_ALIGN_CENTER})
            :pos(0, - tabBtnLblPosYCenOffSet)
            :addTo(self.tabLeftBtns_[i])

        self.tabBtnGroupLeft:addButton(self.tabLeftBtns_[i])
    end

    self.dokbActContPageNode_ = display.newNode()
        :pos(tabPanelLeftSize.width / 2, - topOpreationPanelSizeCal.height / 2)
        :addTo(self, 3)

    self.tabBtnGroupLeft:onButtonSelectChanged(handler(self, self.onLeftTabBtnSelChanged_))
    self.tabBtnGroupLeft:getButtonAtIndex(self.defaultLeftTabIdx_):setButtonSelected(true)
    self:addDataObservers()
end

function AttendDokbView:renderDokbActPageByIdx(pageIdx)
	-- body
	local drawDokbActPageByIdex = {
		[1] = function()
			-- body
			local actListPage = display.newNode()

			-- local testLabel = display.newTTFLabel({text = "This is Page ActList!", size = 24, align = ui.TEXT_ALIGN_CENTER})
			-- 	:addTo(actListPage)

            local labelParam = {
                fontSize = 0,
                color = display.COLOR_WHITE
            }

            local actListPageMainContBorderHoriz = 40 * nk.widthScale
            local actTernNumLblPaddingTopOprPanel = 35

            -- Init Term Num Label Param --
            labelParam.fontSize = 24
            labelParam.color = display.COLOR_WHITE

            local actTermNumLblPosXOffSet = 8
            self.actTermNum_ = display.newTTFLabel({text = "Term Id: 0", size = labelParam.fontSize, color = labelParam.color, align =
                ui.TEXT_ALIGN_CENTER})
            self.actTermNum_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_RIGHT])
            self.actTermNum_:pos(display.width / 2 - LEFTOPR_PANEL_WIDTH / 2 - actListPageMainContBorderHoriz - actTermNumLblPosXOffSet,
                display.height / 2 - TOPOPR_PANEL_HEIGHT / 2 - actTernNumLblPaddingTopOprPanel - self.actTermNum_:getContentSize().height / 2)
                :addTo(actListPage)

			-- self.actListSubAreaBtnGroup_ = nk.ui.CheckBoxButtonGroup.new()

			-- local subAreaNameStr = {
			-- 	"Test Area 1",
			-- 	"Test Area 2",
			-- 	"Test Area 3"
			-- }

			-- local subAreaBtnSize = {
			-- 	width = ,
			-- 	height = 
			-- }

			-- local subAreaBtnMagrins = {
			-- 	top = ,
			-- 	each = 
			-- }

			-- local subAreaBtnLabelParam = {
			-- 	frontSize = 0,
			-- 	color = display.COLOR_WHITE
			-- }

			-- self.actListSubAreaBtns_ = {}
			-- for i = 1, #subAreaNameStr do
			-- 	self.actListSubAreaBtns_[i] = cc.ui.UICheckBoxButton.new({on = "#.png", off = "#.png"},
			-- 		{scale9 = true})
			-- 		:setButtonSize(subAreaBtnSize.width, subAreaBtnSize.height)
			-- 		-- :setButtonLabel(display.newTTFLabel({text = subAreaNameStr[i], size = subAreaBtnLabelParam.frontSize, color = subAreaBtnLabelParam.color, align = ui.TEXT_ALIGN_CENTER}))
			-- 		:pos(, )
			-- 		:addTo(actListPage)

			-- 	self.actListSubAreaBtns_[i].label_ = display.newTTFLabel({text = subAreaNameStr[i], size = subAreaBtnLabelParam.frontSize, color = subAreaBtnLabelParam.color, align = ui.TEXT_ALIGN_CENTER})
			-- 		:addTo(self.actListSubAreaBtns_[i])

			-- 	self.actListSubAreaBtnGroup_:addButton(self.actListSubAreaBtns_[i])
			-- end

			-- self.actListSubAreaBtnGroup_:onButtonSelectChanged(handler(self, self.onActTypeSelectChanged))
			-- self.actListSubAreaBtnGroup_:getButtonAtIndex(self.defaultActTypeIdx_):setButtonSelected(true)

            local actListTermsPaddingTopOprPanel = 60

            local actListTermModel = display.newSprite("#dokb_bgActTermMain.png")
            local actListTermSizeCal = actListTermModel:getContentSize()

            local actListTermMagrinGapCal = (display.width - LEFTOPR_PANEL_WIDTH - actListPageMainContBorderHoriz * 2 - actListTermSizeCal.width * 3) / 2
            self.actListTermItems_ = {}

            for i = 1, 3 do
             self.actListTermItems_[i] = DokbActListTermItem.new()
                 :pos((actListTermSizeCal.width + actListTermMagrinGapCal) * (i - 2), display.height / 2 - TOPOPR_PANEL_HEIGHT / 2 - actListTermsPaddingTopOprPanel -
                    actListTermSizeCal.height / 2)
                 :addTo(actListPage)
            end

			return actListPage
		end,

		[2] = function()
			-- body
			local lottryRecPage = display.newNode()

			-- local testLabel = display.newTTFLabel({text = "This is Page LottryRec!", size = 24, align = ui.TEXT_ALIGN_CENTER})
   --              :addTo(lottryRecPage)
            -- Init Default LotryRecSubItemIdx Set 1 Temporary --
            self.defaultLotryRecSubItemIdx_ = 1

   			self.lotryTermIdBtnGroup_ = nk.ui.CheckBoxButtonGroup.new()

            local labelParam = {
                fontSize = 0,
                color = display.COLOR_WHITE
            }

   			local lotryTermIdStr = {
   				"Last 1 Id: 0",
   				"Last 2 Id: 0",
   				"Last 3 Id: 0",
   				"Last 4 Id: 0",
   				"Last 5 Id: 0",
   				"Last 6 Id: 0"
   			}

   			local lotryTermBtnSize = {
				width = 118,
				height = 35
			}

			local lotryTermBtnMagrins = {
				top = 32,
				each = 12 * nk.widthScale,
				groupLeft = 10 * nk.widthScale
			}

            labelParam.fontSize = 18
            labelParam.color = display.COLOR_WHITE

			self.lotryTermsIdBtns = {}
			for i = 1, #lotryTermIdStr do
				self.lotryTermsIdBtns[i] = cc.ui.UICheckBoxButton.new({on = "#dokb_btnTermId_sel.png", off = "#dokb_btnTermId_unSel.png"},
					{scale9 = true})
					:setButtonSize(lotryTermBtnSize.width, lotryTermBtnSize.height)
					:pos(- display.width / 2 + LEFTOPR_PANEL_WIDTH / 2 + lotryTermBtnMagrins.groupLeft + (2 * i - 1) / 2 * lotryTermBtnSize.width +
                        (i - 1) * lotryTermBtnMagrins.each, display.height / 2 - TOPOPR_PANEL_HEIGHT / 2 - lotryTermBtnMagrins.top - lotryTermBtnSize.height / 2)
					:addTo(lottryRecPage)

				self.lotryTermsIdBtns[i].label_ = display.newTTFLabel({text = lotryTermIdStr[i], size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
					:addTo(self.lotryTermsIdBtns[i])

				self.lotryTermIdBtnGroup_:addButton(self.lotryTermsIdBtns[i])
			end

			self.lotryTermIdBtnGroup_:onButtonSelectChanged(handler(self, self.onLotryRecTermIdSelectChanged))

			-- None Select For No Term Data --
			-- self.lotryTermIdBtnGroup_:getButtonAtIndex(self.defaultLotryRecSubItemIdx_):setButtonSelected(true)

			local lotryRefreshBtnSize = {
				width = 52,
				height = 35
			}

            local lotryRecRefrshBtnMagrinRight = 10
			-- local lotryRefreshBtnPosAdj = {
			-- 	x = 6,
			-- 	y = 0
			-- }

			self.lotryRecRefreshBtn_ = cc.ui.UIPushButton.new({normal = "#dokb_btnTermId_unSel.png", pressed = "#dokb_btnTermId_sel.png", disabled = "#dokb_btnTermId_unSel.png"},
                {scale9 = true})
                :setButtonSize(lotryRefreshBtnSize.width, lotryRefreshBtnSize.height)
				:onButtonClicked(handler(self, self.onLotryRecRefreshBtnCallBack_))
				:pos(display.width / 2 - LEFTOPR_PANEL_WIDTH / 2 - lotryRecRefrshBtnMagrinRight - lotryRefreshBtnSize.width / 2,
                    display.height / 2 - TOPOPR_PANEL_HEIGHT / 2 - lotryTermBtnMagrins.top - lotryRefreshBtnSize.height / 2)
				:addTo(lottryRecPage)

            local lotryRecRefreshIcon = display.newSprite("#dokb_icRefresh.png")
                :addTo(self.lotryRecRefreshBtn_)

            local lotryRecBgDentMagrinHoriz = 10
			local bgDentLotryRecSize = {
				width = display.width - LEFTOPR_PANEL_WIDTH - lotryRecBgDentMagrinHoriz * 2,
				height = 440 * nk.heightScale
			}

			local lotryRecBgMagrinTop = 12 * nk.heightScale

			local lotryRecBgDent = display.newScale9Sprite("#dokb_bgRecInfoMain.png", 0, self.lotryRecRefreshBtn_:getPositionY() - lotryRefreshBtnSize.height / 2 - lotryRecBgMagrinTop -
                bgDentLotryRecSize.height / 2, cc.size(bgDentLotryRecSize.width, bgDentLotryRecSize.height))
				:addTo(lottryRecPage)

            local bgGroupTitleMagrinHoriz = 2
			local bgGroupTitleDentSize = {
				width = bgDentLotryRecSize.width - 2 * bgGroupTitleMagrinHoriz,
				height = 45
			}

			local lotryRecGroupTitleBg = display.newScale9Sprite("#dokb_bgRecInfoDent.png", bgDentLotryRecSize.width / 2, bgDentLotryRecSize.height - bgGroupTitleDentSize.height / 2,
				cc.size(bgGroupTitleDentSize.width, bgGroupTitleDentSize.height))
				:addTo(lotryRecBgDent)

			local groupNameStr = --[[bm.LangUtil.getText("DOKB", "LOTRYREC_GROUP_NAME")]]
            {
				"夺宝物品",
				"中奖编号",
				"获奖用户",
				"我的夺宝编号"
			}

            labelParam.fontSize = 20
            labelParam.color = display.COLOR_WHITE

			local groupNameLbl = nil

			for i = 1, #groupNameStr do
				if i ~= #groupNameStr then
					--todo

					groupNameLbl = display.newTTFLabel({text = groupNameStr[i], size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
						:pos(bgGroupTitleDentSize.width / 10 * (2 * i - 1), bgGroupTitleDentSize.height / 2)
						:addTo(lotryRecGroupTitleBg)
				else
					groupNameLbl = display.newTTFLabel({text = groupNameStr[i], size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
						:pos(bgGroupTitleDentSize.width * 4 / 5, bgGroupTitleDentSize.height / 2)
						:addTo(lotryRecGroupTitleBg)
				end
			end

            local lotryRecListMagrinHoriz = 0
            local lotoryRecListMagrinVert = 6
			local lotryRecListViewSize = {
				width = bgDentLotryRecSize.width - lotryRecListMagrinHoriz * 2,
				height = bgDentLotryRecSize.height - bgGroupTitleDentSize.height - lotoryRecListMagrinVert * 2
			}

            local lotryRecListPosYAdj = 26
			self.lotryRecList_ = bm.ui.ListView.new({viewRect = cc.rect(- lotryRecListViewSize.width * 0.5, - lotryRecListViewSize.height * 0.5, lotryRecListViewSize.width,
				lotryRecListViewSize.height), direction = bm.ui.ListView.DIRECTION_VERTICAL --[[upRefresh = handler(self, self.onLotryRecUpToRefresh_)]]}, LotryRecListItem)
                :pos(0, - lotryRecListPosYAdj - bgGroupTitleDentSize.height / 2)
                :addTo(lottryRecPage)

            labelParam.fontSize = 36
            labelParam.color = display.COLOR_RED

            self.noLotryRecTip_ = display.newTTFLabel({text = "暂无记录" --[[bm.LangUtil.getText("DOKB", "LOTRYREC_NORECTIP")]], size = labelParam.frontSize,
                color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
            	:pos(0, - lotryRecListPosYAdj - bgGroupTitleDentSize.height / 2)
            	:addTo(lottryRecPage)
            	:hide()
            -- self.lotryRecList_:setData({1, 2, 3, 4, 5, 6, 7, 8})

			return lottryRecPage
		end,

		[3] = function()
			-- body
			local myPaticRecPage = display.newNode()

			-- local testLabel = display.newTTFLabel({text = "This is Page MyPaticRec!", size = 24, align = ui.TEXT_ALIGN_CENTER})
                -- :addTo(myPaticRecPage)
            
            local myRecBgDentMagrinHoriz = 12
			local bgContMyRecSize = {
    			width = display.width - LEFTOPR_PANEL_WIDTH - myRecBgDentMagrinHoriz * 2,
    			height = 490 * nk.heightScale
    		}

            local recBgDentPosYAdj = 10

			local myRecBgDent = display.newScale9Sprite("#dokb_bgRecInfoMain.png", 0, - recBgDentPosYAdj, cc.size(bgContMyRecSize.width, bgContMyRecSize.height))
				:addTo(myPaticRecPage)

            local bgGroupTitleMagrinHoriz = 2
			local bgGroupTitleSize = {
				width = bgContMyRecSize.width - bgGroupTitleMagrinHoriz * 2,
				height = 42
			}

			local myRecGroupTitleBg = display.newScale9Sprite("#dokb_bgRecInfoDent.png", bgContMyRecSize.width / 2, bgContMyRecSize.height - bgGroupTitleSize.height / 2,
				cc.size(bgGroupTitleSize.width, bgGroupTitleSize.height))
				:addTo(myRecBgDent)

            local labelParam = {
                fontSize = 0,
                color = display.COLOR_WHITE
            }

			local groupNameStr = --[[bm.LangUtil.getText("DOKB", "MYREC_GROUP_NAME")]]
            {
				"夺宝期号",
				"夺宝物品",
				"中奖编号",
				"过期时间",
				"领奖查询"
			}

            labelParam.fontSize = 20
            labelParam.color = display.COLOR_WHITE

            local groupLblborderMagrinHoriz = 36
            
            local groupNameLblModel = display.newTTFLabel({text = groupNameStr[1], size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
            local groupNameLblSizeCal = groupNameLblModel:getContentSize()

            local groupNameLblMagrinGap = (bgGroupTitleSize.width - groupLblborderMagrinHoriz * 2 - groupNameLblSizeCal.width) / 4

            local groupNameLbl = nil
			for i = 1, #groupNameStr do
				groupNameLbl = display.newTTFLabel({text = groupNameStr[i], size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
					:pos(bgGroupTitleSize.width / 2 - groupNameLblMagrinGap * (3 - i), bgGroupTitleSize.height / 2)
					:addTo(myRecGroupTitleBg)
			end

            local myRecListContMagrinHoriz = 0
            local myRecListContMagrinVert = 4
            local myRecListViewSize = {
                width = bgContMyRecSize.width - myRecListContMagrinHoriz * 2,
                height = bgContMyRecSize.height - bgGroupTitleSize.height - myRecListContMagrinVert * 2
            }

            local myRecListPosYAdj = 0
            self.myRecList_ = bm.ui.ListView.new({viewRect = cc.rect(- myRecListViewSize.width * 0.5, - myRecListViewSize.height * 0.5, myRecListViewSize.width,
                myRecListViewSize.height) --[[upRefresh = handler(self, self.onMyRecUpToRefresh_)]]}, MyRecListItem)
                :pos(0, - bgGroupTitleSize.height / 2 - myRecListPosYAdj - recBgDentPosYAdj)
                :addTo(myPaticRecPage)

            self.myRecList_:addEventListener("ITEM_EVENT", handler(self, self.onMyRecGoExcMarketEvtCallBack_))
            -- self.myRecList_:setData({1, 2, 3, 4, 5, 6, 8})

            labelParam.fontSize = 36
            labelParam.color = display.COLOR_RED

            self.noMyRecTip_ = display.newTTFLabel({text = "暂无记录" --[[bm.LangUtil.getText("DOKB", "MYREC_NORECTIP")]], size = labelParam.fontSize, color = labelParam.color,
                align = ui.TEXT_ALIGN_CENTER})
                :pos(0, - bgGroupTitleSize.height / 2 - myRecListPosYAdj - recBgDentPosYAdj)
                :addTo(myPaticRecPage)
                :hide()

			return myPaticRecPage
		end
	}

    self.dokbActPages_ = self.dokbActPages_ or {}

    for _, page in pairs(self.dokbActPages_) do
        if page then
            --todo
            page:hide()
        end
    end

    local page = self.dokbActPages_[pageIdx]

    if not page then
        --todo
        page = drawDokbActPageByIdex[pageIdx]()
        self.dokbActPages_[pageIdx] = page
        page:addTo(self.dokbActContPageNode_)
    end

    page:show()
end

function AttendDokbView:onAvatarLoadComplete_(success, sprite)
	-- body
	if success then
        --todo
        local oldAvatar = self.topOpreationPanel_:getChildByTag(AVATAR_TAG)
        if oldAvatar then
            oldAvatar:removeFromParent()
        end

        local sprSize = sprite:getContentSize()

        local avatarShownBorden = 60

        if sprSize.width > sprSize.height then
            sprite:scale(avatarShownBorden / sprSize.width)
        else
            sprite:scale(avatarShownBorden / sprSize.height)
        end

        local avatarImgPosAdj = {
            x = 1,
            y = 0
        }

        sprite:align(display.CENTER, self.userAvatarRim_:getPositionX() + avatarImgPosAdj.x,
            self.userAvatarRim_:getPositionY() - avatarImgPosAdj.y)
            :addTo(self.topOpreationPanel_, 1, AVATAR_TAG)
    end
end

function AttendDokbView:playSuonaMsgScrolling()
    -- body
    if not self.suonaMsgPlaying_ then
        --todo
        self:playSuonaMsgNext()
    end
end

function AttendDokbView:playSuonaMsgNext()
    -- body
    local currentSuonaMsgData = nil

    local suonaMsgShownColor = {
        tip = display.COLOR_WHITE,
        msg = cc.c3b(206, 206, 210)
    }
    if self.controller_.suonaMsgQueue_[1] then
        --todo
        currentSuonaMsgData = table.remove(self.controller_.suonaMsgQueue_, 1)
    else
        self.suonaChatInfo_:setString("")
        self.suonaChatInfo_:setTextColor(suonaMsgShownColor.tip)
        self.suonaChatInfo_:pos(self.suonaChatMsgStrPosXSrc - self.suonaChatInfo_:getContentSize().width, 0)

        self.suonaChatInfo_:setOpacity(0)

        self.suonaMsgPlaying_ = false
        return
    end

    -- dump(currentSuonaMsgData, "currentSuonaMsgData: =================")

    self.suonaMsgPlaying_ = true
    self.suonaChatInfo_:setString(currentSuonaMsgData)
    self.suonaChatInfo_:setTextColor(suonaMsgShownColor.msg)

    self.suonaChatInfo_:pos(self.suonaChatMsgStrPosXSrc, 0)

    local chatMsgPlayDelayTime = 0.2
    local chatMsgShownTimeIntval = 3
    -- local chatMsgLabelRollVelocity = 85
    local labelRollTime = 7
    -- self.suonaChatMsgStrPosXSrc - self.suonaChatMsgStrPosXDes / chatMsgLabelRollVelocity
    -- self.suonaChatInfo_:getContentSize().width / chatMsgLabelRollVelocity > 4 and 4 or self.suonaChatInfo_:getContentSize().width / chatMsgLabelRollVelocity
    -- self.suonaChatInfo_:show()
    self.suonaChatInfo_:setOpacity(255)

    self.suonaMsgAnim_ = transition.execute(self.suonaChatInfo_, cc.MoveTo:create(labelRollTime,
        cc.p(self.suonaChatMsgStrPosXDes, 0)), {delay = chatMsgPlayDelayTime / 2})

    self.suonaDelayCallHandler_ = nk.schedulerPool:delayCall(handler(self, self.playSuonaMsgNext), labelRollTime + chatMsgPlayDelayTime + chatMsgShownTimeIntval)
    -- self.delayScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.delayCallback_), 0.3 + DEFAULT_STAY_TIME + scrollTime)
end

function AttendDokbView:playShowAnim()
    -- body
    local animTime = self.controller_:getAnimTime()

    -- transition.moveTo(self.topBtnNode_, {time = animTime, y = 0, delay = animTime})

 --    transition.moveTo(self.bottomNode_, {time = animTime, y = - display.height / 2 + 45, delay = animTime})

 --    if self.dokbActPages_[1] then
 --     --todo
 --     local dokbActTermsItemsPosYAdj = 30
    --     for i, termItem in ipairs(self.actListTermItems_) do
    --      transition.moveTo(termItem, {time = animTime, y = - dokbActTermsItemsPosYAdj, delay = animTime + 0.05 * i,     
 --                easing = "BACKOUT"})
    --     end
 --    end
    
    -- transition.fadeIn(self.dokbActPageNode_, {time = animTime, opacity = 255, delay = animTime * 2})
end

function AttendDokbView:onLeftTabBtnSelChanged_(evt)
    -- body
    local tabBtnIconImgKeys = {
        {nor = "dokb_actTypeMain_unSel.png", sel = "dokb_actTypeMain_sel.png"},
        {nor = "dokb_actTypeLotryRec_unSel.png", sel = "dokb_actTypeLotryRec_sel.png"},
        {nor = "dokb_actTypeMyRec_unSel.png", sel = "dokb_actTypeMyRec_sel.png"}
    }

    local btnLblColor = {
        nor = display.COLOR_BLUE,
        sel = display.COLOR_WHITE
    }

    if not self.selectedIdx_ then
        --todo
        self.selectedIdx_ = evt.selected

        self.tabLeftBtns_[self.selectedIdx_].icon_:setSpriteFrame(tabBtnIconImgKeys[self.selectedIdx_].sel)
        self.tabLeftBtns_[self.selectedIdx_].label_:setTextColor(btnLblColor.sel)
    end

    local isChanged = self.selectedIdx_ ~= evt.selected

    if isChanged then
        --todo

        -- Modify Last Btn To Nor --
        self.tabLeftBtns_[self.selectedIdx_].icon_:setSpriteFrame(tabBtnIconImgKeys[self.selectedIdx_].nor)
        self.tabLeftBtns_[self.selectedIdx_].label_:setTextColor(btnLblColor.nor)

        -- Modify New Btn To Sel --
        self.tabLeftBtns_[evt.selected].icon_:setSpriteFrame(tabBtnIconImgKeys[evt.selected].sel)
        self.tabLeftBtns_[evt.selected].label_:setTextColor(btnLblColor.sel)

        self.selectedIdx_ = evt.selected
    end

    nk.userData.DOKB_TAB = self.selectedIdx_
    self:renderDokbActPageByIdx(self.selectedIdx_)

    self:getDokePageData()
end

function AttendDokbView:onReturnBtnCallBack_(evt)
    -- body
    self:hidePanel()
    nk.userData.DOKB_TAB = nil
end

function AttendDokbView:onGetChipBtnCallBack_(evt)
    -- body
    nk.DReport:report({id = "openStoreClick"})
    StorePopup.new():showPanel()
end

function AttendDokbView:onGetCashBtnCallBack_(evt)
    -- body
    nk.DReport:report({id = "openStoreClick"})

    local cashTabIndx = 2
    StorePopup.new(cashTabIndx):showPanel()
end

function AttendDokbView:onExchangeBtnCallBack_(evt)
    -- body
    self.exchangeBtn_:setButtonEnabled(false)

    local excMarketView = ExcMarketView.new(self.controller_):showPanel()
    excMarketView:setParentView(self)
    
    self.exchangeBtn_:setButtonEnabled(true)
end

function AttendDokbView:onAddrMsgBtnCallBack_(evt)
    -- body
    UserAddrComfirmPopup.new():showPanel()
end

function AttendDokbView:onFeedbackClick_(evt)
	-- body
	HelpPopup.new(false, true, 1):showPanel()
end

function AttendDokbView:onSuonaSendBtnCallBack_(evt)
	-- body
    -- local msgInfo = {
    --     type = 1,
    --     content = "通知:唉纱布的骄傲比我都看见爱我不打开暗红色的金卡和贷款还逗我还等哈啊肯定会！         ",
    --     -- location = "fillawrdaddr",
    --     name = "tsing"
    -- }
    -- local msgJson = json.encode(msgInfo)

    -- self.controller_:onSuonaBroadRecv_({data = {msg_info = msgJson}})
    -- do return end

    self.suonaSendBtn_:setButtonEnabled(false)
    SuonaUsePopup.new():show()

    self.suonaSendBtn_:setButtonEnabled(true)
end

function AttendDokbView:onDokbHelpBtnCallBack_(evt)
    -- body
    DokbHelpPopup.new():showPanel(handler(self, self.onHelpPopShowed))
end

-- Standby! --
function AttendDokbView:onActTypeSelectChanged(evt)
	-- body

	self.dokbActTypeSelectedIdx_ = evt.selected
end

function AttendDokbView:onLotryRecTermIdSelectChanged(evt)
	-- body
	if self.lotryRecTermIds_ and self.lotryRecTermIds_[evt.selected] then
		--todo
        self.defaultLotryRecSubItemIdx_ = evt.selected
		self.lotryRecTermIdSelected_ = self.lotryRecTermIds_[evt.selected]
	else
		self.lotryRecTermIdSelected_ = 0
	end
	
	self:getLotryRecInTermId()
end

function AttendDokbView:onLotryRecRefreshBtnCallBack_(evt)
    -- body
    self.lotryRecRefreshBtn_:setButtonEnabled(false)

    self:getDokePageData()
end

function AttendDokbView:onMyRecGoExcMarketEvtCallBack_(evt)
    -- body
    local excPageRecIdx = 0

    local excMarketView = ExcMarketView.new(self.controller_, excPageRecIdx):showPanel()
    excMarketView:setParentView(self)
end

function AttendDokbView:onHelpPopShowed()
	-- body
	-- if self.checkHelpInsTipsRepeatAction_ then
	-- 	--todo
	-- 	self:stopAction(self.checkHelpInsTipsRepeatAction_)
	-- end

	-- if self and self.bgHelpTipInsNode_ then
	-- 	--todo
	-- 	self.bgHelpTipInsNode_:removeFromParent()
 --        self.bgHelpTipInsNode_ = nil
	-- end
end

function AttendDokbView:addDataObservers()
    -- body
    self.avatarUrlObserverHandle_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "aUser.micon", handler(self, function (obj, micon)
        if not micon or string.len(micon) <= 5 then
            if nk.userData["aUser.msex"] == 2 or nk.userData["aUser.msex"] == 0 then
                self:onAvatarLoadComplete_(true, display.newSprite("#common_female_avatar.png"))
            else
                self:onAvatarLoadComplete_(true, display.newSprite("#common_male_avatar.png"))
            end
        else
            local imgurl = micon
            if string.find(imgurl, "facebook") then
                if string.find(imgurl, "?") then
                    imgurl = imgurl .. "&width=100&height=100"
                else
                    imgurl = imgurl .. "?width=100&height=100"
                end
            end
            nk.ImageLoader:loadAndCacheImage(obj.userAvatarLoaderId_, imgurl, handler(obj, obj.onAvatarLoadComplete_), 
                nk.ImageLoader.CACHE_TYPE_USER_HEAD_IMG)
        end
        
    end))

    self.nickObserverHandle_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "aUser.name", handler(self, function (obj, name)
        if obj and obj.userName_ then
            obj.userName_:setString(nk.Native:getFixedWidthText("", 24, name, 200))
        end
        
    end))

    self.experienceObserverHandle_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "aUser.exp", handler(self, function (obj, experience)
        local percent, progress, all

        percent, progress, all, self.lvRequest_ = nk.Level:getLevelUpProgress(experience, function(levelData, percent, progress, all)

            if obj then
                --todo
                if obj.expPrgBar_ then
                    --todo
                    obj.expPrgBar_:setValue(percent)
                end

                if obj.userLevel_ then
                    --todo
                    obj.userLevel_:setString(bm.LangUtil.getText("COMMON", "LEVEL", nk.Level:getLevelByExp(experience)))
                end

                if obj.userExpVal_ then
                    --todo
                    obj.userExpVal_:setString(progress .. "/" .. all)
                end

                self.lvRequest_ = nil
            end

        end)
        
        if obj then
            --todo
            if obj.expPrgBar_ then
                --todo
                obj.expPrgBar_:setValue(percent)
            end

            if obj.userLevel_ then
                --todo
                obj.userLevel_:setString(bm.LangUtil.getText("COMMON", "LEVEL", nk.Level:getLevelByExp(experience)))
            end

            if obj.userExpVal_ then
                --todo
                obj.userExpVal_:setString(progress .. "/" .. all)
            end
        end
    end))
    
    self.moneyObserverHandle_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "aUser.money", handler(self, function (obj, money)
        if obj and obj.chipNum_ then
            if money >= 10000000 then
                --todo
                obj.chipNum_:setString(bm.formatBigNumber(money))
            else
                obj.chipNum_:setString(bm.formatNumberWithSplit(money))
            end
        end
        
    end))

    self.cashNumChangeObserverHandler_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "match.point", handler(self, function(obj, cash)
        -- body
        if obj and obj.cashNum_ then
            --todo
            if cash >= 10000000 then
                --todo
                obj.cashNum_:setString(bm.formatBigNumber(cash))
            else
                obj.cashNum_:setString(bm.formatNumberWithSplit(cash))
            end
        end
    end))
end

function AttendDokbView:getDokePageData()
	-- body
	local getDokbPageDataByIdx = {
		[1] = function()
			-- body

			self.reqGetDokbActListDataId_ = nk.http.getDokbActList(function(retData)
				-- body
				-- dump(retData, "getDokbActList.retData :====================", 5)

				if retData and retData.data then
					--todo
					if self and self.actTermNum_ then
						--todo
						self.actTermNum_:setString(bm.LangUtil.getText("DOKB", "TERM_SERIAL_NUMBER", retData.daytime or 0))
					end

					if self and self.actListTermItems_ then
						--todo
						for i = 1, #self.actListTermItems_ do
							if retData.data[i] then
								--todo
								retData.data[i].termId_ = retData.daytime or 0

								self.actListTermItems_[i]:refreshTermItemUiData(retData.data[i])
							end
						end
					end
				end

			end, function(errData)
				-- body
                dump(errData, "getDokbActList.errData :==================")
				self.reqGetDokbActListDataId_ = nil

				if self and self.onGetPageDataWrong then
					--todo
					self:onGetPageDataWrong()
				end
			end)
		end,

		[2] = function()
			-- body
			self.reqGetDokbLotryRecTermId_ = nk.http.getDokbLotryRecTermId(function(retData)
				-- body
				-- dump(retData, "getDokbLotryRecTermId.data :====================")
				if self.lotryRecTermIds_ then
					--todo
					self.lotryRecTermIds_ = nil
				end

				self.lotryRecTermIds_ = {}
				for i = 1, #retData do
					if retData[i] then
						--todo
						table.insert(self.lotryRecTermIds_, retData[i].time)
					end
				end

				if self and self.lotryTermsIdBtns then
					--todo
					for i = 1, #self.lotryTermsIdBtns do

						self.lotryTermsIdBtns[i]:show()

						if self.lotryRecTermIds_[i] then
							--todo
							self.lotryTermsIdBtns[i].label_:setString(bm.LangUtil.getText("DOKB", "TERM_SERIAL_NUMBER", self.lotryRecTermIds_[i]))
						else
							self.lotryTermsIdBtns[i]:hide()
						end
						
					end
				end

				if self and self.lotryTermIdBtnGroup_ then
					--todo
					if self.lotryTermIdBtnGroup_:getButtonAtIndex(self.defaultLotryRecSubItemIdx_):isButtonSelected() then
						--todo
						self:getLotryRecInTermId()
					else
						self.lotryTermIdBtnGroup_:getButtonAtIndex(self.defaultLotryRecSubItemIdx_):setButtonSelected(true)
					end
				end

				if self and self.lotryRecRefreshBtn_ then
					--todo
					self.lotryRecRefreshBtn_:setButtonEnabled(true)
				end
			end, function(errData)
				-- body
				self.reqGetDokbLotryRecTermId_ = nil

				-- dump(errData, "getDokbLotryRecTermId.errData :==================")

				if self and self.onGetPageDataWrong then
					--todo
					self:onGetPageDataWrong()
				end

				if self and self.lotryRecRefreshBtn_ then
					--todo
					self.lotryRecRefreshBtn_:setButtonEnabled(true)
				end
			end)
		end,

		[3] = function()
			-- body
			self.reqGetDokbMyRecDataId_ = nk.http.getDokbMyAtdRec(function(retData)
				-- body
				-- dump(retData, "getDokbMyAtdRec.data :====================")

				if #retData <= 0 then
					--todo
					self.myRecList_:setData(nil)
					self.noMyRecTip_:show()
				else
					self.noMyRecTip_:hide()
					self.myRecList_:setData(retData)
				end
				
			end, function(errData)
				-- body
				self.reqGetDokbMyRecDataId_ = nil
				-- dump(errData, "getDokbMyAtdRec.errData :=====================")

				if self and self.onGetPageDataWrong then
					--todo
					self:onGetPageDataWrong()
				end
			end)
		end
	}

	getDokbPageDataByIdx[self.selectedIdx_]()
end

function AttendDokbView:getLotryRecInTermId()
	-- body

	self.reqGetLotryRecDataByTermId_ = nk.http.getDokbLotryRec(self.lotryRecTermIdSelected_, function(retData)
		-- body
		-- dump(retData, "getDokbLotryRec.data :=====================", 6)

		if retData then
			--todo
			if #retData <= 0 then
				--todo
				self.lotryRecList_:setData(nil)
				self.noLotryRecTip_:show()
			else
				self.noLotryRecTip_:hide()
				self.lotryRecList_:setData(retData)
			end
		end

	end, function(errData)
		-- body
		self.reqGetLotryRecDataByTermId_ = nil
		-- dump(errData, "getDokbLotryRec.errData :==================")

		nk.ui.Dialog.new({messageText = bm.LangUtil.getText("COMMON", "REQUEST_DATA_FAIL"), secondBtnText = bm.LangUtil.getText("COMMON", "RETRY"), 
	        callback = function (type)
	            if type == nk.ui.Dialog.SECOND_BTN_CLICK then
	                self:getLotryRecInTermId()
	            end
	        end}):show()
	end)
end

function AttendDokbView:onGetPageDataWrong()
	-- body
	nk.ui.Dialog.new({messageText = bm.LangUtil.getText("COMMON", "REQUEST_DATA_FAIL"), secondBtnText = bm.LangUtil.getText("COMMON", "RETRY"), 
        callback = function (type)
            if type == nk.ui.Dialog.SECOND_BTN_CLICK then
                self:getDokePageData()
            end
        end}):show()
end

function AttendDokbView:reloadActListData(evt)
	-- body
	self:getDokePageData()
end

function AttendDokbView:removeDataObservers()
    -- body
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.micon", self.avatarUrlObserverHandle_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.money", self.userMoneyChangeObserver_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "match.point", self.userCashChangeObserver_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.name", self.nickObserverHandle_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.exp", self.experienceObserverHandle_)
end

function AttendDokbView:showPanel(showedCallBack, hideCallBack)
    -- body
    self.onShowedCallBack_ = showedCallBack
    -- self.hideCallBack_ = hideCallBack

    nk.PopupManager:addPopup(self, false, nil, nil, false)
    return self
end

function AttendDokbView:onShowed()
    -- body
    if self and self.onShowedCallBack_ then
        --todo
        self.onShowedCallBack_()
    end
end

function AttendDokbView:hidePanel()
    -- body
    self.controller_:showMainHallView()
    nk.PopupManager:removePopup(self)
    -- if self and self.hideCallBack_ then
    --     --todo
    --     local MainHallViewTablePosTop = 1
    --     self.hideCallBack_(MainHallViewTablePosTop)
    -- end
end

function AttendDokbView:onEnter()
	-- body

	bm.EventCenter:addEventListener(nk.eventNames.DOKB_LOTRY_LOAD_NEXTROUND_RERESHDATA, handler(self, self.reloadActListData))
end

function AttendDokbView:onExit()
	-- body
    if self.suonaMsgAnim_ then
        --todo
        self:stopAction(self.suonaMsgAnim_)
        self.suonaMsgAnim_ = nil
    end

    if self.suonaDelayCallHandler_ then
        --todo
        nk.schedulerPool:clear(self.suonaDelayCallHandler_)
        self.suonaDelayCallHandler_ = nil
    end

    -- if self.checkHelpInsTipsRepeatAction_ then
    --     --todo
    --     self:stopAction(self.checkHelpInsTipsRepeatAction_)
    --     self.checkHelpInsTipsRepeatAction_ = nil
    -- end

    self:removeDataObservers()
    bm.EventCenter:removeEventListenersByEvent(nk.eventNames.DOKB_LOTRY_LOAD_NEXTROUND_RERESHDATA)

    if self.reqGetDokbActListDataId_ then
        --todo
        nk.http.cancel(self.reqGetDokbActListDataId_)
    end

    if self.reqGetDokbLotryRecTermId_ then
        --todo
        nk.http.cancel(self.reqGetDokbLotryRecTermId_)
    end

    if self.reqGetLotryRecDataByTermId_ then
        --todo
        nk.http.cancel(self.reqGetLotryRecDataByTermId_)
    end

    if self.reqGetDokbMyRecDataId_ then
        --todo
        nk.http.cancel(self.reqGetDokbMyRecDataId_)
    end
end

function AttendDokbView:onCleanup()
	-- body
    display.removeSpriteFramesWithFile("dokb_act.plist", "dokb_act.png")

    nk.schedulerPool:delayCall(function()
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    end, 0.1)
end

return AttendDokbView