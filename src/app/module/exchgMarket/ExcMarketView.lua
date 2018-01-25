--
-- Author: ThinkerWang
-- Date: 2015-10-23 16:20:50
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: ExcMarketView.lua Reconstructed By Tsing7x.
--

local StorePopup = import("app.module.store.StorePopup")
local SettingHelpPopup = import("app.module.settingHelp.SettingHelpPopupMgr")
local SuonaUsePopup = import("app.module.suona.SuonaUsePopup")

local ExchangeWarePopup = import(".views.ExchangeWarePopup")

local ExcMarketController = import(".ExcMarketController")
local ExcPrdLineListItem = import(".ExcPrdLineListItem")
local ExcUsrPayRecordListItem = import(".ExcUsrPayRecordListItem")

local ExcMarketView = class("ExcMarketView", function()
    return display.newNode()
end)

local TOPOPR_PANEL_HEIGHT = 0
local TOPOPR_PANELSUONA_HEIGHT = 0
local LEFTOPR_PANEL_WIDTH = 0

local AVATAR_TAG = 100

function ExcMarketView:ctor(pntController, defaultWareGroupId)
    self.pntController_ = pntController
    self.defaultLeftTypeGroupIdx_ = defaultWareGroupId or 0

    self.controller_ = ExcMarketController.new(self)

    self:setNodeEventEnabled(true)

    local bgScale = nil
    if display.width > 1140 and display.height == 640 then
        bgScale = display.width / 1140
    elseif display.width == 960 and display.height > 640 then
        bgScale = display.height / 640
    else
        bgScale = 1
    end

    local roomChoseBg = display.newSprite("hall_auxSurMain_bg.jpg")
        :addTo(self)
        :scale(bgScale)

    roomChoseBg:setTouchEnabled(true)
    roomChoseBg:setTouchSwallowEnabled(true)

    self.pntController_:setDisplayView(self)

    display.addSpriteFrames("excMarket.plist", "excMarket.png", handler(self, self.onExchangeMarketTextureLoaded_))

    local repArgs = {
        eventId = "ExcMarketView_Create",
        label = "ExcMarketView_Create",
    }

    self:reportUmeng_("event", repArgs)
end

function ExcMarketView:onExchangeMarketTextureLoaded_(fileName, imgName)
    -- body
    self.topOpreationAreaNode_ = display.newNode()
        :addTo(self)

    local topOpreationPanelCalModel = display.newSprite("#excMar_bgPanelTop.png")
    local topOpreationPanelSizeCal = topOpreationPanelCalModel:getContentSize()

    TOPOPR_PANEL_HEIGHT = topOpreationPanelSizeCal.height

    local topOprAreaPanelStencil = {
        x = 233,
        y = 0,
        width = 660,
        height = 100
    }

    self.topOpreationPanel_ = display.newScale9Sprite("#excMar_bgPanelTop.png", 0, display.cy - topOpreationPanelSizeCal.height / 2,
        CCSize(display.width, topOpreationPanelSizeCal.height), cc.rect(topOprAreaPanelStencil.x, topOprAreaPanelStencil.y,
            topOprAreaPanelStencil.width, topOprAreaPanelStencil.height))
        :addTo(self.topOpreationAreaNode_)

    local back2LastViewBtnCalModel = display.newSprite("#excMar_btnReturn.png")
    local back2LastViewBtnTexSize = back2LastViewBtnCalModel:getContentSize()

    self.back2LastViewBtn_ = cc.ui.UIPushButton.new({normal = "#excMar_btnReturn.png", pressed = "#excMar_btnReturn.png", disabled = "#excMar_btnReturn.png"},
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
    self.userAvatarRim_:pos(back2LastViewBtnTexSize.width + self.userAvatarRim_:getContentSize().width / 2 + userAvatarMagrins.left,
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

    local userNameLblMagrins = {
        top = 16,
        left = 12
    }

    labelParam.fontSize = 28
    labelParam.color = display.COLOR_WHITE
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

    self.expPrgBar_ = nk.ui.ProgressBar.new("#excMar_prgLayerExp.png", "#excMar_prgFillerExp.png", expPrgbarParam)
        :pos(self.userName_:getPositionX(), self.userName_:getPositionY() - self.userName_:getContentSize().height - expPrgbarMagrins.top)
        :addTo(self.topOpreationPanel_)

    -- Init LabelUserLevel Param --
    local userLevelLblMagrins = {
        top = 5,
        left = 16
    }

    labelParam.fontSize = 16
    labelParam.color = display.COLOR_WHITE
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
    local currnecyDentPosXShift = back2LastViewBtnTexSize.width / 2 + 10 * nk.widthScale

    local gameCurrencyChipDent = display.newSprite("#excMar_dentCurrency.png")
    local gameCurrencyCashDent = display.newSprite("#excMar_dentCurrency.png")

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
    local chipIcon = display.newSprite("#excMar_icChip.png")
    chipIcon:pos(chipIcon:getContentSize().width / 2 + currencyIconMagrinLeft, gameCurrencyChipDent:getContentSize().height / 2)
        :addTo(gameCurrencyChipDent)

    self.chipNum_ = ui.newTTFLabel({text = "0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.chipNum_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.chipNum_:pos(chipIcon:getPositionX() + chipIcon:getContentSize().width / 2 + currencyNumLblMagrinLeft, chipIcon:getPositionY())
        :addTo(gameCurrencyChipDent)

    self.chipGetBtn_ = cc.ui.UIPushButton.new({normal = "#excMar_btnGetCurrency.png", pressed = "#excMar_btnGetCurrency.png", disabled = "#excMar_btnGetCurrency.png"},
        {scale9 = false})
        :onButtonClicked(buttontHandler(self, self.onGetChipBtnCallBack_))
        :pos(gameCurrencyChipDent:getContentSize().width - currencyAddBtnMagrinRight - currencyGetBtnSizeWidth / 2, chipIcon:getPositionY())
        :addTo(gameCurrencyChipDent)

    -- CurrencyCash --
    local cashIcon = display.newSprite("#excMar_icCash.png")
    cashIcon:pos(cashIcon:getContentSize().width / 2 + currencyIconMagrinLeft, gameCurrencyCashDent:getContentSize().height / 2)
        :addTo(gameCurrencyCashDent)

    self.cashNum_ = ui.newTTFLabel({text = "0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.cashNum_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.cashNum_:pos(cashIcon:getPositionX() + cashIcon:getContentSize().width / 2 + currencyNumLblMagrinLeft, cashIcon:getPositionY())
        :addTo(gameCurrencyCashDent)

    self.cashGetBtn_ = cc.ui.UIPushButton.new({normal = "#excMar_btnGetCurrency.png", pressed = "#excMar_btnGetCurrency.png", disabled = "#excMar_btnGetCurrency.png"},
        {scale9 = false})
        :onButtonClicked(buttontHandler(self, self.onGetCashBtnCallBack_))
        :pos(gameCurrencyCashDent:getContentSize().width - currencyAddBtnMagrinRight - currencyGetBtnSizeWidth / 2, cashIcon:getPositionY())
        :addTo(gameCurrencyCashDent)

    local rightOprBtnMagrinEach = 18
    -- Top Area Right --
    local feedBackBtnSize = {
        width = 40,
        height = 40
    }

    self.feedBackBtn_ = cc.ui.UIPushButton.new({normal = "#excMar_btnFeedBack.png", pressed = "#excMar_btnFeedBack.png", disabled = "#excMar_btnFeedBack.png"},
        {scale9 = false})
        :onButtonClicked(buttontHandler(self, self.onFeedBackBtnCallBack_))
        :pos(display.width - rightOprBtnMagrinEach - feedBackBtnSize.width / 2, gameCurrencyChipDent:getPositionY())
        :addTo(self.topOpreationPanel_)

    local leftOprTabAreaPanelModel = display.newSprite("#excMar_bgPanelLeft.png")
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

    local suonaMsgPanel = display.newScale9Sprite("#excMar_bgSuonaMsg.png", leftOprTabAreaPanelSizeCal.width / 2, display.cy - topOpreationPanelSizeCal.height -
        suonaMsgPanelMagrinTop - suonaMsgPanelSize.height / 2, CCSize(suonaMsgPanelSize.width, suonaMsgPanelSize.height), cc.rect(suonaPanelStencil.x, suonaPanelStencil.y,
            suonaPanelStencil.width, suonaPanelStencil.height))
        :addTo(self.suonaMsgBroPanelNode_)

    local suonaPanelGapBotViewPages = 5 * nk.heightScale

    TOPOPR_PANELSUONA_HEIGHT = suonaMsgPanelSize.height + suonaMsgPanelMagrinTop + suonaPanelGapBotViewPages

    local suonaSendBtnMagrinHoriz = 118 * nk.widthScale
    local suonaSendBtnSize = {
        width = 40,
        height = 24
    }

    self.suonaSendBtn_ = cc.ui.UIPushButton.new({normal = "#excMar_btnSuonaSend.png", pressed = "#excMar_btnSuonaSend.png", disabled = "#excMar_btnSuonaSend.png"},
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

    self.leftTabOprAreaNode_ = display.newNode()
        :addTo(self, 2)

    local tabPanelLeftSizeHAdj = 20
    local tabPanelLeftSize = cc.size(LEFTOPR_PANEL_WIDTH, display.height - TOPOPR_PANEL_HEIGHT + tabPanelLeftSizeHAdj)
    self.leftOprTabPanel_ = display.newScale9Sprite("#excMar_bgPanelLeft.png", - display.width / 2 + tabPanelLeftSize.width / 2,
        - (display.height / 2 - tabPanelLeftSize.height / 2), tabPanelLeftSize)
        :addTo(self.leftTabOprAreaNode_)

    local excTicketMagrins = {
        left = 8,
        top = 22
    }

    local ecxTicketIcon = display.newSprite("#excMar_icExcTicket.png")
    ecxTicketIcon:pos(ecxTicketIcon:getContentSize().width / 2 + excTicketMagrins.left, tabPanelLeftSize.height - excTicketMagrins.top -
        ecxTicketIcon:getContentSize().height / 2)
        :addTo(self.leftOprTabPanel_)

    local excTickNumLblMagrinLeft = 6
    local excTickNumLblPosYAdj = 3

    labelParam.fontSize = 18
    labelParam.color = display.COLOR_WHITE
    self.excTicketNum_ = display.newTTFLabel({text = tostring(nk.userData["match.ticket"] or 0), size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.excTicketNum_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.excTicketNum_:pos(excTicketMagrins.left + ecxTicketIcon:getContentSize().width + excTickNumLblMagrinLeft, ecxTicketIcon:getPositionY() + excTickNumLblPosYAdj)
        :addTo(self.leftOprTabPanel_)

    -- local QMarkBtnSize = {
    --     width = 35,
    --     height = 35
    -- }

    -- local excQMarkBtnMagrinRight = 10

    -- self.excQMarkBtn_ = cc.ui.UIPushButton.new({normal = "#excMar_btnQMark.png", pressed = "#excMar_btnQMark.png", disabled = "#excMar_btnQMark.png"}, {scale9 = false})
    --     :onButtonClicked(buttontHandler(self, self.onExcQMarkBtnCallBack_))
    --     :pos(tabPanelLeftSize.width - QMarkBtnSize.width / 2 - excQMarkBtnMagrinRight, ecxTicketIcon:getPositionY())
    --     :addTo(self.leftOprTabPanel_)

    self.excMainContNode_ = display.newNode()
        :pos(LEFTOPR_PANEL_WIDTH / 2, - (TOPOPR_PANEL_HEIGHT + TOPOPR_PANELSUONA_HEIGHT) / 2)
        :addTo(self)

    local excMainContListviewMagrinHoriz = 14 * nk.widthScale
    local excMainContListviewMagrinVect = 15 * nk.heightScale

    local excMainContListViewSize = {
        width = display.width - LEFTOPR_PANEL_WIDTH - excMainContListviewMagrinHoriz * 2,
        height = display.height - TOPOPR_PANEL_HEIGHT - TOPOPR_PANELSUONA_HEIGHT - excMainContListviewMagrinVect * 2
    }

    self.excMainContListView_ = bm.ui.ListView.new({viewRect = cc.rect(- excMainContListViewSize.width / 2, - excMainContListViewSize.height / 2, excMainContListViewSize.width,
        excMainContListViewSize.height), direction = bm.ui.ListView.DIRECTION_VERTICAL}, ExcPrdLineListItem)
        :addTo(self.excMainContNode_)

    labelParam.fontSize = 28
    labelParam.color = display.COLOR_RED
    self.noExcContListDataTip_ = display.newTTFLabel({text = "暂无数据", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
        :addTo(self.excMainContNode_)
        :hide()

    -- self.excMainContListView_:setItemClass(ExcUsrPayRecordListItem)
    -- self.excMainContListView_:setData({1, 2, 3, 4})
    -- self.excMainContListView_:setNotHide(true)
    local decBotModel = display.newSprite("#excMar_decModBot.png")
    local decBotModelSizeCal = decBotModel:getContentSize()

    local decModeBot = display.newScale9Sprite("#excMar_decModBot.png", 0, - display.height / 2 + decBotModelSizeCal.height / 2, cc.size(display.width,
        decBotModelSizeCal.height))
        :addTo(self)

    self.controller_:getExchangeMarketInitData()
    self:setReqWareTypeDataLoading(true)

    self:addDataObservers()
end

function ExcMarketView:renderLeftExcWareTypesView(initData)
    -- body
    self:setReqWareTypeDataLoading(false)

    local labelParam = {
        fontSize = 0,
        color = display.COLOR_BLACK
    }

    self.leftExcWareTypeBtns_ = {}
    self.leftExcTypeBtnGroup_ = nk.ui.CheckBoxButtonGroup.new()

    local typeBtnLblStrs = nil

    local typeBtnSizeWFix = 3

    local leftExcWareTypeBtnSize = {
        width = LEFTOPR_PANEL_WIDTH - typeBtnSizeWFix * 2,
        height = 62
    }

    local typeBtnsMagrinTop = 40
    local typeBtnsMagrinEachVect = - 4

    local typeBtnPosXAdj = 2

    labelParam.fontSize = 25
    labelParam.color = display.COLOR_WHITE  -- State Nor
    for i = 1, #initData + 1 do
        if i == #initData + 1 then
            --todo
            typeBtnLblStrs = "兑换记录"
        else
            typeBtnLblStrs = initData[i].name or "TypeName"
        end

        self.leftExcWareTypeBtns_[i] = cc.ui.UICheckBoxButton.new({on = "#excMar_chkBtnLeftTab_sel.png", off = "#excMar_chkBtnLeftTab_unSel.png"}, {scale9 = true})
            :setButtonSize(leftExcWareTypeBtnSize.width, leftExcWareTypeBtnSize.height)
            :pos(LEFTOPR_PANEL_WIDTH / 2 - typeBtnPosXAdj, display.height - TOPOPR_PANEL_HEIGHT - typeBtnsMagrinTop - leftExcWareTypeBtnSize.height / 2 * (i * 2 - 1) -
                typeBtnsMagrinEachVect * (i - 1))
            :addTo(self.leftOprTabPanel_)

        self.leftExcWareTypeBtns_[i].label_ = display.newTTFLabel({text = typeBtnLblStrs, size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
            :addTo(self.leftExcWareTypeBtns_[i])

        self.leftExcTypeBtnGroup_:addButton(self.leftExcWareTypeBtns_[i])
    end

    self.leftExcTypeBtnGroup_:onButtonSelectChanged(buttontHandler(self, self.onLeftExcTypeSelChanged_))

    self.usrExcRecordLeftTabIdx_ = #initData + 1

    local defaultLeftTabIdx = nil

    if self.defaultLeftTypeGroupIdx_ == 0 then
        --todo
        defaultLeftTabIdx = self.usrExcRecordLeftTabIdx_
    else
        for i = 1, #initData do
            local itemGroupData = initData[i].param

            local itemGroups = string.split(itemGroupData, ",")

            for j = 1, #itemGroups do
                if self.defaultLeftTypeGroupIdx_ == tonumber(itemGroups[j]) then
                    --todo
                    defaultLeftTabIdx = i
                end
            end
        end
    end

    self.leftWareTypeDataList_ = initData

   self.leftExcTypeBtnGroup_:getButtonAtIndex(defaultLeftTabIdx or 1):setButtonSelected(true)
end

function ExcMarketView:onAvatarLoadComplete_(success, sprite)
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

function ExcMarketView:playSuonaMsgScrolling()
    -- body
    if not self.suonaMsgPlaying_ then
        --todo
        self:playSuonaMsgNext()
    end
end

function ExcMarketView:playSuonaMsgNext()
    -- body
    local currentSuonaMsgData = nil

    local suonaMsgShownColor = {
        tip = display.COLOR_WHITE,
        msg = cc.c3b(206, 206, 210)
    }
    if self.pntController_.suonaMsgQueue_[1] then
        --todo
        currentSuonaMsgData = table.remove(self.pntController_.suonaMsgQueue_, 1)
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

function ExcMarketView:playShowAnim()
    -- body
    -- Reservation For Show Anim Funcs --
end

function ExcMarketView:setReqWareTypeDataLoading(state)
    -- body
    if state then
        --todo
        if not self.reqDataLoadingBar_ then
            --todo
            self.reqDataLoadingBar_ = nk.ui.Juhua.new()
                :addTo(self)
        end
    else
        if self.reqDataLoadingBar_ then
            --todo
            self.reqDataLoadingBar_:removeFromParent()
            self.reqDataLoadingBar_ = nil
        end
    end
end

function ExcMarketView:setReqMainContListDataLoading(state)
    -- body
    if state then
        --todo
        if not self.reqDataLoadingBar_ then
            --todo
            self.reqDataLoadingBar_ = nk.ui.Juhua.new()
                :addTo(self.excMainContNode_)
        end
    else
        if self.reqDataLoadingBar_ then
            --todo
            self.reqDataLoadingBar_:removeFromParent()
            self.reqDataLoadingBar_ = nil
        end
    end
end

function ExcMarketView:onReturnBtnCallBack_(evt)
    -- body
    self:hidePanel()
end

function ExcMarketView:onGetChipBtnCallBack_(evt)
    -- body
    nk.DReport:report({id = "openStoreClick"})
    StorePopup.new():showPanel()
end

function ExcMarketView:onGetCashBtnCallBack_(evt)
    -- body
    nk.DReport:report({id = "openStoreClick"})

    local cashTabIndx = 2
    StorePopup.new(cashTabIndx):showPanel()
end

function ExcMarketView:onFeedBackBtnCallBack_(evt)
    -- body
    SettingHelpPopup.new(false, true, 1):showPanel()
end

function ExcMarketView:onSuonaSendBtnCallBack_(evt)
    -- body
    -- local msgInfo = {
    --     type = 1,
    --     content = "通知:唉纱布的骄傲比我都看见爱我不打开暗红色的金卡和贷款还逗我还等哈啊肯定会！      ",
    --     -- location = "fillawrdaddr",
    --     name = "tsing"
    -- }
    -- local msgJson = json.encode(msgInfo)

    -- self.pntController_:onSuonaBroadRecv_({data = {msg_info = msgJson}})
    -- do return end

    self.suonaSendBtn_:setButtonEnabled(false)
    SuonaUsePopup.new():show()

    self.suonaSendBtn_:setButtonEnabled(true)
end

function ExcMarketView:onExcQMarkBtnCallBack_(evt)
    -- body
end

function ExcMarketView:onLeftExcTypeSelChanged_(evt)
    -- body
    local leftExcTypeBtnLblColor = {
        nor = display.COLOR_WHITE,
        sel = display.COLOR_GREEN
    }

    if not self.leftExcTypeTabSelIdx_ then
        --todo
        self.leftExcTypeTabSelIdx_ = evt.selected
        self.leftExcWareTypeBtns_[self.leftExcTypeTabSelIdx_].label_:setTextColor(leftExcTypeBtnLblColor.sel)
    end

    local isChanged = self.leftExcTypeTabSelIdx_ ~= evt.selected

    if isChanged then
        --todo
        self.leftExcWareTypeBtns_[self.leftExcTypeTabSelIdx_].label_:setTextColor(leftExcTypeBtnLblColor.nor)

        self.leftExcWareTypeBtns_[evt.selected].label_:setTextColor(leftExcTypeBtnLblColor.sel)

        self.leftExcTypeTabSelIdx_ = evt.selected
    end

    self.excMainContListView_:setData(nil)
    if self.leftExcTypeTabSelIdx_ == self.usrExcRecordLeftTabIdx_ then
        --todo
        self.excMainContListView_:setItemClass(ExcUsrPayRecordListItem)
    else
        self.excMainContListView_:setItemClass(ExcPrdLineListItem)
        self.excMainContListView_.itemClass_:setExcActionCallBack(handler(self, self.onPrdExcActionCallBack_))
    end

    self:getExcMainContPagesData()
end

function ExcMarketView:onPrdExcActionCallBack_(itemData)
    -- body
    ExchangeWarePopup.new(self.controller_, itemData):showPanel()
end

function ExcMarketView:getExcMainContPagesData()
    -- body
    local wareGroupParam = nil

    if self.leftWareTypeDataList_[self.leftExcTypeTabSelIdx_] then
        --todo
        wareGroupParam = self.leftWareTypeDataList_[self.leftExcTypeTabSelIdx_].param
    else
        wareGroupParam = self.leftWareTypeDataList_[1].param
    end

    if self.leftExcTypeTabSelIdx_ == self.usrExcRecordLeftTabIdx_ then
        --todo
        self.controller_:getMyExcRecordData(wareGroupParam)
        -- self.excMainContListView_:setData({1, 2, 3, 4})
    else
        self.controller_:getExcWareData(wareGroupParam)
    end

    self:setReqMainContListDataLoading(true)
end

function ExcMarketView:rangeExcWareListData(dataList)
    -- body
    local retTab = {}

    local retTabelLen = math.ceil(#dataList / 3)

    for i = 1, retTabelLen do
        retTab[i] = {}
        for j = 1, 3 do
            if dataList[(i - 1) * 3 + j] then
                --todo
                table.insert(retTab[i], dataList[(i - 1) * 3 + j])
            end
        end
    end

    return retTab
end

function ExcMarketView:onGetMarketInitDataWrong(errData)
    -- body
    self:setReqWareTypeDataLoading(false)
    if errData then
        --todo
        nk.ui.Dialog.new({messageText = bm.LangUtil.getText("COMMON", "REQUEST_DATA_FAIL"), secondBtnText = bm.LangUtil.getText("COMMON", "RETRY"), callback = function(type)
            if type == nk.ui.Dialog.SECOND_BTN_CLICK then
                self.controller_:getExchangeMarketInitData()
                self:setReqWareTypeDataLoading(true)
            end
        end
        }):show()
    else
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("COMMON", "REQUEST_DATA_FAIL"))
    end
end

function ExcMarketView:onMyExcRecordDataGet(data)
    -- body
    self:setReqMainContListDataLoading(false)

    if self.leftExcTypeTabSelIdx_ ~= self.usrExcRecordLeftTabIdx_ then
        --todo
        return
    end

    if #data <= 0 then
        --todo
        self.noExcContListDataTip_:setString("暂无兑换记录")
        self.noExcContListDataTip_:show()
    else
        self.noExcContListDataTip_:hide()
        self.excMainContListView_:setData(data)
    end
end

function ExcMarketView:onExcWareListDataGet(data)
    -- body
    self:setReqMainContListDataLoading(false)

    -- Alert Later,Add More Conditions<Alert Data Structure> --
    if self.leftExcTypeTabSelIdx_ ~= 1 then
        --todo
        return
    end

    if #data <= 0 then
        --todo
        self.noExcContListDataTip_:setString("暂无可兑换的物品")
        self.noExcContListDataTip_:show()
    else
        self.noExcContListDataTip_:hide()

        local excWareRangedData = self:rangeExcWareListData(data)
        self.excMainContListView_:setData(excWareRangedData)
    end
end

function ExcMarketView:getMainContListDataWrong(errData)
    -- body
    self:setReqMainContListDataLoading(false)

    if errData then
        --todo
        nk.ui.Dialog.new({messageText = bm.LangUtil.getText("COMMON", "REQUEST_DATA_FAIL"), secondBtnText = bm.LangUtil.getText("COMMON", "RETRY"), callback = function(type)
            if type == nk.ui.Dialog.SECOND_BTN_CLICK then
                self:getExcMainContPagesData()
            end
        end
        }):show()
    else
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("COMMON", "REQUEST_DATA_FAIL"))
    end
end

function ExcMarketView:setParentView(view)
    -- body
    self.parentView_ = view
end

function ExcMarketView:addDataObservers()
    -- body
    self.avatarUrlObserverHandler_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "aUser.micon", handler(self, function(obj, micon)
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

    self.nickObserverHandler_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "aUser.name", handler(self, function(obj, name)
        if obj and obj.userName_ then
            obj.userName_:setString(nk.Native:getFixedWidthText("", 24, name, 200))
        end
        
    end))

    self.experienceObserverHandler_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "aUser.exp", handler(self, function (obj, experience)
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
    
    self.moneyObserverHandler_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "aUser.money", handler(self, function (obj, money)
        if obj and obj.chipNum_ then
            if money >= 10000000 then
                --todo
                obj.chipNum_:setString(bm.formatBigNumber(money))
            else
                obj.chipNum_:setString(bm.formatNumberWithSplit(money))
            end
        end
        
    end))

    self.cashNumObserverHandler_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "match.point", handler(self, function(obj, cash)
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

    self.excTicketNumObserverHandler_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "match.ticket", handler(self, function(obj, ticketNum)
        -- body
        if obj and obj.excTicketNum_ then
            --todo
            local num = ticketNum or 0

            if num >= 100000 then
                --todo
                obj.excTicketNum_:setString(bm.formatBigNumber(num))
            else
                obj.excTicketNum_:setString(bm.formatNumberWithSplit(num))
            end
        end
    end))
end

function ExcMarketView:reportUmeng_(command, args)
    if device.platform == "android" or device.platform == "ios" then  
        cc.analytics:doCommand{command = command, args = args}
    end 
end

function ExcMarketView:removeDataObserver()
    -- body
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.micon", self.avatarUrlObserverHandler_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.money", self.moneyObserverHandler_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "match.point", self.cashNumObserverHandler_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.name", self.nickObserverHandler_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.exp", self.experienceObserverHandler_)

    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "match.ticket", self.excTicketNumObserverHandler_)
end

function ExcMarketView:showPanel()
    -- body
    nk.PopupManager:addPopup(self, false, nil, nil, false)
    return self
end

function ExcMarketView:onShowed()
    -- body
    if self.excMainContListView_ then
        --todo
        self.excMainContListView_:update()
    end
end

function ExcMarketView:hidePanel()
    -- body
    nk.PopupManager:removePopup(self)
end

function ExcMarketView:onEnter()
    -- body
end

function ExcMarketView:onExit()
    -- body
    self:removeDataObserver()

    self.pntController_:setDisplayView(self.parentView_)
end

function ExcMarketView:onCleanup()
    -- body
    display.removeSpriteFramesWithFile("excMarket.plist", "excMarket.png")

    nk.schedulerPool:delayCall(function()
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    end, 0.1)
end

return ExcMarketView