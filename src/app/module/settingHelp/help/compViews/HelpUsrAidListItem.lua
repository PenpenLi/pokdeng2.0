--
-- Author: viking@boomegg.com
-- Date: 2014-09-03 15:40:07
-- Copyright: Copyright (c) 2014, BOOMEGG INTERACTIVE CO., LTD All rights reserved.
-- Description: HelpUsrAidListItem.lua Create By Tsing7x.
--

local ITEMSIZE = nil
local ITEMANS_CONTRETSIZE = nil
local ITEM_MAGRINSVECT = 4

local HelpUsrAidListItem = class("HelpUsrAidListItem", bm.ui.ListItem)

function HelpUsrAidListItem:ctor()
    -- body
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

function HelpUsrAidListItem:createCustomItemByIdx(idx)
    -- body
    local drawCustomItemUiByIdx = {
        [1] = function()
            -- body
            -- self.quesAnsLabel_ => Sprite
            local quesTitleMagrinLeft = 18

            self.quesAnsLabel_:removeFromParent()
            self.quesAnsLabel_ = nil

            self.quesAnsLabel_ = display.newSprite("help_cardCombValRule.jpg")
            self.quesAnsLabel_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])

            local quesAnsLblSizeOrg = self.quesAnsLabel_:getContentSize()

            self.quesAnsLabel_:pos(quesTitleMagrinLeft, - quesAnsLblSizeOrg.height / 2 * .65)
                :addTo(self.itemBg_)
                :scale(.65)

            ITEMANS_CONTRETSIZE = cc.size(quesAnsLblSizeOrg.width * .65, quesAnsLblSizeOrg.height * .65)

            return ITEMANS_CONTRETSIZE
        end,

        [2] = function()
            -- body
            -- self.quesAnsLabel_ => Sprite
            local quesTitleMagrinLeft = 18

            self.quesAnsLabel_:removeFromParent()
            self.quesAnsLabel_ = nil

            self.quesAnsLabel_ = display.newSprite("help_cardCombValExt.jpg")
            self.quesAnsLabel_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])

            local quesAnsLblSizeOrg = self.quesAnsLabel_:getContentSize()
            self.quesAnsLabel_:pos(quesTitleMagrinLeft, - quesAnsLblSizeOrg.height / 2 * .65)
                :addTo(self.itemBg_)
                :scale(.65)

            ITEMANS_CONTRETSIZE = cc.size(quesAnsLblSizeOrg.width * .65, quesAnsLblSizeOrg.height * .65)

            return ITEMANS_CONTRETSIZE
        end,

        [15] = function()
            -- body
            -- self.quesAnsLabel_ => Node
            self.quesAnsLabel_:removeFromParent()
            self.quesAnsLabel_ = nil

            self.quesAnsLabel_ = display.newNode()
                :addTo(self.itemBg_)

            local defaultItemAnsHeight = 5

            local levelConfData = nk.Level:getLevelConfigData()
            if levelConfData and #levelConfData > 0 then
                --todo
                local levelHelpTitle = {
                    "LV",
                    "称号",
                    "所有EXP",
                    "升级奖励"
                }

                local lvConfContInfoMagrinHoriz = 16
                local levelInfoColumnHeight = 38

                local lvConfContPageWidth = ITEMSIZE.width - lvConfContInfoMagrinHoriz * 2

                local levelInfoColLabel = {}
                local levelConfInfoDivLine = nil

                local levelInfoContDivLineSize = {
                    width = lvConfContPageWidth,
                    height = 2
                }

                local levelConfInfoTitleLblParam = {
                    fontSize = 22,
                    color = display.COLOR_RED
                }

                local levelConfContLblParam = {
                    fontSize = 20,
                    color = display.COLOR_WHITE
                }

                for i = 1, #levelConfData + 1 do
                    for j = 1, #levelHelpTitle do
                        if i == 1 then
                            --todo
                            levelInfoColLabel[j] = display.newTTFLabel({text = levelHelpTitle[j], size = levelConfInfoTitleLblParam.fontSize, color = levelConfInfoTitleLblParam.color,
                                align = ui.TEXT_ALIGN_CENTER})
                        else
                            levelInfoColLabel[j] = display.newTTFLabel({text = levelConfData[i - 1][j], size = levelConfContLblParam.fontSize, color = levelConfContLblParam.color,
                                align = ui.TEXT_ALIGN_CENTER})
                        end

                        if j == 4 then
                            --todo
                            levelInfoColLabel[j]:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_RIGHT])
                            levelInfoColLabel[j]:pos(lvConfContPageWidth + lvConfContInfoMagrinHoriz, levelInfoColumnHeight * (#levelConfData + 1) / 2 - levelInfoColumnHeight / 2 * (i * 2 - 1))
                        else
                            levelInfoColLabel[j]:setAnchorPoint(display.ANCHOR_POINTS[display.LEFT_CENTER])
                            levelInfoColLabel[j]:pos(lvConfContPageWidth / 4 * (j - 1) + lvConfContInfoMagrinHoriz, levelInfoColumnHeight * (#levelConfData + 1) / 2 - levelInfoColumnHeight / 2 *
                                (i * 2 - 1))
                        end

                        levelInfoColLabel[j]:addTo(self.quesAnsLabel_)

                        levelConfInfoDivLine = display.newScale9Sprite("#common_divLineSplit.png", lvConfContPageWidth / 2 + lvConfContInfoMagrinHoriz, levelInfoColumnHeight * (#levelConfData + 1) /
                            2 - levelInfoColumnHeight * i, cc.size(levelInfoContDivLineSize.width, levelInfoContDivLineSize.height))
                            :addTo(self.quesAnsLabel_)
                    end
                end

                ITEMANS_CONTRETSIZE = cc.size(ITEMSIZE.width, levelInfoColumnHeight * (#levelConfData + 1))
            else
                ITEMANS_CONTRETSIZE = cc.size(ITEMSIZE.width, defaultItemAnsHeight)
            end

            return ITEMANS_CONTRETSIZE
        end
    }

    if idx and drawCustomItemUiByIdx[idx] then
        --todo
        return drawCustomItemUiByIdx[idx]()
    else
        return self:getNormalTextItem()
    end

    return nil
end

function HelpUsrAidListItem:getNormalTextItem()
    -- body
    ITEMANS_CONTRETSIZE = self.quesAnsLabel_:getContentSize()

    return ITEMANS_CONTRETSIZE
end

function HelpUsrAidListItem:extendItem(data)
    self.quesAnsLabel_:show()

    local quesAnsLblMagrinTop = 10

    local itemAnsContSize = nil
    if not self.itemAnsContInit_ then
        --todo
        self.quesAnsLabel_:setString(data[2] or "Answer.")

        itemAnsContSize = self:createCustomItemByIdx(self.index_)

        self.itemAnsContInit_ = true
    else
        itemAnsContSize = ITEMANS_CONTRETSIZE
    end

    local itemAnsContSize = self:createCustomItemByIdx(self.index_)
    local quesAnsLblMagrinItembgBorBot = 15

    local itemBgHeight = (self.itemSizeFold_.height - ITEM_MAGRINSVECT * 2) / 2 + self.quesTitleLabel_:getContentSize().height / 2 + quesAnsLblMagrinTop +
        itemAnsContSize.height + quesAnsLblMagrinItembgBorBot

    ITEMSIZE = cc.size(self.itemSizeFold_.width, itemBgHeight + ITEM_MAGRINSVECT * 2)
    self:setContentSize(ITEMSIZE)

    self.itemBg_:size(ITEMSIZE.width, itemBgHeight)
    self.itemBg_:pos(ITEMSIZE.width / 2, ITEMSIZE.height / 2)

    self.itemTouchBtn_:setPositionY(itemBgHeight - self.itemSizeFold_.height / 2)
    self.quesTitleLabel_:setPositionY(itemBgHeight - self.itemSizeFold_.height / 2)
    self.foldArrowIc_:setPositionY(itemBgHeight - self.itemSizeFold_.height / 2)
    self.quesAnsLabel_:setPositionY(itemBgHeight - self.itemSizeFold_.height / 2 - self.quesTitleLabel_:getContentSize().height / 2 -
        quesAnsLblMagrinTop - itemAnsContSize.height / 2)

    self:dispatchEvent({name = "RESIZE"})
end

function HelpUsrAidListItem:flodContent()
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

function HelpUsrAidListItem:onItemQuesTouched_(evt)
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

function HelpUsrAidListItem:onDataSet(dataChanged, data)
    if dataChanged then
        self.quesTitleLabel_:setString(data[1])
    end
end

function HelpUsrAidListItem:onEnter()
    -- body
end

function HelpUsrAidListItem:onExit()
    -- body
end

function HelpUsrAidListItem:onCleanup()
    -- body
end

return HelpUsrAidListItem