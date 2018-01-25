--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-03-27 17:12:32
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: UpdateView.lua Reconstructed By Tsing7x.
--

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local upd = import(".init")

local PROBAR_WIDTH = 368
local PROBAR_HEIGHT = 17

local UpdateView = class("UpdateView", function ()
    return display.newNode()
end)

function UpdateView:ctor(controller, scaleNum)
    self:setNodeEventEnabled(true)

    self.controller_ = controller
    self.bgScale_ = scaleNum or 1

    local updateMainBg = display.newSprite("login_main_bg.png")
        :scale(self.bgScale_)
        :addTo(self, 0)

    -- display.addSpriteFrames("login_th.plist", "login_th.png", function(fileName, imgName)
    --     -- body
    --     display.addSpriteFrames("update_texture.plist", "update_texture.png", handler(self, self.onLoginTextureLoaded))
    -- end)

    display.addSpriteFrames("login_th.plist", "login_th.png")
    display.addSpriteFrames("update_texture.plist", "update_texture.png")
    self:onLoginTextureLoaded()
end

-- Render Main UI UpdateView 2.0 --
function UpdateView:onLoginTextureLoaded(fileName, imgName)
    -- body

    self.updatePanelNode_ = display.newNode()
        :addTo(self)

    local updatePanel = display.newSprite("#login_bg_table.png")
        :scale(self.bgScale_)

    local updatePanelSize = updatePanel:getContentSize()
    updatePanel:pos(display.cx - updatePanelSize.width / 2, 0)
        :addTo(self.updatePanelNode_)

    local gameLogoDecPosYAdj = 64
    local gameLogoDecMagrinRight = 20

    local gameLogoDec = display.newSprite("#login_dec_logo.png")
    gameLogoDec:pos(updatePanelSize.width - gameLogoDecMagrinRight - gameLogoDec:getContentSize().width / 2,
        display.cy + gameLogoDecPosYAdj)
        :addTo(updatePanel)

    PROBAR_WIDTH = PROBAR_WIDTH * self.bgScale_

    local porgressBarPosYShift = 88
    self.proBarBg_ = display.newScale9Sprite("#upd_porBarLayer.png", gameLogoDec:getPositionX(), display.cy - porgressBarPosYShift,
        cc.size(PROBAR_WIDTH, PROBAR_HEIGHT))
        :addTo(updatePanel)

    local proBarFillerMagrinAdj = 4

    self.proBarFiller_ = display.newScale9Sprite("#upd_proBarFiller.png")
    self.proBarFiller_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.proBarFiller_:pos(proBarFillerMagrinAdj, PROBAR_HEIGHT / 2)
        :addTo(self.proBarBg_)

    local proBarForwRightExtra = 3
    local proBarForwPosYAdj = 2.3
    self.proBarLayerForw_ = display.newSprite("#upd_porBarLayerForw.png")
    self.proBarLayerForw_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_RIGHT])
    self.proBarLayerForw_:pos(self.proBarFiller_:getContentSize().width + proBarForwRightExtra, PROBAR_HEIGHT / 2 - proBarForwPosYAdj)
        :addTo(self.proBarFiller_)

    local labelParam = {
        fontSize = 0,
        color = display.COLOR_WHITE
    }

    -- Progress Info Label Param --
    labelParam.fontSize = 21
    labelParam.color = display.COLOR_WHITE

    local progressInfoLblPosYAdj = 25
    self.progressInfoTip_ = display.newTTFLabel({text = "Progress Info Label", size = labelParam.fontSize, color = labelParam.color,
        align = ui.TEXT_ALIGN_CENTER})
        :pos(gameLogoDec:getPositionX(), self.proBarBg_:getPositionY() + progressInfoLblPosYAdj)
        :addTo(updatePanel)

    labelParam.fontSize = 18
    labelParam.color = display.COLOR_WHITE

    local downloadInfoLblPosYAdj = 25
    self.downloadSpeedInfo_ = display.newTTFLabel({text = "Speed : 0KB/s.", size = labelParam.fontSize, color = labelParam.color,
        align = ui.TEXT_ALIGN_CENTER})
    self.downloadSpeedInfo_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.downloadSpeedInfo_:pos(gameLogoDec:getPositionX() - PROBAR_WIDTH / 2, self.proBarBg_:getPositionY() - downloadInfoLblPosYAdj)
        :addTo(updatePanel)

    self.totalSizeToDownloadInfo_ = display.newTTFLabel({text = "Total Size : 0KB", size = labelParam.fontSize, color = labelParam.color,
        align = ui.TEXT_ALIGN_CENTER})
    self.totalSizeToDownloadInfo_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_RIGHT])
    self.totalSizeToDownloadInfo_:pos(gameLogoDec:getPositionX() + PROBAR_WIDTH / 2, self.proBarBg_:getPositionY() - downloadInfoLblPosYAdj)
        :addTo(updatePanel)

    self:setProgress(0)

    -- For Test UI --
    -- self:setUpdateInfoVisible(false)
    -- self:setProgress(0.01, "3.2MB/s")
    -- self:setDownloadSizeTotalInfo("5MB")
    -- self:setProgressTipsInfo(upd.lang.getText("UPDATE", "DOWNLOADING_MSG", 1, 5))

    -- Poker Girl --
    self.pokerGirlDecNode_ = display.newNode()
        :addTo(self)

    local pokerGirlMagrinLeft = 28
    local pokerGirlDec = display.newSprite("#login_dec_girl.png")
    pokerGirlDec:pos(- display.cx + pokerGirlMagrinLeft + pokerGirlDec:getContentSize().width / 2, - display.cy + pokerGirlDec:getContentSize().height / 2)
        :addTo(self.pokerGirlDecNode_)
        -- :schedule(handler(self, self.pokerGirlBlink_), 5)

    -- -- Copyright Info Lable --
    -- self.copyrightLabel_ = display.newTTFLabel({text = upd.lang.getText("UPDATE", "COPY_RIGHT"), color = cc.c3b(0x00, 0x6d, 0x32), 
    --     size = 18, align = ui.TEXT_ALIGN_RIGHT})
    --     :align(display.RIGHT_BOTTOM, display.cx - 104, - (display.cy - 4))
    --     :addTo(self)

    -- self.versionLabel = display.newTTFLabel({text = "V1.0.0.0", color = cc.c3b(0x00, 0x6d, 0x32), size = 18, align = ui.TEXT_ALIGN_RIGHT})
    --     :align(display.RIGHT_BOTTOM, display.cx - 3, -(display.cy - 4))
    --     :addTo(self)

    -- self:playDotsAnim()

    -- self.controller_:startUpdate()
end

-- Poker Girl Blink Anim --
function UpdateView:pokerGirlBlink_()
    -- local blinkSpr = display.newSprite("#poker_girl_blink_half.png")
    --     :pos(- 31.4, 235.8)
    --     :addTo(self.pokerGirlBatchNode_)
    -- blinkSpr:performWithDelay(function ()
    --     blinkSpr:setSpriteFrame(display.newSpriteFrame("poker_girl_blink_all.png"))
    -- end, 0.05)  -- 0.05
    -- blinkSpr:performWithDelay(function ()
    --     blinkSpr:setSpriteFrame(display.newSpriteFrame("poker_girl_blink_half.png"))
    -- end, 0.15) -- 0.15
    -- blinkSpr:performWithDelay(function ()
    --     blinkSpr:removeFromParent()
    -- end, 0.20) -- 0.20
end

function UpdateView:playDotsAnim()
    -- self:stopDotsAnim_()
    -- self.firstDotId_ = 1
    -- self.dotsSchedulerHandle_ = scheduler.scheduleGlobal(handler(self, function (obj)

    --     if obj and obj.dots_ then
    --         --todo
    --         obj.dots_[obj.firstDotId_]:runAction(transition.sequence({cc.FadeTo:create(0.3, 255), cc.FadeTo:create(0.3, 32)}))

    --         local secondDotId = obj.firstDotId_ + DOTS_NUM * 0.5
    --         if secondDotId > DOTS_NUM then
    --             secondDotId = secondDotId - DOTS_NUM
    --         end
            
    --         obj.dots_[secondDotId]:runAction(transition.sequence({cc.FadeTo:create(0.3, 255), cc.FadeTo:create(0.3, 32)}))
    --         obj.firstDotId_ = obj.firstDotId_ + 1

    --         if obj.firstDotId_ > DOTS_NUM then
    --             obj.firstDotId_ = 1
    --         end
    --     end
    -- end), 0.05)
end

function UpdateView:playLeaveScene(callback)
    -- log("UpdateView:playLeaveScene called!")
    -- log("UpdateView:playLeaveScene.callback :" .. tostring(callback))
    -- log("UpdateView:playLeaveScene call self.tableNode_ :" .. tostring(self.tableNode_))

    -- log("UpdateView:playLeaveScene call self.tableNode_ moveTo X:" .. display.right + display.width * 0.5)

    self.progressInfoTip_:setVisible(false)

    local moveAnimTime = 0.5
    transition.moveTo(self.updatePanelNode_, {x = display.right + display.width * 0.5, time = moveAnimTime, onComplete = callback})
end

-- Set File TotalSize Label --
function UpdateView:setDownloadSizeTotalInfo(totalSize)
    self.totalSizeToDownloadInfo_:setString(upd.lang.getText("UPDATE", "DOWNLOAD_SIZE", totalSize))
end

-- Set Progress Info Label --
function UpdateView:setProgressTipsInfo(msg)
    self.progressInfoTip_:setVisible(true)
    self.progressInfoTip_:setString(msg)
end

-- Set Version Code Info Label --
function UpdateView:setVersionInfo(version)
    -- if version and #(string.split(version, ".")) == 3 then
    --     version = version .. ".0"
    -- end

    -- self.versionLabel:setString("V" .. version)
    -- self.copyrightLabel_:align(display.RIGHT_BOTTOM, display.cx - 6 - self.versionLabel:getContentSize().width, - (display.cy - 4))
end

-- Set Porgress Bar Visible State --
function UpdateView:setUpdateInfoVisible(bool)
    self.proBarBg_:setVisible(bool)
    self.progressInfoTip_:setVisible(bool)
    self.downloadSpeedInfo_:setVisible(bool)
    self.totalSizeToDownloadInfo_:setVisible(bool)
end

local lastProPercent
local lastSpeed
function UpdateView:setProgress(proPercent, speed)


    self.proBarHiliLines = self.proBarHiliLines or {}

    if proPercent > 1 then
        proPercent = 1
    end

    if speed ~= lastSpeed then
        lastSpeed = speed

        if speed then
            self.downloadSpeedInfo_:setString(upd.lang.getText("UPDATE", "SPEED", speed))
        end
    end

    if lastProPercent == proPercent then
        return
    end

    lastProPercent = proPercent

    if proPercent > 0 then
        self:setProgressTipsInfo(upd.lang.getText("UPDATE", "DOWNLOAD_PROGRESS", checkint(proPercent * 100)))
    else
        --self:setProgressTipsInfo("")
    end

    local proBarFillerWidth = PROBAR_WIDTH * proPercent

    local proBarForwWidthHalf = 24

    if proPercent <= 0 then
        self.proBarFiller_:setVisible(false)

        -- Needed ! --
        for i = 1, #self.proBarHiliLines do
            if self.proBarHiliLines[i] then
                --todo
                self.proBarHiliLines[i]:removeFromParent()
                self.proBarHiliLines[i] = nil
            end
        end

        return
    else
        self.proBarFiller_:setVisible(true)

        local proBarForwRightExtra = 3
        local proBarForwPosYAdj = 2.5

        if proBarFillerWidth <= proBarForwWidthHalf then
            self.proBarLayerForw_:pos(proBarForwWidthHalf + proBarForwRightExtra, PROBAR_HEIGHT / 2 - proBarForwPosYAdj)
        elseif proBarFillerWidth + proBarForwRightExtra >= PROBAR_WIDTH then
            --todo
            self.proBarLayerForw_:pos(PROBAR_WIDTH, PROBAR_HEIGHT / 2 - proBarForwPosYAdj)
        else
            self.proBarLayerForw_:pos(proBarFillerWidth + proBarForwRightExtra, PROBAR_HEIGHT / 2 - proBarForwPosYAdj)
        end
    end

    local proBarHiliLineShownGap = 14
    local proBarHiliLineShownWidth = 12

    local curLinesNum = checkint((proBarFillerWidth - proBarHiliLineShownGap) / (proBarHiliLineShownGap + proBarHiliLineShownWidth))
    local linesNum = #self.proBarHiliLines
    
    if curLinesNum > linesNum then
        linesNum = curLinesNum
    end

    local proBarHiliLinePosYAdj = 2
    for i = 1, linesNum do
        if curLinesNum >= i then
            if not self.proBarHiliLines[i] then
                self.proBarHiliLines[i] = display.newSprite("#upd_porBarHili.png")
                self.proBarHiliLines[i]:setAnchorPoint(display.ANCHOR_POINTS[display.BOTTOM_RIGHT])
                self.proBarHiliLines[i]:addTo(self.proBarBg_)
            end

            self.proBarHiliLines[i]:pos((proBarHiliLineShownGap + proBarHiliLineShownWidth) * i, proBarHiliLinePosYAdj)
        elseif self.proBarHiliLines[i] then
            self.proBarHiliLines[i]:removeFromParent()
            self.proBarHiliLines[i] = nil
        end
    end

    if proBarFillerWidth <= proBarHiliLineShownGap + proBarHiliLineShownWidth then
        proBarFillerWidth = proBarHiliLineShownGap + proBarHiliLineShownWidth
    end

    local proBarFilerMagrinLayerVert = 2.2
    self.proBarFiller_:setContentSize(cc.size(proBarFillerWidth, PROBAR_HEIGHT - proBarFilerMagrinLayerVert * 2))
end

function UpdateView:stopDotsAnim_()
    -- for _, dot in ipairs(self.dots_) do
    --     dot:opacity(0)
    --     dot:stopAllActions()
    -- end

    -- if self.dotsSchedulerHandle_ then
    --     scheduler.unscheduleGlobal(self.dotsSchedulerHandle_)
    --     self.dotsSchedulerHandle_ = nil
    -- end
end

function UpdateView:onEnter()
    -- body
end

function UpdateView:onEnterTransitionFinish()
    -- body
end

function UpdateView:onExit()
    -- body
    self:stopDotsAnim_()

    if self.dotsSchedulerHandle_ then
        scheduler.unscheduleGlobal(self.dotsSchedulerHandle_)
        self.dotsSchedulerHandle_ = nil
    end
end

function UpdateView:onCleanup()
end

return UpdateView