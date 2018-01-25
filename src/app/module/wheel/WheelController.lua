--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-05-03 10:43:58
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: WheelController.lua Reconstructed By Tsing7x.
--

local WheelController = class("WheelController")

function WheelController:ctor(view)
    self.view_ = view
    self.isTimesReady_ = false
    self.isConfigReady_ = false
end

function WheelController:getPlayTimes(callback)
    self.playTimesId = nk.http.getWheelInitInfo(function(retData)
        if retData then
            self.isTimesReady_ = true
            self.freeTimes_ = retData.num
            callback(true, retData)
        end
    end, function(errData)
        self.isTimesReady_ = false
        callback(false)
    end)
end

function WheelController:getConfig(callback)
    bm.cacheFile(nk.userData.WHEEL_CONF, function(result, content)
        if result == "success" then
            self.isConfigReady_ = true
            local wheelItems_ = json.decode(content)
            callback(true, wheelItems_)
        else
            self.isConfigReady_ = false
            callback(false)
        end
    end, "wheel")
end

function WheelController:playWheelGame(callback)
    self.playNowId = nk.http.getWheelRewardInfo(function(retData)
        if retData then
            callback(true, retData)

            if retData.money then
                local addMoney = retData.money.addMoney
                local money = retData.money.money
            end

            if retData.props then
                nk.http.getUserProps(2, function(retData)
                    if retData then
                        for _, v in pairs(retData) do
                            if tonumber(v.pnid) == 2001 then
                                nk.userData.hddjNum = checkint(v.pcnter)
                                break
                            end
                        end
                    end
                end, function(errData)
                    dump(errData, "nk.http.getUserProps.errData :================")

                end)
            end
        end
    end, function(errData) 
        callback(false) 
    end)
end

function WheelController:shareToGetChance()
    self.getchanceReuqest_ = nk.http.shareWheel(function(retData)
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("WHEEL", "SHARE_GET_CHANCE"))
        self.view_:getPlayTimes()
    end, function(errData)
    end)
end

function WheelController:isTimesReady()
    return self.isTimesReady_
end

function WheelController:isConfigReady()
    return self.isConfigReady_
end

function WheelController:isAllReady()
    return self.isTimesReady_ and self.isConfigReady_
end

function WheelController:dispose()
    nk.http.cancel(self.playTimesId)
    nk.http.cancel(self.playNowId)
    nk.http.cancel(self.getchanceReuqest_)
end

return WheelController