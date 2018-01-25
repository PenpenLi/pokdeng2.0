--
-- Author: tony
-- Date: 2014-11-17 16:33:16
-- Copyright: Copyright (c) 2014, BOOMEGG INTERACTIVE CO., LTD All rights reserved.
-- Description: StorePopupController.lua ReConstructed by Tsing.
--

local LoadGiftControl = import(".LoadGiftControl")

local PurchaseServiceManager = import(".managers.PurchaseServiceManager")

local StorePopupController = class("StorePopupController")
local logger = bm.Logger.new("StorePopupController")

local payConfigJsonTest = [[
    {
        "ret": 0,
        "payTypes": [
            {
                "id": 100,
                "name": "GooglePlay",
                "configURL": "http://d147wns3pm1voh.cloudfront.net/static/nineke/nineke/json/android-53a02243.json",
                "deliveryURL": "http://d25t7ht5vi1l2.cloudfront.net/androidpay.php",
                "discount": {
                    "com.boomegg.nineke.450k": 1.2
                },
                "chipDiscount": 1.1
            },

            {
                "id": 200,
                "name": "AppStore",
                "configURL": "http://d147wns3pm1voh.cloudfront.net/static/nineke/nineke/json/ios-bbc2affd.json",
                "discount": {
                    "com.boomegg.nineke.450k": 1.2
                },
                "chipDiscount": 1.1
            },

            {
                "id": 400,
                "name": "",
                "configURL": "",
                "purchaseURL": "",
                "discount": {
                    "com.boomegg.nineke.450k": 1.2
                },
                "chipDiscount": 1.1
            }
        ]
    }
]]

local payTypeTest = {
    {
        ["id"] = 504,
        ["name"] = "12call",
        ["purchaseURL"] = "",
        ["configURL"] = "http://pirates133.by.com/pokdeng/staticres/data/androidtl/12call-yk-20150717.json",
        ["deliveryURL"] = "",
        ["pmode"] = "472",
        ["discount"] = {},
        ["chipDiscount"] = 1,
        ["moneyDiscount"] = 1,
        ["maxDiscount"] = 1
    },
    
    {
        ["id"] = 100,
        ["name"] = "GooglePlay",
        ["configURL"] = "http://pirates133.by.com/pokdeng/staticres/data/androidtl/android-yk-20150708.json",
        ["deliveryURL"] = "",
        ["discount"] = {},
        ["pmode"] = "12",
        ["chipDiscount"] = 1,
        ["moneyDiscount"] = 1,
        ["maxDiscount"] = 1
    },
    
    {
        ["id"] = 601,
        ["name"] = "BluePay",
        ["configURL"] = "http://pirates133.by.com/pokdeng/staticres/data/androidtl/BluePay-yk-20150721.json",
        -- ["configURL"]= "http://138.128.204.205/BluePay-yk-20150721.json",
        ["deliveryURL"] = "",
        ["discount"] = {},
        ["pmode"] = "240",
        ["chipDiscount"] = 1,
        ["moneyDiscount"] = 1,
        ["maxDiscount"] = 1,
        ["smsIds"] = {
            -- ["120340"] = 41,["12341"] =42,["120342"] = 43 ,["120343"] = 44
        -- }  -- FB Acc
            ["120344"] = 41, ["12345"] =42, ["120346"] = 43, ["120347"] = 44  -- Visitor Acc
        }
    }
}


function StorePopupController:ctor(view)
    self.view_ = view
    self.manager_ = PurchaseServiceManager.new()
end

function StorePopupController:init()
    self:loadPayModConfig()
end

function StorePopupController:loadPayModConfig()
    -- logger:debug("loadPayConfig ..")

    local retryTimes = 3
    local loadPayConfigFuc = nil

    loadPayConfigFuc = function()
        -- dump(BM_UPDATE.VERSION, "BM_UPDATE.VERSION:=============")

        self.reqGetPayConfigDataId_ = nk.http.getPayTypeConfig(BM_UPDATE.VERSION, function(retData)
            -- dump(retData, "nk.http.getPayTypeConfig.retData :=====================")
            if retData then
                -- logger:debug("loadPayConfig complete")
                local payTypeAvailable = {}
                for i, payType in ipairs(retData) do
                    if self.manager_:isServiceAvailable(payType.id) then
                        payTypeAvailable[#payTypeAvailable + 1] = payType
                    end
                end

                -- dump(payTypeAvailable, "payTypeAvailable:==============")
                self.manager_:init(payTypeAvailable)

                if self.view_ and self.view_.renderStoreContViews then
                    --todo
                    self.view_:renderStoreContViews(payTypeAvailable)
                end
            else
                retryTimes = retryTimes - 1

                if retryTimes > 0 then
                    loadPayConfigFuc()
                else
                    nk.TopTipManager:showTopTip("拉取配置数据失败！")

                    if self.view_ and self.view_.hidePanel then
                        --todo
                        self.view_:hidePanel()
                    end
                end
            end

        end, function(errData)
            dump(errData, "nk.http.getPayTypeConfig.errData :===================")

            retryTimes = retryTimes - 1
            if retryTimes > 0 then
                loadPayConfigFuc()
            else
                self.reqGetPayConfigDataId_ = nil
                nk.TopTipManager:showTopTip("网络异常,拉取数据失败！")

                if self.view_ and self.view_.hidePanel then
                    --todo
                    self.view_:hidePanel()
                end
            end
        end)
    end

    loadPayConfigFuc()
end

function StorePopupController:loadChipProductList(payType)
    local service = self:getPurchaseService_(payType)
    service:loadChipProductList(handler(self, self.loadChipProductListResult_))
end

function StorePopupController:loadChipProductListResult_(payType, isComplete, data)
    if self.view_ and self.view_.onStorePrdChipDataGet then
        --todo
        self.view_:onStorePrdChipDataGet(payType, isComplete, data)
    end
end

function StorePopupController:loadCashProductList(payType)
    -- body
    local service = self:getPurchaseService_(payType)
    service:loadCashProductList(handler(self, self.loadCashProductListResult_))
end

function StorePopupController:loadCashProductListResult_(payType, isComplete, data)
    -- body
    if self.view_ and self.view_.onStorePrdCashDataGet then
        --todo
        self.view_:onStorePrdCashDataGet(payType, isComplete, data)
    end
end

function StorePopupController:loadUsrHistryPaymentData()
    -- body
    self.reqLoadHistryDataId_ = nk.http.getPayRecord(function(retData)
        -- body
        -- dump(retData, "nk.http.getPayRecord.retData :================")
        if retData then
            --todo
            if self.view_ and self.view_.onUsrHistryDataGet then
                --todo
                self.view_:onUsrHistryDataGet(retData.list)
            end
        else
            if self.view_ and self.view_.onUsrHistryDataWrong then
                --todo
                self.view_:onUsrHistryDataWrong()
            end
        end
    end, function(errData)
        -- body
        self.reqLoadHistryDataId_ = nil
        dump(errData, "nk.http.getPayRecord.errData :======================")

        if self.view_ and self.view_.onUsrHistryDataWrong then
            --todo
            self.view_:onUsrHistryDataWrong()
        end
    end)
end

function StorePopupController:loadTicketProductList(paytype)
    local service = self:getPurchaseService_(paytype)
    service:loadTicketProductList(handler(self, self.loadTicketProductListResult_))
end

function StorePopupController:loadTicketProductListResult_(paytype, isComplete, data)
    self.view_:setTicketList(paytype, isComplete, data)
end

function StorePopupController:loadPropProductList(paytype)
    local service = self:getPurchaseService_(paytype)
    service:loadPropProductList(handler(self, self.loadPropProductListResult_))
end

function StorePopupController:loadPropProductListResult_(paytype, isComplete, data)
    self.view_:setPropList(paytype, isComplete, data)
end

function StorePopupController:getGiftWarePrdData()
    -- body
    if not self.giftWareData_ then
        self.hotGift_ = {}
        self.newArrGift_ = {}
        self.festivalGift_ = {}
        self.otherGift_ = {}

        LoadGiftControl:getInstance():loadConfig(nk.userData.GIFT_JSON, function(success, data)
            if success then
                self.giftWareData_ = data

                -- dump(self.giftWareData_, "StorePopupController:getGiftWarePrdData.giftWareData_ :=================")
                for i = 1, #data do
                    if data[i].status == "1"  then
                        if data[i].gift_category == "0" then
                            table.insert(self.hotGift_, data[i])

                        elseif data[i].gift_category == "1" then
                            table.insert(self.newArrGift_, data[i])

                        elseif data[i].gift_category == "2" then
                            table.insert(self.festivalGift_, data[i])

                        elseif  data[i].gift_category == "3" then 
                            table.insert(self.otherGift_, data[i])
                        end
                    end
                end
                -- dump(self.hotGift_, "StorePopupController:getGiftWarePrdData.hotGift_ :===================")
            else

                if self.view_ and self.view_.onGetWarePrdDataWrong then
                    --todo
                    self.view_:onGetWarePrdDataWrong(1)
                end
            end
        end)
    end
end

function StorePopupController:getPropsWarePrdData()
    -- body
    self.reqGetPropPrdDataId_ = nk.http.getPropShopProdList(function(retData)
        -- body
        dump(retData, "nk.http.getPropShopProdList.retData :=================")
        if retData then
            --todo

            if self.view_ and self.view_.onPropPrdWareDataGet then
                --todo
                self.view_:onPropPrdWareDataGet(retData)
            end
        end
    end, function(errData)
        -- body

        dump(errData, "nk.http.getPropShopProdList.errData:=================")
        self.reqGetPropPrdDataId_ = nil
        if self.view_ and self.view_.onGetWarePrdDataWrong then
            --todo
            self.view_:onGetWarePrdDataWrong(2)
        end
    end)
end

function StorePopupController:presentGiftToPlayer(giftId, toUid)
    -- body
    -- log("StorePopupController:presentGiftToUid.giftId :" .. giftId .. " toUid :" .. toUid)

    if self.reqPresentGiftToOtherId_ then
        --todo
        return
    end

    if toUid == nk.userData.uid then
        --todo
        self:buyGiftToSelf(giftId, function()
            nk.server:sendRoomGift(giftId, {toUid})
        end)
        
    else
        self.reqPresentGiftToOtherId_ = nk.http.giftBuy(giftId, toUid, function(retData)

            -- dump(retData, "nk.http.giftBuy.retData :====================")
            if retData then
                nk.TopTipManager:showTopTip(bm.LangUtil.getText("GIFT", "PRESENT_GIFT_SUCCESS_TOP_TIP"))

                local money = checkint(retData.money)
                local subMoney = checkint(retData.subMoney)

                if money and money >= 0 then
                    nk.userData["aUser.money"] = money
                end

                if retData.addMoney then
                    local addMoney = checkint(retData.addMoney)
                    bm.EventCenter:dispatchEvent({name = nk.eventNames.UPDATE_SEAT_ANTE_CHIP, data = {chip = addMoney}})
                end

                nk.server:sendRoomGift(giftId, {toUid})

                if self.view and self.view_.hidePanel then
                    --todo
                    self.view_:hidePanel()
                end

                self.reqPresentGiftToOtherId_ = nil
            end
        end, function(errData)
                dump(errData, "nk.http.giftBuy.errData :====================")
                self.reqPresentGiftToOtherId_ = nil

                if errData.errorCode == - 6 then
                    --todo
                    nk.TopTipManager:showTopTip(bm.LangUtil.getText("GIFT", "FAILD_NOTENOUGH_MONEY"))
                else
                    nk.TopTipManager:showTopTip(bm.LangUtil.getText("GIFT", "BUY_GIFT_FAIL_TOP_TIP"))
                end
                
        end)
    end
end

function StorePopupController:presentGiftToTable(giftId, toUidArr, allTableId)
    -- body
    if self.reqPresentTabelGiftId_ then
        --todo
        return
    end

    self.reqPresentTabelGiftId_ = nk.http.giftBuy(giftId, allTableId, function(retData)
        -- dump(retData, "nk.http.giftBuy.retData :==================")

        if retData then
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("GIFT", "PRESENT_TABLE_GIFT_SUCCESS_TOP_TIP"))

            nk.server:sendRoomGift(giftId, toUidArr)

            if retData.addMoney then
                local addMoney = checkint(retData.addMoney)
                bm.EventCenter:dispatchEvent({name = nk.eventNames.UPDATE_SEAT_ANTE_CHIP, data = {chip = addMoney}})
            end

            if self.view_ and self.view_.hidePanel then
                --todo
                self.view_:hidePanel()
            end
        end

        self.reqPresentTabelGiftId_ = nil
    end, function(errData)
        dump(errData, "nk.http.giftBuy.errData :===================")
        self.reqPresentTabelGiftId_ = nil

        if errData.errorCode == - 6 then
            --todo
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("GIFT", "FAILD_NOTENOUGH_MONEY"))
        else
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("GIFT", "PRESENT_TABLE_GIFT_FAIL_TOP_TIP"))
        end
        
    end)
end

function StorePopupController:buyGiftToSelf(giftId)
    -- body
    if self.reqGiftBuyToSelfId_ then
        return 
    end

    -- log("StorePopupController:buyGiftToSelf.giftId :" .. giftId)
    self.reqGiftBuyToSelfId_ = nk.http.giftBuy(giftId, nk.userData.uid, function(retData)
        -- dump(retData, "nk.http.giftBuy.retData :====================")
        if retData then
            
            local money = checkint(retData.money)
            local subMoney = checkint(retData.subMoney)

            if money and money >= 0 then
                nk.userData["aUser.money"] = money
            end

            if retData.addMoney then
                local addMoney = checkint(retData.addMoney)
                bm.EventCenter:dispatchEvent({name = nk.eventNames.UPDATE_SEAT_ANTE_CHIP, data = {chip = addMoney}})
            end

            self.purchGiftId_ = giftId
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("GIFT", "BUY_GIFT_SUCCESS_TOP_TIP"))

            if retData.addMoney then
                local addMoney = checkint(retData.addMoney)
                bm.EventCenter:dispatchEvent({name = nk.eventNames.UPDATE_SEAT_ANTE_CHIP, data = {chip = addMoney}})
            end
        end

        self.reqGiftBuyToSelfId_ = nil
    end, function(errData)
        dump(errData, "nk.http.giftBuy.errData :==================")
        self.reqGiftBuyToSelfId_ = nil

        if errData.errorCode == - 6 then
            --todo
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("GIFT", "FAILD_NOTENOUGH_MONEY"))
        else
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("GIFT", "BUY_GIFT_FAIL_TOP_TIP"))
        end
    end)
end

function StorePopupController:wearPurchedGift()
    -- body
    if self.purchGiftId_ == nk.userData["aUser.gift"] or not self.purchGiftId_ then
        return 
    end
   
    nk.http.useProps(self.purchGiftId_, function(retData)
        -- dump(retData, "nk.http.useProps.retData :=================")

        nk.userData["aUser.gift"] = self.purchGiftId_
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("GIFT", "SET_GIFT_SUCCESS_TOP_TIP"))
    end, function(errData)
        dump(errData, "nk.http.useProps.errData :===============")
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("GIFT", "SET_GIFT_FAIL_TOP_TIP"))
    end)
end

function StorePopupController:buyPropsById(propsPackId)
    -- body
    if self.buyPropsPackRequestId_ then
        --todo
        return
    end
    
    self.buyPropsPackRequestId_ = nk.http.buyProps(propsPackId, function (data)
        -- body
        -- dump(data, "buyProps.data:===============")

        nk.TopTipManager:showTopTip(bm.LangUtil.getText("STORE", "BUY_PROPPACK_SUCC"))
        nk.userData["aUser.money"] = data.money
        nk.userData.hddjNum = data.props

        self.buyPropsPackRequestId_ = nil

        if data.addMoney then
            local addMoney = checkint(data.addMoney)
            bm.EventCenter:dispatchEvent({name = nk.eventNames.UPDATE_SEAT_ANTE_CHIP, data = {chip = addMoney}})
        end
    end,
    function(errData)
        -- body
        -- dump(errData, "buyProps.errData:==============")
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("STORE", "BUY_PROP_FAILD"))
        self.buyPropsPackRequestId_ = nil
    end)
end

function StorePopupController:getPurchaseService_(paytype)
    return self.manager_:getPurchaseService(paytype.id)
end

function StorePopupController:getGiftGroupByIdx(index)
    -- body
    local getGiftGroup = {
        [1] = function()
            -- body
            return self.hotGift_
        end,

        [2] = function()
            -- body
            return self.newArrGift_
        end,

        [3] = function()
            -- body
            return self.festivalGift_
        end,

        [4] = function()
            -- body
            return self.otherGift_
        end
    }

    return getGiftGroup[index]()
end

function StorePopupController:onGiftWareTypeSelChaned(selType)
    -- body
    local giftWareSelGroupData = self:getGiftGroupByIdx(selType)

    if self.view_ and self.view_.onSelGiftTypeWareDataGet then
        --todo
        self.view_:onSelGiftTypeWareDataGet(selType, giftWareSelGroupData)
    end
end

function StorePopupController:makePurchase(paytype, pid, goodData)
    local service = self:getPurchaseService_(paytype)
    service:makePurchase(pid, handler(self, self.purchaseResult_), goodData)
end

function StorePopupController:prepareEditBox(paytype, input1, input2, submitBtn)
    local service = self:getPurchaseService_(paytype)
    service:prepareEditBox(input1, input2, submitBtn)
end

function StorePopupController:onInputCardInfo(paytype, productType, input1, input2, submitBtn)
    local service = self:getPurchaseService_(paytype)
    service:onInputCardInfo(productType, input1, input2, submitBtn, handler(self, self.purchaseResult_))
end

function StorePopupController:purchaseResult_(succ, result)
    if succ then
        self:loadUsrHistryPaymentData()
        bm.EventCenter:dispatchEvent(nk.eventNames.ROOM_REFRESH_HDDJ_NUM)

        nk.http.getMemberInfo(nk.userData["aUser.mid"], function(retData)
            -- body
            if retData then
                --todo
                nk.userData["aUser.money"] = retData.aUser.money or nk.userData["aUser.money"] or 0

                nk.userData["match"] = retData.match or nk.userData["match"]
                nk.userData["match.point"] = retData.match.point or nk.userData["match.point"]
                nk.userData["match.highPoint"] = retData.match.highPoint or nk.userData["match.highPoint"]
            end
        end,function(errData)
            -- body
            dump(errData, "purchaseResult_:getMemberInfo.errData:===============")
        end)

        nk.http.getUserProps(2, function(pdata)
            if pdata then
                for _, v in pairs(pdata) do
                    if tonumber(v.pnid) == 2001 then
                        nk.userData.hddjNum = checkint(v.pcnter)
                        break
                    end
                end
            end
            
        end, function(errData)
            dump(errData, "purchaseResult_:getUserProps.errData:===============")
        end)
    end
end

function StorePopupController:dispose()
    if self.reqGetPayConfigDataId_ then
        --todo
        nk.http.cancel(self.reqGetPayConfigDataId_)
    end

    if self.reqLoadHistryDataId_ then
        --todo
        nk.http.cancel(self.reqLoadHistryDataId_)
    end

    if self.reqGetPropPrdDataId_ then
        --todo
        nk.http.cancel(self.reqGetPropPrdDataId_)
    end

    if self.reqPresentGiftToOtherId_ then
        --todo
        nk.http.cancel(self.reqPresentGiftToOtherId_)
    end

    if self.reqGiftBuyToSelfId_ then
        --todo
        nk.http.cancel(self.reqGiftBuyToSelfId_)
    end

    if self.reqPresentTabelGiftId_ then
        --todo
        nk.http.cancel(self.reqPresentTabelGiftId_)
    end
    
    self.manager_:autoDispose()
end

return StorePopupController
