--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-06-09 15:48:32
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: ExchangeWarePopup.lua Created By Tsing7x.
--

local ExchangeWarePopup = class("ExchangeWarePopup", nk.ui.Panel)

local PANEL_WIDTH = 520
local PANEL_HEIGHT = 360

function ExchangeWarePopup:ctor(controller, data)
    self.controller_ = controller
    self.prdData_ = data
    self:setNodeEventEnabled(true)

    self.super.ctor(self, {PANEL_WIDTH, PANEL_HEIGHT})

    local descTitle = display.newSprite("#excMar_decTitleExc.png")
    self:addPanelTitleBar(descTitle)

    local titleBarSize = self:getTitleBarSize()
    local panelBorWidth = 6

    local prdImgBgMagrins = {
        top = 24,
        left = 26
    }

    local prdImgBg = display.newSprite("#excMar_bgExcPrdImg.png")
    prdImgBg:pos(- PANEL_WIDTH / 2 + panelBorWidth + prdImgBgMagrins.left + prdImgBg:getContentSize().width / 2, PANEL_HEIGHT / 2 - panelBorWidth - titleBarSize.height -
        prdImgBgMagrins.top - prdImgBg:getContentSize().height / 2)
        :addTo(self)

    self.prdImg_ = display.newSprite()
        :pos(prdImgBg:getContentSize().width / 2, prdImgBg:getContentSize().height / 2)
        :addTo(prdImgBg)

    self.prdImgLoaderId_ = nk.ImageLoader:nextLoaderId()
    nk.ImageLoader:loadAndCacheImage(self.prdImgLoaderId_, self.prdData_.imgurl or "", handler(self, self.onPrdImgLoaded_))

    local labelParam = {
        fontSize = 0,
        color = display.COLOR_BLACK
    }

    local prdInfoDescLblsMagrinLeft = 22
    local prdDescTitleMagrinTop = 24

    labelParam.fontSize = 25
    labelParam.color = display.COLOR_WHITE
    local prdTitle = display.newTTFLabel({text = self.prdData_.giftname or "Title", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    prdTitle:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    prdTitle:pos(prdImgBg:getPositionX() + prdImgBg:getContentSize().width / 2 + prdInfoDescLblsMagrinLeft, PANEL_HEIGHT / 2 - panelBorWidth - titleBarSize.height -
        prdDescTitleMagrinTop - prdTitle:getContentSize().height / 2)
        :addTo(self)

    local prdDescLblMagrinTop = 4
    local prdDescLblShownSize = {
        width = 278,
        height = 62
    }

    labelParam.fontSize = 22
    labelParam.color = display.COLOR_WHITE
    local prdDesc = display.newTTFLabel({text = self.prdData_.desc or "", size = labelParam.fontSize, color = labelParam.color, dimensions = cc.size(prdDescLblShownSize.width,
        0), align = ui.TEXT_ALIGN_LEFT})
    prdDesc:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    prdDesc:pos(prdTitle:getPositionX(), prdTitle:getPositionY() - prdTitle:getContentSize().height / 2 - prdDescLblMagrinTop - prdDesc:getContentSize().height / 2)
        :addTo(self)

    labelParam.fontSize = 25
    labelParam.color = display.COLOR_WHITE
    local excConditionTitle = display.newTTFLabel({text = "兑换条件", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    excConditionTitle:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    excConditionTitle:pos(prdTitle:getPositionX(), prdTitle:getPositionY() - prdTitle:getContentSize().height / 2 - prdDescLblShownSize.height -
        excConditionTitle:getContentSize().height / 2)
        :addTo(self)

    local prdNumRemain = self.prdData_.num or 0
    local prdNumStr = bm.formatNumberWithSplit(prdNumRemain)

    local excCurrencyInfo = nil
    local excCurrencyData = self.prdData_.price

    if checkint(excCurrencyData) > 0 then
        --todo
        if self.prdData_.exchangeMethod == "chip" then
            --todo
            local chipNum = nil

            if tonumber(excCurrencyData) < 100000 then
                chipNum  = bm.formatNumberWithSplit(excCurrencyData)
            else
                chipNum = bm.formatBigNumber(tonumber(excCurrencyData))
            end

            excCurrencyInfo = "消耗" .. chipNum .. "筹码可获得,剩余" .. prdNumStr
        elseif self.prdData_.exchangeMethod == "point" then
            --todo
            local cashNum = nil

            if tonumber(excCurrencyData) < 100000 then
                cashNum  = bm.formatNumberWithSplit(excCurrencyData)
            else
                cashNum = bm.formatBigNumber(tonumber(excCurrencyData))
            end

            excCurrencyInfo = "消耗" .. cashNum .. "现金币可获得,剩余" .. prdNumStr
        else
            excCurrencyInfo = "消耗0筹码可获得,剩余" .. prdNumStr
        end
    else
        local curCombinData = json.decode(excCurrencyData)

        if checkint(curCombinData.money) > 0  and checkint(curCombinData.point)>0 then
            --todo
            local chipNum = nil
            local cashNum = nil

            if tonumber(curCombinData.money) < 100000 then
                --todo
                chipNum  = bm.formatNumberWithSplit(curCombinData.money)
            else
                chipNum = bm.formatBigNumber(tonumber(curCombinData.money))
            end

            if tonumber(curCombinData.point) < 100000 then
                --todo
                cashNum  = bm.formatNumberWithSplit(curCombinData.point)
            else
                cashNum = bm.formatBigNumber(tonumber(curCombinData.point))
            end

            excCurrencyInfo = "消耗" .. chipNum .. "筹码+" .. cashNum .. "现金币可获得,剩余" .. prdNumStr
        elseif checkint(curCombinData.point) > 0 and checkint(curCombinData.ticket) > 0 then
            --todo
            local cashNum = nil
            local excTicketNum = nil

            if tonumber(curCombinData.point) < 100000 then
                --todo
                cashNum  = bm.formatNumberWithSplit(curCombinData.point)
            else
                cashNum = bm.formatBigNumber(tonumber(curCombinData.point))
            end

            if tonumber(curCombinData.ticket) < 100000 then
                --todo
                excTicketNum  = bm.formatNumberWithSplit(curCombinData.ticket)
            else
                excTicketNum = bm.formatBigNumber(tonumber(curCombinData.ticket))
            end

            excCurrencyInfo = "消耗" .. cashNum .. "现金币+" .. excTicketNum .. "兑换券可获得,剩余" .. prdNumStr
        else
            excCurrencyInfo = "消耗0筹码+0现金币可获得,剩余" .. prdNumStr
        end
    end

    local excExpenLblShownSize = {
        width = 278,
        height = 45
    }

    labelParam.fontSize = 20
    labelParam.color = display.COLOR_WHITE
    local excExpenLbl = display.newTTFLabel({text = excCurrencyInfo, size = labelParam.fontSize, color = labelParam.color, dimensions = cc.size(excExpenLblShownSize.width,
        excExpenLblShownSize.height), align = ui.TEXT_ALIGN_LEFT})
    excExpenLbl:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    excExpenLbl:pos(prdTitle:getPositionX(), excConditionTitle:getPositionY() - excConditionTitle:getContentSize().height / 2 - prdDescLblMagrinTop -
        excExpenLbl:getContentSize().height / 2)
        :addTo(self)

    local excConfirmBtnSize = {
        width = 180,
        height = 60
    }

    local excConfirmBtnMagrinBot = 20

    labelParam.fontSize = 28
    labelParam.color = display.COLOR_WHITE
    self.excConfirmBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnYellowRigOutl.png", pressed = "#common_btnYellowRigOutl.png", disabled = "#common_btnGreyLitRigOut.png"},
        {scale9 = true})
        :setButtonSize(excConfirmBtnSize.width, excConfirmBtnSize.height)
        :setButtonLabel(display.newTTFLabel({text = "确认兑换", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked(buttontHandler(self, self.onExcConfirmBtnCallBack_))
        :pos(0, - PANEL_HEIGHT / 2 + panelBorWidth + excConfirmBtnMagrinBot + excConfirmBtnSize.height / 2)
        :addTo(self)

    self:addCloseBtn()
end

function ExchangeWarePopup:onPrdImgLoaded_(success, sprite)
    -- body
    if success then
        --todo
        local tex = sprite:getTexture()
        local texSize = tex:getContentSize()

        if self and self.prdImg_ then
            --todo
            self.prdImg_:setTexture(tex)
            self.prdImg_:setTextureRect(cc.rect(0, 0, texSize.width, texSize.height))

            local prdImgShownBorWidth = 120
            local scaleSize = prdImgShownBorWidth / texSize.width

            self.prdImg_:scale(scaleSize)
        end
    end
end

function ExchangeWarePopup:onExcConfirmBtnCallBack_(evt)
    -- body
    self.excConfirmBtn_:setButtonEnabled(false)

    -- if tonumber(self.data_.category) == 1 or tonumber(self.data_.category) == 3 then
    --     ExchangeGoodAddressPopup.new(self.control_,self.data_):show()
    -- else
    --     self:openBuyGoodsTip(self.data_)
    -- end

    nk.ui.Dialog.new({messageText = bm.LangUtil.getText("SCOREMARKET", "CONFIRM_EXCHANGE") .. self.prdData_.giftname .. "？", secondBtnText =
        bm.LangUtil.getText("SCOREMARKET", "EXCHANGE_CONFIRM"), callback = function(type)
            if type == nk.ui.Dialog.SECOND_BTN_CLICK then
                self.controller_:exchangePrd(self.prdData_)

                self:hidePanel_()
            else
                self.excConfirmBtn_:setButtonEnabled(true)
            end
        end}
    ):show()
end

function ExchangeWarePopup:showPanel()
    -- body
    self:showPanel_()
end

function ExchangeWarePopup:onEnter()
    -- body
end

function ExchangeWarePopup:onExit()
    -- body
    nk.ImageLoader:cancelJobByLoaderId(self.prdImgLoaderId_)
end

function ExchangeWarePopup:onCleanup()
    -- body
end

return ExchangeWarePopup