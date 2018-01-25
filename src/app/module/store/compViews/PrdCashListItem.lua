--
-- Author: TsingZhang@boyaa.com
-- Date: 2016-03-16 14:56:27
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: ProductCashListItem.lua Created By Tsing.
--

local ITEMSIZE = nil

local PrdCashListItem = class("PrdCashListItem", bm.ui.ListItem)

function PrdCashListItem:ctor()
    self:setNodeEventEnabled(true)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

    local prdCashItemSize = {
        width = 770,
        height = 82
    }

    ITEMSIZE = cc.size(prdCashItemSize.width, prdCashItemSize.height)
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

    local itemCashIcCntMagrinLeft = 48
    self.itemCashIc_ = display.newSprite("#cash_coin_icon.png")  -- Alert ImgKey Later.
    self.itemCashIc_:pos(itemCashIcCntMagrinLeft, itemBgSize.height / 2)
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

    local prdCashNamePaddingLeft = 90
    local prdCashDiscInfoMagrinVect = 2

    labelParam.fontSize = 26
    labelParam.color = display.COLOR_WHITE
    self.prdCashTitle_ = display.newTTFLabel({text = "现金币 0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.prdCashTitle_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.prdCashTitle_:pos(prdCashNamePaddingLeft, itemBgSize.height / 2 + prdCashDiscInfoMagrinVect / 2 + self.prdCashTitle_:getContentSize().height / 2)
        :addTo(self.itemBg_)

    local delLineWFix = 2
    local delLineFillColor = cc.c4f(0xF9 / 0xff, 0xBA / 0xff, 0x22 / 0xff, 1)

    local delLineSize = {
        width = self.prdCashTitle_:getContentSize().width + delLineWFix * 2,
        height = 2
    }

    self.prdCashTitleDisDelLine_ = display.newRect(delLineSize.width, delLineSize.height, {fill = true, fillColor = delLineFillColor})
        :pos(prdCashNamePaddingLeft + self.prdCashTitle_:getContentSize().width / 2, self.prdCashTitle_:getPositionY())
        :addTo(self.itemBg_)
        :hide()

    self.prdCashDiscOffTitle_ = display.newTTFLabel({text = "现金币 0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.prdCashDiscOffTitle_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.prdCashDiscOffTitle_:pos(prdCashNamePaddingLeft, itemBgSize.height / 2 - prdCashDiscInfoMagrinVect / 2 - self.prdCashDiscOffTitle_:getContentSize().height / 2)
        :addTo(self.itemBg_)
        :hide()

    local storeGoBuyPrdBtnSize = {
        width = 130,
        height = 52
    }

    local storeGoBuyPrdBtnMagrinRight = 12

    labelParam.fontSize = 26
    labelParam.color = display.COLOR_WHITE
    self.goBuyPrdCashBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnGreenRigOutl.png", pressed = "#common_btnGreenRigOutl.png", disabled = "#common_btnGreyLitRigOut.png"}, {scale9 = true})
        :setButtonSize(storeGoBuyPrdBtnSize.width, storeGoBuyPrdBtnSize.height)
        :setButtonLabel(display.newTTFLabel({text = "0TH", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked(buttontHandler(self, self.onGoBuyPrdCashBtnCallBack_))
        :pos(itemBgSize.width - storeGoBuyPrdBtnSize.width / 2 - storeGoBuyPrdBtnMagrinRight, itemBgSize.height / 2)
        :addTo(self.itemBg_)

    self.goBuyPrdCashBtn_:setTouchSwallowEnabled(false)
    self.goBuyPrdCashBtn_:setButtonEnabled(false)
end

function PrdCashListItem:onDataSet(dataChanged, data)
    if dataChanged then
        local delLineSize = {
            width = 1,
            height = 2
        }

        self.prdCashTitleDisDelLine_:setContentSize(delLineSize.width, delLineSize.height)

        self.prdCashTitle_:setString(data.title or "现金币 0.")

        local delLineWFix = 2
        local delLineSizeWidth = self.prdCashTitle_:getContentSize().width + delLineWFix * 2
        self.prdCashTitleDisDelLine_:setScaleX(delLineSizeWidth)

        self.goBuyPrdCashBtn_:setButtonLabelString(data.priceLabel or "0TH.")  -- Confrim data.buyButtonLabel Field And Usage.
        
        local prdCashNamePaddingLeft = 80
        local itemBgSize = nil

        if self.isMultiPayType_ then
            --todo
            if self.itemResized_ then
                --todo
                itemBgSize = self.itemBg_:getContentSize()

                if data.discount and data.discount ~= 1 then
                    --todo
                    local prdCashDiscInfoMagrinVect = 2

                    self.discOffNum_:setString(string.format("%+d%%", math.round((data.discount - 1) * 100)))
                    self.discCorMarkBg_:show()

                    self.prdCashTitle_:pos(prdCashNamePaddingLeft, itemBgSize.height / 2 + prdCashDiscInfoMagrinVect / 2 + self.prdCashTitle_:getContentSize().height / 2)

                    self.prdCashTitleDisDelLine_:pos(prdCashNamePaddingLeft + self.prdCashTitle_:getContentSize().width / 2, self.prdCashTitle_:getPositionY())
                        :show()

                    self.prdCashDiscOffTitle_:setString("现金币 " .. bm.formatBigNumber(data.cashNumOff or 0))
                    self.prdCashDiscOffTitle_:pos(prdCashNamePaddingLeft, itemBgSize.height / 2 - prdCashDiscInfoMagrinVect / 2 - self.prdCashDiscOffTitle_:getContentSize().height / 2)
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
                local itemCashIcCntMagrinLeft = 48
                self.itemCashIc_:pos(itemCashIcCntMagrinLeft, itemBgSize.height / 2)

                local bgCorMarkPosAdj = {
                    x = - 2,
                    y = 1
                }

                self.discCorMarkBg_:pos(self.discCorMarkBg_:getContentSize().width / 2 + bgCorMarkPosAdj.x, itemBgSize.height - self.discCorMarkBg_:getContentSize().height / 2 + bgCorMarkPosAdj.y)
                self.hotTagCorMark_:pos(self.hotTagCorMark_:getContentSize().width / 2 + bgCorMarkPosAdj.x, itemBgSize.height - self.hotTagCorMark_:getContentSize().height / 2 + bgCorMarkPosAdj.y)
                self.newTagCorMark_:pos(self.newTagCorMark_:getContentSize().width / 2 + bgCorMarkPosAdj.x, itemBgSize.height - self.newTagCorMark_:getContentSize().height / 2 + bgCorMarkPosAdj.y)

                self.prdCashTitle_:pos(prdCashNamePaddingLeft, itemBgSize.height / 2)

                local storeGoBuyPrdBtnSize = {
                    width = 130,
                    height = 52
                }

                local storeGoBuyPrdBtnMagrinRight = 12

                self.goBuyPrdCashBtn_:pos(itemBgSize.width - storeGoBuyPrdBtnSize.width / 2 - storeGoBuyPrdBtnMagrinRight, itemBgSize.height / 2)

                if data.discount and data.discount ~= 1 then
                    --todo
                    local prdCashDiscInfoMagrinVect = 2

                    self.discOffNum_:setString(string.format("%+d%%", math.round((data.discount - 1) * 100)))
                    self.discCorMarkBg_:show()

                    self.prdCashTitle_:pos(prdCashNamePaddingLeft, itemBgSize.height / 2 + prdCashDiscInfoMagrinVect / 2 + self.prdCashTitle_:getContentSize().height / 2)

                    self.prdChipTitleDisDelLine_:pos(prdCashNamePaddingLeft + self.prdCashTitle_:getContentSize().width / 2, self.prdCashTitle_:getPositionY())
                        :show()

                    self.prdCashDiscOffTitle_:setString(bm.LangUtil.getText("STORE", "FORMAT_CHIP", bm.formatBigNumber(data.cashNumOff or 0)))
                    self.prdCashDiscOffTitle_:pos(prdCashNamePaddingLeft, itemBgSize.height / 2 - prdCashDiscInfoMagrinVect / 2 - self.prdCashDiscOffTitle_:getContentSize().height / 2)
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
                local prdCashDiscInfoMagrinVect = 2

                itemBgSize = self.itemBg_:getContentSize()

                self.discOffNum_:setString(string.format("%+d%%", math.round((data.discount - 1) * 100)))
                self.discCorMarkBg_:show()

                self.prdCashTitle_:pos(prdCashNamePaddingLeft, itemBgSize.height / 2 + prdCashDiscInfoMagrinVect / 2 + self.prdCashTitle_:getContentSize().height / 2)

                self.prdCashTitleDisDelLine_:pos(prdCashNamePaddingLeft + self.prdCashTitle_:getContentSize().width / 2, self.prdCashTitle_:getPositionY())
                    :show()

                self.prdCashDiscOffTitle_:setString(bm.LangUtil.getText("STORE", "FORMAT_CHIP", bm.formatBigNumber(data.cashNumOff or 0)))
                self.prdCashDiscOffTitle_:pos(prdCashNamePaddingLeft, itemBgSize.height / 2 - prdCashDiscInfoMagrinVect / 2 - self.prdCashDiscOffTitle_:getContentSize().height / 2)
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

        self.goBuyPrdCashBtn_:setButtonEnabled(true)
    end
end

function PrdCashListItem:onGoBuyPrdCashBtnCallBack_(evt)
    -- body
    self:dispatchEvent({name="ITEM_EVENT", type="MAKE_PURCHASE", pid = self.data_.pid, goodData = self.data_})
end

function PrdCashListItem:setItemMultiPayType(isMultiPayType)
    -- body
    self.isMultiPayType_ = isMultiPayType
end

function PrdCashListItem:onEnter()
    -- body
end

function PrdCashListItem:onExit()
    -- body
end

function PrdCashListItem:onCleanup()
    -- body
end

return PrdCashListItem