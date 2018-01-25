--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-02-28 17:28:13
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: LoginGameView.lua Reconstruct By Tsing7x.
--

-- local DisplayUtil = import("app.util.DisplayUtil")
local DebugPopup = import("app.module.debugtools.DebugPopup")

local LoginFeedBack = import(".views.LoginFeedBack")

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local LoginGameView = class("LoginGameView", function ()
    return display.newNode()
end)

local logger = bm.Logger.new("LoginGameView")

function LoginGameView:ctor(controller)
    self:setNodeEventEnabled(true)
    self.controller_ = controller
    self.controller_:setDisplayView(self)

    -- self.pokerBatchNode_ = display.newBatchNode("update_texture.png")
    --     :pos(-display.cx - 300, 0)
    --     :addTo(self)
    -- local animTime = 32
    -- local poker1 = display.newSprite("#float_poker_1.png")
    --     :pos(260, 122)
    --     :addTo(self.pokerBatchNode_)
    -- poker1:runAction(cc.RepeatForever:create(transition.sequence({
    --     cc.MoveTo:create(animTime, cc.p(-40, 122)), 
    --     cc.MoveTo:create(animTime, cc.p(260, 122))
    -- })))
    -- local poker2 = display.newSprite("#float_poker_2.png")
    --     :pos(140, -20)
    --     :addTo(self.pokerBatchNode_)
    -- poker2:runAction(cc.RepeatForever:create(transition.sequence({
    --     cc.MoveTo:create(animTime * 0.8, cc.p(292, -20)), 
    --     cc.MoveTo:create(animTime * 0.8, cc.p(-60, -20))
    -- })))
    -- local poker3 = display.newSprite("#float_poker_3.png")
    --     :pos(124, -132)
    --     :addTo(self.pokerBatchNode_)
    -- poker3:runAction(cc.RepeatForever:create(transition.sequence({
    --     cc.MoveTo:create(animTime * 0.7, cc.p(-76, -132)), 
    --     cc.MoveTo:create(animTime * 0.7, cc.p(284, -132))
    -- })))
    -- local poker4 = display.newSprite("#float_poker_4.png")
    --     :pos(64, -220)
    --     :addTo(self.pokerBatchNode_)
    -- poker4:runAction(cc.RepeatForever:create(transition.sequence({
    --     cc.MoveTo:create(animTime * 0.8, cc.p(244, -220)), 
    --     cc.MoveTo:create(animTime * 0.8, cc.p(-64, -220))
    -- })))
    -- local poker5 = display.newSprite("#float_poker_5.png")
    --     :pos(100, 64)
    --     :addTo(self.pokerBatchNode_)
    -- poker5:runAction(cc.RepeatForever:create(transition.sequence({
    --     cc.MoveTo:create(animTime * 1.2, cc.p(256, 64)), 
    --     cc.MoveTo:create(animTime * 1.2, cc.p(-76, 64))
    -- })))
    
    local bgScale = self.controller_:getBgScale()

    local loginMainBg = display.newSprite("login_main_bg.png")
        :scale(bgScale)
        :addTo(self, 0)

    self.loginPanelNode_ = display.newNode()
        :addTo(self)

    local loginPanelBg = display.newSprite("#login_bg_table.png")
        :scale(bgScale)

    local loginPanelBgSize = loginPanelBg:getContentSize()
    loginPanelBg:pos(display.cx - loginPanelBgSize.width / 2, 0)
        :addTo(self.loginPanelNode_)

    local gameLogoMagrins = {
        top = 65,
        right = 25
    }

    local gameLogo = display.newSprite("#login_dec_logo.png")
    gameLogo:pos(loginPanelBgSize.width - gameLogoMagrins.right - gameLogo:getContentSize().width / 2,
        loginPanelBgSize.height - gameLogoMagrins.top - gameLogo:getContentSize().height / 2)
        :addTo(loginPanelBg)

    local loginBtnMagrins = {
        gap = 16,
        right = 38
    }

    local FBLoginBtnPosAdjY = 30

    local FBLoginTex = display.newSprite("#login_btn_FBLog.png")
    local FBLoginBtnSize = FBLoginTex:getContentSize()

    FBLoginTex:pos(loginPanelBgSize.width - loginBtnMagrins.right - FBLoginBtnSize.width / 2, loginPanelBgSize.height / 2 +
        FBLoginBtnPosAdjY)
        :addTo(loginPanelBg)

    local tagHotPosAdj = {
        x = 4,
        y = 10
    }

    local tagHot = display.newSprite("#login_tag_hot.png")
    tagHot:pos(FBLoginBtnSize.width - tagHot:getContentSize().width / 2 - tagHotPosAdj.x, FBLoginBtnSize.height - tagHot:getContentSize().height / 2 - tagHotPosAdj.y)
        :addTo(FBLoginTex)

    self.FBLoginBtn_ = cc.ui.UIPushButton.new({normal = "#common_modTransparent.png", pressed = "#common_modTransparent.png", disabled = "#common_modTransparent.png"},
        {scale9 = true})
        :setButtonSize(FBLoginBtnSize.width, FBLoginBtnSize.height)
        :onButtonClicked(buttontHandler(self, self.onFacebookBtnClick_))
        :pos(FBLoginBtnSize.width / 2, FBLoginBtnSize.height / 2)
        :addTo(FBLoginTex)

    local guestLoginTex = display.newSprite("#login_btn_guestLog.png")
    local guestLoginBtnSize = guestLoginTex:getContentSize()

    guestLoginTex:pos(FBLoginTex:getPositionX(), FBLoginTex:getPositionY() - FBLoginBtnSize.height / 2 - loginBtnMagrins.gap - guestLoginBtnSize.height / 2)
        :addTo(loginPanelBg)

    self.guestLoginBtn_ = cc.ui.UIPushButton.new({normal = "#common_modTransparent.png", pressed = "#common_modTransparent.png", disabled = "#common_modTransparent.png"},
        {scale9 = true})
        :setButtonSize(guestLoginBtnSize.width, guestLoginBtnSize.height)
        :onButtonClicked(buttontHandler(self, self.onGuestBtnClick_))
        :pos(guestLoginBtnSize.width / 2, guestLoginBtnSize.height / 2)
        :addTo(guestLoginTex)

    if DEBUG >= 5 then
        --todo
        local phpSelBtnMagrins = {
            top = 40,
            right = 40
        }

        self.debugPhpSelBtn_ = cc.ui.UIPushButton.new({normal = "#login_btn_switchSrv.png", pressed = "#login_btn_switchSrv.png"}, {scale9 = false})
            :onButtonClicked(buttontHandler(self, self.onPhpSelector_))
            :pos(loginPanelBgSize.width - phpSelBtnMagrins.right, loginPanelBgSize.height - phpSelBtnMagrins.top)
            :addTo(loginPanelBg)

        local ranNewAccBtnPosAss = {
            x = 90,
            y = 40
        }

        local debugRanNewAccBtn = cc.ui.UIPushButton.new({normal = "#login_btn_ranGuest.png", pressed = "#login_btn_ranGuest.png"}, {scale9 = false})
            :onButtonClicked(buttontHandler(self, self.onRanCreateNewAccount_))
            :pos(loginPanelBgSize.width - ranNewAccBtnPosAss.x, loginPanelBgSize.height - ranNewAccBtnPosAss.y )
            :addTo(loginPanelBg)
    end

    self.pokerGirlNode_ = display.newNode()
        :addTo(self)

    local pokerGirlMagrinLeft = 28

    local pokerGirlDec = display.newSprite("#login_dec_girl.png")
    pokerGirlDec:pos(- display.cx + pokerGirlMagrinLeft + pokerGirlDec:getContentSize().width / 2, - display.cy + pokerGirlDec:getContentSize().height / 2)
        :addTo(self.pokerGirlNode_)

    local feedBackBtnMagrins = {
        left = 16,
        bottom = 14
    }

    local feedBackBtnSize = {
        width = 72,
        height = 72
    }

    self.feedBackBtn_ = cc.ui.UIPushButton.new("#login_btn_feedback.png")
        :onButtonClicked(buttontHandler(self, self.onLoginFeedBackBtnCallBack_))
        :pos(- display.cx + feedBackBtnMagrins.left + feedBackBtnSize.width / 2, - display.cy + feedBackBtnMagrins.bottom + feedBackBtnSize.height / 2)
        :addTo(self)

    --  Clear Cache Func --
    local clearCacheBtnSize = {
        width = 80,
        height = 80
    }

    self.clearLoginCacheBtn_ = cc.ui.UIPushButton.new("#common_modTransparent.png", {scale9 = true})
        :setButtonSize(clearCacheBtnSize.width, clearCacheBtnSize.height)
        :onButtonClicked(buttontHandler(self, self.onClearBtnCallBack_))
        :pos(- display.cx + clearCacheBtnSize.width / 2, display.cy - clearCacheBtnSize.height / 2)
        :addTo(self)

    self.clearLoginCacheBtn_:setButtonEnabled(false)
    -- self:addGrayFilter()
end

function LoginGameView:playShowAnim()
    local animTime = self.controller_:getAnimTime()

    -- transition.fadeIn(self.copyrightLabel_, {time = animTime})
    -- transition.moveTo(self.pokerBatchNode_, {time = animTime, x = -display.cx})
    -- transition.moveTo(self.tableNode_, {time = animTime, x = 0})
    
end

function LoginGameView:playLoginAnim()
    self.clearLoginCacheBtn_:setButtonEnabled(true)

    -- self:playDotsAnimInLogin_()
    local animTime = self.controller_:getAnimTime()
    -- self.logoBatchNode_:stopAllActions()
    -- self.btnNode_:stopAllActions()
    -- if self.loadingLabel_ then
    --     self.loadingLabel_:removeFromParent()
    --     self.loadingLabel_ = nil
    -- end
    -- transition.moveTo(self.logoBatchNode_, {
    --     time = animTime, 
    --     y = -LOGO_POS_Y, 
    -- })
    -- transition.moveTo(self.btnNode_, {
    --     time = animTime, 
    --     x = display.cx + PANEL_WIDTH * 0.5, 
    --     onComplete = handler(self, function (obj)
    --         obj.loadingLabel_ = display.newTTFLabel({text = bm.LangUtil.getText("LOGIN", "LOGINING_MSG"), color = styles.FONT_COLOR.LIGHT_TEXT, size = 28, align = ui.TEXT_ALIGN_CENTER})
    --             :pos(LOGO_POS_X, LOGO_POS_Y - 264 * nk.heightScale - 40)
    --             :addTo(obj.tableNode_)
    --     end)
    -- })
end

function LoginGameView:playHideAnim()
    local animTime = self.controller_:getAnimTime()

    -- To Complete --
    self:performWithDelay(function()
        -- body
        self:removeFromParent()
    end, animTime)
    -- transition.fadeOut(self.copyrightLabel_, {time = animTime})
    -- transition.moveTo(self.pokerBatchNode_, {time = animTime, x = -display.cx - 300})
    -- transition.moveTo(self.tableNode_, {
    --     time = animTime, 
    --     x = self.visibleTableWidth_, 
    --     onComplete = handler(self, function (obj)
    --         obj:removeFromParent()
    --     end)
    -- })
end

function LoginGameView:playLoginFailAnim()
    self.clearLoginCacheBtn_:setButtonEnabled(true)

    -- self:playDotsAnimInNormal_()
    local animTime = self.controller_:getAnimTime()
    -- self.logoBatchNode_:stopAllActions()
    -- self.btnNode_:stopAllActions()
    -- transition.moveTo(self.logoBatchNode_, {
    --     time = animTime, 
    --     y = 0, 
    -- })
    -- transition.moveTo(self.btnNode_, {
    --     time = animTime, 
    --     x = 0, 
    -- })
    -- if self.loadingLabel_ then
    --     self.loadingLabel_:removeFromParent()
    --     self.loadingLabel_ = nil 
    -- end
end

function LoginGameView:playDotsAnimInLogin_()
    -- self:stopDotsAnim_()
    -- self.firstDotId_ = 1
    -- self.dotsSchedulerHandle_ = scheduler.scheduleGlobal(handler(self, function (obj)
    --     obj.dots_[obj.firstDotId_]:runAction(transition.sequence({
    --             cc.FadeTo:create(0.3, 255), 
    --             cc.FadeTo:create(0.3, 32),
    --         })
    --     )
    --     local secondDotId = obj.firstDotId_ + DOTS_NUM * 0.5
    --     if secondDotId > DOTS_NUM then
    --         secondDotId = secondDotId - DOTS_NUM
    --     end
    --     obj.dots_[secondDotId]:runAction(transition.sequence({
    --             cc.FadeTo:create(0.3, 255), 
    --             cc.FadeTo:create(0.3, 32), 
    --         })
    --     )
    --     obj.firstDotId_ = obj.firstDotId_ + 1
    --     if obj.firstDotId_ > DOTS_NUM then
    --         obj.firstDotId_ = 1
    --     end
    -- end), 0.05)
end

function LoginGameView:playDotsAnimInNormal_()
    -- self:stopDotsAnim_()
    -- for _, dot in ipairs(self.dots_) do
    --     dot:runAction(cc.RepeatForever:create(cc.Sequence:create(
    --                 cc.FadeTo:create(1, 128), 
    --                 cc.FadeTo:create(1, 0)
    --             )
    --         )
    --     )
    -- end
end

function LoginGameView:stopDotsAnim_()
    -- for _, dot in ipairs(self.dots_) do
    --     dot:opacity(0)
    --     dot:stopAllActions()
    -- end
    -- if self.dotsSchedulerHandle_ then
    --     scheduler.unscheduleGlobal(self.dotsSchedulerHandle_)
    --     self.dotsSchedulerHandle_ = nil
    -- end
end

function LoginGameView:setShowState()
    local animTime = self.controller_:getAnimTime()
    -- self.copyrightLabel_:show()
    -- self.pokerBatchNode_:setPositionX(-display.cx)
    -- transition.moveTo(self.tableNode_, {time = animTime, x = 0})
end

function LoginGameView:addGrayFilter()
    DisplayUtil.setGray(self)
end

function LoginGameView:removeGrayFilter()
    DisplayUtil.removeShader(self)
end

function LoginGameView:onFacebookBtnClick_(evt)
    -- FB登录
    self.controller_:loginWithFacebook()
end

function LoginGameView:onGuestBtnClick_(evt)
    -- 游客登录
    self.controller_:loginWithGuest()
end

function LoginGameView:onLoginFeedBackBtnCallBack_(evt)
    self.feedBackBtn_:setButtonEnabled(false)

    LoginFeedBack.new():show()
    self.feedBackBtn_:setButtonEnabled(true)
end

function LoginGameView:onPhpSelector_(evt)
    self.debugPhpSelBtn_:setButtonEnabled(false)

    DebugPopup.new():show()
    self.debugPhpSelBtn_:setButtonEnabled(true)
end

function LoginGameView:onRanCreateNewAccount_(evt)
    -- 游客登录
    self.controller_:loginWithNewGuestByDebug()
end

function LoginGameView:onClearBtnCallBack_(evt)
    -- body
    self.clearLoginCacheBtn_:setButtonEnabled(false)
    nk.ui.Dialog.new({messageText = bm.LangUtil.getText("LOGIN", "CLEAR_CACHE_TIP"), 
        callback = function (type)
            if type == nk.ui.Dialog.SECOND_BTN_CLICK then

                if self.controller_ and self.controller_.cancelLoginAndClearCache then
                    --todo
                    self.controller_:cancelLoginAndClearCache()
                end
            end
        end
    }):show()
    
    self.clearLoginCacheBtn_:setButtonEnabled(true)
end

function LoginGameView:onEnter()
    local g = global_statistics_for_umeng
    g.umeng_view = g.Views.login
end

function LoginGameView:onExit()
    local g = global_statistics_for_umeng
    g.umeng_view = g.Views.other
end

function LoginGameView:onCleanup()
    -- if self.dotsSchedulerHandle_ then
    --     scheduler.unscheduleGlobal(self.dotsSchedulerHandle_)
    --     self.dotsSchedulerHandle_ = nil
    -- end
end

return LoginGameView
