--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-04-21 12:27:10
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: RegisterAwardPopup.lua Reconstructed By Tsing7x.
--

local CommonRewardChipAnimation = import("app.login.CommonRewardChipAnimation")

local RegisterAwardPopup = class("RegisterAwardPopup", function()
	return display.newNode()
end)

--
-- @param :param 
-- param.rewardChipNum Day 1 Reward Chip Num
-- param.rewardNextNum Day 2 Reward Chip Num
-- param.rewardDayNum Day Seril Num
-- param.isNextRewTip Is The Next Reward Tip Popup
-- param.isPlayAnim Is Play Reward Anim
-- param.closeCallback Popup Close Callback
--
function RegisterAwardPopup:ctor(param)
    self:setNodeEventEnabled(true)

    self.chipAddNum_ = param.rewardChipNum or 100000
    self.isPlayRewardAnim_ = param.isPlayAnim
    self.closeCallBack_ = param.closeCallback

    self.regData_ = param
    display.addSpriteFrames("registerReward.plist", "registerReward.png", handler(self, self.onTextureLoaded))
end

function RegisterAwardPopup:onTextureLoaded(fileName, imgName)
    -- body

    local bgPanelModel = display.newSprite("#regRew_bgPanelMain.png")

    local bgPanelModelCalSize = bgPanelModel:getContentSize()

    self.background_ = display.newScale9Sprite("#regRew_bgPanelMain.png", 0, 0, cc.size(display.width, bgPanelModelCalSize.height))
        :addTo(self)

    local labelParam = {
        fontSize = 0,
        color = display.COLOR_WHITE
    }

    local titlePosAdj = {
        x = 15,
        y = 58
    }

    local regDay = self.regData_.rewardDayNum or 1
    local isRegRewNextTip = self.regData_.isNextRewTip

    if isRegRewNextTip then
        --todo
        regDay = 0
    end

    local titleImgKey = nil

    if regDay == 0 then
        --todo
        titleImgKey = "#regRew_decTipDescTit.png"
    else
        titleImgKey = "#regRew_decRewDescTiDay_" .. regDay .. ".png"
    end

    local rewardTitleDesc = display.newSprite(titleImgKey)
    rewardTitleDesc:pos(display.width / 2 + titlePosAdj.x, bgPanelModelCalSize.height - rewardTitleDesc:getContentSize().height / 2 -
        titlePosAdj.y)
        :addTo(self.background_)

    local rewardFrameBorMagrinBot = 100
    local rewardFrameBorMagrinRight = 350 * nk.widthScale

    local rewardShinyDent = display.newSprite("#regRew_decRewShiny.png")
    rewardShinyDent:pos(display.width - rewardFrameBorMagrinRight - rewardShinyDent:getContentSize().width / 2, rewardFrameBorMagrinBot +
        rewardShinyDent:getContentSize().height / 2)
        :addTo(self.background_)

    local rewardHiliBor = display.newSprite("#regRew_decBorRew.png")
        :pos(rewardShinyDent:getContentSize().width / 2, rewardShinyDent:getContentSize().height / 2)
        :addTo(rewardShinyDent)

    local rewardIcon = display.newSprite("#regRew_icRewChip.png")
        :pos(rewardShinyDent:getContentSize().width / 2, rewardShinyDent:getContentSize().height / 2)
        :addTo(rewardShinyDent)

    labelParam.fontSize = 18
    labelParam.color = display.COLOR_WHITE

    local rewardNextTipsMagrinBot = 98

    local rewardNextDayChipNum = self.regData_.rewardNextNum or 200000
    local rewardNextDayTip = display.newTTFLabel({text = "次日登陆还可以再获得" .. bm.formatBigNumber(rewardNextDayChipNum) .. "筹码,记得回来领取哦！",
        size = labelParam.fontSize, color = labelParam.color, aligm = ui.TEXT_ALIGN_CENTER})
    rewardNextDayTip:pos(rewardShinyDent:getPositionX(), rewardNextTipsMagrinBot + rewardNextDayTip:getContentSize().height / 2)
        :addTo(self.background_)

    local decPokerGirl = display.newSprite("#regRew_decPokerGirl.png")
    decPokerGirl:pos(decPokerGirl:getContentSize().width / 2, decPokerGirl:getContentSize().height / 2)
        :addTo(self.background_)

end

function RegisterAwardPopup:playRewardAnim(addMoney)
    if checkint(addMoney) <= 0 then
        return
    end
    
    -- self:performWithDelay(function()
    --     self:destoryAnim()
    -- end, 1.8)

    -- self.animation_ = CommonRewardChipAnimation.new()
    --     :addTo(self)
end

function RegisterAwardPopup:destoryAnim()
    if self.animation_ then
        self.animation_:removeFromParent()
        self.animation_ = nil
    end
end

function RegisterAwardPopup:showPanel()
    self:showPanel_()
end

function RegisterAwardPopup:showPanel_(isModal, isCentered, closeWhenTouchModel, useShowAnimation)
    nk.PopupManager:addPopup(self, isModal ~= false, isCentered ~= false, closeWhenTouchModel ~= false, useShowAnimation ~= false)
    return self
end

function RegisterAwardPopup:onShowed()
    if self.isPlayRewardAnim_ then
        self:playRewardAnim(self.chipAddNum_)
    end
end

function RegisterAwardPopup:hidePanel_()
    nk.PopupManager:removePopup(self)
    return self
end

function RegisterAwardPopup:onRemovePopup(removePopupFunc)
    if self.closeCallBack_ then
        self.closeCallBack_()
    end

    removePopupFunc()
end

function RegisterAwardPopup:onEnter()
    -- body
end

function RegisterAwardPopup:onExit()
    -- body
end

function RegisterAwardPopup:onCleanup()
    -- body
    display.removeSpriteFramesWithFile("registerReward.plist", "registerReward.png")

    nk.schedulerPool:delayCall(function()
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    end, 0.1)
end

return RegisterAwardPopup