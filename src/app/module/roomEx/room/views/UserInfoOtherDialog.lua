--
-- Author: tony
-- Date: 2014-08-04 11:30:13
--

local WIDTH = 808
local HEIGHT = 486
local LEFT = -WIDTH * 0.5
local TOP = HEIGHT * 0.5
local RIGHT = WIDTH * 0.5
local BOTTOM = -HEIGHT * 0.5



-- local StorePopup = import("app.module.store.StorePopup")
local GiftStorePopup = import("app.module.store.GiftStorePopup")
local UserInfoOtherDialog = class("UserInfoOtherDialog", function() return nk.ui.Panel.new({WIDTH, HEIGHT}) end)

function UserInfoOtherDialog:ctor(ctx)
    display.addSpriteFrames("user_other_info.plist", "user_other_info.png")
    
    self:setNodeEventEnabled(true)
    self.ctx = ctx

    local LEFT_BG_WIDTH = 209
    local BOTTOM_BG_WIDTH = 545
    local BOTTOM_BG_HEIGHT = 229
    self.background_:hide()
    self.bg_ = display.newSprite("#otherinfo_bg.png"):addTo(self)
    display.newSprite("#otherinfo_left_bg.png"):addTo(self)
    :pos(-WIDTH/2+LEFT_BG_WIDTH/2+10,0)
    self.bg_:setTouchEnabled(true)
    self.bg_:setTouchSwallowEnabled(true)
    display.newSprite("#otherinfo_bottom_bg.png"):addTo(self)
    :pos(WIDTH/2-BOTTOM_BG_WIDTH/2-32,-HEIGHT/2+BOTTOM_BG_HEIGHT/2+30)

    local winRateText = ui.newTTFLabel({size=24,text="胜率:", color=cc.c3b(0x94, 0x91, 0xbc)})
    :addTo(self)
    :pos(LEFT + 300, TOP - 47 )

    local rateSize = winRateText:getContentSize()
    --胜率
    self.winRate_ = ui.newTTFLabel({size=24, color=cc.c3b(0xcd, 0x9f, 0x21)})
    self.winRate_:setAnchorPoint(cc.p(0, 0.5))
    self.winRate_:pos(LEFT + 300 + rateSize.width/2+10, TOP - 47)
    self.winRate_:align(display.LEFT_CENTER)
    self.winRate_:addTo(self)
    self.winRate_:setString("99%")

    --排名
    local rankText = ui.newTTFLabel({size=24,text="排名:", color=cc.c3b(0x94, 0x91, 0xbc)})
    :addTo(self)
    :pos(LEFT + 470, TOP - 47 )
    local rankSize = rankText:getContentSize()

    self.ranking_ = ui.newTTFLabel({size=24, color=cc.c3b(0xcd, 0x9f, 0x21)})
    self.ranking_:setAnchorPoint(cc.p(0, 0.5))
    self.ranking_:pos(LEFT + 470 + rankSize.width/2+10, TOP - 47)
    self.ranking_:addTo(self)
    self.ranking_:align(display.LEFT_CENTER)
    self.ranking_:setString(">10000")

    --头像背景
    self.headImgMaleBg_ = display.newScale9Sprite("#user_info_avatar_bg.png", LEFT + 12 + 60+40, TOP - 12 - 60-45, CCSize(156, 156)):addTo(self)
    self.headImgFemaleBg_ = display.newScale9Sprite("#user_info_avatar_bg.png", LEFT + 12 + 60+40, TOP - 12 - 60-45, CCSize(156, 156)):addTo(self):hide()
    --头像剪裁容器
    self.headImageLoaderId_ = nk.ImageLoader:nextLoaderId()
    self.headImgContainer_ = cc.ClippingNode:create()
    local stencil = display.newDrawNode()
    local pn = {{-73, -73}, {-73, 73}, {73, 73}, {73, -73}}  
    local clr = cc.c4f(255, 0, 0, 255)  
    stencil:drawPolygon(pn, clr, 1, clr)
    self.headImgContainer_:setStencil(stencil)
    self.headImgContainer_:pos(self.headImgMaleBg_:getPositionX(), self.headImgMaleBg_:getPositionY())
    self.headImgContainer_:addTo(self)

    --UID
    self.uid_ = ui.newTTFLabel({size=18, color=cc.c3b(0xa9, 0xa7, 0xa7)})
    self.uid_:setAnchorPoint(cc.p(0, 0.5))
    self.uid_:pos(LEFT + 12 + 20, TOP - 210)
    self.uid_:addTo(self)

    --等级
    self.level_ = ui.newTTFLabel({size=18, color=cc.c3b(0xcd, 0x9f, 0x21)})
    self.level_:setAnchorPoint(cc.p(0, 0.5))
    self.level_:pos(LEFT + 12 + 20+110, TOP - 210)
    self.level_:addTo(self)

    --昵称
    self.nick_ = ui.newTTFLabel({size=24, color=cc.c3b(0xf1, 0xe8, 0xdf)})
    self.nick_:setAnchorPoint(cc.p(0, 0.5))
    self.nick_:pos(LEFT + 12 + 40, TOP - 240)
    self.nick_:addTo(self)

    --性别
    self.femaleIcon = display.newSprite("#otherinfo_girl.png")
    self.femaleIcon:pos(LEFT + 12 + 20, TOP - 240)
    self.femaleIcon:addTo(self)
    self.femaleIcon:rotation(60)
    self.femaleIcon:hide()

    self.maleIcon = display.newSprite("#otherinfo_boy.png")
    self.maleIcon:pos(LEFT + 12 + 20, TOP - 240)
    self.maleIcon:addTo(self)
    self.maleIcon:rotation(60)
    self.maleIcon:hide()

     --加好友按钮
    self.isAddFriend_ = true
    self.addFriendBtn_ = cc.ui.UIPushButton.new({
                normal="#otherinfo_add_friend_up.png",
                pressed="#otherinfo_add_friend_down.png",
                disabled="#otherinfo_add_friend_ena.png",
            }, {scale9=false})
        --:setButtonSize(122, 47)
        :setButtonLabel(ui.newTTFLabel({text=bm.LangUtil.getText("ROOM", "ADD_FRIEND"), size=22, color=cc.c3b(0xFF, 0xFF, 0xFF)}))
        :onButtonClicked(buttontHandler(self, self.onFriendClicked_))
        :pos(LEFT + 12 + 100, TOP - 290)
        :setButtonEnabled(false)
        :addTo(self)

    display.newSprite("#otherinfo_chip_icon.png")
    :addTo(self)
    :pos(LEFT + 12 + 30, TOP - 345)

    display.newSprite("#otherinfo_cash_icon.png")
    :addTo(self)
    :pos(LEFT + 12 + 30, TOP - 390)

    display.newSprite("#otherinfo_score_icon.png")
    :addTo(self)
    :pos(LEFT + 12 + 30, TOP - 435)

    --筹码
    self.chip_ = ui.newTTFLabel({size=24, color=cc.c3b(0xe7, 0xdf, 0xd6)})
    self.chip_:setAnchorPoint(cc.p(0, 0.5))
    self.chip_:pos(LEFT + 12 + 50, TOP - 345)
    self.chip_:addTo(self)
    --现金币
    self.cash_ = ui.newTTFLabel({size=24, color=cc.c3b(0xe7, 0xdf, 0xd6)})
    self.cash_:setAnchorPoint(cc.p(0, 0.5))
    self.cash_:pos(LEFT + 12 + 50, TOP - 390)
    self.cash_:addTo(self)
    --比赛积分
    self.score_ = ui.newTTFLabel({size=24, color=cc.c3b(0xe7, 0xdf, 0xd6)})
    self.score_:setAnchorPoint(cc.p(0, 0.5))
    self.score_:pos(LEFT + 12 + 50, TOP - 435)
    self.score_:addTo(self)

    local roomData = nk.getRoomDataByLevel(self.ctx.model.roomInfo.roomType)
    if not roomData and self.ctx.model.roomInfo.roomType == consts.ROOM_TYPE.PERSONAL_NORMAL then
        local roomInfo = self.ctx.model.roomInfo
        roomData = {}
        roomData.minBuyIn = roomInfo.minBuyIn
        roomData.maxBuyIn = roomInfo.maxBuyIn
        roomData.roomType = roomInfo.roomType
        roomData.blind = roomInfo.blind
        roomData.sendChips = {500,2000,5000,20000}
    end
    self.sendChipBtn1_ = cc.ui.UIPushButton.new("#otherinfo_btn_green.png")
        :setButtonLabel(ui.newTTFLabel({text=""..bm.formatBigNumber(roomData.sendChips[1]), size=24, color=styles.FONT_COLOR.LIGHT_TEXT}))
        :setButtonLabelOffset(0, -2)
        :onButtonPressed(function(event) end)
        :onButtonRelease(function(event) end)
        :onButtonClicked(function(event)
                nk.SoundManager:playSound(nk.SoundManager.CLICK_BUTTON)
                self:sendChipClicked_(roomData.sendChips[1])
            end)
        :pos(LEFT + 325, TOP - 126)
        :addTo(self)

    --绿色筹码按钮2
    self.sendChipBtn2_ = cc.ui.UIPushButton.new("#otherinfo_btn_red.png")
        :setButtonLabel(ui.newTTFLabel({text=""..bm.formatBigNumber(roomData.sendChips[2]), size=24, color=styles.FONT_COLOR.LIGHT_TEXT}))
        :setButtonLabelOffset(0, -2)
        :onButtonPressed(function(event) end)
        :onButtonRelease(function(event) end)
        :onButtonClicked(function(event)
                nk.SoundManager:playSound(nk.SoundManager.CLICK_BUTTON)
                self:sendChipClicked_(roomData.sendChips[2])
            end)
        :pos(LEFT + 325 + 110, TOP - 126)
        :addTo(self)

    --红色筹码按钮1
    self.sendChipBtn3_ = cc.ui.UIPushButton.new("#otherinfo_btn_yellow.png")
        :setButtonLabel(ui.newTTFLabel({text=""..bm.formatBigNumber(roomData.sendChips[3]), size=24, color=styles.FONT_COLOR.LIGHT_TEXT}))
        :setButtonLabelOffset(0, -2)
        :onButtonPressed(function(event) end)
        :onButtonRelease(function(event) end)
        :onButtonClicked(function(event)
                nk.SoundManager:playSound(nk.SoundManager.CLICK_BUTTON)
                self:sendChipClicked_(roomData.sendChips[3])
            end)
        :pos(LEFT + 325 + 110 * 2, TOP - 126)
        :addTo(self)

    --红色筹码按钮2
    self.sendChipBtn4_ = cc.ui.UIPushButton.new("#otherinfo_btn_zi.png")
        :setButtonLabel(ui.newTTFLabel({text=""..bm.formatBigNumber(roomData.sendChips[4]), size=24, color=styles.FONT_COLOR.LIGHT_TEXT}))
        :setButtonLabelOffset(0, -2)
        :onButtonPressed(function(event) end)
        :onButtonRelease(function(event) end)
        :onButtonClicked(function(event)
                nk.SoundManager:playSound(nk.SoundManager.CLICK_BUTTON)
                self:sendChipClicked_(roomData.sendChips[4])
            end)
        :pos(LEFT + 325 + 110 * 3, TOP - 126)
        :addTo(self)


    local x, y = LEFT + 80+210, BOTTOM + 134+60
    for i = 1, 2 do
        for j = 1, 5 do
            local id = (i - 1) * 5 + j
            local btn = cc.ui.UIPushButton.new({normal="#common_modTransparent.png", normal = "#user_info_other_hddj_item_up_bg.png",pressed="#user_info_other_hddj_item_down_bg.png"}, {scale9=true})
                :setButtonSize(80, 60)
                :onButtonClicked(function()
                        nk.SoundManager:playSound(nk.SoundManager.CLICK_BUTTON)
                        self:sendHddjClicked_(id)
                    end)
                :pos(x, y)
                :addTo(self)
            if id == 1 then
                btn:setButtonLabel(display.newSprite("#hddj_egg_icon.png"))
            elseif id == 10 then
                btn:setButtonLabel(display.newSprite("#hddj_tissue_icon.png"):scale(1.1))
            elseif id == 4 then
                btn:setButtonLabel(display.newSprite("#hddj_kiss_lip_icon.png"):scale(1.3))
            elseif id == 5 then
                btn:setButtonLabel(display.newSprite("#hddj_" .. id .. ".png"):scale(0.75))
            elseif id == 6 then
                btn:setButtonLabel(display.newSprite("#hddj_" .. id .. ".png"):scale(0.5))
            elseif id == 7 then
                btn:setButtonLabel(display.newSprite("#hddj_" .. id .. ".png"):scale(1.4))
            elseif id == 8 then
                btn:setButtonLabel(display.newSprite("#hddj_" .. id .. ".png"):scale(0.9))
            else
                btn:setButtonLabel(display.newSprite("#hddj_" .. id .. ".png"):scale(0.6))
            end
            x = x + 105
        end
        x = LEFT + 82+210
        y = y - 105
    end
     self:loadFriendUidList()
end
function UserInfoOtherDialog:loadFriendUidList()

    -- dump(nk.userData.friendUidList, "nk.userData.friendUidList:=================")
    if not nk.userData.friendUidList then
        self.addFriendBtn_:setButtonEnabled(false)
        self.getHallFriendRequestId_ = nk.http.getHallFriendList(
            function(data)

                -- dump(data, "getHallFriendList.data:=================")
                local uidList = {}
                local arr = data
                if arr then
                    for i, v in ipairs(arr) do
                        -- uidList[#uidList + 1] = v.fid

                        uidList[#uidList + 1] = tostring(v.fid)
                    end
                end
                nk.userData.friendUidList = uidList
                self:setAddFriendStatus()
            end,

            function()
                print("load friend uid list fail")
            end)
    end

end
function UserInfoOtherDialog:setAddFriendStatus()
    -- dump(self.data_, "setAddFriendStatus:self.data_:=====================")
    -- dump(nk.userData.friendUidList, "setAddFriendStatus:nk.userData.friendUidList:===================")

    if self.data_ and nk.userData.friendUidList then
        self.addFriendBtn_:setButtonEnabled(true)
        if not table.indexof(nk.userData.friendUidList, tostring(self.data_.uid)) then
            self.addFriendBtn_:setButtonImage("normal", "#otherinfo_add_friend_up.png", true)
            self.addFriendBtn_:setButtonImage("pressed", "#otherinfo_add_friend_down.png", true)
            self.addFriendBtn_:setButtonLabelString(bm.LangUtil.getText("ROOM", "ADD_FRIEND"))
            self.isAddFriend_ = true
        else
            self.addFriendBtn_:setButtonImage("normal", "#otherinfo_del_friend_up.png", true)
            self.addFriendBtn_:setButtonImage("pressed", "#otherinfo_del_friend_down.png", true)
            self.addFriendBtn_:setButtonLabelString(bm.LangUtil.getText("ROOM", "DEL_FRIEND"))
            self.isAddFriend_ = false
        end
    end
end
function UserInfoOtherDialog:show(data)
    self:setData(data)
    self:showPanel_(true, true, true, true)
end
function UserInfoOtherDialog:hide()
    if self.rankingRequestId_ then
        nk.http.cancel(self.rankingRequestId_)
    end
    if self.hddjNumObserverId_ then
        bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "hddjNum", self.hddjNumObserverId_)
        self.hddjNumObserverId_ = nil
    end
    nk.ImageLoader:cancelJobByLoaderId(self.headImageLoaderId_)
    self:hidePanel_()
end
function UserInfoOtherDialog:setData(data)
    self.data_ = data
    

    if data.gender == 2 or data.gender == 0 then
            self.femaleIcon:show()
            self.maleIcon:hide()
            self:setImage_(display.newSprite("#common_female_avatar.png"))
    else
            self.femaleIcon:hide()
            self.maleIcon:show()
            self:setImage_(display.newSprite("#common_male_avatar.png"))
    end

    local rate =  data.userInfo.mwin +  data.userInfo.mlose > 0 and math.round(data.userInfo.mwin * 100 / (data.userInfo.mwin + data.userInfo.mlose)) or 0
    self.winRate_:setString(""..rate.."%")
    self.nick_:setString(nk.Native:getFixedWidthText("", 24, data.userInfo.name, 150))
    self.uid_:setString(bm.LangUtil.getText("ROOM", "INFO_UID", data.userId or data.uid))
    self.chip_:setString(bm.formatBigNumber(data.userInfo.money or 0))
    self.cash_:setString(data.userInfo.cash or 0)
    self.score_:setString(data.userInfo.point or 0)

    if data.userInfo.rankMoney then
        if data.userInfo.rankMoney > 10000 then
            self.ranking_:setString(">10,000")
        else
            self.ranking_:setString(bm.formatNumberWithSplit(data.userInfo.rankMoney or 0))
        end
    else
        self.ranking_:setString(bm.LangUtil.getText("ROOM", "INFO_RANKING", ".."))
        if self.rankingRequestId_ then
            nk.http.cancel(self.rankingRequestId_)
        end

        self.rankingRequestId_ = nk.http.getMemberInfo(data.uid,
                function(callData)
                    do return end
                    if callData then
                            self.data_.chips = tonumber(callData.aUser.money) or self.data_.chips or 0
                            self.data_.level = tonumber(callData.aUser.mlevel) or nk.Level:getLevelByExp(self.data_.exp)
                            self.data_.win = tonumber(callData.aUser.win) or self.data_.userInfo.mwin
                            self.data_.lose = tonumber(callData.aUser.lose) or self.data_.userInfo.mlose
                            callData.rankMoney = tonumber(callData.aBest.rankMoney) or nk.userData["aBest.rankMoney"] or 0
                            self.data_.ranking = tonumber(callData.rankMoney) or self.data_.ranking or 0

                            self.chip_:setString(bm.formatBigNumber(callData.aUser.money))
                            self.level_:setString(T("Lv.%d",callData.aUser.mlevel))
                            self.winRate_:setString(bm.LangUtil.getText("ROOM", "INFO_WIN_RATE", callData.aUser.win + callData.aUser.lose > 0 and math.round(callData.aUser.win * 100 / (callData.aUser.win + callData.aUser.lose)) or 0))
                            if callData.rankMoney > 10000 then
                                self.ranking_:setString(bm.LangUtil.getText("ROOM", "INFO_RANKING", ">10,000"))
                            else
                                self.ranking_:setString(bm.LangUtil.getText("ROOM", "INFO_RANKING", bm.formatNumberWithSplit(callData.rankMoney)))
                            end
                        end

                end,function()
                     self.rankingRequestId_ = nil
                        self.ranking_:setString(bm.LangUtil.getText("ROOM", "INFO_RANKING", "-"))
                end
        )
    end
    self.level_:setString(bm.LangUtil.getText("ROOM", "INFO_LEVEL", data.userInfo.mlevel or nk.Level:getLevelByExp(data.userInfo.mexp)))
    local imgurl = data.userInfo.mavatar or ""
    if string.find(imgurl, "facebook") then
        if string.find(imgurl, "?") then
            imgurl = imgurl .. "&width=180&height=180"
        else
            imgurl = imgurl .. "?width=180&height=180"
        end
    end
    nk.ImageLoader:loadAndCacheImage(self.headImageLoaderId_,
            imgurl, 
            handler(self, self.imageLoadCallback_),
            nk.ImageLoader.CACHE_TYPE_USER_HEAD_IMG)

     self:setAddFriendStatus()
end
function UserInfoOtherDialog:imageLoadCallback_(success, sprite)
    if success then
        self:setImage_(sprite)
    elseif self.data_ and (self.data_.gender == 2 or self.data_.gender == 0) then
        self:setImage_(display.newSprite("#common_female_avatar.png"))
    else
        self:setImage_(display.newSprite("#common_male_avatar.png"))
    end
end
function UserInfoOtherDialog:setImage_(sprite)
    local img = self.headImgContainer_:getChildByTag(1)
    if img then
        img:removeFromParent()
    end
    local spsize = sprite:getContentSize()
    if spsize.width > spsize.height then
        sprite:scale(146 / spsize.width)
    else
        sprite:scale(146 / spsize.height)
    end
    spsize = sprite:getContentSize()
    local seatSize = self:getContentSize()
    
    sprite:pos(seatSize.width * 0.5, seatSize.height * 0.5):addTo(self.headImgContainer_, 1, 1)
end
function UserInfoOtherDialog:sendChipClicked_(chips)
    if self.ctx.model:isSelfInSeat() then
        local roomData = nk.getRoomDataByLevel(self.ctx.model.roomInfo.roomType)

        if not roomData and self.ctx.model.roomInfo.roomType == consts.ROOM_TYPE.PERSONAL_NORMAL then
            local roomInfo = self.ctx.model.roomInfo
            roomData = {}
            roomData.minBuyIn = roomInfo.minBuyIn
            roomData.maxBuyIn = roomInfo.maxBuyIn
            roomData.roomType = roomInfo.roomType
            roomData.blind = roomInfo.blind
            roomData.sendChips = {500,2000,5000,20000}
        end

        if not roomData then 
            return;
        end
        
        if (nk.userData["aUser.money"] -  chips ) > roomData.minBuyIn then
               nk.http.sendCoinForRoomEx(nk.userData.uid,self.data_.uid, chips,1,self.ctx.model.roomInfo.blind,
                   function (data)
                    -- dump(data,"senddata")
                      self.data_.userInfo.money = self.data_.userInfo.money + chips;
                      nk.server:sendCoinForRoomPlayer(self.data_.seatId, chips);
                      self:hide();
                   end,
                   function (errData)
                    -- dump(errData,"senddataerr")  
                    if errData and errData.errorCode then
                        if errData.errorCode == -7 then--送得太频繁
                            nk.TopTipManager:showTopTip(bm.LangUtil.getText("ROOM", "SEND_CHIP_TOO_OFTEN"))
                        end
                        if errData.errorCode == -6 then--金币不够
                            nk.TopTipManager:showTopTip(bm.LangUtil.getText("ROOM", "SEND_CHIP_NOT_ENOUGH_CHIPS"))
                        end
                        if errData.errorCode == -5 then
                            nk.TopTipManager:showTopTip(bm.LangUtil.getText("ROOM", "SEND_CHIP_NOT_ENOUGH_CHIPS"))
                        end
                    end
                end
            )
        end
    else
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("ROOM", "SEND_CHIP_NOT_IN_SEAT"))
    end
end

function UserInfoOtherDialog:sendHddjClicked_(hddjId)
    local roomType = self.ctx.model:roomType()
    if self.ctx.model:roomType() == consts.ROOM_TYPE.TOURNAMENT  then
        --比赛场不能发送互动道具
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("ROOM", "SEND_HDDJ_IN_MATCH_ROOM_MSG"))
    else
        if self.ctx.model:isSelfInSeat() then
            self.sendHddjId_ = hddjId
            if nk.userData.hddjNum then
                self:doSendHddj()
            else
                self.hddjNumObserverId_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "hddjNum", handler(self, self.doSendHddj))
                bm.EventCenter:dispatchEvent(nk.eventNames.ROOM_LOAD_HDDJ_NUM)
            end
        else
            --不在座位不能发送互动道具
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("ROOM", "SEND_HDDJ_NOT_IN_SEAT"))
        end
    end
end
function UserInfoOtherDialog:doSendHddj()
    if nk.userData.hddjNum then
        if self.hddjNumObserverId_ then
            bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "hddjNum", self.hddjNumObserverId_)
            self.hddjNumObserverId_ = nil
        end
        if nk.userData.hddjNum > 0 then
            self:sendHddjAndHide_()
        else
            --获取道具数量
        nk.http.getUserProps(2,function(pdata)
            if pdata then
                for _,v in pairs(pdata) do
                    if tonumber(v.pnid) == 2001 then
                        nk.userData.hddjNum = checkint(v.pcnter)
                        if nk.userData.hddjNum > 0 then
                            self:sendHddjAndHide_()
                        else
                            self:showHddjNotEnoughDialog_()
                         end

                        break
                    end
                end
            end
            
        end,function()
            
        end)

     
        end
    end
end
function UserInfoOtherDialog:sendHddjAndHide_()
    nk.userData.hddjNum = nk.userData.hddjNum - 1

    local pnid = 2001 --互动表情道具
    nk.http.useProps(pnid,function(callData)
        if callData and callData.propList and callData.propList.pcnter then
            nk.userData.hddjNum = checkint(callData.propList.pcnter)
        end
    end,function()
        
    end)


    nk.server:sendProp(self.sendHddjId_,{self.data_.seatId},pnid)
    self.ctx.animManager:playHddjAnimation(self.ctx.model:selfSeatId(), self.data_.seatId, self.sendHddjId_)
    self:hide()


end

function UserInfoOtherDialog:showHddjNotEnoughDialog_()
    nk.ui.Dialog.new({
        messageText = bm.LangUtil.getText("ROOM", "SEND_HDDJ_NOT_ENOUGH"), 
        firstBtnText = bm.LangUtil.getText("COMMON", "CANCEL"),
        secondBtnText = bm.LangUtil.getText("COMMON", "BUY"), 
        callback = function (type)
            if type == nk.ui.Dialog.SECOND_BTN_CLICK then
                self:hide()
                -- StorePopup.new(2, nil, 2):showPanel()
                GiftStorePopup.new(2):showPanel()
            end
        end
    }):show()
end
function UserInfoOtherDialog:onFriendClicked_(evt)
    if self.isAddFriend_ then
        self:onAddFriendClicked_(evt)
    else
        self:onDelFriendClicked_(evt)
    end
end

function UserInfoOtherDialog:onAddFriendClicked_(evt)
    if self.addFriendRequistId_ then
        return
    end
    
    self.addFriendBtn_:setButtonEnabled(false)

    self.addFriendRequistId_ = nk.http.addFriend(self.data_.uid, function(data)
        -- dump(data,"#### add friend ret:")
        self.addFriendRequistId_ = nil
        if data then
            if self.ctx.model:isSelfInSeat() then
                --自己在座位，广播加好友动画
                -- nk.socket.RoomSocket:sendAddFriend(self.ctx.model:selfSeatId(), self.data_.seatId)
                if self.data_ and (self.data_.seatId) then
                    nk.server:sendAddFriend(checkint(self.data_.seatId))
                end
                
            else
                --不在座位，只播放动画，别人看不到
                self.ctx.animManager:playAddFriendAnimation(-1, checkint(self.data_.seatId))
            end
            if nk.userData.friendUidList and not table.indexof(nk.userData.friendUidList, tostring(self.data_.uid)) then
                table.insert(nk.userData.friendUidList, tostring(self.data_.uid))
            end
            self:hide()
        elseif data == "-1" then
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("FRIEND", "TOO_MANY_FRIENDS_TO_ADD_FRIEND_MSG"))
            self:setAddFriendStatus()
        else
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("ROOM", "ADD_FRIEND_FAILED_MSG"))
            self:setAddFriendStatus()
        end
    end, function(errData)
        self.addFriendRequistId_ = nil
        if errData and errData.errorCode then
            if errData.errorCode == -2 then
                --已经添加过该好友
                nk.TopTipManager:showTopTip(bm.LangUtil.getText("ROOM", "ADD_FRIEND_FAILED_MSG"))
                self:setAddFriendStatus()

            elseif errData.errorCode == -3 then
                nk.TopTipManager:showTopTip(bm.LangUtil.getText("ROOM", "ADD_FRIEND_FAILED_MSG"))
                self:setAddFriendStatus()
            elseif errData.errorCode == -4 then
                --添加好友达到上限
                nk.TopTipManager:showTopTip(bm.LangUtil.getText("FRIEND", "TOO_MANY_FRIENDS_TO_ADD_FRIEND_MSG"))
                self:setAddFriendStatus()
            else
                nk.TopTipManager:showTopTip(bm.LangUtil.getText("ROOM", "ADD_FRIEND_FAILED_MSG"))
                self:setAddFriendStatus()
            end
        else
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("ROOM", "ADD_FRIEND_FAILED_MSG"))
            self:setAddFriendStatus()

        end
        
    end)

end

function UserInfoOtherDialog:onDelFriendClicked_(evt)
    if self.deleteFriendRequestId_ then
        return
    end

    self.addFriendBtn_:setButtonEnabled(false)
     self.deleteFriendRequestId_ = nk.http.deleteFriend(self.data_.uid,
        function (data)
            self.deleteFriendRequestId_ = nil
            local idx = nk.userData.friendUidList and table.indexof(nk.userData.friendUidList, tostring(self.data_.uid))
            if idx then
                table.remove(nk.userData.friendUidList, idx)
             end
             self:setAddFriendStatus()
        end,
        function()
            self.deleteFriendRequestId_ = nil
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("ROOM", "DEL_FRIEND_FAILED_MSG"))
            self:setAddFriendStatus()
        end

    )
end
function UserInfoOtherDialog:onCleanup()
    display.removeSpriteFramesWithFile("user_other_info.plist", "user_other_info.png")
    if self.addFriendRequistId_ then
        nk.http.cancel(self.addFriendRequistId_)
    end

    if self.deleteFriendRequestId_ then
        nk.http.cancel(self.deleteFriendRequestId_)
    end
    nk.http.cancel(self.getHallFriendRequestId_)

    nk.ImageLoader:cancelJobByLoaderId(self.adImgLoaderId_)
end
return UserInfoOtherDialog