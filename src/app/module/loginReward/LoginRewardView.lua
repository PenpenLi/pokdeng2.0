--
-- Author: shanks
-- Date: 2014.09.03
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: LoginRewardView.lua Reconstructed By Tsing7x.
--

local SignInContPopup = import("app.module.signIn.SignInContPopup")
local CommonRewardChipAnimation = import("app.login.CommonRewardChipAnimation")

local PANEL_WIDTH = 822
local PANEL_HEIGHT = 422

local LoginRewardView = class("LoginRewardView", nk.ui.Panel)

local logger = bm.Logger.new("LoginRewardView")

function LoginRewardView:ctor()
    self:setNodeEventEnabled(true)
    self.super.ctor(self, {PANEL_WIDTH, PANEL_HEIGHT})

    self:addDecInnerTop()
    self:addDecInnerBottom()

    local titleBgPosYFix = 15

    local titleBg = display.newSprite("#logRew_decTitle.png")
        :pos(0, PANEL_HEIGHT / 2 + titleBgPosYFix)
        :addTo(self)
    local titleBgSizeCal = titleBg:getContentSize()

    local titleDescPosYFix = 26
    local titleDesc = display.newSprite("#logRew_descTitle.png")
        :pos(titleBgSizeCal.width / 2, titleBgSizeCal.height / 2 - titleDescPosYFix)
        :addTo(titleBg)

    local labelParam = {
        fontSize = 0,
        color = display.COLOR_WHITE
    }

    labelParam.fontSize = 18
    labelParam.color = display.COLOR_WHITE

    local rewardDescLblTopMagrinTop = - 2

    local rewardTodayDescLbl = display.newTTFLabel({text = "今天可领取" .. (nk.userData.loginReward.addMoney or 0) .. "筹码,(FB用户每日可额外获得" .. 100000 ..
        "筹码)", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    rewardTodayDescLbl:pos(0, titleBg:getPositionY() - titleBgSizeCal.height / 2 - rewardDescLblTopMagrinTop - rewardTodayDescLbl:getContentSize().height / 2)
        :addTo(self)

    local rewardDayNum = 6
    local rewardChipsGapEachHoriz = - 8

    local daySerialStr = {
        "一",
        "二",
        "三",
        "四",
        "五",
        "六"
    }

    local rewardChipModel = display.newSprite("#logRew_bgItemUnAchv.png")

    local rewardChip = nil
    local rewardImg = nil
    local rewardDaySeqLbl = nil
    local rewardDescLbl = nil
    local rewardShd = nil

    local rewardChipModelSizeCal = rewardChipModel:getContentSize()

    local rewardChipPosYAdj = 15
    local rewardDaySeqLblMagrinTop = 12
    local rewardDescLblMagrinBot = 10
    local rewardShdPosYFix = 2

    for i = 1, rewardDayNum do
        rewardChip = rewardChipModel:clone()
            :pos((rewardChipModelSizeCal.width + rewardChipsGapEachHoriz) * (i * 2 - 7) / 2, rewardChipPosYAdj)
            :addTo(self)

        labelParam.fontSize = 22
        labelParam.color = display.COLOR_WHITE

        rewardDaySeqLbl = display.newTTFLabel({text = "第" .. daySerialStr[i] .. "天", size = labelParam.fontSize, color = labelParam.color, align =
            ui.TEXT_ALIGN_CENTER})
        rewardDaySeqLbl:pos(rewardChipModelSizeCal.width / 2, rewardChipModelSizeCal.height - rewardDaySeqLblMagrinTop - rewardDaySeqLbl:getContentSize().height / 2)
            :addTo(rewardChip)

        labelParam.fontSize = 18
        labelParam.color = display.COLOR_WHITE

        rewardDescLbl = display.newTTFLabel({text = "筹码" .. (nk.userData.loginReward.days[i] or 0), size = labelParam.fontSize, color = labelParam.color,
            align = ui.TEXT_ALIGN_CENTER})
        rewardDescLbl:pos(rewardChipModelSizeCal.width / 2, rewardDescLblMagrinBot + rewardDescLbl:getContentSize().height / 2)
            :addTo(rewardChip)

        rewardImg = display.newSprite("#logRew_rewChipsDay_" .. i .. ".png")
            :pos(rewardChipModelSizeCal.width / 2, rewardChipModelSizeCal.height / 2)
            :addTo(rewardChip)

        if i < checkint(nk.userData.loginReward.day) then
            --todo
            rewardShd = display.newSprite("#logRew_shdAchved.png")
                :pos(rewardChipModelSizeCal.width / 2, rewardChipModelSizeCal.height / 2 + rewardShdPosYFix)
                :addTo(rewardChip)
        elseif i == nk.userData.loginReward.day then
            --todo
            local rewardDescLblColorHili = display.COLOR_RED

            rewardDescLbl:setTextColor(rewardDescLblColorHili)

            -- Add TodayReward Unget Shade --
            rewardShd = display.newSprite("#logRew_shdToday.png")
                :pos(rewardChipModelSizeCal.width / 2, rewardChipModelSizeCal.height / 2 + rewardShdPosYFix)
                :addTo(rewardChip)
        end
    end

    local rewardTipsLblBotPaddingBot = 98

    labelParam.fontSize = 18
    labelParam.color = display.COLOR_WHITE

    local rewardTipsBot = display.newTTFLabel({text = bm.LangUtil.getText("LOGINREWARD", "PROMPT", nk.userData.loginReward.days[6]), size = labelParam.fontSize, color =
        labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    rewardTipsBot:pos(0, - PANEL_HEIGHT / 2 + rewardTipsLblBotPaddingBot + rewardTipsBot:getContentSize().height / 2)
        :addTo(self)

    labelParam.fontSize = 30
    labelParam.color = display.COLOR_WHITE

    local botBtnSize = {
        width = 180,
        height = 60
    }

    local botBtnGapDistance = 142
    local botBtnMagrinBot = 25

    self.confirmBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnGreenRigOutl.png", pressed = "#common_btnGreenRigOutl.png", disabled = "#common_btnGreyLitRigOut.png"},
        {scale9 = true})
        :setButtonSize(botBtnSize.width, botBtnSize.height)
        :setButtonLabel(display.newTTFLabel({text = "确定", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked(buttontHandler(self, self.onConfrimBtnCallBack_))
        :pos(- botBtnGapDistance / 2 - botBtnSize.width / 2, - PANEL_HEIGHT / 2 + botBtnMagrinBot + botBtnSize.height / 2)
        :addTo(self)

    self.signInBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnYellowRigOutl.png", pressed = "#common_btnYellowRigOutl.png", disabled = "#common_btnGreyLitRigOut.png"},
        {scale9 = true})
        :setButtonSize(botBtnSize.width, botBtnSize.height)
        :setButtonLabel(display.newTTFLabel({text = "签到", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked(buttontHandler(self, self.onSignInBtnCallBack_))
        :pos(botBtnGapDistance / 2 + botBtnSize.width / 2, - PANEL_HEIGHT / 2 + botBtnMagrinBot + botBtnSize.height / 2)
        :addTo(self)

    self:addCloseBtn()

    self.canClose = true
    -- self:playRewardAnim()
end

function LoginRewardView:playRewardAnim()
    if nk.userData.loginReward.ret == 1 then
        nk.userData.loginReward.ret = -1

        -- Already Get Reward, Modify To Unget State.
        -- nk.userData["aUser.money"] = nk.userData["aUser.money"] - checkint(nk.userData.loginReward.addMoney)

        self:performWithDelay(function()
            self.canClose = true 
            nk.userData["aUser.money"] = nk.userData["aUser.money"] + checkint(nk.userData.loginReward.addMoney or 0)
        end, 1.5)

        self.animation_ = CommonRewardChipAnimation.new()
            :addTo(self)

        self.changeChipAnim_ = nk.ui.ChangeChipAnim.new(checkint(nk.userData.loginReward.addMoney))
            :addTo(self)
    end
end

function LoginRewardView:onShareCalled()
end

function LoginRewardView:onConfrimBtnCallBack_(evt)
    -- body
    if self.canClose then
        --todo
        self:hidePanel_()
    end
end

function LoginRewardView:onSignInBtnCallBack_(evt)
    -- body
    SignInContPopup.new():show()

    if self.canClose then
        --todo
        self:hidePanel_()
    end
end

function LoginRewardView:showPanel(callback)
    -- body
    self.closeCallback_ = callback
    
    self:showPanel_()
end

function LoginRewardView:onRemovePopup(removeFunc)
    -- body
    if self.closeCallback_ then
        self.closeCallback_({action = "action_close"})
    end

    if self.canClose then
        removeFunc()
    end
end

function LoginRewardView:onEnter()
    -- body
end

function LoginRewardView:onExit()
    -- body
end

function LoginRewardView:onCleanup()
    -- body
    display.removeSpriteFramesWithFile("loginreward_texture.plist", "loginreward_texture.png")
end

return LoginRewardView