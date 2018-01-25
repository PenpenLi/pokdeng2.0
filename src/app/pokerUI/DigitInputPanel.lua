--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-04-17 15:07:30
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: DigitInputPanel.lua Create By Tsing7x.
--

local DigitInputPanel = class("DigitInputPanel", function()
    return display.newNode()
end)

-- DigitInputPanel Addto Display.runningScene, @param zOrder :DigitInputPanel's zOrder
function DigitInputPanel:ctor(zOrder)
    self:setNodeEventEnabled(true)

    self.panelZorder = zOrder or 999
    self.background_ = display.newScale9Sprite("#common_modTransparent.png", 0, 0, cc.size(display.width, display.height))
        :addTo(self)

    self.background_:setTouchEnabled(true)
    self.background_:setTouchSwallowEnabled(true)

    self.background_:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onBackgourndTouch_))

    local bgDigitPanelBotSize = {
        width = display.width,
        height = 166
    }

    local bgDigitPanelBot = display.newScale9Sprite("#common_bgDigInputBot.png", display.width / 2, bgDigitPanelBotSize.height / 2,
        cc.size(bgDigitPanelBotSize.width, bgDigitPanelBotSize.height))
        :addTo(self.background_)

    bgDigitPanelBot:setTouchEnabled(true)
    bgDigitPanelBot:setTouchSwallowEnabled(true)

    local digitBtnsMagrinBorHoriz = 10
    local digitBtnsMagrinEachHoriz = 12
    local digitBtnsMagrinEachVert = 8

    local btnDitgitNumImgKeys = {}

    local sumBtnNum = 12
    local btnShownLine = 2

    for i = 1, sumBtnNum do
        if i <= 5 then
            --todo
            table.insert(btnDitgitNumImgKeys, "#common_digInputNum_" .. i .. ".png")
        elseif i == 6 then
            --todo
            table.insert(btnDitgitNumImgKeys, "#common_digInputTagBack.png")
        elseif i <= 10 then
            --todo
            table.insert(btnDitgitNumImgKeys, "#common_digInputNum_" .. (i - 1) .. ".png")
        elseif i == 11 then
            --todo
            table.insert(btnDitgitNumImgKeys, "#common_digInputNum_0.png")
        else
            table.insert(btnDitgitNumImgKeys, "#common_digInputTagACK.png")
        end
    end

    local digitBtnSize = {
        width = (display.width - digitBtnsMagrinBorHoriz * 2 - digitBtnsMagrinEachHoriz * 5) / 6,
        height = 72
    }

    self.digitBtns_ = {}
    for i = 1, sumBtnNum do
        local btnIdxInX = (i - 1) % (sumBtnNum / btnShownLine) + 1 -- Distance No. Of BtnNum 1 ~ 6
        local btnIdxInY = math.floor((sumBtnNum - i) / (sumBtnNum / btnShownLine)) - 1  -- Distance RPP Of Half Height 0 or - 1

        self.digitBtns_[i] = cc.ui.UIPushButton.new({normal = "#common_btnDigInputNum.png", pressed = "#common_btnDigInputNum.png",
            disabled = "#common_btnDigInputNum.png"}, {scale9 = true})
            :setButtonSize(digitBtnSize.width, digitBtnSize.height)
            :onButtonClicked(buttontHandler(self, self.onPanelBtnCallBack_))
            :pos(digitBtnsMagrinBorHoriz + digitBtnSize.width * (2 * btnIdxInX - 1) / 2 + digitBtnsMagrinEachHoriz * (btnIdxInX - 1),
                (digitBtnsMagrinEachVert + digitBtnSize.height) * (btnIdxInY + 0.5) + bgDigitPanelBotSize.height / 2)
            :addTo(bgDigitPanelBot)

        self.digitBtns_[i].btnImg_ = display.newSprite(btnDitgitNumImgKeys[i])
            :addTo(self.digitBtns_[i])

        if i <= 5 then
            --todo
            self.digitBtns_[i].index_ = i
        elseif i == 6 then
            --todo
            self.digitBtns_[i].index_ = "del"
        elseif i <= 10 then
            --todo
            self.digitBtns_[i].index_ = i - 1
        elseif i == 11 then
            --todo
            self.digitBtns_[i].index_ = 0
        else
            self.digitBtns_[i].index_ = "ok"
        end
    end
end

function DigitInputPanel:onBackgourndTouch_(evt)
    -- body
    self:removeFromParent()
end

function DigitInputPanel:onPanelBtnCallBack_(evt)
    -- body
    local btnTarget = evt.target
    local btnIndex = btnTarget.index_

    if type(btnIndex) == "number" then
        --todo
        if self.digitInputCallback_ then
            --todo
            self.digitInputCallback_(btnIndex)
        end

    elseif type(btnIndex) == "string" then
        --todo
        if btnIndex == "del" then
            --todo
            if self.delOprCallback_ then
                --todo
                self.delOprCallback_()
            end
        elseif btnIndex == "ok" then
            --todo
            self:removeFromParent()
        end
    end
end

function DigitInputPanel:showPanel(onDigitInputCallBack, onDelCallBack)
    -- body
    self.digitInputCallback_ = onDigitInputCallBack
    self.delOprCallback_ = onDelCallBack

    self:pos(display.cx, display.cy)
        :addTo(nk.runningScene, self.panelZorder)

    bm.EventCenter:dispatchEvent(nk.eventNames.DISENABLED_EDITBOX_TOUCH)
end

function DigitInputPanel:onEnter()
    -- body
end

function DigitInputPanel:onExit()
    -- body
    bm.EventCenter:dispatchEvent(nk.eventNames.ENABLED_EDITBOX_TOUCH)
end

function DigitInputPanel:onCleanup()

end

return DigitInputPanel