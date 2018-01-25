--
-- Author: johnny@boomegg.com
-- Date: 2014-08-04 15:59:48
-- Copyright: Copyright (c) 2014, BOOMEGG INTERACTIVE CO., LTD All rights reserved.
-- Description: MainHallView.lua Reconstructed By Tsing7x.
--

local SettingHelpPopupMgr = import("app.module.settingHelp.SettingHelpPopupMgr")
local UserInfoPopup = import("app.module.userInfo.UserInfoPopup")
local InviteRecallPopup = import("app.module.friend.InviteRecallPopup")
local StorePopup = import("app.module.store.StorePopup")
local FriendPopup = import("app.module.friend.FriendPopup")
local RankingPopup = import("app.module.ranking.RankingPopup")
local ExcMarketView = import("app.module.exchgMarket.ExcMarketView")
local UpdatePopup = import("app.module.settingHelp.setting.views.UpdatePopup")
local SuonaUsePopup = import("app.module.suona.SuonaUsePopup")

local DailyTasksPopup = import("app.module.dailytasks.DailyTasksPopup")
local ExchangeCodePop = import("app.module.exchangecode.ExchangeCode")
local WheelPopup = import("app.module.wheel.WheelPopup")
local CornuPopup = import("app.module.cornucopiaEx.CornuPopup")
local SignInContPopup = import("app.module.signIn.SignInContPopup")

local PayGuide = import("app.module.store.purchGuide.PayGuide")
local NewestActPopup = import("app.module.newestact.NewestActPopup")
local PokdengAdPopup = import("app.module.pokdeng.PokdengAdPopup")
local PromotActPopup = import("app.module.unionAct.PromotActPopup")
local FirChargePayGuidePopup = import("app.module.store.firChrgGuide.FirChrgPayGuidePopup")
local AgnChargePayGuidePopup = import("app.module.store.agnChrgGuide.AgnChrgPayGuidePopup")
local AdPromotPopup = import("app.module.adPromot.AdPromotPopup")
local GucuReCallPopup = import("app.module.gucuRecall.GucuReCallPopup")
local RegisterAwardPopup = import("app.module.newer.RegisterAwardPopup")

local PURCHASE_TYPE = import("app.module.store.managers.PURCHASE_TYPE")

local MessageView  = import("app.module.message.MessageView")
local MessageData = import("app.module.message.MessageData")

-- For Import Test Module --
local GiftStorePopup = import("app.module.store.GiftStorePopup")
-- local LoginRewardView = import("app.module.loginReward.LoginRewardView")
-- local NewerPlayRewardPopup = import("app.module.newer.NewerPlayRewardPopup")

local AdPromtPageItem = import(".AdPromtPageItem")

local AVATAR_TAG = 100

local DIVID_LINE_RIGHT1_TAG = 7
local DIVID_LINE_RIGHT2_TAG = 17

local GAMEBRICK_WIDTH = 202
local PROMOTEBRICK_WIDTH = 248
local BRICK_HEIGHT = 302
local BOTOPRPANEL_HEIGHT = 0

local GAMEBRICK_GAP = 16 * nk.widthScale
local PROMOTEBRICK_GAP = 22 * nk.widthScale

local MainHallView = class("MainHallView", function()
    return display.newNode()
end)

MainHallView.TABLE_POS_TOP    = 1
MainHallView.TABLE_POS_BOTTOM = 2

function MainHallView:ctor(controller, tablePos)
    self.controller_ = controller
    self.controller_:setDisplayView(self)
    self.tablePos_ = tablePos

    self:setNodeEventEnabled(true)

    -- self.tableNode_ = display.newNode()
    --     :addTo(self)

    -- TopHalf Node --
    self.halfTopNode_ = display.newNode()
        :addTo(self)
    
    -- Top Opreation Area --
    self.topOpreationAreaNode_ = display.newNode()
        :addTo(self.halfTopNode_, 1)

    local topOpreationPanelCalModel = display.newSprite("#hall_panelTop.png")
    local topOpreationPanelSizeCal = topOpreationPanelCalModel:getContentSize()

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

    local userAvatarMagrins = {
        top = 15,
        left = 15
    }

    self.userAvatarRim_ = display.newSprite("#common_bg_userAvatar.png")
    self.userAvatarRim_:pos(self.userAvatarRim_:getContentSize().width / 2 + userAvatarMagrins.left,
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

    local topHeadBtnBordenRound = 1
    self.topHeadUserInfoBtn_ = cc.ui.UIPushButton.new({normal = "#common_modTransparent.png", pressed = "#common_roundRect_grey.png", disabled = "#common_modTransparent.png"},
        {scale9 = true})
        :setButtonSize(self.userAvatarRim_:getContentSize().width + topHeadBtnBordenRound * 2, self.userAvatarRim_:getContentSize().height + topHeadBtnBordenRound * 2)
        :onButtonClicked(buttontHandler(self, self.onTopUserInfoBtnCallBack_))
        :pos(self.userAvatarRim_:getContentSize().width / 2 + userAvatarMagrins.left - topHeadBtnBordenRound, topOpreationPanelSizeCal.height -
            self.userAvatarRim_:getContentSize().height / 2 - userAvatarMagrins.top + topHeadBtnBordenRound)
        :addTo(self.topOpreationPanel_, 2)

    self.userAvatarLoaderId_ = nk.ImageLoader:nextLoaderId()

    -- Default Param For Label --
    local labelParam = {
        fontSize = 0,
        color = display.COLOR_WHITE
    }

    -- Init LabelUserName Param --
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
        fillWidth = 8,
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

    local gameCurrencyChipDent = display.newSprite("#hall_dentCurrency.png")
    local gameCurrencyCashDent = display.newSprite("#hall_dentCurrency.png")

    gameCurrencyChipDent:pos(display.cx - currencyDentGapCnt / 2 - gameCurrencyChipDent:getContentSize().width / 2, topOpreationPanelSizeCal.height - currencyDentMagrinTop -
        gameCurrencyChipDent:getContentSize().height / 2)
        :addTo(self.topOpreationPanel_)

    gameCurrencyCashDent:pos(display.cx + currencyDentGapCnt / 2 + gameCurrencyCashDent:getContentSize().width / 2, gameCurrencyChipDent:getPositionY())
        :addTo(self.topOpreationPanel_)

    local currencyNumLblMagrinLeft = 5
    local currencyAddBtnMagrinRight = 5
    local currencyIconMagrinLeft = 2
    local currencyGetBtnSizeWidth = 40

    -- Omit --
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

    -- Right Opreation Area --
    local setBtnSize = {
        width = 35,
        height = 28
    }

    self.settingBtn_ = cc.ui.UIPushButton.new({normal = "#hall_btnMoreSet_nor.png", pressed = "#hall_btnMoreSet_pre.png", disabled = "#hall_btnMoreSet_nor.png"},
        {scale9 = false})
        :onButtonClicked(buttontHandler(self, self.onSettingBtnCallBack_))
        :pos(display.width - rightOprBtnMagrinEach - setBtnSize.width / 2, gameCurrencyChipDent:getPositionY())
        :addTo(self.topOpreationPanel_)

    local divdLine1PosAdj = {
        x = 0,
        y = 0
    }

    local divdLineRight1 = display.newSprite("#hall_divLine_topPanel.png")
    divdLineRight1:pos(self.settingBtn_:getPositionX() - setBtnSize.width / 2 - rightOprBtnMagrinEach - divdLineRight1:getContentSize().width / 2,
        self.settingBtn_:getPositionY() - divdLine1PosAdj.y)
        :addTo(self.topOpreationPanel_, 1, DIVID_LINE_RIGHT1_TAG)

    local mailMsgBtnSize = {
        width = 38,
        height = 28
    }

    self.mailMsgBtn_ = cc.ui.UIPushButton.new({normal = "#hall_btnMailMsg_nor.png", pressed = "#hall_btnMailMsg_pre.png", disabled = "#hall_btnMailMsg_nor.png"},
        {scale9 = false})
        :onButtonClicked(buttontHandler(self, self.onMailMsgBtnCallBack_))
        :pos(divdLineRight1:getPositionX() - divdLineRight1:getContentSize().width / 2 - rightOprBtnMagrinEach - mailMsgBtnSize.width / 2,
            self.settingBtn_:getPositionY())
        :addTo(self.topOpreationPanel_)

    -- Render By Conditions --
    -- local divdLineRight2 = display.newSprite("#hall_divLine_topPanel.png")
    -- divdLineRight2:pos(self.mailMsgBtn_:getPositionX() - mailMsgBtnSize.width / 2 - rightOprBtnMagrinEach - divdLineRight2:getContentSize().width / 2,
    --     divdLineRight1:getPositionY())
    --     :addTo(self.topOpreationPanel_, 1, DIVID_LINE_RIGHT2_TAG)

    -- local giftPackBtnSize = {
    --     width = 34,
    --     height = 38
    -- }

    -- self.giftPackBtn_ = cc.ui.UIPushButton.new({normal = "#hall_btnGift_nor.png", pressed = "#hall_btnGift_pre.png", disabled = "#hall_btnGift_nor.png"},
    --     {scale9 = false})
    --     :onButtonClicked(buttontHandler(self, self.onGiftPackBtnCallBack_))
    --     :pos(divdLineRight2:getPositionX() - divdLineRight2:getContentSize().width / 2 - rightOprBtnMagrinEach - giftPackBtnSize.width / 2,
    --         self.settingBtn_:getPositionY())
    --     :addTo(self.topOpreationPanel_)

    -- Souna Msg Block --
    self.suonaMsgBroPanelNode_ = display.newNode()
        :addTo(self.halfTopNode_, 1)

    local suonaMsgPanelMagrinTop = 2

    local suonaMsgPanelSize = {
        width = display.width,
        height = 38
    }

    local suonaPanelStencil = {
        x = 136,
        y = 2,
        width = 650,
        height = 34
    }

    local suonaMsgPanel = display.newScale9Sprite("#hall_bg_suonaMsg.png", 0, display.cy - topOpreationPanelSizeCal.height - suonaMsgPanelMagrinTop - suonaMsgPanelSize.height / 2,
        CCSize(suonaMsgPanelSize.width, suonaMsgPanelSize.height), cc.rect(suonaPanelStencil.x, suonaPanelStencil.y, suonaPanelStencil.width, suonaPanelStencil.height))
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

    self.suonaChatInfo_ = ui.newTTFLabel({text = "点此使用小喇叭>>", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.suonaChatInfo_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.suonaChatInfo_:pos(self.suonaChatMsgStrPosXSrc - self.suonaChatInfo_:getContentSize().width, 0)
        :addTo(suonaChatInfoLabelClipNode_)

    self.suonaChatInfo_:setOpacity(0)

    -- Half && Bottom Node --
    self.halfBottomNode_ = display.newNode()
        :addTo(self)

    local hallChipBrickWidth = GAMEBRICK_WIDTH * 3 + PROMOTEBRICK_WIDTH + GAMEBRICK_GAP * 2 + PROMOTEBRICK_GAP

    local hallChipBrickBtnBorderRound = 2
    -- PromotAd && FBInvite --
    self.promtChipNode_ = display.newNode()
        :addTo(self.halfBottomNode_, 1)

    local promtChipBrickSprPosAdj = {
        x = 0,
        y = 0
    }

    self.promtChipBrickSprite_ = display.newSprite("#hall_bg_promtAd.png")
    self.promtChipBrickSprite_:pos(PROMOTEBRICK_WIDTH / 2 - hallChipBrickWidth / 2 + promtChipBrickSprPosAdj.x,
        BRICK_HEIGHT / 2 - self.promtChipBrickSprite_:getContentSize().height / 2 + promtChipBrickSprPosAdj.y)
        :addTo(self.promtChipNode_)

    self:addModulePromtAdPageView()

    local FBInviteBrickSprPosAdj = {
        x = 2,
        y = - 18
    }

    self.FBInviteBrickSprite_ = display.newSprite("#hall_btnInvite_nor.png")
    self.FBInviteBrickSprite_:pos(PROMOTEBRICK_WIDTH / 2 - hallChipBrickWidth / 2 + FBInviteBrickSprPosAdj.x,
        self.FBInviteBrickSprite_:getContentSize().height / 2 - BRICK_HEIGHT / 2 + FBInviteBrickSprPosAdj.y)
        :addTo(self.promtChipNode_)

    local FBInviteBrickBtnSizeAdj = {
        width = 2,
        height = 12
    }

    local FBInviteBrickBtnPosAdj = {
        x = 3,
        y = 4
    }

    self.FBInviteBrickBtn_ = cc.ui.UIPushButton.new({normal = "#common_modTransparent.png", pressed = "#common_modRiAnGrey.png", disabled = "#common_modRiAnGrey.png"},
        {scale9 = true})
        :setButtonSize(PROMOTEBRICK_WIDTH + hallChipBrickBtnBorderRound * 2 - FBInviteBrickBtnSizeAdj.width, self.FBInviteBrickSprite_:getContentSize().height +
            hallChipBrickBtnBorderRound * 2 - FBInviteBrickBtnSizeAdj.height)
        :onButtonClicked(buttontHandler(self, self.onFBInviteBrickBtnCallBack_))
        :pos(self.FBInviteBrickSprite_:getContentSize().width / 2 - FBInviteBrickBtnPosAdj.x, self.FBInviteBrickSprite_:getContentSize().height / 2 + FBInviteBrickBtnPosAdj.y)
        :addTo(self.FBInviteBrickSprite_)

    -- Nor Room Choose --
    self.norRoomChipBrickNode_ = display.newNode()
        :addTo(self.halfBottomNode_, 1)

    local norRoomChipSprPosAdj = {
        x = 0,
        y = - 5
    }

    self.norRoomChipBrickSprite_ = display.newSprite("#hall_bgBrick_norRoom.png")
        :pos(self.promtChipBrickSprite_:getPositionX() + PROMOTEBRICK_WIDTH / 2 + PROMOTEBRICK_GAP + GAMEBRICK_WIDTH / 2 + norRoomChipSprPosAdj.x,
            norRoomChipSprPosAdj.y)
        :addTo(self.norRoomChipBrickNode_)

    self.norRoomChipBrickBtn_ = cc.ui.UIPushButton.new({normal = "#common_modTransparent.png", pressed = "#common_roundRect_grey.png", disabled = "#common_modTransparent.png"},
        {scale9 = true})
        :setButtonSize(GAMEBRICK_WIDTH + hallChipBrickBtnBorderRound * 2, BRICK_HEIGHT + hallChipBrickBtnBorderRound * 2)
        :onButtonClicked(buttontHandler(self, self.onNorHallClick))
        :pos(self.norRoomChipBrickSprite_:getContentSize().width / 2, self.norRoomChipBrickSprite_:getContentSize().height / 2)
        :addTo(self.norRoomChipBrickSprite_)

    -- Pro Room Choose --
    self.proRoomChipBrickNode_ = display.newNode()
        :addTo(self.halfBottomNode_, 1)

    local proRoomChipSprPosAdj = {
        x = - 5,
        y = 0
    }

    self.proRoomChipBrickSprite_ = display.newSprite("#hall_bgBrick_proRoom.png")
        :pos(self.norRoomChipBrickSprite_:getPositionX() + GAMEBRICK_WIDTH + GAMEBRICK_GAP + proRoomChipSprPosAdj.x, proRoomChipSprPosAdj.y)
        :addTo(self.proRoomChipBrickNode_)

    local proRoomChipBtnPosAdj = {
        x = 4,
        y = 4
    }

    self.proRoomChipBrickBtn_ = cc.ui.UIPushButton.new({normal = "#common_modTransparent.png", pressed = "#common_roundRect_grey.png", disabled = "#common_modTransparent.png"},
        {scale9 = true})
        :setButtonSize(GAMEBRICK_WIDTH + hallChipBrickBtnBorderRound * 2, BRICK_HEIGHT + hallChipBrickBtnBorderRound * 2)
        :onButtonClicked(buttontHandler(self, self.onMatchHallClick))
        :pos(self.proRoomChipBrickSprite_:getContentSize().width / 2 + proRoomChipBtnPosAdj.x, self.proRoomChipBrickSprite_:getContentSize().height / 2 - 
            proRoomChipBtnPosAdj.y)
        :addTo(self.proRoomChipBrickSprite_)

    -- Play Now Brick --
    self.playNowChipBrickNode_ = display.newNode()
        :addTo(self.halfBottomNode_, 1)

    local playNowChipSprPosAdj = {
        x = 15,
        y = - 5
    }

    self.playNowChipBrickSprite_ = display.newSprite("#hall_bgBrick_playNow.png")
        :pos(self.proRoomChipBrickSprite_:getPositionX() + GAMEBRICK_WIDTH + GAMEBRICK_GAP + playNowChipSprPosAdj.x, playNowChipSprPosAdj.y)
        :addTo(self.playNowChipBrickNode_)

    local playNowChipBtnPosAdj = {
        x = 16,
        y = 0
    }

    self.playNowChipBrickBtn_ = cc.ui.UIPushButton.new({normal = "#common_modTransparent.png", pressed = "#common_roundRect_grey.png", disabled = "#common_modTransparent.png"},
        {scale9 = true})
        :setButtonSize(GAMEBRICK_WIDTH + hallChipBrickBtnBorderRound * 2, BRICK_HEIGHT + hallChipBrickBtnBorderRound * 2)
        :onButtonClicked(buttontHandler(self, self.onPlayNowClick))
        :pos(self.playNowChipBrickSprite_:getContentSize().width / 2 - playNowChipBtnPosAdj.x, self.playNowChipBrickSprite_:getContentSize().height / 2 +
            playNowChipBtnPosAdj.y)
        :addTo(self.playNowChipBrickSprite_)

    -- Bottom Opreation Area --
    self.bottomPanelNode_ = display.newNode()
        :addTo(self.halfBottomNode_)

    local bottomOpreationAreaPanelModel = display.newSprite("#hall_panelBottom.png")
    local botOprPanelSizeCal = bottomOpreationAreaPanelModel:getContentSize()

    BOTOPRPANEL_HEIGHT = botOprPanelSizeCal.height

    self.bottomOprPanel_ = display.newScale9Sprite("#hall_panelBottom.png", 0, - display.cy + botOprPanelSizeCal.height / 2, CCSize(display.width, botOprPanelSizeCal.height))
        :addTo(self.bottomPanelNode_)

    local bottomOprBtnLablStrs = -- [[bm.LangUtil.getText("HALL", "HALL_BOTTOMAREA_INDEX_TEXT")]]
    {
        "商城",
        "免费",
        "排行",
        "夺宝",
        "兑换",
        "活动"
    }

    local bottomOprBtnResPathes = {
        nor = {
            "#hall_btnStore_nor.png",
            "#hall_btnFreeChip_nor.png",
            "#hall_btnRank_nor.png",
            "#hall_btnDokb_nor.png",
            "#hall_btnExchange_nor.png",
            "#hall_btnAct_nor.png"
        },
        pre = {
            "#hall_btnStore_pre.png",
            "#hall_btnFreeChip_pre.png",
            "#hall_btnRank_pre.png",
            "#hall_btnDokb_pre.png",
            "#hall_btnExchange_pre.png",
            "#hall_btnAct_pre.png"
        }
    }

    local botBtnActionCallBack = {
        buttontHandler(self, self.onStoreBtnCallBack_),
        buttontHandler(self, self.onFreeChipBtnCallBack_),
        buttontHandler(self, self.onRankBtnCallBack_),
        buttontHandler(self, self.onDokbBtnCallBack_),
        buttontHandler(self, self.onExchangeBtnCallBack_),
        buttontHandler(self, self.onActBtnCallBack_),
    }

    self.bottomOprBtns = {}

    -- ButtonLabel Param By State --
    labelParam.fontSize = 15
    labelParam.color = {
        nor = cc.c3b(48, 86, 86),
        pre = cc.c3b(125, 128, 150)
    }

    local bottomOprBtnLblOffsetY = - 32
    local bottomOprBtnPosAdjY = 0

    for i = 1, #bottomOprBtnLablStrs do
        self.bottomOprBtns[i] = cc.ui.UIPushButton.new({normal = bottomOprBtnResPathes.nor[i], pressed = bottomOprBtnResPathes.pre[i], disabled = bottomOprBtnResPathes.nor[i]},
            {scale9 = false})
            :setButtonLabel("normal", ui.newTTFLabel({text = bottomOprBtnLablStrs[i], size = labelParam.fontSize, color = labelParam.color.nor,
                align = ui.TEXT_ALIGN_CENTER}))
            :setButtonLabel("pressed", ui.newTTFLabel({text = bottomOprBtnLablStrs[i], size = labelParam.fontSize, color = labelParam.color.pre,
                align = ui.TEXT_ALIGN_CENTER}))
            :setButtonLabel("disabled", ui.newTTFLabel({text = bottomOprBtnLablStrs[i], size = labelParam.fontSize, color = labelParam.color.nor,
                align = ui.TEXT_ALIGN_CENTER}))
            :setButtonLabelOffset(0, bottomOprBtnLblOffsetY)
            :onButtonClicked(botBtnActionCallBack[i])
            :pos(display.width * (2 * i - 1) / 12, botOprPanelSizeCal.height / 2 + bottomOprBtnPosAdjY)
            :addTo(self.bottomOprPanel_)

        if i ~= #bottomOprBtnLablStrs then
            --todo
            local dividLineBot = display.newSprite("#hall_divLine_botPanel.png")
            dividLineBot:pos(display.width * i / 6, dividLineBot:getContentSize().height / 2)
                :addTo(self.bottomOprPanel_)
        end
        
    end

    self:addPropertyObservers()

    -- if nk.config.CHRISTMAS_THEME_ENABLED then
    --     if not nk.userData.__christmas then
    --         audio.playMusic("sounds/Christmas.mp3", false)
    --         nk.userData.__christmas = true
    --     end

    --     display.addSpriteFrames("christmas_texture.plist", "christmas_texture.png")

    --     -- 大的灯笼
    --     self.smallLanternNode = display.newNode()
    --         :pos(display.cx - 370, display.cy - 23)
    --         :addTo(self)

    --     self.smallLanternIcon_ = display.newSprite("#christmas-big-lantern.png")
    --         :pos(0, -23)
    --         :addTo(self.smallLanternNode)

    --     local smallLanternSequenceAct = transition.sequence({
    --         cc.RotateTo:create(5,10), 
    --         cc.RotateTo:create(5,-10)
    --         })
    --     self.smallLanternNode:runAction(cc.RepeatForever:create(smallLanternSequenceAct))

    --     -- 小的灯笼
    --     self.bigLanternNode = display.newNode()
    --         :pos(display.cx - 300, display.cy - 17)
    --         :addTo(self)

    --     self.bigLanternIcon_ = display.newSprite("#christmas-small-lantern.png")
    --         :pos(0, -73)
    --         :addTo(self.bigLanternNode)

    --     local bigLanternSequenceAct = transition.sequence({
    --         cc.RotateTo:create(5,10), 
    --         cc.RotateTo:create(5,-10)
    --         })
    --     self.bigLanternNode:runAction(cc.RepeatForever:create(bigLanternSequenceAct))

    --     -- 圣诞袜子
    --     self.socksNode_ = display.newNode()
    --         :pos(display.c_left + 250 , display.cy - 23)
    --         :addTo(self)

    --     self.socksIcon_ = display.newSprite("#chiristmas-sock.png")
    --         :pos(0 ,  - 73)
    --         :addTo(self.socksNode_)

    --     local socksSequenceAct = transition.sequence({
    --         cc.RotateTo:create(5,10), 
    --         cc.RotateTo:create(5,-10)
    --         })
    --     self.socksNode_:runAction(cc.RepeatForever:create(socksSequenceAct))

    --     -- Remove Logo Snow.
    --     -- self.logoSnow_ = display.newSprite("#christmas-game-logo.png")
    --     --     :pos(- display.cx + 140, display.cy - 130)
    --     --     :addTo(self.halfTopNode_)

    --     self.inviteFriendRightSnow_ = display.newSprite("#chiristmas-invite-friend-right.png")
    --         :pos(display.cx - 60, display.cy - 77)
    --         :addTo(self.halfTopNode_)

    --     self.inviteFriendDownSnow_ = display.newSprite("#chiristmas-invite-friend-down.png")
    --         :pos(display.cx - 150, display.cy - 123)
    --         :addTo(self.halfTopNode_)


    --     self.snowIcon_1 = display.newSprite("#christmas-free-chip-snow.png")
    --         :pos(-BRICK_DISTANCE * 1.5, -bgY + 54)
    --         :addTo(self.moreChipNode_)

    --     self.snowIcon_2 = display.newSprite("#christmas-normal-room-snow.png")
    --         :pos(-BRICK_DISTANCE * 0.5, -bgY + 56)
    --         :addTo(self.norHallNode_)

    --     self.snowIcon_3 = display.newSprite("#christmas-professional-room-snow.png")
    --         :pos(BRICK_DISTANCE * 0.5, -bgY + 56)
    --         :addTo(self.proHallNode_)

    --     self.snowIcon_4 = display.newSprite("#christmas-quick-room-snow.png")
    --         :pos(BRICK_DISTANCE * 1.5, -bgY + 54)
    --         :addTo(self.playNowNode_)

    --     -- 加上两张冰窗效果！
    --     local snowWindowLeftPosShift = {
    --         x = 75,
    --         y = 72
    --     }
    --     local snowWindowStateLeft = display.newSprite("#christ_snowCorner_right.png")
    --         :rotation(90)
    --         :pos(- display.cx + snowWindowLeftPosShift.x, - display.cy + BOTTOM_PANEL_HEIGHT + snowWindowLeftPosShift.y)
    --         :addTo(self.bottomPanelNode_)

    --     local snowWindowRightPosShift = {
    --         x = 75,
    --         y = 72
    --     }

    --     local snowWindowStateRight = display.newSprite("#christ_snowCorner_right.png")
    --         :pos(display.cx - snowWindowRightPosShift.x, - display.cy + BOTTOM_PANEL_HEIGHT + snowWindowRightPosShift.y)
    --         :addTo(self.bottomPanelNode_)


    --     self.userInfoSnow_ = display.newSprite("#christmas-person-informal-snow.png")
    --         :pos(-display.cx + BOTTOM_USER_INFO_WIDTH * 0.5 - 58, -display.cy + BOTTOM_PANEL_HEIGHT * 0.5 + 50)
    --         :addTo(self.bottomPanelNode_)

    --     -- 圣诞树
    --     self.settingSnowIcon_ = display.newSprite("#christmas-tree-snow.png")
    --         :pos(-display.cx + BOTTOM_USER_INFO_WIDTH + BOTTOM_MAIN_BTN_WIDTH * 3 + BOTTOM_SUB_BTN_WIDTH * 1.5 + 66, -display.cy + BOTTOM_PANEL_HEIGHT * 0.5 + 77)
    --         :addTo(self.bottomPanelNode_)

    --     -- 雪花效果
    --     self.newSnow_ = display.newNode()
    --         :addTo(self)
            
    --     local emitter = cc.ParticleSystemQuad:create("particle_texture.plist")
    --     emitter:pos(0, display.cy)
    --     emitter:addTo(self.newSnow_)
    -- end

    -- -- 宋干节
    -- if nk.config.SONGKRAN_THEME_ENABLED then

    --     display.addSpriteFrames("songkran_texture.plist", "songkran_texture.png")
        
    --     -- 左边
    --     self.songkranHallLeft_ = display.newSprite("#songkran_hall_left.png")
    --     local leftSize = self.songkranHallLeft_:getContentSize()
    --     self.songkranHallLeft_:pos(-display.cx + leftSize.width / 2, -display.cy + BOTTOM_PANEL_HEIGHT - 1 + leftSize.height / 2)
    --     self.songkranHallLeft_:addTo(self.bottomPanelNode_)
        
    --     -- 右边
    --     self.songkranHallRight_ = display.newSprite("#songkran_hall_right.png")
    --     local rightSize = self.songkranHallRight_:getContentSize()
    --     self.songkranHallRight_:pos(display.cx - rightSize.width / 2, -display.cy + BOTTOM_PANEL_HEIGHT - 1 + rightSize.height / 2)
    --     self.songkranHallRight_:addTo(self.bottomPanelNode_)

    --     -- moreChip水滴
    --     self.songKranHallMoreChip = display.newSprite("#songkran_hall_morechip.png")
    --         :pos(-BRICK_DISTANCE * 1.5, -bgY)
    --         :addTo(self.moreChipNode_)

    --     -- combat水滴
    --     self.songKranHallMoreChip = display.newSprite("#songkran_hall_combat.png")
    --         :pos(-BRICK_DISTANCE * 0.5, -bgY)
    --         :addTo(self.norHallNode_)
        
    --     -- 2 cards水滴
    --     self.songKranHallMoreChip = display.newSprite("#songkran_hall_2_cards.png")
    --         :pos(BRICK_DISTANCE * 0.5, -bgY)
    --         :addTo(self.proHallNode_)

    --     -- PlayNow水滴
    --     self.songKranHallMoreChip = display.newSprite("#songkran_hall_quickstart.png")
    --         :pos(BRICK_DISTANCE * 1.5 - 10, -bgY + 15)
    --         :addTo(self.playNowNode_)
    -- end
end

function MainHallView:addModulePromtAdPageView()
    -- body
    local promtAdAreaSize = {
        width = 244,
        height = 244
    }

    local promtAdPageViewPosFix = {
        x = - 1,
        y = 4
    }

    self.promtAdPageView_ = bm.ui.PageView.new({viewRect = cc.rect(- promtAdAreaSize.width / 2, - promtAdAreaSize.height / 2, promtAdAreaSize.width, promtAdAreaSize.height),
        direction = bm.ui.ScrollView.DIRECTION_HORIZONTAL}, AdPromtPageItem, {speed = promtAdAreaSize.width / 4, move = promtAdAreaSize.width * 2 / 3})
        :pos(self.promtChipBrickSprite_:getPositionX() + promtAdPageViewPosFix.x, self.promtChipBrickSprite_:getPositionY() + promtAdPageViewPosFix.y)
        :addTo(self.promtChipNode_)
    self.promtAdPageView_:addEventListener("ITEM_EVENT", handler(self, self.onPromtAdAction_))

    display.addSpriteFrames("hallPromtAd.plist", "hallPromtAd.png", handler(self, self.onAdPromtFrameLoaded))
end

function MainHallView:onAvatarLoadComplete_(success, sprite)
    if success then
        local oldAvatar = self.topOpreationPanel_:getChildByTag(AVATAR_TAG)
        if oldAvatar then
            oldAvatar:removeFromParent()
        end

        local sprSize = sprite:getContentSize()
        local avatarShownSize = {
            width = 60,
            height = 60
        }

        if sprSize.width > sprSize.height then
            sprite:scale(avatarShownSize.width / sprSize.width)
        else
            sprite:scale(avatarShownSize.height / sprSize.height)
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

function MainHallView:playShowAnim()
    local animTime = self.controller_.getAnimTime()

    -- Set Nil,Waiting For Anim Complete --

    -- 桌子与筹码
    -- if self.tablePos_ == 1 then
    --     self.pokerTable_:pos(0, 0)
    -- else
    --     self.pokerTable_:pos(0, -(display.cy + 320))
    -- end
    -- transition.moveTo(self.pokerTable_, {time = animTime, y = -(display.cy + 146)})
    -- transition.moveTo(self.leftChip_,   {time = animTime, y = -(display.cy - 116)})
    -- transition.moveTo(self.rightChip_,  {time = animTime, y = -(display.cy - 116)})

    -- -- 方块panel
    -- local posY = -(MORE_CHIP_PANEL_HEIGHT + BRICK_HEIGHT)
    -- local baseDelayTime = 0.05
    -- self.moreChipNode_:pos(0, posY)
    -- transition.moveTo(self.moreChipNode_, {time = animTime, y = 0, delay = animTime + baseDelayTime * 0, easing = "BACKOUT"})
    -- self.norHallNode_:pos(0, posY)
    -- transition.moveTo(self.norHallNode_, {time = animTime, y = 0, delay = animTime + baseDelayTime * 1, easing = "BACKOUT"})
    -- self.proHallNode_:pos(0, posY)
    -- transition.moveTo(self.proHallNode_, {time = animTime, y = 0, delay = animTime + baseDelayTime * 2, easing = "BACKOUT"})
    -- self.playNowNode_:pos(0, posY)
    -- transition.moveTo(self.playNowNode_, {time = animTime, y = 0, delay = animTime + baseDelayTime * 3, easing = "BACKOUT"})

    -- -- 底部panel
    -- self.bottomPanelNode_:pos(0, -BOTTOM_PANEL_HEIGHT)
    -- transition.moveTo(self.bottomPanelNode_, {time = animTime, y = 0, delay = animTime + baseDelayTime * 3})

    -- 顶部panel
    -- self.halfTopNode_:pos(0, self.gameLogo_:getContentSize().height + 150)
    -- transition.moveTo(self.halfTopNode_, {time = animTime, y = 0, delay = animTime + baseDelayTime * 3, onComplete =
    --     handler(self, function(obj)
    --         --楼下这段十分飘逸的逻辑，，
    --         --在玩家在房间内收到来自其他玩家的私人房邀请的时候
    --         --只做提示，，待到他退出到大厅的时候，并且时间间隔
    --         --5分钟之内，则弹出提示！
    --         if nk.userData["inviteRoomData"] then
    --             local tid = nk.userData["inviteRoomData"].tid
    --             local inviteName = nk.userData["inviteRoomData"].inviteName;
    --             local content_ = bm.LangUtil.getText("HALL","PERSONAL_ROOM_INVITE_CONTENT",inviteName);
    --             local currentTime_ = os.time()
    --             local leftTime_ = currentTime_ - nk.userData["inviteRoomData"].time;
    --             if leftTime_ <= 300 then
    --                 nk.ui.Dialog.new({
    --                                 messageText = content_,
    --                                 callback = function (type)
    --                                     if type == nk.ui.Dialog.SECOND_BTN_CLICK then
    --                                         nk.server:searchPersonalRoom(nil,tid)
    --                                     end
    --                                 end
    --                             })
    --                                 :show()
    --                 nk.userData["inviteRoomData"] = nil
    --                 return
    --             end
    --         end

    --         local invitePopupdateDate = nk.userDefault:getStringForKey(nk.cookieKeys.DALIY_POPUP_INVITABLE)
    --         if invitePopupdateDate ~= os.date("%Y%m%d") then

    --             local lastLoginType = nk.userDefault:getStringForKey(nk.cookieKeys.LAST_LOGIN_TYPE)
    --             if lastLoginType ~= "GUEST" and nk.userData['aUser.mlevel'] >= 3 then

    --                     local codeNum = bm.DataProxy:getData(nk.dataKeys.FARM_TIPS)
    --                     if codeNum == 1 then
    --                         local lastEnterScene = bm.DataProxy:getData(nk.dataKeys.LAST_ENTER_SCENE)
    --                         if (lastEnterScene ~= nil ) and (lastEnterScene == "RoomScene") then
    --                                 --优先弹邀请活动框
    --                             nk.userDefault:setStringForKey(nk.cookieKeys.DALIY_POPUP_INVITABLE, os.date("%Y%m%d"))
    --                             nk.ui.Dialog.new({
    --                                 hasCloseButton = true,
    --                                 messageText = bm.LangUtil.getText("DORNUCOPIA", "HALL_TIPS"), 
    --                                 callback = function (type)
    --                                     if type == nk.ui.Dialog.SECOND_BTN_CLICK then
    --                                              CornuPopup.new():show()
    --                                     elseif type == nk.ui.Dialog.FIRST_BTN_CLICK or type == nk.ui.Dialog.CLOSE_BTN_CLICK then

    --                                     end
    --                                 end
    --                             }):show()
    --                             bm.DataProxy:setData(nk.dataKeys.FARM_TIPS, -3)
    --                         end
    --                     end
    --             end
       
    
    --             local invitePopupdateDate = nk.userDefault:getStringForKey(nk.cookieKeys.DALIY_POPUP_INVITABLE)
    --             if invitePopupdateDate ~= os.date("%Y%m%d") then
    --                 --[[
    --                 nk.userDefault:setStringForKey(nk.cookieKeys.DALIY_POPUP_INVITABLE, os.date("%Y%m%d"))  
    --                 NewestActPopup.new(1,function(action)
    --                     if action == "invite" then
    --                         if self and self["onInviteBtnClick"] then
    --                             self:onInviteBtnClick()
    --                         end
    --                     elseif action == "openShop" then
    --                         if self and self["onStoreBtnClicked"] then
    --                             -- self:onStoreBtnClicked()
    --                             StorePopup.new(nil,PURCHASE_TYPE.BLUE_PAY):showPanel()
    --                         end
    --                     end
    --                 end):show()
    --                 --]]
    --             else
    --                 --从房间回来，一个feed逻辑
    --                 if nk.userData["aUser.conWinNum_"] and nk.userData["aUser.conWinNum_"] == 5 then
    --                     nk.ui.Dialog.new({
    --                                 messageText = bm.LangUtil.getText("HALL","SHARE_CONWIN_FIVE"),
    --                                 callback = function (type)
    --                                     if type == nk.ui.Dialog.SECOND_BTN_CLICK then
    --                                         nk.sendFeed:win_five_()
    --                                     end
    --                                 end
    --                             })
    --                                 :show()
    --                 elseif nk.userData["aUser.card_five_multiple_"] and nk.userData["aUser.card_five_multiple_"]==1  then
    --                    nk.ui.Dialog.new({
    --                                 messageText = bm.LangUtil.getText("HALL","SHARE_FIVE_CARD"),
    --                                 callback = function (type)
    --                                     if type == nk.ui.Dialog.SECOND_BTN_CLICK then
    --                                         nk.sendFeed:five_Card_()
    --                                     end
    --                                 end
    --                             })
    --                             :show()
    --                 end
    --             end
    --         end

    --         nk.userData["aUser.conWinNum_"] = nil;
    --         nk.userData["aUser.card_five_multiple_"] = nil;
    --     end
    --     )
    -- })
end

function MainHallView:playHideAnim()
    local animTime = self.controller_.getAnimTime()

    -- Set Nil Temporary --
    -- if self and self.pokerTable_ then
    --     --todo
    --     self.pokerTable_:removeFromParent()
    --     self.pokerTable_ = nil
    -- end
    
    -- transition.moveTo(self.halfTopNode_, {time = animTime, y = self.gameLogo_:getContentSize().height + 80})
    -- transition.moveTo(self.tableNode_, {time = animTime, y = -(MORE_CHIP_PANEL_HEIGHT + BRICK_HEIGHT)})
    -- transition.moveTo(self.halfBottomNode_, {
    --     time = animTime, 
    --     y = -(MORE_CHIP_PANEL_HEIGHT + BRICK_HEIGHT), 
    --     onComplete = handler(self, function (obj)
    --         obj:removeFromParent()
    --     end)
    -- })
    self:performWithDelay(handler(self, function(obj)
        -- body
        obj:removeFromParent()
    end), animTime)
end

function MainHallView:playSuonaMsgScrolling(suonaMsg)
    -- body
    -- self.suonaMsgQueue_ = self.suonaMsgQueue_ or {}
    -- table.insert(self.suonaMsgQueue_, suonaMsg)

    if not self.suonaMsgPlaying_ then
        -- self.suonaMsgPosXSrc = self.suonaChatInfo_:getPositionX()
        self:playSuonaMsgNext()
    end
end

function MainHallView:playSuonaMsgNext()
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
        -- Set SuonaMsg Shown To Default Msg --
        self.suonaChatInfo_:setString("点击这里使用小喇叭>>")
        self.suonaChatInfo_:setTextColor(suonaMsgShownColor.tip)
        self.suonaChatInfo_:pos(self.suonaChatMsgStrPosXSrc - self.suonaChatInfo_:getContentSize().width, 0)

        -- self.suonaBtnTop_:setOpacity(255)
        self.suonaChatInfo_:setOpacity(0)
        -- self.suonaChatInfo_:hide()

        self.suonaMsgPlaying_ = false
        return
    end

    if self.suonaIconClickTipAction_ then
        --todo
        self:stopAction(self.suonaIconClickTipAction_)
        self.suonaIconClickTipAction_ = nil

        -- self.suonaChatInfo_:setOpacity(255)
        bm.DataProxy:setData(nk.dataKeys.SUONA_USETIP_ONOFF, false)
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
    self.suonaChatInfo_:setOpacity(255) -- cc.c3b(255, 0, 255)

    self.suonaMsgAnim_ = transition.execute(self.suonaChatInfo_, cc.MoveTo:create(labelRollTime,
        cc.p(self.suonaChatMsgStrPosXDes, 0)), {delay = chatMsgPlayDelayTime / 2})

    self.suonaDelayCallHandler_ = nk.schedulerPool:delayCall(handler(self, self.playSuonaMsgNext), labelRollTime + chatMsgPlayDelayTime + chatMsgShownTimeIntval)
    -- self.delayScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.delayCallback_), 0.3 + DEFAULT_STAY_TIME + scrollTime)
end

function MainHallView:onAdPromtFrameLoaded(FileName, imgName)
    -- body
    local pageAdNum = 1

    local pageData = {}

    for i = 1, pageAdNum do
        local tabTmp = {}
        tabTmp.adImg = "hallAd_adPicDef.jpg"
        tabTmp.action = "regNextDayTip"

        table.insert(pageData, tabTmp)
    end

    self.promtAdPageView_:setData(pageData)

    -- self.promtAdLoopCallHandler_ = nk.schedulerPool:loopCall(handler(self, self.), time)
    -- nk.schedulerPool:delayCall(function()
    --     -- body
    --     self.promtAdPageView_:gotoPage(3)
    -- end, 3)
end

function MainHallView:refreshMatchAndDokbEntryUi()
    -- body
    local userLevelFact = nk.Level:getLevelByExp(nk.userData["aUser.exp"])
    if userLevelFact >= 3 or nk.userData["aUser.mlevel"] >= 3 then
        --todo
        if self then
            --todo
            -- Remove DokbEntry Sheild --
            if self.lockDokbTips_ then
                --todo
                self.lockDokbTips_:removeFromParent()
                self.lockDokbTips_ = nil
            end

            if self.lockDokbEntry_ then
                --todo
                self.lockDokbEntry_:removeFromParent()
                self.lockDokbEntry_ = nil
            end

            if self.dokbEntrySheildModel_ then
                --todo
                self.dokbEntrySheildModel_:removeFromParent()
                self.dokbEntrySheildModel_ = nil
            end

            -- Remove ProRoomEntry Sheild --
            if self.lockProRoomTips_ then
                --todo
                self.lockProRoomTips_:removeFromParent()
                self.lockProRoomTips_ = nil
            end

            if self.lockProRoom_ then
                --todo
                self.lockProRoom_:removeFromParent()
                self.lockProRoom_ = nil
            end

            if self.proRoomSheildModel_ then
                --todo
                self.proRoomSheildModel_:removeFromParent()
                self.proRoomSheildModel_ = nil
            end
        end
    else
        dump("User Level Lower Than 3!")
    end
end

function MainHallView:initUnionActEntryUi(isOpen)
    -- body

    if isOpen then
        -- display.addSpriteFrames("pokdeng_ad_texture.plist", "pokdeng_ad_texture.png")
        -- cc.ui.UIPushButton.new({normal = "#pokdeng_ad_popup_open.png"})
        --     :pos(-display.cx + 108, display.cy - 208)
        --     :addTo(self.halfTopNode_)
        --     :onButtonClicked(buttontHandler(self, self.onPokdengAdClick_))

        -- plan 1 --

        if not self._unionActEntrance then
            --todo
            local promtBtnPosShift = {
                x = 108,
                y = 208
            }

        self._unionActEntrance = cc.ui.UIPushButton.new("#hall_ic_prom.png", {scale9 = false})
            :pos(- display.cx + promtBtnPosShift.x, display.cy - promtBtnPosShift.y)
            :onButtonClicked(buttontHandler(self, self._onActPromtCallBack))
            :addTo(self.halfTopNode_)
        end
        
        -- end --


        -- plan 2 --
        -- self._unionActEntrance:setVisible(true)
        -- end --
    else

        -- plan 1 --
        if self._unionActEntrance then
            --todo
            self._unionActEntrance:removeFromParent()
            self._unionActEntrance = nil
        end

        -- end -- 

        -- plan 2 --
        -- self._unionActEntrance:setVisible(false)
        -- plan 2 --
    end
end

function MainHallView:initFirstChargeFavEntry(isOpen)
    -- body
    if isOpen then
        --todo

        if not self._firstChargeFavEntrance then
            --todo

            local firstChargeFavBtnPosAdjust = {
                x = 160,
                y = 150,
            }

            local firstChargeIconPath = nil

            if device.platform == "android" or device.platform == "windows" then
                --todo
                if nk.OnOff:check("firstchargeFavGray") then
                    --todo
                    firstChargeIconPath = "#chgFirFav_entry.png"
                else
                    firstChargeIconPath = "#chargeFav_entry.png"
                end
            elseif device.platform == "ios" then
                --todo
                if nk.OnOff:check("firstchargeFavGray") then
                    --todo
                    firstChargeIconPath = "#chgFirFav_entry.png"
                else
                    firstChargeIconPath = "#chargeFav_entry_ios.png"
                end
                -- firstChargeIconPath = "#chargeFav_entry_ios.png"
            end

            self._firstChargeFavEntrance = cc.ui.UIPushButton.new(firstChargeIconPath, {scale9 = false})
                :pos(display.cx - firstChargeFavBtnPosAdjust.x, display.cy - firstChargeFavBtnPosAdjust.y)
                :onButtonClicked(buttontHandler(self, self._onFirstChargeFavBtnCallBack))
                :addTo(self.halfTopNode_)
            -- self._firstChargeFavEntrance:setScale(0.75)
        else
            local firstChargeIconPath = nil

            if device.platform == "android" or device.platform == "windows" then
                --todo
                if nk.OnOff:check("firstchargeFavGray") then
                    --todo
                    firstChargeIconPath = "#chgFirFav_entry.png"
                else
                    firstChargeIconPath = "#chargeFav_entry.png"
                end
            elseif device.platform == "ios" then
                --todo
                if nk.OnOff:check("firstchargeFavGray") then
                    --todo
                    firstChargeIconPath = "#chgFirFav_entry.png"
                else
                    firstChargeIconPath = "#chargeFav_entry_ios.png"
                end
                -- firstChargeIconPath = "#chargeFav_entry_ios.png"
            end

            self._firstChargeFavEntrance:setButtonImage("normal", firstChargeIconPath)
            self._firstChargeFavEntrance:setButtonImage("pressed", firstChargeIconPath)
        end
    else

        if self._firstChargeFavEntrance then
            --todo
            self._firstChargeFavEntrance:removeFromParent()
            self._firstChargeFavEntrance = nil
        end

    end
end

function MainHallView:initAlmRechargeFavEntryUi(isOpen)
    -- body
    if isOpen then
        --todo
        if not self.almRechargeEntryBtn_ then
            --todo
            local chargeFavBtnPosAdjust = {
                x = 160,
                y = 150,
            }

            local reChargeIconResKey = {}

            reChargeIconResKey[1] = "#chgAgnFav_entry_nor.png"  -- nor
            reChargeIconResKey[2] = "#chgAgnFav_entry_pre.png"  -- pre
            reChargeIconResKey[3] = "#chgAgnFav_entry_nor.png"  -- dis

            self.almRechargeEntryBtn_ = cc.ui.UIPushButton.new({normal = reChargeIconResKey[1], pressed = reChargeIconResKey[2], disabled = reChargeIconResKey[3]},
                {scale9 = false})
                :onButtonClicked(buttontHandler(self, self.onAlmRechargeFavCallBack_))
                :pos(display.cx - chargeFavBtnPosAdjust.x, display.cy - chargeFavBtnPosAdjust.y)
                :addTo(self.halfTopNode_)
        end
    else
        if self.almRechargeEntryBtn_ then
            --todo
            self.almRechargeEntryBtn_:removeFromParent()
            self.almRechargeEntryBtn_ = nil
        end
    end
end

function MainHallView:initNewsActPaopTip(isOpen)
    -- body
    -- dump(nk.userData, "look for isFirst:===============")

    if isOpen then
        --todo
        if not self._newstActEntryPaopTip then
            --todo

            local paopTipPosAdjust = {
                x = 80,
                y = 215
            }

            self._newstActEntryPaopTip = display.newSprite("#hall_newstAct_entryTipPaop_com.png")
                :pos(display.cx - paopTipPosAdjust.x, display.cy - paopTipPosAdjust.y)
                :addTo(self.halfTopNode_)

            local tipsLabelPosShift = {
                x = 0,
                y = 4
            }

            local tipsFrontSize = 16
            local tipsLabel = display.newTTFLabel({text = bm.LangUtil.getText("HALL", "NEWSTACT_PAOPTIP"), size = tipsFrontSize, color = display.COLOR_WHITE, align = ui.TEXT_ALIGN_CENTER})
                :pos(self._newstActEntryPaopTip:getContentSize().width / 2 + tipsLabelPosShift.x, self._newstActEntryPaopTip:getContentSize().height / 2 - tipsLabelPosShift.y)
                :addTo(self._newstActEntryPaopTip)

            local function paopTipAnim()
                -- body
                self._newstActEntryPaopTip:setSpriteFrame(display.newSpriteFrame("hall_newstAct_entryTipPaop_lig.png"))
                self._newstActEntryPaopTip:performWithDelay(function ()
                    self._newstActEntryPaopTip:setSpriteFrame(display.newSpriteFrame("hall_newstAct_entryTipPaop_com.png"))
                        end, 0.45) 
            end

            self._newstActEntryPaopAnim = self._newstActEntryPaopTip:schedule(paopTipAnim, 0.9)

            self._newstActEntryPaopTip:performWithDelay(function ()
                if self._newstActEntryPaopAnim then
                    --todo
                    self:stopAction(self._newstActEntryPaopAnim)
                    self._newstActEntryPaopAnim = nil
                end

                self._newstActEntryPaopTip:removeFromParent()
                self._newstActEntryPaopTip = nil

                bm.DataProxy:setData(nk.dataKeys.HALL_NEWSTACT_PAOPTIP, false)
                end, 10.9)
        end
    else

        if self._newstActEntryPaopTip then
            --todo
            self._newstActEntryPaopTip:removeFromParent()
            self._newstActEntryPaopTip = nil
        end
    end
end

function MainHallView:addInviteBarBushAnim()
    -- body
    display.addSpriteFrames("anims/inviteBushBarAnim.plist", "anims/inviteBushBarAnim.png", function(fileName, imgName)
        if self.isOnCleanup_ then
            display.removeSpriteFramesWithFile("anims/inviteBushBarAnim.plist", "anims/inviteBushBarAnim.png")
            return
        end
        local frames = display.newFrames("invtAnim_tex_%d.png", 1, 16, false)
        local animation = display.newAnimation(frames, 1.2 / 16)
        -- display.setAnimationCache(animName, animation)
        local bushSprPosYAdj = 4
        local sp = display.newSprite()
        :pos(display.cx - 150, display.cy - 88 - bushSprPosYAdj)
        :addTo(self.halfTopNode_)
        transition.playAnimationForever(sp, animation)


    end)

    -- local bushSprPosYAdj = 4
    -- self.inviteBarBushAnimSpr_ = display.newSprite()
    --     :pos(display.cx - 150, display.cy - 88 - bushSprPosYAdj)
    --     :addTo(self.halfTopNode_)

    -- local function playOneRoundAnim()
    --     -- body
    --     local texNum = 16

    --     for i = 1, texNum do
    --         self.inviteBarBushAnimSpr_:performWithDelay(function()
    --             -- body
    --             self.inviteBarBushAnimSpr_:setSpriteFrame(display.newSpriteFrame("invtAnim_tex_" .. i .. ".png"))
    --         end, 0.06 * i)
    --     end
    -- end

    -- playOneRoundAnim()
    -- self.inviteBarBushAnimSpr_:schedule(playOneRoundAnim, 0.96)
end

function MainHallView:refreshSuonaTipAnim(isShow)
    -- body
    if isShow then
        --todo
        local function suonaTipsAnim()
            -- body
            if not self.suonaIconClickTipAction_ then
                --todo
                return
            end

            self.suonaChatInfo_:setOpacity(255)
            -- self.suonaChatInfo_.show()
            self.suonaChatInfo_:performWithDelay(function()
                -- body
                if not self.suonaIconClickTipAction_ then
                    --todo
                    return
                end

                self.suonaChatInfo_:setOpacity(0)
                -- self.suonaChatInfo_:hide()
            end, 0.45)
        end

        self.suonaIconClickTipAction_ = self.suonaChatInfo_:schedule(suonaTipsAnim, 0.9)

        self.suonaChatInfo_:performWithDelay(function()
            -- body
            if self.suonaIconClickTipAction_ then
                --todo
                self:stopAction(self.suonaIconClickTipAction_)
                self.suonaIconClickTipAction_ = nil

                bm.DataProxy:setData(nk.dataKeys.SUONA_USETIP_ONOFF, false)
                -- self.suonaChatInfo_:hide()
                self.suonaChatInfo_:setOpacity(0)
            end
        end, 10.9)
    else
        dump(isShow, "isSuonaUseTipShow: ===============")
    end
end

function MainHallView:refreshSigninNewActPointSate(isShow)
    -- body

    if self.signInNewIconBottom_ then
        --todo
        self.signInNewIconBottom_:setVisible(isShow)
    end
    
    -- if isShow then
    --     --todo
    --     self.signInNewIconBottom_:setVisible()
    -- else
    --     self.signInNewIconBottom_:setVisible()
    -- end
end

function MainHallView:popAdPromot()
    -- body
    AdPromotPopup.new(function(action)
        -- body

        local doActionByIns = {
            ["matchlist"] = function()
                -- body

                self:onMatchHallClick()
                -- self.controller_:showChooseMatchRoomView(self.controller_.CHOOSE_MATCH_NOR_VIEW)
            end,

            ["shoplist"] = function()
                -- body
                StorePopup.new():showPanel()
            end,

            ["invitefriends"] = function()
                -- body
                self:onInviteBtnClick()
            end,

            ["activitycenter"] = function()
                -- body
                self:onActCenterClick()
                -- local grabDealerViewTab = 3

                -- self.controller_:showChooseRoomView(self.controller_.CHOOSE_NOR_VIEW)
                -- self.controller_.view_.topTabBar_:gotoTab(grabDealerViewTab)
            end,

            ["freechips"] = function()
                -- body
                self:_onSignInBtnCallBack()
            end,

            ["openrank"] = function()
                -- body
                RankingPopup.new():show()
            end,

            ["openfriends"] = function()
                -- body
                FriendPopup.new():show()
            end,

            ["openpersondata"] = function()
                -- body
                self:onTopUserInfoBtnCallBack_()
            end,

            ["gograbdealer"] = function()
                -- body
                local grabDealerViewTab = 2

                nk.userData.DEFAULT_TAB = grabDealerViewTab
                self:onNorHallClick()
                -- self.controller_:showChooseRoomView(self.controller_.CHOOSE_NOR_VIEW)
                -- self.controller_.view_.topTabBar_:gotoTab(grabDealerViewTab)
            end,

            ["gochsnorroom"] = function()
                -- body
                local chooseNorViewTab = 1
                nk.userData.DEFAULT_TAB = chooseNorViewTab
                self:onNorHallClick()
                
                -- self.controller_.view_.mainTabBar_:gotoTab(chooseNorViewTab)
                -- self.controller_:showChooseRoomView(self.controller_.CHOOSE_NOR_VIEW)
            end,

            ["gocashroom"] = function()
                -- body
                local chooseCashViewTab = 3
                nk.userData.DEFAULT_TAB = chooseCashViewTab
                self:onNorHallClick()
            end,

            ["fillawrdaddr"] = function()
                -- body
                local isPopFillAdress = true

                self:showExchangeMarketView(isPopFillAdress)
            end
        }

        if action and doActionByIns[action] then
            --todo
            doActionByIns[action]()
        else
            dump("wrong actionType!")
        end
        -- doActionByIns[action]()
    end):show()
end

function MainHallView:popGucuRecallReward()
    -- body
    GucuReCallPopup.new():showPanel()
end

-- Top Opreation Area Btn Events --
function MainHallView:onTopUserInfoBtnCallBack_(evt)
    -- body
    nk.DReport:report({id = "userInfoClick"})
    UserInfoPopup.new(nil, {enterMatch = handler(self, self.onMatchHallClick)}):show(false)
end

function MainHallView:onGetChipBtnCallBack_(evt)
    -- body
    nk.DReport:report({id = "openStoreClick"})
    StorePopup.new():showPanel()
end

function MainHallView:onGetCashBtnCallBack_(evt)
    -- body
    nk.DReport:report({id = "openStoreClick"})

    local cashTabIndx = 2
    StorePopup.new(cashTabIndx):showPanel()
end

function MainHallView:onSettingBtnCallBack_(evt)
    -- body
    SettingHelpPopupMgr.new():showPanel()
end

function MainHallView:onMailMsgBtnCallBack_(evt)
    -- body
    nk.DReport:report({id = "openMessageClick"})
    MessageView.new():show()
end

function MainHallView:onSuonaSendBtnCallBack_(evt)
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

function MainHallView:onGiftPackBtnCallBack_(evt)
    -- body
end
-- Top Opreation Area Btn Events END --

-- Half Top Area BrickChip Events --
function MainHallView:onFBInviteBrickBtnCallBack_(evt)
    -- body
    -- Just for Test Actcenter act_push --
    -- if nk.ByActivity then
    --     --todo
    --     nk.ByActivity:clearRelatedCache()
    -- end

    -- do return end
    self.FBInviteBrickBtn_:setButtonEnabled(false)
    nk.DReport:report({id = "inviteClick"})

    InviteRecallPopup.new(self):show()
    self.FBInviteBrickBtn_:setButtonEnabled(true)
    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand{command = "event", args = {eventId = "hall_Invite_friends", label = "user hall_Invite_friends"}}
    end
end

function MainHallView:onProHallClick(evt)

    if nk.OnOff:check("privateroom") then
        -- self:onPersonalHallClick()
    else
        local tipTxt = nk.OnOff:checkTip("privateroom")

        local defaultTxt = T("暂未开放 敬请期待")
        if tipTxt then
            defaultTxt = tipTxt
        end

        nk.ui.Dialog.new({messageText = defaultTxt, secondBtnText = T("确定"), closeWhenTouchModel = true, hasFirstButton = false,
        hasCloseButton = false, callback = function (type)
            dump("Not Open  Key :privateroom")
            end
        }):show()
    end
end

function MainHallView:onNorHallClick(evt)
    -- Just for Test Actcenter act_push --
    -- if nk.ByActivity then
    --     --todo
    --     nk.ByActivity:switchServer(0) -- 切换到正式服
    -- end

    -- local panelTest = nk.ui.Panel.new(nk.ui.Panel.SIZE_LARGE)
    --     :addPanelTitleBar(display.newTTFLabel({text = "Title", size = 24, color = display.COLOR_RED, align = ui.TEXT_ALIGN_CENTER}))
    --     -- :addDecInnerTop()
    --     -- :addDecInnerBottom()
    --     :addCloseBtn()
    --     :showPanel_()
        
    -- nk.ui.Dialog.new({titleText = "领奖成功", messageText = "密码: " .. "ABC1234567", secondBtnText = "复制",
    --     callback = function(type)
    --         -- body
    --     end}):show()

    -- display.addSpriteFrames("loginreward_texture.plist", "loginreward_texture.png", function()
    --     -- body
    --     LoginRewardView.new():showPanel()
    -- end)
    
    -- RegisterAwardPopup.new(2):showPanel()

    -- local data = {
    --     addMoney = 100000,
    --     isAnim = false,
    --     contentFlag = 1,
    --     nextAddMoney = 2000000
    -- }

    -- NewerPlayRewardPopup.new(data):showPanel()

    -- WheelPopup.new():showPanel()

    -- FirChargePayGuidePopup.new(2):showPanel()
    -- SettingHelpPopupMgr.new(false, true):showPanel()
    -- UserInfoPopup.new():showPanel()
    -- GiftStorePopup.new():showPanel()
    -- do return end

    nk.DReport:report({id = "nor_enter_room"})
    self.norRoomChipBrickBtn_:setButtonEnabled(false)
    self.controller_:showChooseRoomView(self.controller_.CHOOSE_NOR_VIEW)

    -- if device.platform == "android" or device.platform == "ios" then1
    --     cc.analytics:doCommand{command = "event",
    --                 args = {eventId = "nor_enter_room", label = "user nor_enter_room"}}
    -- end
end

function MainHallView:onMatchHallClick(evt)
    -- Just for Test Actcenter act_push --
    -- if nk.ByActivity then
    --     --todo
    --     nk.ByActivity:switchServer(1) -- 切换到测试服
    -- end
    -- do return end
    self.proRoomChipBrickBtn_:setButtonEnabled(false)

    nk.DReport:report({id = "enterMatchClick"})
    if nk.OnOff:check("match") then

        local userLevelFact = nk.Level:getLevelByExp(nk.userData["aUser.exp"])
        if userLevelFact < 3 or nk.userData["aUser.mlevel"] < 3 then
            --todo
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("NEWER", "NOT_MEET_LEVEL_TIP"))
            return
        end

        self.controller_:showChooseMatchRoomView(self.controller_.CHOOSE_MATCH_NOR_VIEW)
    else
        local tipTxt = nk.OnOff:checkTip("match")
        local defaultTxt = T("暂未开放 敬请期待")

        if tipTxt then
            defaultTxt = tipTxt
        end

        nk.ui.Dialog.new({messageText = defaultTxt, secondBtnText = T("确定"), closeWhenTouchModel = true,
            hasFirstButton = false, hasCloseButton = false,
            callback = function (type)
                dump("Not Open  Key :match")
            end
        }):show()

        self.proRoomChipBrickBtn_:setButtonEnabled(true)
    end
end

function MainHallView:onPlayNowClick(evt)
    nk.DReport:report({id = "fastEnterClick"})
    local preType = bm.DataProxy:getData(nk.dataKeys.ROOM_INFO_TYPE)
    if preType == 1 or preType == nil then
        self.controller_:getEnterRoomData(nil, true)
    elseif preType==2 then
        if nk.userData["match.point"] < 10 then
            self.controller_:getEnterRoomData(nil, true)
        else
            self.controller_:getEnterCashRoomData()
        end
    end

    -- if device.platform == "android" or device.platform == "ios" then
    --     cc.analytics:doCommand{command = "event",
    --                 args = {eventId = "play_now_enter_room", label = "user play_now_enter_room"}}
    -- end
end

function MainHallView:onPersonalHallClick(evt)
    -- self.controller_:showChoosePersonalRoomView(self.controller_.CHOOSE_PERSONAL_NOR_VIEW)
    -- if device.platform == "android" or device.platform == "ios" then
    --     cc.analytics:doCommand{command = "event",
    --                 args = {eventId = "nor_enter_room", label = "user nor_enter_room"}}
    -- end
end

function MainHallView:onPromtAdAction_(evt)
    -- body
    -- dump(evt, "MainHallView:onPromtAdAction_.evt :================")
    local action = evt.data.action or "nilAction"  -- default : default Action String

    local getExecuteFuncByEvtAction = {
        ["regNextDayTip"] = function()
            -- body
            local day = 0

            if nk.NewerRegRewControl then
                day = nk.NewerRegRewControl:getNewerDay()
            end

            if day == 1 then
                local regData = {}

                regData.isPlayAnim = false
                regData.rewardNextNum = 200000
                regData.rewardDayNum = 1
                regData.isNextRewTip = true

                RegisterAwardPopup.new(regData):showPanel()
            elseif 2 == day then
                if nk.NewerRegRewControl then
                    nk.NewerRegRewControl:requestNextDayReward()
                end
            end
        end
    }

    if getExecuteFuncByEvtAction[action] then
        --todo
        getExecuteFuncByEvtAction[action]()
    end

end
-- Half Top Area BrickChip Events END --

-- Bottom Opreation Area Btn Events --
function MainHallView:onStoreBtnCallBack_(evt)
    -- body
    nk.DReport:report({id = "openStoreClick"})

    StorePopup.new():showPanel()
end

function MainHallView:_onSignInBtnCallBack()
    -- body

    -- May Not Use Somehow. --
    -- if self.moreChipModal_ then
    --     self.moreChipModal_:removeFromParent()
    --     self.moreChipModal_ = nil
    --     self.moreChipPanelNode_:removeFromParent()
    -- else
    --     if self._newstActEntryPaopAnim then
    --         --todo
    --         self:stopAction(self._newstActEntryPaopAnim)
    --         self._newstActEntryPaopAnim = nil
    --     end

    --     if self._newstActEntryPaopTip then
    --         --todo
    --         self._newstActEntryPaopTip:removeFromParent()
    --         self._newstActEntryPaopTip = nil
    --     end

    --     bm.DataProxy:setData(nk.dataKeys.HALL_NEWSTACT_PAOPTIP, false)
    --     -- 更多筹码模态
    --     self.moreChipModal_ = display.newScale9Sprite("#common_modRiAnGrey.png", 0, 0, cc.size(display.width, display.height))
    --         :addTo(self.halfBottomNode_, 2)
    --     bm.TouchHelper.new(self.moreChipModal_, handler(self, self.onModalTouch_))

    --     -- 操作栏移出动画
    --     self.moreChipPanelNode_ = display.newNode()
    --         :pos(0, - display.cy + MORE_CHIP_PANEL_HEIGHT * 1.5)
    --         :addTo(self.panelClipNode_)
    --     self.moreChipPanelNode_:setTouchEnabled(true)
    --     self.moreChipPanelNode_:moveTo(0.2, display.left, - display.cy + MORE_CHIP_PANEL_HEIGHT * 0.5)

    --     -- 背景
    --     display.newScale9Sprite("#more_chip_panel_bg.png", 0, 0, cc.size(display.width, 132))
    --         :pos(0, -4)
    --         :addTo(self.moreChipPanelNode_)
    --     display.newSprite("#more_chip_panel_arrow.png")
    --         :pos(-BRICK_DISTANCE * 1.5, MORE_CHIP_PANEL_HEIGHT * 0.5 - 6)
    --         :addTo(self.moreChipPanelNode_)

    --     -- 分割线

    --     local ToAddFarmFixPosX = 20
    --     local BRICK_GAP_DISTANCE = 150+BRICK_GAP - ToAddFarmFixPosX;

    --     local PosXFixDistance = 62
    --     for i = 1, 5 do
    --         display.newSprite("#panel_split_line.png")
    --             :pos(BRICK_GAP_DISTANCE * (i - 2)-100 - PosXFixDistance, -4)
    --             :addTo(self.moreChipPanelNode_)
    --     end

    --     local touchSize = cc.size(200, 180)
    --     -- 图标
    --     self.dailyMissionPressed_ = display.newSprite("#act_button_pressed.png", -BRICK_GAP_DISTANCE * 1.5-100 - PosXFixDistance, 10):addTo(self.moreChipPanelNode_):hide()
    --     local dailyMission = display.newSprite("#daily_mission_icon.png")
    --         :pos(-BRICK_GAP_DISTANCE * 1.5-100 - PosXFixDistance, 10)
    --         :addTo(self.moreChipPanelNode_)
    --     local dailyMissionTouch_ = display.newScale9Sprite("#common_modTransparent.png", -BRICK_GAP_DISTANCE * 1.5-100 - PosXFixDistance, 10, touchSize):addTo(self.moreChipPanelNode_)
    --     bm.TouchHelper.new(dailyMissionTouch_, handler(self, self.onDailyMissionClick))
        
    --     self.dailyBonusPressed_ = display.newSprite("#act_button_pressed.png", -BRICK_GAP_DISTANCE * 0.5-100 - PosXFixDistance, 10):addTo(self.moreChipPanelNode_):hide()
    --     local dailyBonus = display.newSprite("#daily_bonus_icon.png")
    --         :pos(-BRICK_GAP_DISTANCE * 0.5-100 - PosXFixDistance, 10)
    --         :addTo(self.moreChipPanelNode_)
    --     local dailyBonusTouch_ = display.newScale9Sprite("#common_modTransparent.png", -BRICK_GAP_DISTANCE * 0.5-100 - PosXFixDistance, 10, touchSize):addTo(self.moreChipPanelNode_)
    --     bm.TouchHelper.new(dailyBonusTouch_, handler(self, self.onDailyBonusClick))
        
    --     self.newestActivityPressed_ = display.newSprite("#act_button_pressed.png", BRICK_GAP_DISTANCE * 0.5-100 - PosXFixDistance, 10):addTo(self.moreChipPanelNode_):hide()
    --     local newestActivity = display.newSprite("#newest_activity_icon.png")
    --         :pos(BRICK_GAP_DISTANCE * 0.5-100 - PosXFixDistance, 10)
    --         :addTo(self.moreChipPanelNode_)
    --     local newestActivityTouch_ = display.newScale9Sprite("#common_modTransparent.png", BRICK_GAP_DISTANCE * 0.5-100 - PosXFixDistance, 10, touchSize):addTo(self.moreChipPanelNode_)
    --     bm.TouchHelper.new(newestActivityTouch_, handler(self, self.onNewestActivityClick))

    --     -- self.newActPoint = display.newSprite("#common_small_point.png")
    --     --     :pos(BRICK_GAP_DISTANCE * 0.5-50 - PosXFixDistance, 30)
    --     --     :addTo(self.moreChipPanelNode_)

    --     -- if nk.OnOff:check("mother") then 
    --     --     local isClickedMotherDay = bm.DataProxy:getData(nk.dataKeys.MOTHER_DAY)
    --     --     dump(isClickedMotherDay,"isClickedMotherDay")
    --     --     if isClickedMotherDay == 1 then
    --     --         bm.DataProxy:setData(nk.dataKeys.MOTHER_DAY, 1)
    --     --     else
    --     --         bm.DataProxy:setData(nk.dataKeys.MOTHER_DAY, 0)
    --     --     end
    --     -- else
    --     --      bm.DataProxy:setData(nk.dataKeys.MOTHER_DAY, 1)
    --     -- end
        
        
    --     self.luckyWheelPressed_ = display.newSprite("#act_button_pressed.png", BRICK_GAP_DISTANCE * 1.5-100 - PosXFixDistance, 10):addTo(self.moreChipPanelNode_):hide()
    --     local luckyWheel = display.newSprite("#lucky_wheel_icon.png")
    --         :pos(BRICK_GAP_DISTANCE * 1.5-100 - PosXFixDistance, 10)
    --         :addTo(self.moreChipPanelNode_)
    --     local luckyWheelTouch_ = display.newScale9Sprite("#common_modTransparent.png", BRICK_GAP_DISTANCE * 1.5-100 - PosXFixDistance, 10, touchSize):addTo(self.moreChipPanelNode_)
    --     bm.TouchHelper.new(luckyWheelTouch_, handler(self, self.onLuckyWheelClick))

    --     self.sharegamePressed_ = display.newSprite("#act_button_pressed.png", BRICK_GAP_DISTANCE * 2.5-100 - PosXFixDistance, 10):addTo(self.moreChipPanelNode_):hide()
    --     local sharegamebtn = display.newSprite("#share_game_icon.png")
    --         :pos(BRICK_GAP_DISTANCE * 2.5-100 - PosXFixDistance, 10)
    --         :addTo(self.moreChipPanelNode_)
    --     local sharegamebtnTouch_ = display.newScale9Sprite("#common_modTransparent.png", BRICK_GAP_DISTANCE * 2.5-100 - PosXFixDistance, 10, touchSize):addTo(self.moreChipPanelNode_)
    --     bm.TouchHelper.new(sharegamebtnTouch_, handler(self, self.onShareClick))

    --     local signInNewIconBottomPosShift = {
    --         x = 50,
    --         y = 25
    --     }
    --     self.signInNewIconBottom_ = display.newSprite("#common_small_point.png")
    --         :pos(BRICK_GAP_DISTANCE * 2.5 - 100 - PosXFixDistance + signInNewIconBottomPosShift.x, 10 + signInNewIconBottomPosShift.y)
    --         :addTo(self.moreChipPanelNode_)
    --         :hide()

    --     -- self._signInNewIconBottom:setScale(0.6)
    --     local isShowState = bm.DataProxy:getData(nk.dataKeys.HALL_SIGNIN_NEW)
        
    --     if isShowState then
    --         --todo
    --         self.signInNewIconBottom_:setVisible(isShowState)
    --     else
    --         self.signInNewIconBottom_:setVisible(false)
    --     end

    --     -- 农场 -- 
    --     self._iconFarmPressed = display.newSprite("#act_button_pressed.png", BRICK_GAP_DISTANCE * 3.5 - 100 - PosXFixDistance, 10):addTo(self.moreChipPanelNode_):hide()
    --     local iconFarm = display.newSprite("#hall_ic_farm.png")
    --         :pos(BRICK_GAP_DISTANCE * 3.5 - 100 - PosXFixDistance, -5)
    --         :addTo(self.moreChipPanelNode_)

    --     -- local mylevel = nk.userData["aUser.mlevel"]
    --     local userLevelFact = nk.Level:getLevelByExp(nk.userData["aUser.exp"])
    --     if userLevelFact >= 3 then
    --         display.newSprite("#common_small_point.png")
    --         :pos(BRICK_GAP_DISTANCE * 3.5-50 - PosXFixDistance, 30)
    --         :addTo(self.moreChipPanelNode_)
    --     end

    --     local _iconFarmTouch = display.newScale9Sprite("#common_modTransparent.png", BRICK_GAP_DISTANCE * 3.5 - 100 - PosXFixDistance, -5, touchSize):addTo(self.moreChipPanelNode_)
    --     bm.TouchHelper.new(_iconFarmTouch, handler(self, self.onIconFarmClick))
    --     -- 农场 --

    --     -- 文本标签
    --     display.newTTFLabel({text = bm.LangUtil.getText("HALL", "DAILY_MISSION"), color = styles.FONT_COLOR.LIGHT_TEXT, size = 24, align = ui.TEXT_ALIGN_CENTER})
    --         :pos(-BRICK_GAP_DISTANCE * 1.5-100 - PosXFixDistance, -48)
    --         :addTo(self.moreChipPanelNode_)
    --     display.newTTFLabel({text = bm.LangUtil.getText("ECODE", "TITLE"), color = styles.FONT_COLOR.LIGHT_TEXT, size = 24, align = ui.TEXT_ALIGN_CENTER})
    --         :pos(-BRICK_GAP_DISTANCE * 0.5-100 - PosXFixDistance, -48)
    --         :addTo(self.moreChipPanelNode_)
    --     display.newTTFLabel({text = bm.LangUtil.getText("HALL", "NEWEST_ACTIVITY"), color = styles.FONT_COLOR.LIGHT_TEXT, size = 24, align = ui.TEXT_ALIGN_CENTER})
    --         :pos(BRICK_GAP_DISTANCE * 0.5-100 - PosXFixDistance, -48)
    --         :addTo(self.moreChipPanelNode_)
    --     display.newTTFLabel({text = bm.LangUtil.getText("HALL", "LUCKY_WHEEL"), color = styles.FONT_COLOR.LIGHT_TEXT, size = 24, align = ui.TEXT_ALIGN_CENTER})
    --         :pos(BRICK_GAP_DISTANCE * 1.5-100 - PosXFixDistance, -48)
    --         :addTo(self.moreChipPanelNode_)
    --     display.newTTFLabel({text = bm.LangUtil.getText("HALL", "SIGN_IN"), color = styles.FONT_COLOR.LIGHT_TEXT, size = 24, align = ui.TEXT_ALIGN_CENTER})
    --         :pos(BRICK_GAP_DISTANCE * 2.5-100 - PosXFixDistance, -48)
    --         :addTo(self.moreChipPanelNode_)

    --     display.newTTFLabel({text = bm.LangUtil.getText("DORNUCOPIA", "FARM"), color = styles.FONT_COLOR.LIGHT_TEXT, size = 24, align = ui.TEXT_ALIGN_CENTER})
    --         :pos(BRICK_GAP_DISTANCE * 3.5 - 100 - PosXFixDistance, -48)
    --         :addTo(self.moreChipPanelNode_)
    -- end
end

function MainHallView:onFreeChipBtnCallBack_(evt)
    -- body
    if not self.moreFreeChipModel_ then
        --todo
        self.moreFreeChipModel_ = display.newScale9Sprite("#common_modRiAnGrey.png", 0, 0, cc.size(display.width, display.height))
            :addTo(self.halfBottomNode_, 9)
        bm.TouchHelper.new(self.moreFreeChipModel_, handler(self, self.onFreeChipModalTouch_))

        local moreFreeChipPanelModel = display.newSprite("#hall_bgMoreChipPanel.png")
        local moreFreeChipPanelSizeCal = moreFreeChipPanelModel:getContentSize()

        local moreFreeChipPanelPosYAdj = - 10
        self.moreFreeChipNode_ = display.newNode()
            :pos(- display.width * 3 / 12, - display.height / 2 + BOTOPRPANEL_HEIGHT + moreFreeChipPanelSizeCal.height / 2 + moreFreeChipPanelPosYAdj)
            :addTo(self.halfBottomNode_, 11)

        self.moreFreeChipNode_:setTouchEnabled(true)
        moreFreeChipPanelModel:addTo(self.moreFreeChipNode_)

        local moreFreeChipBtnImgKeys = {
            "#hall_btnDaliyTask.png",
            "#hall_btnCodeExchange.png",
            "#hall_btnLuckyWheel.png",
            "#hall_btnDaySignIn.png",
            "#hall_btnFarm.png"
        }

        local moreFreeChipBtnCallBacks = {
            buttontHandler(self, self.onBtnDaliyTaskCallBack_),
            buttontHandler(self, self.onBtnCodeExchangeCallBack_),
            buttontHandler(self, self.onBtnLuckyWheelCallBack_),
            buttontHandler(self, self.onBtnDaySignInCallBack_),
            buttontHandler(self, self.onBtnFarmCallBack_)
        }

        self.moreFreeChipBtns = {}

        local btnHorizontalDistance = 104
        local btnVerticalDistance = 96

        for i = 1, #moreFreeChipBtnImgKeys do
            self.moreFreeChipBtns[i] = cc.ui.UIPushButton.new({normal = moreFreeChipBtnImgKeys[i], pressed = moreFreeChipBtnImgKeys[i],
                disabled = moreFreeChipBtnImgKeys[i]}, {scale9 = false})
                :onButtonClicked(moreFreeChipBtnCallBacks[i])
                :pos(((i - 1) % 3 - 1) * btnHorizontalDistance + moreFreeChipPanelSizeCal.width / 2, (math.floor((6 - i) / 3 + 1) - 3 / 2) * btnVerticalDistance +
                    moreFreeChipPanelSizeCal.height / 2)
                :addTo(moreFreeChipPanelModel)
        end
    else
        self.moreFreeChipModel_:removeFromParent()
        self.moreFreeChipModel_ = nil
    end
end

function MainHallView:onRankBtnCallBack_(evt)
    -- body
    nk.DReport:report({id = "openRankClick"})
    RankingPopup.new():show()
end

function MainHallView:onDokbBtnCallBack_(evt)
    -- body
    local dokbActBtnIdx = 4
    self.bottomOprBtns[dokbActBtnIdx]:setButtonEnabled(false)

    display.addSpriteFrames("dokb_act.plist", "dokb_act.png", handler(self, self.onDokbActHallClick))
end

function MainHallView:onExchangeBtnCallBack_(evt)
    -- body
    local botBtnExchangeIdx = 5
    self.bottomOprBtns[botBtnExchangeIdx]:setButtonEnabled(false)
    self:showExchangeMarketView()
end

function MainHallView:onActBtnCallBack_(evt)
    -- body
    local botBtnActIdx = 6
    self.bottomOprBtns[botBtnActIdx]:setButtonEnabled(false)

    self:onActCenterClick()
end
-- Bottom Opreation Area Btn Events END --

function MainHallView:onActCenterClick()
    local botBtnActIdx = 6

    nk.DReport:report({id = "actCenterEntryClk"})
    if nk.ByActivity then
        --todo
        -- nk.ByActivity:setWebViewTimeOut(3000)
        -- nk.ByActivity:setWebViewCloseTip(bm.LangUtil.getText("NEWSTACT", "DOUBLE_CLICK_EXIT"))
        -- nk.ByActivity:setNetWorkBadTip(bm.LangUtil.getText("COMMON", "REQUEST_DATA_FAIL"))
        -- nk.ByActivity:setAnimIn(1)
        -- nk.ByActivity:setAnimOut(3)

        nk.ByActivity:display(function()
            -- body
            self.bottomOprBtns[botBtnActIdx]:setButtonEnabled(true)
        end)
        
        -- set displayForce, @param size: 0, small; 1, middle; 2, large
        -- nk.ByActivity:setup(function(data)
        --     -- body
        --     nk.ByActivity:setWebViewTimeOut(3000)
        --     nk.ByActivity:setWebViewCloseTip(bm.LangUtil.getText("NEWSTACT", "DOUBLE_CLICK_EXIT"))
        --     nk.ByActivity:setNetWorkBadTip(bm.LangUtil.getText("COMMON", "REQUEST_DATA_FAIL"))

        --     nk.ByActivity:displayForce(2, function(data)
        --         -- body
        --         dump(data, "displayForce:displayCallBack.data :==============")
        --     end, function(str)
        --         -- body
        --         dump(str, "displayForce:closeCallBack.str :================")
        --     end)
        -- end, 3)
    else
        dump("ActivityCenter Data Wrong!")
        self.bottomOprBtns[botBtnActIdx]:setButtonEnabled(true)
    end
end

function MainHallView:onPokdengAdClick_()
    PokdengAdPopup.new():show()
end

function MainHallView:onDokbActHallClick(fileName, imgName)
    -- body
    local dokbActBtnIdx = 4

    nk.DReport:report({id = "dokbClick"})
    if nk.OnOff:check("dokbAct") then
        --todo
        local userLevelFact = nk.Level:getLevelByExp(nk.userData["aUser.exp"])
        if userLevelFact < 3 or nk.userData["aUser.mlevel"] < 3 then
            --todo
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("NEWER", "NOT_MEET_LEVEL_TIP"))
            self.bottomOprBtns[dokbActBtnIdx]:setButtonEnabled(true)
            return
        end

        self.controller_:showDobkActPageView()
    else
        nk.ui.Dialog.new({messageText = T("暂未开放 敬请期待"), secondBtnText = T("确定"), closeWhenTouchModel = true, hasFirstButton = false,
            hasCloseButton = false, callback = function (type)
                if type == nk.ui.Dialog.SECOND_BTN_CLICK then
                    dump("Not Open  Key :dokbAct")
                end
            end
        }):show()

        self.bottomOprBtns[dokbActBtnIdx]:setButtonEnabled(true)
    end
end

function MainHallView:_onActPromtCallBack()
    -- body
    PromotActPopup.new():show()

     -- self.reportActRequest_ = nk.http.ReportActData(1,
     --    function(data)
     --        nk.http.cancel(self.reportActRequest_)
     --        -- body
     --    end,
     --    function(errData)
     --        nk.http.cancel(self.reportActRequest_)
     --        -- body
     --    end)

    nk.DReport:report({id = "unionActEntryClk"})
end

-- More Free Chips Btn Events --
function MainHallView:onBtnDaliyTaskCallBack_(evt)
    -- body
    DailyTasksPopup.new():show()
end

function MainHallView:onBtnCodeExchangeCallBack_(evt)
    -- body
    nk.PopupManager:addPopup(ExchangeCodePop.new())
end

function MainHallView:onBtnLuckyWheelCallBack_(evt)
    -- body
    WheelPopup.new():showPanel()
end

function MainHallView:onBtnDaySignInCallBack_(evt)
    -- body
    SignInContPopup.new():show()
end

function MainHallView:onBtnFarmCallBack_(evt)
    -- body
    local lastLoginType = nk.userDefault:getStringForKey(nk.cookieKeys.LAST_LOGIN_TYPE)
    if lastLoginType == "GUEST" then
        --todo
        -- local CornuPopup     = import("app.module.cornucopiaEx.CornuPopup")
        -- CornuPopup.new():show()
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("DORNUCOPIA", "GUEST_CANT_ACCESS_TIP"))
    elseif nk.userData['aUser.mlevel'] < 3 then
         nk.TopTipManager:showTopTip(bm.LangUtil.getText("DORNUCOPIA", "LEVEL_CANT_ACCESS_TIP"))
    else
        CornuPopup.new():show()
    end
end
-- More Free Chips Btn Events End --

function MainHallView:_onFirstChargeFavBtnCallBack()
    -- body
    local payGuideShownType = 1
    local isThirdPayOpen = true
    local isFirstCharge = true
    local payBillType = nil

    -- Change Temporary --
    -- if device.platform == "ios" then
    --     --todo
    --     StorePopup.new():showPanel()

    --     return
    -- end

    if nk.OnOff:check("firstchargeFavGray") then
        --todo
        FirChargePayGuidePopup.new():showPanel()
    else
        local params = {}

        params.isOpenThrPartyPay = isThirdPayOpen
        params.isFirstCharge = isFirstCharge
        params.sceneType = payGuideShownType
        params.payListType = payBillType

        PayGuide.new(params):show() 
    end
end

function MainHallView:onAlmRechargeFavCallBack_(evt)
    -- body
    AgnChargePayGuidePopup.new():showPanel()
end

function MainHallView:onFreeChipModalTouch_(target, evt)
    if evt == bm.TouchHelper.CLICK then
        if self.moreFreeChipModel_ then
            nk.SoundManager:playSound(nk.SoundManager.CLOSE_BUTTON)
            self.moreFreeChipModel_:removeFromParent()
            self.moreFreeChipModel_ = nil
            self.moreFreeChipNode_:removeFromParent()
        end
    end
end

function MainHallView:onDailyMissionClick(target, evt)
    if evt == bm.TouchHelper.TOUCH_BEGIN then
        self.dailyMissionPressed_:show()
    elseif evt == bm.TouchHelper.TOUCH_END then
        self.dailyMissionPressed_:hide()
    elseif evt == bm.TouchHelper.CLICK then
        self.dailyMissionPressed_:hide()
        nk.SoundManager:playSound(nk.SoundManager.CLICK_BUTTON)
        DailyTasksPopup.new():show()
        -- if self.moreChipModal_ then
        --     self.moreChipModal_:removeFromParent()
        --     self.moreChipModal_ = nil
        --     self.moreChipPanelNode_:removeFromParent()
        -- end
    end
end

function MainHallView:onDailyBonusClick(target, evt)
    if evt == bm.TouchHelper.TOUCH_BEGIN then
        self.dailyBonusPressed_:show()
    elseif evt == bm.TouchHelper.TOUCH_END then
        self.dailyBonusPressed_:hide()
    elseif evt == bm.TouchHelper.CLICK then
        self.dailyBonusPressed_:hide()
        nk.SoundManager:playSound(nk.SoundManager.CLICK_BUTTON)
        nk.PopupManager:addPopup(ExchangeCodePop.new())
        -- if self.moreChipModal_ then
        --     self.moreChipModal_:removeFromParent()
        --     self.moreChipModal_ = nil
        --     self.moreChipPanelNode_:removeFromParent()
        -- end
    end
end

function MainHallView:onNewestActivityClick(target, evt)

    if device.platform == "android" or device.platform == "windows" then
        --todo
        if evt == bm.TouchHelper.TOUCH_BEGIN then
            self.newestActivityPressed_:show()
        elseif evt == bm.TouchHelper.TOUCH_END then
            self.newestActivityPressed_:hide()
        elseif evt == bm.TouchHelper.CLICK then
            self.newestActivityPressed_:hide()
            nk.SoundManager:playSound(nk.SoundManager.CLICK_BUTTON)
            NewestActPopup.new(1, function(action, param)
                if action == "playnow" then
                    self.controller_:getEnterRoomData(nil, true)
                elseif action == "gotoChoseRoomView" then
                    self.controller_:showChooseRoomView(param)
                elseif action == "invite" then
                    if self and self["onInviteBtnClick"] then
                        self:onInviteBtnClick()
                    end
                elseif action == "openShop" then
                    StorePopup.new(nil,param and param.purchaseType or nil):showPanel()
                elseif action == "goMatchRoom" then
                    -- self.controller_:showChooseMatchRoomView(self.controller_.CHOOSE_MATCH_NOR_VIEW)
                    if self and self.onMatchHallClick then
                        --todo
                        self:onMatchHallClick()
                    end
                    -- local matchDataInfo = nk.MatchConfigEx:getMatchDataById(3)

                    -- if matchDataInfo then
                    --     --todo
                    --     -- nk.runningScene.controller_.view_:onChipClick_(matchDataInfo)
                    --     -- dump(matchDataInfo, "matchDataInfo :===============")
                    --     self.controller_.view_:onChipClick_(matchDataInfo)
                    --     -- MatchApplyPopup.new(matchDataInfo):show()
                    -- else
                    --     dump("matchRoomData config Wrong!")
                    -- end
                elseif action == "clkActCenter" then
                    --todo
                    if self and self.onActCenterClick then
                        --todo
                        self:onActCenterClick()
                    end
                elseif action == "openScoreMarket" then
                    self:showExchangeMarketView()
                elseif action == "openGrab" then
                    self.moreChipModal_:removeFromParent()
                    self.moreChipModal_ = nil
                    self.moreChipPanelNode_:removeFromParent()

                    nk.userData.DEFAULT_TAB = 2
                    self:onNorHallClick()
                end
            end):show()

            -- if self.moreChipModal_ then
            --     self.moreChipModal_:removeFromParent()
            --     self.moreChipModal_ = nil
            --     self.moreChipPanelNode_:removeFromParent()
            -- end

        end
    elseif device.platform == "ios" then
        --todo
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("HALL", "NOTOPEN"))
    end
end

function MainHallView:onLuckyWheelClick(target, evt)
    if evt == bm.TouchHelper.TOUCH_BEGIN then
        self.luckyWheelPressed_:show()
    elseif evt == bm.TouchHelper.TOUCH_END then
        self.luckyWheelPressed_:hide()
    elseif evt == bm.TouchHelper.CLICK then
        self.luckyWheelPressed_:hide()
        nk.SoundManager:playSound(nk.SoundManager.CLICK_BUTTON)

        WheelPopup.new():showPanel()
        
        -- if self.moreChipModal_ then
        --     self.moreChipModal_:removeFromParent()
        --     self.moreChipModal_ = nil
        --     self.moreChipPanelNode_:removeFromParent()
        -- end
    end
end

function MainHallView:onShareClick(target,evt)
    if evt == bm.TouchHelper.TOUCH_BEGIN then
        self.sharegamePressed_:show()
    elseif evt == bm.TouchHelper.TOUCH_END then
        self.sharegamePressed_:hide()
    elseif evt == bm.TouchHelper.CLICK then
        self.sharegamePressed_:hide()
        nk.SoundManager:playSound(nk.SoundManager.CLICK_BUTTON)

        -- local feedData = clone(bm.LangUtil.getText("FEED", "FREE_COIN"))
        --     nk.Facebook:shareFeed(feedData, function(success, result)
        --     print("FEED.FREE_COIN result handler -> ", success, result)
        --     if not success then
        --         nk.TopTipManager:showTopTip(bm.LangUtil.getText("FEED", "SHARE_FAILED")) 
        --      else
        --         nk.TopTipManager:showTopTip(bm.LangUtil.getText("FEED", "SHARE_SUCCESS")) 
        --      end
        -- end)
        
        -- nk.sendFeed:free_coin_()
        
        SignInContPopup.new():show()

        -- if self.moreChipModal_ then
        --     self.moreChipModal_:removeFromParent()
        --     self.moreChipModal_ = nil
        --     self.moreChipPanelNode_:removeFromParent()
        -- end
    end
end

function MainHallView:onIconFarmClick(target, event)
    -- body
    if event == bm.TouchHelper.TOUCH_BEGIN then
        self._iconFarmPressed:show()
    elseif event == bm.TouchHelper.TOUCH_END then
        self._iconFarmPressed:hide()
    elseif event == bm.TouchHelper.CLICK then
        self._iconFarmPressed:hide()
        nk.SoundManager:playSound(nk.SoundManager.CLICK_BUTTON)

        -- 添加弹出窗 -- 
        local lastLoginType = nk.userDefault:getStringForKey(nk.cookieKeys.LAST_LOGIN_TYPE)
        if lastLoginType == "GUEST" then
            --todo
            -- local CornuPopup     = import("app.module.cornucopiaEx.CornuPopup")
            -- CornuPopup.new():show()
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("DORNUCOPIA", "GUEST_CANT_ACCESS_TIP"))
        elseif nk.userData['aUser.mlevel'] < 3 then
             nk.TopTipManager:showTopTip(bm.LangUtil.getText("DORNUCOPIA", "LEVEL_CANT_ACCESS_TIP"))
        else
            CornuPopup.new():show()
        end
    end
end

function MainHallView:onUpdateVerBtnClicked()
    local updata = bm.DataProxy:getData(nk.dataKeys.UPDATE_INFO)
    if not updata then
        return
    end

    if not updata.type then
        return
    end

    if 1 == updata.type then
        nk.ui.Dialog.new({
            hasCloseButton = false,
            messageText = updata.prizedesc or "", 
            firstBtnText = bm.LangUtil.getText("UPDATE", "DO_LATER"),
            secondBtnText = bm.LangUtil.getText("UPDATE", "UPDATE_NOW"), 
            callback = function (type)
                if type == nk.ui.Dialog.FIRST_BTN_CLICK then
                    
                elseif type == nk.ui.Dialog.SECOND_BTN_CLICK then
                    self:checkToUpdate()
                end
            end
        }):show()
    elseif 2 == updata.type then
        if not updata.hasGetPrize or (updata.hasGetPrize == 0) then

            self.getUpdateRequestId_ = nk.http.GetUpdateVerReward(function(data)
                self.getUpdateRequestId_ = nil
                if data and data.money and data.getmoney then
                    local version = BM_UPDATE and BM_UPDATE.VERSION or nk.Native:getAppVersion()
                    nk.userData["aUser.money"] = data.money
                    nk.TopTipManager:showTopTip(string.format("ยินดีด้วยค่ะ คุณได้รับรางวัล %s ชิป เวอร์ชั่นปัจจุบันของคุณ:V%s.",(data.getmoney or 0),version) )
                    updata.hasGetPrize = 1
                    bm.DataProxy:setData(nk.dataKeys.UPDATE_INFO,updata)

                end
            end, function(errData)
                self.getUpdateRequestId_ = nil
                -- body
            end)
        end
    end
end

function MainHallView:showExchangeMarketView(isShowAddFill)
    nk.DReport:report({id = "openMarketClick"})

    local exchgMarketView = ExcMarketView.new(self.controller_):showPanel()
    exchgMarketView:setParentView(self)

    local botBtnExchangeIdx = 5
    self.bottomOprBtns[botBtnExchangeIdx]:setButtonEnabled(true)

    if isShowAddFill and type(isShowAddFill) == "boolean" then
        --todo
        exchgMarketView:onShowAddressPopul_()
    end
end

-- function MainHallView:onSetNewerGuideDay(day)
--     day = checkint(day)
--     if day == 0 then
--         -- if self.newerGuideBtn_ then
--             -- self.newerGuideBtn_:removeFromParent()
--             -- self.newerGuideBtn_ = nil
--         -- end
--         self.newerGuideBtn_:hide()
--     elseif day == 1 then
--         local firstRewardFlag = nk.NewerRegRewControl:getFirstRewardFlag()

--         if firstRewardFlag then
--             self.newerGuideBtn_:hide()
--         else
--             self.newerGuideBtn_:show()
--         end

--         self.newerGuideBtn_:setButtonImage("normal","newerguide/newer_purple_up.png")
--         self.newerGuideBtn_:setButtonImage("pressed","newerguide/newer_purple_down.png")
--         local btnLabel = self.newerGuideBtn_:getButtonLabel()
--         if btnLabel then
--             btnLabel:setTextColor(cc.c3b(0xff, 0xfb, 0xde))
--         end
--         self.newerGuideBtn_:setButtonLabelString(bm.LangUtil.getText("NEWER", "GUIDE_HALL_BTN_LABEL_1"))

--     elseif day == 2 then
--         if not nk.NewerRegRewControl or (nk.NewerRegRewControl:isNextRewardDone()) then
--             self.newerGuideBtn_:hide()
--         else
--             self.newerGuideBtn_:show()
          
--             self.newerGuideBtn_:setButtonImage("normal","newerguide/newer_blue_up.png")
--             self.newerGuideBtn_:setButtonImage("pressed","newerguide/newer_blue_down.png")
--             local btnLabel = self.newerGuideBtn_:getButtonLabel()
--             if btnLabel then
--                 btnLabel:setTextColor(cc.c3b(0xfe, 0xd7, 0x6e))
--             end
--             self.newerGuideBtn_:setButtonLabelString(bm.LangUtil.getText("NEWER", "GUIDE_HALL_BTN_LABEL_2"))
--         end
        
--     end
-- end

function MainHallView:onSetUpdateVerInfo(data)
    if not data or (not data.version) then
        return
    end

    local currentVersion = nk.Native:getAppVersion()
    currentVersion = BM_UPDATE and BM_UPDATE.VERSION or currentVersion

    local numStr
    local numInt
    tb = string.split(currentVersion,".")
    if tb and #tb >= 3 then
        numStr = string.format("%02d%02d%02d",tonumber(tb[1]),tonumber(tb[2]),tonumber(tb[3]))
        numInt = tonumber(numStr)
    end

    local numStr1
    local numInt1
    tb2 = string.split(data.version,".")
    if tb and #tb >= 3 then
        numStr1 = string.format("%02d%02d%02d",tonumber(tb2[1]),tonumber(tb2[2]),tonumber(tb2[3]))
        numInt1 = tonumber(numStr1)
    end


    if numInt and numInt1 then
        if numInt < numInt1 then
            --低于目标版本号显示按钮
            self.updateVerBtn_:setVisible(true)
            data.type = 1
        elseif numInt == numInt1 then
            --等于于目标版本号显示按钮
            data.type = 2
            if data.hasGetPrize == 1 then
                self.updateVerBtn_:setVisible(false)
            else
                self.updateVerBtn_:setVisible(true)
            end
            
        elseif numInt > numInt1 then
            data.type = 3
            --高于目标版本号显示按钮
            self.updateVerBtn_:setVisible(false)
        end
    end 
end

function MainHallView:upInviteBackChips(chips)
    -- local inviteBtn = nil
    -- if self.halfTopNode_ then 
    --     inviteBtn = self.halfTopNode_:getChildByTag(999)
    -- end

    -- if inviteBtn then
    --     local inviteLabel = inviteBtn:getChildByTag(999)
    --     if inviteLabel then
    --         inviteLabel:setString(bm.LangUtil.getText("HALL", "INVITE_FRIEND", bm.formatNumberWithSplit(nk.userData.inviteBackChips)))
    --     end
    -- end
end

function MainHallView:messagePoint(hasNewMessage) 
    -- if hasNewMessage then
    --     self.newMessagePoint:show()
    -- else 
    --     self.newMessagePoint:hide()
    -- end
end

function MainHallView:hallNewIcon(isOpen)
    -- if isOpen == 1 then
    --     self.newActHallPoint = display.newSprite("#newIcon.png")
    --     --:pos(-230,30)
    --     :addTo(self.moreChipNode_)
    --      local bgY = display.cy - (MORE_CHIP_PANEL_HEIGHT + BRICK_HEIGHT * 0.5)
    --     -- local tempW,tempH = self.moreChipNode_:getContentSize()
    --     --BRICK_WIDTH - 16, BRICK_HEIGHT
    --     local tempW = (BRICK_WIDTH - 16)/2
    --     local tempH = (BRICK_HEIGHT - 16)/2
    --      self.newActHallPoint:pos(-BRICK_DISTANCE * 1.5 +tempW, -bgY +tempH)
    -- else

    -- end
end

function MainHallView:checkToUpdate()
    local params = {
        device = (device.platform == "windows" and "android" or device.platform), 
        pay = (device.platform == "windows" and "android" or device.platform), 
        noticeVersion = "noticeVersion",
        osVersion = BM_UPDATE and BM_UPDATE.VERSION or nk.Native:getAppVersion(),
        version = BM_UPDATE and BM_UPDATE.VERSION or nk.Native:getAppVersion(),
        sid = appconfig.ROOT_CGI_SID
    }
    
    if IS_DEMO then
        params.demo = 1
    end

    nk.http.post_url(appconfig.VERSION_CHECK_URL, params, function (data)
        if data then
            local retData = json.decode(data)
            self:checkUpdate(retData.curVersion, retData.verTitle, retData.verMessage, retData.updateUrl)
        end
    end, function()
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("COMMON", "BAD_NETWORK"))
    end)
end

function MainHallView:checkUpdate(curVersion, verTitle, verMessage, updateUrl)
    local latestVersionNum = bm.getVersionNum(curVersion)
    local installVersionNum = bm.getVersionNum(BM_UPDATE.VERSION)
    -- print("latestVersionNum:"..latestVersionNum)
    -- print("installVersionNum:"..installVersionNum)

    if latestVersionNum <= installVersionNum then
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("UPDATE", "HAD_UPDATED"))
    else
        UpdatePopup.new(verTitle, verMessage, updateUrl):show()
    end
end

function MainHallView:addPropertyObservers()
    self.nickObserverHandler_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "aUser.name", handler(self, function (obj, name)
        if obj and obj.userName_ then
            obj.userName_:setString(nk.Native:getFixedWidthText("", 24, name, 200))
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

    -- self.levelObserverHandle_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "aUser.mlevel", handler(self, function (obj, level)
    --     obj.level_:setString(bm.LangUtil.getText("COMMON", "LEVEL", level))
    -- end))

    self.experienceObserverHandle_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "aUser.exp", handler(self, function (obj, experience)
        if experience then
            --todo
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

                    -- if obj.refreshMatchAndDokbEntryUi then
                    --     --todo
                    --     obj:refreshMatchAndDokbEntryUi()
                    -- end

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
                -- if obj.refreshMatchAndDokbEntryUi then
                --     --todo
                --     obj:refreshMatchAndDokbEntryUi()
                -- end
            end
        end
    end))

    -- self.discountObserverHandle_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "__user_discount", function(discount)
    --     if discount and discount > 1 then
    --         self.discountTagBg_:show()
    --         self.discountTagText_:show():setString(string.format("%+d%%", math.round((discount - 1) * 100)))
    --     else
    --         self.discountTagBg_:hide()
    --         self.discountTagText_:hide()
    --     end
    -- end)

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

    self.userOnlineObserverHandle_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "USER_ONLINE", handler(self, function (obj, userOnline)
        -- if obj and obj.userOnline_ then
        --     obj.userOnline_:setString(bm.LangUtil.getText("HALL", "USER_ONLINE", bm.formatNumberWithSplit(userOnline)))
        -- end
    end))

    self.onNewMessageDataObserver = bm.DataProxy:addDataObserver(nk.dataKeys.NEW_MESSAGE, handler(self, self.messagePoint))
    -- self.onNewActDataObserver = bm.DataProxy:addDataObserver(nk.dataKeys.MOTHER_DAY, handler(self, self.actPoint))
    self.onHallNewsIconObserver = bm.DataProxy:addDataObserver(nk.dataKeys.OPEN_ACT,handler(self, self.hallNewIcon))
    self.onHallInviteChipsObserver = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "inviteBackChips", handler(self, self.upInviteBackChips))
    self.onSignInNewPointActObserver = bm.DataProxy:addDataObserver(nk.dataKeys.HALL_SIGNIN_NEW, handler(self, self.refreshSigninNewActPointSate))

    -- self.onUnionActOnOffObserver = bm.DataProxy:addDataObserver(nk.dataKeys.UNIONACT_ONOFF, handler(self, self.initUnionActEntryUi))
    -- self.onChargeFavOnOffObserver = bm.DataProxy:addDataObserver(nk.dataKeys.CHARGEFAV_ONOFF, handler(self, self.initFirstChargeFavEntry))
    -- self.onAlmRechargeFavOnOffObserver = bm.DataProxy:addDataObserver(nk.dataKeys.ALMRECHARGEFAV_ONOFF, handler(self, self.initAlmRechargeFavEntryUi))
    -- self.onNewstActPaopTipObserver = bm.DataProxy:addDataObserver(nk.dataKeys.HALL_NEWSTACT_PAOPTIP, handler(self, self.initNewsActPaopTip))
    self.onSuonaTipsObserver = bm.DataProxy:addDataObserver(nk.dataKeys.SUONA_USETIP_ONOFF, handler(self, self.refreshSuonaTipAnim))
    -- self.onUpdateVerInfoObserver = bm.DataProxy:addDataObserver(nk.dataKeys.UPDATE_INFO, handler(self, self.onSetUpdateVerInfo))

    -- self.onNewerGuideDayObserver = bm.DataProxy:addDataObserver(nk.dataKeys.NEWER_GUIDE_DAY, handler(self, self.onSetNewerGuideDay))
end

function MainHallView:removePropertyObservers()
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.name", self.nickObserverHandler_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.money", self.moneyObserverHandler_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "match.point", self.cashNumChangeObserverHandler_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.mlevel", self.levelObserverHandle_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.exp", self.experienceObserverHandle_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.micon", self.avatarUrlObserverHandle_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "USER_ONLINE", self.userOnlineObserverHandle_)
    -- bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "__user_discount", self.discountObserverHandle_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "inviteBackChips",self.onHallInviteChipsObserver)

    -- bm.DataProxy:removeDataObserver(nk.dataKeys.NEW_MESSAGE, self.onNewMessageDataObserver)
    -- bm.DataProxy:removeDataObserver(nk.dataKeys.MOTHER_DAY, self.onNewActDataObserver)
    bm.DataProxy:removeDataObserver(nk.dataKeys.OPEN_ACT, self.onHallNewsIconObserver)
    bm.DataProxy:removeDataObserver(nk.dataKeys.HALL_SIGNIN_NEW, self.onSignInNewPointActObserver)
    -- bm.DataProxy:removeDataObserver(nk.dataKeys.UNIONACT_ONOFF, self.onUnionActOnOffObserver)
    -- bm.DataProxy:removeDataObserver(nk.dataKeys.CHARGEFAV_ONOFF, self.onChargeFavOnOffObserver)
    -- bm.DataProxy:removeDataObserver(nk.dataKeys.ALMRECHARGEFAV_ONOFF, self.onAlmRechargeFavOnOffObserver)
    -- bm.DataProxy:removeDataObserver(nk.dataKeys.HALL_NEWSTACT_PAOPTIP, self.onNewstActPaopTipObserver)
    bm.DataProxy:removeDataObserver(nk.dataKeys.SUONA_USETIP_ONOFF, self.onSuonaTipsObserver)
    -- bm.DataProxy:removeDataObserver(nk.dataKeys.UPDATE_INFO,self.onUpdateVerInfoObserver)
    -- bm.DataProxy:removeDataObserver(nk.dataKeys.NEWER_GUIDE_DAY,self.onNewerGuideDayObserver)
end

function MainHallView:onEnter()
    -- body
    -- Cleanup Texture Login && Update --
    display.removeSpriteFramesWithFile("login_th.plist", "login_th.png")
    display.removeSpriteFramesWithFile("update_texture.plist", "update_texture.png")

    if self.promtAdPageView_ then
        --todo
        self.promtAdPageView_:update()
    end
end

function MainHallView:onExit()
    -- body
    self:removePropertyObservers()
    nk.ImageLoader:cancelJobByLoaderId(self.userAvatarLoaderId_)

    if self.lvRequest_ then
        nk.Level:cancel(self.lvRequest_)
        self.lvRequest_ = nil
    end

    if self._coinAnim then
        --todo
        self:stopAction(self._coinAnim)
        self._coinAnim = nil
    end

    if self._newstActEntryPaopAnim then
        --todo
        self:stopAction(self._newstActEntryPaopAnim)
        bm.DataProxy:setData(nk.dataKeys.HALL_NEWSTACT_PAOPTIP, false)

        self._newstActEntryPaopAnim = nil
    end

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

    if self.suonaIconClickTipAction_ then
        --todo
        self:stopAction(self.suonaIconClickTipAction_)
        self.suonaIconClickTipAction_ = nil
        bm.DataProxy:setData(nk.dataKeys.SUONA_USETIP_ONOFF, false)
    end

    if self.getUpdateRequestId_ then
        nk.http.cancel(self.getUpdateRequestId_)
        self.getUpdateRequestId_ = nil
    end
end

function MainHallView:onCleanup()
    if nk.config.CHRISTMAS_THEME_ENABLED then
        audio.stopMusic(true)
    end

	display.removeSpriteFramesWithFile("anims/inviteBushBarAnim.plist", "anims/inviteBushBarAnim.png")
    display.removeSpriteFramesWithFile("hallPromtAd.plist", "hallPromtAd.png")

    self.isOnCleanup_ = true
end

return MainHallView