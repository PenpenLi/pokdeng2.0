--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-03-09 19:35:17
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: ChooseMatchRoomView.lua Reconstructed By Tsing7x.
--

local StorePopup = import("app.module.store.StorePopup")
local HelpPopup_1 = import("app.module.match.views.MatchRoomChooseHelpPopup")
local HelpPopup_2 = import("app.module.settingHelp.SettingHelpPopupMgr")
local PayGuide = import("app.module.store.purchGuide.PayGuide")
local FirChargePayGuidePopup = import("app.module.store.firChrgGuide.FirChrgPayGuidePopup")
local ExcMarketView = import("app.module.exchgMarket.ExcMarketView")
local AuctionMarketPopup = import("app.module.auctionmarket.AuctionMarketPopup")
local MatchNormalRegisterPopup = import("app.module.match.views.MatchNormalRegisterPopup")
local MatchTimeRegisterPopup = import("app.module.match.views.MatchTimeRegisterPopup")
local SuonaUsePopup = import("app.module.suona.SuonaUsePopup")
local LoadMatchControlEx = import("app.module.match.LoadMatchControlEx")

local MatchRoomChooseChip = import(".ChooseMatchRoomChip")
local HallSearchRoomPanel = import(".views.HallSearchRoomPanel")

local MATCH_TYPE_HOT = 1
local MATCH_TYPE_NOR = 2
local AVATAR_TAG = 100

local TOPOPR_PANEL_HEIGHT = 0
local LEFTOPR_PANEL_WIDTH = 0

local ChooseMatchRoomView = class("ChooseMatchRoomView", function ()
    return display.newNode()
end)

ChooseMatchRoomView.PLAYER_LIMIT_SELECTED = 1 -- 1：9人场；2：5人场
ChooseMatchRoomView.ROOM_LEVEL_SELECTED   = nil -- 1：初级场；2：中级场；3：高级场
-- ChooseMatchRoomView.MATCH_TYPE_TIME = 1
-- ChooseMatchRoomView.MATCH_TYPE_NORMAL = 2
-- ChooseMatchRoomView.MATCH_TYPE_SELECTED = nil

function ChooseMatchRoomView:ctor(controller, viewType)
    self.controller_ = controller
    self.controller_:setDisplayView(self)

    self:setNodeEventEnabled(true)

    -- dump("viewType :" .. viewType)
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

    self.settingBtn_ = cc.ui.UIPushButton.new({normal = "#hall_btnMoreSet_nor.png", pressed = "#hall_btnMoreSet_pre.png", disabled = "#hall_btnMoreSet_nor.png"},
        {scale9 = false})
        :onButtonClicked(buttontHandler(self, self.onSettingBtnCallBack_))
        :pos(display.width - rightOprBtnMagrinEach - setBtnSize.width / 2, gameCurrencyChipDent:getPositionY())
        :addTo(self.topOpreationPanel_)

    -- local divdLine1PosAdj = {
    --     x = 0,
    --     y = 0
    -- }

    -- local divdLineRight1 = display.newSprite("#hall_divLine_topPanel.png")
    -- divdLineRight1:pos(self.settingBtn_:getPositionX() - setBtnSize.width / 2 - rightOprBtnMagrinEach - divdLineRight1:getContentSize().width / 2,
    --     self.settingBtn_:getPositionY() - divdLine1PosAdj.y)
    --     :addTo(self.topOpreationPanel_, 1, DIVID_LINE_RIGHT1_TAG)

    -- local friendMsgBtnSize = {
    --     width = 38,
    --     height = 28
    -- }

    -- self.friendMsgBtn_ = cc.ui.UIPushButton.new({normal = "#hall_btnMailMsg_nor.png", pressed = "#hall_btnMailMsg_pre.png", disabled = "#hall_btnMailMsg_nor.png"},
    --     {scale9 = false})
    --     :onButtonClicked(buttontHandler(self, self.onMailMsgBtnCallBack_))
    --     :pos(divdLineRight1:getPositionX() - divdLineRight1:getContentSize().width / 2 - rightOprBtnMagrinEach - mailMsgBtnSize.width / 2,
    --         self.settingBtn_:getPositionY())
    --     :addTo(self.topOpreationPanel_)

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

    -- Init defaultLeftTabIdx_ && MatchConfLoaded State Here-- 
    self.defaultLeftTabIdx_ = 1
    self.matchConfLoadedSucc_ = false

    self.leftTabOprAreaNode_ = display.newNode()
        :addTo(self, 2)

    local tabPanelLeftSizeHAdj = 10
    local tabPanelLeftSize = cc.size(leftOprTabAreaPanelSizeCal.width, display.height - topOpreationPanelSizeCal.height + tabPanelLeftSizeHAdj)
    local tabOprPanelLeft = display.newScale9Sprite("#hall_auxBgPanel_left.png", - display.width / 2 + tabPanelLeftSize.width / 2,
        - (display.height / 2 - tabPanelLeftSize.height / 2), tabPanelLeftSize)
        :addTo(self.leftTabOprAreaNode_)

    local tabBtnIconImgKeysNor = {
        "#roomChos_matchTypeHot_unSel.png",
        "#roomChos_matchTypeNor_unSel.png",
    }

    local tabBtnIdxLabel = {
        "热门赛",
        "常规赛"
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

    self:renderMatchRoomChoseContViews()

    self:addDataObservers()

    self.tabBtnGroupLeft:onButtonSelectChanged(handler(self, self.onLeftTabBtnSelChanged_))
    self.tabBtnGroupLeft:getButtonAtIndex(self.defaultLeftTabIdx_):setButtonSelected(true)

    nk.MatchConfigEx:loadConfig(nil, handler(self, self.onLoadMatchConfig))
end

function ChooseMatchRoomView:renderMatchRoomChoseContViews()
    -- body
    local roomChoseListViewMagrinHoriz = 12 * nk.widthScale
    local roomChoseChipGapVertListItem = 26

    local roomChoseListViewPosYOffSet = 35

    local roomChoseItemBgModel = display.newSprite("#roomChos_roomMatchBgItem.png")
    local roomChoseItemBgSizeCal = roomChoseItemBgModel:getContentSize()

    local roomChoseListWidth = display.width - LEFTOPR_PANEL_WIDTH - roomChoseListViewMagrinHoriz * 2
    local roomChoseListHeight = roomChoseItemBgSizeCal.height + roomChoseChipGapVertListItem * 2

    self.matchRoomChoseList_ = bm.ui.ListView.new({viewRect = cc.rect(- roomChoseListWidth * 0.5, - roomChoseListHeight * 0.5,
        roomChoseListWidth, roomChoseListHeight), direction = bm.ui.ListView.DIRECTION_HORIZONTAL}, MatchRoomChooseChip)
        :pos(0, roomChoseListViewPosYOffSet)
        :addTo(self.roomChoseContPageNode_)

    self.matchRoomChoseList_:addEventListener("ITEM_EVENT", handler(self, self.onParticMatch_))
    -- self.matchRoomChoseList_:setData({1, 2, 3})

    -- {
    --     -- local drawMatchRoomChosePageContByTabIdx = {
    --     --     [1] = function()
    --     --         -- body
    --     --         local roomChosePageHotCont = display.newNode()

    --     --         -- local testRoomChoseHotLabel = display.newTTFLabel({text = "This Is MatchRoomChose Page Hot.", size = 24, align = ui.TEXT_ALIGN_CENTER})
    --     --         --     :addTo(roomChosePageHotCont)

    --     --         self.matchHotRoomList_ = bm.ui.ListView.new({viewRect = cc.rect(- cashRoomListViewWidth * 0.5, - cashRoomListViewHeight * 0.5,
    --     --             cashRoomListViewWidth, cashRoomListViewHeight), direction = bm.ui.ListView.DIRECTION_VERTICAL)

    --     --         return roomChosePageHotCont
    --     --     end,

    --     --     [2] = function()
    --     --         -- body
    --     --         local roomChosePageNorCont = display.newNode()

    --     --         -- local testRoomChoseNorLabel = display.newTTFLabel({text = "This Is MatchRoomChose Page Nor.", size = 24, align = ui.TEXT_ALIGN_CENTER})
    --     --         --     :addTo(roomChosePageNorCont)

    --     --         -- self.matchNorRoomList_ = bm.ui.ListView.new({viewRect = cc.rect(- cashRoomListViewWidth * 0.5, - cashRoomListViewHeight * 0.5,
    --     --         --     cashRoomListViewWidth, cashRoomListViewHeight), direction = bm.ui.ListView.DIRECTION_VERTICAL)

    --     --         return roomChosePageNorCont
    --     --     end
    --     -- }

    --     -- self.matchRoomChosePageViews_ = self.matchRoomChosePageViews_ or {}

    --     -- for _, page in pairs(self.matchRoomChosePageViews_) do
    --     --     if page then
    --     --         --todo
    --     --         page:hide()
    --     --     end
    --     -- end

    --     -- local page = self.matchRoomChosePageViews_[pageIdx]

    --     -- if not page then
    --     --     --todo
    --     --     page = drawMatchRoomChosePageContByTabIdx[pageIdx]()
    --     --     self.matchRoomChosePageViews_[pageIdx] = page
    --     --     page:addTo(self.roomChoseContPageNode_)
    --     -- end

    --     -- page:show()
    -- }
end

function ChooseMatchRoomView:playSuonaMsgScrolling()
    -- body
    if not self.suonaMsgPlaying_ then
        --todo
        self:playSuonaMsgNext()
    end
end

function ChooseMatchRoomView:playSuonaMsgNext()
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
end

function ChooseMatchRoomView:playShowAnim()
    
    -- local animTime = self.controller_.getAnimTime()
    -- -- 桌子
    -- transition.moveTo(self.pokerTable_, {time = animTime, y = 0})
    -- -- icon
    -- transition.moveTo(self.roomTypeIcon_, {time = animTime, x = -display.cx, delay = animTime})
    -- -- 分割线
    -- transition.fadeIn(self.splitLine_, {time = animTime, opacity = 255, delay = animTime})
    -- -- 在线人数
    -- -- transition.fadeIn(self.userOnline_, {time = animTime, opacity = 255, delay = animTime})
    -- -- 顶部操作区
    -- transition.moveTo(self.topBtnNode_, {time = animTime, y = 0, delay = animTime})
    -- -- 筹码


    -- local lastSelected = ChooseMatchRoomView.MATCH_TYPE_SELECTED

    -- dump(lastSelected,"playShowAnim")
    -- if selectedTab == ChooseMatchRoomView.MATCH_TYPE_TIME then
    --     -- transition.fadeIn(self.timeMatchListNode_, {time = animTime, opacity = 255, delay = animTime*5})
    -- elseif selectedTab == ChooseMatchRoomView.MATCH_TYPE_NORMAL then
    --     -- transition.fadeIn(self.normalMatchListNode_, {time = animTime, opacity = 255, delay = animTime*5})
    -- elseif selectedTab == ChooseMatchRoomView.MATCH_TYPE_OTHER then

    -- end
end

function ChooseMatchRoomView:playHideAnim()
    self:removeFromParent()
end

function ChooseMatchRoomView:onAvatarLoadComplete_(success, sprite)
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

function ChooseMatchRoomView:onLeftTabBtnSelChanged_(evt)
    -- body
    local tabBtnIconImgKeys = {
        {nor = "roomChos_matchTypeHot_unSel.png", sel = "roomChos_matchTypeHot_sel.png"},
        {nor = "roomChos_matchTypeNor_unSel.png", sel = "roomChos_matchTypeNor_sel.png"}
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

    if self.matchConfLoadedSucc_ then
        --todo
        self:getMatchRoomChoseData()
    end
end

function ChooseMatchRoomView:onReturnBtnCallBack_(evt)
    -- body
    self.controller_:showMainHallView()
end

function ChooseMatchRoomView:onGetChipBtnCallBack_(evt)
    -- body
    nk.DReport:report({id = "openStoreClick"})
    StorePopup.new():showPanel()
end

function ChooseMatchRoomView:onGetCashBtnCallBack_(evt)
    -- body
    nk.DReport:report({id = "openStoreClick"})

    local cashTabIndx = 2
    StorePopup.new(cashTabIndx):showPanel()
end

function ChooseMatchRoomView:onSettingBtnCallBack_(evt)
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

    HelpPopup_2.new(false, true, 2):showPanel()
end

function ChooseMatchRoomView:onSuonaSendBtnCallBack_(evt)
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

function ChooseMatchRoomView:onFeedbackBtnCallBack_()
    HelpPopup_2.new(false, true,1):show()
end

function ChooseMatchRoomView:onExcMarektBtnCallBack_()
    local excMarketView = ExcMarketView.new(self.controller_):showPanel()
    excMarketView:setParentView(self)
end

function ChooseMatchRoomView:onAuctionMarketBtnCallBack_()
    -- body
    AuctionMarketPopup.new():showPanel_()
end

function ChooseMatchRoomView:onSearchPanelCallback(roomId)
    local roomData = {}
    roomData.roomid = roomId
    bm.EventCenter:dispatchEvent({name = nk.eventNames.ENTER_ROOM_WITH_DATA, data = roomData})
end

function ChooseMatchRoomView:onMatchNorParticIn(evt)
	local matchBaseInfo = evt.data

	if matchBaseInfo then
		if tonumber(matchBaseInfo.open) == 0 then
	         nk.TopTipManager:showTopTip(bm.LangUtil.getText("HALL", "NOTOPEN"))
	    else

            MatchNormalRegisterPopup.new(matchBaseInfo):show()

	        -- local repArgs = {
	        --     eventId = "onMatchClipClick_",
	        --     attributes = "id," .. matchBaseInfo.id or -1,
	        --     counter = 1
	        -- }
	        -- self:reportUmeng_("eventCustom",repArgs)
	    end
	end
end

function ChooseMatchRoomView:onMatchHotParticIn(evt)
    MatchTimeRegisterPopup.new(evt.data, handler(self, self.onTimeRegisterCallback)):show()
end

function ChooseMatchRoomView:onTimeRegisterCallback(matchData)
    -- dump(matchData, "ChooseMatchRoomView:onTimeRegisterCallback.matchData :================")
    if self.matchHotDatas_ then
        for i,v in ipairs(self.matchHotDatas_) do

            if v.id == matchData.id and v.mtime.timestamp == matchData.time then
                --是否已报名标识
                v.isReg = true

                if self.selectedIdx_ == MATCH_TYPE_HOT then
                    --todo
                    if self.matchRoomChoseList_ then
                        self.matchRoomChoseList_:updateData(i, v)
                    end
                end
            end
        end

        self:getMatchHotPlayerCountData(self.matchHotDatas_)
    end
end

function ChooseMatchRoomView:onParticMatch_(evt)
    -- body
    if self.selectedIdx_ == MATCH_TYPE_HOT then
        --todo
        self:onMatchHotParticIn(evt)
    elseif self.selectedIdx_ == MATCH_TYPE_NOR then
        --todo
        self:onMatchNorParticIn(evt)
    else
        dump("Wrong TabIdx!")
    end

end

function ChooseMatchRoomView:addDataObservers()
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

function ChooseMatchRoomView:getMatchRoomChoseData()
    -- body
    local getMatchRoomDataByIdxSel = {
        [1] = function()
            -- body
            local matchHotData = self:findNextSomeTimeMatchs() or {}

            self:updateMatchHotTagRoomData(matchHotData)
            self:getMatchHotPlayerCountData(matchHotData)
            self:updateSomeInfoByInterval()
        end,

        [2] = function()
            -- body
            local matchNorData = nk.MatchConfigEx:getMatchDatasByType(LoadMatchControlEx.TYPE_NORMAL_MATCH)

            self:updateMatchNormalRoomData(matchNorData)
            self.controller_:getMatchNorPlayerCountData()
        end
    }

    getMatchRoomDataByIdxSel[self.selectedIdx_]()
end

function ChooseMatchRoomView:findNextSomeTimeMatchs()
    local mlistData = nk.MatchConfigEx:findNextSomeTimeMatchs()
    if mlistData then
    	table.walk(mlistData, function(v, k)
	        -- 检查场次是否已经报过名
	        local regData = nk.MatchConfigEx:findRegisterMatchByIdAndTime(v.id, v.mtime.timestamp)
	        if regData then
	            v.isReg = true
	        end
	    end)

	    table.sort(mlistData,function(t1,t2)
	        return t1.mtime.timestamp < t2.mtime.timestamp
	    end)
    end

    return mlistData
end

function ChooseMatchRoomView:getMatchHotPlayerCountData(listDatas)
    local tb = {}

    for _, v in pairs(listDatas) do
        local id = tostring(v["id"])
        if not tb[id] then
            tb[id] = {}
        end

        table.insert(tb[id], tostring(v.mtime.timestamp))
    end
    
    self.controller_:getMatchHotPlayerCountData(tb)
end

function ChooseMatchRoomView:onLoadMatchConfig(isSuccess, matchsdata)
    if isSuccess and matchsdata then
        --todo
        self.matchConfLoadedSucc_ = true

        self:getMatchRoomChoseData()
    else
        self.matchConfLoadedSucc_ = false
        self:setMatchNilRoomData()
    end
end

function ChooseMatchRoomView:onMatchNorPlayerCountDataGet(data)
    -- dump(data, "ChooseMatchRoomView:onMatchNorPlayerCountDataGet.data :====================")

    local onlineData = data.onlinePeople
    if onlineData then
        local desData = {}
        for k, v in pairs(onlineData) do
            desData[(tonumber(k))] = checkint(v)
        end

        -- self:onUpdateNormalMatchPlayerNum(desData)
    end
end

function ChooseMatchRoomView:onMatchHotPlayerCountDataGet(datas)

    if not self.matchHotDatas_ then
        return
    end
    -- local total = 0
    for i, baseData in ipairs(self.matchHotDatas_) do  

        local id = baseData["id"]  
        local timestamp = baseData["mtime"]["timestamp"]
        local onlineData = datas[tostring(id)]
        local count = 0
        
        if onlineData then
            count = onlineData[tostring(timestamp)] or 0
        else
            count = math.floor(math.random(5, 30))
        end

        baseData.playerCount = count
        -- total = total + count
        
        if self.selectedIdx_ == MATCH_TYPE_HOT then
            --todo
            if self.matchRoomChoseList_ then
                --todo
                self.matchRoomChoseList_:updateData(i, baseData)
            end
        end
    end
end

function ChooseMatchRoomView:updateSomeInfoByInterval()
    if self.getMatchPeopleAction_ then
        self:stopAction(self.getMatchPeopleAction_)
        self.getMatchPeopleAction_ = nil
    end

    local timeSecUpdateInterval = 30

    self.getMatchPeopleAction_ = self:schedule(function ()

        if self.selectedIdx_ == MATCH_TYPE_HOT then
            if self.matchHotDatas_ and #self.matchHotDatas_ > 0 then
                self:getMatchHotPlayerCountData(self.matchHotDatas_)
            end
        end
    end, timeSecUpdateInterval)
end

function ChooseMatchRoomView:onUpdateNormalMatchPlayerNum(datas)
    if not self.matchNorDatas_ then
        return
    end
    
    -- local total = 0
    for i, baseData in ipairs(self.matchNorDatas_) do        
        local num = 0

        if (baseData and baseData["id"]) and (datas and datas[(baseData["id"])]) then
            num = datas[(baseData["id"])]
        else
            num = 50
        end

        -- total = total + num
        baseData.playerCount = num

        if self.selectedIdx_ == MATCH_TYPE_NOR then
            --todo
            if self.matchRoomChoseList_ then
                --todo
                self.matchRoomChoseList_:updateData(i, baseData)
            end
        end
    end
end

function ChooseMatchRoomView:updateMatchNormalRoomData(data)
    -- dump(data, "ChooseMatchRoomView:updateMatchNormalRoomData.data :==================", 8)
    if self then
        --todo
        self.matchNorDatas_ = data
        if self.matchNorDatas_ and #self.matchNorDatas_ > 0 then
            --todo
            if self.selectedIdx_ == MATCH_TYPE_NOR then
                --todo
                if self.matchRoomChoseList_ then
                    --todo
                    self.matchRoomChoseList_:setData(self.matchNorDatas_)
                end
            end
        else
            -- Show No Data State Tips --
            dump("No MatchNorData List")
        end
    end
end

function ChooseMatchRoomView:updateMatchHotTagRoomData(data)
    if self then
        --todo
        self.matchHotDatas_ = data

        if self.matchHotDatas_ and #self.matchHotDatas_ > 0 then
            --todo
            if self.selectedIdx_ == MATCH_TYPE_HOT then
                --todo
                if self.matchRoomChoseList_ then
                    --todo
                    self.matchRoomChoseList_:setData(self.matchHotDatas_)
                end
            end
        else
            -- Show No Data State Tips --
            dump("No MatchHotData List")
        end
    end
end

function ChooseMatchRoomView:setMatchNilRoomData()
    -- body
    if self then
        --todo
        self.matchNorDatas_ = nil
        self.matchHotDatas_ = nil

        if self.matchRoomChoseList_ then
            --todo
            self.matchRoomChoseList_:setData(nil)
        end

        -- Show No Data State Tips --
    end
end

function ChooseMatchRoomView:onEnterForeground_()
    nk.MatchConfigEx:loadConfig(nil, handler(self, self.onLoadMatchConfig), true)
end

function ChooseMatchRoomView:onTimeMatchOpen_()
    nk.MatchConfigEx:loadConfig(nil, handler(self, self.onLoadMatchConfig))
end

function ChooseMatchRoomView:removeDataObserver()
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.micon", self.avatarUrlObserverHandle_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.name", self.nickObserverHandle_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.exp", self.experienceObserverHandle_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.money", self.moneyObserverHandle_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "match.point", self.cashNumChangeObserverHandler_)
end

function ChooseMatchRoomView:onEnter()
    -- body
end

function ChooseMatchRoomView:onExit()
    -- body
    self:removeDataObserver()
    nk.MatchConfigEx:cancel()

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

    if self.getMatchPeopleAction_ then
        self:stopAction(self.getMatchPeopleAction_)
        self.getMatchPeopleAction_ = nil
    end
end

function ChooseMatchRoomView:onCleanup()
    
end

return ChooseMatchRoomView