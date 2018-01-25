--
-- Author: viking@boomegg.com
-- Date: 2014-09-04 16:38:09
-- Copyright: Copyright (c) 2014, BOOMEGG INTERACTIVE CO., LTD All rights reserved.
-- Description: AboutPopup.lua ReConstructed By Tsing7x.
--

local AboutPopup = class("AboutPopup", nk.ui.Panel)

function AboutPopup:ctor()
    self:setNodeEventEnabled(true)
    self.super.ctor(self, self.SIZE_SMALL)

    local titleDesc = display.newSprite("#setg_decDescAboutTi.png")
    self:addPanelTitleBar(titleDesc)

    local titleBarSize = self:getTitleBarSize()
    local panelBorWidth = 6

    local labelParam = {
        fontSize = 0,
        color = display.COLOR_BLACK
    }

    local currentVersion = nk.Native:getAppVersion()
    local aboutInfoStrs = {
        "当前用户ID: " .. nk.userData["aUser.mid"],
        "版本号: " .. (BM_UPDATE and BM_UPDATE.VERSION or currentVersion),
        "官方粉丝页:",
        "https://www.facebook.com/pokdengtl"
    }

    local aboutInfoLblMagrins = {
        left = 40,
        top = 26,
        vectEach = 12
    }

    labelParam.fontSize = 22
    labelParam.color = display.COLOR_WHITE

    local aboutInfoLblModel = display.newTTFLabel({text = aboutInfoStrs[1], size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    local aboutInfoLblSizeCal = aboutInfoLblModel:getContentSize()

    local aboutInfoLabel = nil

    for i = 1, #aboutInfoStrs do
        aboutInfoLabel = display.newTTFLabel({text = aboutInfoStrs[i], size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
        aboutInfoLabel:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
        aboutInfoLabel:pos(- self.width_ / 2 + panelBorWidth + aboutInfoLblMagrins.left, self.height_ / 2 - panelBorWidth - titleBarSize.height -
            aboutInfoLblMagrins.top - aboutInfoLblSizeCal.height / 2 * (i * 2 - 1) - aboutInfoLblMagrins.vectEach * (i - 1))
            :addTo(self)
    end

    local dividLineMagrinBot = 90
    local infoDividLine = display.newSprite("#setg_divlInfoAbout.png")
    infoDividLine:pos(0, - self.height_ / 2 + panelBorWidth + dividLineMagrinBot + infoDividLine:getContentSize().height / 2)
        :addTo(self)

    local aboutInfoTermsMagrinDivLine = 18
    local aboutInfoCopyRightMagrinTermLbl = 12

    labelParam.fontSize = 15
    labelParam.color = display.COLOR_WHITE

    local infoTermsLabel = display.newTTFLabel({text = "服务条款与隐私策略", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    infoTermsLabel:pos(0, infoDividLine:getPositionY() - infoDividLine:getContentSize().height / 2 - aboutInfoTermsMagrinDivLine -
        infoTermsLabel:getContentSize().height / 2)
        :addTo(self)

    local copyRightAddLabel = display.newTTFLabel({text = bm.LangUtil.getText("ABOUT", "COPY_RIGHT"), size = labelParam.fontSize, color = labelParam.color,
        align = ui.TEXT_ALIGN_CENTER})
    copyRightAddLabel:pos(0, infoTermsLabel:getPositionY() - infoTermsLabel:getContentSize().height / 2 - aboutInfoCopyRightMagrinTermLbl -
        copyRightAddLabel:getContentSize().height / 2)
        :addTo(self)

    self:addCloseBtn()
end

function AboutPopup:showPanel()
    self:showPanel_()
end

function AboutPopup:hidePanel()
    self:hidePanel_()
end

function AboutPopup:onEnter()
    -- body
end

function AboutPopup:onExit()
    -- body
end

function AboutPopup:onCleanup()
    -- body
end

return AboutPopup