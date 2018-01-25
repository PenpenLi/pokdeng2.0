--
-- Author: tony
-- Date: 2014-11-17 16:32:41
-- Copyright: Copyright (c) 2014, BOOMEGG INTERACTIVE CO., LTD All rights reserved.
-- Description: StorePopup.lua ReConstructed by Tsing.
--

local StorePopupController = import(".StorePopupController")

local PrdChipListItem = import(".compViews.PrdChipListItem")
local PrdCashListItem = import(".compViews.PrdCashListItem")
local UsrPayHistryListItem = import(".compViews.UsrPayHistryListItem")

local PANEL_WIDTH = 790
local PANEL_HEIGHT = 470

local PANELLEFTOPR_WIDTH = 0
local PANELTOPOPR_HEIGHT = 0

local StorePopup = class("StorePopup", nk.ui.Panel)

function StorePopup:ctor(defaultTabIdx, defaultPayType)
    self:setNodeEventEnabled(true)
    self.super.ctor(self, {PANEL_WIDTH, PANEL_HEIGHT})

    self.defaultTopTabIdx_ = defaultTabIdx or 1
    self.defaultPayType_ = defaultPayType

    self.controller_ = StorePopupController.new(self)

    display.addSpriteFrames("store.plist", "store.png", handler(self, self.onStoreTextureLoaded_))
end

function StorePopup:onStoreTextureLoaded_(fileName, imageName)
    -- body
    self.storeTopTabNode_ = display.newNode()
    self:addPanelTitleBar(self.storeTopTabNode_)

    -- self:renderStoreContViews()
    self.controller_:init()
    self:setStoreReqPayConfL1DataLoading(true)
    self:addCloseBtn()
end

function StorePopup:renderStoreContViews(availablePayType)
    -- body
    self:setStoreReqPayConfL1DataLoading(false)

    self.availType_ = availablePayType

    local titleBarSize = self:getTitleBarSize()

    PANELTOPOPR_HEIGHT = titleBarSize.height

    local topTabBtnHBorFix = 2
    local topTabBtnWBorFix = 1
    local topTabBtnSize = {
        width = (titleBarSize.width - topTabBtnWBorFix * 3) / 3,
        height = PANELTOPOPR_HEIGHT - topTabBtnHBorFix * 2
    }

    self.topTabBtns_ = {}
    self.topTabBtnGroup_ = nk.ui.CheckBoxButtonGroup.new()

    local btnSelImgModel = display.newSprite("#store_bgTopTabBtnSel.png")
    local btnSelImgSizeCal = btnSelImgModel:getContentSize()
    local btnSelImgWBorFix = .3

    local btnSelImgPosAdj = {
        x = - .5,
        y = 2
    }

    for i = 1, 3 do
        self.topTabBtns_[i] = cc.ui.UICheckBoxButton.new({on = "#common_modTransparent.png", off = "#common_modTransparent.png"}, {scale9 = true})
            :setButtonSize(topTabBtnSize.width, topTabBtnSize.height)
            :pos((i - 2) * topTabBtnSize.width, 0)
            :addTo(self.storeTopTabNode_)

        self.topTabBtns_[i].imgSel_ = display.newSprite("#store_bgTopTabBtnSel.png")
            :pos(btnSelImgPosAdj.x, btnSelImgPosAdj.y)
            :addTo(self.topTabBtns_[i])

        self.topTabBtns_[i].imgSel_:setScaleX((topTabBtnSize.width - btnSelImgWBorFix * 2) / btnSelImgSizeCal.width)
        self.topTabBtns_[i].imgSel_:hide()

        self.topTabBtns_[i].label_ = display.newSprite("#store_dscTopTabTi" .. i .. "_unSel.png")
            :addTo(self.topTabBtns_[i])

        self.topTabBtnGroup_:addButton(self.topTabBtns_[i])
    end

    self.payTypeSel_ = self.availType_[1]

    if self.availType_ and #self.availType_ > 1 then
        --todo
        self.isMultiPayType_ = true
        self:createLeftPayTypePanel()
    end

    self.utilPayTypePrdContNode_ = display.newNode()
        :pos(PANELLEFTOPR_WIDTH / 2, - PANELTOPOPR_HEIGHT / 2)
        :addTo(self)

    self.topTabBtnGroup_:onButtonSelectChanged(buttontHandler(self, self.onTopTabBtnSelChanged_))
    self.topTabBtnGroup_:getButtonAtIndex(self.defaultTopTabIdx_):setButtonSelected(true)
end

function StorePopup:createLeftPayTypePanel()
    -- body
    local defaultPayTypeIdx = 1

    local leftOprPanelModel = display.newSprite("#store_bgLeftOprPanel.png")
    local leftOprPanelSizeCal = leftOprPanelModel:getContentSize()

    PANELLEFTOPR_WIDTH = leftOprPanelSizeCal.width

    local panelBorWidth = 6
    local panelTitleBarSize = self:getTitleBarSize()

    local leftOprPanelHBorFix = 2
    local leftOprPanelSize = {
        width = PANELLEFTOPR_WIDTH,
        height = PANEL_HEIGHT - panelBorWidth * 2 - panelTitleBarSize.height - leftOprPanelHBorFix * 2
    }

    local leftOprPanelPosFix = {
        x = 2,
        y = 1
    }
    self.leftOprPanelContNode_ = display.newNode()
        :pos(- PANEL_WIDTH / 2 + panelBorWidth + leftOprPanelSize.width / 2 + leftOprPanelPosFix.x, - PANEL_HEIGHT / 2 + leftOprPanelSize.height / 2 + panelBorWidth + leftOprPanelPosFix.y)
        :addTo(self)

    local leftOprPanel = display.newScale9Sprite("#store_bgLeftOprPanel.png", 0, 0, cc.size(leftOprPanelSize.width, leftOprPanelSize.height))
        :addTo(self.leftOprPanelContNode_)

    local scrollViewContent = display.newNode()

    local payTypeChkBtnSize = {
        width = PANELLEFTOPR_WIDTH,
        height = 64
    }

    local payTypeBtnsMagrinEach = .5

    self.payTypeChkBtnGroup_ = nk.ui.CheckBoxButtonGroup.new()
    local payTypeChkBtn = nil
    local payTypeIc = nil

    for i, payType in ipairs(self.availType_) do
        local payTypeChkBtnPosY = payTypeChkBtnSize.height * #self.availType_ / 2 + (#self.availType_ - 1) * payTypeBtnsMagrinEach - (i * 2 - 1) * payTypeChkBtnSize.height / 2 - (i - 1) *
            payTypeBtnsMagrinEach

        payTypeChkBtn = cc.ui.UICheckBoxButton.new({on = "#store_bgLeftTabBtn_sel.png", off = "#store_bgLeftTabBtn_unSel.png"}, {scale9 = true})
            :setButtonSize(payTypeChkBtnSize.width, payTypeChkBtnSize.height)
            :pos(0, payTypeChkBtnPosY)
            :addTo(scrollViewContent)

        payTypeChkBtn:setTouchSwallowEnabled(false)

        local path = cc.FileUtils:getInstance():fullPathForFilename("store_payType_" .. payType.id .. ".png")
        -- dump(path, "paytype.id:" .. payType.id .. "exists:" .. tostring(io.exists(path))  .. " :===================")

        if io.exists(path) then
            payTypeIc = display.newSprite("store_payType_" .. payType.id .. ".png")
                :addTo(payTypeChkBtn)
        else
            local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("store_payType_" .. payType.id .. ".png")
            if frame then
                payTypeIc = display.newSprite(frame)
                    :addTo(payTypeChkBtn)
            end
        end

        self.payTypeChkBtnGroup_:addButton(payTypeChkBtn)

        if payType.id == self.defaultPayType_ then
            defaultPayTypeIdx = i
        end
    end

    self.leftPayTypeInit_ = true

    self.payTypeChkBtnGroup_:onButtonSelectChanged(handler(self, self.onLeftPayTypeBtnSelChanged_))
    self.payTypeChkBtnGroup_:getButtonAtIndex(defaultPayTypeIdx):setButtonSelected(true)

    local payTypeScrollViewSizeHBorFix = 1
    local payTypeScrollViewSize = {
        width = PANELLEFTOPR_WIDTH,
        height = leftOprPanelSize.height - payTypeScrollViewSizeHBorFix * 2
    }

    self.leftOprPayTypeScrollview_ = bm.ui.ScrollView.new({viewRect = cc.rect(- payTypeScrollViewSize.width / 2, - payTypeScrollViewSize.height / 2, payTypeScrollViewSize.width,
        payTypeScrollViewSize.height), scrollContent = scrollViewContent, direction = bm.ui.ScrollView.DIRECTION_VERTICAL})
        :addTo(self.leftOprPanelContNode_)

    PANELLEFTOPR_WIDTH = leftOprPanelSizeCal.width + leftOprPanelPosFix.x
end

function StorePopup:renderStoreContPageViews(tabIdx)
    -- body
    local panelBorWidth = 6

    local pageContAreaHBorFix = 3
    local pageContAreaWidth = PANEL_WIDTH - panelBorWidth * 2 - PANELLEFTOPR_WIDTH
    local pageContAreaHeight = PANEL_HEIGHT - panelBorWidth * 2 - PANELTOPOPR_HEIGHT - pageContAreaHBorFix * 2

    local drawStroeMainContListViewsByIdx = {
        [1] = function()
            -- body
            local prdChipListNode = display.newNode()

            local labelParam = {
                fontSize = 0,
                color = display.COLOR_BLACK
            }

            local prdChipListViewSize = {
                width = pageContAreaWidth,
                height = pageContAreaHeight
            }

            self.prdChipListView_ = bm.ui.ListView.new({viewRect = cc.rect(- prdChipListViewSize.width / 2, - prdChipListViewSize.height / 2, prdChipListViewSize.width,
                prdChipListViewSize.height), direction = bm.ui.ListView.DIRECTION_VERTICAL}, PrdChipListItem)
                :addTo(prdChipListNode)

            self.prdChipListView_.itemClass_:setItemMultiPayType(self.isMultiPayType_)
            self.prdChipListView_:addEventListener("ITEM_EVENT", handler(self, self.onPrdEvtCallBack_))

            -- self.prdChipListView_:setData({1, 2, 3, 4, 5})
            self.prdChipListView_:setNotHide(true)

            labelParam.fontSize = 28
            labelParam.color = display.COLOR_RED

            self.prdChipWareListTip_ = display.newTTFLabel({text = "暂无商品", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
                :addTo(prdChipListNode)
                :hide()

            return prdChipListNode
        end,

        [2] = function()
            -- body
            local prdCashListNode = display.newNode()

            local labelParam = {
                fontSize = 0,
                color = display.COLOR_BLACK
            }

            local prdCashListViewSize = {
                width = pageContAreaWidth,
                height = pageContAreaHeight
            }

            self.prdCashListView_ = bm.ui.ListView.new({viewRect = cc.rect(- prdCashListViewSize.width / 2, - prdCashListViewSize.height / 2, prdCashListViewSize.width,
                prdCashListViewSize.height), direction = bm.ui.ListView.DIRECTION_VERTICAL}, PrdCashListItem)
                :addTo(prdCashListNode)

            self.prdCashListView_.itemClass_:setItemMultiPayType(self.isMultiPayType_)
            self.prdCashListView_:addEventListener("ITEM_EVENT", handler(self, self.onPrdEvtCallBack_))

            -- self.prdCashListView_:setData({1, 2, 3, 4, 5})
            self.prdCashListView_:setNotHide(true)

            labelParam.fontSize = 28
            labelParam.color = display.COLOR_RED

            self.prdCashWareListTip_ = display.newTTFLabel({text = "暂无商品", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
                :addTo(prdCashListNode)
                :hide()

            return prdCashListNode
        end,

        [3] = function()
            -- body
            local usrPayHistryListNode = display.newNode()

            local labelParam = {
                fontSize = 0,
                color = display.COLOR_BLACK
            }

            local usrPaymentHistryListViewSize = {
                width = PANEL_WIDTH - panelBorWidth * 2,
                height = pageContAreaHeight
            }

            self.usrPaymentHistryListView_ = bm.ui.ListView.new({viewRect = cc.rect(- usrPaymentHistryListViewSize.width / 2, - usrPaymentHistryListViewSize.height / 2,
                usrPaymentHistryListViewSize.width, usrPaymentHistryListViewSize.height), direction = bm.ui.ListView.DIRECTION_VERTICAL}, UsrPayHistryListItem)
                :addTo(usrPayHistryListNode)

            -- self.usrPaymentHistryListView_:setData({1, 2, 3, 4, 5})
            -- self.usrPaymentHistryListView_:setNotHide(true)

            labelParam.fontSize = 28
            labelParam.color = display.COLOR_RED

            self.paymentHistryListTip_ = display.newTTFLabel({text = "暂无购买记录", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
                :addTo(usrPayHistryListNode)
                :hide()

            return usrPayHistryListNode
        end
    }

    self.storeListContPageViews_ = self.storeListContPageViews_ or {}

    for _, page in pairs(self.storeListContPageViews_) do
        if page then
            --todo
            page:hide()
        end
    end

    local page = self.storeListContPageViews_[tabIdx]

    if not page then
        --todo
        page = drawStroeMainContListViewsByIdx[tabIdx]()
        self.storeListContPageViews_[tabIdx] = page

        if tabIdx == 3 then
            --todo
            page:pos(0, - PANELTOPOPR_HEIGHT / 2)
                :addTo(self)
        else
            page:addTo(self.utilPayTypePrdContNode_)
        end
    end

    page:show()
end

function StorePopup:showPrdPayCodeInputBlkIf(prdType)
    -- body
    self.prdTypeSel_ = prdType

    local panelBorWidth = 6

    local pageContAreaHBorFix = 3
    local pageContAreaWidth = PANEL_WIDTH - panelBorWidth * 2 - PANELLEFTOPR_WIDTH
    local pageContAreaHeight = PANEL_HEIGHT - panelBorWidth * 2 - PANELTOPOPR_HEIGHT - pageContAreaHBorFix * 2

    local payCodeNoEditBlkSize = {
        width = 450,
        height = 44
    }

    local cardInfoEditBlkMagrinTop = 16
    local cardInfoEditBlkMagrinLeft = 15
    local cardInfoEditBlkMagrinEachVect = 6

    local editNorTextFontSize = 24
    local editNorTextColor = display.COLOR_WHITE
    local cardInfoNameMaxLenght = 25

    if not self.prdPayCodeInputBlkNode_ then
        --todo
        self.prdPayCodeInputBlkNode_ = display.newNode()
            :addTo(self.utilPayTypePrdContNode_)
    end

    self.prdPayCodeInputBlkNode_:show()

    if not self.payCodeNoEdit_ then
        --todo
        self.payCodeNoEdit_ = cc.ui.UIInput.new({image = "#common_bgInputLayer.png", size = cc.size(payCodeNoEditBlkSize.width, payCodeNoEditBlkSize.height),--[[ listener = 
            ]]x = - pageContAreaWidth / 2 + cardInfoEditBlkMagrinLeft + payCodeNoEditBlkSize.width / 2, y = pageContAreaHeight / 2 - cardInfoEditBlkMagrinTop -
                payCodeNoEditBlkSize.height / 2})
            :addTo(self.prdPayCodeInputBlkNode_)

        self.payCodeNoEdit_:setFont(ui.DEFAULT_TTF_FONT, editNorTextFontSize)
        self.payCodeNoEdit_:setFontColor(editNorTextColor)

        self.payCodeNoEdit_:setPlaceHolder("")
        self.payCodeNoEdit_:setPlaceholderFont(ui.DEFAULT_TTF_FONT, editNorTextFontSize)
        self.payCodeNoEdit_:setPlaceholderFontColor(editNorTextColor)

        self.payCodeNoEdit_:setMaxLength(cardInfoNameMaxLenght)
        self.payCodeNoEdit_:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        self.payCodeNoEdit_:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
        self.payCodeNoEdit_:setInputFlag(cc.EDITBOX_INPUT_FLAG_SENSITIVE)

        self.payCodeNoEdit_:hide()

        nk.EditBoxManager:addEditBox(self.payCodeNoEdit_, 1)
    end

    if not self.payCodePinEdit_ then
        --todo
        self.payCodePinEdit_ = cc.ui.UIInput.new({image = "#common_bgInputLayer.png", size = cc.size(payCodeNoEditBlkSize.width, payCodeNoEditBlkSize.height),--[[ listener = 
            ]]x = - pageContAreaWidth / 2 + cardInfoEditBlkMagrinLeft + payCodeNoEditBlkSize.width / 2, y = pageContAreaHeight / 2 - cardInfoEditBlkMagrinTop -
                payCodeNoEditBlkSize.height * 3 / 2 - cardInfoEditBlkMagrinEachVect})
            :addTo(self.prdPayCodeInputBlkNode_)

        self.payCodePinEdit_:setFont(ui.DEFAULT_TTF_FONT, editNorTextFontSize)
        self.payCodePinEdit_:setFontColor(editNorTextColor)

        self.payCodePinEdit_:setPlaceHolder("")
        self.payCodePinEdit_:setPlaceholderFont(ui.DEFAULT_TTF_FONT, editNorTextFontSize)
        self.payCodePinEdit_:setPlaceholderFontColor(editNorTextColor)

        self.payCodePinEdit_:setMaxLength(cardInfoNameMaxLenght)
        self.payCodePinEdit_:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        self.payCodePinEdit_:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
        self.payCodePinEdit_:setInputFlag(cc.EDITBOX_INPUT_FLAG_SENSITIVE)

        self.payCodePinEdit_:hide()

        nk.EditBoxManager:addEditBox(self.payCodePinEdit_, 1)
    end

    if not self.payCodeSubmitBtn_ then
        --todo
        local submitBtnSize = {
            width = 134,
            height = 44
        }

        local submitBtnMagrinRight = 8

        local btnLblFontSize = 28
        local btnLblColor = display.COLOR_WHITE

        self.payCodeSubmitBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnGreenRigOutl.png", pressed = "#common_btnGreenRigOutl.png", disabled = "#common_btnGreyLitRigOut.png"},
            {scale9 = true})
            :setButtonSize(submitBtnSize.width, submitBtnSize.height)
            :setButtonLabel(display.newTTFLabel({text = "TOP UP", size = btnLblFontSize, color = btnLblColor, align = ui.TEXT_ALIGN_CENTER}))
            :onButtonClicked(buttontHandler(self, self.onPayCodeSubmitBtnCallBack_))
            :pos(pageContAreaWidth / 2 - submitBtnMagrinRight - submitBtnSize.width / 2, pageContAreaHeight / 2 - cardInfoEditBlkMagrinTop - submitBtnSize.height / 2)
            :addTo(self.prdPayCodeInputBlkNode_)
            :hide()
    end

    self.payCodeNoEdit_:hide()
    self.payCodePinEdit_:hide()
    self.payCodeSubmitBtn_:hide()

    self.controller_:prepareEditBox(self.payTypeSel_, self.payCodeNoEdit_, self.payCodePinEdit_, self.payCodeSubmitBtn_)

    local submitBtnMagrinRight = 8

    local payCodeInputBlkHeight = 0
    if self.payTypeSel_.inputType == "singleLine" then
        --todo
        payCodeInputBlkHeight = cardInfoEditBlkMagrinTop * 2 + payCodeNoEditBlkSize.height

        local submitBtnSize = {
            width = 134,
            height = 44
        }

        self.payCodeSubmitBtn_:setButtonSize(submitBtnSize.width, submitBtnSize.height)
        self.payCodeSubmitBtn_:pos(pageContAreaWidth / 2 - submitBtnMagrinRight - submitBtnSize.width / 2, pageContAreaHeight / 2 - cardInfoEditBlkMagrinTop -
            submitBtnSize.height / 2)

        self.payCodeNoEdit_:show()
        self.payCodePinEdit_:hide()
        self.payCodeSubmitBtn_:show()
    elseif self.payTypeSel_.inputType == "twoLine" then
        --todo
        payCodeInputBlkHeight = cardInfoEditBlkMagrinTop * 2 + payCodeNoEditBlkSize.height * 2 + cardInfoEditBlkMagrinEachVect

        local payCodeSubmitBtnSize = {
            width = 134,
            height = payCodeNoEditBlkSize.height * 2 + cardInfoEditBlkMagrinEachVect
        }

        self.payCodeSubmitBtn_:setButtonSize(payCodeSubmitBtnSize.width, payCodeSubmitBtnSize.height)
        self.payCodeSubmitBtn_:pos(pageContAreaWidth / 2 - submitBtnMagrinRight - submitBtnSize.width / 2, pageContAreaHeight / 2 - cardInfoEditBlkMagrinTop -
            payCodeSubmitBtnSize.height / 2)

        self.payCodeNoEdit_:show()
        self.payCodePinEdit_:show()
        self.payCodeSubmitBtn_:show()
    elseif self.payTypeSel_.inputType == "noLine" then
        --todo
        local submitBtnSize = {
            width = 134,
            height = 44
        }

        self.payCodeSubmitBtn_:setButtonSize(submitBtnSize.width, submitBtnSize.height)
        self.payCodeSubmitBtn_:pos(pageContAreaWidth / 2 - submitBtnMagrinRight - submitBtnSize.width / 2, pageContAreaHeight / 2 - cardInfoEditBlkMagrinTop -
            submitBtnSize.height / 2)

        self.payCodeNoEdit_:hide()
        self.payCodePinEdit_:hide()
        self.payCodeSubmitBtn_:hide()
    end

    local prdWareListViewSize = {
        width = pageContAreaWidth,
        height = pageContAreaHeight - payCodeInputBlkHeight
    }

    if self.prdChipListView_ then
        --todo
        self.prdChipListView_:setViewRect(cc.rect(- prdWareListViewSize.width / 2, - prdWareListViewSize.height / 2, prdWareListViewSize.width, prdWareListViewSize.height))
        self.prdChipListView_:pos(0, - payCodeInputBlkHeight / 2)
    end

    if self.prdCashListView_ then
        --todo
        self.prdCashListView_:setViewRect(cc.rect(- prdWareListViewSize.width / 2, - prdWareListViewSize.height / 2, prdWareListViewSize.width, prdWareListViewSize.height))
        self.prdCashListView_:pos(0, - payCodeInputBlkHeight / 2)
    end

end

function StorePopup:setStoreReqPayConfL1DataLoading(state)
    -- body
    if state then
        --todo
        if not self.reqDataLoadingBar_ then
            --todo
            self.reqDataLoadingBar_ = nk.ui.Juhua.new()
                :addTo(self)
        end
    else
        if self.reqDataLoadingBar_ then
            --todo
            self.reqDataLoadingBar_:removeFromParent()
            self.reqDataLoadingBar_ = nil
        end
    end
end

function StorePopup:setStoreReqPrdDataLoading(state)
    -- body
    if state then
        --todo
        if not self.reqDataLoadingBar_ then
            --todo
            self.reqDataLoadingBar_ = nk.ui.Juhua.new()
                :addTo(self.utilPayTypePrdContNode_)
        end
    else
        if self.reqDataLoadingBar_ then
            --todo
            self.reqDataLoadingBar_:removeFromParent()
            self.reqDataLoadingBar_ = nil
        end
    end
end

function StorePopup:onTopTabBtnSelChanged_(evt)
    -- body
    if not self.topTabSelIdx_ then
        --todo
        self.topTabSelIdx_ = evt.selected
        self.topTabBtns_[self.topTabSelIdx_].label_:setSpriteFrame("store_dscTopTabTi" .. self.topTabSelIdx_ .. "_sel.png")
        self.topTabBtns_[self.topTabSelIdx_].imgSel_:show()
    end

    local isChanged = self.topTabSelIdx_ ~= evt.selected

    if isChanged then
        --todo
        self.topTabBtns_[self.topTabSelIdx_].label_:setSpriteFrame("store_dscTopTabTi" .. self.topTabSelIdx_ .. "_unSel.png")
        self.topTabBtns_[self.topTabSelIdx_].imgSel_:hide()

        self.topTabBtns_[evt.selected].label_:setSpriteFrame("store_dscTopTabTi" .. evt.selected .. "_sel.png")
        self.topTabBtns_[evt.selected].imgSel_:show()

        self.topTabSelIdx_ = evt.selected
    end

    if self.topTabSelIdx_ == 3 then
        --todo
        if self.isMultiPayType_ then
            --todo
            self.leftOprPanelContNode_:hide()
        end

        if self.prdPayCodeInputBlkNode_ then
            --todo
            self.prdPayCodeInputBlkNode_:hide()
        end
    else
        if self.isMultiPayType_ then
            --todo
            self.leftOprPanelContNode_:show()
        end
    end

    self:renderStoreContPageViews(self.topTabSelIdx_)

    self:getPagePrdInfoData()
end

function StorePopup:onLeftPayTypeBtnSelChanged_(evt)
    -- body
    self.payTypeSel_ = self.availType_[evt.selected]

    if self.leftPayTypeInit_ then
        --todo
        self.leftPayTypeInit_ = false
    else
        self:getPagePrdInfoData()
    end
end

function StorePopup:onPrdEvtCallBack_(evt)
    -- body
    if evt.type == "MAKE_PURCHASE" then
        --todo
        self.controller_:makePurchase(self.payTypeSel_, evt.pid, evt.goodData)
    end
end

function StorePopup:onPayCodeSubmitBtnCallBack_(evt)
    -- body
    self.controller_:onInputCardInfo(self.payTypeSel_, self.prdTypeSel_, self.payCodeNoEdit_, self.payCodePinEdit_, self.payCodeSubmitBtn_)
end

function StorePopup:getPagePrdInfoData()
    -- body
    local getStorePagePrdDataByIdx = {
        [1] = function()
            -- body
            self.controller_:loadChipProductList(self.payTypeSel_)
        end,

        [2] = function()
            -- body
            self.controller_:loadCashProductList(self.payTypeSel_)
        end,

        [3] = function()
            -- body
            self.controller_:loadUsrHistryPaymentData()
        end
    }

    self:setStoreReqPrdDataLoading(true)  -- Add LoadingBar In Front Data Loading,Req Data Async When Init, Sync In Later Time.
    getStorePagePrdDataByIdx[self.topTabSelIdx_]()
end

function StorePopup:onStorePrdChipDataGet(payType, isComplete, data)
    -- body
    -- dump(payType, "StorePopup:onStorePrdChipDataGet.payType :=====================")
    -- log("StorePopup:onStorePrdChipDataGet.isComplete :" .. tostring(isComplete))
    -- dump(data, "StorePopup:onStorePrdChipDataGet.data :==================")

    self:showPrdPayCodeInputBlkIf("chips")
    if payType.id == self.payTypeSel_.id then
        --todo
        if self.topTabSelIdx_ ~= 1 then
            --todo
            return
        end

        if isComplete then
            --todo
            self:setStoreReqPrdDataLoading(false)
            if data then
                --todo
                if type(data) == "string" then
                    --todo
                    self.prdChipListView_:setData(nil)

                    self.prdChipWareListTip_:setString(data)
                    self.prdChipWareListTip_:show()
                else
                    if self.prdChipListData_ then
                        --todo
                        self.prdChipListData_ = nil
                        self.prdChipListView_:setData(nil)
                    end
                    self.prdChipListData_ = data

                    self.prdChipWareListTip_:hide()
                    self.prdChipListView_:setData(self.prdChipListData_)
                end
            else
                self.prdChipListView_:setData(nil)

                self.prdChipWareListTip_:setString("暂无商品")
                self.prdChipWareListTip_:show()
            end
        else
            self.prdChipWareListTip_:hide()
            self.prdChipListView_:setData(nil)

            self:setStoreReqPrdDataLoading(true)
        end
    end
end

function StorePopup:onStorePrdCashDataGet(payType, isComplete, data)
    -- body
    -- dump(payType, "StorePopup:onStorePrdCashDataGet.payType :=====================")
    -- log("StorePopup:onStorePrdCashDataGet.isComplete :" .. tostring(isComplete))
    -- dump(data, "StorePopup:onStorePrdCashDataGet.data :==================")

    self:showPrdPayCodeInputBlkIf("cash")
    if payType.id == self.payTypeSel_.id then
        --todo
        if self.topTabSelIdx_ ~= 2 then
            --todo
            return
        end

        if isComplete then
            --todo
            self:setStoreReqPrdDataLoading(false)
            if data then
                --todo
                if type(data) == "string" then
                    --todo
                    self.prdCashListView_:setData(nil)

                    self.prdCashWareListTip_:setString(data)
                    self.prdCashWareListTip_:show()
                else
                    if self.prdCashListData_ then
                        --todo
                        self.prdCashListData_ = nil
                        self.prdCashListView_:setData(nil)
                    end
                    self.prdCashListData_ = data

                    self.prdCashWareListTip_:hide()
                    self.prdCashListView_:setData(data)
                end
            else
                self.prdCashListView_:setData(nil)

                self.prdCashWareListTip_:setString("暂无商品")
                self.prdCashWareListTip_:show()
            end
        else
            self.prdCashWareListTip_:hide()
            self.prdCashListView_:setData(nil)

            self:setStoreReqPrdDataLoading(true)
        end
    end
end

function StorePopup:onUsrHistryDataGet(data)
    -- body
    self:setStoreReqPrdDataLoading(false)

    if data and #data > 0 then
        --todo
        if self.usrHistryListData_ then
            --todo
            self.usrHistryListData_ = nil
            self.usrPaymentHistryListView_:setData(nil)
        end
        self.usrHistryListData_ = data

        self.paymentHistryListTip_:hide()
        self.usrPaymentHistryListView_:setData(self.usrHistryListData_)
    else
        self.paymentHistryListTip_:setString("暂无购买记录")
        self.paymentHistryListTip_:show()
        self.usrPaymentHistryListView_:setData(nil)
    end
end

function StorePopup:onUsrHistryDataWrong()
    -- body
    self:setStoreReqPrdDataLoading(false)

    self.paymentHistryListTip_:setString("网络错误,拉取订单记录失败！")
    self.paymentHistryListTip_:show()
    self.usrPaymentHistryListView_:setData(nil)
end

function StorePopup:showPanel()
    self:showPanel_()
end

function StorePopup:onShowed()
    if self.prdChipListView_ then
        --todo
        self.prdChipListView_:update()
    end

    if self.prdCashListView_ then
        --todo
        self.prdCashListView_:update()
    end

    if self.usrPaymentHistryListView_ then
        --todo
        self.usrPaymentHistryListView_:update()
    end

    if self.leftOprPayTypeScrollview_ then
        --todo
        self.leftOprPayTypeScrollview_:update()
    end
end

function StorePopup:hidePanel()
    -- body
    self:hidePanel_()
end

function StorePopup:onEnter()
    -- body
end

function StorePopup:onExit()
    -- body
    self.controller_:dispose()

    if self.payCodeNoEdit_ then
        --todo
        nk.EditBoxManager:removeEditBox(self.payCodeNoEdit_)
    end
    
    if self.payCodePinEdit_ then
        --todo
        nk.EditBoxManager:removeEditBox(self.payCodePinEdit_)
    end
end

function StorePopup:onCleanup()
    -- body
    display.removeSpriteFramesWithFile("store.plist", "store.png")

    nk.schedulerPool:delayCall(function()
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    end, 0.1)
end

return StorePopup
