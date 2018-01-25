--
-- Author: viking@boomegg.com
-- Date: 2014-09-04 10:38:07
-- Copyright: Copyright (c) 2014, BOOMEGG INTERACTIVE CO., LTD All rights reserved.
-- Description: UpdatePopup.lua ReConstructed By Tsing7x.
--

local UpdatePopup = class("UpdatePopup", nk.ui.Panel)

function UpdatePopup:ctor(verTitle, verMessage, updateUrl)
    self:setNodeEventEnabled(true)
    self.super.ctor(self, self.SIZE_SMALL)

    self.updateUrl_ = updateUrl or ""
    local labelParam = {
        fontSize = 0,
        color = display.COLOR_BLACK
    }

    labelParam.fontSize = 32
    labelParam.color = display.COLOR_WHITE

    local titleDescLabel = display.newTTFLabel({text = verTitle or bm.LangUtil.getText("UPDATE", "TITLE"), size = labelParam.fontSize, color = labelParam.color, align =
        ui.TEXT_ALIGN_CENTER})

    self:addPanelTitleBar(titleDescLabel)
    local titleBarSize = self:getTitleBarSize()
    local panelBorWidth = 6

    local gameIconLogoBgMagrins = {
        left = 40,
        top = 26
    }

    local gameIcLogoBg = display.newSprite("#setg_bgGameIcLogo.png")
    gameIcLogoBg:pos(- self.width_ / 2 + panelBorWidth + gameIconLogoBgMagrins.left + gameIcLogoBg:getContentSize().width / 2, self.height_ / 2 - panelBorWidth -
        titleBarSize.height - gameIconLogoBgMagrins.top - gameIcLogoBg:getContentSize().height / 2)
        :addTo(self)

    local gameIcLogoDisplayBorWidth = 134
    local gameIconLogo = display.newSprite("#common_icGameLogo.png")
        :pos(gameIcLogoBg:getContentSize().width / 2, gameIcLogoBg:getContentSize().height / 2)
        :addTo(gameIcLogoBg)

    gameIconLogo:scale(gameIcLogoDisplayBorWidth / gameIconLogo:getContentSize().width)

    local updVerInfoContScrollViewMagrins = {
        top = 35,
        right = 38
    }

    local updVerContScrollViewSize = {
        width = 258,
        height = 132
    }

    local scrollViewContainer = display.newNode()
        :pos(self.width_ / 2 - panelBorWidth - updVerInfoContScrollViewMagrins.right - updVerContScrollViewSize.width / 2, self.height_ / 2 - panelBorWidth -
            titleBarSize.height - updVerInfoContScrollViewMagrins.top - updVerContScrollViewSize.height / 2)
        :addTo(self)

    local scrollContentNode = display.newNode()

    labelParam.fontSize = 25
    labelParam.color = display.COLOR_WHITE

    local updVerInfoLblContMarinScrollBor = 4
    local updVerInfoCont = display.newTTFLabel({text = verMessage, size = labelParam.fontSize, color = labelParam.color, dimensions = cc.size(updVerContScrollViewSize.width -
        updVerInfoLblContMarinScrollBor * 2), align = ui.TEXT_ALIGN_CENTER})
        :addTo(scrollContentNode)

    self.updaVerInfoContScrollView_ = bm.ui.ScrollView.new({viewRect = cc.rect(- updVerContScrollViewSize.width / 2, - updVerContScrollViewSize.height / 2,
        updVerContScrollViewSize.width, updVerContScrollViewSize.height), scrollContent = scrollContentNode, direction = bm.ui.ScrollView.DIRECTION_VERTICAL})
        :addTo(scrollViewContainer)

    local botAreaOprBtnSize = {
        width = 180,
        height = 60
    }

    local botBtnsMagrinBotBor = 30
    local botBtnsGapEachHoriz = 94

    labelParam.fontSize = 28
    labelParam.color = display.COLOR_WHITE

    self.updLaterBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnGreenRigOutl.png", pressed = "#common_btnGreenRigOutl.png", disabled = "#common_btnGreyLitRigOut.png"},
        {scale9 = true})
        :setButtonSize(botAreaOprBtnSize.width, botAreaOprBtnSize.height)
        :setButtonLabel(display.newTTFLabel({text = "以后再说", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked(buttontHandler(self, self.onUpdLaterBtnCallBack_))
        :pos(- botAreaOprBtnSize.width / 2 - botBtnsGapEachHoriz / 2, - self.height_ / 2 + panelBorWidth + botBtnsMagrinBotBor + botAreaOprBtnSize.height / 2)
        :addTo(self)

    self.updNowBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnYellowRigOutl.png", pressed = "#common_btnYellowRigOutl.png", disabled = "#common_btnGreyLitRigOut.png"},
        {scale9 = true})
        :setButtonSize(botAreaOprBtnSize.width, botAreaOprBtnSize.height)
        :setButtonLabel(display.newTTFLabel({text = "立即升级", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked(buttontHandler(self, self.onUpdNowBtnCallBack_))
        :pos(botAreaOprBtnSize.width / 2 + botBtnsGapEachHoriz / 2, - self.height_ / 2 + panelBorWidth + botBtnsMagrinBotBor + botAreaOprBtnSize.height / 2)
        :addTo(self)

    self:addCloseBtn()
end

function UpdatePopup:onUpdLaterBtnCallBack_(evt)
    -- body
    self:hidePanel_()
end

function UpdatePopup:onUpdNowBtnCallBack_(evt)
    -- body
    device.openURL(self.updateUrl_)
    self:hidePanel_()
end

function UpdatePopup:showPanel()
    self:showPanel_()
end

function UpdatePopup:onShowed()
    self.updaVerInfoContScrollView_:update()
end

function UpdatePopup:onEnter()
    -- body
end

function UpdatePopup:onExit()
    -- body
end

function UpdatePopup:onCleanup()
    -- body
end

return UpdatePopup