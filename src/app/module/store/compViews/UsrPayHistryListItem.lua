--
-- Author: tony
-- Date: 2014-11-24 15:47:18
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: ProductCashListItem.lua Created By Tsing.
--

local ITEMSIZE = nil

local UsrPayHistryListItem = class("UsrPayHistryListItem", bm.ui.ListItem)

function UsrPayHistryListItem:ctor()
    self:setNodeEventEnabled(true)

    local payHistryItemSize = {
        width = 780,
        height = 80
    }

    ITEMSIZE = cc.size(payHistryItemSize.width, payHistryItemSize.height)
    self.super.ctor(self, ITEMSIZE.width, ITEMSIZE.height)

    local itemDivLineHeight = 4

    local labelParam = {
        fontSize = 0,
        color = display.COLOR_BLACK
    }

    local prdNameMagrinLeft = 40

    labelParam.fontSize = 24
    labelParam.color = display.COLOR_WHITE
    self.prdContTitle_ = display.newTTFLabel({text = "购买0筹码", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.prdContTitle_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.prdContTitle_:pos(prdNameMagrinLeft, ITEMSIZE.height / 2 + itemDivLineHeight / 2)
        :addTo(self)

    local prdPayDateLblPaddingRight = 265
    self.prdPayDate_ = display.newTTFLabel({text = "1970-01-01", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.prdPayDate_:pos(ITEMSIZE.width - prdPayDateLblPaddingRight - self.prdPayDate_:getContentSize().width / 2, ITEMSIZE.height / 2 + itemDivLineHeight / 2)
        :addTo(self)

    local prdPaymentStateLblMagrinRight = 40
    self.prdPaymentState_ = display.newTTFLabel({text = "已发货", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.prdPaymentState_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_RIGHT])
    self.prdPaymentState_:pos(ITEMSIZE.width - prdPaymentStateLblMagrinRight, ITEMSIZE.height / 2 + itemDivLineHeight / 2)
        :addTo(self)

    local prdPaymentRecDivLineWFix = 2
    local prdPaymentRecDivLineSize = {
        width = ITEMSIZE.width - prdPaymentRecDivLineWFix * 2,
        height = 4
    }

    local paymentRecDivLine = display.newScale9Sprite("#store_divLineRecs.png", ITEMSIZE.width / 2, prdPaymentRecDivLineSize.height / 2, cc.size(prdPaymentRecDivLineSize.width, prdPaymentRecDivLineSize.height))
        :addTo(self)
end

function UsrPayHistryListItem:onDataSet(dataChanged, data)
    if dataChanged then

        local prdNameStr = nil
        if checkint(data.count) and checkint(data.count) > 0 then
            --todo
            prdNameStr = self:getPrdContTitleByType(checkint(data.object), checkint(data.count))
        else
            prdNameStr = "0M筹码."
        end

        self.prdContTitle_:setString(prdNameStr)

        self.prdPayDate_:setString(os.date("%Y-%m-%d", checkint(data.created or 0)))
        self.prdPaymentState_:setString(bm.LangUtil.getText("STORE", "RECORD_STATUS")[checkint(data.status or 1)])
    end
end

function UsrPayHistryListItem:getPrdContTitleByType(type, val)
    -- body
    local getPurchasedItemByType = {
        [0] = function(itemNum)
            -- body
            return bm.LangUtil.getText("STORE", "BUY_CASHS", bm.formatNumberWithSplit(checkint(itemNum or 0)))
        end,
        
        [1] = function(itemNum)
            -- body
            return bm.LangUtil.getText("STORE", "BUY_CHIPS", bm.formatBigNumber(checkint(itemNum or 0)))
        end,

        [2] = function(itemNum)
            -- body
            return bm.LangUtil.getText("STORE", "BUY_TICKETS", bm.formatNumberWithSplit(checkint(itemNum or 0)))
        end,

        [6] = function(price)
            -- body
            return bm.LangUtil.getText("STORE", "BUY_GIFTBAGS", price or 29)
        end
    }

    if getPurchasedItemByType[type] then
        --todo
        return getPurchasedItemByType[type](val)
    end

    return "nil"
end

function UsrPayHistryListItem:onEnter()
    -- body
end

function UsrPayHistryListItem:onExit()
    -- body
end

function UsrPayHistryListItem:onCleanup()
    -- body
end

return UsrPayHistryListItem