--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-03-02 16:54:25
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: ChooseRoomView.lua By Tsing7x.
--

local StorePopup = import("app.module.store.StorePopup")
local HelpPopup = import("app.module.settingHelp.SettingHelpPopupMgr")
local PayGuide = import("app.module.store.purchGuide.PayGuide")
local PayGuidePopMgr = import("app.module.store.purchGuide.PayGuidePopMgr")
local FirChargePayGuidePopup = import("app.module.store.firChrgGuide.FirChrgPayGuidePopup")
local ExcMarketView = import("app.module.exchgMarket.ExcMarketView")
local SuonaUsePopup = import("app.module.suona.SuonaUsePopup")
local InvitePopup = import("app.module.friend.InviteRecallPopup")

local HallSearchRoomPanel = import(".views.HallSearchRoomPanel")
local PerRoomHelpPopup = import(".views.PerRoomHelpPopup")
local CreatePerRoomPopup= import(".views.CreatePerRoomPopup")
local PswEntryPopup = import(".views.PswEntryPopup")
local QRCodePopup = import(".views.QRCodeShowPopup")
local AnimUpScrollQueue = import(".views.AnimUpScrollQueue")

local ChooseRoomChip = import(".ChooseRoomChip")
local ChooseProRoomListItem = import(".ChooseProRoomListItem")
local ChoosePersonRoomListItem = import(".ChoosePersonRoomListItem")

local ROOM_TYPE_NOR = 1
local ROOM_TYPE_PRO = 2
local CHIP_HORIZONTAL_DISTANCE = 192 * nk.widthScale
local CHIP_VERTICAL_DISTANCE   = 200 * nk.heightScale

local AVATAR_TAG = 100

local DIVID_LINE_RIGHT1_TAG = 7
local DIVID_LINE_RIGHT2_TAG = 17

local TOPOPR_PANEL_HEIGHT = 0
local LEFTOPR_PANEL_WIDTH = 0

local ChooseRoomView = class("ChooseRoomView", function()
    return display.newNode()
end)

ChooseRoomView.PLAYER_LIMIT_SELECTED = 1 -- 1: 9 Peop Ihci; 2: 5 Peop Ihci
ChooseRoomView.ROOM_LEVEL_SELECTED   = 1 -- 1: Ihci Primary; 2: Ihci Middle; 3: Ihci Senior

function ChooseRoomView:ctor(controller, viewType)
    self.controller_ = controller
    self.controller_:setDisplayView(self)
    self:setNodeEventEnabled(true)

    if viewType == controller.CHOOSE_NOR_VIEW then
        self.roomType_ = ROOM_TYPE_NOR
    else
        self.roomType_ = ROOM_TYPE_PRO
    end
    
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

    local feedbackBtnSize = {
        width = 38,
        height = 28
    }

    self.feedbackBtn_ = cc.ui.UIPushButton.new({normal = "#hall_auxBtnFeedBack.png", pressed = "#hall_auxBtnFeedBack.png", disabled = "#hall_auxBtnFeedBack.png"},
        {scale9 = false})
        :onButtonClicked(buttontHandler(self, self.onFeedbackBtnCallBack_))
        :pos(divdLineRight1:getPositionX() - divdLineRight1:getContentSize().width / 2 - rightOprBtnMagrinEach - feedbackBtnSize.width / 2,
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

    -- Init defaultLeftTabIdx_ && RoomNorConfDataSet State Here-- 
    self.defaultLeftTabIdx_ = 1
    self.isRoomNorConfDataSet_ = false

    self.leftTabOprAreaNode_ = display.newNode()
        :addTo(self, 2)

    local tabPanelLeftSizeHAdj = 10
    local tabPanelLeftSize = cc.size(leftOprTabAreaPanelSizeCal.width, display.height - topOpreationPanelSizeCal.height + tabPanelLeftSizeHAdj)
    local tabOprPanelLeft = display.newScale9Sprite("#hall_auxBgPanel_left.png", - display.width / 2 + tabPanelLeftSize.width / 2,
        - (display.height / 2 - tabPanelLeftSize.height / 2), tabPanelLeftSize)
        :addTo(self.leftTabOprAreaNode_)

    local tabBtnIconImgKeysNor = {
        "#roomChos_roomTypeNor_unSel.png",
        "#roomChos_roomTypeCash_unSel.png",
        "#roomChos_roomTypePerson_unSel.png"
    }

    local tabBtnIdxLabel = {
        "普通场",
        "金币场",
        "私人场"
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

    self.roomChoseContPageNode_ = display.newNode()
        :pos(tabPanelLeftSize.width / 2, - topOpreationPanelSizeCal.height / 2)
        :addTo(self, 3)

    self.tabBtnGroupLeft:onButtonSelectChanged(handler(self, self.onLeftTabBtnSelChanged_))
    self.tabBtnGroupLeft:getButtonAtIndex(self.defaultLeftTabIdx_):setButtonSelected(true)

    self:addDataObservers()
end

function ChooseRoomView:renderRoomChosePageViews(pageIdx)
    -- body
    local drawRoomChoseMainContByTabIdx = {
        [1] = function()
            -- body
            local roomChoseNorPageCont = display.newNode()

            -- local testRoomChoseNorLabel = display.newTTFLabel({text = "This Is RoomChose Page Nor.", size = 24, align =
            --     ui.TEXT_ALIGN_CENTER})
            --     :addTo(roomChoseNorPageCont)

            local chipSkinColors = {
                cc.c3b(0x43, 0x8f, 0x86), 
                cc.c3b(0x36, 0x86, 0xaa), 
                cc.c3b(0x5a, 0x3b, 0x95), 
                cc.c3b(0x83, 0x3b, 0x95), 
                cc.c3b(0x91, 0x78, 0x2e), 
                cc.c3b(0x8b, 0x5b, 0x33),
                cc.c3b(0x8c, 0x37, 0x42),
                cc.c3b(0x74, 0x3c, 0x39)
            }

            self.roomChips_ = {}

            local tempTb = nk.getRoomDatasByLimitAndTab(ChooseRoomView.PLAYER_LIMIT_SELECTED, ChooseRoomView.ROOM_LEVEL_SELECTED)
            local roomChipSkin = nil
            local roomChipPreCallTextColor = nil

            for i = 1, #chipSkinColors do

                if tempTb[i] and tempTb[i].rType == 2 then
                    --todo
                    roomChipSkin = "#roomChos_roomCashChip.png"
                    roomChipPreCallTextColor = cc.c3b(155, 89, 0)

                elseif not tempTb[i] or tempTb[i].rType == 1 then
                    --todo
                    roomChipSkin = "#roomChos_roomNorChip_" .. i ..".png"
                    roomChipPreCallTextColor = chipSkinColors[i]
                end

                self.roomChips_[i] = ChooseRoomChip.new(roomChipSkin, roomChipPreCallTextColor)
                    :pos(((i - 1) % 4 - 1 - 1 / 2) * CHIP_HORIZONTAL_DISTANCE, (math.floor((8 - i) / 4) - 1) * CHIP_VERTICAL_DISTANCE + CHIP_VERTICAL_DISTANCE / 2)
                    :onChipClick(handler(self, self.onNormalRoomChipClick))
                    :addTo(roomChoseNorPageCont)
            end

            return roomChoseNorPageCont
        end,

        [2] = function()
            -- body
            local roomChoseCashPageCont = display.newNode()

            -- local testRoomChoseGrabLabel = display.newTTFLabel({text = "This Is RoomChose Page Cash.", size = 24, align = 
            --     ui.TEXT_ALIGN_CENTER})
            --     :addTo(roomChoseCashPageCont)

            local labelParam = {
                fontSize = 0,
                color = display.COLOR_WHITE
            }

            local cashRoomChoseInfoStrs = {
                "庄 家",
                "底 注",
                "MIN上庄值",
                "入场门槛",
                "在线人数"
            }

            local cashRoomChoseInfoLabelBorderHoriz = 24 * nk.widthScale
            local cashRoomChoseInfoLabelPaddingTop = 45

            labelParam.fontSize = 24
            labelParam.color = display.COLOR_WHITE

            local cashRoomChoseInfoLbl = nil

            local cashRoomChoseInfoLabelWidthSum = 0
            local cashRoomChoseInfoLabelPosY = display.height / 2 - TOPOPR_PANEL_HEIGHT / 2 - cashRoomChoseInfoLabelPaddingTop
            
            for i = 1, #cashRoomChoseInfoStrs do
                cashRoomChoseInfoLbl = display.newTTFLabel({text = cashRoomChoseInfoStrs[i], size = labelParam.fontSize, 
                    color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})

                cashRoomChoseInfoLbl:pos(- display.width / 2 + LEFTOPR_PANEL_WIDTH / 2 + cashRoomChoseInfoLabelWidthSum + cashRoomChoseInfoLabelBorderHoriz +
                    cashRoomChoseInfoLbl:getContentSize().width / 2, cashRoomChoseInfoLabelPosY)
                    :addTo(roomChoseCashPageCont)

                cashRoomChoseInfoLabelWidthSum = cashRoomChoseInfoLabelWidthSum + cashRoomChoseInfoLabelBorderHoriz * 2 + cashRoomChoseInfoLbl:getContentSize().width

                if i ~= #cashRoomChoseInfoStrs then
                    --todo
                    display.newSprite("#roomChos_roomInfoDivLine_vertical.png")
                        :pos(- display.width / 2 + LEFTOPR_PANEL_WIDTH / 2 + cashRoomChoseInfoLabelWidthSum, cashRoomChoseInfoLabelPosY)
                        :addTo(roomChoseCashPageCont)
                end
            end
            
            local cashRoomListViewRectMagrinBorder = 2

            local cashRoomListViewMagrinTop = 20
            local cashRoomListViewWidth = display.width - LEFTOPR_PANEL_WIDTH - cashRoomListViewRectMagrinBorder * 2
            local cashRoomListViewHeight = display.height - TOPOPR_PANEL_HEIGHT - cashRoomChoseInfoLabelPaddingTop - cashRoomListViewMagrinTop -
                cashRoomListViewRectMagrinBorder * 2

            local cashRoomListViewPosY = - 26
            local cashRoomListViewPosX = - 8
            self.cashRoomList_ = bm.ui.ListView.new({viewRect = cc.rect(- cashRoomListViewWidth * 0.5, - cashRoomListViewHeight * 0.5,
                cashRoomListViewWidth, cashRoomListViewHeight), direction = bm.ui.ListView.DIRECTION_VERTICAL,
                    upRefresh = handler(self, self.onCashRoomListUpRefresh_)}, ChooseProRoomListItem)
                :pos(cashRoomListViewPosX, cashRoomListViewPosY)
                :addTo(roomChoseCashPageCont)

            self.cashRoomList_:addEventListener("ITEM_EVENT", handler(self, self.onProRoomLogin_))
            -- self.cashRoomList_:setData({1, 2, 3, 4, 5, 6, 7, 8})

            labelParam.fontSize = 35
            labelParam.color = display.COLOR_RED
            self.cashRoomNotOpenTips_ = display.newTTFLabel({text = "暂未开放", size = labelParam.fontSize, color = labelParam.color, align =
                ui.TEXT_ALIGN_CENTER})
                :addTo(roomChoseCashPageCont)
                :hide()

            self.cashRoomDataLoadingBar_ = nk.ui.Juhua.new()
                :addTo(roomChoseCashPageCont)

            return roomChoseCashPageCont
        end,

        [3] = function()
            -- body
            local roomChosePersonalPageCont = display.newNode()

            -- local testRoomChoseCashLabel = display.newTTFLabel({text = "This Is RoomChose Page Personal.", size = 24, align =
            --     ui.TEXT_ALIGN_CENTER})
            --     :addTo(roomChosePersonalPageCont)

            local labelParam = {
                fontSize = 0,
                color = display.COLOR_WHITE
            }

            local personalRoomChooseInfoStrs = {
                "房间ID",
                "房间名称",
                "底注",
                "最小准入",
                "服务费",
                "密码",
                "房间人数"
            }

            local infoLabelBarMagrinExtra = 10 * nk.widthScale
            local infoLabelBorderHoriz = 12 * nk.widthScale
            local infolabelPaddingTop = 54

            labelParam.fontSize = 22
            labelParam.color = display.COLOR_WHITE

            local personRoomChooseInfoLbl = nil

            local personRoomChooseInfoLblWidthSum = 0
            local personRoomChooseInfoLblPosY = display.height / 2 - TOPOPR_PANEL_HEIGHT / 2 - infolabelPaddingTop

            for i = 1, #personalRoomChooseInfoStrs do
                personRoomChooseInfoLbl = display.newTTFLabel({text = personalRoomChooseInfoStrs[i], size = labelParam.fontSize, color = labelParam.color,
                    align = ui.TEXT_ALIGN_CENTER})

                personRoomChooseInfoLbl:pos(- display.width / 2 + LEFTOPR_PANEL_WIDTH / 2 + personRoomChooseInfoLblWidthSum + infoLabelBarMagrinExtra +
                    infoLabelBorderHoriz + personRoomChooseInfoLbl:getContentSize().width / 2, personRoomChooseInfoLblPosY)
                    :addTo(roomChosePersonalPageCont)

                personRoomChooseInfoLblWidthSum = personRoomChooseInfoLblWidthSum + infoLabelBorderHoriz * 2 + personRoomChooseInfoLbl:getContentSize().width

                if i ~= #personalRoomChooseInfoStrs then
                    --todo
                    display.newSprite("#roomChos_roomInfoDivLine_vertical.png")
                        :pos(- display.width / 2 + LEFTOPR_PANEL_WIDTH / 2 + personRoomChooseInfoLblWidthSum + infoLabelBarMagrinExtra, personRoomChooseInfoLblPosY)
                        :addTo(roomChosePersonalPageCont)
                end

            end

            local helpBtnSize = {
                width = 32,
                height = 32
            }

            local helpBtnMagrinRight = 8
            local helpBtnMagrinTopOprArea = - 5
            self.perRoomHelpBtn_ = cc.ui.UIPushButton.new({normal = "#roomChos_btnQMark.png", pressed = "#roomChos_btnQMark.png", disabled = "#roomChos_btnQMark.png"},
                {scale9 = false})
                :onButtonClicked(buttontHandler(self, self.onPerRoomHelpBtnCallBack_))
                :pos(display.width / 2 - LEFTOPR_PANEL_WIDTH / 2 - helpBtnMagrinRight - helpBtnSize.width / 2, display.height / 2 - TOPOPR_PANEL_HEIGHT / 2 -
                    helpBtnMagrinTopOprArea - helpBtnSize.height / 2)
                :addTo(roomChosePersonalPageCont)

            local bottomOprPanelModel = display.newSprite("#common_bgDentPanelBot.png")
            local bottomOprPanelSizeCal = bottomOprPanelModel:getContentSize()

            local botOprPanelStencil = {
                x = 15,
                y = 2,
                width = 94,
                height = 76
            }

            local bottomOprPanel = display.newScale9Sprite("#common_bgDentPanelBot.png", 0, - display.height / 2 + TOPOPR_PANEL_HEIGHT / 2 + bottomOprPanelSizeCal.height / 2,
                cc.size(display.width - LEFTOPR_PANEL_WIDTH, bottomOprPanelSizeCal.height), cc.rect(botOprPanelStencil.x, botOprPanelStencil.y, botOprPanelStencil.width,
                    botOprPanelStencil.height))
                :addTo(roomChosePersonalPageCont)

            local msgShownBorderMagrinLeft = 25

            local msgBorderSize = {
                width = 310,
                height = 42
            }

            local msgShownBorder = display.newScale9Sprite("#common_bgInputLayer.png", msgBorderSize.width / 2 + msgShownBorderMagrinLeft, bottomOprPanelSizeCal.height / 2,
                cc.size(msgBorderSize.width, msgBorderSize.height))
                :addTo(bottomOprPanel)

            -- local msgShownTest = display.newTTFLabel({text = "创建自己的房间邀请好友一起游戏", size = 18, align = ui.TEXT_ALIGN_CENTER})
            --     :pos(msgBorderSize.width / 2, msgBorderSize.height / 2)
            --     :addTo(msgShownBorder)

            -- Set TipsAnim Lbl Param --
            labelParam.fontSize = 20
            labelParam.color = display.COLOR_WHITE

            local tipsQueueAnimStencilGapMsgBorHoriz = 5
            local tipQueueAnimStencilGapMsgBorVert = 6

            local tipsQueueAnimContSize = cc.size(msgBorderSize.width - tipsQueueAnimStencilGapMsgBorHoriz * 2, msgBorderSize.height - tipQueueAnimStencilGapMsgBorVert * 2)

            local tipsStrCutHoldWHoriz = 2
            local tipsStrTab = bm.LangUtil.getText("HALL","PERSONAL_HALL_TIPS")
            local tipsAnimStrTab = {}
            for i = 1, #tipsStrTab do
               local tempTab =  nk.subStr2TbByWidth("", labelParam.fontSize, tipsStrTab[i], tipsQueueAnimContSize.width - tipsStrCutHoldWHoriz * 2)
               table.insertto(tipsAnimStrTab, tempTab)
            end
            
            self.tipsAnimQueue_ = AnimUpScrollQueue.new(tipsQueueAnimContSize, labelParam.fontSize, labelParam.color)
                :pos(msgBorderSize.width / 2, msgBorderSize.height / 2)
                :addTo(msgShownBorder)

            self.tipsAnimQueue_:setData(tipsAnimStrTab)
            self.tipsAnimQueue_:startAnim()

            local oprBtnSize = {
                width = 130,
                height = 46
            }

            local oprBtnsMagrinRight = 12
            local oprBtnsMagrinEach = 18

            labelParam.fontSize = 28
            labelParam.color = display.COLOR_WHITE

            local oprBtnLblStrs = {
                "创建房间",
                "扫码推荐",
                "邀请好友"
            }

            local oprBtnImgKeys = {
                "#common_btnGreenRigOutl.png",
                "#common_btnYellowRigOutl.png",
                "#common_btnYellowRigOutl.png",
            }

            local botOprBtnCallBacks = {
                buttontHandler(self, self.onBtnCreateRoomCallBack_),
                buttontHandler(self, self.onBtnQRCodeCallBack_),
                buttontHandler(self, self.onBtnInviteCallBack_)
            }

            self.botOprBtns_ = {}

            for i = 1, #oprBtnLblStrs do
                self.botOprBtns_[i] = cc.ui.UIPushButton.new({normal = oprBtnImgKeys[i], pressed = oprBtnImgKeys[i], disabled = "#common_btnGreyLitRigOut.png"},
                    {scale9 = true})
                    :setButtonSize(oprBtnSize.width, oprBtnSize.height)
                    :setButtonLabel(display.newTTFLabel({text = oprBtnLblStrs[i], size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
                    :onButtonClicked(botOprBtnCallBacks[i])
                    :pos(display.width - LEFTOPR_PANEL_WIDTH - ((2 * (3 - i) + 1) / 2 * oprBtnSize.width + oprBtnsMagrinRight + (3 - i) * oprBtnsMagrinEach),
                        bottomOprPanelSizeCal.height / 2)
                    :addTo(bottomOprPanel)
            end

            -- Set InviteBtn && CreateRoomBtn Unabled Default --
            local botOprBtnCreateRoomIdx = 1
            local botOprBtnInviteIdx = 3

            self.botOprBtns_[botOprBtnCreateRoomIdx]:setButtonEnabled(false)
            self.botOprBtns_[botOprBtnInviteIdx]:setButtonEnabled(false)

            local perRoomListViewRectMagrinBorder = 2

            local perRoomListViewMagrinTop = 20
            local perRoomListViewWidth = display.width - LEFTOPR_PANEL_WIDTH - perRoomListViewRectMagrinBorder * 2
            local perRoomListViewHeight = display.height - TOPOPR_PANEL_HEIGHT - infolabelPaddingTop - perRoomListViewMagrinTop - bottomOprPanelSizeCal.height -
                perRoomListViewRectMagrinBorder * 2

            local perRoomListViewPosY = 2
            local perRoomListViewPosX = - 8

            self.perRoomList_ = bm.ui.ListView.new({viewRect = cc.rect(- perRoomListViewWidth * 0.5, - perRoomListViewHeight * 0.5, perRoomListViewWidth,
                perRoomListViewHeight), direction = bm.ui.ListView.DIRECTION_VERTICAL, upRefresh = handler(self, self.onPersonalRoomListUpRefresh_)},
                    ChoosePersonRoomListItem)
                :pos(perRoomListViewPosX, perRoomListViewPosY)
                :addTo(roomChosePersonalPageCont)

            self.perRoomList_:addEventListener("ITEM_EVENT", handler(self, self.onPersonalRoomLogin_))
            -- self.perRoomList_:setData({1, 2, 3, 4, 5, 6, 7, 8})

            labelParam.fontSize = 35
            labelParam.color = display.COLOR_RED

            self.perRoomNotOpenTips_ = display.newTTFLabel({text = "暂未开放", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
                :addTo(roomChosePersonalPageCont)
                :hide()

            self.perRoomDataLoadingBar_ = nk.ui.Juhua.new()
                :addTo(roomChosePersonalPageCont)

            return roomChosePersonalPageCont
        end
    }

    self.roomChosePageViews_ = self.roomChosePageViews_ or {}

    for _, page in pairs(self.roomChosePageViews_) do
        if page then
            --todo
            page:hide()
        end
    end

    local page = self.roomChosePageViews_[pageIdx]

    if not page then
        --todo
        page = drawRoomChoseMainContByTabIdx[pageIdx]()
        self.roomChosePageViews_[pageIdx] = page
        page:addTo(self.roomChoseContPageNode_)
    end

    page:show()
end

function ChooseRoomView:refreshFirstChargeFavEntryUi(isOpen)
    -- body
    -- if not isOpen then
    --     --todo

    --     if self._firstChargeEntryBtn then
    --     --todo
    --         self._firstChargeEntryBtn:removeFromParent()
    --         self._firstChargeEntryBtn = nil

    --         display.newScale9Sprite("#top_btn_bg.png", 0, 0, cc.size(TOP_BUTTOM_WIDTH + 4, TOP_BUTTOM_HEIGHT + 4))
    --             :pos(display.cx - TOP_BUTTOM_WIDTH * 0.5 - TOP_BUTTOM_PADDING, display.cy - TOP_BUTTOM_HEIGHT * 0.5 - TOP_BUTTOM_PADDING)
    --             :addTo(self.topBtnNode_)

    --         display.newSprite("#top_store_btn_icon.png")
    --             :pos(display.cx - TOP_BUTTOM_WIDTH * 0.5 - TOP_BUTTOM_PADDING, display.cy - TOP_BUTTOM_HEIGHT * 0.5 - TOP_BUTTOM_PADDING)
    --             :addTo(self.topBtnNode_)

    --         cc.ui.UIPushButton.new({normal = "#common_modTransparent.png", pressed = "#rounded_rect_6.png"}, {scale9 = true})
    --             :setButtonSize(TOP_BUTTOM_WIDTH, TOP_BUTTOM_HEIGHT)
    --             :pos(display.cx - TOP_BUTTOM_WIDTH * 0.5 - TOP_BUTTOM_PADDING, display.cy - TOP_BUTTOM_HEIGHT * 0.5 - TOP_BUTTOM_PADDING)
    --             :addTo(self.topBtnNode_)
    --             :onButtonClicked(buttontHandler(self, self.onStoreClick_))
    --     end
    -- end
end

function ChooseRoomView:playSuonaMsgScrolling(suonaMsg)
    -- body
    if not self.suonaMsgPlaying_ then
        --todo
        self:playSuonaMsgNext()
    end
end

function ChooseRoomView:playSuonaMsgNext()
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

function ChooseRoomView:onAvatarLoadComplete_(success, sprite)
    -- body
    if success then
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

function ChooseRoomView:playShowAnim()
    -- local animTime = self.controller_.getAnimTime()
    -- -- 桌子
    -- transition.moveTo(self.pokerTable_, {time = animTime, y = 0})
    -- -- icon
    -- transition.moveTo(self.roomTypeIcon_, {time = animTime, x = -display.cx, delay = animTime})
    -- -- 分割线
    -- transition.fadeIn(self.splitLine_, {time = animTime, opacity = 255, delay = animTime})
    -- -- 在线人数
    -- transition.fadeIn(self.userOnline_, {time = animTime, opacity = 255, delay = animTime})
    -- -- 顶部操作区
    -- transition.moveTo(self.topBtnNode_, {time = animTime, y = 0, delay = animTime})
    -- -- 筹码
    -- for i, chip in ipairs(self.chips_) do
    --     transition.moveTo(chip, {
    --         time = animTime, 
    --         y = (math.floor((6 - i) / 3) - 1) * CHIP_VERTICAL_DISTANCE + 40 * nk.heightScale, 
    --         delay = animTime + 0.05 * ((i <= 3 and i or (i - 3)) - 1),     
    --         easing = "BACKOUT"
    --     })
    -- end
end

function ChooseRoomView:playHideAnim()
    self:removeFromParent()
end

function ChooseRoomView:onReturnBtnCallBack_(evt)
    self.return2HallBtn_:setButtonEnabled(false)
    self.controller_:showMainHallView()
end

function ChooseRoomView:onGetChipBtnCallBack_(evt)
    -- body
    nk.DReport:report({id = "openStoreClick"})
    StorePopup.new():showPanel()
end

function ChooseRoomView:onGetCashBtnCallBack_(evt)
    -- body
    nk.DReport:report({id = "openStoreClick"})

    local cashTabIndx = 2
    StorePopup.new(cashTabIndx):showPanel()
end

function ChooseRoomView:onExchangeBtnCallBack_(evt)
    self.exchangeBtn_:setButtonEnabled(false)
    local excMarketView = ExcMarketView.new(self.controller_):showPanel()
    excMarketView:setParentView(self)

    self.exchangeBtn_:setButtonEnabled(true)
end

function ChooseRoomView:onFeedbackBtnCallBack_(evt)
    -- body
    self.feedbackBtn_:setButtonEnabled(false)

    HelpPopup.new(false, true, 1):showPanel()
    self.feedbackBtn_:setButtonEnabled(true)
end

-- Release Note If Func Needed --
function ChooseRoomView:onSuonaSendBtnCallBack_(evt)
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

function ChooseRoomView:onSearchClick_(evt)
    HallSearchRoomPanel.new(self.controller_, handler(self, self.onSearchPanelCallback)):showPanel()
end

function ChooseRoomView:onStoreClick_(evt)
    StorePopup.new():showPanel()
end

function ChooseRoomView:_onChargeFavCallBack(evt)
    -- body

    local shownScene = 1
    local isThirdPayOpen = true
    local isFirstCharge = true
    local payBillType = nil

    if nk.OnOff:check("firstchargeFavGray") then
        --todo
        FirChargePayGuidePopup.new():showPanel()
    else
        local params = {}

        params.isOpenThrPartyPay = isThirdPayOpen
        params.isFirstCharge = isFirstCharge
        params.sceneType = shownScene
        params.payListType = payBillType

        PayGuide.new(params):show()
    end
end

function ChooseRoomView:onLeftTabBtnSelChanged_(evt)
    -- body
    local tabBtnIconImgKeys = {
        {nor = "roomChos_roomTypeNor_unSel.png", sel = "roomChos_roomTypeNor_sel.png"},
        {nor = "roomChos_roomTypeCash_unSel.png", sel = "roomChos_roomTypeCash_sel.png"},
        {nor = "roomChos_roomTypePerson_unSel.png", sel = "roomChos_roomTypePerson_sel.png"}
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

    nk.userData.DEFAULT_TAB = self.selectedIdx_
    self:renderRoomChosePageViews(self.selectedIdx_)

    self:getRoomChoseData()
end

function ChooseRoomView:onPerRoomHelpBtnCallBack_(evt)
    -- body
    self.perRoomHelpBtn_:setButtonEnabled(false)
    PerRoomHelpPopup.new():showPanel()
    
    self.perRoomHelpBtn_:setButtonEnabled(true)
end

function ChooseRoomView:onBtnCreateRoomCallBack_(evt)
    -- body
    CreatePerRoomPopup.new():showPanel()
end

function ChooseRoomView:onBtnQRCodeCallBack_(evt)
    -- body
    QRCodePopup.new():showPanel()
end

function ChooseRoomView:onBtnInviteCallBack_(evt)
    -- body
    InvitePopup.new():show()
end

function ChooseRoomView:onNormalRoomChipClick(preCall)
    -- body
    local playerCap = 9
    if ChooseRoomView.PLAYER_LIMIT_SELECTED == 2 then
        playerCap = 5
    end
    
    self.controller_:getEnterRoomData({tt = self.roomType_, sb = preCall, pc = playerCap})
end

-- Unite GrabRoom && CashRoom Entry To One Func --
function ChooseRoomView:onProRoomLogin_(evt)
    -- body
    bm.EventCenter:dispatchEvent({name = nk.eventNames.ENTER_GRAB_DEALER_ROOM, data = evt.data})
end

function ChooseRoomView:onPersonalRoomLogin_(evt)
    -- body
    local isCanLoginIn = self:isCanLoginPersonalRoom(evt.data)

    if not isCanLoginIn then
        --todo
        dump("Cant Login Personal Room Due To Thre Not Meet.")
        return
    end

    if checkint(evt.data.hasPwd) == 1 then
        --todo
        -- Need PswCode Input --
        PswEntryPopup.new(evt.data, handler(self, self.onPerRoomPswVerfyCallback)):showPanel()
    else
        nk.server:loginPersonalRoom(nil, evt.data.tableID)
    end
end

function ChooseRoomView:onCreatePersonalRoom(data)
    -- body
    local ret = data.ret
    if ret == 0 then
        nk.server:loginPersonalRoom(nil, data.tableID, (data.hasPwd == 1 and data.pwd or nil))
    end
end

function ChooseRoomView:onSearchPanelCallback(roomId)
    local roomData = {}
    roomData.roomid = roomId
    bm.EventCenter:dispatchEvent({name = nk.eventNames.ENTER_ROOM_WITH_DATA, data = roomData})
end

function ChooseRoomView:onPerRoomPswVerfyCallback(psw, roomData)
    -- body
    if not psw or not roomData then
        return
    end

    nk.server:loginPersonalRoom(nil, roomData.tableID, psw)
end

function ChooseRoomView:addDataObservers()
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

    -- self.onChargeFavOnOffObserver = bm.DataProxy:addDataObserver(nk.dataKeys.CHARGEFAV_ONOFF, handler(self, self.refreshFirstChargeFavEntryUi))
end

function ChooseRoomView:getRoomChoseData()
    -- body
    local getRoomChoseDataByTabIdx = {
        [1] = function()
            -- body
            self.controller_:getPlayerCountData(self.roomType_)

            if self.isRoomNorConfDataSet_ then
                --todo
                return
            end

            local tableConf = bm.DataProxy:getData(nk.dataKeys.TABLE_CONF)
            local tabConfLimt = tableConf[ChooseRoomView.PLAYER_LIMIT_SELECTED]

            -- dump(tableConf, "tableConf :====================", 8)

            if not tabConfLimt then
                --todo
                return
            end

            local preCalls = {}

            for i, v in ipairs(tabConfLimt) do
                for j, roomConf in ipairs(v) do
                    table.insert(preCalls, roomConf)
                end
            end

            -- dump(preCalls, "preCalls :=====================")
            local tempTb = nk.getRoomDatasByLimitAndTab(ChooseRoomView.PLAYER_LIMIT_SELECTED, ChooseRoomView.ROOM_LEVEL_SELECTED)

            for i, chip in ipairs(self.roomChips_) do
                if preCalls[i] then
                    chip:show()
                    chip:setPreCall(preCalls[i])

                    if tempTb[i] and tempTb[i].rType == 2 then
                        --todo
                        chip:setRoomTypeCash(true)
                    end
                else
                    chip:hide()
                end
            end

            self.isRoomNorConfDataSet_ = true
        end,

        [2] = function()
            -- body
            -- self.cashCurPage = 0
            -- self.cashTotalPage = 1

            -- self:reqCashRoomListData()

            if not self.cashRoomDataList_ then
                --todo
                self.cashCurPage = 0
                self.cashTotalPage = 1

                self:reqCashRoomListData()
            end
        end,

        [3] = function()
            -- body
            -- Update  JIT, Always Get PerRoomListData --
            self.perCurPage = 0
            self.perTotalPage = 1

            self:reqPersonalRoomListData()

            -- if not self.perRoomDataList_ then
            --     --todo
            --     self.cashCurPage = 0
            --     self.cashTotalPage = 1

            --     self:reqPersonalRoomListData()
            -- end
        end
    }

    getRoomChoseDataByTabIdx[self.selectedIdx_]()
end

function ChooseRoomView:reqCashRoomListData()
    -- body
    if nk.OnOff:check("cashRoom") then
        --todo
        self:reqCashRoomListDataByPage()
    else
        if self.cashRoomDataLoadingBar_ then
            --todo
            self.cashRoomDataLoadingBar_:removeSelf()
            self.cashRoomDataLoadingBar_ = nil
        end

        if self.cashRoomNotOpenTips_ then
            --todo
            self.cashRoomNotOpenTips_:show()
            self.cashRoomNotOpenTips_:setString("暂未开放")
        end
    end
end

function ChooseRoomView:reqPersonalRoomListData()
    -- body
    local botOprBtnCreateRoomIdx = 1
    local botOprBtnInviteIdx = 3

    if nk.OnOff:check("privateroom") then
        --todo
        self:reqPersonalRoomListDataByPage()

        self.botOprBtns_[botOprBtnCreateRoomIdx]:setButtonEnabled(true)
        self.botOprBtns_[botOprBtnInviteIdx]:setButtonEnabled(true)
    else
        if self.perRoomNotOpenTips_ then
            --todo
            self.perRoomNotOpenTips_:show()
            self.perRoomNotOpenTips_:setString("暂未开放")
        end

        self.botOprBtns_[botOprBtnCreateRoomIdx]:setButtonEnabled(false)
        self.botOprBtns_[botOprBtnInviteIdx]:setButtonEnabled(false)
    end
end

function ChooseRoomView:reqCashRoomListDataByPage()
    -- body
    if self.cashCurPage >= self.cashTotalPage then
        --todo
        dump("No CashRoom Data!")
        return
    end

    self.cashCurPage = self.cashCurPage + 1

    local cashRoomListDataReqParam = {
        roomType = 1, -- 0 :Type GrabRoom Data 1 :Type CashRoom Data 2 :Remix
        pageItemNum = 20
    }

    nk.server:requestGrabRoomList(cashRoomListDataReqParam.roomType, self.cashCurPage, cashRoomListDataReqParam.pageItemNum)
end

function ChooseRoomView:reqPersonalRoomListDataByPage()
    -- body
    if self.perCurPage >= self.perTotalPage then
        --todo
        dump("No PersonalRoom Data!")
        return
    end

    self.perCurPage = self.perCurPage + 1

    local reqPersonalRoomDataItemNum = 50
    nk.server:getPersonalRoomList(nil, self.perCurPage, reqPersonalRoomDataItemNum)
end

function ChooseRoomView:onCashRoomListUpRefresh_()
    -- body
    if nk.OnOff:check("cashRoom") then
        --todo
        self:reqCashRoomListDataByPage()
    else
        dump("cashRoom OnOff Close!")
    end
end

function ChooseRoomView:onPersonalRoomListUpRefresh_()
    -- body
    if nk.OnOff:check("privateroom") then
        --todo
        self:reqPersonalRoomListDataByPage()
    else
        dump("privateroom OnOff Close!")
    end
end

function ChooseRoomView:sortCashRoomDataList(tb)
    -- body
    table.sort(tb, function(t1, t2)
        if t1.basechip > t2.basechip then
            return true
        elseif t1.basechip == t2.basechip then
            if t1.userCount > t2.userCount then
                return true
            elseif t1.userCount == t2.userCount then
                if t1.ante > t2.ante then
                    return true
                else
                    return false
                end
            else
                return false
            end
        else
            return false
        end
    end)
end

function ChooseRoomView:isCanLoginPersonalRoom(roomData)
    -- body
    local roomDataFliter = {}
    roomDataFliter.blind = roomData.baseAnte
    roomDataFliter.minBuyIn = roomData.minAnte
    roomDataFliter.maxBuyIn = roomData.maxAnte

    local isSuccLoginRoom = PayGuidePopMgr.new(roomDataFliter):show()

    return isSuccLoginRoom
end

function ChooseRoomView:onGetPlayerCountData(data, field)
    -- dump(data, "ChooseRoomView:onGetPlayerCountData.data :==============")

    self.ninePlayerCounts_ = data[1]
    self.fivePlayerCounts_ = data[2]

    local playerCounts = nil
    -- local totalPlayer = 0

    if ChooseRoomView.PLAYER_LIMIT_SELECTED == 1 then
        playerCounts = self.ninePlayerCounts_
    elseif ChooseRoomView.PLAYER_LIMIT_SELECTED == 2 then
        playerCounts = self.fivePlayerCounts_
    end
    
    local playerOlineDataList = {}
    for i, v in pairs(playerCounts) do
        -- dump(v, "v :==================")
        for j, roomOnlineData in pairs(v) do
            -- dump(roomOnlineData, "roomOnlineData :====================")
            playerOlineDataList[j] = roomOnlineData
        end
    end

    for i, chip in ipairs(self.roomChips_) do        
        local chipVal = chip:getValue()        
        if playerOlineDataList and playerOlineDataList[chipVal] then
            chip:setPlayerCount(playerOlineDataList[chipVal])
            -- totalPlayer = totalPlayer + playerOlineDataList[chipVal]
        else
            chip:setPlayerCount(0)
        end
    end

    -- self.userOnline_:setString(bm.LangUtil.getText("HALL", "USER_ONLINE", totalPlayer))
end

function ChooseRoomView:onSetGrabRoomList(data)
    -- dump(data, "ChooseRoomView:onSetGrabRoomList.data :=============")

    if data and #data.roomlist > 0 then
        --todo
        if self and self.cashRoomNotOpenTips_ then
            --todo
            self.cashRoomNotOpenTips_:hide()
        end

        self.cashCurPage = data.cur_pages or 0
        self.cashTotalPage = data.total_pages or 1

        local desRoomTableList = {}
        local emptyRoomTable = {}
        local unEmptyRoomTable = {}

        for _, v in pairs(data.roomlist) do
            if v.userCount > 0  then
                table.insert(unEmptyRoomTable, v)
            else
                table.insert(emptyRoomTable, v)
            end
        end

        self:sortCashRoomDataList(unEmptyRoomTable)
        self:sortCashRoomDataList(emptyRoomTable)

        table.insertto(desRoomTableList, unEmptyRoomTable)
        table.insertto(desRoomTableList, emptyRoomTable)

        if not self.cashRoomDataList_ then
            --todo
            self.cashRoomDataList_ = {}
        end

        local tmpRoomTableList = {}
        local count = 0
        local newRoomTableIdx = nil
        local oldRoomTableIdx = nil

        for _, newTab in pairs(desRoomTableList) do
            count = 0
            newRoomTableIdx = tonumber(newTab.tableId) or - 1
            for __, oldTab in pairs(self.cashRoomDataList_) do
                oldRoomTableIdx = tonumber(oldTab.tableId) or - 1

                if (oldRoomTableIdx ~= - 1 and newRoomTableIdx ~= - 1 ) and (oldRoomTableIdx == newRoomTableIdx) then
                    break
                end

                count = count + 1
            end

            if count == #self.cashRoomDataList_ then
                table.insert(tmpRoomTableList, newTab)
            end
        end

        table.insertto(self.cashRoomDataList_, tmpRoomTableList)

        -- dump(self.cashRoomDataList_, "self.cashRoomDataList_ :================")

        if self and self.cashRoomDataLoadingBar_ then
            --todo
            self.cashRoomDataLoadingBar_:removeSelf()
            self.cashRoomDataLoadingBar_ = nil
        end

        if self.cashRoomList_ then
            --todo
            self.cashRoomList_:setData(self.cashRoomDataList_)
        end
    else
        if self and self.cashRoomDataLoadingBar_ then
            --todo
            self.cashRoomDataLoadingBar_:removeSelf()
            self.cashRoomDataLoadingBar_ = nil
        end

        if self and self.cashRoomNotOpenTips_ then
            --todo
            self.cashRoomNotOpenTips_:show()
            self.cashRoomNotOpenTips_:setString("暂未有房间")
        end
    end
end

function ChooseRoomView:onSetPersonalRoomList(data)
    -- body
    if data and #data.roomlist > 0 then
        --todo
        if self and self.perRoomNotOpenTips_ then
            --todo
            self.perRoomNotOpenTips_:hide()
        end

        self.perCurPage = data.cur_pages or 0
        self.perTotalPage = data.total_pages or 1

        if not self.perRoomDataList_ then
            --todo
            self.perRoomDataList_ = {}
        end

        local tmpDataListTab = {}
        local count = 0

        for _, v in pairs(data.roomlist) do
            count = 0

            for __, vv in pairs(self.perRoomDataList_) do

                if vv.tableID == v.tableID then
                    break
                end

                count = count + 1
            end

            if count == #self.perRoomDataList_ then
                table.insert(tmpDataListTab, v)
            end
        end

        table.insertto(self.perRoomDataList_, tmpDataListTab)

        -- dump(self.perRoomDataList_, "self.perRoomDataList_ :===================")
        if self and self.perRoomDataLoadingBar_ then
            --todo
            self.perRoomDataLoadingBar_:removeSelf()
            self.perRoomDataLoadingBar_ = nil
        end

        if self.perRoomList_ then
            --todo
            self.perRoomList_:setData(self.perRoomDataList_)
            -- self.perRoomList_:appendData(tmpDataListTab)
        end
    else
        if self and self.perRoomDataLoadingBar_ then
            --todo
            self.perRoomDataLoadingBar_:removeSelf()
            self.perRoomDataLoadingBar_ = nil
        end

        if self and self.perRoomNotOpenTips_ then
            --todo
            self.perRoomNotOpenTips_:show()
            self.perRoomNotOpenTips_:setString("暂未有房间")
        end
    end
end

function ChooseRoomView:onExit()
    -- body
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.micon", self.avatarUrlObserverHandle_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.name", self.nickObserverHandle_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.exp", self.experienceObserverHandle_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.money", self.moneyObserverHandle_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "match.point", self.cashNumChangeObserverHandler_)

    -- bm.DataProxy:removeDataObserver(nk.dataKeys.CHARGEFAV_ONOFF, self.onChargeFavOnOffObserver)

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

    if self.tipsAnimQueue_ then
        --todo
        self.tipsAnimQueue_:stopAnim()
    end
end

function ChooseRoomView:onCleanup()
end

return ChooseRoomView