--
-- Author: viking@boomegg.com
-- Date: 2014-08-22 16:50:03
-- Copyright: Copyright (c) 2014, BOOMEGG INTERACTIVE CO., LTD All rights reserved.
-- Description: SettingView.lua ReConstructed By Tsing7x.
--

local HelpView = import("..help.HelpView")
local UpdatePopup = import(".views.UpdatePopup")
local AboutPopup = import(".views.AboutPopup")

local PANEL_WIDTH = 790
local PANEL_HEIGHT = 470

local AVATAR_TAG = 100

local SettingView = class("SettingView", nk.ui.Panel)

function SettingView:ctor(isInRoom)
    self.isInRoom_ = isInRoom

    self:setNodeEventEnabled(true)
    self.super.ctor(self, {PANEL_WIDTH, PANEL_HEIGHT})

    display.addSpriteFrames("setting_texture.plist", "setting_texture.png", handler(self, self.onSettingTextureLoaded))
end

function SettingView:onSettingTextureLoaded(fileName, imgName)
    -- body
    local titleDesc = display.newSprite("#setg_decDescTitle.png")

    self:addPanelTitleBar(titleDesc)

    local titleBarSize = self:getTitleBarSize()
    local panelBorWidth = 5

    local labelParam = {
        fontSize = 0,
        color = display.COLOR_BLACK
    }

    -- Main Setting Func Area --
    local areaMainP1MagrinTop = 24
    local areaMainBlkDentMagrinBorHoriz = 28
    local areaMainSetLblMagrinLeft = 24

    -- Left Half Part --
    local areaLeftHalfP1MagrinP2 = 15

    local areaLeftHalfP1Size = {
        width = 348,
        height = 150
    }

    local areaSetBtnMagrinRight = 16
    local areaSetLblMarinEachInP1 = 24

    local settingPartAreaLeftHalfP1 = display.newScale9Sprite("#setg_bgBlkAbout.png", - PANEL_WIDTH / 2 + panelBorWidth + areaMainBlkDentMagrinBorHoriz + areaLeftHalfP1Size.width / 2,
        PANEL_HEIGHT / 2 - panelBorWidth - titleBarSize.height - areaMainP1MagrinTop - areaLeftHalfP1Size.height / 2, cc.size(areaLeftHalfP1Size.width, areaLeftHalfP1Size.height))
        :addTo(self)

    labelParam.fontSize = 23
    labelParam.color = display.COLOR_WHITE

    local attriSetChkBtnSize = {
        width = 104,
        height = 34
    }

    local volumeSetLabel = display.newTTFLabel({text = "音量", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    volumeSetLabel:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    volumeSetLabel:pos(areaMainSetLblMagrinLeft, areaLeftHalfP1Size.height / 2 + volumeSetLabel:getContentSize().height + areaSetLblMarinEachInP1)
        :addTo(settingPartAreaLeftHalfP1)

    local volumeSliderBarSize = {
        width = 254,
        height = 14
    }

    local volumeSliderBarScaleSize = .9

    self.volumeVal_ = 0

    self.volumeSetSlider_ = cc.ui.UISlider.new(display.LEFT_TO_RIGHT, {bar = "#setg_sldBarBgVolume.png", barfg = "#setg_sldBarFillerVolume.png", button = "#setg_sldBtnVolume.png"},
        {scale9 = true})
        :setSliderSize(volumeSliderBarSize.width, volumeSliderBarSize.height)
        :onSliderValueChanged(handler(self, self.onVolumeValueChanged_))
        :onSliderRelease(handler(self, self.onVolumeValueUpdate_))
        :align(display.CENTER_LEFT, areaLeftHalfP1Size.width  - areaSetBtnMagrinRight - volumeSliderBarSize.width * volumeSliderBarScaleSize, volumeSetLabel:getPositionY())
        :addTo(settingPartAreaLeftHalfP1)
        :scale(volumeSliderBarScaleSize)

    local gameMusicSetLbl = display.newTTFLabel({text = "游戏音乐", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    gameMusicSetLbl:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    gameMusicSetLbl:pos(areaMainSetLblMagrinLeft, areaLeftHalfP1Size.height / 2)
        :addTo(settingPartAreaLeftHalfP1)

    self.gameMuicSetChkBtn_ = cc.ui.UICheckBoxButton.new({on = "#setg_chkBtnSet_on.png", off = "#setg_chkBtnSet_off.png"}, {scale9 = false})
        :onButtonStateChanged(buttontHandler(self, self.onGameMusicOnOffStateChanged_))
        :pos(areaLeftHalfP1Size.width - areaSetBtnMagrinRight - attriSetChkBtnSize.width / 2, gameMusicSetLbl:getPositionY())
        :addTo(settingPartAreaLeftHalfP1)

    -- self.gameMuicSetChkBtn_:setButtonSelected(true)

    local vibrateSetLabel = display.newTTFLabel({text = "震动", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    vibrateSetLabel:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    vibrateSetLabel:pos(areaMainSetLblMagrinLeft, areaLeftHalfP1Size.height / 2 - vibrateSetLabel:getContentSize().height - areaSetLblMarinEachInP1)
        :addTo(settingPartAreaLeftHalfP1)

    self.vibrateOnOffVal_ = false

    self.vibrateSetChkBtn_ = self.gameMuicSetChkBtn_:clone()
    self.vibrateSetChkBtn_:onButtonStateChanged(buttontHandler(self, self.onVibrateOnOffStateChanged_))
        :pos(areaLeftHalfP1Size.width - areaSetBtnMagrinRight - attriSetChkBtnSize.width / 2, vibrateSetLabel:getPositionY())
        :addTo(settingPartAreaLeftHalfP1)

    local areaLeftHalfP2Size = {
        width = 348,
        height = 108
    }

    local areaSetLblMarinEachInP2 = 26

    local settingPartAreaLeftHalfP2 = display.newScale9Sprite("#setg_bgBlkAbout.png", settingPartAreaLeftHalfP1:getPositionX(), PANEL_HEIGHT / 2 - panelBorWidth -
        titleBarSize.height - areaMainP1MagrinTop - areaLeftHalfP1MagrinP2 - areaLeftHalfP1Size.height - areaLeftHalfP2Size.height / 2, cc.size(areaLeftHalfP2Size.width,
            areaLeftHalfP2Size.height))
        :addTo(self)

    local autoSitSetLabel = display.newTTFLabel({text = "进入房间自动坐下", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    autoSitSetLabel:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    autoSitSetLabel:pos(areaMainSetLblMagrinLeft, areaLeftHalfP2Size.height / 2 + areaSetLblMarinEachInP2 / 2 + autoSitSetLabel:getContentSize().height / 2)
        :addTo(settingPartAreaLeftHalfP2)

    self.autoSitOnOffVal_ = true

    self.autoSitSetChkBtn_ = self.gameMuicSetChkBtn_:clone()
    self.autoSitSetChkBtn_:onButtonStateChanged(buttontHandler(self, self.onAutoSitOnOffStateChanged_))
        :pos(areaLeftHalfP2Size.width - areaSetBtnMagrinRight - attriSetChkBtnSize.width / 2, autoSitSetLabel:getPositionY())
        :addTo(settingPartAreaLeftHalfP2)

    local autoBuyInSetLabel = display.newTTFLabel({text = "自动买入", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    autoBuyInSetLabel:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    autoBuyInSetLabel:pos(areaMainSetLblMagrinLeft, areaLeftHalfP2Size.height / 2 - areaSetLblMarinEachInP2 / 2 - autoBuyInSetLabel:getContentSize().height / 2)
        :addTo(settingPartAreaLeftHalfP2)

    self.autoBuyInOnOffVal_ = true

    self.autoBuyInSetChkBtn_ = self.gameMuicSetChkBtn_:clone()
    self.autoBuyInSetChkBtn_:onButtonStateChanged(buttontHandler(self, self.onAutoBuyInOnOffStateChanged_))
        :pos(areaLeftHalfP2Size.width - areaSetBtnMagrinRight - attriSetChkBtnSize.width / 2, autoBuyInSetLabel:getPositionY())
        :addTo(settingPartAreaLeftHalfP2)

    -- Right Half Part --
    local areaRightHalfItemSize = {
        width = 350,
        height = 55
    }

    local setItemMagrinEach = 17

    local currentVersion = nk.Native:getAppVersion()
    local areaSetRightItemStrs = {
        "检查更新 V" .. (BM_UPDATE and BM_UPDATE.VERSION or currentVersion),
        "喜欢我们,打分鼓励",
        "官方粉丝页",
        "关于"
    }

    local areaSetRightItemBtnCtrlHandlers = {
        buttontHandler(self, self.onUpdateInfoBtnCallBack_),
        buttontHandler(self, self.onInciteBtnCallBack_),
        buttontHandler(self, self.onPageFansBtnCallBack_),
        buttontHandler(self, self.onGameAboutBtnCallBack_)
    }

    labelParam.fontSize = 24
    labelParam.color = display.COLOR_WHITE

    self.areaRightHalfItemBtns_ = {}

    local setItemBtnArrowMagrinRight = 20

    for i = 1, #areaSetRightItemStrs do
        self.areaRightHalfItemBtns_[i] = cc.ui.UIPushButton.new({normal = "#setg_bgBlkAbout.png", pressed = "#setg_bgBlkAboutHili.png", disabled = "#setg_bgBlkAbout.png"},
            {scale9 = true})
            :setButtonSize(areaRightHalfItemSize.width, areaRightHalfItemSize.height)
            :onButtonClicked(areaSetRightItemBtnCtrlHandlers[i])
            :pos(PANEL_WIDTH / 2 - panelBorWidth - areaMainBlkDentMagrinBorHoriz - areaRightHalfItemSize.width / 2, PANEL_HEIGHT / 2 - panelBorWidth - titleBarSize.height -
                areaMainP1MagrinTop - setItemMagrinEach * (i - 1) - areaRightHalfItemSize.height / 2 * (i * 2 - 1))
            :addTo(self)

        self.areaRightHalfItemBtns_[i].label_ = display.newTTFLabel({text = areaSetRightItemStrs[i], size = labelParam.fontSize, color = labelParam.color, align =
            ui.TEXT_ALIGN_CENTER})
        self.areaRightHalfItemBtns_[i].label_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
        self.areaRightHalfItemBtns_[i].label_:pos(- areaRightHalfItemSize.width / 2 + areaMainSetLblMagrinLeft, 0)
            :addTo(self.areaRightHalfItemBtns_[i])

        self.areaRightHalfItemBtns_[i].arrow_ = display.newSprite("#setg_arrowRight.png")
        self.areaRightHalfItemBtns_[i].arrow_:pos(areaRightHalfItemSize.width / 2 - setItemBtnArrowMagrinRight - self.areaRightHalfItemBtns_[i].arrow_:getContentSize().width / 2, 0)
            :addTo(self.areaRightHalfItemBtns_[i])

        self.areaRightHalfItemBtns_[i]:onButtonPressed(handler(self, self.onAreaSetRightItemBtnPressed_))
        self.areaRightHalfItemBtns_[i]:onButtonRelease(handler(self, self.onAreaSetRightItemBtnRelease_))
    end

    local botBarWidthFixHoriz = 2

    local dentBotStencil = {
        x = 5,
        y = 1,
        width = 113,
        height = 80
    }

    local botDecBarSize = {
        width = PANEL_WIDTH - botBarWidthFixHoriz * 2,
        height = 80
    }

    self.panelBotBar_ = display.newScale9Sprite("#common_bgDentPanelBot.png", 0, - PANEL_HEIGHT / 2 + panelBorWidth + botDecBarSize.height / 2,
        cc.size(botDecBarSize.width, botDecBarSize.height), cc.rect(dentBotStencil.x, dentBotStencil.y, dentBotStencil.width, dentBotStencil.height))
        :addTo(self)

    local avatarImgShownBorLen = 56

    local avatarMagrins = {
        left = 16,
        bottom = 12
    }

    local defaultAvatarImg = display.newSprite("#common_female_avatar.png")
    defaultAvatarImg:scale(avatarImgShownBorLen / defaultAvatarImg:getContentSize().width)
    defaultAvatarImg:pos(avatarImgShownBorLen / 2 + avatarMagrins.left, avatarImgShownBorLen / 2 + avatarMagrins.bottom)
        :addTo(self.panelBotBar_, 1, AVATAR_TAG)

    self.userAvatarLoaderId_ = nk.ImageLoader:nextLoaderId()

    labelParam.fontSize = 26
    labelParam.color = display.COLOR_WHITE

    local userNameLblMagrinLeft = 15
    self.userName_ = display.newTTFLabel({text = "Name", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.userName_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.userName_:pos(defaultAvatarImg:getPositionX() + avatarImgShownBorLen / 2 + userNameLblMagrinLeft, defaultAvatarImg:getPositionY())
        :addTo(self.panelBotBar_)

    labelParam.fontSize = 25
    labelParam.color = display.COLOR_WHITE

    local panelBotOprBtnSize = {
        width = 130,
        height = 45
    }
    
    if not self.isInRoom_ then
        --todo
        self.changeAccBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnGreenRigOutl.png", pressed = "#common_btnGreenRigOutl.png", disabled =
            "#common_btnGreyLitRigOut.png"}, {scale9 = true})
            :setButtonSize(panelBotOprBtnSize.width, panelBotOprBtnSize.height)
            :setButtonLabel(display.newTTFLabel({text = "切换账号", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
            :onButtonClicked(buttontHandler(self, self.onChangeAccBtnCallBack_))
            :pos(botDecBarSize.width / 2 - panelBotOprBtnSize.width / 2, botDecBarSize.height / 2)
            :addTo(self.panelBotBar_)
    end

    local botOprRight2BtnMagrins = {
        right = 24,
        bottom = 20,
        each = 16
    }

    self.gameHelpBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnYellowRigOutl.png", pressed = "#common_btnYellowRigOutl.png", disabled =
        "#common_btnGreyLitRigOut.png"}, {scale9 = true})
        :setButtonSize(panelBotOprBtnSize.width, panelBotOprBtnSize.height)
        :setButtonLabel(display.newTTFLabel({text = "游戏帮助", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked(buttontHandler(self, self.onGameHelpBtnCallBack_))
        :pos(botDecBarSize.width - panelBotOprBtnSize.width * 3 / 2 - botOprRight2BtnMagrins.right - botOprRight2BtnMagrins.each, botDecBarSize.height / 2)
        :addTo(self.panelBotBar_)

    self.feedBackBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnGreenRigOutl.png", pressed = "#common_btnGreenRigOutl.png", disabled =
        "#common_btnGreyLitRigOut.png"}, {scale9 = true})
        :setButtonSize(panelBotOprBtnSize.width, panelBotOprBtnSize.height)
        :setButtonLabel(display.newTTFLabel({text = "反馈", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked(buttontHandler(self, self.onFeedBackBtnCallBack_))
        :pos(botDecBarSize.width - panelBotOprBtnSize.width / 2 - botOprRight2BtnMagrins.right, botDecBarSize.height / 2)
        :addTo(self.panelBotBar_)

    self:addCloseBtn()
    self:addDataObservers()
end

function SettingView:onAvatarLoadComplete_(success, sprite)
    -- body
    if success then
        local oldAvatar = self.panelBotBar_:getChildByTag(AVATAR_TAG)
        if oldAvatar then
            oldAvatar:removeFromParent()
        end

        local sprSize = sprite:getContentSize()
        local avatarShownSize = {
            width = 56,
            height = 56
        }

        if sprSize.width > sprSize.height then
            sprite:scale(avatarShownSize.width / sprSize.width)
        else
            sprite:scale(avatarShownSize.height / sprSize.height)
        end

        local avatarMagrins = {
            left = 16,
            bottom = 12
        }

        sprite:align(display.CENTER, avatarShownSize.width / 2 + avatarMagrins.left, avatarShownSize.height / 2 + avatarMagrins.bottom)
            :addTo(self.panelBotBar_, 1, AVATAR_TAG)
    end
end

-- Main Area Ctrl Events --
function SettingView:onVolumeValueChanged_(evt)
    -- body
    if evt.value <= 0 then
        --todo
        self.gameMuicSetChkBtn_:setButtonSelected(false)
    else
        self.gameMuicSetChkBtn_:setButtonSelected(true)
    end

    self.volumeVal_ = evt.value

    self.preVolumeVal_ = self.curVolumeVal_ or 0
    self.curVolumeVal_ = self.volumeVal_

    local curVolTime = bm.getTime()
    local preVolTime = self.lastGearTickPlayTime_ or 0

    if self.preVolumeVal_ ~= self.curVolumeVal_ and curVolTime - preVolTime > 0.05 then
        self.lastGearTickPlayTime_ = curVolTime
        nk.SoundManager:playSound(nk.SoundManager.GEAR_TICK)
    end
end

function SettingView:onVolumeValueUpdate_(evt)
    -- body
    if self.volumeVal_ then
        cc.UserDefault:getInstance():setIntegerForKey(nk.cookieKeys.VOLUME, self.volumeVal_)
        cc.UserDefault:getInstance():flush()

        nk.SoundManager:updateVolume()
        nk.SoundManager:playSound(nk.SoundManager.CLICK_BUTTON)
    end
end

function SettingView:onGameMusicOnOffStateChanged_(evt)
    -- body
    local defaultVolumeWhenGameMusicOn = 10

    if evt.state == "on" then
        --todo
        self.volumeVal_ = defaultVolumeWhenGameMusicOn
    else
        self.volumeVal_ = 0
    end

    self.volumeSetSlider_:setSliderValue(self.volumeVal_)
    self:onVolumeValueUpdate_()
end

function SettingView:onVibrateOnOffStateChanged_(evt)
    -- body
    if evt.state == "on" then
        --todo
        self.vibrateOnOffVal_ = true

        local deviceVibrateTime = 5 * 100
        nk.Native:vibrate(deviceVibrateTime)
    else
        self.vibrateOnOffVal_ = false
    end
end

function SettingView:onAutoSitOnOffStateChanged_(evt)
    -- body
    if evt.state == "on" then
        --todo
        self.autoSitOnOffVal_ = true
    else
        self.autoSitOnOffVal_ = false
    end
end

function SettingView:onAutoBuyInOnOffStateChanged_(evt)
    -- body
    if evt.state == "on" then
        --todo
        self.autoBuyInOnOffVal_ = true
    else
        self.autoBuyInOnOffVal_ = false
    end
end

function SettingView:onUpdateInfoBtnCallBack_(evt)
    -- body
    local updateBtnIdx = 1
    self.areaRightHalfItemBtns_[updateBtnIdx]:setButtonEnabled(false)

    local params = {device = (device.platform == "windows" and "android" or device.platform), pay = (device.platform == "windows" and "android" or device.platform), noticeVersion =
        "noticeVersion", osVersion = BM_UPDATE and BM_UPDATE.VERSION or nk.Native:getAppVersion(), version = BM_UPDATE and BM_UPDATE.VERSION or nk.Native:getAppVersion(), sid =
            appconfig.ROOT_CGI_SID}
    
    if IS_DEMO then
        params.demo = 1
    end

    nk.http.post_url(appconfig.VERSION_CHECK_URL, params, function(retData)
        if retData then
            local updataParam = json.decode(retData)

            self:checkUpdate(updataParam)
        end
    end, function(errData)
        dump(errData, "nk.http.post_url->" .. appconfig.VERSION_CHECK_URL .. " :===================")
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("COMMON", "BAD_NETWORK"))

        self.areaRightHalfItemBtns_[updateBtnIdx]:setButtonEnabled(true)
    end)
end

function SettingView:onInciteBtnCallBack_(evt)
    -- body
    local inciteBtnIdx = 2
    self.areaRightHalfItemBtns_[inciteBtnIdx]:setButtonEnabled(false)

    device.openURL(BM_UPDATE.COMMENT_URL or "")

    self.areaRightHalfItemBtns_[inciteBtnIdx]:setButtonEnabled(true)
end

function SettingView:onPageFansBtnCallBack_(evt)
    -- body
    local pageFansBtnIdx = 3
    self.areaRightHalfItemBtns_[pageFansBtnIdx]:setButtonEnabled(false)

    device.openURL(bm.LangUtil.getText("ABOUT", "FANS_OPEN"))

    self.areaRightHalfItemBtns_[pageFansBtnIdx]:setButtonEnabled(true)
end

function SettingView:onGameAboutBtnCallBack_(evt)
    -- body
    local gameAboutBtnIdx = 3
    self.areaRightHalfItemBtns_[gameAboutBtnIdx]:setButtonEnabled(false)

    AboutPopup.new():showPanel()

    self.areaRightHalfItemBtns_[gameAboutBtnIdx]:setButtonEnabled(true)
end

function SettingView:onAreaSetRightItemBtnPressed_(evt)
    -- body
    local targetBtn = evt.target

    local btnLblColorPressed = display.COLOR_GREEN
    targetBtn.label_:setTextColor(btnLblColorPressed)
end

function SettingView:onAreaSetRightItemBtnRelease_(evt)
    -- body
    local targetBtn = evt.target

    local btnLblColorRelease = display.COLOR_WHITE
    targetBtn.label_:setTextColor(btnLblColorRelease)
end

-- Area Bot Btns Ctrl Events --
function SettingView:onChangeAccBtnCallBack_(evt)
    -- body
    self:hidePanel()
    bm.EventCenter:dispatchEvent(nk.eventNames.HALL_LOGOUT_SUCC)
end

function SettingView:onGameHelpBtnCallBack_(evt)
    -- body
    local gameHelpTabIdx = 3
    HelpView.new(gameHelpTabIdx):showPanel()

    self:hidePanel()
end

function SettingView:onFeedBackBtnCallBack_(evt)
    -- body
    local feedBackTabIdx = 1
    HelpView.new(feedBackTabIdx):showPanel()

    self:hidePanel()
end

function SettingView:checkUpdate(param)
    local latestVersionNum = bm.getVersionNum(param.curVersion)
    local installVersionNum = bm.getVersionNum(BM_UPDATE.VERSION)

    if latestVersionNum <= installVersionNum then
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("UPDATE", "HAD_UPDATED"))
    else
        UpdatePopup.new(param.verTitle, param.verMessage, param.updateUrl):showPanel()

        local updateBtnIdx = 1
        self.areaRightHalfItemBtns_[updateBtnIdx]:setButtonEnabled(true)
    end
end

function SettingView:addDataObservers()
    -- body
    self.avatarUrlObserverHandler_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "aUser.micon", handler(self, function (obj, micon)
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

    self.nickObserverHandler_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "aUser.name", handler(self, function (obj, name)
        if obj and obj.userName_ then
            obj.userName_:setString(nk.Native:getFixedWidthText("", 24, name, 200))
        end
    end))
end

function SettingView:showPanel()
    -- body
    self:showPanel_()
end

function SettingView:onShowed()
    -- body
    -- Set All Button Default State Value --
    local volumeVal = cc.UserDefault:getInstance():getIntegerForKey(nk.cookieKeys.VOLUME, 100)
    self.volumeVal_ = volumeVal

    self.volumeSetSlider_:setSliderValue(self.volumeVal_)
    self:onVolumeValueUpdate_()

    local isVibrate = cc.UserDefault:getInstance():getBoolForKey(nk.cookieKeys.SHOCK, false)
    self.vibrateOnOffVal_ = isVibrate

    self.vibrateSetChkBtn_:setButtonSelected(self.vibrateOnOffVal_)

    local isAutoSit = cc.UserDefault:getInstance():getBoolForKey(nk.cookieKeys.AUTO_SIT, true)
    self.autoSitOnOffVal_ = isAutoSit

    self.autoSitSetChkBtn_:setButtonSelected(self.autoSitOnOffVal_)

    local isAutoBuyIn = cc.UserDefault:getInstance():getBoolForKey(nk.cookieKeys.AUTO_BUY_IN, true)
    self.autoBuyInOnOffVal_ = isAutoBuyIn

    self.autoBuyInSetChkBtn_:setButtonSelected(self.autoBuyInOnOffVal_)
end

function SettingView:hidePanel()
    -- body
    self:hidePanel_()
end

function SettingView:onEnter()
    -- body
end

function SettingView:onExit()
    -- body
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.name", self.nickObserverHandler_)
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.micon", self.avatarUrlObserverHandler_)

    cc.UserDefault:getInstance():setBoolForKey(nk.cookieKeys.SHOCK, self.vibrateOnOffVal_)
    cc.UserDefault:getInstance():setBoolForKey(nk.cookieKeys.AUTO_SIT, self.autoSitOnOffVal_)
    cc.UserDefault:getInstance():setBoolForKey(nk.cookieKeys.AUTO_BUY_IN, self.autoBuyInOnOffVal_)
    cc.UserDefault:getInstance():flush()
end

function SettingView:onCleanup()
    -- body
    display.removeSpriteFramesWithFile("setting_texture.plist", "setting_texture.png")

    nk.schedulerPool:delayCall(function()
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    end, 0.1)
end

return SettingView