--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-06-28 17:12:48
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: CardTypeGameRecPopup.lua Created By Tsing7x.
--

local GameCardRecListItem = import(".GameCardRecListItem")

local PANEL_WIDTH = 305

local CardTypeGameRecPopup = class("CardTypeGameRecPopup", function()
    return display.newNode()
end)

function CardTypeGameRecPopup:ctor(defaultContIdx)
    self:setNodeEventEnabled(true)

    self.defaultTabBotIdx_ = defaultContIdx or 1

    display.addSpriteFrames("cardTypeGameRec.plist", "cardTypeGameRec.png", handler(self, self.onCardTypeGameRecTextureLoaded))
end

function CardTypeGameRecPopup:onCardTypeGameRecTextureLoaded(fileName, imgName)
    -- body
    self.background_ = display.newScale9Sprite("#crdTyGmRc_bgPanel.png", - PANEL_WIDTH / 2, display.cy, cc.size(PANEL_WIDTH, display.height))
        :addTo(self)

    self.background_:setTouchEnabled(true)
    self.background_:setTouchSwallowEnabled(true)

    local botTabLblStrs = {
        "牌型介绍",
        "牌局记录"
    }

    local labelParam = {
        fontSize = 0,
        color = display.COLOR_BLACK
    }

    local botTabBtnSize = {
        width = 150,
        height = 60
    }

    local botTabBtnSelImgPosYFix = 4

    self.botTabBtns_ = {}
    self.botTabBtnGroup_ = nk.ui.CheckBoxButtonGroup.new()

    labelParam.fontSize = 26
    labelParam.color = display.COLOR_GREEN
    for i = 1, #botTabLblStrs do
        self.botTabBtns_[i] = cc.ui.UICheckBoxButton.new({on = "#common_modTransparent.png", off = "#crdTyGmRc_btnContTab_nor.png"}, {scale9 = true})
            :setButtonSize(botTabBtnSize.width, botTabBtnSize.height)
            :pos(botTabBtnSize.width / 2 * (i * 2 - 1), botTabBtnSize.height / 2)
            :addTo(self.background_)

        self.botTabBtns_[i].imgSel_ = display.newSprite("#crdTyGmRc_btnContTabSel.png")
            :pos(0, botTabBtnSelImgPosYFix)
            :addTo(self.botTabBtns_[i])
            :hide()

        self.botTabBtns_[i].label_ = display.newTTFLabel({text = botTabLblStrs[i], size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
            :addTo(self.botTabBtns_[i])

        self.botTabBtnGroup_:addButton(self.botTabBtns_[i])
    end

    self.panelInfoContPageNode_ = display.newNode()
        :pos(- PANEL_WIDTH / 2, display.cy + botTabBtnSize.height / 2)
        :addTo(self)

    self.botTabBtnGroup_:onButtonSelectChanged(buttontHandler(self, self.onBotTabBtnSelChanged_))
    self.botTabBtnGroup_:getButtonAtIndex(self.defaultTabBotIdx_):setButtonSelected(true)

    self.gameRecObserverHandler_ = bm.DataProxy:addDataObserver(nk.dataKeys.NEW_CARD_RECORD, handler(self, self.onGameCardRecDataObtain))
end

function CardTypeGameRecPopup:renderPanelContPageViews(pageIdx)
    -- body
    local botTabBtnHeight = 60

    local pageContAreaWidth = PANEL_WIDTH
    local pageContAreaHeight = display.height - botTabBtnHeight

    local drawPanelContPagesByIdx = {
        [1] = function()
            -- body
            local cardTypeDescContNode = display.newNode()

            local cardTypeInfoDesc = display.newSprite("#crdTyGmRc_cardTypeDesc.png")
                :addTo(cardTypeDescContNode)

            return cardTypeDescContNode
        end,

        [2] = function()
            -- body
            local gameRecContNode = display.newNode()

            local gameRecDecTitle = display.newSprite("#crdTyGmRc_decRecTitle.png")

            local gameRecTitleSizeCal = gameRecDecTitle:getContentSize()

            gameRecDecTitle:pos(0, pageContAreaHeight / 2 - gameRecTitleSizeCal.height / 2)
                :addTo(gameRecContNode)

            local labelParam = {
                fontSize = 0,
                color = display.COLOR_BLACK
            }

            local titleColumnLblsGap = 90

            labelParam.fontSize = 24
            labelParam.color = display.COLOR_WHITE
            local columnMineTitle = display.newTTFLabel({text = "你", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
            columnMineTitle:pos(gameRecTitleSizeCal.width / 2 - titleColumnLblsGap / 2 - columnMineTitle:getContentSize().width / 2, gameRecTitleSizeCal.height / 2)
                :addTo(gameRecDecTitle)

            local columnDealerTitle = display.newTTFLabel({text = "庄家", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
            columnDealerTitle:pos(gameRecTitleSizeCal.width / 2 + titleColumnLblsGap / 2 + columnDealerTitle:getContentSize().width / 2, gameRecTitleSizeCal.height / 2)
                :addTo(gameRecDecTitle)

            local cardTypeListViewSize = {
                width = pageContAreaWidth,
                height = pageContAreaHeight - gameRecTitleSizeCal.height
            }

            self.gameCardTypeRecListView_ = bm.ui.ListView.new({viewRect = cc.rect(- cardTypeListViewSize.width / 2, - cardTypeListViewSize.height / 2, cardTypeListViewSize.width,
                cardTypeListViewSize.height), direction = bm.ui.ListView.DIRECTION_VERTICAL}, GameCardRecListItem)
                :pos(0, - gameRecTitleSizeCal.height / 2)
                :addTo(gameRecContNode)

            -- self.gameCardTypeRecListView_:setData({1, 2, 3, 4, 5})
            self.gameCardTypeRecListView_:setNotHide(true)

            -- self.gameCardTypeRecListView_:setScrollContentTouchRect()
            -- self.gameCardTypeRecListView_:update()

            labelParam.fontSize = 28
            labelParam.color = display.COLOR_RED
            self.noGameCardRecHint_ = display.newTTFLabel({text = "暂无牌局记录", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
                :pos(0, - gameRecTitleSizeCal.height / 2)
                :addTo(gameRecContNode)
                :hide()

            local rowNextListPageMagrinBot = 12

            -- self.rowListNextPage_ = cc.ui.UIPushButton.new({normal = "#crdTyGmRc_arrowDown.png", pressed = "#crdTyGmRc_arrowDown.png", disabled = "#crdTyGmRc_arrowDown.png"},
            --     {scale9 = false})
            --     :onButtonClicked(handler(self, self.onListNextPageBtnCallBack_))
            --     :pos(0, - pageContAreaHeight / 2 + rowNextListPageBtnCntMagrinBot)
            --     :addTo(gameRecContNode)
            --     :hide()

            self.rowListNextPage_ = display.newSprite("#crdTyGmRc_arrowDown.png")
            self.rowListNextPage_:pos(0, - pageContAreaHeight / 2 + rowNextListPageMagrinBot + self.rowListNextPage_:getContentSize().height / 2)
                :addTo(gameRecContNode)
                :hide()

            if not self.gameCardRecDataList_ then
                --todo
                self.gameCardRecDataList_ = bm.DataProxy:getData(nk.dataKeys.NEW_CARD_RECORD)
            end

            self:onGameCardRecDataObtain(self.gameCardRecDataList_)

            return gameRecContNode
        end
    }

    self.panelContPageViews_ = self.panelContPageViews_ or {}

    for _, page in pairs(self.panelContPageViews_) do
        if page then
            --todo
            page:hide()
        end
    end

    local page = self.panelContPageViews_[pageIdx]

    if not page then
        --todo
        page = drawPanelContPagesByIdx[pageIdx]()
        self.panelContPageViews_[pageIdx] = page
        page:addTo(self.panelInfoContPageNode_)
    end

    page:show()
end

function CardTypeGameRecPopup:onBotTabBtnSelChanged_(evt)
    -- body
    local botBtnLblParam = {
        nor = {
            fontSize = 28,
            color = display.COLOR_GREEN
        },
        sel = {
            fontSize = 30,
            color = display.COLOR_WHITE
        }
    }

    if not self.botTabSelIdx_ then
        --todo
        self.botTabSelIdx_ = evt.selected
        self.botTabBtns_[self.botTabSelIdx_].label_:setTextColor(botBtnLblParam.sel.color)
        self.botTabBtns_[self.botTabSelIdx_].label_:setSystemFontSize(botBtnLblParam.sel.fontSize)
        self.botTabBtns_[self.botTabSelIdx_].imgSel_:show()
    end

    local isChanged = self.botTabSelIdx_ ~= evt.selected

    if isChanged then
        --todo
        self.botTabBtns_[self.botTabSelIdx_].label_:setTextColor(botBtnLblParam.nor.color)
        self.botTabBtns_[self.botTabSelIdx_].label_:setSystemFontSize(botBtnLblParam.nor.fontSize)
        self.botTabBtns_[self.botTabSelIdx_].imgSel_:hide()

        self.botTabBtns_[evt.selected].label_:setTextColor(botBtnLblParam.sel.color)
        self.botTabBtns_[evt.selected].label_:setSystemFontSize(botBtnLblParam.sel.fontSize)
        self.botTabBtns_[evt.selected].imgSel_:show()

        self.botTabSelIdx_ = evt.selected
    end

    self:renderPanelContPageViews(self.botTabSelIdx_)
end

-- function CardTypeGameRecPopup:onListNextPageBtnCallBack_(evt)
--     -- body
--     local itemsIn1Page = 5
--     if not self.curListPageIdx_ then
--         --todo
--         self.curListPageIdx_ = 1
--     end

--     self.curListPageIdx_ = self.curListPageIdx_ + 1
-- end

-- function CardTypeGameRecPopup:onGameRecDataChanged_(data)
--     -- body
--     self:onGameCardRecDataObtain(data)
-- end

function CardTypeGameRecPopup:onGameCardRecDataObtain(data)
    -- body
    -- dump(data, "CardTypeGameRecPopup:onGameCardRecDataObtain.data :==============")

    if data and #data > 0 then
        --todo
        if self.noGameCardRecHint_ then
            --todo
            self.noGameCardRecHint_:hide()
        end

        if self.gameCardTypeRecListView_ then
            --todo
            if self.gameCardRecDataList_ then
                --todo
                self.gameCardRecDataList_ = nil
                self.gameCardTypeRecListView_:setData(nil)
            end

            self.gameCardRecDataList_ = data

            self.gameCardTypeRecListView_:setData(self.gameCardRecDataList_)

            if #data >= 6 then
                --todo
                self.rowListNextPage_:show()
            else
                self.rowListNextPage_:hide()
            end
        end
    else
        if self.gameCardTypeRecListView_ then
            --todo
            self.gameCardTypeRecListView_:setData(nil)
            self.rowListNextPage_:hide()
        end

        if self.noGameCardRecHint_ then
            --todo
            self.noGameCardRecHint_:show()
        end
    end
end

function CardTypeGameRecPopup:showPanel(isAnim)
    self.playShowAnim_ = isAnim

    if isAnim == nil then
        --todo
        self.playShowAnim_ = true
    end

    nk.PopupManager:addPopup(self, true, false, true, false)
end

function CardTypeGameRecPopup:onShowPopup()
    -- body
    if self.playShowAnim_ then
        --todo
        self:stopAllActions()

        local animTime = .3
        transition.moveTo(self, {time = animTime, x = PANEL_WIDTH, easing = "OUT", onComplete = function()

            if self.gameCardTypeRecListView_ then
                --todo
                self.gameCardTypeRecListView_:setScrollContentTouchRect()
                self.gameCardTypeRecListView_:update()
            end
        end})
    else
        self:pos(PANEL_WIDTH, 0)
    end
end

function CardTypeGameRecPopup:onRemovePopup(removeFunc)
    self:stopAllActions()

    local animTime = .3
    transition.moveTo(self, {time = animTime, x = 0, easing = "OUT", onComplete = function() 
        removeFunc()
    end})
end

function CardTypeGameRecPopup:onEnter()
    -- body
end

function CardTypeGameRecPopup:onExit()
    -- body
    bm.DataProxy:removeDataObserver(nk.dataKeys.ROOM_CARD_RECORD, self.gameRecObserverHandler_)
    self.gameRecObserverHandler_ = nil
end

function CardTypeGameRecPopup:onCleanup()
    -- body
    display.removeSpriteFramesWithFile("cardTypeGameRec.plist", "cardTypeGameRec.png")

    nk.schedulerPool:delayCall(function()
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    end, 0.1)
end

return CardTypeGameRecPopup