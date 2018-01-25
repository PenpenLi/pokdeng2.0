--
-- Author: TsingZhang@boyaa.com
-- Date: 2016-03-14 15:14:54
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: GiftStorePopup.lua Reconstruced By Tsing.
--

local GiftPrdLineListItem = import(".compViews.GiftPrdLineListItem")
local PropPrdListItem = import(".compViews.PropPrdListItem")

local StorePopupController = import(".StorePopupController")

local PANEL_WIDTH = 792
local PANEL_HEIGHT = 470

local PANELTOPOPR_HEIGHT = 0
local PANELLEFTOPR_WIDTH = 0

local GiftStorePopup = class("GiftStorePopup", nk.ui.Panel)

function GiftStorePopup:ctor(defaultTabIdx)
	-- body
    self.defualtLeftTabIdx_ = defaultTabIdx or 1
    self.controller_ = StorePopupController.new(self)

    self:setNodeEventEnabled(true)
	self.super.ctor(self, {PANEL_WIDTH, PANEL_HEIGHT})

    display.addSpriteFrames("giftStore.plist", "giftStore.png", handler(self, self.onGiftStoreTextureLoaded_))
end

function GiftStorePopup:onGiftStoreTextureLoaded_(fileName, imgName)
    -- body
    local titleDesc = display.newSprite("#propGift_decTitleStoreDesc.png")

    self:addPanelTitleBar(titleDesc)

    local titleBarSize = self:getTitleBarSize()

    PANELTOPOPR_HEIGHT = titleBarSize.height

    local panelBorWidth = 6

    local leftOprPanelModel = display.newSprite("#propGift_bgLeftTabBar.png")
    local leftOprPanelSizeCal = leftOprPanelModel:getContentSize()

    PANELLEFTOPR_WIDTH = leftOprPanelSizeCal.width

    local leftOprPanelHeightFix = 1.5

    local leftOprPanelSize = {
        width = PANELLEFTOPR_WIDTH,
        height = PANEL_HEIGHT - panelBorWidth * 2 - PANELTOPOPR_HEIGHT - leftOprPanelHeightFix * 2
    }

    local leftOprPanelPosXAdj = 3

    local leftOprPanel = display.newScale9Sprite("#propGift_bgLeftTabBar.png", - PANEL_WIDTH / 2 + panelBorWidth + leftOprPanelSize.width / 2 + leftOprPanelPosXAdj, - PANEL_HEIGHT / 2 + panelBorWidth +
        leftOprPanelSize.height / 2, cc.size(leftOprPanelSize.width, leftOprPanelSize.height))
        :addTo(self)

    local leftTabBtnSize = {
        width = leftOprPanelSize.width,
        height = 64
    }

    local leftBtnMagrinEachVect = - 3

    self.leftTabBtnGroup_ = nk.ui.CheckBoxButtonGroup.new()
    self.leftTabBtns_ = {}

    for i = 1, 2 do
        self.leftTabBtns_[i] = cc.ui.UICheckBoxButton.new({on = "#propGift_btnLeftTabItem_sel.png", off = "#propGift_btnLeftTabItem_unSel.png"}, {scale9 = true})
            :setButtonSize(leftTabBtnSize.width, leftTabBtnSize.height)
            :pos(leftOprPanelSize.width / 2, leftOprPanelSize.height - leftTabBtnSize.height / 2 *(i * 2 - 1) - leftBtnMagrinEachVect * (i - 1))
            :addTo(leftOprPanel)

        self.leftTabBtns_[i].label_ = display.newSprite("#propGift_decDescSubTi" .. i .. "_unSel.png")
            :addTo(self.leftTabBtns_[i])

        self.leftTabBtnGroup_:addButton(self.leftTabBtns_[i])
    end

    self.giftPropContPageNode_ = display.newNode()
        :pos(PANELLEFTOPR_WIDTH / 2, - PANELTOPOPR_HEIGHT / 2)
        :addTo(self)

    self.leftTabBtnGroup_:onButtonSelectChanged(buttontHandler(self, self.onLeftTabBtnSelChanged_))
    self.leftTabBtnGroup_:getButtonAtIndex(self.defualtLeftTabIdx_):setButtonSelected(true)

    self:addCloseBtn()
end

function GiftStorePopup:renderGiftPropContPageViews(pageIdx)
    -- body
    local panelBorWidth = 6
    local pageContAreaWidth = PANEL_WIDTH - panelBorWidth * 2 - PANELLEFTOPR_WIDTH
    local pageContAreaHeight = PANEL_HEIGHT - panelBorWidth * 2 - PANELTOPOPR_HEIGHT

    local drawGiftPropPageContByIdx = {
        [1] = function()
            -- body
            local giftWareContPage = display.newNode()

            local labelParam = {
                fontSize = 0,
                color = display.COLOR_BLACK
            }

            local contPageTopOprAreaHeight = 0

            local giftWareTypeSelBtnSize = {
                width = 136,
                height = 45
            }

            local wareTypeBtnsMagrinEachHoriz = 12
            local wareTypeBtnsMagrinTop = 15

            contPageTopOprAreaHeight = wareTypeBtnsMagrinTop * 2 + giftWareTypeSelBtnSize.height

            local giftWareTypeStrs = {
                "热 销",
                "新 品",
                "节 日",
                "其 他"
            }

            self.giftWareTypeBtnGroup_ = nk.ui.CheckBoxButtonGroup.new()
            self.giftWareTypeBtns_ = {}

            labelParam.fontSize = 26
            labelParam.color = display.COLOR_WHITE
            for i = 1, #giftWareTypeStrs do
                self.giftWareTypeBtns_[i] = cc.ui.UICheckBoxButton.new({on = "#propGift_btnSubGiftType_sel.png", off = "#propGift_btnSubGiftType_unSel.png"}, {scale9 = true})
                    :setButtonSize(giftWareTypeSelBtnSize.width, giftWareTypeSelBtnSize.height)
                    :pos((giftWareTypeSelBtnSize.width + wareTypeBtnsMagrinEachHoriz) / 2 * (i * 2 - 5), pageContAreaHeight / 2 - wareTypeBtnsMagrinTop -
                        giftWareTypeSelBtnSize.height / 2)
                    :addTo(giftWareContPage)

                self.giftWareTypeBtns_[i].label_ = display.newTTFLabel({text = giftWareTypeStrs[i], size = labelParam.fontSize, color = labelParam.color, align =
                    ui.TEXT_ALIGN_CENTER})
                    :addTo(self.giftWareTypeBtns_[i])

                self.giftWareTypeBtnGroup_:addButton(self.giftWareTypeBtns_[i])
            end

            local giftWareTypeDefaultIdx = 1

            local oprGiftBuyBotPanelSize = {
                width = pageContAreaWidth,
                height = 78
            }

            local dentBotStencil = {
                x = 5,
                y = 1,
                width = 113,
                height = 80
            }

            local oprGiftBuyPanel = display.newScale9Sprite("#common_bgDentPanelBot.png", 0, - pageContAreaHeight / 2 + oprGiftBuyBotPanelSize.height / 2, cc.size(oprGiftBuyBotPanelSize.width,
                oprGiftBuyBotPanelSize.height), cc.rect(dentBotStencil.x, dentBotStencil.y, dentBotStencil.width, dentBotStencil.height))
                :addTo(giftWareContPage)

            local oprGiftBuyBtnSize = {
                width = 170,
                height = 56
            }

            local oprBuyBtnsMagrinEach = 52

            labelParam.fontSize = 28
            labelParam.color = display.COLOR_WHITE
            self.preGiftToAllTableBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnGreenRigOutl.png", pressed = "#common_btnGreenRigOutl.png", disabled = "#common_btnGreyLitRigOut.png"}, {scale9 = true})
                :setButtonSize(oprGiftBuyBtnSize.width, oprGiftBuyBtnSize.height)
                :setButtonLabel(display.newTTFLabel({text = "买给牌桌×" .. (self.tableUserNum_ or 0), size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
                :onButtonClicked(buttontHandler(self, self.onBuyGiftToAllBtnCallBack_))
                :pos(oprGiftBuyBotPanelSize.width / 2 - oprGiftBuyBtnSize.width / 2 - oprBuyBtnsMagrinEach / 2, oprGiftBuyBotPanelSize.height / 2)
                :addTo(oprGiftBuyPanel)
                :hide()

            self.preGiftToAllTableBtn_:setButtonEnabled(false)

            self.buyGiftToSelfBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnYellowRigOutl.png", pressed = "#common_btnYellowRigOutl.png", disabled = "#common_btnGreyLitRigOut.png"}, {scale9 = true})
                :setButtonSize(oprGiftBuyBtnSize.width, oprGiftBuyBtnSize.height)
                :setButtonLabel(display.newTTFLabel({text = "购买", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
                :onButtonClicked(buttontHandler(self, self.onBuyGiftToSelfBtnCallBack_))
                :pos(oprGiftBuyBotPanelSize.width / 2, oprGiftBuyBotPanelSize.height / 2)
                :addTo(oprGiftBuyPanel)

            self.buyGiftToSelfBtn_:setButtonEnabled(false)

            if self.toUid_ and self.toUid_ ~= nk.userData.uid then
                --todo
                self.buyGiftToSelfBtn_:getButtonLabel():setString("赠送")
            end

            if self.isInRoom_ then
                --todo
                self.buyGiftToSelfBtn_:pos(oprGiftBuyBotPanelSize.width / 2 + oprGiftBuyBtnSize.width / 2 + oprBuyBtnsMagrinEach / 2, oprGiftBuyBotPanelSize.height / 2)
                self.preGiftToAllTableBtn_:show()
            end

            local giftWareListViewMagrinBorHoriz = 4

            local prdGiftWareListViewSize = {
                width = pageContAreaWidth - giftWareListViewMagrinBorHoriz * 2,
                height = pageContAreaHeight - contPageTopOprAreaHeight - oprGiftBuyBotPanelSize.height
            }

            self.prdGiftListView_ = bm.ui.ListView.new({viewRect = cc.rect(- prdGiftWareListViewSize.width / 2, - prdGiftWareListViewSize.height / 2, prdGiftWareListViewSize.width,
                prdGiftWareListViewSize.height), direction = bm.ui.ListView.DIRECTION_VERTICAL}, GiftPrdLineListItem)
                :pos(0, (oprGiftBuyBotPanelSize.height - contPageTopOprAreaHeight) / 2)
                :addTo(giftWareContPage)

            self.prdGiftListView_.itemClass_:setGiftPrdActionCallBack(handler(self, self.onGiftPrdItemActionCallBack_))

            -- self.prdGiftListView_:setData({1, 2, 3, 4, 5})
            self.prdGiftListView_:setNotHide(true)

            labelParam.fontSize = 28
            labelParam.color = display.COLOR_RED
            self.noGiftWareSaleTip_ = display.newTTFLabel({text = "暂无商品出售", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
                :pos(0, (oprGiftBuyBotPanelSize.height - contPageTopOprAreaHeight) / 2)
                :addTo(giftWareContPage)
                :hide()

            self.giftWarePrdConfInit_ = true

            self.giftWareTypeBtnGroup_:onButtonSelectChanged(buttontHandler(self, self.onGiftWareTypeSelChanged_))
            self.giftWareTypeBtnGroup_:getButtonAtIndex(giftWareTypeDefaultIdx):setButtonSelected(true)

            return giftWareContPage
        end,

        [2] = function()
            -- body
            local propWareContPage = display.newNode()

            local propWareListViewMagrins = {
                horiz = 3,
                vect = 6
            }

            local propWareListViewSize = {
                width = pageContAreaWidth - propWareListViewMagrins.horiz * 2,
                height = pageContAreaHeight - propWareListViewMagrins.vect * 2
            }

            self.prdPropListView_ = bm.ui.ListView.new({viewRect = cc.rect(- propWareListViewSize.width / 2, - propWareListViewSize.height / 2, propWareListViewSize.width, propWareListViewSize.height),
                direction = bm.ui.ListView.DIRECTION_VERTICAL}, PropPrdListItem)
                :addTo(propWareContPage)

            self.prdPropListView_:addEventListener("ITEM_EVENT", handler(self, self.onPropItemEvtCallBack_))

            -- self.prdPropListView_:setData({1, 2, 3, 4, 5})
            self.prdPropListView_:setNotHide(true)

            local labelParam = {
                fontSize = 0,
                color = display.COLOR_BLACK
            }

            labelParam.fontSize = 28
            labelParam.color = display.COLOR_RED
            self.noPropWareSaleTip_ = display.newTTFLabel({text = "暂无商品出售", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
                :addTo(propWareContPage)
                :hide()

            return propWareContPage
        end
    }

    self.storeContPageViews_ = self.storeContPageViews_ or {}

    for _, page in pairs(self.storeContPageViews_) do
        if page then
            --todo
            page:hide()
        end
    end

    local page = self.storeContPageViews_[pageIdx]

    if not page then
        --todo
        page = drawGiftPropPageContByIdx[pageIdx]()
        self.storeContPageViews_[pageIdx] = page
        page:addTo(self.giftPropContPageNode_)
    end

    page:show()
end

function GiftStorePopup:setGiftStoreReqDataLoading(state)
    -- body
    if state then
        --todo
        if not self.reqDataLoadingBar_ then
            --todo
            self.reqDataLoadingBar_ = nk.ui.Juhua.new()
                :addTo(self.giftPropContPageNode_)
        end
    else
        if self.reqDataLoadingBar_ then
            --todo
            self.reqDataLoadingBar_:removeFromParent()
            self.reqDataLoadingBar_ = nil
        end

    end
end

function GiftStorePopup:onLeftTabBtnSelChanged_(evt)
    -- body
    if not self.leftTabSelIdx_ then
        --todo
        self.leftTabSelIdx_ = evt.selected

        self.leftTabBtns_[self.leftTabSelIdx_].label_:setSpriteFrame("propGift_decDescSubTi" .. self.leftTabSelIdx_ .. "_sel.png")
    end

    local isChanged = self.leftTabSelIdx_ ~= evt.selected

    if isChanged then
        --todo
        self.leftTabBtns_[self.leftTabSelIdx_].label_:setSpriteFrame("propGift_decDescSubTi" .. self.leftTabSelIdx_ .. "_unSel.png")

        self.leftTabBtns_[evt.selected].label_:setSpriteFrame("propGift_decDescSubTi" .. evt.selected .. "_sel.png")

        self.leftTabSelIdx_ = evt.selected
    end

    self:renderGiftPropContPageViews(self.leftTabSelIdx_)

    self:getGiftPropPagesData()
end

function GiftStorePopup:onGiftWareTypeSelChanged_(evt)
    -- body
    local giftWareTypeBtnLblColor = {
        nor = display.COLOR_WHITE,
        sel = display.COLOR_GREEN
    }

    if not self.giftWareTypeTabSelIdx_ then
        --todo
        self.giftWareTypeTabSelIdx_ = evt.selected

        self.giftWareTypeBtns_[self.giftWareTypeTabSelIdx_].label_:setTextColor(giftWareTypeBtnLblColor.sel)
    end

    local isChanged = self.giftWareTypeTabSelIdx_ ~= evt.selected

    if isChanged then
        --todo
        self.giftWareTypeBtns_[self.giftWareTypeTabSelIdx_].label_:setTextColor(giftWareTypeBtnLblColor.nor)

        self.giftWareTypeBtns_[evt.selected].label_:setTextColor(giftWareTypeBtnLblColor.sel)

        self.giftWareTypeTabSelIdx_ = evt.selected
    end

    local getGiftWareDataDelayTime = .02
    self:performWithDelay(function()
        -- body
        self.controller_:onGiftWareTypeSelChaned(self.giftWareTypeTabSelIdx_)
    end, getGiftWareDataDelayTime)

    self:setGiftStoreReqDataLoading(true)
end

function GiftStorePopup:onBuyGiftToAllBtnCallBack_(evt)
    -- body
    self.controller_:presentGiftToTable(self.giftStoreSelGiftId_, self.toUidArr_, self.allTableId_)
end

function GiftStorePopup:onBuyGiftToSelfBtnCallBack_(evt)
    -- body
    if self.isInRoom_ then
        --todo
        self.controller_:presentGiftToPlayer(self.giftStoreSelGiftId_, self.toUid_)
    else
        self.controller_:buyGiftToSelf(self.giftStoreSelGiftId_)
    end
end

function GiftStorePopup:onGiftPrdItemActionCallBack_(giftId)
    -- body
    self.giftStoreSelGiftId_ = giftId

    -- log("GiftStorePopup:onGiftPrdItemActionCallBack_.giftStoreSelGiftId_ :" .. self.giftStoreSelGiftId_)
end

function GiftStorePopup:onPropItemEvtCallBack_(evt)
    -- body
    local propsId = evt.data.id

    self.controller_:buyPropsById(propsId)
end

function GiftStorePopup:getGiftPropPagesData()
    -- body
    local getContPageDataByIdx = {
        [1] = function()
            -- body
            self.controller_:getGiftWarePrdData()

            if self.giftWarePrdConfInit_ then
                --todo
                self.giftWarePrdConfInit_ = false
            end
        end,

        [2] = function()
            -- body
            self.controller_:getPropsWarePrdData()
        end
    }

    getContPageDataByIdx[self.leftTabSelIdx_]()
    self:setGiftStoreReqDataLoading(true)

    if self.leftTabSelIdx_ == 1 and not self.giftWarePrdConfInit_ then
        --todo
        self:setGiftStoreReqDataLoading(false)
    end
end

function GiftStorePopup:rangeGiftWareTypeData(dataList)
    -- body
    local retTab = {}

    local retTabelLen = math.ceil(#dataList / 4)

    for i = 1, retTabelLen do
        retTab[i] = {}
        for j = 1, 4 do
            if dataList[(i - 1) * 4 + j] then
                --todo
                table.insert(retTab[i], dataList[(i - 1) * 4 + j])
            end
        end
    end

    return retTab
end

function GiftStorePopup:onSelGiftTypeWareDataGet(giftType, data)
    -- body
    -- dump(data, "GiftStorePopup:onSelGiftTypeWareDataGet.giftType(" .. giftType .. ") :==================")

    self:setGiftStoreReqDataLoading(false)
    if self.leftTabSelIdx_ ~= 1 or giftType ~= self.giftWareTypeTabSelIdx_ then
        --todo
        return
    end

    self.prdGiftListView_:setData(nil)

    if data and #data > 0 then
        --todo
        if self.noGiftWareSaleTip_ then
            --todo
            self.noGiftWareSaleTip_:hide()
        end

        self.giftStoreSelGiftId_ = data[1].pnid

        data[1].isDefaultSel_ = true

        local giftListGruopData = self:rangeGiftWareTypeData(data)

        -- dump(giftListGruopData, "RangedGiftTypeWareListData :===================")

        self.prdGiftListView_:setData(giftListGruopData)

        self.preGiftToAllTableBtn_:setButtonEnabled(true)
        self.buyGiftToSelfBtn_:setButtonEnabled(true)
    else
        self.giftStoreSelGiftId_ = nil

        self.noGiftWareSaleTip_:show()

        self.preGiftToAllTableBtn_:setButtonEnabled(false)
        self.buyGiftToSelfBtn_:setButtonEnabled(false)
    end
end

function GiftStorePopup:onPropPrdWareDataGet(data)
    -- body
    self:setGiftStoreReqDataLoading(false)

    if self.leftTabSelIdx_ ~= 2 then
        --todo
        return
    end

    self.prdPropListView_:setData(nil)

    if #data > 0 then
        --todo
        self.noPropWareSaleTip_:hide()

        self.prdPropListView_:setData(data)
    else
        self.noPropWareSaleTip_:show()
    end
end

function GiftStorePopup:onGetWarePrdDataWrong(prdType)
    -- body

    self:setGiftStoreReqDataLoading(false)

    -- Gift Config Loaded Wrong. --
    if prdType == 1 then
        --todo
        nk.TopTipManager:showTopTip("拉取礼物配置出错")

    -- Props Data Wrong. --
    elseif prdType == 2 then
        --todo
        self.prdPropListView_:setData(nil)

        nk.ui.Dialog.new({messageText = bm.LangUtil.getText("COMMON", "REQUEST_DATA_FAIL"), secondBtnText = bm.LangUtil.getText("COMMON", "RETRY"), callback = function(type)
            if type == nk.ui.Dialog.SECOND_BTN_CLICK then
                self.controller_:getPropsWarePrdData()
                self:setGiftStoreReqDataLoading(true)
            end
        end
        }):show()
    end

end

function GiftStorePopup:showPanel(roomInfo)
	-- body
	if roomInfo then
		--todo
		self.isInRoom_ = roomInfo.isInRoom
        self.toUid_ = roomInfo.toUid
        self.toUidArr_ = roomInfo.toUidArr
        self.tableUserNum_ = roomInfo.tableNum
        self.allTableId_ = roomInfo.allTabId
	end

	self:showPanel_(true, true, true, true)
end

function GiftStorePopup:onShowed()
	-- body
    if self.prdGiftListView_ then
        --todo
        self.prdGiftListView_:update()
    end

    if self.prdPropListView_ then
        --todo
        self.prdPropListView_:update()
    end

end

function GiftStorePopup:hidePanel()
	-- body
	self:hidePanel_()
end

function GiftStorePopup:onRemovePopup(removeFuc)
    -- body
    removeFuc()
end

function GiftStorePopup:onEnter()
	-- body
end

function GiftStorePopup:onExit()
	-- body
	self.controller_:wearPurchedGift()

	self.controller_:dispose()
end

function GiftStorePopup:onCleanup()
	-- body
    display.removeSpriteFramesWithFile("giftStore.plist", "giftStore.png")

    nk.schedulerPool:delayCall(function()
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    end, 0.1)

end

return GiftStorePopup