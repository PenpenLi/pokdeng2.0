--
-- Author: LeoLuo
-- Date: 2015-06-12 09:51:27
--
local WIDTH = 720
local HEIGHT = 470
local TOP,BOTTOM,LEFT,RIGHT = 0,0,0,0
local UserCrash = class("UserCrash", nk.ui.Panel)
-- local StorePopup = import("app.module.store.StorePopup")
local logger = bm.Logger.new("UserCrash")
local InvitePopup         = import("app.module.friend.InviteRecallPopup")
local InviteOldUserPopup = import("app.module.friend.InviteOldUserPopup")
local QuickPurchaseServiceManager = import("app.module.store.managers.QuickPurchaseServiceManager")
local PURCHASE_TYPE = import("app.module.store.managers.PURCHASE_TYPE")
local UserInfoPopup = import("app.module.userInfo.UserInfoPopup")

function UserCrash:ctor(times,subsidizeChips,limitedDay,limitedTimes,isPretendBankrupt,inRoom)
    self.isPretendBankrupt_ = isPretendBankrupt
    self.inRoom_ = inRoom
    self.isShowPay_ = nk.OnOff:check("payGuide") --是否显示破产快捷支付
    -- self.isShowPay_ = true

    if self.isShowPay_ then
        HEIGHT = 470
    else
        HEIGHT = 300
    end

    self.times_ = times
    self.subsidizeChips_ = subsidizeChips
    self.limitedTimes_ = limitedTimes
    self.limitedDay_ = limitedDay
    display.addSpriteFrames("crash_texture.plist", "crash_texture.png")
    UserCrash.super.ctor(self, {WIDTH, HEIGHT})
    self:setNodeEventEnabled(true)
    
    TOP = self.height_*0.5
    BOTTOM = -self.height_*0.5
    LEFT = -self.width_*0.5
    RIGHT = self.width_*0.5
    TOP_HEIGHT = 64 

    self.closeButton_ = cc.ui.UIPushButton.new({normal= "#panel_close_btn_up.png", pressed = "#panel_close_btn_down.png"})
        :pos(RIGHT - 15, TOP - 22)
        :onButtonClicked(handler(self, function ()
            self:hide()
        end))
        :addTo(self)
    
    if self.isShowPay_ then
        self.quickPay_ = QuickPurchaseServiceManager.new()
        self.bigJuhua_ = nk.ui.Juhua.new():addTo(self)
        self.quickPay_:loadPayConfig(handler(self, self.onLoadPayConfig_))

    else
        self:buildView_() 
    end
end

function UserCrash:onLoadPayConfig_(ret)
    if self then
        --todo
        if self.bigJuhua_ then
            --todo
            self.bigJuhua_:removeSelf()
        end
        
        if self.buildView_ then
            --todo
            self:buildView_()
        end

    end

    if ret == 0 then
        local isServiceAvailable = self.quickPay_:isServiceAvailable(PURCHASE_TYPE.BLUE_PAY)
        local service = self.quickPay_:getPurchaseService(PURCHASE_TYPE.BLUE_PAY)
        if isServiceAvailable and service then
            self.quickPay_:loadChipProductList(PURCHASE_TYPE.BLUE_PAY,function(config, isComplete, data)             
                if isComplete then
                    self:showPayItem_(data)
                end
            end)
        end
        
    end
end

function UserCrash:buildView_()
    self.title_ = display.newTTFLabel({text=bm.LangUtil.getText("CRASH", "TITLE"), size=30, color=cc.c3b(0xff, 0xff, 0xff), align=ui.TEXT_ALIGN_CENTER})
        :pos(0, TOP - 20)
        :addTo(self)

    display.newScale9Sprite("#user-info-desc-division-line.png", 0, TOP - 50, cc.size(WIDTH - 16 * 2, 2))
        :addTo(self)

    -- 金币
    display.newScale9Sprite("#common_input_bg.png", 0, 0, cc.size(WIDTH - 16 * 2, 82))
        :pos(0, TOP - 50 - 41 - 15)
        :addTo(self)

    self.box1 = display.newNode()
    self.box1:pos(0, TOP - 50 - 41 - 15):addTo(self)

    self.icon1 = display.newSprite("#chips_icon.png"):pos(LEFT + 16 + 36.5 + 10, 0):addTo(self.box1)

    self.title1 = display.newTTFLabel({text=bm.LangUtil.getText("CRASH", "CHIPS_TIPS"), size=24, color=cc.c3b(0xff, 0xff, 0xff), align=ui.TEXT_ALIGN_LEFT})
    self.title1:pos(LEFT + 16 + 36.5 + 10 + 36.5 + self.title1:getContentSize().width / 2 + 10,  self.title1:getContentSize().height / 2):addTo(self.box1)

    self.chips1 = display.newTTFLabel({text=bm.LangUtil.getText("CRASH", "CHIPS", self.subsidizeChips_), size=24, color=cc.c3b(109, 183, 0), align=ui.TEXT_ALIGN_LEFT})
    local tmpWidth = self.chips1:getContentSize().width
    self.chips1:pos(LEFT + 16 + 36.5 + 10 + 36.5 + tmpWidth / 2 + 10,  - self.chips1:getContentSize().height / 2):addTo(self.box1)

    self.info1 = display.newTTFLabel({text=bm.LangUtil.getText("CRASH", "CHIPS_INFO",self.limitedDay_,self.limitedTimes_), size=24, color=cc.c3b(0x1e, 0x9e, 0xe8), align=ui.TEXT_ALIGN_LEFT})
    self.info1:pos(LEFT + 16 + 36.5 + 10 + 36.5 + tmpWidth / 2 + 10 + tmpWidth + self.info1:getContentSize().width / 2 - 30,  - self.chips1:getContentSize().height / 2):addTo(self.box1)
    
    self.actionBtn1 = cc.ui.UIPushButton.new({normal= "#common_green_btn_up.png", pressed = "#common_green_btn_down.png"},{scale9 = true})
        :setButtonSize(140, 50)
        :setButtonLabel(display.newTTFLabel({text=bm.LangUtil.getText("CRASH", "GET"), size=24, color=cc.c3b(0xff, 0xff, 0xff), align=ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked(handler(self, self.onGetCrashChips_))
        :pos(RIGHT - 140 / 2 - 16 - 10, 0)
        :addTo(self.box1)

    -- 邀请好友
    display.newScale9Sprite("#common_input_bg.png", 0, 0, cc.size(WIDTH - 16 * 2, 82))
        :pos(0, TOP - 50 - 41 - 15 - 82 - 10)
        :addTo(self)

    self.box2 = display.newNode()
    self.box2:pos(0, TOP - 50 - 41 - 15 - 82 - 10):addTo(self)

    self.icon2 = display.newSprite("#invite_icon.png"):pos(LEFT + 16 + 36.5 + 10, 0):addTo(self.box2)

    self.title2 = display.newTTFLabel({text=bm.LangUtil.getText("CRASH", "INVITE"), size=24, color=cc.c3b(0xff, 0xff, 0xff), align=ui.TEXT_ALIGN_LEFT})    
    self.title2:pos(LEFT + 16 + 36.5 + 10 + 36.5 + self.title2:getContentSize().width / 2 + 10, 0 + self.title2:getContentSize().height / 2):addTo(self.box2)

    self.chips2 = display.newTTFLabel({text=bm.LangUtil.getText("CRASH", "CHIPS", nk.userData.inviteBackChips), size=24, color=cc.c3b(109, 183, 0), align=ui.TEXT_ALIGN_LEFT})
    tmpWidth = self.chips2:getContentSize().width
    self.chips2:pos(LEFT + 16 + 36.5 + 10 + 36.5 + tmpWidth / 2 + 10, 0 - self.chips2:getContentSize().height / 2):addTo(self.box2)

    self.info2 = display.newTTFLabel({text=bm.LangUtil.getText("CRASH", "INVITE_INFO"), size=24, color=cc.c3b(0x1e, 0x9e, 0xe8), align=ui.TEXT_ALIGN_LEFT})
    self.info2:pos(LEFT + 16 + 36.5 + 10 + 36.5 + tmpWidth / 2 + 10 + tmpWidth + self.info2:getContentSize().width / 2 - 30, 0 - self.chips2:getContentSize().height / 2):addTo(self.box2)
    
    self.actionBtn2 = cc.ui.UIPushButton.new({normal= "#common_dark_blue_btn_up.png", pressed = "#common_dark_blue_btn_down.png"},{scale9 = true})
        :setButtonSize(140, 50)
        :setButtonLabel(display.newTTFLabel({text=bm.LangUtil.getText("CRASH", "GET"), size=24, color=cc.c3b(0xff, 0xff, 0xff), align=ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked(handler(self, self.onInvite_))
        :pos(RIGHT - 140 / 2 - 16 - 10, 0)
        :addTo(self.box2)

    self.box3 = display.newNode()
    self.box3:hide()
    self.box3:pos(0, TOP - 50 - 41 - 15 - 82 - 10):addTo(self)

    self.icon3 = display.newSprite("#recall_icon.png"):pos(LEFT + 16 + 36.5 + 10, 0):addTo(self.box3)

    self.title3 = display.newTTFLabel({text=bm.LangUtil.getText("CRASH", "RECALL"), size=24, color=cc.c3b(0xff, 0xff, 0xff), align=ui.TEXT_ALIGN_LEFT})    
    self.title3:pos(LEFT + 16 + 36.5 + 10 + 36.5 + self.title3:getContentSize().width / 2 + 10, 0 + self.title3:getContentSize().height / 2):addTo(self.box3)

    self.chips3 = display.newTTFLabel({text=bm.LangUtil.getText("CRASH", "CHIPS", nk.userData.recallBackChips), size=24, color=cc.c3b(109, 183, 0), align=ui.TEXT_ALIGN_LEFT})
    tmpWidth = self.chips3:getContentSize().width
    self.chips3:pos(LEFT + 16 + 36.5 + 10 + 36.5 + tmpWidth / 2 + 10, 0 - self.chips3:getContentSize().height / 2):addTo(self.box3)

    self.info3 = display.newTTFLabel({text=bm.LangUtil.getText("CRASH", "RECALL_INFO"), size=24, color=cc.c3b(0x1e, 0x9e, 0xe8), align=ui.TEXT_ALIGN_LEFT})
    self.info3:pos(LEFT + 16 + 36.5 + 10 + 36.5 + tmpWidth / 2 + 10 + tmpWidth + self.info3:getContentSize().width / 2 - 30, 0 - self.chips3:getContentSize().height / 2):addTo(self.box3)
    
    self.actionBtn3 = cc.ui.UIPushButton.new({normal= "#common_dark_blue_btn_up.png", pressed = "#common_dark_blue_btn_down.png"},{scale9 = true})
        :setButtonSize(140, 50)
        :setButtonLabel(display.newTTFLabel({text=bm.LangUtil.getText("CRASH", "GET"), size=24, color=cc.c3b(0xff, 0xff, 0xff), align=ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked(handler(self, self.onReCall_))
        :pos(RIGHT - 140 / 2 - 16 - 10, 0)
        :addTo(self.box3)



    self.box4 = display.newNode()
    self.box4:hide()
    self.box4:pos(0, TOP - 50 - 41 - 15 - 82 - 10):addTo(self)

    self.icon4 = display.newSprite("#safebox_icon.png"):pos(LEFT + 16 + 36.5 + 10, 0):addTo(self.box4)

    self.title4 = display.newTTFLabel({text=bm.LangUtil.getText("CRASH", "LOSE_ALL"), size=24, color=cc.c3b(0xff, 0xff, 0xff), align=ui.TEXT_ALIGN_LEFT})    
    self.title4:pos(LEFT + 16 + 36.5 + 10 + 36.5 + self.title3:getContentSize().width / 2 + 10, 0 + self.title3:getContentSize().height / 2):addTo(self.box4)

    self.chips4 = display.newTTFLabel({text="  ", size=24, color=cc.c3b(109, 183, 0), align=ui.TEXT_ALIGN_LEFT})
    tmpWidth = self.chips4:getContentSize().width
    self.chips4:pos(LEFT + 16 + 36.5 + 10 + 36.5 + tmpWidth / 2 + 10, 0 - self.chips4:getContentSize().height / 2):addTo(self.box4)

    self.info4 = display.newTTFLabel({text=bm.LangUtil.getText("CRASH", "GET_BANK_MONEY"), size=24, color=cc.c3b(0x1e, 0x9e, 0xe8), align=ui.TEXT_ALIGN_LEFT})
    self.info4:pos(LEFT + 16 + 36.5 + 10 + 36.5 + tmpWidth / 2 + 10 + tmpWidth + self.info4:getContentSize().width / 2 - 30, 0 - self.chips4:getContentSize().height / 2):addTo(self.box4)
    
    self.actionBtn4 = cc.ui.UIPushButton.new({normal= "#common_dark_blue_btn_up.png", pressed = "#common_dark_blue_btn_down.png"},{scale9 = true})
        :setButtonSize(140, 50)
        :setButtonLabel(display.newTTFLabel({text=bm.LangUtil.getText("CRASH", "OPEN_BANK"), size=24, color=cc.c3b(0xff, 0xff, 0xff), align=ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked(handler(self, self.onOpenBank_))
        :pos(RIGHT - 140 / 2 - 16 - 10, 0)
        :addTo(self.box4)


    if self.isPretendBankrupt_ then
        self:showBox4_()
    else
        if (self.subsidizeChips_ == 0) or (self.times_ >= self.limitedTimes_) then
            self:showBox3_()
        end
    end

    
end

function UserCrash:showPayItem_(itemDatas)
    if #itemDatas < 2 then
        return
    end
    -- 取第一个 和 最后一个
    local data = {}
    data[1] = itemDatas[1]
    data[2] = itemDatas[#itemDatas]


    self.payData_ = data
    -- 支付
    --left 
    display.newScale9Sprite("#common_input_bg.png", 0, 0, cc.size(WIDTH - 16 * 2, 180))
        :pos(0, TOP - 50 - 41 - 15 - 82 - 10 - 41 - 90 - 20)
        :addTo(self)
    cc.ui.UIPushButton.new({normal= "#crash_product_chip_bg.png", pressed = "#crash_product_chip_bg.png"},{scale9 = true})
        :setButtonSize(WIDTH / 2 - 30, 160)
        :pos(LEFT + (WIDTH / 2 - 30) / 2 + 16 + 10 , TOP - 50 - 41 - 15 - 82 - 10 - 41 - 90 - 20)
        :onButtonClicked(handler(self, self.onGoStoreHandler1_))
        :addTo(self)

    local paymentFlagLeftTop = display.newSprite("#crash_product_chip_tips.png")
        :pos(LEFT + (WIDTH / 2 - 30) / 2 + 16 + 10 - (WIDTH / 2 - 30) / 2 + 35, TOP - 50 - 41 - 15 - 82 - 10 - 41 - 90 - 20 + 80 - 36)
        :addTo(self)
    display.newSprite("#store_prd_101.png")
        :pos(LEFT + (WIDTH / 2 - 30) / 2 + 16 + 10 - (WIDTH / 2 - 30) / 2 + 34 + 40, TOP - 50 - 41 - 15 - 82 - 10 - 41 - 90 - 20):scale(1.2)
        :addTo(self)

    local text = display.newTTFLabel({text=bm.LangUtil.getText("CRASH", "PRODUCT", (data[1].title or ""), data[1].priceLabel), size = 30, color=cc.c3b(109, 183, 0), align=ui.TEXT_ALIGN_LEFT})
    text:pos(LEFT + (WIDTH / 2 - 30) / 2 + 16 + 10 +  35, TOP - 50 - 41 - 15 - 82 - 10 - 41 - 90 - 20):addTo(self)
    
    if data[1].discount ~= 1 then
        --todo
        paymentFlagLeftTop:setSpriteFrame(display.newSpriteFrame("crash_bgProduct_chip_dis.png"))

        display.newTTFLabel({text = string.format("%+d%%",  math.round((data[1].discount - 1) * 100)), size = 16, color = cc.c3b(0x01, 0x45, 0x17), align = ui.TEXT_ALIGN_CENTER})
            :pos(paymentFlagLeftTop:getPositionX() - 8, paymentFlagLeftTop:getPositionY() + 8)
            :addTo(self, 1)
            :rotation(- 45)

        text:setString(bm.LangUtil.getText("CRASH", "PRODUCT", bm.LangUtil.getText("STORE", "FORMAT_CHIP", bm.formatBigNumber(data[1].chipNumOff)), data[1].priceLabel))

        local chipsOffOrign = display.newTTFLabel({text = data[1].title or "", size = 32, color = cc.c3b(0xca, 0xca, 0xca), align = ui.TEXT_ALIGN_LEFT})
            :pos(LEFT + (WIDTH / 2 - 30) / 2 + 16 + 10 +  35, TOP - 50 - 41 - 15 - 82 - 10 - 41 - 90 - 20 + 52)
            :addTo(self)

        local chipsOffOrignDeleteLine = display.newRect(1, 2, {fill=true, fillColor=cc.c4f(0xF9 / 0xff, 0xBA / 0xff, 0x22 / 0xff, 1)})
        chipsOffOrignDeleteLine:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER])
        chipsOffOrignDeleteLine:pos(LEFT + (WIDTH / 2 - 30) / 2 + 16 + 10 +  35, TOP - 50 - 41 - 15 - 82 - 10 - 41 - 90 - 20 + 52)
            :addTo(self)
        chipsOffOrignDeleteLine:setScaleX(chipsOffOrign:getContentSize().width)
    end

    -- right
    cc.ui.UIPushButton.new({normal= "#crash_product_chip_bg.png", pressed = "#crash_product_chip_bg.png"},{scale9 = true})
        :setButtonSize(WIDTH / 2 - 30, 160)   
        :pos(RIGHT - ((WIDTH / 2 - 30) / 2 + 16 + 10) , TOP - 50 - 41 - 15 - 82 - 10 - 41 - 90 - 20)
        :onButtonClicked(handler(self, self.onGoStoreHandler2_))
        :addTo(self)

    local paymentFlagLeftTop = display.newSprite("#crash_product_chip_tips.png")
        :pos(RIGHT - ((WIDTH / 2 - 30) / 2 + 16 + 10) - (WIDTH / 2 - 30) / 2 + 35, TOP - 50 - 41 - 15 - 82 - 10 - 41 - 90 - 20 + 80 - 36)
        :addTo(self)
    
    display.newSprite("#store_prd_103.png")
        :pos(RIGHT - ((WIDTH / 2 - 30) / 2 + 16 + 10) - (WIDTH / 2 - 30) / 2 + 34 + 40, TOP - 50 - 41 - 15 - 82 - 10 - 41 - 90 - 20):scale(1.2)
        :addTo(self)

    local text = display.newTTFLabel({text=bm.LangUtil.getText("CRASH", "PRODUCT", (data[2].title or ""), data[2].priceLabel), size=32, color=cc.c3b(109, 183, 0), align=ui.TEXT_ALIGN_LEFT})
    text:pos(RIGHT - ((WIDTH / 2 - 30) / 2 + 16 + 10) + 35, TOP - 50 - 41 - 15 - 82 - 10 - 41 - 90 - 20):addTo(self)

    if data[2].discount ~= 1 then
        --todo
        paymentFlagLeftTop:setSpriteFrame(display.newSpriteFrame("crash_bgProduct_chip_dis.png"))

        display.newTTFLabel({text = string.format("%+d%%",  math.round((data[2].discount - 1) * 100)), size = 16, color = cc.c3b(0x01, 0x45, 0x17), align = ui.TEXT_ALIGN_CENTER})
            :pos(paymentFlagLeftTop:getPositionX() - 8, paymentFlagLeftTop:getPositionY() + 8)
            :addTo(self, 1)
            :rotation(- 45)

        text:setString(bm.LangUtil.getText("CRASH", "PRODUCT", bm.LangUtil.getText("STORE", "FORMAT_CHIP", bm.formatBigNumber(data[2].chipNumOff)), data[2].priceLabel))

        local chipsOffOrign = display.newTTFLabel({text = data[2].title or "", size = 32, color = cc.c3b(0xca, 0xca, 0xca), align = ui.TEXT_ALIGN_LEFT})
            :pos(RIGHT - ((WIDTH / 2 - 30) / 2 + 16 + 10) +  35, TOP - 50 - 41 - 15 - 82 - 10 - 41 - 90 - 20 + 52)
            :addTo(self)

        local chipsOffOrignDeleteLine = display.newRect(1, 2, {fill=true, fillColor=cc.c4f(0xF9 / 0xff, 0xBA / 0xff, 0x22 / 0xff, 1)})
        chipsOffOrignDeleteLine:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER])
        chipsOffOrignDeleteLine:pos(RIGHT - ((WIDTH / 2 - 30) / 2 + 16 + 10) +  35, TOP - 50 - 41 - 15 - 82 - 10 - 41 - 90 - 20 + 52)
            :addTo(self)
        chipsOffOrignDeleteLine:setScaleX(chipsOffOrign:getContentSize().width)
    end

    if device.platform == "android" or device.platform == "windows" then
        --todo
        text = display.newTTFLabel({text=bm.LangUtil.getText("CRASH", "BLUEPAY_TIP"), size=22, color=cc.c3b(143, 143, 143), align=ui.TEXT_ALIGN_LEFT})
        text:pos(LEFT + (WIDTH / 2 - 30) / 2 + 16 + 10, (TOP - 50 - 41 - 15 - 82 - 10 - 41 - 90 - 20) - 50):addTo(self)

        text = display.newTTFLabel({text=bm.LangUtil.getText("CRASH", "BLUEPAY_TIP"), size=22, color=cc.c3b(143, 143, 143), align=ui.TEXT_ALIGN_LEFT})
        text:pos(RIGHT - ((WIDTH / 2 - 30) / 2 + 16 + 10), (TOP - 50 - 41 - 15 - 82 - 10 - 41 - 90 - 20) - 50):addTo(self)
    end
end

-- 获取破产补助
function UserCrash:onGetCrashChips_()
    self.getCrashRequestId_ = nk.http.getBankruptcyReward(function(retData)
        if retData then

            -- dump(retData, "getBankruptcyReward.retData :===================")
            local addmoney = checkint(retData.addmoney or retData.addMoney)
            local money = checkint(retData.money)
            local times = checkint(retData.times)
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("CRASH", "GET_REWARD", addmoney))
          
            nk.userData["aUser.money"] = money
            nk.userData.bankruptcyGrant.bankruptcyTimes = times; 
            self:showBox3_()

        end

    end,function(errData)
        -- dump(errData, "getBankruptcyReward.errData :===================")
        self.getCrashRequestId_ = nil
    end)

    -- do return end
    -- nk.TopTipManager:showTopTip(bm.LangUtil.getText("CRASH", "GET_REWARD", self.subsidizeChips_))
    -- self:showBox3_()
end

function UserCrash:showBox4_()
    self.box1:removeSelf()
    -- self.box2:pos(0, TOP - 50 - 41 - 15)
    self.box4:pos(0, TOP - 50 - 41 - 15)
    self.box4:show()
end

function UserCrash:showBox3_()
    self.box1:removeSelf()
    self.box2:pos(0, TOP - 50 - 41 - 15)
    self.box3:show()
end

function UserCrash:onInvite_()
    self:reportData_("crash_invite","crash invite")
    InvitePopup.new():show()
end

function UserCrash:onReCall_()
    self:reportData_("crash_recall","crash recall")
    InvitePopup.new(nil, 2):show()
end

function UserCrash:onOpenBank_()
    self:reportData_("crash_openbank","crash openbank")
    UserInfoPopup.new(4):show(self.inRoom_)
end

function UserCrash:onGoStoreHandler1_()
    self:reportData_("crash_gostore1","crash gostore1")
    self.quickPay_:makePurchase(PURCHASE_TYPE.BLUE_PAY,self.payData_[1].pid,self.payData_[1])
end

function UserCrash:onGoStoreHandler2_()
    self:reportData_("crash_gostore2","crash gostore2")
    self.quickPay_:makePurchase(PURCHASE_TYPE.BLUE_PAY,self.payData_[2].pid,self.payData_[2])
end

function UserCrash:reportData_(id,dataLabel)
    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand{command = "event",
            args = {eventId = id , label = dataLabel}}
    end
end

function UserCrash:hide()
    self:hidePanel_()
end

function UserCrash:show()    
    self:showPanel_()
end



function UserCrash:onCleanup()
    if self.getCrashRequestId_ then
        nk.http.cancel(self.getCrashRequestId_)
    end
    self.getCrashRequestId_ = nil

    if self.quickPay_ then
        self.quickPay_:autoDispose()
    end
end

function UserCrash:onEnter()
end

function UserCrash:onExit()
end

return UserCrash
