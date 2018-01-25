--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-03-14 15:13:34
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: Panel.lua Recontructed By Tsing7x.
--
local ZORDER_DEC = 8
local ZORDER_COMPON = 6

local Panel = class("Panel", function()
    return display.newNode()
end)

Panel.SIZE_SMALL = {524, 360}
Panel.SIZE_NORMAL = {684, 420}
Panel.SIZE_LARGE = {794, 470}

Panel.ZORDER_CONT = 9

function Panel:ctor(size)
    self:setNodeEventEnabled(true)
    self.width_, self.height_= size[1], size[2]

    local panelStencil = {
        x = 10,
        y = 10,
        width = 42,
        height = 66
    }

    self.background_ = display.newScale9Sprite("#common_bgPanel.png", 0, 0, cc.size(self.width_, self.height_), cc.rect(panelStencil.x,
        panelStencil.y, panelStencil.width, panelStencil.height))
        :addTo(self)

    self.background_:setTouchEnabled(true)
    self.background_:setTouchSwallowEnabled(true)

    local decHiliBorScaleInWH = 0.6
    local decHiliBorder = display.newScale9Sprite("#common_decPanelHiliBor.png")
    local decHiliBorSizaCal = decHiliBorder:getContentSize()

    local decHiliDot = display.newSprite("#common_decPanelLiDot.png")

    local decBorRoundEdgeDistance = 5
    local decBorRoundEdgeHorizFix = 4

    local decDotBorTopDisFix = 2

    -- Dec Top --
    local decHiliBorTop = decHiliBorder:clone()
    decHiliBorTop:setContentSize(self.width_ * decHiliBorScaleInWH, decHiliBorSizaCal.height)
    decHiliBorTop:pos(self.width_ / 2, self.height_ - decHiliBorSizaCal.height / 2 - decBorRoundEdgeDistance)
        :addTo(self.background_, ZORDER_DEC)

    decHiliDot:pos(self.width_ / 6, self.height_ - decBorRoundEdgeDistance - decDotBorTopDisFix)
        :addTo(self.background_, ZORDER_DEC)

    -- Dec Bottom --
    local decHiliBorBottom = decHiliBorder:clone()
    decHiliBorBottom:setContentSize(self.width_ * decHiliBorScaleInWH, decHiliBorSizaCal.height)
    decHiliBorBottom:pos(self.width_ / 2, decHiliBorSizaCal.height / 2 + decBorRoundEdgeDistance)
        :addTo(self.background_, ZORDER_DEC)

    local decHiliDotBotttom = decHiliDot:clone()
    decHiliDotBotttom:pos(self.width_ * 4 / 5, decBorRoundEdgeDistance)
        :addTo(self.background_, ZORDER_DEC)

    -- Dec Left --
    local decHiliBorLeft = decHiliBorder:clone()
    decHiliBorLeft:setContentSize(self.height_ * decHiliBorScaleInWH, decHiliBorSizaCal.height)
    decHiliBorLeft:rotation(90)
    decHiliBorLeft:pos(decBorRoundEdgeDistance + decBorRoundEdgeHorizFix, self.height_ * 2 / 5)
        :addTo(self.background_, ZORDER_DEC)

    -- Dec Right --
    local decHiliBorRight = decHiliBorder:clone()
    decHiliBorRight:setContentSize(self.height_ * decHiliBorScaleInWH, decHiliBorSizaCal.height)
    decHiliBorRight:rotation(270)
    decHiliBorRight:pos(self.width_ - decBorRoundEdgeDistance - decBorRoundEdgeHorizFix, self.height_ * 2 / 5)
        :addTo(self.background_, ZORDER_DEC)
end

-- @Param labelTitle : Obj Label Nomaly, Node Etc.
function Panel:addPanelTitleBar(labelTitle)
    -- body
    local titleBarModel = display.newSprite("#common_bgPanelTilBar.png")
    local titleBarSizeCal = titleBarModel:getContentSize()

    local titleBarGapBgTop = 10
    local titleBarSizeWFix = 9

    self.panelTitleBar_ = display.newScale9Sprite("#common_bgPanelTilBar.png", self.width_ / 2, self.height_ -
        titleBarSizeCal.height / 2 - titleBarGapBgTop, cc.size(self.width_ - titleBarSizeWFix * 2, titleBarSizeCal.height))
        :addTo(self.background_, ZORDER_COMPON)

    local titleBarDecLeft = display.newSprite("#common_decPanelTilLeft.png")
    titleBarDecLeft:pos(titleBarDecLeft:getContentSize().width / 2, titleBarSizeCal.height - titleBarDecLeft:getContentSize().height / 2)
        :addTo(self.panelTitleBar_)

    local titleBarDecRightPosYFix = 2
    local titleBarDecRight = display.newSprite("#common_decPanelTilRight.png")
    titleBarDecRight:pos(self.panelTitleBar_:getContentSize().width - titleBarDecRight:getContentSize().width / 2, titleBarDecRight:getContentSize().height / 2 +
        titleBarDecRightPosYFix)
        :addTo(self.panelTitleBar_)

    if labelTitle then
        --todo
        self.panelTitle_ = labelTitle
        self.panelTitle_:pos(self.panelTitleBar_:getContentSize().width / 2, titleBarSizeCal.height / 2)
            :addTo(self.panelTitleBar_)
    end

    return self
end

function Panel:addDecInnerTop()
    -- body
    local innerTopDecPosXFix = 10
    local innerTopDecPosYFix = 11

    local innerTopDecLeft = display.newSprite("#common_decPanelTilLeft.png")
    innerTopDecLeft:pos(innerTopDecLeft:getContentSize().width / 2 + innerTopDecPosXFix, self.height_ - innerTopDecLeft:getContentSize().height / 2 -
        innerTopDecPosYFix)
        :addTo(self.background_, ZORDER_COMPON - 1)

    local innerTopDecRight = innerTopDecLeft:clone()
        :flipX(true)

    innerTopDecRight:pos(self.width_ - innerTopDecRight:getContentSize().width / 2 - innerTopDecPosXFix,
        self.height_ - innerTopDecRight:getContentSize().height / 2 - innerTopDecPosYFix)
        :addTo(self.background_, ZORDER_COMPON - 1)

    return self
end

function Panel:addDecInnerBottom()
    -- body
    local innerBottomDecPosXFix = 10
    local innerBottomDecPosYFix = 7

    local innerBotDecRight = display.newSprite("#common_decPanelTilRight.png")
    innerBotDecRight:pos(self.width_ - innerBotDecRight:getContentSize().width / 2 - innerBottomDecPosXFix, innerBotDecRight:getContentSize().height / 2 +
        innerBottomDecPosYFix)
        :addTo(self.background_, ZORDER_COMPON - 1)

    local innerBotDecLeft = innerBotDecRight:clone()
        :flipX(true)

    innerBotDecLeft:pos(innerBotDecLeft:getContentSize().width / 2 + innerBottomDecPosXFix, innerBotDecLeft:getContentSize().height / 2 + innerBottomDecPosYFix)
        :addTo(self.background_, ZORDER_COMPON - 1)

    return self
end

function Panel:addCloseBtn()
    -- local closeBtnSize = {
    --     width = 64,
    --     height = 64
    -- }

    local closeBtnPosAdj = {
        x = 6,
        y = 5
    }

    if self.closeBtn_ then
        --todo
        self.closeBtn_:removeFromParent()
        self.closeBtn_ = nil
    end

    self.closeBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnPanelClose.png", pressed = "#common_btnPanelClose.png", disabled = "#common_btnPanelClose.png"},
        {scale9 = false})
        :onButtonClicked(buttontHandler(self, self.onClose))
        :pos(self.width_ - closeBtnPosAdj.x, self.height_ - closeBtnPosAdj.y)
        :addTo(self.background_, self.ZORDER_CONT)

    return self
end

function Panel:onClose()
    self:hidePanel_()
end

-- @Param label : Obj Label Nomaly, Node Etc.
function Panel:setPanelTitleLabel(label)
    -- body
    if self.panelTitle_ then
        --todo
        self.panelTitle_:removeFromParent()
        self.panelTitle_ = nil
    end

    self.panelTitle_ = label
    self.panelTitle_:pos(self.panelTitleBar_:getContentSize().width / 2, self.panelTitleBar_:getContentSize().height / 2)
        :addTo(self.panelTitleBar_)

    return self
end

function Panel:getTitleBarSize()
    -- body
    if self.panelTitleBar_ then
        --todo
        local panelTitleBarSize = self.panelTitleBar_:getContentSize()

        return panelTitleBarSize

    else
        dump("No TitleBar,Please Init it.")
    end

    return nil
end

function Panel:showPanel_(isModal, isCentered, closeWhenTouchModel, useShowAnimation)
    nk.PopupManager:addPopup(self, isModal ~= false, isCentered ~= false, closeWhenTouchModel ~= false, useShowAnimation ~= false)
    return self
end

function Panel:hidePanel_()
    nk.PopupManager:removePopup(self)
end

function Panel:onEnter()
    -- body
end

function Panel:onExit()
    -- body
end

function Panel:onCleanup()
    -- body
end

return Panel
