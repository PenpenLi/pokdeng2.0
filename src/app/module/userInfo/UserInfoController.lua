--
-- Author: johnny@boomegg.com
-- Date: 2014-09-05 10:57:15
-- Copyright: Copyright (c) 2014, BOOMEGG INTERACTIVE CO., LTD All rights reserved.
--

local UserInfoController = class("UserInfoController")

function UserInfoController:ctor(view)
    self.view_ = view
end

function UserInfoController:loadUsrDataUpdate()
    -- body
    self.reqUsrUpdateDataId_ = nk.http.getMemberInfo(nk.userData["aUser.mid"], function(retData)
        if retData then
            -- dump(retData, "getMemberInfo.retData :=================", 5)
            nk.userData["aUser.name"] = retData.aUser.name or nk.userData["aUser.name"] or ""
            nk.userData["aUser.money"] = retData.aUser.money or nk.userData["aUser.money"] or 0
            nk.userData["aUser.lastMoney"] = retData.aUser.lastMoney or nk.userData["aUser.lastMoney"] or 0

            nk.userData["aUser.gift"] = retData.aUser.gift or nk.userData["aUser.gift"] or 0
            nk.userData["aUser.mlevel"] = retData.aUser.mlevel or nk.userData["aUser.mlevel"] or 1
            nk.userData["aUser.exp"] = retData.aUser.exp or nk.userData["aUser.exp"] or 0
            nk.userData["aUser.win"] = retData.aUser.win or nk.userData["aUser.win"] or 0
            nk.userData["aUser.lose"] = retData.aUser.lose or nk.userData["aUser.lose"] or 0
            nk.userData["aUser.msex"] = retData.aUser.msex or nk.userData["aUser.msex"] or 0
            nk.userData["aUser.micon"] = retData.aUser.micon or nk.userData["aUser.micon"] or ""
            nk.userData["aUser.mcity"] = retData.aUser.mcity or nk.userData["aUser.mcity"] or 0
            

            nk.userData["aBest.maxmoney"] = retData.aBest.maxmoney or nk.userData["aBest.maxmoney"] or 0
            nk.userData["aBest.maxwmoney"] = retData.aBest.maxwmoney or nk.userData["aBest.maxwmoney"] or 0
            nk.userData["aBest.maxwcard"] = retData.aBest.maxwcard or nk.userData["aBest.maxwcard"] or 0
            nk.userData["aBest.rankMoney"] = retData.aBest.rankMoney or nk.userData["aBest.rankMoney"] or 0

            nk.userData["match"] = retData.match
            nk.userData["match.point"] = retData.match.point
            nk.userData["match.highPoint"] = retData.match.highPoint

            if nk.userData["aUser.money"] > nk.userData["aBest.maxmoney"] then
                nk.userData["aBest.maxmoney"] = nk.userData["aUser.money"]
                
                local info = {}
                info.maxmoney = nk.userData["aBest.maxmoney"]

                nk.http.updateMemberBest(info, function(retData)
                    -- body
                    -- dump(retData, "nk.http.updateMemberBest.retData :================")
                end, function(errData)
                    -- body
                    -- dump("updateMemberBest Failed!")
                    dump(errData, "nk.http.updateMemberBest.errData :================")
                end)

                retData.aBest.maxmoney = nk.userData["aBest.maxmoney"]
            end

            if self.view_ and self.view_.onGetUsrInfoDataUpdated then
                --todo
                self.view_:onGetUsrInfoDataUpdated()
            end
        end
    end, function(errData)
        dump(errData, "nk.http.getMemberInfo.errData :===================")
        self.reqUsrUpdateDataId_ = nil
    end)
end

function UserInfoController:getUsrPropsData()
    nk.http.cancel(self.reqHddjNumId_)
     
    self.reqHddjNumId_ = nk.http.getUserProps("1,2,7,8", function(pdata)
        if pdata then
            -- dump(pdata, "nk.http.getUserProps.pdata :=================")

            for _, v in pairs(pdata) do
                if tonumber(v.pnid) == 2001 then
                    nk.userData.hddjNum = checkint(v.pcnter)
                    break
                end
            end

            if self.view_ and self.view_.onPropsDataGet then
                --todo
                self.view_:onPropsDataGet(pdata)
            end
        end
    
    end, function(errData)
        self.reqHddjNumId_ = nil
        dump(errData, "nk.http.getUserProps.errData :==================")

        if self.view_ and self.view_.onGetUsrPropsDataWrong then
            --todo
            self.view_:onGetUsrPropsDataWrong(errData)
        end
    end)
end

function UserInfoController:getMyGiftData()
    -- body
    local retryTimes = 3

    local request = nil
    request = function()
        self.reqMyGiftDataId_ = nk.http.giftMineInfo("0,2,3,4", handler(self, self.onMyGiftDataGet), function(errData)
            dump(errData, "nk.http.giftMineInfo.errData :===================")
            
            retryTimes = retryTimes - 1
            if retryTimes >= 0 then
                if request then
                    --todo
                    request()
                end
            else
                self.reqMyGiftDataId_ = nil
                if self.view_ and self.view_.onGetMyGiftDataWrong then
                    --todo
                    self.view_:onGetMyGiftDataWrong()
                end
            end
        end)
    end

    request()
end

--pmode:'0,1,2,3,4,5'   //道具来源，0系统 1管理员添加 2商城购买 3好友赠送 4任务获得 5使用道具获得
function UserInfoController:onMyGiftDataGet(data)
    -- body
    -- dump(data, "nk.http.giftMineInfo.data :=====================")
    local selfBuyGiftData = {}
    local friendPresentData = {}
    local systemPresentData = {}

    self.myGiftData_ = {}
    
    if data then
        for i = 1, #data do
            local giftData = {}
            giftData.giftId_ = tonumber(data[i].pnid)
            giftData.giftExpireTime_ = data[i].day

            if checkint(data[i].pmode) == 2 then
                table.insert(selfBuyGiftData, giftData)

            elseif checkint(data[i].pmode) == 3 then
                table.insert(friendPresentData, giftData)

            elseif checkint(data[i].pmode) == 0 or checkint(data[i].pmode) == 4 then
                table.insert(systemPresentData, giftData)
            end
        end
    end

    self.myGiftData_[1] = selfBuyGiftData
    self.myGiftData_[2] = friendPresentData
    self.myGiftData_[3] = systemPresentData

    if self.view_ and self.view_.onMyGiftFilterTypeDataGet then
        --todo
        self.view_:onMyGiftFilterTypeDataGet(self.myGiftData_[self.giftSubTabIdx_])
    end
end

function UserInfoController:wareGiftBySelectedId(isInRoom)
    -- body
    if self.giftWaredId_ ~= nk.userData["aUser.gift"] then
        --todo
        nk.http.useProps(nk.userData["aUser.gift"], function(retData)
            -- dump(retData, "nk.http.useProps.retData :===============")
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("GIFT", "SET_GIFT_SUCCESS_TOP_TIP"))

            self.giftWaredId_ = nk.userData["aUser.gift"]
            
            if isInRoom then
                nk.server:updateRoomGift(nk.userData["aUser.gift"], nk.userData.uid)
            end
        end, function(errData)
            dump(errData, "nk.http.useProps.errData :===============")

            nk.TopTipManager:showTopTip(bm.LangUtil.getText("GIFT", "SET_GIFT_FAIL_TOP_TIP"))
            self.giftWaredId_ = nil
        end)
    end
end

function UserInfoController:cancelBankPsw(callback)
    -- body
    self.reqCancelBankPswId_ = nk.http.delPassword(function(retData)
        -- dump(retData, "nk.http.delPassword.retData :==================")

        nk.userData["aUser.bankLock"] = 0 
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("BANK", "CANCEL_PASSWORD_SUCCESS_TOP_TIP"))
        
        if callback then
            --todo
            callback()
        end
    end, function(errData)
        dump(errData, "nk.http.delPassword.errData :==================")

        self.reqCancelBankPswId_ = nil
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("COMMON", "BAD_NETWORK"))
    end)

end

function UserInfoController:saveMoneyIntoBank(currencyNum, currencyType)
    -- body
    self.reqSaveCurrencyInBankId_ = nk.http.bankSaveMoney(currencyNum, currencyType, function(retData)
        -- dump(retData, "nk.http.bankSaveMoney.retData :=================")

        if retData then
            --todo
            nk.userData["aUser.bankMoney"] = retData.bankmoney
            nk.userData["aUser.money"] = retData.gameMoney
            nk.userData["aUser.bankPoint"] = retData.bankpoint
            nk.userData['match.point'] = retData.gamePoint

            if self.view_ and self.view_.onBankSaveMoneySucc then
                --todo
                self.view_:onBankSaveMoneySucc()
            end

            nk.TopTipManager:showTopTip(bm.LangUtil.getText("BANK", "USE_BANK_SAVE_CHIP_SUCCESS_TOP_TIP"))
        else
            if self.view_ and self.view_.onSaveBankMoneyWrong then
                --todo
                self.view_:onSaveBankMoneyWrong()
            end

            nk.TopTipManager:showTopTip(bm.LangUtil.getText("BANK", "USE_BANK_SAVE_CHIP_FAIL_TOP_TIP"))
        end

    end, function(errData)
        dump(errData, "nk.http.bankSaveMoney.errData :====================")

        self.reqSaveCurrencyInBankId_ = nil
        if errData then
            --todo
            local errTypeCode = checkint(errData.errorCode)

            if errTypeCode == - 3 then
                --todo
                nk.TopTipManager:showTopTip(bm.LangUtil.getText("BANK", "BANK_SQL_ERROR"))
            elseif errTypeCode == - 7 then
                --todo
                if errData.retData and errData.retData.data then
                    --todo
                    local limit = errData.limitNum or 3
                    nk.TopTipManager:showTopTip(bm.LangUtil.getText("BANK", "BANK_LIMIT_NUM_TIP", limit, limit))
                else
                    nk.TopTipManager:showTopTip(bm.LangUtil.getText("BANK", "USE_BANK_SAVE_CHIP_FAIL_TOP_TIP"))
                end
            else
                nk.TopTipManager:showTopTip(bm.LangUtil.getText("BANK", "USE_BANK_SAVE_CHIP_FAIL_TOP_TIP"))
            end
        else
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("COMMON", "BAD_NETWORK"))
        end

        if self.view_ and self.view_.onSaveBankMoneyWrong then
            --todo
            self.view_:onSaveBankMoneyWrong()
        end
    end)

end

function UserInfoController:drawMoneyFromBank(currencyNum, currencyType)
    -- body
    self.reqDrawCurrencyFromBankId_ = nk.http.bankGetMoney(currencyNum, currencyType, function(retData) 
        -- dump(retData, "nk.http.bankGetMoney.retData :==================")
        if retData then
            --todo
            nk.userData["aUser.bankMoney"] = retData.bankmoney
            nk.userData["aUser.money"] = retData.gameMoney
            nk.userData["aUser.bankPoint"] = retData.bankpoint
            nk.userData['match.point'] = retData.gamePoint

            if self.view_ and self.view_.onBankDrawMoneySucc then
                --todo
                self.view_:onBankDrawMoneySucc()
            end

            nk.TopTipManager:showTopTip(bm.LangUtil.getText("BANK", "USE_BANK_DRAW_CHIP_SUCCESS_TOP_TIP"))
        else
            if self.view_ and self.view_.onDrawBankMoneyWrong then
                --todo
                self.view_:onDrawBankMoneyWrong()
            end

            nk.TopTipManager:showTopTip(bm.LangUtil.getText("BANK","USE_BANK_SAVE_CHIP_FAIL_TOP_TIP"))
        end
    end, function(errData)
        dump(errData, "nk.http.bankGetMoney.errData :==================")

        self.reqDrawCurrencyFromBankId_ = nil
        if errData then
            local errTypeCode = checkint(errData.errorCode)

            if errTypeCode == - 4 then
                 nk.TopTipManager:showTopTip(bm.LangUtil.getText("BANK","BANK_SQL_ERROR")) 
            else
                nk.TopTipManager:showTopTip(bm.LangUtil.getText("BANK", "USE_BANK_DRAW_CHIP_FAIL_TOP_TIP"))
            end
        else
           nk.TopTipManager:showTopTip(bm.LangUtil.getText("COMMON", "BAD_NETWORK"))
        end

        if self.view_ and self.view_.onDrawBankMoneyWrong then
            --todo
            self.view_:onDrawBankMoneyWrong()
        end
    end)
end

function UserInfoController:updateUsrInfo(param)
    -- body
    nk.http.modifyUserInfo(param, function(retData)
        -- body
        -- dump(retData, "nk.http.modifyUserInfo.retData :===================")
        nk.userData["aUser.msex"] = param.msex
        nk.userData["aUser.name"] = param.name

    end, function(errData)
        -- body
        dump(errData, "nk.http.modifyUserInfo.errData :===================")
    end)
end

function UserInfoController:onUsrGiftTypeSelChanged(tabId)
    -- body
    self.giftSubTabIdx_ = tabId

    if self.view_ and self.view_.onMyGiftFilterTypeDataGet then
        --todo

        if self.myGiftData_ and self.myGiftData_[self.giftSubTabIdx_] then
            --todo
            self.view_:onMyGiftFilterTypeDataGet(self.myGiftData_[self.giftSubTabIdx_])
        end
    end
end

function UserInfoController:setWareGiftId(giftId)
    -- body
    self.giftWaredId_ = giftId
end

function UserInfoController:dispose()
    if self.reqHddjNumId_ then
        --todo
        nk.http.cancel(self.reqHddjNumId_)
    end

    if self.reqUsrUpdateDataId_ then
        --todo
        nk.http.cancel(self.reqUsrUpdateDataId_)
    end

    if self.reqMyGiftDataId_ then
        --todo
        nk.http.cancel(self.reqMyGiftDataId_)
    end

    if self.reqSaveCurrencyInBankId_ then
        --todo
        nk.http.cancel(self.reqSaveCurrencyInBankId_)
    end

    if self.reqDrawCurrencyFromBankId_ then
        --todo
        nk.http.cancel(self.reqDrawCurrencyFromBankId_)
    end
end

return UserInfoController