--
-- Author: viking@boomegg.com
-- Date: 2014-10-28 11:11:39
-- Copyright: Copyright (c) 2014, BOOMEGG INTERACTIVE CO., LTD All rights reserved.
-- Description: WheelPopup.lua Reconstructed By Tsing7x.
-- 

local WheelController = import(".WheelController")
local WheelView = import(".WheelView")
local WinResultPopup = import(".views.WheelWinResultPopup")

local WheelPopup = class("WheelPopup", function()
    return display.newNode()
end)

function WheelPopup:ctor()
    self:setNodeEventEnabled(true)
    self.controller_ = WheelController.new(self)

    display.addSpriteFrames("wheel_texture.plist", "wheel_texture.png", handler(self, self.onWheelTextureLoaded))
end

function WheelPopup:onWheelTextureLoaded(fileName, imgName)
    -- body
    self.background_ = display.newSprite("#wheel_bgMainPanel.png")
        :addTo(self)

    self.background_:setTouchEnabled(true)
    self.background_:setTouchSwallowEnabled(true)

    local bgContSize = self.background_:getContentSize()

    local wheelDecRibPosXFix = 20
    local wheelDecRib = display.newSprite("#wheel_decRib.png")
        :pos(wheelDecRibPosXFix, 0)
        :addTo(self)

    local wheelTitlePaddingTop = 52
    local wheelTitle = display.newSprite("#wheel_decDescTitle.png")
    wheelTitle:pos(bgContSize.width / 2, bgContSize.height - wheelTitlePaddingTop - wheelTitle:getContentSize().height / 2)
        :addTo(self.background_)

    local labelParam = {
        fontSize = 0,
        color = display.COLOR_WHITE
    }

    self.playTimesRemain_ = 0

    -- Default State: Times 0 Left --
    local titlePlayTimesPosXGapCnt = 40
    local titlePlayTimesPosYFixTitle = 10

    self.titlePlayTimesLeft_ = display.newSprite("#wheel_decTitleTime_0.png")
        :pos(bgContSize.width / 2 + titlePlayTimesPosXGapCnt, wheelTitle:getPositionY() + titlePlayTimesPosYFixTitle)
        :addTo(self.background_)

    local wheelViewPosYFix = 10

    self.wheelView_ = WheelView.new()
        :pos(0, - wheelViewPosYFix)
        :addTo(self)

    -- local wheelFanTopBorPosYFix = 22
    -- self.wheelFanTopHiliBor_ = display.newSprite("#wheel_decHiliBorRewFan.png")
    -- self.wheelFanTopHiliBor_:pos(0, self.wheelFanTopHiliBor_:getContentSize().height / 2 - wheelFanTopBorPosYFix)
    --     :addTo(self)
    --     :hide()

    self.playGameBtn_ = cc.ui.UIPushButton.new({normal = "#wheel_btnAtdAct_ready.png", pressed = "#wheel_btnAtdAct_ready.png", disabled =
        "#wheel_btnAtdAct_done.png"}, {scale9 = false})
        :onButtonClicked(buttontHandler(self, self.onPlayGameBtnCallBack_))
        :addTo(self)

    -- Default Btn State : Done. --
    self.playGameBtn_:setButtonEnabled(false)

    self.isCanPlayGame = false

    labelParam.fontSize = 30
    labelParam.color = display.COLOR_WHITE

    local timeCuntLblPosYFix = 10
    self.timeCuntDownTick_ = display.newTTFLabel({text = "00:00", size = labelParam.fontSize, color = labelParam.color, align =
        ui.TEXT_ALIGN_CENTER})
        :pos(0, - timeCuntLblPosYFix)
        :addTo(self)
        :hide()

    self.playTimeCunt_ = 0

    local closeBtnPosYFixBg6p7 = 6
    local wheelCloseBtn = cc.ui.UIPushButton.new({normal = "#common_btnPanelClose.png", pressed = "#common_btnPanelClose.png", disabled =
        "#common_btnPanelClose.png"}, {scale9 = false})
        :onButtonClicked(buttontHandler(self, self.onWheelCloseCallBack_))
        :pos(bgContSize.width, bgContSize.height * 6 / 7 - closeBtnPosYFixBg6p7)
        :addTo(self.background_)

    self:getConfig()
end

function WheelPopup:setLoading(isLoading)
    if isLoading then
        if not self.wheelLoadingBar_ then
            self.wheelLoadingBar_ = nk.ui.Juhua.new()
                :addTo(self)
                :scale(0.5)
        end
    else
        if self.wheelLoadingBar_ then
            self.wheelLoadingBar_:removeFromParent()
            self.wheelLoadingBar_ = nil
        end
    end
end

function WheelPopup:tickTimeCuntDown()
    -- body
    if checkint(self.playTimeCunt_) <= 0 then
        --todo
        self:stopAction(self.tickTimeDownAction_)
        self.tickTimeDownAction_ = nil

        -- self.timeCuntDownTick_:hide()
        -- self.playGameBtn_:setButtonImage("normal", "wheel_btnAtdAct_ready.png")
        -- self.playGameBtn_:setButtonImage("pressed", "wheel_btnAtdAct_ready.png")

        self:getPlayTimes()

        return
    end

    self.playTimeCunt_ = self.playTimeCunt_ - 1

    local time_str = bm.formatTimeStamp(1, self.playTimeCunt_)

    local minShown = nil
    local secShown = nil

    if time_str.min < 10 then
        --todo
        minShown = "0" .. time_str.min
    else
        minShown = tostring(time_str.min)
    end

    if time_str.sec < 10 then
        --todo
        secShown = "0" .. time_str.sec
    else
        secShown = tostring(time_str.sec)
    end

    self.timeCuntDownTick_:setString(minShown .. ":" .. secShown)
end

function WheelPopup:getConfig()
    self.controller_:getConfig(function(isSucc, data)
        if isSucc then
            -- Customize Data For Loacal Use,Modify To Field rewType Recognize --
            local rewImgKeys = {
                "wheel_decChipsLarge.png",
                "wheel_decChipsMid.png",
                "wheel_decChipsLess.png",
                "wheel_decChipsLess.png",
                "wheel_decChipsLess.png",
                "wheel_decChipsMid.png",
                "wheel_decProp.png",
                "wheel_decProp.png"
            }

            for i = 1, #data do
                local dataItem = data[i]
                dataItem.url = rewImgKeys[i]
            end

            self.wheelView_:setItemData(data)
        else
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("COMMON", "BAD_NETWORK"))
        end
    end)
end

function WheelPopup:getPlayTimes()
    self.playGameBtn_:setButtonEnabled(false)
    self.isCanPlayGame = false
    self:setLoading(true)

    self.controller_:getPlayTimes(function(isSucc, data)
        if isSucc then
            self:setLoading(false)

            self.playTimesRemain_ = data.num or 0
            self.titlePlayTimesLeft_:setSpriteFrame("wheel_decTitleTime_" .. self.playTimesRemain_ .. ".png")
            self.playGameBtn_:setButtonEnabled(true)

            if self.tickTimeDownAction_ then
                --todo
                self:stopAction(self.tickTimeDownAction_)
                self.tickTimeDownAction_ = nil
            end

            local nextRoundTime = data.diffToNextPan or 0

            if self.playTimesRemain_ > 0 then
                --todo
                if nextRoundTime > 0 then
                    --todo
                    -- Need To Wait For Next Round
                    self.playGameBtn_:setButtonImage("normal", "#wheel_btnAtdAct_wait.png")
                    self.playGameBtn_:setButtonImage("pressed", "#wheel_btnAtdAct_wait.png")

                    self.playTimeCunt_ = nextRoundTime

                    self.timeCuntDownTick_:show()

                    local time_str = bm.formatTimeStamp(1, self.playTimeCunt_)
                    local minShown = nil
                    local secShown = nil

                    if time_str.min < 10 then
                        --todo
                        minShown = "0" .. time_str.min
                    else
                        minShown = tostring(time_str.min)
                    end

                    if time_str.sec < 10 then
                        --todo
                        secShown = "0" .. time_str.sec
                    else
                        secShown = tostring(time_str.sec)
                    end

                    self.timeCuntDownTick_:setString(minShown .. ":" .. secShown)
                    self.tickTimeDownAction_ = self:schedule(handler(self, self.tickTimeCuntDown), 1)
                else
                    -- No Need To Wait
                    self.playTimeCunt_ = 0
                    self.timeCuntDownTick_:setString("00:00")
                    self.timeCuntDownTick_:hide()

                    self.playGameBtn_:setButtonImage("normal", "#wheel_btnAtdAct_ready.png")
                    self.playGameBtn_:setButtonImage("pressed", "#wheel_btnAtdAct_ready.png")

                    self.isCanPlayGame = true
                end
            else
                self.playTimeCunt_ = 0
                self.isCanPlayGame = false

                self.playGameBtn_:setButtonImage("normal", "#wheel_btnAtdAct_ready.png")
                self.playGameBtn_:setButtonImage("pressed", "#wheel_btnAtdAct_ready.png")

                self.timeCuntDownTick_:setString("00:00")
                self.timeCuntDownTick_:hide()
            end
        else
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("COMMON", "BAD_NETWORK"))
        end
    end)
end

function WheelPopup:playGameWheel()
    self.rewardData_ = nil

    self.controller_:playWheelGame(function(isSucc, data)
        if isSucc then
            self.rewardData_ = data

            self.wheelView_:setDestDegreeById(data.id)

            self.wheelView_:startRotation(function()
                -- self.wheelFanTopHiliBor_:show()

                local item = self.wheelView_:findItemById(data.id)
                local viewItem = self.wheelView_:findWheelViewById(data.id)
                if viewItem then
                    --todo
                    viewItem:setSelfRewardWoned(true)
                end
                
                local actionDelayTime = 2.5
                self:performWithDelay(function()
                    nk.SoundManager:playSound(nk.SoundManager.WHEEL_WIN)

                    -- self.wheelFanTopHiliBor_:hide()
                    if viewItem then
                        --todo
                        viewItem:setSelfRewardWoned(false)
                    end

                    WinResultPopup.new(item, self.controller_):showPanel()

                    if self and self.getPlayTimes then
                        --todo
                        self:getPlayTimes()
                    end
                end, actionDelayTime)

                nk.SoundManager:playSound(nk.SoundManager.WHEEL_END)

                if self and self.rewardData_ then
                    if self.rewardData_.money then
                        local addMoney = self.rewardData_.money.addMoney
                        local money = self.rewardData_.money.money
                        nk.userData["aUser.money"] = money
                    end

                    self.rewardData_ = nil
                end
            end)
        else
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("COMMON", "BAD_NETWORK"))

            if self.playTimesRemain_ > 0 then
                self.playGameBtn_:setButtonEnabled(true)
            end
        end
    end)
end

function WheelPopup:onWheelCloseCallBack_(evt)
    -- body
    self:hidePanel()
end

function WheelPopup:onPlayGameBtnCallBack_(evt)
    -- body
    local isGameLoadReady = self.controller_:isAllReady()

    if isGameLoadReady then
        --todo
        if self.playTimesRemain_ > 0 then
            --todo
            if self.isCanPlayGame then
                --todo
                self.playGameBtn_:setButtonEnabled(false)

                nk.SoundManager:playSound(nk.SoundManager.WHEEL_START)
                self:playGameWheel()
            else
                dump("Game State Waiting!")
            end
        else
            nk.CenterTipManager:showCenterTip(bm.LangUtil.getText("WHEEL", "STATUS2"))
        end
    else
        dump("Game State Not Ready,Please Wait For Ready.")
    end
end

function WheelPopup:onShareBtnCallBack_()
    nk.sendFeed:wheel_act_(function()
        self.controller_:shareToGetChance()  
    end, function()
    end)
end

function WheelPopup:showPanel()
    nk.PopupManager:addPopup(self)
    return self
end

function WheelPopup:onShowed()
    self:getPlayTimes()
end

function WheelPopup:hidePanel()
    nk.PopupManager:removePopup(self)
end

function WheelPopup:onEnter()
    -- body
end

function WheelPopup:onExit()
    -- body
    if self.tickTimeDownAction_ then
        --todo
        self:stopAction(self.tickTimeDownAction_)
        self.tickTimeDownAction_ = nil
    end

    if self.rewardData_ then
        if self.rewardData_.money then
            local addMoney = self.rewardData_.money.addMoney
            local money = self.rewardData_.money.money

            nk.userData["aUser.money"] = money
        end
        
        self.rewardData_ = nil
    end
                
    self.controller_:dispose()
end

function WheelPopup:onCleanup()
    display.removeSpriteFramesWithFile("wheel_texture.plist", "wheel_texture.png")

    nk.schedulerPool:delayCall(function()
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    end, 0.1)
end

return WheelPopup
