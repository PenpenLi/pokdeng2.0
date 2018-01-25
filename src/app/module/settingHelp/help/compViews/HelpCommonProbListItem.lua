--
-- Author: viking@boomegg.com
-- Date: 2014-09-01 10:22:00
-- Copyright: Copyright (c) 2014, BOOMEGG INTERACTIVE CO., LTD All rights reserved.
-- Description: HelpCommonProbListItem.lua Create By Tsing7x.
--

local ITEMSIZE = nil
local ITEM_MAGRINSVECT = 4

local HelpCommonProbListItem = class("HelpCommonProbListItem", bm.ui.ListItem)

function HelpCommonProbListItem:ctor()
    self:setNodeEventEnabled(true)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

    local defaultCommonProbItemSize = {
        width = 588,
        height = 60 + ITEM_MAGRINSVECT * 2
    }

    ITEMSIZE = cc.size(defaultCommonProbItemSize.width, defaultCommonProbItemSize.height)
    self.super.ctor(self, ITEMSIZE.width, ITEMSIZE.height)

    self.itemSizeFold_ = ITEMSIZE

    self.isFolded_ = true

    local itemBgHeight = ITEMSIZE.height - ITEM_MAGRINSVECT * 2

    self.itemBg_ = display.newScale9Sprite("#help_bgItemBlkGrey.png", ITEMSIZE.width / 2, ITEMSIZE.height / 2, cc.size(ITEMSIZE.width,
        itemBgHeight))
        :addTo(self)

    self.itemTouchBtn_ = cc.ui.UIPushButton.new({normal = "#common_modTransparent.png", pressed = "#common_modTransparent.png", disabled =
        "#common_modTransparent.png"}, {scale9 = true})
        :setButtonSize(ITEMSIZE.width, itemBgHeight)
        :onButtonClicked(function(evt)
            -- body
            if not self.itemClickedCanceled_ and self.itemBg_:getCascadeBoundingBox():containsPoint(cc.p(evt.x, evt.y)) then
                --todo
                self:onItemQuesTouched_(evt)
            end
        end)
        :onButtonPressed(function(evt)
            -- body
            self.itemPressedY_ = evt.y
            self.itemClickedCanceled_ = false
        end)
        :onButtonRelease(function(evt)
            -- body
            if math.abs(evt.y - self.itemPressedY_) >= 10 then
                --todo
                self.itemClickedCanceled_ = true
            end
        end)
        :pos(ITEMSIZE.width / 2, itemBgHeight / 2)
        :addTo(self.itemBg_)

    self.itemTouchBtn_:setTouchSwallowEnabled(false)

    local labelParam = {
        fontSize = 0,
        color = display.COLOR_BLACK
    }

    local quesTitleMagrinLeft = 18

    labelParam.fontSize = 28
    labelParam.color = display.COLOR_WHITE

    self.quesTitleLabel_ = display.newTTFLabel({text = "Title", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.quesTitleLabel_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.quesTitleLabel_:pos(quesTitleMagrinLeft, itemBgHeight / 2)
        :addTo(self.itemBg_)

    local arrorIconMagrinRight = 26
    self.foldArrowIc_ = display.newSprite("#help_arrowDown.png")
    self.foldArrowIc_:pos(ITEMSIZE.width - arrorIconMagrinRight - self.foldArrowIc_:getContentSize().width / 2, itemBgHeight / 2)
        :addTo(self.itemBg_)

    local quesAnsLblMagrinTop = 10
    local quesAnsLblShownWidthFixItemBorRight = 48

    labelParam.fontSize = 24
    labelParam.color = display.COLOR_WHITE

    self.quesAnsLabel_ = display.newTTFLabel({text = "Answer", size = labelParam.fontSize, color = labelParam.color, dimensions = cc.size(ITEMSIZE.width -
        quesTitleMagrinLeft - quesAnsLblShownWidthFixItemBorRight, 0), align = ui.TEXT_ALIGN_LEFT})
    self.quesAnsLabel_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.quesAnsLabel_:pos(quesTitleMagrinLeft, itemBgHeight / 2 - self.quesTitleLabel_:getContentSize().height / 2 - quesAnsLblMagrinTop -
        self.quesAnsLabel_:getContentSize().height / 2)
        :addTo(self.itemBg_)
        :hide()
end

function HelpCommonProbListItem:extendItem(data)
    self.quesAnsLabel_:setString(data[2] or "Answer.")
    self.quesAnsLabel_:show()
    
    local quesAnsLblMagrinTop = 10

    local quesAnsLblContSize = self.quesAnsLabel_:getContentSize()
    local quesAnsLblMagrinItembgBorBot = 15

    local itemBgHeight = (self.itemSizeFold_.height - ITEM_MAGRINSVECT * 2) / 2 + self.quesTitleLabel_:getContentSize().height / 2 + quesAnsLblMagrinTop +
        quesAnsLblContSize.height + quesAnsLblMagrinItembgBorBot

    ITEMSIZE = cc.size(self.itemSizeFold_.width, itemBgHeight + ITEM_MAGRINSVECT * 2)

    self:setContentSize(ITEMSIZE)

    self.itemBg_:size(ITEMSIZE.width, itemBgHeight)
    self.itemBg_:pos(ITEMSIZE.width / 2, ITEMSIZE.height / 2)
    
    self.itemTouchBtn_:setPositionY(itemBgHeight - self.itemSizeFold_.height / 2)
    self.quesTitleLabel_:setPositionY(itemBgHeight - self.itemSizeFold_.height / 2)
    self.foldArrowIc_:setPositionY(itemBgHeight - self.itemSizeFold_.height / 2)
    self.quesAnsLabel_:setPositionY(itemBgHeight - self.itemSizeFold_.height / 2 - self.quesTitleLabel_:getContentSize().height / 2 -
        quesAnsLblMagrinTop - quesAnsLblContSize.height / 2)

    self:dispatchEvent({name = "RESIZE"})
end

function HelpCommonProbListItem:flodContent()
    -- body
    self.quesAnsLabel_:hide()
    ITEMSIZE = self.itemSizeFold_

    -- local quesAnsLblMagrinTop = 10

    self:setContentSize(ITEMSIZE)
    self.itemBg_:size(ITEMSIZE.width, ITEMSIZE.height - ITEM_MAGRINSVECT * 2)

    self.itemBg_:pos(ITEMSIZE.width / 2, ITEMSIZE.height / 2)

    self.itemTouchBtn_:setPositionY((ITEMSIZE.height - ITEM_MAGRINSVECT * 2) / 2)
    self.quesTitleLabel_:setPositionY((ITEMSIZE.height - ITEM_MAGRINSVECT * 2) / 2)
    self.foldArrowIc_:setPositionY((ITEMSIZE.height - ITEM_MAGRINSVECT * 2) / 2)
    -- self.quesAnsLabel_:setPositionY((ITEMSIZE.height - ITEM_MAGRINSVECT * 2) / 2 - self.quesTitleLabel_:getContentSize().height / 2 -
    --     quesAnsLblMagrinTop - self.quesAnsLabel_:getContentSize().height / 2)

    self:dispatchEvent({name = "RESIZE"})
end

-- Render Custom Item --
function HelpCommonProbListItem:createCustomItemByIdx(index)
    -- body
end

function HelpCommonProbListItem:onItemQuesTouched_(evt)
    if self.isFolded_ then
        self.isFolded_ = false
        self.foldArrowIc_:rotation(180)

        self:extendItem(self.data_)
    else
        self.isFolded_ = true
        self.foldArrowIc_:rotation(360)

        self:flodContent()
    end
end

function HelpCommonProbListItem:onDataSet(dataChanged, data)
    if dataChanged then
        self.quesTitleLabel_:setString(data[1] or "Title.")
    end
end

function HelpCommonProbListItem:onEnter()
    -- body
end

function HelpCommonProbListItem:onExit()
    -- body
end

function HelpCommonProbListItem:onCleanup()
    -- body
end

return HelpCommonProbListItem