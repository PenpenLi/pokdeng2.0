--
-- Author: tony
-- Date: 2014-11-20 17:35:13
-- Copyright: Copyright (c) 2014, BOOMEGG INTERACTIVE CO., LTD All rights reserved.
-- Description: PrdChipListItem.lua ReConstructed by Tsing.
--

local ITEMSIZE = nil

local PrdChipListItem = class("PrdChipListItem", bm.ui.ListItem)

function PrdChipListItem:ctor()
    self:setNodeEventEnabled(true)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

    local prdChipItemSize = {
        width = 770,
        height = 82
    }

    ITEMSIZE = cc.size(prdChipItemSize.width, prdChipItemSize.height)
    self.super.ctor(self, ITEMSIZE.width, ITEMSIZE.height)

    local labelParam = {
        fontSize = 0,
        color = display.COLOR_BLACK
    }

    local itemBgStencil = {
        x = 53,
        y = 3,
        width = 672,
        height = 73
    }

    local itemBgMagrinEachVect = 2
    self.itemBg_ = display.newScale9Sprite("#store_bgPrdItem.png", ITEMSIZE.width / 2, ITEMSIZE.height / 2, cc.size(ITEMSIZE.width, ITEMSIZE.height - itemBgMagrinEachVect), cc.rect(itemBgStencil.x,
        itemBgStencil.y, itemBgStencil.width, itemBgStencil.height))
        :addTo(self)

    local itemBgSize = self.itemBg_:getContentSize()

    local itemChipIcCntMagrinLeft = 48
    self.itemChipIc_ = display.newSprite("#store_icPrdChip01.png")
    self.itemChipIc_:pos(itemChipIcCntMagrinLeft, itemBgSize.height / 2)
        :addTo(self.itemBg_)

    local bgCorMarkPosAdj = {
        x = - 2,
        y = 1
    }

    self.discCorMarkBg_ = display.newSprite("#common_decBgCorMarkDisc.png")
    self.discCorMarkBg_:pos(self.discCorMarkBg_:getContentSize().width / 2 + bgCorMarkPosAdj.x, itemBgSize.height - self.discCorMarkBg_:getContentSize().height / 2 + bgCorMarkPosAdj.y)
        :addTo(self.itemBg_)

    local discOffLblPosAdj = {
        x = - 10,
        y = 8
    }

    labelParam.fontSize = 18
    labelParam.color = display.COLOR_WHITE
    self.discOffNum_ = display.newTTFLabel({text = "+0%", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
        :pos(self.discCorMarkBg_:getContentSize().width / 2 + discOffLblPosAdj.x, self.discCorMarkBg_:getContentSize().height / 2 + discOffLblPosAdj.y)
        :addTo(self.discCorMarkBg_)
        :rotation(- 45)

    self.discCorMarkBg_:hide()

    self.hotTagCorMark_ = display.newSprite("#common_decCorMarkTagHot.png")
    self.hotTagCorMark_:pos(self.hotTagCorMark_:getContentSize().width / 2 + bgCorMarkPosAdj.x, itemBgSize.height - self.hotTagCorMark_:getContentSize().height / 2 + bgCorMarkPosAdj.y)
        :addTo(self.itemBg_)
        :hide()

    self.newTagCorMark_ = display.newSprite("#common_decCorMarkTagNew.png")
    self.newTagCorMark_:pos(self.newTagCorMark_:getContentSize().width / 2 + bgCorMarkPosAdj.x, itemBgSize.height - self.newTagCorMark_:getContentSize().height / 2 + bgCorMarkPosAdj.y)
        :addTo(self.itemBg_)
        :hide()

    local prdChipNamePaddingLeft = 115
    local prdChipDiscInfoMagrinVect = 2

    labelParam.fontSize = 26
    labelParam.color = display.COLOR_WHITE
    self.prdChipTitle_ = display.newTTFLabel({text = "筹码 0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.prdChipTitle_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.prdChipTitle_:pos(prdChipNamePaddingLeft, itemBgSize.height / 2--[[ + prdChipDiscInfoMagrinVect / 2 + self.prdChipTitle_:getContentSize().height / 2]])
        :addTo(self.itemBg_)

    local delLineWFix = 2
    local delLineFillColor = cc.c4f(0xF9 / 0xff, 0xBA / 0xff, 0x22 / 0xff, 1)

    local delLineSize = {
        width = 1,--[[self.prdChipTitle_:getContentSize().width + delLineWFix * 2,]]
        height = 2
    }

    self.prdChipTitleDisDelLine_ = display.newRect(delLineSize.width, delLineSize.height, {fill = true, fillColor = delLineFillColor})
        :pos(prdChipNamePaddingLeft + self.prdChipTitle_:getContentSize().width / 2, self.prdChipTitle_:getPositionY())
        :addTo(self.itemBg_)
        :hide()

    self.prdChipDiscOffTitle_ = display.newTTFLabel({text = "筹码 0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.prdChipDiscOffTitle_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.prdChipDiscOffTitle_:pos(prdChipNamePaddingLeft, itemBgSize.height / 2 - prdChipDiscInfoMagrinVect / 2 - self.prdChipDiscOffTitle_:getContentSize().height / 2)
        :addTo(self.itemBg_)
        :hide()

    local prdChipAvgPriceLblPaddingRight = 165
    local prdChipAvgPriceDiscInfoMagrinVect = 4

    labelParam.fontSize = 25
    labelParam.color = display.COLOR_WHITE
    self.prdChipAvgPrice_ = display.newTTFLabel({text = "1TH=0筹码", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.prdChipAvgPrice_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_RIGHT])
    self.prdChipAvgPrice_:pos(itemBgSize.width - prdChipAvgPriceLblPaddingRight, itemBgSize.height / 2--[[ + prdChipAvgPriceDiscInfoMagrinVect / 2 +
        self.prdChipAvgPrice_:getContentSize().height / 2]])
        :addTo(self.itemBg_)

    delLineSize.width = 1--[[self.prdChipAvgPrice_:getContentSize().width + delLineWFix * 2]]
    delLineSize.height = 2

    self.prdChipAvgPriceDisDelLine_ = display.newRect(delLineSize.width, delLineSize.height, {fill = true, fillColor = delLineFillColor})
        :pos(self.prdChipAvgPrice_:getPositionX() - self.prdChipAvgPrice_:getContentSize().width / 2, self.prdChipAvgPrice_:getPositionY())
        :addTo(self.itemBg_)
        :hide()

    self.prdChipAvgPriceDisOff_ = display.newTTFLabel({text = "1TH=0筹码", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.prdChipAvgPriceDisOff_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_RIGHT])
    self.prdChipAvgPriceDisOff_:pos(itemBgSize.width - prdChipAvgPriceLblPaddingRight, itemBgSize.height / 2 - prdChipAvgPriceDiscInfoMagrinVect / 2 -
        self.prdChipAvgPriceDisOff_:getContentSize().height / 2)
        :addTo(self.itemBg_)
        :hide()

    local storeGoBuyPrdBtnSize = {
        width = 130,
        height = 52
    }

    local storeGoBuyPrdBtnMagrinRight = 12

    labelParam.fontSize = 26
    labelParam.color = display.COLOR_WHITE
    self.goBuyPrdChipBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnGreenRigOutl.png", pressed = "#common_btnGreenRigOutl.png", disabled = "#common_btnGreyLitRigOut.png"}, {scale9 = true})
        :setButtonSize(storeGoBuyPrdBtnSize.width, storeGoBuyPrdBtnSize.height)
        :setButtonLabel(display.newTTFLabel({text = "0TH", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked(buttontHandler(self, self.onGoBuyPrdChipBtnCallBack_))
        :pos(itemBgSize.width - storeGoBuyPrdBtnSize.width / 2 - storeGoBuyPrdBtnMagrinRight, itemBgSize.height / 2)
        :addTo(self.itemBg_)

    self.goBuyPrdChipBtn_:setTouchSwallowEnabled(false)
    self.goBuyPrdChipBtn_:setButtonEnabled(false)
end

function PrdChipListItem:onDataSet(dataChanged, data)
    if dataChanged then

        local prdChipIcGroupNum = self:getChipIcGroupByPrdChipNum(data.chipNum or 0)

        self.itemChipIc_:setSpriteFrame("store_icPrdChip0" .. prdChipIcGroupNum .. ".png")

        local delLineSize = {
            width = 1,
            height = 2
        }

        self.prdChipTitleDisDelLine_:setContentSize(delLineSize.width, delLineSize.height)

        self.prdChipTitle_:setString(data.title or "筹码 0.")

        local delLineWFix = 2
        local delLineSizeWidth = self.prdChipTitle_:getContentSize().width + delLineWFix * 2
        self.prdChipTitleDisDelLine_:setScaleX(delLineSizeWidth)

        local prdChipAvgPrice = (data.rate or 0) / (data.discount or 1)
        local prdChipAvgPriceFotmatStr = nil
        local prdChipAvgPriceStr = nil

        if prdChipAvgPrice > 100000 then
            prdChipAvgPriceFotmatStr = string.format("%d", prdChipAvgPrice)
            prdChipAvgPriceStr = bm.LangUtil.getText("STORE", "RATE_CHIP", bm.formatBigNumber(prdChipAvgPriceFotmatStr), data.priceDollar or "TH")
        elseif prdChipAvgPrice > 1000 then
            --todo
            prdChipAvgPriceFotmatStr = string.format("%d", prdChipAvgPrice)
            prdChipAvgPriceStr = bm.LangUtil.getText("STORE", "RATE_CHIP", bm.formatNumberWithSplit(prdChipAvgPriceFotmatStr), data.priceDollar or "TH")
        else
            prdChipAvgPriceFotmatStr = string.format("%.2f", prdChipAvgPrice)
            prdChipAvgPriceStr = bm.LangUtil.getText("STORE", "RATE_CHIP", prdChipAvgPriceFotmatStr, data.priceDollar or "TH")
        end

        self.prdChipAvgPriceDisDelLine_:setContentSize(delLineSize.width, delLineSize.height)

        self.prdChipAvgPrice_:setString(prdChipAvgPriceStr)

        delLineSizeWidth = self.prdChipAvgPrice_:getContentSize().width + delLineWFix * 2
        self.prdChipAvgPriceDisDelLine_:setScaleX(delLineSizeWidth)

        self.goBuyPrdChipBtn_:setButtonLabelString(data.priceLabel or "0TH.")  -- Confrim data.buyButtonLabel Field And Usage.

        -- Some Common Variables --
        local prdChipNamePaddingLeft = 95
        local prdChipAvgPriceLblPaddingRight = 165
        local itemBgSize = nil

        if self.isMultiPayType_ then
            --todo
            if self.itemResized_ then
                --todo
                itemBgSize = self.itemBg_:getContentSize()

                if data.discount and data.discount ~= 1 then
                    --todo
                    local prdChipDiscInfoMagrinVect = 2
                    local prdChipAvgPriceDiscInfoMagrinVect = 4

                    self.discOffNum_:setString(string.format("%+d%%", math.round((data.discount - 1) * 100)))
                    self.discCorMarkBg_:show()

                    self.prdChipTitle_:pos(prdChipNamePaddingLeft, itemBgSize.height / 2 + prdChipDiscInfoMagrinVect / 2 + self.prdChipTitle_:getContentSize().height / 2)

                    self.prdChipTitleDisDelLine_:pos(prdChipNamePaddingLeft + self.prdChipTitle_:getContentSize().width / 2, self.prdChipTitle_:getPositionY())
                        :show()

                    self.prdChipDiscOffTitle_:setString(bm.LangUtil.getText("STORE", "FORMAT_CHIP", bm.formatBigNumber(data.chipNumOff or 0)))
                    self.prdChipDiscOffTitle_:pos(prdChipNamePaddingLeft, itemBgSize.height / 2 - prdChipDiscInfoMagrinVect / 2 - self.prdChipDiscOffTitle_:getContentSize().height / 2)
                        :show()

                    self.prdChipAvgPrice_:pos(itemBgSize.width - prdChipAvgPriceLblPaddingRight, itemBgSize.height / 2 + prdChipAvgPriceDiscInfoMagrinVect / 2 +
                        self.prdChipAvgPrice_:getContentSize().height / 2)

                    self.prdChipAvgPriceDisDelLine_:pos(self.prdChipAvgPrice_:getPositionX() - self.prdChipAvgPrice_:getContentSize().width / 2, self.prdChipAvgPrice_:getPositionY())
                        :show()

                    local disOffAvgPrice = data.rate or 0
                    local disOffPriceFormatStr = nil
                    local disOffAvgPriceStr = nil

                    if disOffAvgPrice > 100000 then
                        --todo
                        disOffPriceFormatStr = string.format("%d", disOffAvgPrice)
                        disOffAvgPriceStr = bm.LangUtil.getText("STORE", "RATE_CHIP", bm.formatBigNumber(disOffPriceFormatStr), data.priceDollar or "TH")
                    elseif disOffAvgPrice > 1000 then
                        --todo
                        disOffPriceFormatStr = string.format("%d", disOffAvgPrice)

                        disOffAvgPriceStr = bm.LangUtil.getText("STORE", "RATE_CHIP", bm.formatNumberWithSplit(disOffPriceFormatStr), data.priceDollar or "TH")
                    else
                        disOffAvgPriceStr = bm.LangUtil.getText("STORE", "RATE_CHIP", string.format("%.2f", disOffAvgPrice), data.priceDollar or "TH")
                    end    

                    self.prdChipAvgPriceDisOff_:setString(disOffAvgPriceStr)
                    self.prdChipAvgPriceDisOff_:pos(itemBgSize.width - prdChipAvgPriceLblPaddingRight, itemBgSize.height / 2 - prdChipAvgPriceDiscInfoMagrinVect / 2 -
                        self.prdChipAvgPriceDisOff_:getContentSize().height / 2)
                        :show()

                elseif data.tag == "hot" then
                    --todo
                    self.discCorMarkBg_:hide()
                    self.hotTagCorMark_:show()
                    self.newTagCorMark_:hide()

                elseif data.tag == "new" then
                    --todo
                    self.discCorMarkBg_:hide()
                    self.hotTagCorMark_:hide()
                    self.newTagCorMark_:show()
                end

            else
                local itemMultiPayTypeResize = {
                    width = 610,
                    height = 82
                }

                ITEMSIZE = cc.size(itemMultiPayTypeResize.width, itemMultiPayTypeResize.height)
                self:setContentSize(ITEMSIZE)

                local itemBgMagrinEachVect = 2
                self.itemBg_:size(ITEMSIZE.width, ITEMSIZE.height - itemBgMagrinEachVect)

                self.itemBg_:pos(ITEMSIZE.width / 2, ITEMSIZE.height / 2)
                itemBgSize = self.itemBg_:getContentSize()

                -- Adj Nor State All Widget Pos First --
                local itemChipIcCntMagrinLeft = 48
                self.itemChipIc_:pos(itemChipIcCntMagrinLeft, itemBgSize.height / 2)

                local bgCorMarkPosAdj = {
                    x = - 2,
                    y = 1
                }

                self.discCorMarkBg_:pos(self.discCorMarkBg_:getContentSize().width / 2 + bgCorMarkPosAdj.x, itemBgSize.height - self.discCorMarkBg_:getContentSize().height / 2 + bgCorMarkPosAdj.y)
                self.hotTagCorMark_:pos(self.hotTagCorMark_:getContentSize().width / 2 + bgCorMarkPosAdj.x, itemBgSize.height - self.hotTagCorMark_:getContentSize().height / 2 + bgCorMarkPosAdj.y)
                self.newTagCorMark_:pos(self.newTagCorMark_:getContentSize().width / 2 + bgCorMarkPosAdj.x, itemBgSize.height - self.newTagCorMark_:getContentSize().height / 2 + bgCorMarkPosAdj.y)

                self.prdChipTitle_:pos(prdChipNamePaddingLeft, itemBgSize.height / 2)

                self.prdChipAvgPrice_:pos(itemBgSize.width - prdChipAvgPriceLblPaddingRight, itemBgSize.height / 2)

                local storeGoBuyPrdBtnSize = {
                    width = 130,
                    height = 52
                }

                local storeGoBuyPrdBtnMagrinRight = 12

                self.goBuyPrdChipBtn_:pos(itemBgSize.width - storeGoBuyPrdBtnSize.width / 2 - storeGoBuyPrdBtnMagrinRight, itemBgSize.height / 2)

                if data.discount and data.discount ~= 1 then
                    --todo
                    local prdChipDiscInfoMagrinVect = 2
                    local prdChipAvgPriceDiscInfoMagrinVect = 4

                    self.discOffNum_:setString(string.format("%+d%%", math.round((data.discount - 1) * 100)))
                    self.discCorMarkBg_:show()

                    self.prdChipTitle_:pos(prdChipNamePaddingLeft, itemBgSize.height / 2 + prdChipDiscInfoMagrinVect / 2 + self.prdChipTitle_:getContentSize().height / 2)

                    self.prdChipTitleDisDelLine_:pos(prdChipNamePaddingLeft + self.prdChipTitle_:getContentSize().width / 2, self.prdChipTitle_:getPositionY())
                        :show()

                    self.prdChipDiscOffTitle_:setString(bm.LangUtil.getText("STORE", "FORMAT_CHIP", bm.formatBigNumber(data.chipNumOff or 0)))
                    self.prdChipDiscOffTitle_:pos(prdChipNamePaddingLeft, itemBgSize.height / 2 - prdChipDiscInfoMagrinVect / 2 - self.prdChipDiscOffTitle_:getContentSize().height / 2)
                        :show()

                    self.prdChipAvgPrice_:pos(itemBgSize.width - prdChipAvgPriceLblPaddingRight, itemBgSize.height / 2 + prdChipAvgPriceDiscInfoMagrinVect / 2 +
                        self.prdChipAvgPrice_:getContentSize().height / 2)

                    self.prdChipAvgPriceDisDelLine_:pos(self.prdChipAvgPrice_:getPositionX() - self.prdChipAvgPrice_:getContentSize().width / 2, self.prdChipAvgPrice_:getPositionY())
                        :show()

                    local disOffAvgPrice = data.rate or 0
                    local disOffPriceFormatStr = nil
                    local disOffAvgPriceStr = nil

                    if disOffAvgPrice > 100000 then
                        --todo
                        disOffPriceFormatStr = string.format("%d", disOffAvgPrice)
                        disOffAvgPriceStr = bm.LangUtil.getText("STORE", "RATE_CHIP", bm.formatBigNumber(disOffPriceFormatStr), data.priceDollar or "TH")
                    elseif disOffAvgPrice > 1000 then
                        --todo
                        disOffPriceFormatStr = string.format("%d", disOffAvgPrice)

                        disOffAvgPriceStr = bm.LangUtil.getText("STORE", "RATE_CHIP", bm.formatNumberWithSplit(disOffPriceFormatStr), data.priceDollar or "TH")
                    else
                        disOffAvgPriceStr = bm.LangUtil.getText("STORE", "RATE_CHIP", string.format("%.2f", disOffAvgPrice), data.priceDollar or "TH")
                    end    

                    self.prdChipAvgPriceDisOff_:setString(disOffAvgPriceStr)
                    self.prdChipAvgPriceDisOff_:pos(itemBgSize.width - prdChipAvgPriceLblPaddingRight, itemBgSize.height / 2 - prdChipAvgPriceDiscInfoMagrinVect / 2 -
                        self.prdChipAvgPriceDisOff_:getContentSize().height / 2)
                        :show()

                elseif data.tag == "hot" then
                    --todo
                    self.discCorMarkBg_:hide()
                    self.hotTagCorMark_:show()
                    self.newTagCorMark_:hide()

                elseif data.tag == "new" then
                    --todo
                    self.discCorMarkBg_:hide()
                    self.hotTagCorMark_:hide()
                    self.newTagCorMark_:show()
                end

                -- self:dispatchEvent({name = "RESIZE"})
                self.itemResized_ = true
            end
        else
            if data.discount and data.discount ~= 1 then
                --todo
                local prdChipDiscInfoMagrinVect = 2
                local prdChipAvgPriceDiscInfoMagrinVect = 4

                itemBgSize = self.itemBg_:getContentSize()

                self.discOffNum_:setString(string.format("%+d%%", math.round((data.discount - 1) * 100)))
                self.discCorMarkBg_:show()

                self.prdChipTitle_:pos(prdChipNamePaddingLeft, itemBgSize.height / 2 + prdChipDiscInfoMagrinVect / 2 + self.prdChipTitle_:getContentSize().height / 2)

                self.prdChipTitleDisDelLine_:pos(prdChipNamePaddingLeft + self.prdChipTitle_:getContentSize().width / 2, self.prdChipTitle_:getPositionY())
                    :show()

                self.prdChipDiscOffTitle_:setString(bm.LangUtil.getText("STORE", "FORMAT_CHIP", bm.formatBigNumber(data.chipNumOff or 0)))
                self.prdChipDiscOffTitle_:pos(prdChipNamePaddingLeft, itemBgSize.height / 2 - prdChipDiscInfoMagrinVect / 2 - self.prdChipDiscOffTitle_:getContentSize().height / 2)
                    :show()

                self.prdChipAvgPrice_:pos(itemBgSize.width - prdChipAvgPriceLblPaddingRight, itemBgSize.height / 2 + prdChipAvgPriceDiscInfoMagrinVect / 2 +
                    self.prdChipAvgPrice_:getContentSize().height / 2)

                self.prdChipAvgPriceDisDelLine_:pos(self.prdChipAvgPrice_:getPositionX() - self.prdChipAvgPrice_:getContentSize().width / 2, self.prdChipAvgPrice_:getPositionY())
                    :show()

                local disOffAvgPrice = data.rate or 0
                local disOffPriceFormatStr = nil
                local disOffAvgPriceStr = nil

                if disOffAvgPrice > 100000 then
                    --todo
                    disOffPriceFormatStr = string.format("%d", disOffAvgPrice)
                    disOffAvgPriceStr = bm.LangUtil.getText("STORE", "RATE_CHIP", bm.formatBigNumber(disOffPriceFormatStr), data.priceDollar or "TH")
                elseif disOffAvgPrice > 1000 then
                    --todo
                    disOffPriceFormatStr = string.format("%d", disOffAvgPrice)

                    disOffAvgPriceStr = bm.LangUtil.getText("STORE", "RATE_CHIP", bm.formatNumberWithSplit(disOffPriceFormatStr), data.priceDollar or "TH")
                else
                    disOffAvgPriceStr = bm.LangUtil.getText("STORE", "RATE_CHIP", string.format("%.2f", disOffAvgPrice), data.priceDollar or "TH")
                end

                self.prdChipAvgPriceDisOff_:setString(disOffAvgPriceStr)
                self.prdChipAvgPriceDisOff_:pos(itemBgSize.width - prdChipAvgPriceLblPaddingRight, itemBgSize.height / 2 - prdChipAvgPriceDiscInfoMagrinVect / 2 -
                    self.prdChipAvgPriceDisOff_:getContentSize().height / 2)
                    :show()

            elseif data.tag == "hot" then
                --todo
                self.discCorMarkBg_:hide()
                self.hotTagCorMark_:show()
                self.newTagCorMark_:hide()

            elseif data.tag == "new" then
                --todo
                self.discCorMarkBg_:hide()
                self.hotTagCorMark_:hide()
                self.newTagCorMark_:show()
            end
        end

        self.goBuyPrdChipBtn_:setButtonEnabled(true)
    end
end

function PrdChipListItem:onGoBuyPrdChipBtnCallBack_(evt)
    -- body
    self:dispatchEvent({name="ITEM_EVENT", type="MAKE_PURCHASE", pid = self.data_.pid, goodData = self.data_})
end

function PrdChipListItem:getChipIcGroupByPrdChipNum(num)
    -- body
    local chipNum = tonumber(num)
    if chipNum <= 5000000 then
        --todo
        return 1
    elseif chipNum <= 10000000 then
        --todo
        return 2
    elseif chipNum <= 25000000 then
        --todo
        return 3
    elseif chipNum <= 50000000 then
        --todo
        return 4
    else
        return 5
    end
end

function PrdChipListItem:setItemMultiPayType(isMultiPayType)
    -- body
    self.isMultiPayType_ = isMultiPayType
end

function PrdChipListItem:onEnter()
    -- body
end

function PrdChipListItem:onExit()
    -- body
end

function PrdChipListItem:onCleanup()
    -- body
end

return PrdChipListItem