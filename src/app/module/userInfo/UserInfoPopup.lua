--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-03-14 12:03:17
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: UserInfoPopup.lua Reconstructed By Tsing7x.
--

local GiftStorePopup = import("app.module.store.GiftStorePopup")
local HelpPopup = import("app.module.settingHelp.SettingHelpPopupMgr")
local UpgradePopup = import("app.module.upgrade.UpgradePopup")
local LoadGiftControl = import("app.module.store.LoadGiftControl")
local SuonaUsePopup = import("app.module.suona.SuonaUsePopup")
local ExcMarketView = import("app.module.exchgMarket.ExcMarketView")

local UserInfoController = import(".UserInfoController")
local MyProptyAffixLineListItem = import(".MyProptyAffixLineListItem")

local BankPswSetUnlockPopup = import(".views.BankPswSetUnlockPopup")
local UsrRewRecordPopup = import(".views.UsrRewRecordPopup")

local PANEL_WIDTH = 790
local PANEL_HEIGHT = 470

local PANELLEFTOPR_WIDTH = 0
local PANELTOPOPR_HEIGHT = 0

local AVATAR_TAG = 100

local UserInfoPopup = class("UserInfoPopup", nk.ui.Panel)
local logger = bm.Logger.new("UserInfoPopup")

function UserInfoPopup:ctor(defaultTabIdx, params)
    self:setNodeEventEnabled(true)
    self.super.ctor(self, {PANEL_WIDTH, PANEL_HEIGHT})

    self.controller_ = UserInfoController.new(self)
    self.defaultTabIdx_ = defaultTabIdx or 1
    self.popupParams_ = params

    self.controller_:setWareGiftId(nk.userData["aUser.gift"])

    display.addSpriteFrames("usrInfo_texture.plist", "usrInfo_texture.png", handler(self, self.onUsrInfoTextureLoaded_))
end

function UserInfoPopup:onUsrInfoTextureLoaded_(fileName, imgName)
    -- body
    local panelBorWidth = 6

    -- Opr Area Left Panel --
    local leftPanelAreaModel = display.newSprite("#usrInfo_bgLeftPanel.png")
    local leftPanelAreaSizeCal = leftPanelAreaModel:getContentSize()

    local leftOprPanelSizeHeightFixBor = 3

    local leftPanelBlkSize = {
        width = leftPanelAreaSizeCal.width,
        height = PANEL_HEIGHT - panelBorWidth * 2 + leftOprPanelSizeHeightFixBor * 2
    }

    local leftOprPanelAreaBlkPosXFix = 2
    local leftOprPanelAreaBlkWidthFix = 3

    PANELLEFTOPR_WIDTH = leftPanelAreaSizeCal.width - leftOprPanelAreaBlkWidthFix * 2

    local leftPanelAreaBlkOutSide = display.newScale9Sprite("#usrInfo_bgLeftPanel.png", - PANEL_WIDTH / 2 + leftPanelBlkSize.width / 2 + panelBorWidth - leftOprPanelAreaBlkPosXFix, 0,
        cc.size(leftPanelBlkSize.width, leftPanelBlkSize.height))
        :addTo(self)

    local shdDecBorder = display.newSprite("#usrInfo_decOutlBor.png")
        :addTo(self)

    -- Add A Transparent Model For Better Visual Effect --
    local leftPanelAreaBlkInner = display.newScale9Sprite("#common_modTransparent.png", - PANEL_WIDTH / 2 + leftPanelBlkSize.width / 2 + panelBorWidth - leftOprPanelAreaBlkPosXFix, 0,
        cc.size(leftPanelBlkSize.width, leftPanelBlkSize.height))
        :addTo(self)

    local userHeadImgMagins = {
        top = 28,
        left = 26
    }

    self.usrHeadImgBg_ = display.newSprite("#usrInfo_bgUserHeadImg.png")
    local userHeadImgBgSize = self.usrHeadImgBg_:getContentSize()

    self.usrHeadImgBg_:pos(leftPanelAreaSizeCal.width / 2, leftPanelBlkSize.height - userHeadImgBgSize.height / 2 - userHeadImgMagins.top)
        :addTo(leftPanelAreaBlkInner)

    local userAvatar = display.newSprite("#common_female_avatar.png")
        :pos(userHeadImgBgSize.width / 2, userHeadImgBgSize.height / 2)
        :addTo(self.usrHeadImgBg_, 1, AVATAR_TAG)

    local usrAvatarSizeBorFix = 2

    userAvatar:scale((userHeadImgBgSize.width - usrAvatarSizeBorFix * 2) / userAvatar:getContentSize().width)

    self.userAvatarLoaderId_ = nk.ImageLoader:nextLoaderId()

    if nk.config.GIFT_SHOP_ENABLED and nk.userData.GIFT_SHOP == 1 then
        --todo
        local usrGiftBtnImgPosXFix = 5

        self.usrGiftChangeBtn_ = cc.ui.UIPushButton.new({normal = "#usrInfo_btnGiftWare_nor.png", pressed = "#usrInfo_btnGiftWare_pre.png", disabeld = "#usrInfo_btnGiftWare_nor.png"},
            {scale9 = false})
            :onButtonClicked(buttontHandler(self, self.onUsrGiftChangeBtnCallBack_))
            :pos(usrGiftBtnImgPosXFix, userHeadImgBgSize.height / 2)
            :addTo(self.usrHeadImgBg_, 9)

        self.usrGiftImgLoaderId_ = nk.ImageLoader:nextLoaderId()

        if self.reqUsrGiftUrlId_ then
            LoadGiftControl:getInstance():cancel(self.reqUsrGiftUrlId_)
        end

        self.reqUsrGiftUrlId_ = LoadGiftControl:getInstance():getGiftUrlById(nk.userData["aUser.gift"], function(url)
            self.reqUsrGiftUrlId_ = nil

            if url and string.len(url) > 5 then
                nk.ImageLoader:cancelJobByLoaderId(self.usrGiftImgLoaderId_)
                nk.ImageLoader:loadAndCacheImage(self.usrGiftImgLoaderId_, url, handler(self, self.usrGiftImageLoadCallback_), nk.ImageLoader.CACHE_TYPE_GIFT)
            end
        end)
    end

    local labelParam = {
        fontSize = 0,
        color = display.COLOR_BLACK
    }

    local alertAvatarBtnSize = {
        width = userHeadImgBgSize.width,
        height = 35
    }

    labelParam.fontSize = 24
    labelParam.color = display.COLOR_WHITE

    local avatarBtnPosYFix = 3
    if nk.userData.UPLOAD_PIC and nk.userData.canEditAvatar then
        --todo
        self.alertAvatarBtn_ = cc.ui.UIPushButton.new({normal = "#usrInfo_btnGreyAlertAva.png", pressed = "#usrInfo_btnGreyAlertAva.png", disabled = "#usrInfo_btnGreyAlertAva.png"},
            {scale9 = true})
            :setButtonSize(alertAvatarBtnSize.width, alertAvatarBtnSize.height)
            :setButtonLabel(display.newTTFLabel({text = "修改头像", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
            :onButtonClicked(buttontHandler(self, self.onAvatarAlertBtnCallBack_))
            :pos(userHeadImgBgSize.width / 2, alertAvatarBtnSize.height / 2 - avatarBtnPosYFix)
            :addTo(self.usrHeadImgBg_, 2)
    elseif not nk.userData.canEditAvatar then
        --todo
        self.refreshUsrAvatarBtn_ = cc.ui.UIPushButton.new({normal = "#usrInfo_btnGreyAlertAva.png", pressed = "#usrInfo_btnGreyAlertAva.png", disabled = "#usrInfo_btnGreyAlertAva.png"},
            {scale9 = true})
            :setButtonSize(alertAvatarBtnSize.width, alertAvatarBtnSize.height)
            :setButtonLabel(display.newTTFLabel({text = "刷新头像", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
            :onButtonClicked(buttontHandler(self, self.onAvatarRefreshBtnCallBack_))
            :pos(userHeadImgBgSize.width / 2, alertAvatarBtnSize.height / 2 - avatarBtnPosYFix)
            :addTo(self.usrHeadImgBg_, 2)
    end

    local usrIDMagrinTop = 12

    labelParam.fontSize = 16
    labelParam.color = display.COLOR_WHITE
    self.userID_ = display.newTTFLabel({text = "ID: " .. nk.userData["aUser.mid"], size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.userID_:pos(leftPanelAreaSizeCal.width / 2, self.usrHeadImgBg_:getPositionY() - userHeadImgBgSize.height / 2 - usrIDMagrinTop - self.userID_:getContentSize().height / 2)
        :addTo(leftPanelAreaBlkInner)

    local usrNameFieldCntMagrinTop = 32

    local usrSexIconMagrinLeft = 10
    self.usrSexIc_ = display.newSprite("#common_icFemale.png")
    self.usrSexIc_:pos(usrSexIconMagrinLeft + self.usrSexIc_:getContentSize().width / 2, self.userID_:getPositionY() - self.userID_:getContentSize().height / 2 - usrNameFieldCntMagrinTop)
        :addTo(leftPanelAreaBlkInner)

    if nk.userData.canEditAvatar then
        --todo
        bm.TouchHelper.new(self.usrSexIc_, buttontHandler(self, self.onSexIcTouched_))
    end

    self.usrSexGender_ = 2  -- default UsrSexVal: Female (2)

    local usrNameEditBlkSize = {
        width = 160,
        height = 24
    }

    local usrNameEditBlkMagrinLeft = 3

    local editNorTextFontSize = 25
    local editNorTextColor = display.COLOR_WHITE
    local usrNickNameMaxLenght = 15

    self.usrNickNameEdit_ = cc.ui.UIInput.new({image = "#common_modTransparent.png", size = cc.size(usrNameEditBlkSize.width, usrNameEditBlkSize.height), listener = handler(self,
        self.onUsrNickNameEdit_), x = usrSexIconMagrinLeft + self.usrSexIc_:getContentSize().width + usrNameEditBlkMagrinLeft + usrNameEditBlkSize.width / 2, y =
            self.usrSexIc_:getPositionY()})
        :addTo(leftPanelAreaBlkInner)

    self.usrNickNameEdit_:setFont(ui.DEFAULT_TTF_FONT, editNorTextFontSize)
    self.usrNickNameEdit_:setFontColor(editNorTextColor)

    self.usrNickNameEdit_:setPlaceHolder("")
    self.usrNickNameEdit_:setPlaceholderFont(ui.DEFAULT_TTF_FONT, editNorTextFontSize)
    self.usrNickNameEdit_:setPlaceholderFontColor(editNorTextColor)

    self.usrNickNameEdit_:setMaxLength(usrNickNameMaxLenght)
    self.usrNickNameEdit_:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    self.usrNickNameEdit_:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)

    self.usrNickName_ = nk.userData["aUser.name"] or "Name"
    self.usrNickNameEdit_:setText(self.usrNickName_)

    if not nk.userData.canEditAvatar then
        --todo
        self.usrNickNameEdit_:setTouchEnabled(false)
    end

    local nickNameEditPenIcMagrinRight = 6
    local nickNameEditIcon = display.newSprite("#usrInfo_decNamePen.png")
    nickNameEditIcon:pos(PANELLEFTOPR_WIDTH - nickNameEditPenIcMagrinRight - nickNameEditIcon:getContentSize().width / 2, self.usrSexIc_:getPositionY())
        :addTo(leftPanelAreaBlkInner)

    local usrExpPrgbParam = {
        bgWidth = 140,
        bgHeight = 8,
        fillWidth = 10,
        fillHeight = 5
    }

    local usrExpPrgbMagrinTop = 15
    self.usrExpPrgBar_ = nk.ui.ProgressBar.new("#usrInfo_prgbLayerExp.png", "#usrInfo_prgbFillerExp.png", usrExpPrgbParam)
        :pos(leftPanelAreaSizeCal.width / 2 - usrExpPrgbParam.bgWidth / 2, self.usrNickNameEdit_:getPositionY() - usrNameEditBlkSize.height / 2 - usrExpPrgbMagrinTop)
        :addTo(leftPanelAreaBlkInner)

    local usrLvInfoLblMagrinTop = 12
    labelParam.fontSize = 16
    labelParam.color = display.COLOR_WHITE
    self.usrLevel_ = display.newTTFLabel({text = "LV.0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.usrLevel_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.usrLevel_:pos(leftPanelAreaSizeCal.width / 2 - usrExpPrgbParam.bgWidth / 2, self.usrExpPrgBar_:getPositionY() - usrLvInfoLblMagrinTop - self.usrLevel_:getContentSize().height / 2)
        :addTo(leftPanelAreaBlkInner)

    self.usrExp_ = display.newTTFLabel({text = "0/0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.usrExp_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_RIGHT])
    self.usrExp_:pos(leftPanelAreaSizeCal.width / 2 + usrExpPrgbParam.bgWidth / 2, self.usrLevel_:getPositionY())
        :addTo(leftPanelAreaBlkInner)

    local leftPanelUsrProptyIcMagrins = {
        left = 18,
        bottom = 30,
        eachVect = 18
    }

    local usrProptySymbIcons = {
        "#usrInfo_icMatchPnt.png",
        "#usrInfo_icCash.png",
        "#usrInfo_icChip.png"
    }

    local usrProptyValGapIc = 8
    self.usrProptyVals_ = {}
    local usrProptySymbIcs = {}

    local usrProptySymbModel = display.newSprite("#usrInfo_icCash.png")
    local usrProptySymbSizeCal = usrProptySymbModel:getContentSize()

    labelParam.fontSize = 25
    labelParam.color = display.COLOR_WHITE
    for i = 1, #usrProptySymbIcons do
        usrProptySymbIcs[i] = display.newSprite(usrProptySymbIcons[i])
            :pos(leftPanelUsrProptyIcMagrins.left + usrProptySymbSizeCal.width / 2, leftPanelUsrProptyIcMagrins.bottom + usrProptySymbSizeCal.height / 2 * (i * 2 - 1) +
                leftPanelUsrProptyIcMagrins.eachVect * (i - 1))
            :addTo(leftPanelAreaBlkInner)

        self.usrProptyVals_[i] = display.newTTFLabel({text = "0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
        self.usrProptyVals_[i]:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
        self.usrProptyVals_[i]:pos(usrProptySymbIcs[i]:getPositionX() + usrProptySymbSizeCal.width / 2 + usrProptyValGapIc, usrProptySymbIcs[i]:getPositionY())
            :addTo(leftPanelAreaBlkInner)
    end

    local panelTopTabBarSize = {
        width = PANEL_WIDTH - panelBorWidth * 2 - PANELLEFTOPR_WIDTH,
        height = 62
    }

    PANELTOPOPR_HEIGHT = panelTopTabBarSize.height

    local topTabBarPosAdj = {
        x = 2,
        y = 5
    }

    local topTabBarBg = display.newScale9Sprite("#usrInfo_bgTopTabBar.png", PANELLEFTOPR_WIDTH / 2 - topTabBarPosAdj.x, PANEL_HEIGHT / 2 - panelBorWidth - panelTopTabBarSize.height / 2 -
        topTabBarPosAdj.y, cc.size(panelTopTabBarSize.width, panelTopTabBarSize.height))
        :addTo(self)

    local topTabDivLineWidth = 1
    local topTabBtnSize = {
        width = (panelTopTabBarSize.width - topTabDivLineWidth * 3) / 4,
        height = panelTopTabBarSize.height
    }

    local tabImgSelPosYFix = 2

    local tabBtnsDivLine = nil
    self.topTabBtns_ = {}
    self.topTabBtnGroup_ = nk.ui.CheckBoxButtonGroup.new()

    for i = 1, 4 do
        self.topTabBtns_[i] = cc.ui.UICheckBoxButton.new({on = "#common_modTransparent.png", off = "#common_modTransparent.png"}, {scale9 = true})
            :setButtonSize(topTabBtnSize.width, topTabBtnSize.height)
            :pos(topTabBtnSize.width / 2 * (i * 2 - 1) + topTabDivLineWidth * (i - 1), panelTopTabBarSize.height / 2)
            :addTo(topTabBarBg)

        if i ~= 4 then
            --todo
            tabBtnsDivLine = display.newSprite("#usrInfo_divLineTab.png")
                :pos(topTabBtnSize.width * i + topTabDivLineWidth / 2 * (i * 2 - 1), topTabBtnSize.height / 2)
                :addTo(topTabBarBg)
        end

        self.topTabBtns_[i].imgSel_ = display.newSprite("#usrInfo_bgTabBtnSelHili.png")
            :pos(0, - tabImgSelPosYFix)
            :addTo(self.topTabBtns_[i])
            :hide()

        self.topTabBtns_[i].label_ = display.newSprite("#usrInfo_decDescTi" .. i .. "_nor.png")
            :addTo(self.topTabBtns_[i])

        self.topTabBtnGroup_:addButton(self.topTabBtns_[i])
    end

    self.usrInfoContPageNode_ = display.newNode()
        :pos(PANELLEFTOPR_WIDTH / 2, - PANELTOPOPR_HEIGHT / 2)
        :addTo(self)

    self.topTabBtnGroup_:onButtonSelectChanged(buttontHandler(self, self.onTopTabBtnSelChanged_))
    self.topTabBtnGroup_:getButtonAtIndex(self.defaultTabIdx_):setButtonSelected(true)

    -- Customize Close Btn --
    local closeBtnPosAdj = {
        x = 6,
        y = 5
    }

    self.panelCloseBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnPanelClose.png", pressed = "#common_btnPanelClose.png", disabled = "#common_btnPanelClose.png"}, {scale9 = false})
        :onButtonClicked(buttontHandler(self, self.onCloseBtnCallBack_))
        :pos(PANEL_WIDTH / 2 - closeBtnPosAdj.x, PANEL_HEIGHT / 2 - closeBtnPosAdj.y)
        :addTo(self)

    nk.EditBoxManager:addEditBox(self.usrNickNameEdit_, 1)  -- P:Due To Sync Render Ui, Need To Init EditBox Refrence 1
    self:addPropertyObservers()
    self.controller_:loadUsrDataUpdate()
end

function UserInfoPopup:renderUsrInfoContPageViews(pageIdx)
    -- body
    local panelBorWidth = 6
    local pageContAreaWidth = PANEL_WIDTH - panelBorWidth * 2 - PANELLEFTOPR_WIDTH
    local pageContAreaHeight = PANEL_HEIGHT - panelBorWidth * 2 - PANELTOPOPR_HEIGHT

    local drawUsrInfoContPageByIdx = {
        [1] = function()
            -- body
            local usrInfoMainContPage = display.newNode()

            local labelParam = {
                fontSize = 0,
                color = display.COLOR_BLACK
            }

            local usrInfoMainInsLblStrs = {
                "历史胜率:",
                "牌 局 数:",
                "今日收益:",
                "获得最大奖池:",
                "历史最高资产:"
            }

            local usrInfoMainValLblMagrinLeft = 12
            local usrInfoMainIndexLblMagrins = {
                top = 35,
                left = 25,
                eachVect = 14
            }

            labelParam.fontSize = 23
            labelParam.color = display.COLOR_WHITE
            local infoMainInsLblModel = display.newTTFLabel({text = "今日收益:", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
            local infoMainInsLblSizeCal = infoMainInsLblModel:getContentSize()

            local infoMainInsLabels = {}
            self.infoMainVals_ = {}

            for i = 1, #usrInfoMainInsLblStrs do
                labelParam.color = display.COLOR_WHITE
                infoMainInsLabels[i] = display.newTTFLabel({text = usrInfoMainInsLblStrs[i], size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
                infoMainInsLabels[i]:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
                infoMainInsLabels[i]:pos(- pageContAreaWidth / 2 + usrInfoMainIndexLblMagrins.left, pageContAreaHeight / 2 - usrInfoMainIndexLblMagrins.top - infoMainInsLblSizeCal.height / 2 *
                    (i * 2 - 1) - usrInfoMainIndexLblMagrins.eachVect * (i - 1))
                    :addTo(usrInfoMainContPage)

                labelParam.color = display.COLOR_RED
                self.infoMainVals_[i] = display.newTTFLabel({text = "0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
                self.infoMainVals_[i]:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
                self.infoMainVals_[i]:pos(infoMainInsLabels[i]:getPositionX() + infoMainInsLabels[i]:getContentSize().width + usrInfoMainValLblMagrinLeft, infoMainInsLabels[i]:getPositionY())
                    :addTo(usrInfoMainContPage)
            end

            local usrHonRew2BgGap = 24
            local usrHonRew2BgMagrinBot = 18

            local honRewTitleMagrinTop = 3

            local usrHonMedalBg = display.newSprite("#usrInfo_bgRewDisplay.png")
            local usrHonMedalBgSizeCal = usrHonMedalBg:getContentSize()

            local honRewNumBgMagrinBot = 9

            local usrRewIcs = {}
            local usrRewNumBg = nil

            local usrRewNumBgModel = display.newSprite("#usrInfo_bgRewNum.png")
            local usrRewNumBgSizeCal = usrRewNumBgModel:getContentSize()

            usrHonMedalBg:pos(- usrHonMedalBgSizeCal.width / 2 - usrHonRew2BgGap / 2, - pageContAreaHeight / 2 + usrHonMedalBgSizeCal.height / 2 + usrHonRew2BgMagrinBot)
                :addTo(usrInfoMainContPage)

            bm.TouchHelper.new(usrHonMedalBg, buttontHandler(self, self.onUsrHonMedalBgTouched_))

            labelParam.fontSize = 20
            labelParam.color = display.COLOR_WHITE
            local usrHonMedalTitle = display.newTTFLabel({text = "筹码比赛奖牌", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
            usrHonMedalTitle:pos(usrHonMedalBgSizeCal.width / 2, usrHonMedalBgSizeCal.height - usrHonMedalTitle:getContentSize().height / 2 - honRewTitleMagrinTop)
                :addTo(usrHonMedalBg)

            local usrMedalIcModel = display.newSprite("#usrInfo_icMedal_2.png")
            local usrMedalIcModelSizeCal = usrMedalIcModel:getContentSize()

            local usrMedalIcGapBgCnt = 8
            local usrMedalIconMagrinEach = 24
            self.usrMedalNums_ = {}

            labelParam.fontSize = 22
            labelParam.color = display.COLOR_WHITE
            for i = 1, 3 do
                usrRewIcs[i] = display.newSprite("#usrInfo_icMedal_" .. i .. ".png")
                usrRewIcs[i]:pos(usrHonMedalBgSizeCal.width / 2 - (usrMedalIcModelSizeCal.width + usrMedalIconMagrinEach) * (i - 2), usrHonMedalBgSizeCal.height / 2 - usrMedalIcGapBgCnt)
                    :addTo(usrHonMedalBg)

                usrRewNumBg = usrRewNumBgModel:clone()
                    :pos(usrRewIcs[i]:getPositionX(), usrRewNumBgSizeCal.height / 2 + honRewNumBgMagrinBot)
                    :addTo(usrHonMedalBg)

                self.usrMedalNums_[i] = display.newTTFLabel({text = "×0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
                    :pos(usrRewNumBgSizeCal.width / 2, usrRewNumBgSizeCal.height / 2)
                    :addTo(usrRewNumBg)
            end

            self.isMedalHoned_ = false

            local usrHonCupBg = display.newSprite("#usrInfo_bgRewDisplay.png")
            usrHonCupBg:pos(usrHonMedalBgSizeCal.width / 2 + usrHonRew2BgGap / 2, - pageContAreaHeight / 2 + usrHonMedalBgSizeCal.height / 2 + usrHonRew2BgMagrinBot)
                :addTo(usrInfoMainContPage)

            bm.TouchHelper.new(usrHonCupBg, buttontHandler(self, self.onUsrHonCupBgTouched_))

            labelParam.fontSize = 20
            labelParam.color = display.COLOR_WHITE
            local usrHonCupTitle = display.newTTFLabel({text = "实物比赛奖杯", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
            usrHonCupTitle:pos(usrHonMedalBgSizeCal.width / 2, usrHonMedalBgSizeCal.height - usrHonCupTitle:getContentSize().height / 2 - honRewTitleMagrinTop)
                :addTo(usrHonCupBg)

            local usrCupIcModel = display.newSprite("#usrInfo_icCup_2.png")
            local usrCupIcModelSizeCal = usrCupIcModel:getContentSize()

            local usrCupIcGapBgCnt = 10
            local usrCupIconMagrinEach = 10
            self.usrCupNums_ = {}

            labelParam.fontSize = 22
            labelParam.color = display.COLOR_WHITE
            for i = 1, 3 do
                usrRewIcs[i] = display.newSprite("#usrInfo_icCup_" .. i .. ".png")
                usrRewIcs[i]:pos(usrHonMedalBgSizeCal.width / 2 - (usrCupIcModelSizeCal.width + usrCupIconMagrinEach) * (i - 2), usrHonMedalBgSizeCal.height / 2 - usrCupIcGapBgCnt)
                    :addTo(usrHonCupBg)

                usrRewNumBg = usrRewNumBgModel:clone()
                    :pos(usrRewIcs[i]:getPositionX(), usrRewNumBgSizeCal.height / 2 + honRewNumBgMagrinBot)
                    :addTo(usrHonCupBg)

                self.usrCupNums_[i] = display.newTTFLabel({text = "×0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
                    :pos(usrRewNumBgSizeCal.width / 2, usrRewNumBgSizeCal.height / 2)
                    :addTo(usrRewNumBg)
            end

            self.isCupHoned_ = false
            return usrInfoMainContPage
        end,

        [2] = function()
            -- body
            local usrMyPropInfoPage = display.newNode()

            -- local testLabel = display.newTTFLabel({text = "This is Test Label For MyPropInfoPage", size = 24, color = display.COLOR_WHITE, align = ui.TEXT_ALIGN_CENTER})
            --     :addTo(usrMyPropInfoPage)

            local labelParam = {
                fontSize = 0,
                color = display.COLOR_BLACK
            }

            local goPropStoreBtnSize = {
                width = 128,
                height = 45
            }

            local goPropBtnMagrinLeft = 15
            local goPropBtnPosYAdj = 5

            labelParam.fontSize = 23
            labelParam.color = display.COLOR_WHITE
            self.myPropsGoPropStoreBtn_ = cc.ui.UIPushButton.new({normal = "#usrInfo_btnGoExtStore.png", pressed = "#usrInfo_btnGoExtStore.png", disabled = "#usrInfo_btnGoExtStore.png"},
                {scale9 = false})
                :setButtonLabel(display.newTTFLabel({text = "道具商城", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
                :onButtonClicked(buttontHandler(self, self.onMyPropsGoPropStoreBtnCallBack_))
                :pos(pageContAreaWidth / 2 - goPropBtnMagrinLeft - goPropStoreBtnSize.width / 2, pageContAreaHeight / 2 - goPropStoreBtnSize.height / 2 - goPropBtnPosYAdj)
                :addTo(usrMyPropInfoPage)

            local myPropListViewSize = {
                width = 560,
                height = 336
            }

            local propListViewMagrinBot = 6

            self.myPropsListView_ = bm.ui.ListView.new({viewRect = cc.rect(- myPropListViewSize.width / 2, - myPropListViewSize.height / 2, myPropListViewSize.width, myPropListViewSize.height),
                direction = bm.ui.ListView.DIRECTION_VERTICAL}, MyProptyAffixLineListItem)
                :pos(0, - pageContAreaHeight / 2 + myPropListViewSize.height / 2 + propListViewMagrinBot)
                :addTo(usrMyPropInfoPage)

            self.myPropsListView_.itemClass_:setProptyType(1)
            self.myPropsListView_.itemClass_:setProptyActionCallBack(handler(self, self.onPropsItemActionCallBack_))

            -- self.myPropsListView_:setData({1, 2, 3, 4})
            self.myPropsListView_:setNotHide(true)

            labelParam.fontSize = 28
            labelParam.color = display.COLOR_RED
            self.noPropsHint_ = display.newTTFLabel({text = "暂无道具", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
                :pos(0, - pageContAreaHeight / 2 + myPropListViewSize.height / 2 + propListViewMagrinBot)
                :addTo(usrMyPropInfoPage)
                :hide()

            return usrMyPropInfoPage
        end,

        [3] = function()
            -- body
            local usrMyGiftInfoPage = display.newNode()

            local labelParam = {
                fontSize = 0,
                color = display.COLOR_BLACK
            }

            local goGiftStoreBtnSize = {
                width = 128,
                height = 45
            }

            local goGiftBtnMagrinLeft = 15
            local goGiftBtnPosYAdj = 5

            labelParam.fontSize = 23
            labelParam.color = display.COLOR_WHITE
            self.myGiftsGoGiftStoreBtn_ = cc.ui.UIPushButton.new({normal = "#usrInfo_btnGoExtStore.png", pressed = "#usrInfo_btnGoExtStore.png", disabled = "#usrInfo_btnGoExtStore.png"},
                {scale9 = false})
                :setButtonLabel(display.newTTFLabel({text = "礼物商城", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
                :onButtonClicked(buttontHandler(self, self.onMyGiftsGoGiftStoreBtnCallBack_))
                :pos(pageContAreaWidth / 2 - goGiftBtnMagrinLeft - goGiftStoreBtnSize.width / 2, pageContAreaHeight / 2 - goGiftStoreBtnSize.height / 2 - goGiftBtnPosYAdj)
                :addTo(usrMyGiftInfoPage)

            local giftTypeNameStrs = {
                "自己购买",
                "牌友赠送",
                "特别赠送"
            }

            local giftTypeSubBtnsMagrins = {
                left = 25,
                top = 25,
                eachHoriz = 12
            }

            local giftTypeSelBtnSize = {
                width = 125,
                height = 42
            }

            self.giftTypeSubBtns_ = {}
            self.giftTypeSubBtnGroup_ = nk.ui.CheckBoxButtonGroup.new()

            labelParam.fontSize = 24
            labelParam.color = display.COLOR_WHITE
            for i = 1, #giftTypeNameStrs do
                self.giftTypeSubBtns_[i] = cc.ui.UICheckBoxButton.new({on = "#usrInfo_btnSubGiftType_sel.png", off = "#usrInfo_btnSubGiftType_unSel.png"}, {scale9 = true})
                    :setButtonSize(giftTypeSelBtnSize.width, giftTypeSelBtnSize.height)
                    :pos(- pageContAreaWidth / 2 + giftTypeSubBtnsMagrins.left + giftTypeSelBtnSize.width / 2 * (i * 2 - 1) + giftTypeSubBtnsMagrins.eachHoriz * (i - 1), pageContAreaHeight / 2 - 
                        giftTypeSubBtnsMagrins.top - giftTypeSelBtnSize.height / 2)
                    :addTo(usrMyGiftInfoPage)

                self.giftTypeSubBtns_[i].label_ = display.newTTFLabel({text = giftTypeNameStrs[i], size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
                    :addTo(self.giftTypeSubBtns_[i])

                self.giftTypeSubBtnGroup_:addButton(self.giftTypeSubBtns_[i])
            end

            local defaultGiftIndx = 1

            self.giftTypeSubBtnGroup_:onButtonSelectChanged(buttontHandler(self, self.onSubGiftTypeSelChanged_))
            self.giftTypeSubBtnGroup_:getButtonAtIndex(defaultGiftIndx):setButtonSelected(true)

            local myGiftListViewSize = {
                width = 560,
                height = 316
            }

            local giftListViewMagrinBot = 6

            self.myGiftListView_ = bm.ui.ListView.new({viewRect = cc.rect(- myGiftListViewSize.width / 2, - myGiftListViewSize.height / 2, myGiftListViewSize.width, myGiftListViewSize.height),
                direction = bm.ui.ListView.DIRECTION_VERTICAL}, MyProptyAffixLineListItem)
                :pos(0, - pageContAreaHeight / 2 + myGiftListViewSize.height / 2 + giftListViewMagrinBot)
                :addTo(usrMyGiftInfoPage)

            self.myGiftListView_.itemClass_:setProptyType(2)

            -- self.myGiftListView_:setData({1, 2, 3, 4, 5})
            self.myGiftListView_:setNotHide(true)

            labelParam.fontSize = 28
            labelParam.color = display.COLOR_RED
            self.noGiftHint_ = display.newTTFLabel({text = "暂无礼物可用", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
                :pos(0, - pageContAreaHeight / 2 + myGiftListViewSize.height / 2 + giftListViewMagrinBot)
                :addTo(usrMyGiftInfoPage)
                :hide()

            return usrMyGiftInfoPage
        end,

        [4] = function()
            -- body
            local usrMyBankInfoPage = display.newNode()

            local labelParam = {
                fontSize = 0,
                color = display.COLOR_BLACK
            }

            self.bankContViewNode_ = display.newNode()
                :addTo(usrMyBankInfoPage)

            self.bankVerifyCodeViewNode_ = display.newNode()
                :addTo(usrMyBankInfoPage)

            self.bankNotOpenViewNode_ = display.newNode()
                :addTo(usrMyBankInfoPage)

            self.bankLowLvNotOpenViewNode_ = display.newNode()
                :addTo(usrMyBankInfoPage)

            -- Cont View Nor Useage --
            local bankUseTipsMagrins = {
                top = 16,
                left = 15,
                eachVect = 4
            }

            labelParam.fontSize = 18
            labelParam.color = display.COLOR_WHITE
            local bankUseTip1 = display.newTTFLabel({text = "1.使用步骤:输入操作金额数目>选择[存钱]或[取钱]", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
            bankUseTip1:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
            bankUseTip1:pos(- pageContAreaWidth / 2 + bankUseTipsMagrins.left, pageContAreaHeight / 2 - bankUseTipsMagrins.top - bankUseTip1:getContentSize().height / 2)
                :addTo(self.bankContViewNode_)

            local bankUseTip2 = display.newTTFLabel({text = "2.现金币保险箱仅限付费用户使用", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
            bankUseTip2:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
            bankUseTip2:pos(bankUseTip1:getPositionX(), pageContAreaHeight / 2 - bankUseTipsMagrins.top - bankUseTip1:getContentSize().height - bankUseTipsMagrins.eachVect -
                bankUseTip2:getContentSize().height / 2)
                :addTo(self.bankContViewNode_)

            local bgBankProptyNumSize = {
                width = 407,
                height = 54
            }

            local bankProptyBgMagrinTop = 12
            local bankProptyNumBg = display.newScale9Sprite("#usrInfo_bgBankProptyNum.png", - pageContAreaWidth / 2 + bankUseTipsMagrins.left + bgBankProptyNumSize.width / 2,
                bankUseTip2:getPositionY() - bankUseTip2:getContentSize().height / 2 - bankProptyBgMagrinTop - bgBankProptyNumSize.height / 2, cc.size(bgBankProptyNumSize.width,
                    bgBankProptyNumSize.height))
                :addTo(self.bankContViewNode_)

            local proptyNumLblMagrinBgLeft = 10

            labelParam.fontSize = 26
            labelParam.color = display.COLOR_BLACK
            self.proptyInputBankNum_ = display.newTTFLabel({text = "0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
            self.proptyInputBankNum_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
            self.proptyInputBankNum_:pos(proptyNumLblMagrinBgLeft, bgBankProptyNumSize.height / 2)
                :addTo(bankProptyNumBg)

            self.curInputProptyNumString = ""

            local proptyNumInBankInfoBgSize = {
                width = 132,
                height = 88
            }

            local proptyInBankInfoBgMagrins = {
                right = 14,
                top = 40
            }

            local proptyInBankInfoBg = display.newScale9Sprite("#usrInfo_bgDecBankPropty.png", pageContAreaWidth / 2 - proptyInBankInfoBgMagrins.right - proptyNumInBankInfoBgSize.width / 2,
                pageContAreaHeight / 2 - proptyInBankInfoBgMagrins.top - proptyNumInBankInfoBgSize.height / 2, cc.size(proptyNumInBankInfoBgSize.width, proptyNumInBankInfoBgSize.height))
                :addTo(self.bankContViewNode_)

            local bankProptyInsLblMagrinTop = 16

            labelParam.fontSize = 19
            labelParam.color = display.COLOR_WHITE
            local banekProptyInsLabel = display.newTTFLabel({text = "银行内资产", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
            banekProptyInsLabel:pos(proptyNumInBankInfoBgSize.width / 2, proptyNumInBankInfoBgSize.height - bankProptyInsLblMagrinTop - banekProptyInsLabel:getContentSize().height / 2)
                :addTo(proptyInBankInfoBg)

            local bankProptyNumLblMagrinBot = 16

            local proptyNumInBank = nil

            if nk.userData["aUser.bankMoney"] >= 1000000000 then
                --todo
                proptyNumInBank = bm.formatBigNumber(nk.userData["aUser.bankMoney"])
            else
                proptyNumInBank = bm.formatNumberWithSplit(nk.userData["aUser.bankMoney"])
            end

            labelParam.fontSize = 22
            labelParam.color = display.COLOR_GREEN
            self.proptyNumInBank_ = display.newTTFLabel({text = proptyNumInBank, size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
            self.proptyNumInBank_:pos(proptyNumInBankInfoBgSize.width / 2, self.proptyNumInBank_:getContentSize().height / 2 + bankProptyNumLblMagrinBot)
                :addTo(proptyInBankInfoBg)

            labelParam.fontSize = 22
            labelParam.color = display.COLOR_GREEN
            local getColumn4BtnLblByLineNum = {
                [1] = function()
                    -- body
                    return display.newSprite("#usrInfo_icDecUnlock.png")
                end,

                [2] = function()
                    -- body
                    return display.newTTFLabel({text = "存入", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
                end,

                [3] = function()
                    -- body
                    return display.newTTFLabel({text = "取出", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
                end,

                [4] = function()
                    -- body
                    return display.newSprite("#usrInfo_icDigitInputBack.png")
                end
            }

            local digitInputAreaMagrins = {
                bottom = 10,
                each = 6
            }

            local digitBtnSizeNor = {
                width = 132,
                height = 56
            }

            local digitBtnSizeLarge = {
                width = digitBtnSizeNor.width * 3 + digitInputAreaMagrins.each * 2,
                height = digitBtnSizeNor.height
            }

            self.bankDigitBtns_ = {}

            for i = 1, 4 do
                for j = 1, 4 do
                    if j == 4 then
                        --todo
                        self.bankDigitBtns_[i * 4] = cc.ui.UIPushButton.new({normal = "#usrInfo_btnBankDigitInput.png", pressed = "#usrInfo_btnBankDigitInput.png", disabled =
                            "#usrInfo_btnBankDigitInput.png"}, {scale9 = true})
                            :setButtonSize(digitBtnSizeNor.width, digitBtnSizeNor.height)
                            :onButtonClicked(buttontHandler(self, self.onBankDigitInputBtnCallBack_))
                            :pos((digitInputAreaMagrins.each + digitBtnSizeNor.width) / 2 * 3, - pageContAreaHeight / 2 + digitInputAreaMagrins.bottom + digitBtnSizeNor.height / 2 * ((4 - i) *
                                2 + 1) + digitInputAreaMagrins.each * (4 - i))
                            :addTo(self.bankContViewNode_)

                        self.bankDigitBtns_[i * 4].label_ = getColumn4BtnLblByLineNum[i]()
                            :addTo(self.bankDigitBtns_[i * 4])

                        self.bankDigitBtns_[i * 4].val_ = 14 - (i - 1)
                    elseif i == 4 then
                        --todo
                        self.bankDigitBtns_[14] = cc.ui.UIPushButton.new({normal = "#usrInfo_btnBankDigitInput.png", pressed = "#usrInfo_btnBankDigitInput.png", disabled =
                            "#usrInfo_btnBankDigitInput.png"}, {scale9 = true})
                            :setButtonSize(digitBtnSizeLarge.width, digitBtnSizeLarge.height)
                            :onButtonClicked(buttontHandler(self, self.onBankDigitInputBtnCallBack_))
                            :pos(- (digitBtnSizeNor.width + digitInputAreaMagrins.each) / 2, - pageContAreaHeight / 2 + digitInputAreaMagrins.bottom + digitBtnSizeLarge.height / 2)
                            :addTo(self.bankContViewNode_)

                        self.bankDigitBtns_[14].label_ = display.newTTFLabel({text = "0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
                            :addTo(self.bankDigitBtns_[14])

                        self.bankDigitBtns_[14].val_ = 0
                    else
                        self.bankDigitBtns_[(i - 1) * 4 + j] = cc.ui.UIPushButton.new({normal = "#usrInfo_btnBankDigitInput.png", pressed = "#usrInfo_btnBankDigitInput.png", disabled =
                            "#usrInfo_btnBankDigitInput.png"}, {scale9 = true})
                            :setButtonSize(digitBtnSizeNor.width, digitBtnSizeNor.height)
                            :onButtonClicked(buttontHandler(self, self.onBankDigitInputBtnCallBack_))
                            :pos((digitBtnSizeNor.width + digitInputAreaMagrins.each) / 2 * (j * 2 - 5), - pageContAreaHeight / 2 + digitInputAreaMagrins.bottom + digitBtnSizeNor.height / 2 *
                                ((4 - i) * 2 + 1) + digitInputAreaMagrins.each * (4 - i))
                            :addTo(self.bankContViewNode_)

                        local btnDigitVal = (i - 1) * 3 + j
                        self.bankDigitBtns_[(i - 1) * 4 + j].label_ = display.newTTFLabel({text = tostring(btnDigitVal), size = labelParam.fontSize, color = labelParam.color, align =
                            ui.TEXT_ALIGN_CENTER})
                            :addTo(self.bankDigitBtns_[(i - 1) * 4 + j])

                        self.bankDigitBtns_[(i - 1) * 4 + j].val_ = btnDigitVal
                    end
                end
            end
            -- Nor Useage Cont View End --
            self.bankContViewNode_:hide()

            -- Unusual Cont Views --
            labelParam.fontSize = 28
            labelParam.color = display.COLOR_RED

            local usrLvLowBankNotOpenTip = display.newTTFLabel({text = "你的等级没有达到五级,不能使用保险箱", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
                :addTo(self.bankLowLvNotOpenViewNode_)
            self.bankLowLvNotOpenViewNode_:hide()

            local usrBankNotOpenTip = display.newTTFLabel({text = "银行功能尚未开放", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
                :addTo(self.bankNotOpenViewNode_)
            self.bankNotOpenViewNode_:hide()

            local usrVrifyPswTipCntMagrinBgCnt = 25

            labelParam.fontSize = 25
            labelParam.color = display.COLOR_WHITE
            local usrVerifyBankPswTip = display.newTTFLabel({text = "请验证密码！", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
                :pos(0, usrVrifyPswTipCntMagrinBgCnt)
                :addTo(self.bankVerifyCodeViewNode_)

            local verifyBtnSize = {
                width = 162,
                height = 54
            }

            local usrVerifyCodeBtnMagrinBgCnt = 15

            labelParam.fontSize = 26
            labelParam.color = display.COLOR_WHITE
            self.usrVerifyBankPswBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnGreenRigOutl.png", pressed = "#common_btnGreenRigOutl.png", disabled = "#common_btnGreyLitRigOut.png"},
                {scale9 = true})
                :setButtonSize(verifyBtnSize.width, verifyBtnSize.height)
                :setButtonLabel(display.newTTFLabel({text = "现在验证", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
                :onButtonClicked(buttontHandler(self, self.onBankVerifyCodeBtnCallBack_))
                :pos(0, - verifyBtnSize.height / 2 - usrVerifyCodeBtnMagrinBgCnt)
                :addTo(self.bankVerifyCodeViewNode_)
            self.bankVerifyCodeViewNode_:hide()
            -- Unusual Cont Views End --

            return usrMyBankInfoPage
        end
    }

    self.usrInfoContPageViews_ = self.usrInfoContPageViews_ or {}

    for _, page in pairs(self.usrInfoContPageViews_) do
        if page then
            --todo
            page:hide()
        end
    end

    local page = self.usrInfoContPageViews_[pageIdx]

    if not page then
        --todo
        page = drawUsrInfoContPageByIdx[pageIdx]()
        self.usrInfoContPageViews_[pageIdx] = page
        page:addTo(self.usrInfoContPageNode_)
    end

    page:show()
end

function UserInfoPopup:onAvatarLoadComplete_(success, sprite)
    if success then
        local userOldAvatar = self.usrHeadImgBg_:getChildByTag(AVATAR_TAG)
        local usrAvatarBgSize = self.usrHeadImgBg_:getContentSize()
        local usrAvatarSizeBorFix = 2

        if userOldAvatar then
            --todo
            userOldAvatar:removeFromParent()
        end

        local sprSize = sprite:getContentSize()

        sprite:pos(usrAvatarBgSize.width / 2, usrAvatarBgSize.height / 2)
            :addTo(self.usrHeadImgBg_, 1, AVATAR_TAG)
            :scale((usrAvatarBgSize.width - usrAvatarSizeBorFix * 2) / sprSize.width)
    end
end

function UserInfoPopup:usrGiftImageLoadCallback_(success, sprite)
    -- body
    if success then
        local tex = sprite:getTexture()
        local texSize = tex:getContentSize()

        if self and self.usrGiftChangeBtn_ then
             --todo
            self.usrGiftChangeBtn_:setButtonImage("normal", tex)
            self.usrGiftChangeBtn_:setButtonImage("pressed", tex)
            self.usrGiftChangeBtn_:setButtonImage("disabled", tex)
            self.usrGiftChangeBtn_:scale(.6)
        end
    end
    self.usrGiftImgLoaderId_ = nil
end

function UserInfoPopup:setUsrDataReqLoading(loadingState)
    -- body
    if loadingState then
        --todo
        if not self.reqDataLoadingBar_ then
            --todo
            self.reqDataLoadingBar_ = nk.ui.Juhua.new()
                :addTo(self.usrInfoContPageNode_)
        end
    else
        if self.reqDataLoadingBar_ then
            --todo
            self.reqDataLoadingBar_:removeFromParent()
            self.reqDataLoadingBar_ = nil
        end
    end
end

function UserInfoPopup:onAvatarAlertBtnCallBack_(evt)
    -- body
    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand{command = "event", args = {eventId = "change_avatar_click"}, label = "user Upload Avatar_click"}
    end

    self.alertAvatarBtn_:setButtonEnabled(false)
    nk.Native:pickImage(function(success, result)
        logger:debug("nk.Native:pickImage.callback ", success, result)

        if success then
            if bm.isFileExist(result) then
                nk.TopTipManager:showTopTip(bm.LangUtil.getText("USERINFO", "UPLOAD_PIC_IS_UPLOADING"))

                local iconKey = "~#kevin&^$xie$&boyaa"
                local time = os.time()
                local sig = crypto.md5(nk.userData.uid .. "|" .. appconfig.ROOT_CGI_SID .. "|" .. time .. iconKey)
                local extraParam = {{"sid", appconfig.ROOT_CGI_SID}, {"mid", nk.userData.uid}, {"time", time}, {"sig", sig}}

                if IS_DEMO then
                    table.insert(extraParam, {"demo", 1})
                end

                network.uploadFile(function(evt)
                    if evt.name == "completed" then

                        local request = evt.request
                        local code = request:getResponseStatusCode()
                        local ret = request:getResponseString()

                        logger:debugf("REQUEST getResponseStatusCode() = %d", code)
                        logger:debugf("REQUEST getResponseHeadersString() =\n%s", request:getResponseHeadersString())
                        logger:debugf("REQUEST getResponseDataLength() = %d", request:getResponseDataLength())
                        logger:debugf("REQUEST getResponseString() =\n%s", ret)

                        local retTable = json.decode(ret)
                        if retTable.code == 1 and retTable.iconname then
                            local iconname = retTable.iconname
                            nk.http.updateUserIcon({iconname = iconname}, function(ret1)
                                if ret1 then
                                    local imgURL = ret1.micon or ""
                                    nk.userData.b_picture = imgURL
                                    nk.userData.m_picture = imgURL
                                    nk.userData["aUser.micon"] = imgURL

                                    nk.TopTipManager:showTopTip(bm.LangUtil.getText("USERINFO", "UPLOAD_PIC_UPLOAD_SUCCESS"))
                                    -- if self and self.isInRoom_ then
                                    --     nk.socket.RoomSocket:sendSrvChangeHead(nk.userData.uid, imgURL)
                                    -- end

                                -- else
                                --     nk.TopTipManager:showTopTip(bm.LangUtil.getText("USERINFO", "UPLOAD_PIC_UPLOAD_FAIL"))
                                end
                            end, function(errData)
                                dump(errData, "nk.http.updateUserIcon.errData :======================")

                                nk.TopTipManager:showTopTip(bm.LangUtil.getText("USERINFO", "UPLOAD_PIC_UPLOAD_FAIL"))
                            end)
                        else
                            nk.TopTipManager:showTopTip(bm.LangUtil.getText("USERINFO", "UPLOAD_PIC_UPLOAD_FAIL"))
                        end
                        if device.platform == "android" or device.platform == "ios" then
                            cc.analytics:doCommand{command = "event", args = {eventId = "change_avatar_time"}, label = "user Upload avatar_time"}
                        end

                        os.remove(result)
                    end
                end, nk.userData.UPLOAD_PIC, {fileFieldName = "upload", filePath = result, contentType = "Image/jpeg", extra = extraParam})
            else
                nk.TopTipManager:showTopTip(bm.LangUtil.getText("USERINFO", "UPLOAD_PIC_PICK_IMG_FAIL"))
            end
        else
            if result == "nosdcard" then
                nk.TopTipManager:showTopTip(bm.LangUtil.getText("USERINFO", "UPLOAD_PIC_NO_SDCARD"))
            else
                nk.TopTipManager:showTopTip(bm.LangUtil.getText("USERINFO", "UPLOAD_PIC_PICK_IMG_FAIL"))
            end
        end

        self.alertAvatarBtn_:setButtonEnabled(true)
    end)
end

function UserInfoPopup:onAvatarRefreshBtnCallBack_(evt)
    -- body
    self.refreshUsrAvatarBtn_:setButtonEnabled(false)
    nk.clearMyHeadImgCache()
    local micon = nk.userData["aUser.micon"]
    nk.userData["aUser.micon"] = micon

    self.refreshUsrAvatarBtn_:setButtonEnabled(true)
end

function UserInfoPopup:onUsrGiftChangeBtnCallBack_(evt)
    -- body
    self.usrGiftChangeBtn_:setButtonEnabled(false)

    local inRoomInfo = {}
    inRoomInfo.isInRoom = self.isInRoom_
    inRoomInfo.toUid = nk.userData.uid
    inRoomInfo.toUidArr = self.toUidArr
    inRoomInfo.tableNum = self.tableNum
    inRoomInfo.allTabId = self.tableAllUid

    if not self.toUidArr then
        --todo
        inRoomInfo.isInRoom = false
    end

    GiftStorePopup.new():showPanel(inRoomInfo)
    
    self:hidePanel_()
end

function UserInfoPopup:onSexIcTouched_(target, evt)
    -- body
    if evt == bm.TouchHelper.CLICK then
        --todo
        if self.usrSexGender_ == 2 then  -- female
            self.usrSexIc_:setSpriteFrame("common_icMale.png")
            if string.len(nk.userData["aUser.micon"]) <= 5 then
                self:onAvatarLoadComplete_(true, display.newSprite("#common_male_avatar.png"))
            end

            self.usrSexGender_ = 1
        else
            self.usrSexIc_:setSpriteFrame("common_icFemale.png")
            if string.len(nk.userData["aUser.micon"]) <= 5 then
                --todo
                self:onAvatarLoadComplete_(true, display.newSprite("#common_female_avatar.png"))
            end

            self.usrSexGender_ = 2
        end
    end
end

function UserInfoPopup:onUsrNickNameEdit_(evt)
    -- body
    if evt == "began" then
        --todo
    elseif evt == "changed" then
        --todo
    elseif evt == "ended" then
        --todo
        local text = self.usrNickNameEdit_:getText()
        local filteredText = nk.keyWordFilter(text)

        if filteredText ~= text then
            self.usrNickNameEdit_:setText(filteredText)
        end

        self.usrNickName_ = string.trim(self.usrNickNameEdit_:getText())
    elseif evt == "return" then
        --todo
    end
end

function UserInfoPopup:onUsrHonMedalBgTouched_(target, evt)
    -- body
    if evt == bm.TouchHelper.CLICK then
        --todo
        local usrHonMedalRecPos = {
            x = PANELLEFTOPR_WIDTH / 2,
            y = - PANELTOPOPR_HEIGHT / 2
        }

        UsrRewRecordPopup.new(usrHonMedalRecPos, 1):showPanel()
    end
end

function UserInfoPopup:onUsrHonCupBgTouched_(target, evt)
    -- body
    if evt == bm.TouchHelper.CLICK then
        --todo
        local usrHonCupRecPos = {
            x = PANELLEFTOPR_WIDTH / 2,
            y = - PANELTOPOPR_HEIGHT / 2
        }

        UsrRewRecordPopup.new(usrHonCupRecPos, 2):showPanel()
    end
end

function UserInfoPopup:onMyPropsGoPropStoreBtnCallBack_(evt)
    -- body
    local inRoomInfo = {}
    inRoomInfo.isInRoom = self.isInRoom_
    inRoomInfo.toUid = nk.userData.uid
    inRoomInfo.toUidArr = self.toUidArr
    inRoomInfo.tableNum = self.tableNum
    inRoomInfo.allTabId = self.tableAllUid

    if not self.toUidArr then
        --todo
        inRoomInfo.isInRoom = false
    end
    local pageProps = 2

    self.myPropsGoPropStoreBtn_:setButtonEnabled(false)
    GiftStorePopup.new(pageProps):showPanel(inRoomInfo)

    self.myPropsGoPropStoreBtn_:setButtonEnabled(true)

    self:hidePanel_()
end

function UserInfoPopup:usePropsQuickPlay()
    -- body
    if not self.isInRoom_ then
        --todo
        if self.quickPlayHandler_ then
            --todo
            self.quickPlayHandler_()
        else
            nk.server:quickPlay()
        end
    end
    
    self:hidePanel_()
end

function UserInfoPopup:usePropsGoChooseMatchHall()
    if not self.isInRoom_ then
        if self.popupParams_ and self.popupParams_.enterMatch then
            self.popupParams_.enterMatch()
        end
    end

    self:hidePanel_()
end

function UserInfoPopup:usePropsGoScoreMarket()
    if not self.isInRoom_ then
        local runningScene = nk.runningScene

        if runningScene.controller_ and runningScene.controller_.view_ then
            --todo
            local excMarketView = ExcMarketView.new(runningScene.controller_):showPanel()

            excMarketView:setParentView(runningScene.controller_.view_)
        end
    end

    self:hidePanel_()
end

function UserInfoPopup:onPropsItemActionCallBack_(data)
    -- body
    -- dump(data, "UserInfoPopup:onPropsItemActionCallBack_.data :==================")
    if data then
        --todo
        local oprPropsById = {
            [1] = function()
                -- body
                nk.userData["aUser.gift"] = data.pnid
                self.controller_:wareGiftBySelectedId(self.isInRoom_)
            end,

            [2] = function()
                -- body
                self:usePropsQuickPlay()
            end,

            [3] = function()
                -- body
                SuonaUsePopup.new():show()
                self:hidePanel_()
            end,

            [4] = function()
                -- body
                self:usePropsQuickPlay()
            end,

            [5] = function()
                -- body
                self:usePropsQuickPlay()
            end,

            [6] = function()
                -- body
                self:usePropsQuickPlay()
            end,

            [7] = function()
                -- body
                self:usePropsGoChooseMatchHall()
            end,

            [8] = function()
                -- body
                self:usePropsGoScoreMarket()
            end
        }

        local propsId = checkint(data.pcid)

        if propsId and oprPropsById[propsId] then
            --todo
            oprPropsById[propsId]()
        end
    end
end

function UserInfoPopup:onMyGiftsGoGiftStoreBtnCallBack_(evt)
    -- body
    local inRoomInfo = {}
    inRoomInfo.isInRoom = self.isInRoom_
    inRoomInfo.toUid = nk.userData.uid
    inRoomInfo.toUidArr = self.toUidArr
    inRoomInfo.tableNum = self.tableNum
    inRoomInfo.allTabId = self.tableAllUid

    if not self.toUidArr then
        --todo
        inRoomInfo.isInRoom = false
    end

    local pageGift = 1

    self.myGiftsGoGiftStoreBtn_:setButtonEnabled(false)
    GiftStorePopup.new(pageProps):showPanel(inRoomInfo)

    self.myGiftsGoGiftStoreBtn_:setButtonEnabled(true)

    self:hidePanel_()
end

function UserInfoPopup:updateBankBtnStatus()
    -- body
    if self then
        --todo
        local myPocketMoney = nk.userData["aUser.money"]
        local myBankMoney = nk.userData["aUser.bankMoney"]

        -- local myMaxLocalMoney = math.max(myPocketMoney, myBankMoney)
        local bankSaveMoneyBtnIdx = 8
        local bankDrawMoneyBtnIdx = 12

        if self.bankDigitBtns_ and self.bankDigitBtns_[bankSaveMoneyBtnIdx] then
            --todo
            if myPocketMoney <= 0 then
                --todo
                self.bankDigitBtns_[bankSaveMoneyBtnIdx]:setButtonEnabled(false)
            else
                self.bankDigitBtns_[bankSaveMoneyBtnIdx]:setButtonEnabled(true)
            end
        end

        if self.bankDigitBtns_ and self.bankDigitBtns_[bankDrawMoneyBtnIdx] then
            --todo
            if myBankMoney <= 0 then
                --todo
                self.bankDigitBtns_[bankDrawMoneyBtnIdx]:setButtonEnabled(false)
            else
                self.bankDigitBtns_[bankDrawMoneyBtnIdx]:setButtonEnabled(true)
            end
        end
    end
end

function UserInfoPopup:onBankPswCancelSuccCallBack_()
    -- body
    local bankLockOprBtnIdx = 4
    self.bankDigitBtns_[bankLockOprBtnIdx].label_:setSpriteFrame("usrInfo_icDecUnlock.png")
end

function UserInfoPopup:onBankPswSetSuccCallBack_()
    -- body
    local bankLockOprBtnIdx = 4
    self.bankDigitBtns_[bankLockOprBtnIdx].label_:setSpriteFrame("usrInfo_icDecKey.png")
end

function UserInfoPopup:onBankUnlockSuccCallBack_()
    -- body
    if self then
        --todo
        if self.bankVerifyCodeViewNode_ and self.bankNotOpenViewNode_ and self.bankLowLvNotOpenViewNode_ and self.bankContViewNode_ then
            --todo
            self.bankVerifyCodeViewNode_:hide()
            self.bankNotOpenViewNode_:hide()
            self.bankLowLvNotOpenViewNode_:hide()

            self.bankContViewNode_:show()
        end

        local bankLockOprBtnIdx = 4
        if self.bankDigitBtns_ and self.bankDigitBtns_[bankLockOprBtnIdx] then
            --todo
            self.bankDigitBtns_[bankLockOprBtnIdx].label_:setSpriteFrame("usrInfo_icDecKey.png")
        end
    end
end

function UserInfoPopup:onBankDigitInputBtnCallBack_(evt)
    -- body
    local btnTarget = evt.target
    local btnVal = btnTarget.val_

    local speOprBankProptyByBtnVal = {
        [14] = function()
            -- body
            -- Lock && Unlock Bank.
            local bankLockOprBtnIdx = 4
            self.bankDigitBtns_[bankLockOprBtnIdx]:setButtonEnabled(false)

            local isBankLocked = nk.userData["aUser.bankLock"] == 1

            if isBankLocked then
                --todo
                nk.ui.Dialog.new({hasCloseButton = true, messageText = bm.LangUtil.getText("BANK", "BANK_CANCEL_OR_SETING_PASSWORD"),
                    firstBtnText = bm.LangUtil.getText("BANK", "BANK_CACEL_PASSWORD_BUTTON_LABEL"), secondBtnText = bm.LangUtil.getText("BANK", "BANK_SETTING_PASSWORD_BUTTON_LABEL"), 
                    callback = function(type)
                        if type == nk.ui.Dialog.FIRST_BTN_CLICK then
                            self.controller_:cancelBankPsw(handler(self, self.onBankPswCancelSuccCallBack_))

                        elseif type == nk.ui.Dialog.SECOND_BTN_CLICK then
                            BankPswSetUnlockPopup.new(false):showPanel()
                        end
                    end
                }):show()
            else
                BankPswSetUnlockPopup.new(false):showPanel(handler(self, self.onBankPswSetSuccCallBack_))
            end

            self.bankDigitBtns_[bankLockOprBtnIdx]:setButtonEnabled(true)
        end,

        [13] = function()
            -- body
            -- Save Money Into Bank.
            local bankSaveMoneyInBtnIdx = 8
            self.bankDigitBtns_[bankSaveMoneyInBtnIdx]:setButtonEnabled(false)

            if self.isInRoom_ then
                --todo
                nk.TopTipManager:showTopTip(bm.LangUtil.getText("BANK", "BANK_CAN_NOT_USE_IN_ROOM"))
                self.bankDigitBtns_[bankSaveMoneyInBtnIdx]:setButtonEnabled(true)

                return
            end

            local maxMoneyPositOneTime = 2000000000

            if string.len(self.curInputProptyNumString) <= 0 then
                --todo
                nk.TopTipManager:showTopTip(bm.LangUtil.getText("BANK", "EMPYT_CHIP_NUMBER_TOP_TIP"))
                self.bankDigitBtns_[bankSaveMoneyInBtnIdx]:setButtonEnabled(true)

            elseif tonumber(self.curInputProptyNumString) > maxMoneyPositOneTime then
                --todo
                nk.TopTipManager:showTopTip(bm.LangUtil.getText("BANK", "BANK_TOP_LIMIT_TIP"))
                self.bankDigitBtns_[bankSaveMoneyInBtnIdx]:setButtonEnabled(true)

            else
                local currencyType = "money" -- "point"

                self.controller_:saveMoneyIntoBank(self.curInputProptyNumString, currencyType)
                self:setUsrDataReqLoading(true)
            end
        end,

        [12] = function()
            -- body
            -- Draw Money From Bank.
            local bankDrawMoneyInBtnIdx = 12
            self.bankDigitBtns_[bankDrawMoneyInBtnIdx]:setButtonEnabled(false)

            if self.isInRoom_ then
                nk.TopTipManager:showTopTip(bm.LangUtil.getText("BANK", "BANK_CAN_NOT_USE_IN_ROOM"))
                self.bankDigitBtns_[bankDrawMoneyInBtnIdx]:setButtonEnabled(true)

                return
            end

            local maxMoneyDrawOneTime = 2000000000

            if string.len(self.curInputProptyNumString) <= 0 then
                --todo
                nk.TopTipManager:showTopTip(bm.LangUtil.getText("BANK", "EMPYT_CHIP_NUMBER_TOP_TIP"))
                self.bankDigitBtns_[bankDrawMoneyInBtnIdx]:setButtonEnabled(true)

            elseif tonumber(self.curInputProptyNumString) > maxMoneyDrawOneTime then
                --todo
                nk.TopTipManager:showTopTip(bm.LangUtil.getText("BANK", "BANK_TOP_LIMIT_TIP"))
                self.bankDigitBtns_[bankDrawMoneyInBtnIdx]:setButtonEnabled(true)

            else
                local currencyType = "money" -- "point"

                self.controller_:drawMoneyFromBank(self.curInputProptyNumString, currencyType)
                self:setUsrDataReqLoading(true)
            end
        end,

        [11] = function()
            -- body
            -- Delete Usr Input Money Str.
            local myPocketMoney = nk.userData["aUser.money"]
            local myBankMoney = nk.userData["aUser.bankMoney"]

            local myMaxLocalMoney = math.max(myPocketMoney, myBankMoney)

            local curInputProptyNumStrLen = string.len(self.curInputProptyNumString)
            if curInputProptyNumStrLen <= 0 then
                --todo
                return
            end

            local curCutString = string.sub(self.curInputProptyNumString, 0, curInputProptyNumStrLen - 1)
            self.curInputProptyNumString = curCutString

            if string.len(self.curInputProptyNumString) > 0 then
                --todo
                self.proptyInputBankNum_:setString(bm.formatNumberWithSplit(self.curInputProptyNumString))

                local saveOprBtnIdx = 8
                if tonumber(self.curInputProptyNumString) <= myPocketMoney then
                    --todo
                    self.bankDigitBtns_[saveOprBtnIdx]:setButtonEnabled(true)
                else
                    self.bankDigitBtns_[saveOprBtnIdx]:setButtonEnabled(false)
                end

                local drawOprBtnIdx = 12
                -- Input Money Large Than aUser.bankMoney Forbid To Draw Money From Bank
                if tonumber(self.curInputProptyNumString) <= myBankMoney then
                    --todo
                    self.bankDigitBtns_[drawOprBtnIdx]:setButtonEnabled(true)
                else
                    self.bankDigitBtns_[drawOprBtnIdx]:setButtonEnabled(false)
                end
            else
                self.curInputProptyNumString = ""
                self.proptyInputBankNum_:setString("0")
            end
        end
    }

    if btnVal >= 11 then
        --todo
        if speOprBankProptyByBtnVal[btnVal] then
            --todo
            speOprBankProptyByBtnVal[btnVal]()
        end
    else
        local myPocketMoney = nk.userData["aUser.money"]
        local myBankMoney = nk.userData["aUser.bankMoney"]

        local myMaxLocalMoney = math.max(myPocketMoney, myBankMoney)

        if string.len(self.curInputProptyNumString) <= 0 and btnVal == 0 then
            --todo
            return
        end

        if string.len(self.curInputProptyNumString) > 0 and tonumber(self.curInputProptyNumString) >= myMaxLocalMoney then
            --todo
            return
        end

        self.curInputProptyNumString = self.curInputProptyNumString .. btnVal

        self.proptyInputBankNum_:setString(bm.formatNumberWithSplit(self.curInputProptyNumString))
        if tonumber(self.curInputProptyNumString) >= myMaxLocalMoney then
            --todo
            self.proptyInputBankNum_:setString(bm.formatNumberWithSplit(myMaxLocalMoney))
        end

        -- Input Money Large Than aUser.money Forbid To Save Money Into Bank
        if tonumber(self.curInputProptyNumString) > myPocketMoney then
            --todo
            local saveOprBtnIdx = 8

            self.bankDigitBtns_[saveOprBtnIdx]:setButtonEnabled(false)
        end

        -- Input Money Large Than aUser.bankMoney Forbid To Draw Money From Bank
        if tonumber(self.curInputProptyNumString) > myBankMoney then
            --todo
            local drawOprBtnIdx = 12

            self.bankDigitBtns_[drawOprBtnIdx]:setButtonEnabled(false)
        end
    end
end

function UserInfoPopup:onBankSaveMoneySucc()
    -- body
    if self then
        --todo
        if self and self.setUsrDataReqLoading then
            --todo
            self:setUsrDataReqLoading(false)
        end

        local proptyNumInBank = nil

        if nk.userData["aUser.bankMoney"] >= 1000000000 then
            --todo
            proptyNumInBank = bm.formatBigNumber(nk.userData["aUser.bankMoney"])
        else
            proptyNumInBank = bm.formatNumberWithSplit(nk.userData["aUser.bankMoney"])
        end

        if self.proptyNumInBank_ then
            --todo
            self.proptyNumInBank_:setString(proptyNumInBank)  -- callData.bankpoint
        end

        if self.proptyInputBankNum_ then
            --todo
            self.proptyInputBankNum_:setString("0")
        end

        if self.curInputProptyNumString then
            --todo
            self.curInputProptyNumString = ""
        end

        local bankSaveMoneyInBtnIdx = 8
        if self.bankDigitBtns_ and self.bankDigitBtns_[bankSaveMoneyInBtnIdx] then
            --todo
            self.bankDigitBtns_[bankSaveMoneyInBtnIdx]:setButtonEnabled(true)
        end

        if self.updateBankBtnStatus then
            --todo
            self:updateBankBtnStatus()
        end
    end
end

function UserInfoPopup:onSaveBankMoneyWrong()
    -- body
    if self and self.setUsrDataReqLoading then
        --todo
        self:setUsrDataReqLoading(false)
    end

    local bankSaveMoneyInBtnIdx = 8

    if self and self.bankDigitBtns_ and self.bankDigitBtns_[bankSaveMoneyInBtnIdx] then
        --todo
        self.bankDigitBtns_[bankSaveMoneyInBtnIdx]:setButtonEnabled(true)
    end
end

function UserInfoPopup:onBankDrawMoneySucc()
    -- body
    if self then
        --todo
        if self and self.setUsrDataReqLoading then
            --todo
            self:setUsrDataReqLoading(false)
        end

        local proptyNumInBank = nil

        if nk.userData["aUser.bankMoney"] >= 1000000000 then
            --todo
            proptyNumInBank = bm.formatBigNumber(nk.userData["aUser.bankMoney"])
        else
            proptyNumInBank = bm.formatNumberWithSplit(nk.userData["aUser.bankMoney"])
        end

        if self.proptyNumInBank_ then
            --todo
            self.proptyNumInBank_:setString(proptyNumInBank)  -- callData.bankpoint
        end

        if self.proptyInputBankNum_ then
            --todo
            self.proptyInputBankNum_:setString("0")
        end

        if self.curInputProptyNumString then
            --todo
            self.curInputProptyNumString = ""
        end

        local bankDrawMoneyInBtnIdx = 12
        if self.bankDigitBtns_ and self.bankDigitBtns_[bankDrawMoneyInBtnIdx] then
            --todo
            self.bankDigitBtns_[bankDrawMoneyInBtnIdx]:setButtonEnabled(true)
        end

        if self.updateBankBtnStatus then
            --todo
            self:updateBankBtnStatus()
        end
    end
end

function UserInfoPopup:onDrawBankMoneyWrong()
    -- body
    if self and self.setUsrDataReqLoading then
        --todo
        self:setUsrDataReqLoading(false)
    end

    local bankDrawMoneyInBtnIdx = 12

    if self and self.bankDigitBtns_ and self.bankDigitBtns_[bankDrawMoneyInBtnIdx] then
        --todo
        self.bankDigitBtns_[bankDrawMoneyInBtnIdx]:setButtonEnabled(true)
    end
end

function UserInfoPopup:onBankVerifyCodeBtnCallBack_(evt)
    -- body
    self.usrVerifyBankPswBtn_:setButtonEnabled(false)

    BankPswSetUnlockPopup.new(true):showPanel(handler(self, self.onBankUnlockSuccCallBack_))

    self.usrVerifyBankPswBtn_:setButtonEnabled(true)
end

function UserInfoPopup:onSubGiftTypeSelChanged_(evt)
    -- body
    local btnLblColor = {
        nor = display.COLOR_WHITE,
        sel = display.COLOR_GREEN
    }

    if not self.subGiftTypeSelIdx_ then
        --todo
        self.subGiftTypeSelIdx_ = evt.selected
        self.giftTypeSubBtns_[self.subGiftTypeSelIdx_].label_:setTextColor(btnLblColor.sel)
    end

    local isChanged = self.subGiftTypeSelIdx_ ~= evt.selected

    if isChanged then
        --todo
        self.giftTypeSubBtns_[self.subGiftTypeSelIdx_].label_:setTextColor(btnLblColor.nor)

        self.giftTypeSubBtns_[evt.selected].label_:setTextColor(btnLblColor.sel)

        self.subGiftTypeSelIdx_ = evt.selected
    end

    self.controller_:onUsrGiftTypeSelChanged(self.subGiftTypeSelIdx_)
end

function UserInfoPopup:onTopTabBtnSelChanged_(evt)
    -- body
    if not self.topTabSelIdx_ then
        --todo
        self.topTabSelIdx_ = evt.selected
        self.topTabBtns_[self.topTabSelIdx_].label_:setSpriteFrame("usrInfo_decDescTi" .. self.topTabSelIdx_ .. "_sel.png")
        self.topTabBtns_[self.topTabSelIdx_].imgSel_:show()
    end

    local isChanged = self.topTabSelIdx_ ~= evt.selected

    if isChanged then
        --todo
        self.topTabBtns_[self.topTabSelIdx_].label_:setSpriteFrame("usrInfo_decDescTi" .. self.topTabSelIdx_ .. "_nor.png")
        self.topTabBtns_[self.topTabSelIdx_].imgSel_:hide()

        self.topTabBtns_[evt.selected].label_:setSpriteFrame("usrInfo_decDescTi" .. evt.selected .. "_sel.png")
        self.topTabBtns_[evt.selected].imgSel_:show()

        local tabGiftIdx = 3
        if self.topTabSelIdx_ == tabGiftIdx then
            --todo
            -- Last TabIdx:3 Update GiftWare Info
            self.controller_:wareGiftBySelectedId(self.isInRoom_)
        end

        self.topTabSelIdx_ = evt.selected
    end

    self:renderUsrInfoContPageViews(self.topTabSelIdx_)

    self:getUsrInfoPagesData()
end

function UserInfoPopup:onCloseBtnCallBack_(evt)
    -- body
    self:hidePanel_()
end

function UserInfoPopup:onUpgradeBtnCallBack_()
    -- if nk.userData.nextRwdLevel and nk.userData.nextRwdLevel ~= 0 then
    --     display.addSpriteFrames("upgrade_texture.plist", "upgrade_texture.png", function()
    --         UpgradePopup.new(nk.userData.nextRwdLevel):show()
    --     end)
    -- end
end

function UserInfoPopup:getUsrInfoPagesData()
    -- body
    local getUsrInfoPageContDataByTabIdx = {
        [1] = function()
            -- body
            self.controller_:loadUsrDataUpdate()
        end,

        [2] = function()
            -- body
            self.controller_:getUsrPropsData()
        end,

        [3] = function()
            -- body
            self.controller_:getMyGiftData()
        end,

        [4] = function()
            -- body
            self:onBankDataLoaded()
        end
    }

    getUsrInfoPageContDataByTabIdx[self.topTabSelIdx_]()
    self:setUsrDataReqLoading(true)
end

function UserInfoPopup:rangeProptyAffixListDatas(dataList)
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

function UserInfoPopup:onGetUsrInfoDataUpdated()
    -- body
    if self.setUsrDataReqLoading then
        --todo
        self:setUsrDataReqLoading(false)
    end

    if self.infoMainVals_ then
        --todo
        local usrInfoWinRateIdx = 1

        if self.infoMainVals_[usrInfoWinRateIdx] then
            --todo
            local usrWinRate = 0
            if nk.userData["aUser.lose"] > 0 then
                --todo
                usrWinRate = math.round(nk.userData["aUser.win"] * 100 / (nk.userData["aUser.win"] + nk.userData["aUser.lose"]))
            else
                if nk.userData["aUser.win"] > 0 then
                    --todo
                    usrWinRate = 100
                end
            end
            self.infoMainVals_[usrInfoWinRateIdx]:setString(tostring(usrWinRate) .. "%")
        end

        local usrInfoDealRoundIdx = 2

        if self.infoMainVals_[usrInfoDealRoundIdx] then
            --todo
            local usrDealRound = bm.formatNumberWithSplit(nk.userData["aUser.win"] + nk.userData["aUser.lose"])
            self.infoMainVals_[usrInfoDealRoundIdx]:setString(tostring(usrDealRound))
        end

        local usrInfoTodayIncomeIdx = 3

        if self.infoMainVals_[usrInfoTodayIncomeIdx] then
            --todo
            local usrTodayIncome = bm.formatNumberWithSplit(nk.userData["aUser.money"] - nk.userData["aUser.lastMoney"])
            self.infoMainVals_[usrInfoTodayIncomeIdx]:setString(usrTodayIncome)
        end

        local usrInfoHistoryAwardIdx = 4

        if self.infoMainVals_[usrInfoHistoryAwardIdx] then
            --todo
            local usrHistoryAward = bm.formatNumberWithSplit(nk.userData["aBest.maxwmoney"])
            self.infoMainVals_[usrInfoHistoryAwardIdx]:setString(usrHistoryAward)
        end

        local usrInfoHistoryPropty = 5

        if self.infoMainVals_[usrInfoHistoryPropty] then
            --todo
            local usrHistoryPropty = bm.formatNumberWithSplit(nk.userData["aBest.maxmoney"])
            self.infoMainVals_[usrInfoHistoryPropty]:setString(usrHistoryPropty)
        end
    end

    if nk.userData["match"] then
        --todo
        local medalData = nk.userData["match"]["honor"]["medal"]
        local cupData = nk.userData["match"]["honor"]["cup"]

        for k, v in pairs(medalData) do
            if checkint(v) > 0 then
                self.isMedalHoned_ = true
            end
        end

        for k, v in pairs(cupData) do
            if checkint(v) > 0 then
                self.isCupHoned_ = true
            end
        end

        if self.usrMedalNums_ then
            --todo
            for i = 1, 3 do
                self.usrMedalNums_[i]:setString("×" .. medalData[tostring(i)])
            end
        end
        
        if self.usrCupNums_ then
            --todo
            for i = 1, 3 do
                self.usrCupNums_[i]:setString("×" .. cupData[tostring(i)])
            end
        end
    end
end

function UserInfoPopup:onPropsDataGet(data)
    -- dump(data, "UserInfoPopup:onPropsDataGet.data :==================")
    self:setUsrDataReqLoading(false)

    self.propsListData_ = data

    self.myPropsListView_:setData(nil)

    if self.propsListData_ and #self.propsListData_ > 0 then
        --todo
        self.noPropsHint_:hide()

        local propsRangedDataList = self:rangeProptyAffixListDatas(self.propsListData_)

        -- dump(propsRangedDataList, "propsRangedDataList.data :===================")

        self.myPropsListView_:setData(propsRangedDataList)
    else
        self.myPropsListView_:setData(nil)

        self.noPropsHint_:show()
    end
end

function UserInfoPopup:onGetUsrPropsDataWrong(errData)
    -- body
    if self.setUsrDataReqLoading then
        --todo
        self:setUsrDataReqLoading(false)
    end

    nk.ui.Dialog.new({messageText = bm.LangUtil.getText("COMMON", "REQUEST_DATA_FAIL"), secondBtnText = bm.LangUtil.getText("COMMON", "RETRY"), callback = function(type)
        if type == nk.ui.Dialog.SECOND_BTN_CLICK then
            if self.controller_ then
                --todo
                self.controller_:getUsrPropsData()

                self:setUsrDataReqLoading(true)
            end
        end
    end}):show()
end

function UserInfoPopup:onMyGiftFilterTypeDataGet(fliterData)
    -- body
    -- dump(fliterData, "UserInfoPopup:onMyGiftFilterTypeDataGet.fliterData :===================")
    self:setUsrDataReqLoading(false)

    if self.myGiftFliterListData_ then
        --todo
        self.myGiftFliterListData_ = nil
    end

    self.myGiftListView_:setData(nil)

    self.myGiftFliterListData_ = fliterData

    if self.myGiftFliterListData_ and #self.myGiftFliterListData_ > 0 then
        --todo
        self.noGiftHint_:hide()

        local myGiftRangedDataList = self:rangeProptyAffixListDatas(self.myGiftFliterListData_)

        -- dump(myGiftRangedDataList, "myGiftRangedDataList.data :===================")

        self.myGiftListView_:setData(myGiftRangedDataList)
    else
        self.myGiftListView_:setData(nil)

        self.noGiftHint_:show()
    end
end

function UserInfoPopup:onGetMyGiftDataWrong(errData)
    -- body
    if self.setUsrDataReqLoading then
        --todo
        self:setUsrDataReqLoading(false)
    end

    nk.ui.Dialog.new({messageText = bm.LangUtil.getText("COMMON", "REQUEST_DATA_FAIL"), secondBtnText = bm.LangUtil.getText("COMMON", "RETRY"), callback = function(type)
        if type == nk.ui.Dialog.SECOND_BTN_CLICK then
            if self.controller_ then
                --todo
                self.controller_:getMyGiftData()

                self:setUsrDataReqLoading(true)
            end
        end
    end}):show()
end

function UserInfoPopup:onBankDataLoaded()
    -- body
    local bankDataRefreshDelayTime = .05

    self:performWithDelay(function()
        -- body
        if self and self.setUsrDataReqLoading then
            --todo
            self:setUsrDataReqLoading(false)
        end

        local userLevelCal = nk.Level:getLevelByExp(nk.userData["aUser.exp"])
        if not nk.OnOff:check("bank") then
            --todo
            self.bankContViewNode_:hide()
            self.bankVerifyCodeViewNode_:hide()
            self.bankLowLvNotOpenViewNode_:hide()

            self.bankNotOpenViewNode_:show()
        elseif userLevelCal < 5 then
            --todo
            self.bankContViewNode_:hide()
            self.bankVerifyCodeViewNode_:hide()
            self.bankNotOpenViewNode_:hide()

            self.bankLowLvNotOpenViewNode_:show()
        elseif nk.userData["aUser.bankLock"] == 1 then
            --todo
            self.bankContViewNode_:hide()
            self.bankLowLvNotOpenViewNode_:hide()
            self.bankNotOpenViewNode_:hide()

            self.bankVerifyCodeViewNode_:show()
        else
            self.bankVerifyCodeViewNode_:hide()
            self.bankNotOpenViewNode_:hide()
            self.bankLowLvNotOpenViewNode_:hide()

            self.bankContViewNode_:show()

            self:updateBankBtnStatus()
        end        
    end, bankDataRefreshDelayTime)
end

function UserInfoPopup:addPropertyObservers()
    self.nickObserverHandler_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "aUser.name", function(name)
        self.usrNickNameEdit_:setText(nk.Native:getFixedWidthText("", 24, name, 160))
    end)

    self.sexObserverHandler_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "aUser.msex", function(sex)
        if sex == 2 or sex == 0 then
            self.usrSexGender_ = 2
            self.usrSexIc_:setSpriteFrame("common_icFemale.png")
        else
            self.usrSexGender_ = 1
            self.usrSexIc_:setSpriteFrame("common_icMale.png")
        end
    end)

    self.usrMoneyObserverHandler_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "aUser.money", function(money)
        if money then
            --todo
            local usrProptyValChipIdx = 3

            if self and self.usrProptyVals_ and self.usrProptyVals_[usrProptyValChipIdx] then
                self.usrProptyVals_[usrProptyValChipIdx]:setString(bm.formatNumberWithSplit(money))
            end
        end
    end)

    self.usrCashObserverHandler_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "match.point", function(cash)
        -- body
        if cash then
            --todo
            local usrProptyValCashIdx = 2
            if self and self.usrProptyVals_ and self.usrProptyVals_[usrProptyValCashIdx] then
                --todo
                if self.isInRoom_ and self.isInGame_ and self.isCash_ == 1 then
                    --todo
                    self.usrProptyVals_[usrProptyValCashIdx]:setString(bm.formatNumberWithSplit(cash - (nk.userData["aUser.anteMoney"] or 0)))
                else
                    self.usrProptyVals_[usrProptyValCashIdx]:setString(bm.formatNumberWithSplit(cash))
                end
            end
        end
    end)

    self.usrChamPointObserverHandler_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "match.highPoint", function(point)
        -- body
        if point then
            --todo
            local usrProptyValChamPointIdx = 1

            if self and self.usrProptyVals_ and self.usrProptyVals_[usrProptyValChamPointIdx] then
                --todo
                self.usrProptyVals_[usrProptyValChamPointIdx]:setString(bm.formatNumberWithSplit(point))
            end
        end
    end)

    self.usrExpObserverHandler_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "aUser.exp", function(exp)
        if exp then
            --todo
            local percent, progress, all
            percent, progress, all, self.reqLvDataId_ = nk.Level:getLevelUpProgress(exp, function(levelData, percent, progress, all)
                -- body
                if self then
                    --todo
                    if self.usrExpPrgBar_ then
                        --todo
                        self.usrExpPrgBar_:setValue(percent)
                    end

                    if self.usrLevel_ then
                        --todo
                        self.usrLevel_:setString("LV." .. nk.Level:getLevelByExp(exp))
                    end

                    if self.usrExp_ then
                        --todo
                        self.usrExp_:setString(progress .. "/" .. all)
                    end

                    self.reqLvDataId_ = nil
                end
            end)

            if self then
                --todo
                if self.usrExpPrgBar_ then
                    --todo
                    self.usrExpPrgBar_:setValue(percent)
                end

                if self.usrLevel_ then
                    --todo
                    self.usrLevel_:setString("LV." .. nk.Level:getLevelByExp(exp))
                end

                if self.usrExp_ then
                    --todo
                    self.usrExp_:setString(progress .. "/" .. all)
                end
            end
        end
    end)

    self.avatarUrlObserverHandler_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "aUser.micon", function(micon)
        if string.len(micon) <= 5 then
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

            nk.ImageLoader:loadAndCacheImage(self.userAvatarLoaderId_, imgurl, handler(self, self.onAvatarLoadComplete_), nk.ImageLoader.CACHE_TYPE_USER_HEAD_IMG)
        end
    end)

    -- self.nextRwdLevelHandler_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "nextRwdLevel", function(nextRwdLevel)
    --     if nextRwdLevel ~= 0 then
    --     else
    --     end
    -- end)

    if nk.config.GIFT_SHOP_ENABLED and nk.userData.GIFT_SHOP == 1 then
        self.giftIdObserverHandler_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "aUser.gift", function(id)
            if self.reqUsrGiftUrlId_ then
                LoadGiftControl:getInstance():cancel(self.reqUsrGiftUrlId_)
            end

            self.usrGiftImgLoaderId_ = nk.ImageLoader:nextLoaderId()

            self.reqUsrGiftUrlId_ = LoadGiftControl:getInstance():getGiftUrlById(id, function(url)
                self.reqUsrGiftUrlId_ = nil
                if url and string.len(url) > 5 then
                    nk.ImageLoader:cancelJobByLoaderId(self.usrGiftImgLoaderId_)
                    nk.ImageLoader:loadAndCacheImage(self.usrGiftImgLoaderId_, url, handler(self,self.usrGiftImageLoadCallback_), nk.ImageLoader.CACHE_TYPE_GIFT)
                end
            end)
        end)
    end
end

function UserInfoPopup:removePropertyObservers()
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.name", self.nickObserverHandler_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.msex", self.sexObserverHandler_)

    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.money", self.usrMoneyObserverHandler_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "match.point", self.usrCashObserverHandler_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "match.highPoint", self.usrChamPointObserverHandler_)

    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.exp", self.usrExpObserverHandler_)
    -- bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "nextRwdLevel", self.nextRwdLevelHandler_)

    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.micon", self.avatarUrlObserverHandler_)

    if nk.config.GIFT_SHOP_ENABLED and nk.userData.GIFT_SHOP == 1 then
        bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.gift", self.giftIdObserverHandler_)
    end
end

function UserInfoPopup:show(isInRoom, tableMessage, quickPlayHandler, isInGame)
    self.isInRoom_ = isInRoom
    self.isInGame_ = isInGame
    -- 暂时注释，保留后面可能使用！
    if self.isInRoom_ and tableMessage then
        self.tableAllUid = tableMessage.tableAllUid
        self.toUidArr = tableMessage.toUidArr
        self.tableNum = tableMessage.tableNum
        self.isCash_ = tableMessage.isCash
        -- self.minMoney = tableMessage.minMoney
    end

    self._quickPlayHandler = quickPlayHandler
    self:showPanel_()
    nk.cacheKeyWordFile()
end

--[[ @param :param 
    param.isInRoom :inRoom State
    param.tableMessage :roomTabel Messsage
    param.quickPlayHandler :quickPlayHandler For QuickPlay Call
    param.isInGame :inGame State
]]--
function UserInfoPopup:showPanel(param)
    -- body
    if param then
        --todo
        self.isInRoom_ = param.isInRoom or false
        self.isInGame_ = param.isInGame or false

        local tableMessage = param.tableMessage
        if self.isInRoom_ and tableMessage then
            self.tableAllUid = tableMessage.tableAllUid
            self.toUidArr = tableMessage.toUidArr
            self.tableNum = tableMessage.tableNum
            self.isCash_ = tableMessage.isCash
            -- self.minMoney = tableMessage.minMoney
        end

        self.quickPlayHandler_ = param.quickPlayHandler
    end

    self:showPanel_()
    nk.cacheKeyWordFile()
end

function UserInfoPopup:onShowed()
    -- body
    if self.myPropsListView_ then
        --todo
        self.myPropsListView_:update()
    end

    if self.myGiftListView_ then
        --todo
        self.myGiftListView_:update()
    end
end

function UserInfoPopup:onEnter()
    -- body
end

function UserInfoPopup:onExit()
    -- body
    local tabGiftIdx = 3

    if self.topTabSelIdx_ == tabGiftIdx then
        --todo
        self.controller_:wareGiftBySelectedId(self.isInRoom_)
    end

    if self.usrSexGender_ ~= nk.userData["aUser.msex"] or self.usrNickName_ ~= nk.userData["aUser.name"] then
       
        local params = {}
        if self.usrSexGender_ ~= nk.userData["aUser.msex"] then
            params.msex = self.usrSexGender_
        end

        if self.usrNickName_ ~= nk.userData["aUser.name"] then
            params.name = self.usrNickName_
        end

        self.controller_:updateUsrInfo(params)
    end

    nk.ImageLoader:cancelJobByLoaderId(self.userAvatarLoaderId_)
    nk.ImageLoader:cancelJobByLoaderId(self.usrGiftImgLoaderId_)

    if self.reqUsrGiftUrlId_ then
        LoadGiftControl:getInstance():cancel(self.reqUsrGiftUrlId_)
    end

    self.controller_:dispose()
    self:removePropertyObservers()

    nk.EditBoxManager:removeEditBox(self.usrNickNameEdit_)
end

function UserInfoPopup:onCleanup()
    display.removeSpriteFramesWithFile("usrInfo_texture.plist", "usrInfo_texture.png")

    nk.schedulerPool:delayCall(function()
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    end, 0.1)
end

return UserInfoPopup