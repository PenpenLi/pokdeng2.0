--
-- Author: viking@boomegg.com
-- Date: 2014-08-28 16:35:21
-- Copyright: Copyright (c) 2014, BOOMEGG INTERACTIVE CO., LTD All rights reserved.
-- Description: HelpView.lua ReConstructed By Tsing7x.
--
local FeedbackCommon = import("app.module.feedback.FeedbackCommon")

local HelpController = class("HelpController")

HelpController.FEED_BACK  = 1
HelpController.FAQ        = 2
HelpController.RULE       = 3
HelpController.LEVEL      = 4

function HelpController:ctor(helpView)
    self.view_ = helpView
end

function HelpController:getFeedbackListData()
    local feedList = {}
    local g = 2

    bm.HttpService.POST({mod = "feedback", act = "getList"}, function(retData)
        if retData then
            local feedbackRetData = json.decode(retData)
            if feedbackRetData.ret == 0 then
                for i = 1, #feedbackRetData.data do
                    table.insert(feedList, feedbackRetData.data[i])
                end
            end
        end

        g = g - 1
        if g <= 0 then
            table.sort(feedList, function(a, b)
                return a.mtime > b.mtime
            end)

            if self.view_ and self.view_.onGetFeedBackReplyData then
                --todo
                self.view_:onGetFeedBackReplyData(feedList)
            end
        end
    end, function(errData)
        dump(errData, "bm.HttpService.POST:{mod = feedback, act = getList}.errData :==================")
        g = g - 1
        if g <= 0 then
            table.sort(feedList, function(a, b)
                return a.mtime > b.mtime
            end)

            if self.view_ and self.view_.onGetFeedBackReplyData then
                --todo
                self.view_:onGetFeedBackReplyData(feedList)
            end
        end

        nk.TopTipManager:showTopTip(bm.LangUtil.getText("COMMON", "BAD_NETWORK"))
    end)

    FeedbackCommon.getFeedbackList(function(succ, feedbackRetData)
        if succ then
            for i = 1, #feedbackRetData.data do
                table.insert(feedList, feedbackRetData.data[i])
            end
        else
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("COMMON", "BAD_NETWORK"))
        end

        g = g - 1
        if g <= 0 then
            table.sort(feedList, function(a, b)
                return a.mtime > b.mtime
            end)

            if self.view_ and self.view_.onGetFeedBackReplyData then
                --todo
                self.view_:onGetFeedBackReplyData(feedList)
            end
        end
    end)
    
end

function HelpController:getHelpCommonProData()
    -- body
    local data = bm.LangUtil.getText("HELP", "FAQ")
    return data
end

function HelpController:getUserAidData()
    -- body
    local retTable = {}

    local ruleAidData = bm.LangUtil.getText("HELP", "RULE")
    local levelAidData = bm.LangUtil.getText("HELP", "LEVEL")

    local levelData = nk.Level:getLevelConfigData()

    -- dump(levelData, "nk.Level:getLevelConfigData().confData :======================")
    if levelData then
        levelAidData[2] = {T("升级奖励"), ""}
        levelAidData[3] = bm.LangUtil.getText("HELP","CASH_COIN")
    else
        levelAidData[2] = bm.LangUtil.getText("HELP","CASH_COIN")
    end

    table.insertto(retTable, ruleAidData)
    table.insertto(retTable, levelAidData)

    return retTable
end

return HelpController