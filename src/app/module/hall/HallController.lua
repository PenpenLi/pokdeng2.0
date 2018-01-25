--
-- Author: johnny@boomegg.com
-- Date: 2014-08-26 21:26:45
-- Copyright: Copyright (c) 2014, BOOMEGG INTERACTIVE CO., LTD All rights reserved.
-- Description: HallController.lua ReConstructed By Tsing7x.
--

local LoadGiftControl = import("app.module.store.LoadGiftControl")
local LoadLevelControl = import("app.util.LoadLevelControl")
local MessageData = import("app.module.message.MessageData")

local LoginRewardView = import("app.module.loginReward.LoginRewardView")
local RegisterAwardPopup = import("app.module.newer.RegisterAwardPopup")
local UserCrash = import("app.module.userCrash.UserCrash")
local PayGuidePopMgr = import("app.module.store.purchGuide.PayGuidePopMgr")
local PayGuide = import("app.module.store.purchGuide.PayGuide")
local FirChargePayGuidePopup = import("app.module.store.firChrgGuide.FirChrgPayGuidePopup")
local AgnChargePayGuidePopup = import("app.module.store.agnChrgGuide.AgnChrgPayGuidePopup")
local GrabDealerEnterLimitPopup = import("app.module.grabDealer.views.GrabDealerEnterLimitPopup")
local TicketTransferPopup = import("app.module.ticketTransfer.TicketTransferPopup")

local HallController = class("HallController")

local logger = bm.Logger.new("HallController")

HallController.FIRST_OPEN      = 0
HallController.LOGIN_GAME_VIEW = 1
HallController.MAIN_HALL_VIEW  = 2
HallController.CHOOSE_NOR_VIEW = 3
HallController.CHOOSE_PRO_VIEW = 4
HallController.CHOOSE_PERSONAL_NOR_VIEW = 5
HallController.CHOOSE_PERSONAL_POINT_VIEW = 6
HallController.CHOOSE_MATCH_NOR_VIEW = 7
HallController.CHOOSE_MATCH_PRO_VIEW = 8

HallController.SVR_LOGIN_OK_EVENT_TAG = 100
HallController.SVR_DOUBLE_LOGINUCC_EVENT_TAG = 101
HallController.SVR_ONLINE_EVENT_TAG = 102
HallController.SVR_LOGIN_ROOM_OK_EVENT_TAG = 103
HallController.SVR_LOGIN_ROOM_FAIL_EVENT_TAG = 104
HallController.SVR_ERROR_EVENT_TAG = 105
HallController.HALL_LOGOUT_SUCC_EVENT_TAG = 106
HallController.ENTER_ROOM_WITH_DATA_EVENT_TAG = 107

HallController.SVR_GET_PERSONAL_ROOM_LIST_EVENT_TAG = 108
HallController.SVR_LOGIN_PERSONAL_ROOM_TAG = 109
HallController.SVR_SEARCH_PERSONAL_ROOM_TAG = 110
HallController.SVR_CREATE_PERSONAL_ROOM_TAG = 111
HallController.SVR_COMMON_BROADCAST_TAG = 112 

HallController.ENTER_MATCH_WITH_DATA_EVENT_TAG = 113
HallController.SVR_LOGIN_OK_NEW_EVENT_TAG = 114
HallController.SVR_LOGIN_MATCH_ROOM_FAIL_EVENT_TAG = 115
HallController.SVR_LOGIN_MATCH_ROOM_OK_EVENT_TAG = 116
HallController.ENTER_GRAB_WITH_DATA_EVENT_TAG = 119
HallController.SVR_LOGIN_GRAB_ROOM_OK_EVENT_TAG = 120
HallController.SVR_LOGIN_GRAB_DELAER_ROOM_FAIL_EVENT_TAG = 121
HallController.SVR_LOGIN_OK_RE_CONECT_TAG = 122
HallController.SVR_GRAB_ROOM_LIST_RESULT_EVENT_TAG = 123
HallController.SVR_PUSH_MATCH_ROOM_EVENT_TAG = 124
HallController.SVR_TIME_MATCH_OFF_TAG = 125

HallController.SVR_SUONA_BROADCAST_RECV_TAG = 117
HallController.SVR_LOGIN_NEW_ROOM_OK_EVENT_TAG = 126

HallController.ANIM_TIME = 0.5

function HallController:ctor(scene)
    self.scene_ = scene    
    bm.EventCenter:addEventListener(nk.eventNames.SVR_LOGIN_OK, handler(self, self.onLoginServerSucc_), HallController.SVR_LOGIN_OK_EVENT_TAG)
    bm.EventCenter:addEventListener(nk.eventNames.SVR_DOUBLE_LOGIN, handler(self, self.onDoubleLoginError_), HallController.SVR_DOUBLE_LOGINUCC_EVENT_TAG)
    bm.EventCenter:addEventListener(nk.eventNames.SVR_ONLINE, handler(self, self.onOnline_), HallController.SVR_ONLINE_EVENT_TAG)
    bm.EventCenter:addEventListener(nk.eventNames.SVR_LOGIN_OK_NEW, handler(self, self.onLoginServerSuccNew_), HallController.SVR_LOGIN_OK_NEW_EVENT_TAG)
    bm.EventCenter:addEventListener(nk.eventNames.SVR_LOGIN_OK_RE_CONECT,handler(self, self.onReLoginServerSuccNew_), HallController.SVR_LOGIN_OK_RE_CONECT_TAG)
    bm.EventCenter:addEventListener(nk.eventNames.HALL_LOGOUT_SUCC, handler(self, self.handleLogoutSucc_), HallController.HALL_LOGOUT_SUCC_EVENT_TAG)
    bm.EventCenter:addEventListener(nk.eventNames.SVR_ERROR, handler(self, self.onServerFail_), HallController.SVR_ERROR_EVENT_TAG)

    bm.EventCenter:addEventListener(nk.eventNames.SVR_GRAB_ROOM_LIST_RESULT, handler(self, self.onGrabRoomlistResult), HallController.SVR_GRAB_ROOM_LIST_RESULT_EVENT_TAG)
    bm.EventCenter:addEventListener(nk.eventNames.SVR_GET_PERSONAL_ROOM_LIST, handler(self, self.onPersonalRoomListResult),
        HallController.SVR_GET_PERSONAL_ROOM_LIST_EVENT_TAG)
    bm.EventCenter:addEventListener(nk.eventNames.SVR_CREATE_PERSONAL_ROOM,handler(self, self.onCreatePersonalRoom), HallController.SVR_CREATE_PERSONAL_ROOM_TAG)
    bm.EventCenter:addEventListener(nk.eventNames.SVR_SEARCH_PERSONAL_ROOM,handler(self, self.onSearchPersonalRoom), HallController.SVR_SEARCH_PERSONAL_ROOM_TAG)
    bm.EventCenter:addEventListener(nk.eventNames.SVR_LOGIN_ROOM_OK, handler(self, self.onLoginRoomSucc_), HallController.SVR_LOGIN_ROOM_OK_EVENT_TAG)
    bm.EventCenter:addEventListener(nk.eventNames.SVR_LOGIN_ROOM_FAIL, handler(self, self.onLoginRoomFail_), HallController.SVR_LOGIN_ROOM_FAIL_EVENT_TAG)
    bm.EventCenter:addEventListener(nk.eventNames.ENTER_ROOM_WITH_DATA, handler(self, self.onEnterRoom_), HallController.ENTER_ROOM_WITH_DATA_EVENT_TAG)
    bm.EventCenter:addEventListener(nk.eventNames.ENTER_MATCH_WITH_DATA, handler(self, self.onEnterMatch_), HallController.ENTER_MATCH_WITH_DATA_EVENT_TAG)
    bm.EventCenter:addEventListener(nk.eventNames.ENTER_GRAB_DEALER_ROOM,handler(self, self.onEnterGrabDealer_), HallController.ENTER_GRAB_WITH_DATA_EVENT_TAG)
    bm.EventCenter:addEventListener(nk.eventNames.SVR_LOGIN_MATCH_ROOM_OK,handler(self, self.onLoginMatchRoomOk_), HallController.SVR_LOGIN_MATCH_ROOM_OK_EVENT_TAG)
    bm.EventCenter:addEventListener(nk.eventNames.SVR_LOGIN_MATCH_ROOM_FAIL,handler(self, self.onLoginMatchRoomFail_), HallController.SVR_LOGIN_MATCH_ROOM_FAIL_EVENT_TAG)
    bm.EventCenter:addEventListener(nk.eventNames.SVR_LOGIN_GRAB_ROOM_OK, handler(self, self.onLoginGrabRoomSucc_), HallController.SVR_LOGIN_GRAB_ROOM_OK_EVENT_TAG)
    bm.EventCenter:addEventListener(nk.eventNames.SVR_LOGIN_GRAB_DELAER_ROOM_FAIL, handler(self, self.onLoginGrabRoomFail_),
        HallController.SVR_LOGIN_GRAB_DELAER_ROOM_FAIL_EVENT_TAG)
    bm.EventCenter:addEventListener(nk.eventNames.SVR_PUSH_MATCH_ROOM, handler(self, self.onTimeMatchPush_ ), HallController.SVR_PUSH_MATCH_ROOM_EVENT_TAG)
    bm.EventCenter:addEventListener(nk.eventNames.SVR_TIME_MATCH_OFF, handler(self, self.timeMatchOff_), HallController.SVR_TIME_MATCH_OFF_TAG)
    bm.EventCenter:addEventListener(nk.eventNames.SVR_LOGIN_NEW_ROOM_OK, handler(self, self.onLoginNewRoomSucc_), HallController.SVR_LOGIN_NEW_ROOM_OK_EVENT_TAG)

    bm.EventCenter:addEventListener(nk.eventNames.SVR_COMMON_BROADCAST,handler(self, self.onBroadCast_), HallController.SVR_COMMON_BROADCAST_TAG)
	bm.EventCenter:addEventListener(nk.eventNames.SVR_SUONA_BROADCAST_RECV, handler(self, self.onSuonaBroadRecv_), HallController.SVR_SUONA_BROADCAST_RECV_TAG)

    self.isLoginInProgress_ = false
    self:bindDataObservers_()

    self.schedulerPool_ = bm.SchedulerPool.new()

    local umengReportTimeUsageDelayTime = 5
    self.schedulerPool_:delayCall(handler(self, self.umengUpdateTimeUsage), umengReportTimeUsageDelayTime)
end

-- Common Funcs --
function HallController:setDisplayView(view)
    self.view_ = view
end

function HallController:getAnimTime()
    return HallController.ANIM_TIME
end

function HallController:getBgScale()
    return self.scene_:getBgScale()
end

-- Login Logic Funcs --
function HallController:checkAutoLogin()
    local lastLoginType = nk.userDefault:getStringForKey(nk.cookieKeys.LAST_LOGIN_TYPE)

    if lastLoginType == "GUEST" then
        self:loginWithGuest()
    elseif lastLoginType == "FACEBOOK" then

        self:loginWithFacebook()
    end
end

function HallController:loginWithFacebook()
    if self.isLoginInProgress_ then
        return
    end

    self.isLoginInProgress_ = true
    nk.userDefault:setStringForKey(nk.cookieKeys.LAST_LOGIN_TYPE, "FACEBOOK")
    nk.userDefault:flush()
    
    if nk.Facebook then
        nk.Facebook:login(function(success, result)
            logger:debug(success, result)
            if success then
                if result then

                    if type(result) == "table" then
                        local accessToken = result.accessToken
                        local exptime = result.exptime
                        self:loginFacebookWithAccessToken_(accessToken,exptime)

                    elseif type(result) == "string" then
                        self:loginFacebookWithAccessToken_(result,nil)
                    end
                end
            else
                self.isLoginInProgress_ = false

                if result == "canceled" then
                    nk.TopTipManager:showTopTip(bm.LangUtil.getText("LOGIN", "CANCELLED_MSG"))
                    self:reportLoginResult_(nk.userDefault:getStringForKey(nk.cookieKeys.LAST_LOGIN_TYPE), "5", "authorization cancelled")
                else
                    nk.TopTipManager:showTopTip(bm.LangUtil.getText("COMMON", "BAD_NETWORK"))
                    self:reportLoginResult_(nk.userDefault:getStringForKey(nk.cookieKeys.LAST_LOGIN_TYPE), "6", "authorization failed")
                end
            end
        end)
    end
end

function HallController:loginWithGuest()
    if self.isLoginInProgress_ then
        return
    end
    self.isLoginInProgress_ = true

    local lastLoginType = nk.userDefault:getStringForKey(nk.cookieKeys.LAST_LOGIN_TYPE)
    local isLoginedDevice = (lastLoginType and lastLoginType ~= "")
    
    nk.userDefault:setStringForKey(nk.cookieKeys.LAST_LOGIN_TYPE, "GUEST")
    nk.userDefault:flush()

    if self.view_ and self.view_.playLoginAnim then
        --todo
        self.view_:playLoginAnim()
    end
    self:startGuestLogin_("")
end

function HallController:loginWithNewGuestByDebug()

    if self.isLoginInProgress_ then
        --todo
        return
    end

    self.isLoginInProgress_ = true

    if self.view_ and self.view_.playLoginAnim then
        --todo
        self.view_:playLoginAnim()
    end
    
    nk.http.login("GUEST", nk.Native:getLoginToken(true), nil, nil, handler(self, self.onLoginSucc_), handler(self, self.onLoginError_))
end

function HallController:loginFacebookWithAccessToken_(accessToken, exptime)
    nk.Facebook.setAccessToken(accessToken) 
    nk.Facebook.getId(function(data)
        local idsTbl = json.decode(data)

        if type(idsTbl) == "table" and idsTbl.id then
            local id = idsTbl.id            
            local sesskey = nk.userDefault:getStringForKey(nk.cookieKeys.LOGIN_SESSKEY .. id, "")           
            self:loginFacebookWithAccessTokenAndSesskey_(accessToken, sesskey, exptime)
        else
            self:loginFacebookWithAccessTokenAndSesskey_(accessToken, "", exptime)
        end

    end, function() 
        self:loginFacebookWithAccessTokenAndSesskey_(accessToken, "", exptime)
    end)
end

function HallController:loginFacebookWithAccessTokenAndSesskey_(accessToken, sesskey, tokenExptime)
    if self.view_ and self.view_.playLoginAnim then
        --todo
        self.view_:playLoginAnim()
    end

    self.facebookAccessToken_ = accessToken
    tokenStr = accessToken

    if tokenExptime then
        tokenStr = accessToken .. "#" .. tokenExptime
    end

    nk.userDefault:setStringForKey(nk.cookieKeys.FACEBOOK_ACCESS_TOKEN, tokenStr)
    nk.userDefault:flush()

    self.loginWithFBId_ = nk.http.login("FACEBOOK", nk.Native:getLoginToken(), accessToken, sesskey, handler(self, self.onLoginSucc_),
        handler(self, self.onLoginError_))
end

function HallController:startGuestLogin_(deviceName)
    self.loginWithGuestId_ = nk.http.login("GUEST", nk.Native:getLoginToken(), nil, nil, handler(self, self.onLoginSucc_), handler(self,
        self.onLoginError_))
end

function HallController:onLoginSucc_(data)
    -- dump(data, "onLoginSucc_.data :=================")
    self.isLoginInProgress_ = false
    self:processUserData(data)
    bm.DataProxy:setData(nk.dataKeys.USER_DATA, data, true)

    local ip,port = string.match(nk.userData.hallip[1], "([%d%.]+):(%d+)")  
    -- if ip then
    --     ip = string.format("64:ff9b::%s", ip)
    -- end
  
    nk.server:connect(ip, port, false)
    nk.http.load(function(retData)

        -- dump(retData, "load.retData :===================", 8)
        nk.OnOff:init(retData)

        if not nk.OnOff:checkLocalVersion("roomlist") or bm.DataProxy:getData(nk.dataKeys.TABLE_CONF) == nil then
            nk.http.getRoomList(function(retData)
                -- dump(retData,"getRoomList.retData :===============", 10)

                nk.OnOff:saveNewVersionInLocal("roomlist")
                bm.DataProxy:setData(nk.dataKeys.TABLE_CONF, retData.roomlist)
                bm.DataProxy:cacheData(nk.dataKeys.TABLE_CONF)
            end, function(errData)
                -- body
                dump(errData, "getRoomList.errData :==================")
            end)
        end

        if not nk.OnOff:checkLocalVersion("bankerlist") or bm.DataProxy:getData(nk.dataKeys.GRAB_ROOM_LIST) == nil then
            nk.http.getGrabRoomList(function(retData)
                -- dump(retData, "getGrabRoomList.retData :==================", 8)

                nk.OnOff:saveNewVersionInLocal("bankerlist")
                bm.DataProxy:setData(nk.dataKeys.GRAB_ROOM_LIST, retData)
                bm.DataProxy:cacheData(nk.dataKeys.GRAB_ROOM_LIST)
            end, function(errData)
                -- body
                dump(errData, "getGrabRoomList.errData :==================")
            end)
        end

        if retData.bankruptcyGrant then
            nk.userData["bankruptcyGrant"] = retData.bankruptcyGrant
        end

        if retData.loginAward then
            nk.userData["loginReward"] = retData.loginAward
        end

        if retData.registrationAward then
            nk.userData["loginRewardStep"] = checkint(retData.registrationAward)
        end

        -- gucuReward! --
        if nk.OnOff:check("replayAward") then
            --todo
            nk.userData["recallAward"] = retData.recallAward
        end

        if retData.best then
            nk.userData["best"] = retData.best
        end
        
        if retData.bagPayList then
            --todo
            nk.userData["bagPayList"] = retData.bagPayList
        end

        if retData.open then
            nk.userData["open"] = retData.open
            nk.userData["open"]["mother"] = nil
            -- if nk.userData["open"]["mother"] then
            bm.DataProxy:setData(nk.dataKeys.OPEN_ACT, 1) 
            -- end
        end

        if retData.bowltips then
            local codeNum = checkint(retData.bowltips.code)
            bm.DataProxy:setData(nk.dataKeys.FARM_TIPS, codeNum)
        end

        if retData.pointNotice then
            local winNum = checkint(retData.pointNotice)
            bm.DataProxy:setData(nk.dataKeys.CASH_WIN_SEND_NUM, winNum)
        else
            local defaultSendNum = 45
            bm.DataProxy:setData(nk.dataKeys.CASH_WIN_SEND_NUM, defaultSendNum)
        end

        if retData.inviteFriend then
            nk.userData.inviteFriendLimit = retData.inviteFriend["fbLimit"].."" or "200"
            nk.userData.inviteSendChips = retData.inviteFriend["sendChips"] or 1000  -- InviteFriend Chips Reward.
            nk.userData.inviteBackChips = retData.inviteFriend["backChips"] or 50000  -- InviteCallBack Chips Reward.
            nk.userData.recallBackChips = 50000  -- Recall Reward Num.
            nk.userData.recallSendChips = 500  -- Recall Send Reward Num.
        end

        local lastLoginType = nk.userDefault:getStringForKey(nk.cookieKeys.LAST_LOGIN_TYPE)

        if lastLoginType == "FACEBOOK" then
            --todo
            self:reportInvitableFriends_(nk.userData.inviteFriendLimit)  -- Cache Friend FB Data --
        end
        
        if checkint(retData.loginAward.ret) == 0 and checkint(retData.registrationAward) == 0 then
            if nk.userData.bankruptcyGrant and nk.userData["aUser.money"] < nk.userData.bankruptcyGrant.maxBmoney then

                if nk.userData["aUser.bankMoney"] >= nk.userData.bankruptcyGrant.maxsafebox then
                    local userCrash = UserCrash.new(0, 0, 0, 0, true)
                    userCrash:show()

                else
                    if nk.userData.bankruptcyGrant.bankruptcyTimes < nk.userData.bankruptcyGrant.num then
                        if nk.userData.bankruptcyGrant.bankruptcyTimes == 0 then
                            --todo
                            local isShowPay = nk.OnOff:check("payGuide")
                            local isPay = nk.userData.best and nk.userData.best.paylog == 1 or false
                            -- local isAlmChargeFavPay = nk.userData.bagPayList and nk.userData.bagPayList.almRechgFav == 1 or false

                            local shownSence = 3
                            local isThirdPayOpen = isShowPay
                            local isFirstCharge = not isPay
                            local payBillType = nil

                            if nk.OnOff:check("firstchargeFavGray") and isThirdPayOpen and isFirstCharge then
                                --todo
                                FirChargePayGuidePopup.new(0):showPanel(0)
                            else
                                local rechargeFavAccess = nk.userData.bagPayList and nk.userData.bagPayList.access == 1 or false
                                if nk.OnOff:check("rechargeFavGray") and isThirdPayOpen and isPay and rechargeFavAccess then
                                    --todo
                                    AgnChargePayGuidePopup.new():showPanel(0)
                                else
                                    local params = {}

                                    params.isOpenThrPartyPay = isThirdPayOpen
                                    params.isFirstCharge = isFirstCharge
                                    params.sceneType = shownSence
                                    params.payListType = payBillType

                                    PayGuide.new(params):show(0)
                                end
                            end
                        else
                            local rewardTime = nk.userData.bankruptcyGrant.bankruptcyTimes + 1
                            local bankruptcyTimes = nk.userData.bankruptcyGrant.bankruptcyTimes
                            local rewardMoney = nk.userData.bankruptcyGrant.money[rewardTime] or 0
                            local limitDay = nk.userData.bankruptcyGrant.day or 1
                            local limitTimes = nk.userData.bankruptcyGrant.num or 0
                            local userCrash = UserCrash.new(bankruptcyTimes, rewardMoney, limitDay, limitTimes)
                                :show()
                        end
                    end
                end
            end
        end

        if retData.popad and retData.popad.open == 1 then
            --todo
            nk.userData.popad = retData.popad
        end

        if nk.ByActivity then
            --todo
            -- nk.ByActivity:switchServer(1) -- 切换到测试服
            nk.ByActivity:setup(function(initData)
                -- body
                nk.ByActivity:setWebViewTimeOut(3000)
                nk.ByActivity:setWebViewCloseTip(bm.LangUtil.getText("NEWSTACT", "DOUBLE_CLICK_EXIT"))
                nk.ByActivity:setNetWorkBadTip(bm.LangUtil.getText("COMMON", "REQUEST_DATA_FAIL"))

                nk.ByActivity:displayForce(2, function(data)
                    -- body
                    -- dump(data, "displayForce:displayCallBack.data :==============")
                end, function(str)
                    -- body
                    -- dump(str, "displayForce:closeCallBack.str :================")
                end)
            end)
        end

        local isShowPay = nk.OnOff:check("payGuide")
        local isPay = nk.userData.best and nk.userData.best.paylog == 1 or false
        -- local isAlmChargeFavPay = nk.userData.bagPayList and nk.userData.bagPayList.almRechgFav == 1 or false

        if nk.AdSceneSdk then
          nk.AdSceneSdk:setup()
        end

        local isAdSceneOpen = nk.OnOff:check("unionAd")
        
        -- aUser.msta == 2 BAN To Speak
        local silenced = checkint(nk.userData["aUser.msta"])
        nk.userData.silenced = (silenced == 2) and 1 or 0

        if isAdSceneOpen and nk.AdSceneSdk then
          nk.AdSceneSdk:setShowRecommendBar(1)
        end
        
        if isShowPay and not isPay then
            --todo
            bm.DataProxy:setData(nk.dataKeys.CHARGEFAV_ONOFF, true)

            bm.DataProxy:setData(nk.dataKeys.ALMRECHARGEFAV_ONOFF, false)

            if nk.OnOff:check("firstchargeFavGray") then
                --todo
                nk.http.reportFirstPayData(1, function(retData)
                    -- body
                    -- dump(retData, "reportFirstPayData.data :==================")
                    
                end, function(errData)
                    -- body
                    dump(retData, "reportFirstPayData.errData :==================")
                end)
            end
        else
            bm.DataProxy:setData(nk.dataKeys.CHARGEFAV_ONOFF, false)

            local rechargeFavAccess = nk.userData.bagPayList and nk.userData.bagPayList.access == 1 or false
            if isShowPay and isPay and nk.OnOff:check("rechargeFavGray") and rechargeFavAccess then
                --todo
                nk.DReport:report({id = "AlmReChargeFavAccord"})
                bm.DataProxy:setData(nk.dataKeys.ALMRECHARGEFAV_ONOFF, true)
            else
                bm.DataProxy:setData(nk.dataKeys.ALMRECHARGEFAV_ONOFF, false)
            end
        end

        -- Data Test --
        -- retData.dayNum = 1
        if checkint(retData.dayNum) > 0 then

            if not nk.NewerRegRewControl then
                nk.NewerRegRewControl = import("app.module.newer.RegisterAwardControler").new()
            end

            nk.NewerRegRewControl:init(retData.dayNum)
            local firstRewardFlag = checkint(nk.userData["isCreate"]) == 1
            nk.NewerRegRewControl:setFirstRewardFlag(firstRewardFlag)
        end

        self:onRewardPopup()
        self:showLoginReward()

    end, function(errData)
        -- body
        dump(errData, "load.errData: ================")
    end)

    nk.http.GetUpdateVerInitInfo(function(retData)
        -- dump(retData, "GetUpdateVerInitInfo.retData :================")

       local version = retData.version
       local prizedesc = retData.prizedesc

       bm.DataProxy:setData(nk.dataKeys.UPDATE_INFO, retData)

    end,function(errData)
        dump(errData, "GetUpdateVerInitInfo.errData :================")
    end)

    nk.http.getIsCanSignState(function(retData)
        -- body
        -- dump(retData, "getIsCanSignState.retData :===================")

        if retData == 1 then
            --todo
            bm.DataProxy:setData(nk.dataKeys.HALL_SIGNIN_NEW, true)
        else
            bm.DataProxy:setData(nk.dataKeys.HALL_SIGNIN_NEW, false)
        end
    end, function(errData)
        -- body
        dump(errData, "getIsCanSignState.errData :===================")

        -- Condition Wrong, Set Not Sign Today --
        bm.DataProxy:setData(nk.dataKeys.HALL_SIGNIN_NEW, false)
    end)

    if not self.scene_ or not self.scene_.onLoginSucc then
        --todo
        return
    end
    
    self.scene_:onLoginSucc()
    bm.EventCenter:dispatchEvent(nk.eventNames.HALL_LOGIN_SUCC)

    self:onGetMessage()

    local lastLoginType = nk.userDefault:getStringForKey(nk.cookieKeys.LAST_LOGIN_TYPE)
    self:reportLoginResult_(lastLoginType, "0", "login success")

    if lastLoginType ==  "FACEBOOK" then
        nk.userData["canEditAvatar"] = false
        nk.Facebook:updateAppRequest()
        
        -- Report Friend Can Invite --
        -- self:reportInvitableFriends_()

        -- Save FB Login SESSKEY To AutoLogin --
        nk.userDefault:setStringForKey(nk.cookieKeys.LOGIN_SESSKEY .. nk.userData["aUser.sitemid"], data.sesskey)
        nk.userDefault:flush()

    elseif lastLoginType == "GUEST" then
        nk.userData["canEditAvatar"] = true
    end

    local headImgLastUpdateTime = nk.userDefault:getStringForKey(nk.cookieKeys.DALIY_USERHEADIMG_UPDATE)
    local dayNow = os.date("%Y%m%d%H")

    if string.len(headImgLastUpdateTime) <= 0 or headImgLastUpdateTime ~= dayNow  then
        --todo
        nk.userDefault:setIntegerForKey(nk.cookieKeys.ENTEREDEXPER_TIMES_TODAY, 0)

        nk.userDefault:setStringForKey(nk.cookieKeys.DALIY_USERHEADIMG_UPDATE, dayNow)

        nk.userDefault:flush()
        local deviceInfo = nk.Native:getDeviceInfo()

        local netState = network.getInternetConnectionStatus()
        if netState == cc.kCCNetworkStatusReachableViaWiFi then
            nk.clearMyHeadImgCache()
        end
    end

    -- Cache KeyWord --
    nk.cacheKeyWordFile()
    self:updateUserMaxDiscount()

    if nk.config.GIFT_SHOP_ENABLED and nk.userData.GIFT_JSON then
        LoadGiftControl:getInstance():loadConfig(nk.userData.GIFT_JSON)
    end

    nk.http.getUserProps(2, function(retData)
        if retData then
            -- dump(retData, "getUserProps.retData :=================")

            for _, v in pairs(retData) do
                if tonumber(v.pnid) == 2001 then
                    nk.userData.hddjNum = checkint(v.pcnter)
                    break
                end
            end
        end
        
    end,function(errData)
        dump(errData, "getUserProps.errData :=================")
    end)

    if nk.Push then
        nk.Push:register(function(success, result)
            if success then
                nk.http.reportPushToken(result or "","clientid")
            end
        end)
    end

    if nk.GCMPush then
        nk.GCMPush:register(function(success, result)
            if success then
                nk.http.reportPushToken(result or "","pushToken")
            end
        end)
    end

    if nk.AdSdk then
       if checkint(nk.userData["isCreate"]) == 1 then
            nk.AdSdk:reportReg(tostring(nk.userData["aUser.mid"]))
       end

       nk.AdSdk:reportLogin(tostring(nk.userData["aUser.mid"]))
    end

    local searchedGamePackageName = "com.boomegg.nineke"  -- com.boomegg.nineke
    local isAppInstalled, gameInstallInfo = nk.Native:isAppInstalled(searchedGamePackageName)

    if gameInstallInfo then
        --todo
        local packageFlag = gameInstallInfo.flag
        local packageFirstInstallTime = gameInstallInfo.firstInstallTime
        local packageLastUpdateTime = gameInstallInfo.lastUpdateTime
    end

    local installState = isAppInstalled and 2 or 1
    
    nk.http.getUnionActShowState(installState, function(retData)
        -- body
        -- dump(retData, "getUnionActShowState.retData :=====================")

         bm.DataProxy:setData(nk.dataKeys.UNIONACT_ONOFF, true) 
    end, function(errData)
        -- body
        dump(errData, "getUnionActShowState.errData :=====================")

        bm.DataProxy:setData(nk.dataKeys.UNIONACT_ONOFF, false)
    end)

    -- For Test --
    -- bm.DataProxy:setData(nk.dataKeys.UNIONACT_ONOFF, true)
    -- end --

    bm.DataProxy:setData(nk.dataKeys.SUONA_USETIP_ONOFF, true)  -- Note This Line For First Login Everyday Show SuonaUseTip.
    if nk.userData.isFirst == 1 then
        --todo
        bm.DataProxy:setData(nk.dataKeys.HALL_NEWSTACT_PAOPTIP, true)

        -- bm.DataProxy:setData(nk.dataKeys.SUONA_USETIP_ONOFF, true)  -- Release This Line For First Login Everyday Show SuonaUseTip.
    else
        bm.DataProxy:setData(nk.dataKeys.HALL_NEWSTACT_PAOPTIP, false)
    end
    
    self:umengLoginTimeUsage()

    nk.userDefault:setStringForKey(nk.cookieKeys.LAST_LOGIN_MID, nk.userData["aUser.mid"])
    nk.userDefault:flush()
end

function HallController:onLoginError_(errData)
    dump(errData, "login.errData :===================")

    local errTipsStr = bm.LangUtil.getText("COMMON", "BAD_NETWORK")

    if errData ~= nil and errData.errorCode then
        if 1 == errData.errorCode then
            self:reportLoginResult_(nk.userDefault:getStringForKey(nk.cookieKeys.LAST_LOGIN_TYPE), "1", "json parse error")
        elseif -5 == errData.errorCode then
            -- Account Be Banned --
            errTipsStr = bm.LangUtil.getText("COMMON", "BE_BANNED")
        else
            self:reportLoginResult_(nk.userDefault:getStringForKey(nk.cookieKeys.LAST_LOGIN_TYPE), "2", "php error:" .. errData.errorCode)
        end
    else
        self:reportLoginResult_(nk.userDefault:getStringForKey(nk.cookieKeys.LAST_LOGIN_TYPE), "4", "connection problem")
    end

    nk.userDefault:setStringForKey(nk.cookieKeys.LAST_LOGIN_TYPE, "")
    nk.userDefault:flush()

    self.isLoginInProgress_ = false
    self.view_:playLoginFailAnim()

    nk.TopTipManager:showTopTip(errTipsStr)
    self:umengLoginTimeUsage()
end

-- Views Work Logic Funcs --
function HallController:showChooseRoomView(viewType)
    self.scene_:onShowChooseRoom(viewType)
end

function HallController:showChooseMatchRoomView(viewType)
    self.scene_:showChooseMatchRoomView(viewType)
end

function HallController:showDobkActPageView()
    -- body
    self.scene_:onShowDobkActPage()
end

function HallController:showChoosePersonalRoomView(viewType)
    self.scene_:onShowChoosePersonalRoom(viewType)
end

function HallController:showMainHallView()
    self.scene_:onShowMainHall()
end

-- Data Work Logic Funcs --
function HallController:updateOnline()
    nk.http.getOnlineNumber(function(retData)
        -- dump(retData, "getOnlineNumber.retData :==================")

        nk.userData.USER_ONLINE = retData.number
    end,function(errData)
        dump(errData, "getOnlineNumber.errData :==================")
    end)
end

function HallController:cancelLoginAndClearCache()
    -- body
    if self.loginWithFBId_ then
        --todo
        nk.http.cancel(self.loginWithFBId_)
    end

    if self.loginWithGuestId_ then
        --todo
        nk.http.cancel(self.loginWithGuestId_)
    end

    nk.clearLoginCache()
    self.isLoginInProgress_ = false
    self.view_:playLoginFailAnim()
end

function HallController:checkToRoom()
    -- Set Nil Temporary --
    -- local toMatchData = bm.DataProxy:getData(nk.dataKeys.TO_MATCH_DATA)
    -- if toMatchData then
    --     if toMatchData.matchid and toMatchData.tableid then
    --         local matchid = toMatchData.matchid
    --         local tableid = toMatchData.tableid
    --         local uid = nk.userData.uid   
    --         local strinfo = json.encode(nk.getUserInfo())
    --         self.view_:performWithDelay(function()
    --             nk.server:loginMatchRoom(uid,matchid,tableid,(strinfo or ""))
    --         end, 1.5)
    --         bm.DataProxy:setData(nk.dataKeys.TO_MATCH_DATA, nil)
    --     end
    -- end
end

function HallController:getEnterCashRoomData()
    if self.isEnterRoomIng == 1 then
        --todo
        return
    end

    local level = nk.getRoomLevelByCash(nk.userData["match.point"])
    if not level then
        self:getEnterRoomData(nil, true)
        return
    end

    local sendData = {gameLevel = checkint(level), tableId = 0}
    bm.EventCenter:dispatchEvent({name = nk.eventNames.ENTER_GRAB_DEALER_ROOM, data = sendData})
end

function HallController:getEnterRoomData(args, isPlaynow) 
    if self.isEnterRoomIng == 1 then
        return
    end   

    if not nk.server:isLogin() then
        return
    end

    local level = nil
    if args == nil then
        local tableConf = bm.DataProxy:getData(nk.dataKeys.TABLE_CONF)
        if not tableConf then 
            return
        end
       
        level = tableConf[1][1][1][1]
    else
        level = args.sb[1]
    end
  
    local roomData = nk.getRoomDataByLevel(level)

    if not roomData then
        return
    end

    -- dump(roomData, "roomData :================")
    local roomDataFliter = {}
    roomDataFliter.blind = roomData.blind
    roomDataFliter.minBuyIn = roomData.minBuyIn
    roomDataFliter.maxBuyIn = roomData.limit
    roomDataFliter.roomType = roomData.roomGroup
    roomDataFliter.enterLimit = roomData.enterLimit

    if isPlaynow then

        local isShowPay = nk.OnOff:check("payGuide")
        local isPay = nil
        -- local isAlmChargeFavPay = nk.userData.bagPayList and nk.userData.bagPayList.almRechgFav == 1 or false

        if nk.userData and nk.userData.best then
            isPay = nk.userData.best.paylog == 1 or false
        else
            isPay = false
        end

        level = nk.getRoomLevelByMoney2(nk.userData["aUser.money"])
        local roomData = nk.getRoomDataByLevel(level)

        if not roomData then
            return
        end

        if nk.userData["aUser.money"] >= roomData.enterLimit then
            --todo

            self.isEnterRoomIng = 1
            nk.server:quickPlay()
        else
            if nk.userData["aUser.bankMoney"] >= nk.userData.bankruptcyGrant.maxsafebox then
                local userCrash = UserCrash.new(0, 0, 0, 0, true)
                    :show()

            else
                if nk.userData.bankruptcyGrant.bankruptcyTimes == 0 then
                    --todo
                    local shownSence = 3
                    local isThirdPayOpen = isShowPay
                    local isFirstCharge = not isPay
                    local payBillType = roomData.roomGroup

                    if nk.OnOff:check("firstchargeFavGray") and isThirdPayOpen and isFirstCharge then
                        --todo
                        FirChargePayGuidePopup.new(0):showPanel(0)
                    else

                        local rechargeFavAccess = nk.userData.bagPayList and nk.userData.bagPayList.access == 1 or false
                        if nk.OnOff:check("rechargeFavGray") and isThirdPayOpen and isPay and rechargeFavAccess then
                            --todo
                            AgnChargePayGuidePopup.new():showPanel(0)
                        else
                            local params = {}

                            params.isOpenThrPartyPay = isThirdPayOpen
                            params.isFirstCharge = isFirstCharge
                            params.sceneType = shownSence
                            params.payListType = payBillType

                            PayGuide.new(params):show(0)
                        end
                    end
                else

                    if nk.userData.bankruptcyGrant then
                        local rewardTime = nk.userData.bankruptcyGrant.bankruptcyTimes + 1
                        local bankruptcyTimes = nk.userData.bankruptcyGrant.bankruptcyTimes
                        local rewardMoney = nk.userData.bankruptcyGrant.money[rewardTime] or 0
                        local limitDay = nk.userData.bankruptcyGrant.day or 1
                        local limitTimes = nk.userData.bankruptcyGrant.num or 0
                        local userCrash = UserCrash.new(bankruptcyTimes,rewardMoney,limitDay,limitTimes)
                            :show()
                    end
                end
            end
        end
    else

        if roomData.maxBuyIn > 0 and nk.userData["aUser.money"] >= roomData.maxBuyIn and roomData.isAllIn == 1 then

            nk.ui.Dialog.new({messageText = T("您的筹码已超过该底注场上限，请切换更高级的场次游戏吧"), titleText = bm.LangUtil.getText("COMMON", "NOTICE"),
                hasFirstButton = true, hasCloseButton = true, callback = function(type)
                    if type == nk.ui.Dialog.SECOND_BTN_CLICK then
                        nk.server:quickPlay()
                    end
                end}
            ):show()

            return
        end

        local isSuccLoginRoom = true
        if nk.userData["aUser.money"] >= roomDataFliter.enterLimit then
            isSuccLoginRoom = true
        else
            isSuccLoginRoom = false
            PayGuidePopMgr.new(roomDataFliter):show()
        end

        if isSuccLoginRoom then
            --todo
            nk.server:getRoomAndLogin(level, 0)
            self.isEnterRoomIng = 1
            msg = msg or bm.LangUtil.getText("ROOM", "ENTERING_MSG")
            if self.roomLoading_ then 
                self.roomLoading_:removeFromParent()
                self.roomLoading_ = nil
            end
            self.roomLoading_ = nk.ui.RoomLoading.new(msg)
                :addTo(self.view_, 100)

            self.roomLoading_:setNodeEventEnabled(true)
            self.roomLoading_.onCleanup = handler(self,function(obj)
                obj.roomLoading_ = nil
            end)

            nk.server:pause()
            self.loginRoomSucc_ = false
        end
    end
end

function HallController:getPlayerCountData(roomType, field)
    nk.http.cancel(self.reqPlayerCountId_)

    self.reqPlayerCountId_ = nk.http.getOnline(function(retData)
        -- dump(retData, "getOnline.retData :==============")

        if self.view_ and self.view_.onGetPlayerCountData then
            self.view_:onGetPlayerCountData(retData, field)
        end
    end, function(errData)
        dump(errData, "getOnline.errData :================")

        if self.view_ then
            local delayCallGetCountTime = 2

            self.view_:performWithDelay(handler(self, self.getPlayerCountData), delayCallGetCountTime)
        end
    end)    
end

function HallController:getMatchNorPlayerCountData()
    nk.http.cancel(self.matchPlayerCountRequestId_)

    self.matchPlayerCountRequestId_ = nk.http.getMatchOnlineNum(1, function(retData)
        -- dump(retData, "getMatchOnlineNum.retData :===============")

        if self.view_ and self.view_["onMatchNorPlayerCountDataGet"] then
            self.view_:onMatchNorPlayerCountDataGet(retData)
        end

    end, function(errData)
        dump(errData, "getMatchOnlineNum.errData :===============")

        if self.view_ then
            local delayCallMatchNorCountTime = 1.5

            self.view_:performWithDelay(handler(self, self.getMatchNorPlayerCountData), delayCallMatchNorCountTime)
        end
    end) 
end

function HallController:getMatchHotPlayerCountData(param)
    nk.http.cancel(self.timeMatchPlayerCountRequestId_)

    self.timeMatchPlayerCountRequestId_ = nk.http.getTimeMatchPeople(param, function(retData)      
        if self.view_ and self.view_["onMatchHotPlayerCountDataGet"] then
            self.view_:onMatchHotPlayerCountDataGet(retData)
        end
        
    end, function(errData)
        if self.view_ then
            local delayCallMatchHotCountTime = 1.5

            self.view_:performWithDelay(handler(self, self.getMatchHotPlayerCountData), delayCallMatchHotCountTime)
        end
    end) 
end

function HallController:getProxyListFromUserData_(userData)
    local ret = {}

    if userData.proxyAddr_array then
        for _, proxyAddr in ipairs(userData.proxyAddr_array) do
            local proxyArr = string.split(proxyAddr, ":")
            local proxyIp = proxyArr[1]
            local proxyPort = checkint(proxyArr[2])

            if proxyIp and string.len(proxyIp) > 0 and proxyPort > 0 then
                table.insert(ret, {ip = proxyIp, port = proxyPort})
            end
        end
    end

    return ret
end

function HallController:findGrabRoom()
    local selfMoney = nk.userData["aUser.money"]
    local high = 240000000
    local middle = 24000000
    local low = 50000

    if selfMoney >= high then
        return 301  -- Grab High Room Level
    elseif selfMoney >= middle and selfMoney < high then
        return 302  -- Grab Middle Room Level
    elseif selfMoney >= low and selfMoney < middle then
        return 303  -- Grab Low Room Level
    end

    return - 1 -- Chip Not Enough
end

-- Event Work Logic Funcs --
function HallController:onLoginServerSucc_(evt)
    -- do return end
    -- local data = event.data
    -- if data.tid > 0 and (not self.notReConnect_) then
    --     -- 重连房间
    --     self.tid__ = data.tid
    --     self.view_:performWithDelay(handler(self, self.reLoginRoom_), 1.5)
    -- end
end

function HallController:onDoubleLoginError_(evt)
    nk.ui.Dialog.new({messageText = T("您的账户在别处登录"), secondBtnText = T("确定"), closeWhenTouchModel = false, hasFirstButton = false, hasCloseButton = false,
        callback = function (type)
            if type == nk.ui.Dialog.SECOND_BTN_CLICK then
                self:handleLogoutSucc_()
            end
        end}
    ):show()

    self:handleLogoutSucc_()
end

function HallController:onOnline_(evt)
end

function HallController:onLoginServerSuccNew_(evt)
end

function HallController:onReLoginServerSuccNew_(evt)
    local runningScene = nk.runningScene

    if not runningScene or runningScene.name == nil or runningScene.name ~= "HallScene" then
        return
    end

    local data = evt.data
    if data.tid <= 0 then
        return
    end
    
    dump(data, "HallController:onReLoginServerSuccNew_(204).data :====================")

    local delayCallLoginRoomTime = 1.5
    if data.type == 1 then
        self.tid__ = data.tid
        self.view_:performWithDelay(handler(self, self.reLoginRoom_), delayCallLoginRoomTime)

    elseif data.type == 2 then
        local exData = json.decode(data.extStr)
        self.matchid_ = exData.matchid
        self.view_:performWithDelay(handler(self, self.reLoginMatch_), delayCallLoginRoomTime)

    elseif data.type == 3 then
        self.grabRoomId_ = data.tid
        self.view_:performWithDelay(function()
            nk.server:loginGrabDealerRoom(self.grabRoomId_)
        end, delayCallLoginRoomTime)

    elseif data.type == 4 then
        self.tid__ = data.tid
        local exData = json.decode(data.extStr)
        self.matchid_ = exData.matchid
        self.view_:performWithDelay(handler(self, self.reLoginTimeMatch_), delayCallLoginRoomTime)
    end
end

function HallController:onServerFail_(evt)
    -- Failed To Connect --
    if evt.data == consts.SVR_ERROR.ERROR_CONNECT_FAILURE then       
        self:showErrorByDialog_(bm.LangUtil.getText("COMMON", "ERROR_CONNECT_FAILURE"))

    -- Heatbeat Time Out --
    elseif evt.data == consts.SVR_ERROR.ERROR_HEART_TIME_OUT then       
        self:showErrorByDialog_(bm.LangUtil.getText("COMMON", "ERROR_HEART_TIME_OUT"))
    
    -- Login Time Out --
    elseif evt.data == consts.SVR_ERROR.ERROR_LOGIN_TIME_OUT then       
        self:showErrorByDialog_(bm.LangUtil.getText("COMMON", "ERROR_LOGIN_TIME_OUT"))   
    end
end

function HallController:onGrabRoomlistResult(evt)
    if self.scene_ and self.scene_["onSetGrabRoomList"] then
        self.scene_:onSetGrabRoomList(evt.data)
    end
end

function HallController:onPersonalRoomListResult(evt)
    if self.view_ and self.view_["onSetPersonalRoomList"] then
        self.view_:onSetPersonalRoomList(evt.data)
    end
end

function HallController:onCreatePersonalRoom(evt)
    if self.view_ and self.view_["onCreatePersonalRoom"] then
        self.view_:onCreatePersonalRoom(evt.data)
    end
end

function HallController:onSearchPersonalRoom(evt)
    if self.scene_ and self.scene_["onSearchPersonalRoom"] then
        self.scene_:onSearchPersonalRoom(evt.data)
    end
end

function HallController:onLoginRoomSucc_(evt)
    -- dump(evt, "HallController:onLoginRoomSucc_.evt :==================")
    if evt.data then
        local roomInfo = {}
        
        roomInfo.minBuyIn = evt.data.minAnte
        roomInfo.maxBuyIn = evt.data.maxAnte
        roomInfo.roomType = evt.data.tableLevel
        roomInfo.blind = evt.data.baseAnte
        roomInfo.playerNum = evt.data.maxSeatCnt
        roomInfo.defaultBuyIn = evt.data.defaultAnte
        roomInfo.tid = evt.data.tableId

        bm.DataProxy:setData(nk.dataKeys.ROOM_INFO, roomInfo)
    end

    if self.loadedRoomTexture_ then
        self.isEnterRoomIng = false
        app:enterRoomScene()
    else
        if not self.loadingRoomTexture_ then
            msg = msg or bm.LangUtil.getText("ROOM", "ENTERING_MSG")
            if self.roomLoading_ then 
                self.roomLoading_:removeFromParent()
                self.roomLoading_ = nil
            end
            self.roomLoading_ = nk.ui.RoomLoading.new(msg)
                :addTo(self.view_, 100)

            nk.server:pause()
            self:loadRoomTexture_()
        end
    end

    self.loginRoomSucc_ = true    
end

function HallController:onLoginRoomFail_(evt)
    self.isEnterRoomIng = false
    if self.tid__ and self.tid__ > 0 then
        self.notReConnect_ = true 
    end

    if self.roomLoading_ then
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end

    if self.loadedRoomTexture_ then
        self.loadedRoomTexture_ = false
        display.removeSpriteFramesWithFile("room_texture.plist", "room_texture.png")
    end
    
    local errNum = checkint(evt.data.errno)

    -- dump(evt.data, "data : =====================")

    if errNum==5 then
        -- Table Not Exist --
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("HALL", "ERROR_TABLE_NOT_EXIST"))
    elseif errNum==6 then
        -- In Room --
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("HALL", "ERROR_USER_IN_TABLE"))
    elseif errNum==9 then
        -- Chip Not Enough --
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("HALL", "ERROR_NOT_ENOUGH_MONEY"))
    elseif errNum==13 then
        -- Chip Too Much --
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("HALL", "ERROR_TOO_MUCH_MONEY"))
    else
        -- Translate It --
        nk.TopTipManager:showTopTip(T("服务器繁忙,请稍后再试[%d]", evt.data.errno))
    end
end

function HallController:onEnterRoom_(evt)
    local data = evt.data
    if (data and data.roomid and checkint(data.roomid) > 0) and (nk and nk.server) then
        msg = msg or bm.LangUtil.getText("ROOM", "ENTERING_MSG")
        if self.roomLoading_ then 
            self.roomLoading_:removeFromParent()
            self.roomLoading_ = nil
        end

        self.roomLoading_ = nk.ui.RoomLoading.new(msg)
            :addTo(self.view_, 100)

        self.roomLoading_:setNodeEventEnabled(true)
        self.roomLoading_.onCleanup = handler(self, function(obj)
            obj.roomLoading_ = nil
        end)

        nk.server:loginRoom(checkint(data.roomid))
        nk.server:pause()
        self.loginRoomSucc_ = false
        self:loadRoomTexture_()

        local delayRemoveLoadingTime = 5

        self.schedulerPool_:delayCall(function()
            if self.roomLoading_ then 
                self.roomLoading_:removeFromParent()
                self.roomLoading_ = nil
            end
        end, delayRemoveLoadingTime)
    end
end

function HallController:onEnterMatch_(evt)
    self:getEnterMatchRoomData(evt.data)
end

function HallController:onEnterGrabDealer_(evt)
    -- dump(evt, "HallController:onEnterGrabDealer_.evt :===================")

    local gameLevel = evt.data and evt.data.gameLevel or nil
    local tableId = evt.data and evt.data.tableId or 0
    nk.server:getGrabDealerRoomAndLogin(gameLevel, checkint(tableId))
    self.isEnterRoomIng = 1
end

function HallController:onLoginMatchRoomOk_(evt)
    self.loginMatchRoomSucc_ = true

    if self.loadedRoomTexture_ then
        app:enterMatchRoomScene()
    else
        if not self.loadingMatchRoomTexture_ then

            msg = msg or bm.LangUtil.getText("ROOM", "ENTERING_MSG")
            if self.roomLoading_ then 
                self.roomLoading_:removeFromParent()
                self.roomLoading_ = nil
            end

            self.roomLoading_ = nk.ui.RoomLoading.new(msg)
                :addTo(self.view_, 100)

            self.roomLoading_:setNodeEventEnabled(true)
            self.roomLoading_.onCleanup = handler(self, function(obj)
                obj.roomLoading_ = nil
            end)

            nk.server:pause()
            self:loadMatchRoomTexture_()
        end
    end
end

function HallController:onLoginMatchRoomFail_(evt)
    self.loginMatchRoomSucc_ = false

    if self.roomLoading_ then
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end

    if self.loadedMatchRoomTexture_ then
        self.loadedMatchRoomTexture_ = false
        display.removeSpriteFramesWithFile("room_texture.plist", "room_texture.png")
    end
end

function HallController:onLoginGrabRoomSucc_(evt)
    if evt.data then
        local roomInfo = {}
        
        roomInfo.minBuyIn = evt.data.minAnte
        roomInfo.maxBuyIn = evt.data.maxAnte
        roomInfo.roomType = evt.data.tableLevel
        roomInfo.blind = evt.data.baseAnte
        roomInfo.playerNum = evt.data.maxSeatCnt
        roomInfo.defaultBuyIn = evt.data.defaultAnte
        roomInfo.tid     = evt.data.tableId

        bm.DataProxy:setData(nk.dataKeys.ROOM_INFO, roomInfo)
    end

    if self.loadedGrabRoomTexture_ then
        self.isEnterRoomIng = false
        app:enterGrabDealerRoomScene()
    else
        if not self.loadingGrabRoomTexture_ then
            if self.roomLoading_ then 
                self.roomLoading_:removeFromParent()
                self.roomLoading_ = nil
            end

            local grabMsg = T("正在进入抢庄房间，请稍候...")
            self.roomLoading_ = nk.ui.RoomLoading.new(grabMsg)
                :addTo(self.view_, 100)
            self.roomLoading_:setNodeEventEnabled(true)
            self.roomLoading_.onCleanup = handler(self, function(obj)
                obj.roomLoading_ = nil
            end)

            nk.server:pause()
            self:loadGrabRoomTexture_()
        end
    end
    self.loginGrabRoomSucc_ = true    
end

function HallController:onLoginGrabRoomFail_(evt)
    self.isEnterRoomIng = false
    if self.tid__ and self.tid__ > 0 then
        self.notReConnect_ = true 
    end

    if self.roomLoading_ then
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end

    if self.loadedGrabRoomTexture_ then
        self.loadedGrabRoomTexture_ = false
        display.removeSpriteFramesWithFile("room_texture.plist", "room_texture.png")
    end
    
    
    local errNum = checkint(evt.data.errno)

    -- dump(evt.data, "data : =====================")
    if errNum==5 then
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("HALL", "ERROR_TABLE_NOT_EXIST"))

    elseif errNum==6 then
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("HALL", "ERROR_USER_IN_TABLE"))

    elseif errNum==9 then
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("HALL", "ERROR_NOT_ENOUGH_MONEY"))

    elseif errNum==13 then
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("HALL", "ERROR_TOO_MUCH_MONEY"))

    else
        -- Translate It --
        nk.TopTipManager:showTopTip(T("服务器繁忙,请稍后再试[%d]", evt.data.errno))
    end  
end

function HallController:onTimeMatchPush_(evt)
    local pack = evt.data
    local matchid = pack.matchid
    local tableid = pack.tableid
    local uid = nk.userData.uid   
    local strinfo = json.encode(nk.getUserInfo())
    nk.server:loginMatchRoom(uid, matchid, tableid, (strinfo or ""))
end

function HallController:timeMatchOff_(evt)

    local pack = evt.data
    local matchid = pack.matchid
    nk.http.outMatch(matchid, function(retData) 
        dump(retData, "outMatch.retData :=================")

        if self.scene_ and self.scene_["onUpdateMatchInfo"] then
            self.scene_:onUpdateMatchInfo()
        end
    end, function(errData) 
        dump(errData, "outMatch.errData :=================")
    end)
end

function HallController:onLoginNewRoomSucc_(evt)
    if evt.data then
        local roomInfo = {}
        
        roomInfo.minBuyIn = evt.data.minAnte
        roomInfo.maxBuyIn = evt.data.maxAnte
        roomInfo.roomType = evt.data.tableLevel
        roomInfo.blind = evt.data.baseAnte
        roomInfo.playerNum = evt.data.maxSeatCnt
        roomInfo.defaultBuyIn = evt.data.defaultAnte
        roomInfo.tid = evt.data.tableId

        bm.DataProxy:setData(nk.dataKeys.ROOM_INFO, roomInfo)
    end

    if self.loadedGrabRoomTexture_ then
        self.isEnterRoomIng = false
        app:enterRoomSceneEx()
    else
        if not self.loadingGrabRoomTexture_ then
            if self.roomLoading_ then 
                self.roomLoading_:removeFromParent()
                self.roomLoading_ = nil
            end

            local grabMsg = T("正在进入新玩法房间，请稍候...")
            self.roomLoading_ = nk.ui.RoomLoading.new(grabMsg)
                :addTo(self.view_, 100)
            self.roomLoading_:setNodeEventEnabled(true)
            self.roomLoading_.onCleanup = handler(self, function(obj)
                obj.roomLoading_ = nil
            end)

            nk.server:pause()
            self:loadNewRoomTexture_()
        end
    end
    self.loginGrabRoomSucc_ = true    
end

function HallController:onBroadCast_(evt)
    local pack = evt.data
    local mtype = pack.mtype

    if mtype == 2 then
        if pack.info then
            local inviteData = json.decode(pack.info)
            local inviteName_ = inviteData.name
            local tid = inviteData.tid
            local content_ = bm.LangUtil.getText("HALL", "PERSONAL_ROOM_INVITE_CONTENT", inviteName_)
            local buttonLabel_ = bm.LangUtil.getText("HALL", "PERSONAL_ROOM_TOP_TIPS")[1]

            local btnSize = {
                width = 140,
                height = 52
            }

            local labelParam = {
                fontSize = 20,
                color = styles.FONT_COLOR.LIGHT_TEXT
            }
            local button = cc.ui.UIPushButton.new({normal = "#common_green_btn_up.png", pressed = "#common_green_btn_down.png", disabled = "#common_btn_disabled.png"},
                {scale9 = true})
                :setButtonSize(btnSize.width, btnSize.height)
                :setButtonLabel(display.newTTFLabel({text = buttonLabel_ , size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
                :onButtonClicked(buttontHandler(self, function() 
                    nk.server:searchPersonalRoom(nil, tid)
                end))

            nk.TopTipExManager:showTopTip({text = content_, button = button})
            
        end
    end
end

function HallController:onSuonaBroadRecv_(evt)
    -- body
    -- dump(evt.data, "onSuonaBroadRecv_.evt.data :===================")
    if evt.data and evt.data.msg_info then
        --todo
        local chatData = json.decode(evt.data.msg_info)

        local msgType = chatData.type

        if msgType == 2 then
            --todo
            local contentMsg = chatData.content
            local jumpIndex = chatData.location
            local textColorHex = chatData.color

            -- local textColorRGB = nil
            -- if textColorHex and string.len(textColorHex) > 0 then
            --     --todo
            --     local colorR = "0x" .. string.sub(textColorHex, 1, 2)
            --     local colorG = "0x" .. string.sub(textColorHex, 3, 4)
            --     local colorB = "0x" .. string.sub(textColorHex, 5, 6)

            --     textColorRGB = cc.c3b(colorR, colorG, colorB)
            -- end

            if jumpIndex == "0" then
                --todo
                self.suonaMsgQueue_ = self.suonaMsgQueue_ or {}
                table.insert(self.suonaMsgQueue_, contentMsg)

                if self.view_ and self.view_.playSuonaMsgScrolling then
                    --todo
                    self.view_:playSuonaMsgScrolling(contentMsg)
                else
                    nk.TopTipManager:showTopTip({text = contentMsg, messageType = 1000})
                end

            else
                -- self.broadcastJumpAction_ = jumpIndex

                -- self.exButton_ = cc.ui.UIPushButton.new({normal = "#common_btn_aqua.png", pressed = "#common_btn_aqua.png", disabled = "#common_btn_disabled.png"},
                --     {scale9 = true})
                --     :setButtonSize(120, 48)
                --     :setButtonLabel("normal", display.newTTFLabel({text = "Go>>>", size = 20, color = styles.FONT_COLOR.LIGHT_TEXT,
                --         align = ui.TEXT_ALIGN_CENTER}))
                --     :onButtonClicked(buttontHandler(self, self.onBoroadCastMsgJump_))

                -- nk.TopTipExManager:showTopTip({text = contentMsg, messageType = 1001, button = self.exButton_})

                -- nk.TopTipExManager:setLblColor_(textColorRGB)

                return
            end

            return
        elseif msgType == 1 or not msgType then
            --todo
            local chatFromName = chatData.name
            local chatMsg = chatData.content
            local chatInfoMsg = "[" .. chatFromName .. "]" .. bm.LangUtil.getText("SUONA", "SAY") .. chatMsg

            self.suonaMsgQueue_ = self.suonaMsgQueue_ or {}
            table.insert(self.suonaMsgQueue_, chatInfoMsg)

            if self.view_ and self.view_.playSuonaMsgScrolling then
                --todo
                self.view_:playSuonaMsgScrolling(chatInfoMsg)
            else
                nk.TopTipManager:showTopTip({text = chatInfoMsg, messageType = 1000})
            end
        end
    end
end

-- Event Work Follow-up Process Funcs --
function HallController:handleLogoutSucc_()
    self:doLogout()

    self.scene_:onLogoutSucc()
end

function HallController:doLogout()
    nk.userDefault:setStringForKey(nk.cookieKeys.LAST_LOGIN_TYPE, "")
    nk.userDefault:flush()

    if nk.Facebook then
        nk.Facebook:logout()
        nk.userDefault:setStringForKey(nk.cookieKeys.FACEBOOK_ACCESS_TOKEN, "")
        nk.userDefault:flush()
    end

    nk.server:disconnect()   

    if nk.AdSdk then
        nk.AdSdk:reportLogout()
    end

    if nk.MatchConfigEx then
        nk.MatchConfigEx:dispose()
    end

    if nk.NewerRegRewControl then
        nk.NewerRegRewControl:dispose()
    end
    
    nk.PopupManager:removeAllPopup()
end

function HallController:reLoginRoom_()
    msg = msg or bm.LangUtil.getText("ROOM", "ENTERING_MSG")
    if self.roomLoading_ then 
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end

    self.roomLoading_ = nk.ui.RoomLoading.new(msg)
        :addTo(self.view_, 100)

    self.roomLoading_:setNodeEventEnabled(true)
    self.roomLoading_.onCleanup = handler(self,function(obj)
        obj.roomLoading_ = nil
    end)

    nk.server:loginRoom(self.tid__)
    nk.server:pause()

    self.loginRoomSucc_ = false
    self:loadRoomTexture_()
end 

function HallController:reLoginMatch_()
    msg = msg or bm.LangUtil.getText("ROOM", "ENTERING_MSG")
    if self.roomLoading_ then 
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end

    self.roomLoading_ = nk.ui.RoomLoading.new(msg)
        :addTo(self.view_, 100)

    self.roomLoading_:setNodeEventEnabled(true)
    self.roomLoading_.onCleanup = handler(self,function(obj)
        obj.roomLoading_ = nil
    end)

    nk.server:checkJoinMatch(self.matchid_)
end

function HallController:reLoginTimeMatch_()
    msg = msg or bm.LangUtil.getText("ROOM", "ENTERING_MSG")
    if self.roomLoading_ then 
        self.roomLoading_:removeFromParent()
        self.roomLoading_ = nil
    end

    self.roomLoading_ = nk.ui.RoomLoading.new(msg)
        :addTo(self.view_, 100)
    self.roomLoading_:setNodeEventEnabled(true)
    self.roomLoading_.onCleanup = handler(self,function(obj)
        obj.roomLoading_ = nil
    end)

    local uid = nk.userData.uid
    local strinfo = json.encode(nk.getUserInfo())

    nk.server:loginMatchRoom(uid, self.matchid_, self.tid__, strinfo or "")
end

function HallController:loadRoomTexture_()
    if self.loadingRoomTexture_ then
        return
    end
    
    if not self.loadedRoomTexture_ then
        self.loadingRoomTexture_ = true
        self.loadedRoomTexture_ = false
        self.loadRoomTextureNum_ = 0
        cc.Director:getInstance():getTextureCache():addImageAsync("room_background.png", handler(self, self.onLoadedRoomTexture_))
    else

        if self.loginRoomSucc_ then
            app:enterRoomScene()
        end
        self.loadedRoomTexture_ = true
    end
end

function HallController:onLoadedRoomTexture_(fileName, imgName)
    self.loadRoomTextureNum_ = self.loadRoomTextureNum_ + 1

    if self.loadRoomTextureNum_ == 1 then
        display.addSpriteFrames("room_texture.plist", "room_texture.png", handler(self, self.onLoadedRoomTexture_))
    elseif self.loadRoomTextureNum_ == 2 then
        
        if self.loginRoomSucc_ then
            app:enterRoomScene()
        end

        self.loadedRoomTexture_ = true
        self.loadingRoomTexture_ = false
    end
end

function HallController:showErrorByDialog_(msg)

    if self.errorDlg_ then
        return
    end

    msg = bm.LangUtil.getText("COMMON","ERROR_NETWORK_FAILURE") or msg
    self.errorDlg_ = nk.ui.Dialog.new({messageText = msg, secondBtnText = bm.LangUtil.getText("COMMON", "RETRY_PLEASE"), titleText = bm.LangUtil.getText("COMMON",
        "ERROR_NOTICE"), closeWhenTouchModel = false, hasFirstButton = false, hasCloseButton = false,
        callback = function (type)
            if type == nk.ui.Dialog.SECOND_BTN_CLICK then
                local ip,port = string.match(nk.userData.hallip[1], "([%d%.]+):(%d+)")  

                nk.CommonTipManager:playReconnectingAnim(true, bm.LangUtil.getText("COMMON", "ERROR_NETWORK_RECONNECT", "\n"))

                if (ip and ip ~= "") and (port and port ~= "") then
                   nk.server:connect(ip, port, false) 
                end
            end

            self.errorDlg_ = nil
        end}
    ):show()
end

function HallController:getEnterMatchRoomData(args)
    if not nk.server:isLogin() then
        return
    end

    local matchid = args.matchid
    nk.server:checkJoinMatch(matchid)          
end

function HallController:loadMatchRoomTexture_()
    if self.loadingMatchRoomTexture_ then
        return
    end
    
    if not self.loadedMatchRoomTexture_ then
        self.loadingMatchRoomTexture_ = true
        self.loadedMatchRoomTexture_ = false
        self.loadMatchRoomTextureNum_ = 0
        cc.Director:getInstance():getTextureCache():addImageAsync("room_background.png", handler(self, self.onLoadedMatchRoomTexture_))
    else
        if self.loginMatchRoomSucc_ then
            app:enterMatchRoomScene()
        end
        self.loadedMatchRoomTexture_ = true
    end
end

function HallController:onLoadedMatchRoomTexture_(fileName, imgName)
    self.loadMatchRoomTextureNum_ = self.loadMatchRoomTextureNum_ + 1
    if self.loadMatchRoomTextureNum_ == 1 then
        display.addSpriteFrames("room_texture.plist", "room_texture.png", handler(self, self.onLoadedMatchRoomTexture_))
    elseif self.loadMatchRoomTextureNum_ == 2 then
        
        if self.loginMatchRoomSucc_ then
            app:enterMatchRoomScene()
        end
        self.loadedMatchRoomTexture_ = true
        self.loadingMatchRoomTexture_ = false
    end
end

function HallController:loadGrabRoomTexture_()
    if not self.loadedGrabRoomTexture_ then
        self.loadingGrabRoomTexture_ = true
        self.loadedGrabRoomTexture_ = false
        self.loadGrabRoomTextureNum_ = 0
        cc.Director:getInstance():getTextureCache():addImageAsync("room_background.png", handler(self, self.onLoadedGrabRoomTexture_))
    else
        if self.loginGrabRoomSucc_ then
            app:enterGrabDealerRoomScene()
            --app:enterRoomSceneEx()
        end
        self.loadedGrabRoomTexture_ = true
    end
end

function HallController:onLoadedGrabRoomTexture_(fileName, imgName)
    self.loadGrabRoomTextureNum_ = self.loadGrabRoomTextureNum_ + 1
    if self.loadGrabRoomTextureNum_ == 1 then
        display.addSpriteFrames("room_texture.plist", "room_texture.png", handler(self, self.onLoadedGrabRoomTexture_))
    elseif self.loadGrabRoomTextureNum_ == 2 then
        display.addSpriteFrames("grabDealerRoom.plist", "grabDealerRoom.png", handler(self, self.onLoadedGrabRoomTexture_))
    elseif self.loadGrabRoomTextureNum_ == 3 then
        
        if self.loginGrabRoomSucc_ then
            app:enterGrabDealerRoomScene()
        end
        self.loadedGrabRoomTexture_ = true
        self.loadingGrabRoomTexture_ = false
    end
end

function HallController:loadNewRoomTexture_()
    if not self.loadedGrabRoomTexture_ then
        self.loadingGrabRoomTexture_ = true
        self.loadedGrabRoomTexture_ = false
        self.loadGrabRoomTextureNum_ = 0
        cc.Director:getInstance():getTextureCache():addImageAsync("room_background.png", handler(self, self.onLoadedNewRoomTexture_))
    else
        if self.loginGrabRoomSucc_ then
            app:enterRoomSceneEx()
        end
        self.loadedGrabRoomTexture_ = true
    end
end

function HallController:onLoadedNewRoomTexture_(fileName, imgName)
    self.loadGrabRoomTextureNum_ = self.loadGrabRoomTextureNum_ + 1
    if self.loadGrabRoomTextureNum_ == 1 then
        display.addSpriteFrames("room_texture.plist", "room_texture.png", handler(self, self.onLoadedNewRoomTexture_))
    
    elseif self.loadGrabRoomTextureNum_ == 2 then
        display.addSpriteFrames("grabDealerRoom.plist", "grabDealerRoom.png", handler(self, self.onLoadedNewRoomTexture_))
    
    elseif self.loadGrabRoomTextureNum_ == 3 then
        
        if self.loginGrabRoomSucc_ then
            app:enterRoomSceneEx()
        end
        self.loadedGrabRoomTexture_ = true
        self.loadingGrabRoomTexture_ = false
    end
end

-- Comon Work Follow-up Process Funcs --
function HallController:processUserData(userData)
    userData.inviteSendChips = 1000
    userData.inviteBackChips = 50000
    userData.recallBackChips = 50000
    userData.recallSendChips = 500

    --userData.uid = userData['aUser.mid']
    userData.GIFT_JSON = userData["urls.gift"]
    userData.MSGTPL_ROOT = userData["urls.msg"]
    userData.LEVEL_JSON = userData["urls.level"]
    userData.UPLOAD_PIC = userData["urls.updateicon"]
    userData.WHEEL_CONF = userData["urls.luckyWheel2"]
    userData.DIRTY_LIB  = userData["urls.keyword"]
    userData.MATCH_JSON = userData["urls.match"]
    userData.SCOREMARKET_JSON = userData["urls.matchgift"]
    userData.PROPS_JSON = userData["urls.props"]

    userData.GIFT_SHOP = 1

    if not nk.Level then
        nk.Level = import("app.util.LoadLevelControl").new()
    end

    nk.Level:loadConfig(userData.LEVEL_JSON, function(success, levelData)
        if success then
            local exp = checkint(userData["aUser.exp"])
            local level = userData["aUser.mlevel"]          
            local maxLevel = nk.Level:getLevelByExp(exp)
            local dsLevel = maxLevel- level
            if (maxLevel > level) and (dsLevel >= 1) then
                userData.nextRwdLevel = level + 1
            else
                userData.nextRwdLevel = 0
            end
        end
    end)

    if not nk.MatchConfigEx then
        nk.MatchConfigEx = import("app.module.match.LoadMatchControlEx").new()
    end

    if not nk.MatchRegisterControl then
        nk.MatchRegisterControl = import("app.module.match.MatchRegisterControl").new()
    end

    if not nk.Props then
        nk.Props = import("app.util.LoadPropsControl").new()  
    end

    nk.MatchConfigEx:loadConfig(nil, handler(self, self.onLoadMatchExConfig), true)
    nk.Props:loadConfig(userData.PROPS_JSON, nil)
end

function HallController:onGetMessage()
    MessageData.new()
end

function HallController:onRewardPopup()
    if nk.userData.loginRewardStep and nk.userData.loginRewardStep > 0 then
        self:checkShowNewerGuidePopup()
    end
end

function HallController:showLoginReward()
    -- hacode
    if nk.TestUtil.simuLogrinRewardJust then
        nk.TestUtil.simuLoginReward()
    end

    -- Pop GucuRecallReward Here--
    if nk.userData.recallAward then
        --todo
        if self.view_ and self.view_.popGucuRecallReward then
            --todo
            self.view_:popGucuRecallReward()
        end
    end

    if nk.userData.loginReward and nk.userData.loginReward.ret == 1 then

        -- dump(nk.userData.popad, "nk.userData.popad :==============")
        local userLevelCal = nk.Level:getLevelByExp(nk.userData["aUser.exp"])
        if userLevelCal >= 2 and nk.userData.popad then
            --todo
            if self.view_ and self.view_.popAdPromot then
                --todo
                self.view_:popAdPromot()

                nk.DReport:report({id = "openPopAd"})
            end      
        end
        display.addSpriteFrames("loginreward_texture.plist", "loginreward_texture.png", handler(self, self.onLoadLgTextureComplete))
    end    
end

function HallController:reportInvitableFriends_(inviteAbleFriendNum)
    if device.platform == "android" or device.platform == "ios" then        
        -- local date = nk.userDefault:getStringForKey(nk.cookieKeys.DALIY_REPORT_INVITABLE)       
        nk.Facebook:getInvitableFriends(function(success, friendData) 
            if success then
                dump("FaceBook.getInvitableFriends Data Succ!")
            else
                dump("FaceBook.getInvitableFriends Data Failed!")
            end      
        end, inviteAbleFriendNum)
    end
end

function HallController:onLoadMatchExConfig(isSuccess, matchsdata)
    if isSuccess and matchsdata then
        nk.http.getRegisteredMatchInfo(function(retData)
            dump(retData, "getRegisteredMatchInfo.retData :===================")

            for _, v in pairs(retData) do
                nk.MatchConfigEx:addRegisterMatch(v)
                nk.MatchConfigEx:cacheRegisterMatch(v)
            end
        end, function(errData)
            dump(errData, "getRegisteredMatchInfo.errData :===================")
        end)
    end
end

function HallController:checkShowNewerGuidePopup()
    if not nk.NewerRegRewControl or (nk.NewerRegRewControl:getNewerDay() ~= 1 and nk.NewerRegRewControl:getNewerDay() ~= 2) then
        return
    end

    local registerDay = nk.NewerRegRewControl:getNewerDay()
    local regParam = {}

    regParam.rewardChipNum = 100000
    regParam.rewardNextNum = 200000
    regParam.rewardDayNum = registerDay
    regParam.isNextRewTip = false
    regParam.isPlayAnim = true

    regParam.closeCallback = function()
        -- body
        if nk.NewerRegRewControl then
            --todo
            nk.NewerRegRewControl:setFirstRewardFlag(false)

            local newerDay = nk.NewerRegRewControl:getNewerDay()
            bm.DataProxy:setData(nk.dataKeys.NEWER_GUIDE_DAY, newerDay)
        end
    end

    RegisterAwardPopup.new(regParam):showPanel()
end

function HallController:onLoadLgTextureComplete(fileName, imgName)
    LoginRewardView.new():showPanel(handler(self, self.onLoginRewardViewCallback))
end

function HallController:onLoginRewardViewCallback(data)
    if data then
        if "action_close" == data.action then
            if nk.OnOff:check("ticketTrans") then
                self.requestMatchInfoId_ = nk.http.matchHallInfo(function(retData)
                    -- dump(retData, "matchHallInfo.retData :======================")

                    nk.userData["match.point"] = checkint(retData.point)
                    nk.userData["match.highPoint"] = checkint(retData.highPoint)
                   
                    local tickets = retData.tickets

                    for i = 1, #tickets do
                        local item = tickets[i]
                        local tickKey = "match.ticket_" .. item.pnid
                        nk.userData[tickKey] = checkint(item.pcnter)
                    end

                    if checkint(nk.userData["match.ticket_7104"]) > 0 then
                        TicketTransferPopup.new():show()
                    end

                end, function(errData)
                    dump(errData, "matchHallInfo.errData :=====================")
                    self.requestMatchInfoId_ = nil
                end)
            end
            
        end
    end
end

function HallController:updateUserMaxDiscount()
    local userData = nk.userData
    if not userData then
        return 
    end

    local requestMaxDiscount = nil
    local maxretry = 4

    requestMaxDiscount = function()
        bm.HttpService.POST({mod = "payCenter", act = "getMaxDiscount"}, function(retData)
            local retJson = json.decode(retData)

            if retJson and retJson.ret == 0 then
                userData.__user_discount = tonumber(retJson.discount) or 1
            else
                maxretry = maxretry - 1
                if maxretry > 0 then
                    requestMaxDiscount()
                end
            end
        end, function(errData)
            maxretry = maxretry - 1

            if maxretry > 0 then
                requestMaxDiscount()
            end
        end)
    end
    requestMaxDiscount()
end

function HallController:reportLoginResult_(loginType, code, detail)
     if device.platform == "android" or device.platform == "ios" then
         local eventName = nil
         if loginType == "FACEBOOK" then
             eventName = "login_result_facebook"

         elseif loginType == "GUEST" then
             eventName = "login_result_guest"
         end

         -- if eventName then
         --    cc.analytics:doCommand{
         --        command = "event",
         --        args = {
         --            eventId = eventName,
         --            label = "[" .. code .. "]" .. detail,
         --        },
         --    }
        -- end
    end
end

-- Data Observer && Report Work Logic Funcs --
function HallController:checkMoneyChange(money)
    if not self.hallGlobalMoney_ then
        -- dump("self.hallGlobalMoney_ init Value :" .. self.hallGlobalMoney_)

        self.hallGlobalMoney_ = money
    else
        if nk.userData.bankruptcyGrant and (self.hallGlobalMoney_ > nk.userData.bankruptcyGrant.maxBmoney and money < nk.userData.bankruptcyGrant.maxBmoney) then
            self.hallGlobalMoney_ = money
            local otherFiled = bm.LangUtil.getText("COMMON", "OTHER")

            nk.http.reportBankrupt(0, otherFiled or "")
        elseif nk.userData.bankruptcyGrant and (money > nk.userData.bankruptcyGrant.maxBmoney) then
            self.hallGlobalMoney_ = money
        end
        
    end
end

function HallController:umengEnterHallTimeUsage()
    if device.platform ~= "android" or device.platform ~= "ios" then
        return
    end

    local g = global_statistics_for_umeng

    if g.first_enter_hall_checked then
        return
    end

    g.first_enter_hall_checked = true

    local delta = math.abs(os.difftime(os.time(), g.run_main_timestamp))

    if delta > 60 then delta = 60 end

    -- cc.analytics:doCommand{command = "eventCustom", args = {eventId = "boot_to_hall_time_usage", attributes = "boot_time," .. delta, counter = 1}}
end

function HallController:umengUpdateTimeUsage()
    if device.platform ~= "android" and device.platform ~= "ios" then
        return
    end

    local g = global_statistics_for_umeng
    local firstCheckedFirstapi = g.first_update_checked_firstapi

    if not firstCheckedFirstapi then
        g.first_update_checked_firstapi = true

        local checkFirstApiInfo = g.update_check_info.firstApi
        local succInLimitTime = false

        for i, v in pairs(checkFirstApiInfo) do
            if v.result == "success" then
                succInLimitTime = true
                    -- cc.analytics:doCommand{command = "eventCustom", args = {eventId = "check_update_firstApi_success", attributes = "fail_times," .. (i - 1) ..
                    --     "|success_times," .. (v.check or i) .. "|succ_" .. (v.check or i) .. "," .. (v.time or 0), counter = 1}}

                break
            else
                -- cc.analytics:doCommand{command = "eventCustom", args = {eventId = "check_update_firstApi_success_2", attributes = "fail_" .. (i - 1) .. "," ..
                --     (v.time or 0), counter = 1}}
            end
        end
    end 

    local firstCheckedFlist = g.first_update_checked_flist
    if not firstCheckedFlist then
        g.first_update_checked_flist = true
        local checkFlistInfo = g.update_check_info.flist
        local succInLimitTime1 = false

        for i, v in pairs(checkFlistInfo) do
            if v.result == "success" then
                succInLimitTime1 = true
                    -- cc.analytics:doCommand{command = "eventCustom", args = {eventId = "check_update_flist_success", attributes = "fail_times," .. (i - 1) ..
                    --     "|success_times," .. (v.check or i) .. "|succ_" .. (v.check or i) .. "," .. (v.time or 0), counter = 1}}

                break
            else
                -- cc.analytics:doCommand{command = "eventCustom", args = {eventId = "check_update_flist_success", attributes = "fail_" .. (i - 1) .. "," ..
                --     (v.time or 0), counter = 1}}
            end
        end
    end
end

function HallController:umengLoginTimeUsage()
    if device.platform ~= "android" and device.platform ~= "ios" then
        return
    end

    local g = global_statistics_for_umeng
    local login_check_info = g.login_check_info
    local attributes = ""

    local result = login_check_info.result
    local time = login_check_info.time or 0
    if result == "success" then
        attributes = "success," .. time
    elseif result == "fail" then
         attributes = "fail," .. time
    end

    -- if attributes and string.len(attributes) > 0 then
    --     cc.analytics:doCommand{command = "eventCustom", args = {eventId = "check_login_info", attributes = attributes, counter = 1}}
    -- end
end

-- Compon Work Logic Funcs --
function HallController:bindDataObservers_()
    self.moneyObserverHandle_ = bm.DataProxy:addPropertyObserver(nk.dataKeys.USER_DATA, "aUser.money", handler(self, self.checkMoneyChange))
end

function HallController:unbindDataObservers_()
    bm.DataProxy:removePropertyObserver(nk.dataKeys.USER_DATA, "aUser.money", self.moneyObserverHandle_)
end

function HallController:dispose()
    nk.http.cancel(self.reqPlayerCountId_)
    nk.http.cancel(self.matchPlayerCountRequestId_)

    if self.requestMatchInfoId_ then
        nk.http.cancel(self.requestMatchInfoId_)
        self.requestMatchInfoId_ = nil
    end

    if self.timeMatchPlayerCountRequestId_ then
        nk.http.cancel(self.timeMatchPlayerCountRequestId_)
        self.timeMatchPlayerCountRequestId_ = nil
    end

    bm.EventCenter:removeEventListenersByTag(HallController.SVR_LOGIN_OK_EVENT_TAG)
    bm.EventCenter:removeEventListenersByTag(HallController.SVR_DOUBLE_LOGINUCC_EVENT_TAG)
    bm.EventCenter:removeEventListenersByTag(HallController.SVR_ONLINE_EVENT_TAG)
    bm.EventCenter:removeEventListenersByTag(HallController.SVR_LOGIN_ROOM_OK_EVENT_TAG)
    bm.EventCenter:removeEventListenersByTag(HallController.SVR_LOGIN_ROOM_FAIL_EVENT_TAG)
    bm.EventCenter:removeEventListenersByTag(HallController.SVR_ERROR_EVENT_TAG)
    bm.EventCenter:removeEventListenersByTag(HallController.HALL_LOGOUT_SUCC_EVENT_TAG)
    bm.EventCenter:removeEventListenersByTag(HallController.ENTER_ROOM_WITH_DATA_EVENT_TAG)
    bm.EventCenter:removeEventListenersByTag(HallController.SVR_GET_PERSONAL_ROOM_LIST_EVENT_TAG)
    -- bm.EventCenter:removeEventListenersByTag(HallController.SVR_LOGIN_PERSONAL_ROOM_TAG)
    bm.EventCenter:removeEventListenersByTag(HallController.SVR_SEARCH_PERSONAL_ROOM_TAG)
    bm.EventCenter:removeEventListenersByTag(HallController.SVR_COMMON_BROADCAST_TAG)

    bm.EventCenter:removeEventListenersByTag(HallController.ENTER_MATCH_WITH_DATA_EVENT_TAG)
    bm.EventCenter:removeEventListenersByTag(HallController.ENTER_GRAB_WITH_DATA_EVENT_TAG)
    bm.EventCenter:removeEventListenersByTag(HallController.SVR_LOGIN_OK_NEW_EVENT_TAG)
    bm.EventCenter:removeEventListenersByTag(HallController.SVR_LOGIN_MATCH_ROOM_OK_EVENT_TAG)
    bm.EventCenter:removeEventListenersByTag(HallController.SVR_LOGIN_MATCH_ROOM_FAIL_EVENT_TAG)
    bm.EventCenter:removeEventListenersByTag(HallController.SVR_LOGIN_GRAB_ROOM_OK_EVENT_TAG)
    bm.EventCenter:removeEventListenersByTag(HallController.SVR_LOGIN_GRAB_DELAER_ROOM_FAIL_EVENT_TAG)
    bm.EventCenter:removeEventListenersByTag(HallController.SVR_LOGIN_OK_RE_CONECT_TAG)
    bm.EventCenter:removeEventListenersByTag(HallController.SVR_GRAB_ROOM_LIST_RESULT_EVENT_TAG)
    bm.EventCenter:removeEventListenersByTag(HallController.SVR_SUONA_BROADCAST_RECV_TAG)
    bm.EventCenter:removeEventListenersByTag(HallController.SVR_PUSH_MATCH_ROOM_EVENT_TAG)
    bm.EventCenter:removeEventListenersByTag(HallController.SVR_TIME_MATCH_OFF_TAG)
    bm.EventCenter:removeEventListenersByTag(HallController.SVR_LOGIN_NEW_ROOM_OK_EVENT_TAG)
    
    self:unbindDataObservers_()

    self.suonaMsgQueue_ = nil
    if self.schedulerPool_ then
        self.schedulerPool_:clearAll()
    end
end

return HallController