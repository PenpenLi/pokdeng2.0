--
-- Author: johnny@boomegg.com
-- Date: 2014-08-09 17:27:11
-- Copyright: Copyright (c) 2014, BOOMEGG INTERACTIVE CO., LTD All rights reserved.
-- Description: ChooseRoomChip.lua Reconstructed By Tsing7x.
-- 

local ChooseRoomChip = class("ChooseRoomChip", function ()
    return display.newNode()
end)

function ChooseRoomChip:ctor(chipSkin, textColor)

    self.chip_ = display.newSprite(chipSkin)
        :addTo(self)
    self.chip_:setTouchEnabled(true)
    self.chip_:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch_))

    -- Init Param Label --
    local labelParam = {
        fontSize = 0,
        color = textColor
    }

    labelParam.fontSize = 35
    -- PreCall --
    local preCallLblPosYOffSet = 20
    self.preCallLabel_= display.newTTFLabel({text = "0", color = labelParam.color, size = labelParam.fontSize, align = ui.TEXT_ALIGN_CENTER})
        :pos(0, preCallLblPosYOffSet)
        :addTo(self)

    labelParam.fontSize = 18
    labelParam.color = display.COLOR_WHITE

    -- Online Player Num--
    local playerCountLblPosYOffSet = 32
    local playerCountLblPosXOffSet = 8
    self.playerCountLabel_ = display.newTTFLabel({text = "0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
        :align(display.CENTER, playerCountLblPosXOffSet, - playerCountLblPosYOffSet)
        :addTo(self)

    labelParam.fontSize = 18
    labelParam.color = cc.c3b(0x6C, 0xAA, 0x34)

    local minBuyInLblPosYShift = 8
    self.minBuyInLabel_ = display.newTTFLabel({text = bm.LangUtil.getText("HALL", "MIN_IN_TO_ROOM_TEXT", 0), color = labelParam.color,
        size = labelParam.fontSize, align = ui.TEXT_ALIGN_CENTER})
        :pos(0, - self.chip_:getContentSize().height / 2 - minBuyInLblPosYShift)
        :addTo(self)
end

function ChooseRoomChip:onTouch_(evt)
    local chipTouchScaledFactor = .9
    local chipTouchScaleTime = .05

    self.touchInSprite_ = self.chip_:getCascadeBoundingBox():containsPoint(cc.p(evt.x, evt.y))

    if evt.name == "began" then
        self:scaleTo(chipTouchScaleTime, chipTouchScaledFactor)

        self.clickCanced_ = false
        return true
    elseif evt.name == "moved" then
        if not self.touchInSprite_ and not self.clickCanced_ then
            self:scaleTo(chipTouchScaleTime, 1)
            self.clickCanced_ = true
        end

    elseif evt.name == "ended" or name == "cancelled" then
        if not self.clickCanced_ then
            nk.SoundManager:playSound(nk.SoundManager.CLICK_BUTTON)
            self:scaleTo(chipTouchScaleTime, 1)

            if self.callback_ then
                self.callback_(self.preCall_)
            end
        end
    end
end

function ChooseRoomChip:setPlayerCount(count)
    if count >= 0 then
        self.playerCountLabel_:setString(bm.formatNumberWithSplit(count))
    end
end

function ChooseRoomChip:setPreCall(val)
    self.preCall_ = val
    if self.preCall_ and #self.preCall_ > 4 then

        if tonumber(self.preCall_[2]) > 0 then
            --todo
            self.preCallLabel_:setString(bm.formatBigNumber(self.preCall_[2]))
        else
            self.preCallLabel_:setString(bm.formatBigNumber(0))
        end

        self.minBuyInLabel_:setString(bm.LangUtil.getText("HALL", "MIN_IN_TO_ROOM_TEXT", bm.formatBigNumber(self.preCall_[13])))
    end
end

function ChooseRoomChip:setRoomTypeCash(isRoomTypeCash)
    -- body
    if isRoomTypeCash then
        --todo
        local perCallLblFontSizeAdj = 42

        self.preCallLabel_:setString(bm.formatNumberWithCurrenySfx(self.preCall_[2], "฿"))
        self.preCallLabel_:setSystemFontSize(perCallLblFontSizeAdj)
    end
end

function ChooseRoomChip:getValue()
    return (self.preCall_ and self.preCall_[2] or 0)
end

function ChooseRoomChip:getPreCall()
    return self.preCall_
end

function ChooseRoomChip:onChipClick(callback)
    assert(type(callback) == "function", "callback should be a function")
    self.callback_ = callback
    return self
end

return ChooseRoomChip