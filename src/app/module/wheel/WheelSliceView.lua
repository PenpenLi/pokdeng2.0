--
-- Author: viking@boomegg.com
-- Date: 2014-10-29 14:52:20
-- Copyright: Copyright (c) 2014, BOOMEGG INTERACTIVE CO., LTD All rights reserved.
-- Description: WheelSliceView.lua Reconstructed By Tsing7x.
--

local WheelSliceView = class("WheelSliceView", function()
    return display.newNode()
end)

WheelSliceView.BLUE = 0
WheelSliceView.GREEN = 1

function WheelSliceView:ctor(color)
    self:setNodeEventEnabled(true)

    self.viewId_ = 0
    self.viewBg_ = nil
    local textColor = nil

    local labelParam = {
        fontSize = 0,
        color = display.COLOR_WHITE
    }

    if color ==  WheelSliceView.BLUE then
        self.viewBg_ = display.newSprite("#wheel_bgFanBlue.png")
        textColor = display.COLOR_WHITE
    else
        self.viewBg_ = display.newSprite("#wheel_bgFanGreen.png")
        textColor = display.COLOR_WHITE
    end

    self.viewBg_:setAnchorPoint(display.ANCHOR_POINTS[display.BOTTOM_CENTER])
    self.viewBg_:addTo(self)

    local wheelFanTopBorPosYFix = 12
    self.rewWinHiliBor_ = display.newSprite("#wheel_decHiliBorRewFan.png")
    self.rewWinHiliBor_:setAnchorPoint(display.ANCHOR_POINTS[display.BOTTOM_CENTER])
    self.rewWinHiliBor_:pos(0, - wheelFanTopBorPosYFix)
        :addTo(self)
        :hide()

    self.viewBgSize = self.viewBg_:getContentSize()

    labelParam.fontSize = 18
    labelParam.color = textColor

    local rewDescMagrinTop = 25
    self.rewDesc_ = display.newTTFLabel({text = "rewName * 0", size = labelParam.fontSize, color = labelParam.color, align =
        ui.TEXT_ALIGN_CENTER})

    self.rewDesc_:pos(self.viewBgSize.width / 2, self.viewBgSize.height - rewDescMagrinTop - self.rewDesc_:getContentSize().height / 2)
        :addTo(self.viewBg_)
end

function WheelSliceView:setDescText(text)
    self.rewDesc_:setString(text)
end

function WheelSliceView:setRewImageKey(imgKey)
    local rewIcFixBgCnt = 35

    self.rewIcFrame_ = display.newSprite("#" .. imgKey)
        :pos(self.viewBgSize.width / 2, self.viewBgSize.height / 2 + rewIcFixBgCnt)
        :addTo(self.viewBg_)
        :scale(.8)
end

function WheelSliceView:setViewId(id)
    -- body
    self.viewId_ = id or 0
end

function WheelSliceView:setSelfRewardWoned(iswin)
    -- body
    if iswin then
        --todo
        self.rewWinHiliBor_:show()
    else
        self.rewWinHiliBor_:hide()
    end
end

function WheelSliceView:getViewId()
    -- body
    return self.viewId_
end

function WheelSliceView:onEnter()
    -- body
end

function WheelSliceView:onExit()
    -- body
end

function WheelSliceView:onCleanup()
    
end

return WheelSliceView