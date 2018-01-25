--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-04-25 10:48:08
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: NewerPlayRewardPopup.lua Reconstructed By Tsing7x.
--

local CommonRewardChipAnimation = import("app.login.CommonRewardChipAnimation")

local PANEL_WIDTH = 522
local PANEL_HEIGHT = 360

local NewerPlayRewardPopup = class("NewerPlayRewardPopup", nk.ui.Panel)

function NewerPlayRewardPopup:ctor(playData)
    self:setNodeEventEnabled(true)
    self.super.ctor(self, {PANEL_WIDTH, PANEL_HEIGHT})

    self.contData_ = playData
    -- display.addSpriteFrames("room_texture.plist", "room_texture.png", handler(self, self.renderMainCont))
    self:renderMainCont()
end

-- For Easy Test, Get Render Func For Views Render --
function NewerPlayRewardPopup:renderMainCont()
    -- body
    local titleDesc = display.newSprite("#nerPlyRew_decDescTitle.png")

    self:addPanelTitleBar(titleDesc)

    local decChipsImgMagrinBot = 0

    local decChipsImg = display.newSprite("#nerPlyRew_decIcChips.png")
    decChipsImg:pos(0, - PANEL_HEIGHT / 2 + decChipsImgMagrinBot + decChipsImg:getContentSize().height / 2)
        :addTo(self)

    local titleBarSize = self:getTitleBarSize()

    local labelParam = {
        fontSize = 0,
        color = display.COLOR_WHITE
    }

    local stage = self.contData_.contentFlag or 1

    local bgPanelBorWTop = 8
    local rewardTipsMagrinTop = 20
    local rewTipShownWidth = 402

    labelParam.fontSize = 25
    labelParam.color = display.COLOR_WHITE

    local rewTip = nil
    if stage == 1 then
        --todo
        rewTip = display.newTTFLabel({text = "恭喜您玩牌获得" .. checkint(self.contData_.addMoney or 0) .. "筹码,继续玩牌奖励更多,仅限今天哦！", size =
            labelParam.fontSize, color = labelParam.color, dimensions = cc.size(rewTipShownWidth, 0), align = ui.TEXT_ALIGN_CENTER})
        rewTip:pos(0, PANEL_HEIGHT / 2 - titleBarSize.height - rewardTipsMagrinTop - bgPanelBorWTop - rewTip:getContentSize().height / 2)
            :addTo(self)

        local rewGrantTipMagrinTop = 2

        local rewGrantTip = display.newTTFLabel({text = "(奖励已自动到账)", size = labelParam.fontSize, color = labelParam.color, align =
            ui.TEXT_ALIGN_CENTER})
        rewGrantTip:pos(0, rewTip:getPositionY() - rewTip:getContentSize().height / 2 - rewGrantTipMagrinTop - rewGrantTip:getContentSize().height / 2)
            :addTo(self)

    elseif stage == 2 then
        --todo
        rewTip = display.newTTFLabel({text = "恭喜您玩牌获得" .. checkint(self.contData_.addMoney or 0) .. "筹码,新手成长奖励已全部领完,明日登陆还可以直接领取"
            .. checkint(self.contData_.nextAddMoney or 0) .. ",不要错过哦！", size = labelParam.fontSize, color = labelParam.color, dimensions =
                cc.size(rewTipShownWidth, 0), align = ui.TEXT_ALIGN_CENTER})
        rewTip:pos(0, PANEL_HEIGHT / 2 - titleBarSize.height - rewardTipsMagrinTop - bgPanelBorWTop - rewTip:getContentSize().height / 2)
            :addTo(self)
    end

    local vanishTipMagrinBot = 20

    labelParam.fontSize = 24
    labelParam.color = display.COLOR_WHITE

    local vanishTip = display.newTTFLabel({text = "五秒后自动消失", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    vanishTip:pos(0, - PANEL_HEIGHT / 2 + vanishTipMagrinBot + vanishTip:getContentSize().height / 2)
        :addTo(self)

    self:addCloseBtn()
end

function NewerPlayRewardPopup:showPanel()
    self:showPanel_()
end

function NewerPlayRewardPopup:onShowed()
    if self.showData_ and self.showData_.isAnim and self.showData_.addMoney then
        self:playRewardAnim(self.showData_.addMoney)
    end

    local vanishTime = 5
    self:performWithDelay(function()
       self:hidePanel_()
    end, vanishTime)   
end

function NewerPlayRewardPopup:destoryAnim()
        if self.rewAnim_ then
            self.rewAnim_:removeFromParent()
            self.rewAnim_ = nil
        end

        if self.changeChipAnim_ then
            self.changeChipAnim_:removeFromParent()
            self.changeChipAnim_ = nil
        end
end

function NewerPlayRewardPopup:playRewardAnim(addMoney)
    if checkint(addMoney) == 0 then
        return
    end

    -- animDelayTime = 1.8
    -- self:performWithDelay(function()
    --     nk.userData["aUser.money"] = nk.userData["aUser.money"] + addMoney
    --     self:destoryAnim()
    -- end, animDelayTime)
    
    -- self.rewAnim_ = CommonRewardChipAnimation.new()
    --     :addTo(self)

    -- self.changeChipAnim_ = nk.ui.ChangeChipAnim.new(checkint(addMoney))
    --     :addTo(self)   
end

return NewerPlayRewardPopup