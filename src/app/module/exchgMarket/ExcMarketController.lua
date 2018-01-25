--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-06-07 18:19:15
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: ExcMarketController.lua Created By Tsing7x.
--

local ExcMarketController = class("ExcMarketController")

function ExcMarketController:ctor(view)
    self.view_ = view
end

function ExcMarketController:getExchangeMarketInitData()
	-- body
	self.reqExcMarketInitId_ = nk.http.getShopInitInfo(function(retData)
		-- dump(retData, "nk.http.getShopInitInfo.retData :=====================")

		if retData then
			--todo
			if self.view_ and self.view_.renderLeftExcWareTypesView then
				--todo
				self.view_:renderLeftExcWareTypesView(retData)
			end
		else
			if self.view_ and self.view_.onGetMarketInitDataWrong then
				--todo
				self.view_:onGetMarketInitDataWrong()
			end
		end
	end, function(errData)
		self.reqExcMarketInitId_ = nil
		dump(errData, "nk.http.getShopInitInfo.errData :===================")
		
		if self.view_ and self.view_.onGetMarketInitDataWrong then
			--todo
			self.view_:onGetMarketInitDataWrong(errData)
		end
	end)
end

-- Alert Interface to Get All Exchange Records <PHP Assit>--
function ExcMarketController:getMyExcRecordData(groupData)

	self.reqGetMyExcRecordDataId_ = nk.http.getMyExchangeRecord(groupData, function(retData)
		-- dump(retData, "nk.http.getMyExchangeRecord.retData :===================")
		if retData then
			--todo
			if self.view_ and self.view_.onMyExcRecordDataGet then
				--todo
				self.view_:onMyExcRecordDataGet(retData)
			end
		else
			if self.view_ and self.view_.getMainContListDataWrong then
				--todo
				self.view_:getMainContListDataWrong()
			end
		end

	end, function(errData)
		self.reqGetMyExcRecordDataId_ = nil
		dump(errData, "nk.http.getMyExchangeRecord.errData :===================")

		if self.view_ and self.view_.getMainContListDataWrong then
			--todo
			self.view_:getMainContListDataWrong(errData)
		end
	end)

end

function ExcMarketController:getExcWareData(groupData)

	self.reqGetExcWareDataId_ = nk.http.getShopGoods(groupData, function(retData)
		-- dump(retData, "nk.http.getShopGoods.retData :===================")
		if retData then
			--todo
			if self.view_ and self.view_.onExcWareListDataGet then
				--todo
				self.view_:onExcWareListDataGet(retData)
			end
		else
			if self.view_ and self.view_.getMainContListDataWrong then
				--todo
				self.view_:getMainContListDataWrong()
			end
		end

    end, function(errData)
    	self.reqGetExcWareDataId_ = nil
    	dump(errData, "nk.http.getShopGoods.errData :===================")

    	if self.view_ and self.view_.getMainContListDataWrong then
			--todo
			self.view_:getMainContListDataWrong(errData)
		end
    end)
end

function ExcMarketController:exchangePrd(itemData)
	
	self.reqExcPrdId_ = nk.http.exchangeGoodById(itemData.gid, itemData.category, function(retData)
		-- dump(retData, "nk.http.exchangeGoodById.retData :=====================")

		nk.userData["match.point"] = data.point and tonumber(data.point) or nk.userData["match.point"]
		nk.userData["aUser.money"] = data.money and tonumber(data.money) or nk.userData["aUser.money"]
		nk.userData["match.ticket"] = data.ticket and tonumber(data.ticket) or nk.userData["match.ticket"]

		if self.view_ and self.view_.getExcMainContPagesData then
			--todo
			self.view_:getExcMainContPagesData()
		end

		nk.TopTipManager:showTopTip(bm.LangUtil.getText("SCOREMARKET", "EXCHANGE_SUCCESS_TIP"))
	end, function(errData)
		self.reqExcPrdId_ = nil
		local retData = errData.retData
		
		local checkDiffData = function(cdata)
			local cashStr = nil
			local ticketStr = nil
			local otherTicketStr = nil
			local chipStr = nil
			local diffStrTb = {}

			if checkint(cdata.diffMoney) > 0 then
				chipStr = bm.LangUtil.getText("SCOREMARKET", "CHIP_NUM", checkint(cdata.diffMoney))
				table.insert(diffStrTb, chipStr)
			end

			if checkint(cdata.diffPoint) > 0 then
				cashStr = bm.LangUtil.getText("SCOREMARKET", "CASH_NUM", checkint(cdata.diffPoint))
				table.insert(diffStrTb, cashStr)
			end

			if checkint(cdata.diffOtherTicket) > 0 then
				otherTicketStr = bm.LangUtil.getText("SCOREMARKET", "OTHER_TICKET_NUM", checkint(cdata.diffOtherTicket))
				table.insert(diffStrTb, otherTicketStr)
			end

			if checkint(cdata.diffTicket) > 0 then
				ticketStr = bm.LangUtil.getText("SCOREMARKET", "TICKET_NUM", checkint(cdata.diffTicket))
				table.insert(diffStrTb, ticketStr)
			end

			return diffStrTb, cdata
		end

		local diffStr = nil
		local diffData = nil
		if retData and retData.data then
			local data = retData.data
			local stb, dffData = checkDiffData(data)

			if stb and #stb > 0 then
				diffStr = table.concat(stb, ",")
			end

			diffData = dffData
		end

		if errData.errorCode == - 3 then
			nk.TopTipManager:showTopTip(bm.LangUtil.getText("SCOREMARKET", "NOTENOUGH_LEFT_CNT"))
		elseif errData.errorCode == - 7 then
			if diffStr and diffData then
				nk.ui.Dialog.new({messageText = bm.LangUtil.getText("SCOREMARKET", "NEED_TIP", diffStr), secondBtnText = bm.LangUtil.getText("SCOREMARKET", "TO_PLAY"),
			    	closeWhenTouchModel = true, callback = function(type)
			        	if type == nk.ui.Dialog.SECOND_BTN_CLICK then
			            	if self and self.doJump then
			            		--todo
			            		if nk.userData["match.point"] < 10 then
			                		local timMatchTag = "timMatch"
				                	self:doJump(timMatchTag)
				                	nk.PopupManager:removeAllPopup()
				                else
			                		local ChooseCashRoomTag = "cashRoomChoose"
									self:doJump(ChooseCashRoomTag)
									nk.PopupManager:removeAllPopup()
				                end
			            	end
			            end
			        end}
			    ):show()

			end

		elseif errData.errorCode == - 8 then
			nk.TopTipManager:showTopTip(bm.LangUtil.getText("SCOREMARKET", "NOTENOUGH_SCORE_2"))
		elseif errData.errorCode == - 11 then
			if errData.retData and errData.retData["data"] then
				local edata = errData.retData["data"]
				local limit = edata["limit"] or 1
				local allLimit = edata["allLimit"] or 1

				nk.ui.Dialog.new({messageText = bm.LangUtil.getText("SCOREMARKET", "NUM_LIMIT_TIP"), secondBtnText = bm.LangUtil.getText("SCOREMARKET", "TO_PLAY"),
			    	closeWhenTouchModel = true, callback = function(type)
			            if type == nk.ui.Dialog.SECOND_BTN_CLICK then
			                if self and self.doJump then
			                	--todo
			                	if nk.userData["match.point"] < 10 then
				                	local timMatchTag = "timMatch"
				                	self:doJump(timMatchTag)
				                	nk.PopupManager:removeAllPopup()
				                else
				                	local ChooseCashRoomTag = "cashRoomChoose"
									self:doJump(ChooseCashRoomTag)
									nk.PopupManager:removeAllPopup()
				                end
			                end
			            end
			        end}
			    ):show()
			end

		elseif errData.errorCode == - 12 then
			nk.TopTipManager:showTopTip(bm.LangUtil.getText("SCOREMARKET", "NOTENOUGH_SCORE_3"))
		elseif errData.errorCode == - 13 then
			if diffStr and diffData then
				nk.ui.Dialog.new({messageText = bm.LangUtil.getText("SCOREMARKET", "NEED_TIP", diffStr), secondBtnText = bm.LangUtil.getText("SCOREMARKET", "TO_GET"),  
			    	closeWhenTouchModel = true, callback = function(type)
			            if type == nk.ui.Dialog.SECOND_BTN_CLICK then
			                if self and self.doJump then
			                	--todo
			                	local timMatchTag = "timMatch"
			                	self:doJump(timMatchTag)
			                	nk.PopupManager:removeAllPopup()
			                end
			            end
			        end}
			    ):show()

			end
		elseif errData.errorCode == - 15 then
			if diffStr and diffData then
				nk.ui.Dialog.new({messageText = bm.LangUtil.getText("SCOREMARKET", "NEED_TIP", diffStr), secondBtnText = bm.LangUtil.getText("SCOREMARKET", "TO_GET"),  
			    	closeWhenTouchModel = true, callback = function(type)
			            if type == nk.ui.Dialog.SECOND_BTN_CLICK then
			                if self and self.doJump then
			                	--todo
			                	if nk.userData["match.point"] < 10 then
				                	local timMatchTag = "timMatch"
				                	self:doJump(timMatchTag)
				                	nk.PopupManager:removeAllPopup()
				                else
				                	if checkint(diffData.diffPoint) > 0 then
				                		local ChooseCashRoomTag = "cashRoomChoose"
										self:doJump(ChooseCashRoomTag)
										nk.PopupManager:removeAllPopup()
				                	else
				                		local timMatchTag = "timMatch"
					                	self:doJump(timMatchTag)
					                	nk.PopupManager:removeAllPopup()
				                	end
				                end
			                end
			            end
			        end}
			    ):show()

			end
		else
			nk.TopTipManager:showTopTip(bm.LangUtil.getText("COMMON", "REQUEST_DATA_FAIL"))
		end
	end)
end



function ExcMarketController:doJump(action)
	local HallController = import("app.module.hall.HallController")
	
	local currentViewType = bm.DataProxy:getData(nk.dataKeys.CURRENT_HALL_VIEW)
    local runningScene = nk.runningScene

    if runningScene.name == "HallScene" then
    	if currentViewType == HallController.MAIN_HALL_VIEW then
    		--todo
    		if action == "cashRoomChoose" then
    			--todo
    			nk.userData.DEFAULT_TAB = 2
                runningScene.controller_.view_:onNorHallClick()
    		elseif action == "timMatch" then
    			--todo
    			runningScene.controller_.view_:onMatchHallClick()
    		end
    	elseif currentViewType == HallController.CHOOSE_NOR_VIEW then
    		--todo
    		if action == "cashRoomChoose" then
    			--todo
    			if nk.userData.DEFAULT_TAB ~= 2 then
    				--todo
    				local cashRoomChooseTabIdx = 2
    				runningScene.controller_.view_.mainTabBar_:gotoTab(cashRoomChooseTabIdx)
    			end
    		elseif action == "timMatch" then
    			--todo
    			runningScene.controller_:showMainHallView()
                runningScene.controller_.view_:onMatchHallClick()
    		end
    	elseif currentViewType == HallController.CHOOSE_MATCH_NOR_VIEW then
    		--todo
    		if action == "cashRoomChoose" then
    			--todo
    			nk.userData.DEFAULT_TAB = 2

    			runningScene.controller_:showMainHallView()
                runningScene.controller_.view_:onNorHallClick()
    		elseif action == "timMatch" then
    			--todo
    			if runningScene.controller_.view_.MATCH_TYPE_SELECTED ~= runningScene.controller_.view_.MATCH_TYPE_TIME then
    				--todo
    				runningScene.controller_.view_.mainTabBar_:gotoTab(runningScene.controller_.view_.MATCH_TYPE_TIME)
    			end
    		end
    	end
    elseif runningScene.name == "RoomSceneEx" then
    	--todo
    	if action == "cashRoomChoose" then
    		--todo
    		if runningScene.controller_.model:isSelfInGame() and runningScene.controller_.model:hasCardActive() then
                --todo
                nk.ui.Dialog.new({
                    messageText = bm.LangUtil.getText("ROOM", "EXIT_IN_GAME_MSG"), 
                    hasCloseButton = false,
                    callback = function (type)
                        if type == nk.ui.Dialog.SECOND_BTN_CLICK then

                            bm.DataProxy:setData(nk.dataKeys.CURRENT_HALL_VIEW, HallController.CHOOSE_NOR_VIEW)
                            nk.userData.DEFAULT_TAB = 2

                            if runningScene and runningScene.doBackToHall then
                                --todo
                                nk.server:logoutRoom()
                                runningScene:doBackToHall()
                            end
                        end
                    end
                }):show()
            else
                bm.DataProxy:setData(nk.dataKeys.CURRENT_HALL_VIEW, HallController.CHOOSE_NOR_VIEW)
                nk.userData.DEFAULT_TAB = 2

                if runningScene and runningScene.doBackToHall then
                    --todo
                    nk.server:logoutRoom()
                    runningScene:doBackToHall()
                end
            end
    	elseif action == "timMatch" then
    		--todo
    		if runningScene.controller_.model:isSelfInGame() and runningScene.controller_.model:hasCardActive() then
                --todo
                nk.ui.Dialog.new({
                    messageText = bm.LangUtil.getText("ROOM", "EXIT_IN_GAME_MSG"), 
                    hasCloseButton = false,
                    callback = function (type)
                        if type == nk.ui.Dialog.SECOND_BTN_CLICK then

                            bm.DataProxy:setData(nk.dataKeys.CURRENT_HALL_VIEW, HallController.CHOOSE_MATCH_NOR_VIEW)

                            if runningScene and runningScene.doBackToHall then
                                --todo
                                nk.server:logoutRoom()
                                runningScene:doBackToHall()
                            end
                        end
                    end
                }):show()
            else
                bm.DataProxy:setData(nk.dataKeys.CURRENT_HALL_VIEW, HallController.CHOOSE_MATCH_NOR_VIEW)

                if runningScene and runningScene.doBackToHall then
                    --todo
                    nk.server:logoutRoom()
                    runningScene:doBackToHall()
                end
            end
    	end

    elseif runningScene.name == "MatchRoomScene" then
    	--todo
    	if action == "cashRoomChoose" then
    		--todo
            if runningScene.controller_.model:isSelfInMatch() then
                --todo
                if runningScene.controller_.model.gameInfo.gameStatus == consts.SVR_MATCH_GAME_STATUS.APPLY then
                    --todo

                    local requestBackToHall = function()
                        nk.http.matchOut(function(data)

                            if data and data.money then
                                nk.userData["aUser.money"] = tonumber(data.money)
                            end

                            if runningScene and runningScene.doBackToHall then
                                --todo
                                runningScene:doBackToHall()
                            end
                        end, function(errorCode)
                            nk.TopTipManager:showTopTip(T("退赛失败,请继续比赛"))
                        end)
                    end

                    nk.http.getMatchExitLeftTime(runningScene.controller_.model.roomInfo.matchType, function(data)
                        
                        -- bm.DataProxy:setData(nk.dataKeys.CURRENT_HALL_VIEW, HallController.CHOOSE_MATCH_NOR_VIEW)
                        bm.DataProxy:setData(nk.dataKeys.CURRENT_HALL_VIEW, HallController.CHOOSE_NOR_VIEW)
                        nk.userData.DEFAULT_TAB = 2

                        if tonumber(data.remainTime) > 0 then
                            local MatchExitTipPopup = import("app.module.match.views.MatchExitTipPopup")
                            MatchExitTipPopup.new(requestBackToHall, data.remainTime):show()
                        else
                            requestBackToHall()
                        end
                    end, function(errData)
                        -- bm.DataProxy:setData(nk.dataKeys.CURRENT_HALL_VIEW, HallController.CHOOSE_MATCH_NOR_VIEW)
                        bm.DataProxy:setData(nk.dataKeys.CURRENT_HALL_VIEW, HallController.CHOOSE_NOR_VIEW)
                        nk.userData.DEFAULT_TAB = 2

                        requestBackToHall()
                    end)

                else
                    -- bm.DataProxy:setData(nk.dataKeys.CURRENT_HALL_VIEW, HallController.CHOOSE_MATCH_NOR_VIEW)
                    bm.DataProxy:setData(nk.dataKeys.CURRENT_HALL_VIEW, HallController.CHOOSE_NOR_VIEW)
                    nk.userData.DEFAULT_TAB = 2

                    nk.server:matchExitGetLeftTime()
                end

            else
                -- bm.DataProxy:setData(nk.dataKeys.CURRENT_HALL_VIEW, HallController.CHOOSE_MATCH_NOR_VIEW)
                bm.DataProxy:setData(nk.dataKeys.CURRENT_HALL_VIEW, HallController.CHOOSE_NOR_VIEW)
                nk.userData.DEFAULT_TAB = 2

                if runningScene.controller_.model:isSelfKnockOut() then
                    nk.server:matchQuit()
                end
                
                if runningScene and runningScene.doBackToHall then
                    --todo
                    runningScene:doBackToHall()
                end
            end
    	elseif action == "timMatch" then
    		--todo
    		if runningScene.controller_.model:isSelfInMatch() then
                --todo
                if runningScene.controller_.model.gameInfo.gameStatus == consts.SVR_MATCH_GAME_STATUS.APPLY then
                    --todo

                    local requestBackToHall = function()
                        nk.http.matchOut(function(data)

                            if data and data.money then
                                nk.userData["aUser.money"] = tonumber(data.money)
                            end

                            if runningScene and runningScene.doBackToHall then
                                --todo
                                runningScene:doBackToHall()
                            end
                        end, function(errorCode)
                            nk.TopTipManager:showTopTip(T("退赛失败,请继续比赛"))
                        end)
                    end

                    nk.http.getMatchExitLeftTime(runningScene.controller_.model.roomInfo.matchType, function(data)
                        
                        bm.DataProxy:setData(nk.dataKeys.CURRENT_HALL_VIEW, HallController.CHOOSE_MATCH_NOR_VIEW)
                        if tonumber(data.remainTime) > 0 then
                            local MatchExitTipPopup = import("app.module.match.views.MatchExitTipPopup")
                            MatchExitTipPopup.new(requestBackToHall, data.remainTime):show()
                        else
                            requestBackToHall()
                        end

                    end,function(errData)
                        bm.DataProxy:setData(nk.dataKeys.CURRENT_HALL_VIEW, HallController.CHOOSE_MATCH_NOR_VIEW)
                        requestBackToHall()
                    end)

                else
                    bm.DataProxy:setData(nk.dataKeys.CURRENT_HALL_VIEW, HallController.CHOOSE_MATCH_NOR_VIEW)

                    nk.server:matchExitGetLeftTime()
                end

            else
                bm.DataProxy:setData(nk.dataKeys.CURRENT_HALL_VIEW, HallController.CHOOSE_MATCH_NOR_VIEW)

                if runningScene.controller_.model:isSelfKnockOut() then
                    nk.server:matchQuit()
                end
                
                if runningScene and runningScene.doBackToHall then
                    --todo
                    runningScene:doBackToHall()
                end
            end
    	end

    elseif runningScene.name == "GrabDealerRoomScene" then
    	--todo
    	if action == "cashRoomChoose" then
    		--todo
    		if runningScene.controller_.model:isSelfInGame() and runningScene.controller_.model:hasCardActive() then
                nk.ui.Dialog.new({
                    messageText = bm.LangUtil.getText("ROOM", "EXIT_IN_GAME_MSG"), 
                    hasCloseButton = false,
                    callback = function (type)
                        if type == nk.ui.Dialog.SECOND_BTN_CLICK then
                            
                            bm.DataProxy:setData(nk.dataKeys.CURRENT_HALL_VIEW, HallController.CHOOSE_NOR_VIEW)
                            nk.userData.DEFAULT_TAB = 2

                            nk.server:logoutRoom()
                           -- self:doBackToHall()
                        end
                    end
                }):show()
            else
                bm.DataProxy:setData(nk.dataKeys.CURRENT_HALL_VIEW, HallController.CHOOSE_NOR_VIEW)
                nk.userData.DEFAULT_TAB = 2

                nk.server:logoutRoom()
               -- self:doBackToHall()
            end

    	elseif action == "timMatch" then
    		--todo
    		if runningScene.controller_.model:isSelfInGame() and runningScene.controller_.model:hasCardActive() then
                nk.ui.Dialog.new({
                    messageText = bm.LangUtil.getText("ROOM", "EXIT_IN_GAME_MSG"), 
                    hasCloseButton = false,
                    callback = function (type)
                        if type == nk.ui.Dialog.SECOND_BTN_CLICK then
                            bm.DataProxy:setData(nk.dataKeys.CURRENT_HALL_VIEW, HallController.CHOOSE_MATCH_NOR_VIEW)
                            nk.server:logoutRoom()
                           -- self:doBackToHall()
                        end
                    end
                }):show()
            else
                bm.DataProxy:setData(nk.dataKeys.CURRENT_HALL_VIEW, HallController.CHOOSE_MATCH_NOR_VIEW)             
                nk.server:logoutRoom()
               -- self:doBackToHall()
            end
    	end
    end
end

function ExcMarketController:dispose()
	-- body
	if self.reqExcMarketInitId_ then
		--todo
		nk.http.cancel(self.reqExcMarketInitId_)
	end

	if self.reqGetMyExcRecordDataId_ then
		--todo
		nk.http.cancel(self.reqGetMyExcRecordDataId_)
	end

	if self.reqGetExcWareDataId_ then
		--todo
		nk.http.cancel(self.reqGetExcWareDataId_)
	end
end

return ExcMarketController