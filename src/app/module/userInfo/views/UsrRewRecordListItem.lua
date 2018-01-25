--
-- Author: thinkeras3@163.com
-- Date: 2015-10-27 10:0:39
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: UsrRewRecordListItem.lua Created && Reconstructed By Tsing7x.
--

local ITEMSIZE = nil

local UsrRewRecordListItem = class("UsrRewRecordListItem", bm.ui.ListItem)

function UsrRewRecordListItem:ctor()
    self:setNodeEventEnabled(true)

    local itemSizeMeas = {
        width = 552,
        height = 100
    }
	self.super.ctor(self, itemSizeMeas.width, itemSizeMeas.height)
    
    ITEMSIZE = cc.size(itemSizeMeas.width, itemSizeMeas.height)
    self.itemBg_ = display.newSprite("#usrInfo_bgUsrRewInfo.png")
        :pos(ITEMSIZE.width / 2, ITEMSIZE.height / 2)
        :addTo(self)

    local itemBgSizeCal = self.itemBg_:getContentSize()

    local labelParam = {
        fontSize = 0,
        color = display.COLOR_BLACK
    }

    local rewIconMagrinLeft = 20

    self.rewImgIc_ = display.newSprite("#usrInfo_icMedal_2.png")
    self.rewImgIc_:pos(rewIconMagrinLeft + self.rewImgIc_:getContentSize().width / 2, itemBgSizeCal.height / 2)
        :addTo(self.itemBg_)

    self.rewImgLoaderId_ = nk.ImageLoader:nextLoaderId()

    local rewInfoLblMagrinLeft = 16
    local rewInfoLblMagrinEachVect = 10

    labelParam.fontSize = 24
    labelParam.color = display.COLOR_WHITE
    self.rewInfoTime_ = display.newTTFLabel({text = "1970_01_01 08:00:00", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.rewInfoTime_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.rewInfoTime_:pos(self.rewImgIc_:getPositionX() + self.rewImgIc_:getContentSize().width / 2 + rewInfoLblMagrinLeft, itemBgSizeCal.height / 2 + rewInfoLblMagrinEachVect / 2 +
        self.rewInfoTime_:getContentSize().height / 2)
        :addTo(self.itemBg_)

    labelParam.fontSize = 20
    labelParam.color = display.COLOR_WHITE
    self.rewInfoDesc_ = display.newTTFLabel({text = "Rew Info Desc", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.rewInfoDesc_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.rewInfoDesc_:pos(self.rewInfoTime_:getPositionX(), itemBgSizeCal.height / 2 - rewInfoLblMagrinEachVect / 2 - self.rewInfoDesc_:getContentSize().height / 2)
        :addTo(self.itemBg_)

    local getRewBtnSize = {
        width = 96,
        height = 44
    }

    local getRewBtnMagrinRight = 18

    labelParam.fontSize = 20
    labelParam.color = display.COLOR_WHITE
    self.getRewBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnYellowRigOutl.png", pressed = "#common_btnYellowRigOutl.png", disabled = "#common_btnGreyLitRigOut.png"},
        {scale9 = true})
        :setButtonSize(getRewBtnSize.width, getRewBtnSize.height)
        :setButtonLabel(display.newTTFLabel({text = "领取奖励", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked(buttontHandler(self, self.onGetRewBtnCallBack_))
        :pos(itemBgSizeCal.width - getRewBtnMagrinRight - getRewBtnSize.width / 2, itemBgSizeCal.height / 2)
        :addTo(self.itemBg_)

    self.getRewBtn_:setTouchSwallowEnabled(false)
end

function UsrRewRecordListItem:onRewImgIcLoadComplete_(success, sprite)
    if success then
        local tex = sprite:getTexture()
        local texSize = tex:getContentSize()
        self.rewImgIc_:setTexture(tex)
        self.rewImgIc_:setTextureRect(cc.rect(0, 0, texSize.width, texSize.height))
    else
        self.rewImgLoaderId_ = nil
    end
end

function UsrRewRecordListItem:onDataSet(changed, data)
    -- body
    if changed then
        --todo
        self.rewInfoTime_:setString(data.time or "1970_01_01 08:00:00.")

        self.rewInfoDesc_:setString(nk.userData["aUser.name"] .. " 参加 " .. (data.idName or "game ihci") .. " 获得第 " .. (data.rank or 0) .. "名")
    
        if checkint(data.reward) == 0 then
            --todo
            self.getRewBtn_:setVisible(true)
        else
            self.getRewBtn_:setVisible(false)
        end

        if data.imgurl and string.len(data.imgurl) > 5 then
            --todo
            nk.ImageLoader:loadAndCacheImage(self.rewImgLoaderId_, data.imgurl, handler(self, self.onRewImgIcLoadComplete_), nk.ImageLoader.CACHE_TYPE_MATCH)
        end
    end
end

function UsrRewRecordListItem:onGetRewBtnCallBack_(evt)
    -- body
    self.getRewBtn_:setButtonEnabled(false)

    local param = {}
    param.matchid = self.data_.matchid
    param.uid = nk.userData["aUser.mid"]
    param.rank = self.data_.rank
    param.logid  = self.data_.logid

    self.reqGetMatchRewId_ = nk.http.matchGetReward(param, function(retData)
        -- body
        -- dump(retData, "nk.http.matchGetReward.retData :================")
        nk.userData["aUser.money"] = tonumber(retData.money or nk.userData["aUser.money"])
        nk.userData["match.highPoint"] = tonumber(retData.highPoint or nk.userData["match.highPoint"])
        nk.userData["match.point"] = tonumber(retData.point or nk.userData["match.point"])

        self.getRewBtn_:setButtonEnabled(true)
        self.getRewBtn_:setVisible(false)

        nk.TopTipManager:showTopTip(bm.LangUtil.getText("MATCH", "AWARD_SUCC"))
    end, function(errData)
        -- body
        dump(errData, "nk.http.matchGetReward.errData :====================")
        self.reqGetMatchRewId_ = nil

        nk.TopTipManager:showTopTip("领奖失败！")

        self.getRewBtn_:setButtonEnabled(true)
    end)
end

function UsrRewRecordListItem:onEnter()
    -- body
end

function UsrRewRecordListItem:onExit()
    -- body
    if self.reqGetMatchRewId_ then
        --todo
        nk.http.cancel(self.reqGetMatchRewId_)
    end

    if self.rewImgLoaderId_ then
        --todo
        nk.ImageLoader:cancelJobByLoaderId(self.rewImgLoaderId_)
    end
end

function UsrRewRecordListItem:onCleanup()
    -- body
end

return UsrRewRecordListItem