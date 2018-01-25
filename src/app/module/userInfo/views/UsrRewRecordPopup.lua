--
-- Author: thinkeras3@163.com
-- Date: 2015-10-26 10:0:39
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: UsrRewRecordPopup.lua Created && Reconstructed By Tsing7x.
--

local UsrRewRecordListItem = import(".UsrRewRecordListItem")

local UsrRewRecordPopup = class("UsrRewRecordPopup", function()
    return display.newNode()
end)

--[[ @pram :recListPos recListPanel Pos Type(table) recListPos.x, recListPos.y
    rewType :rewardType Type(number) 1.type Medal, 2.type Cup
]]--
function UsrRewRecordPopup:ctor(recListPos, rewType)
    self:setNodeEventEnabled(true)

    self.rewType_ = rewType or 1

    self.background_ = display.newScale9Sprite("#common_modTransparent.png", 0, 0, cc.size(display.width, display.height))
        :addTo(self)

    self.background_:setTouchEnabled(true)
    self.background_:setTouchSwallowEnabled(true)

    self.background_:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onBackgourndTouch_))

    local recPanelPos = recListPos or {x = 0, y = 0}

    local labelParam = {
        fontSize = 0,
        color = display.COLOR_BLACK
    }

    local recListBgPanelSize = {
        width = 574,
        height = 380
    }

    local panelStencil = {
        x = 10,
        y = 10,
        width = 42,
        height = 66
    }

    local recListBgPanel = display.newScale9Sprite("#common_bgPanel.png", display.width / 2 + recPanelPos.x, display.height / 2 + recPanelPos.y, cc.size(recListBgPanelSize.width,
        recListBgPanelSize.height), cc.rect(panelStencil.x, panelStencil.y, panelStencil.width, panelStencil.height))
        :addTo(self.background_)

    recListBgPanel:setTouchEnabled(true)
    recListBgPanel:setTouchSwallowEnabled(true)

    local decHiliBorScaleInWH = 0.6
    local decHiliBorder = display.newScale9Sprite("#common_decPanelHiliBor.png")
    local decHiliBorSizaCal = decHiliBorder:getContentSize()

    local decHiliDot = display.newSprite("#common_decPanelLiDot.png")

    local decBorRoundEdgeDistance = 5
    local decBorRoundEdgeHorizFix = 4

    local decDotBorTopDisFix = 2

    -- Dec Top --
    local decHiliBorTop = decHiliBorder:clone()
    decHiliBorTop:setContentSize(recListBgPanelSize.width * decHiliBorScaleInWH, decHiliBorSizaCal.height)
    decHiliBorTop:pos(recListBgPanelSize.width / 2, recListBgPanelSize.height - decHiliBorSizaCal.height / 2 - decBorRoundEdgeDistance)
        :addTo(recListBgPanel)

    decHiliDot:pos(recListBgPanelSize.width / 6, recListBgPanelSize.height - decBorRoundEdgeDistance - decDotBorTopDisFix)
        :addTo(recListBgPanel)

    -- Dec Bottom --
    local decHiliBorBottom = decHiliBorder:clone()
    decHiliBorBottom:setContentSize(recListBgPanelSize.width * decHiliBorScaleInWH, decHiliBorSizaCal.height)
    decHiliBorBottom:pos(recListBgPanelSize.width / 2, decHiliBorSizaCal.height / 2 + decBorRoundEdgeDistance)
        :addTo(recListBgPanel)

    local decHiliDotBotttom = decHiliDot:clone()
    decHiliDotBotttom:pos(recListBgPanelSize.width * 4 / 5, decBorRoundEdgeDistance)
        :addTo(recListBgPanel)

    -- Dec Left --
    local decHiliBorLeft = decHiliBorder:clone()
    decHiliBorLeft:setContentSize(recListBgPanelSize.height * decHiliBorScaleInWH, decHiliBorSizaCal.height)
    decHiliBorLeft:rotation(90)
    decHiliBorLeft:pos(decBorRoundEdgeDistance + decBorRoundEdgeHorizFix, recListBgPanelSize.height * 2 / 5)
        :addTo(recListBgPanel)

    -- Dec Right --
    local decHiliBorRight = decHiliBorder:clone()
    decHiliBorRight:setContentSize(recListBgPanelSize.height * decHiliBorScaleInWH, decHiliBorSizaCal.height)
    decHiliBorRight:rotation(270)
    decHiliBorRight:pos(recListBgPanelSize.width - decBorRoundEdgeDistance - decBorRoundEdgeHorizFix, recListBgPanelSize.height * 2 / 5)
        :addTo(recListBgPanel)

    self.recListViewDisplayNode_ = display.newNode()
        :pos(recPanelPos.x, recPanelPos.y)
        :addTo(self)

    local recListViewSizeMagrins = {
        horiz = 8,
        vect = 12
    }

    local recListViewSize = {
        width = recListBgPanelSize.width - recListViewSizeMagrins.horiz * 2,
        height = recListBgPanelSize.height - recListViewSizeMagrins.vect * 2
    }

    self.honRewRecListView_ = bm.ui.ListView.new({viewRect = cc.rect(- recListViewSize.width / 2, - recListViewSize.height / 2, recListViewSize.width, recListViewSize.height),
        direction = bm.ui.ListView.DIRECTION_VERTICAL}, UsrRewRecordListItem)
        :addTo(self.recListViewDisplayNode_)

    -- self.honRewRecListView_:setData({1, 2, 3, 4, 5})
    -- self.honRewRecListView_:setNotHide(true)

    labelParam.fontSize = 28
    labelParam.color = display.COLOR_RED
    self.noRecTip_ = display.newTTFLabel({text = "暂无获奖记录", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
        :addTo(self.recListViewDisplayNode_)
        :hide()

    self:getUsrRewRecData()
    self:setReqRecListDataLoading(true)
end

function UsrRewRecordPopup:setReqRecListDataLoading(loading)
    if loading then
        if not self.reqDataLoadingBar_ then
            self.reqDataLoadingBar_ = nk.ui.Juhua.new()
                :addTo(self.recListViewDisplayNode_)
        end
    else
        if self.reqDataLoadingBar_ then
            self.reqDataLoadingBar_:removeFromParent()
            self.reqDataLoadingBar_ = nil
        end
    end
end

function UsrRewRecordPopup:onBackgourndTouch_(evt)
    -- body
    self:removeFromParent()
end

function UsrRewRecordPopup:getUsrRewRecData()
    -- body
    -- self.rewType_

    self.reqGetUsrMatchRewRecId_ = nk.http.getMatchRecord(function(retData)
        -- dump(retData, "nk.http.getMatchRecord.retData :======================")
        self:setReqRecListDataLoading(false)

        if retData and #retData > 0 then
            --todo
            self.honRewRecListView_:setData(retData)
            self.noRecTip_:hide()
        else
            self.honRewRecListView_:setData(nil)
            self.noRecTip_:show()
        end

    end, function(errData)
        self.reqGetUsrMatchRewRecId_ = nil
        dump(errData, "nk.http.getMatchRecord.errData :======================")
        self:setReqRecListDataLoading(false)
        self.noRecTip_:show()

        nk.TopTipManager:showTopTip(bm.LangUtil.getText("COMMON", "REQUEST_DATA_FAIL"))
    end)
end

function UsrRewRecordPopup:showPanel()
    self:pos(display.cx, display.cy)
        :addTo(nk.runningScene, 999)

    bm.EventCenter:dispatchEvent(nk.eventNames.DISENABLED_EDITBOX_TOUCH)
end

function UsrRewRecordPopup:onEnter()
    -- body
end

function UsrRewRecordPopup:onExit()
    -- body
    bm.EventCenter:dispatchEvent(nk.eventNames.ENABLED_EDITBOX_TOUCH)

    if self.reqGetUsrMatchRewRecId_ then
        --todo
        nk.http.cancel(self.reqGetUsrMatchRewRecId_)
    end
end

function UsrRewRecordPopup:onCleanup()
    -- body
end

return UsrRewRecordPopup	