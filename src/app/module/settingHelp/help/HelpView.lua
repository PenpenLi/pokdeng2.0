--
-- Author: viking@boomegg.com
-- Date: 2014-08-22 16:56:47
-- Copyright: Copyright (c) 2014, BOOMEGG INTERACTIVE CO., LTD All rights reserved.
-- Description: HelpView.lua ReConstructed By Tsing7x.
--

local FeedbackCommon = import("app.module.feedback.FeedbackCommon")

local HelpController = import(".HelpController")
local FeedBackReplyListItem = import(".FeedBackReplyListItem")

local HelpCommonProbListItem = import(".compViews.HelpCommonProbListItem")
local HelpUsrAidListItem = import(".compViews.HelpUsrAidListItem")

local PANEL_WIDTH = 790
local PANEL_HEIGHT = 470

local PANEL_TOPTI_HEIGHT = 0
local PANEL_LEFTOPR_WIDTH = 0

local HelpView = class("HelpView", nk.ui.Panel)

function HelpView:ctor(subTabIdx)
    self:setNodeEventEnabled(true)
    self.super.ctor(self, {PANEL_WIDTH, PANEL_HEIGHT})

    self.controller_ = HelpController.new(self)

    self.schedulerPool_ = bm.SchedulerPool.new()
    self.defaultLeftTabIdx_ = subTabIdx or 1

    display.addSpriteFrames("help_texture.plist", "help_texture.png", handler(self, self.onHelpTextureLoaded))
end

function HelpView:onHelpTextureLoaded(fileName, imgName)
    -- body
    local descTitle = display.newSprite("#help_decDescTitle.png")
    self:addPanelTitleBar(descTitle)

    local titleBarSize = self:getTitleBarSize()
    PANEL_TOPTI_HEIGHT = titleBarSize.height

    local panelBorWidth = 6

    local leftOprTabAreaPanelModel = display.newSprite("#help_bgLeftTabBar.png")
    local leftOprTabAreaPanelSizeCal = leftOprTabAreaPanelModel:getContentSize()
    PANEL_LEFTOPR_WIDTH = leftOprTabAreaPanelSizeCal.width

    local leftOprAreaSizeHTopFix = 4

    local leftOprAreaPanelSize = {
        width = PANEL_LEFTOPR_WIDTH,
        height = PANEL_HEIGHT - panelBorWidth * 2 - PANEL_TOPTI_HEIGHT - leftOprAreaSizeHTopFix
    }

    local leftOprAreaPanelPosXFix = 4
    local leftSubTabAreaPanel = display.newScale9Sprite("#help_bgLeftTabBar.png", - PANEL_WIDTH / 2 + panelBorWidth + leftOprAreaPanelSize.width / 2 + leftOprAreaPanelPosXFix,
        - PANEL_HEIGHT / 2 + panelBorWidth + leftOprAreaPanelSize.height / 2, cc.size(leftOprAreaPanelSize.width, leftOprAreaPanelSize.height))
        :addTo(self)

    local labelParam = {
        fontSize = 0,
        color = display.COLOR_BLACK
    }

    local leftTabBtnLblStrs = {
        "用户反馈",
        "常见问题",
        "用户帮助"
    }

    local tabBtnSize = {
        width = 158,
        height = 60
    }

    local tabBtnMagrinEach = 2

    self.leftOprBtns_ = {}
    self.leftOprBtnGroup_ = nk.ui.CheckBoxButtonGroup.new()

    labelParam.fontSize = 30
    labelParam.color = display.COLOR_WHITE  -- State Nor

    for i = 1, #leftTabBtnLblStrs do
        self.leftOprBtns_[i] = cc.ui.UICheckBoxButton.new({on = "#help_btnLeftTabItem_sel.png", off = "#help_btnLeftTabItem_unSel.png"}, {scale9 = false})
            :pos(leftOprAreaPanelSize.width / 2, leftOprAreaPanelSize.height - tabBtnSize.height / 2 * (i * 2 - 1) - tabBtnMagrinEach * (i - 1))
            :addTo(leftSubTabAreaPanel)

        self.leftOprBtns_[i].label_ = display.newTTFLabel({text = leftTabBtnLblStrs[i], size = labelParam.fontSize, color = labelParam.color, align =
            ui.TEXT_ALIGN_CENTER})
            :addTo(self.leftOprBtns_[i])

        self.leftOprBtnGroup_:addButton(self.leftOprBtns_[i])
    end

    self.helpContPageNode_ = display.newNode()
        :pos(PANEL_LEFTOPR_WIDTH / 2, - PANEL_TOPTI_HEIGHT / 2)
        :addTo(self)

    self.leftOprBtnGroup_:onButtonSelectChanged(buttontHandler(self, self.onLeftOprTabBtnSelChanged_))
    self.leftOprBtnGroup_:getButtonAtIndex(self.defaultLeftTabIdx_):setButtonSelected(true)

    self:addCloseBtn()
end

function HelpView:renderHelpContPageViews(pageIdx)
    -- body
    local panelBorWidth = 6
    local pageContAreaWidth = PANEL_WIDTH - panelBorWidth * 2 - PANEL_LEFTOPR_WIDTH
    local pageContAreaHeight = PANEL_HEIGHT - panelBorWidth * 2 - PANEL_TOPTI_HEIGHT

    local drawHelpPagesMainContByTabIdx = {
        [1] = function()
            -- body
            local helpFeedBackContPage = display.newNode()

            local feebBackContInputBlkSize = {
                width = 450,
                height = 178
            }

            local inputBlkMagrins = {
                left = 16,
                top = 16
            }

            local editNorTextFontSize = 20
            local editTextColor = display.COLOR_WHITE
            local editPlaceholderColor = display.COLOR_RED

            self.feedBackContEdit_ = cc.ui.UIInput.new({image = "#help_bgBlkDent.png", size = cc.size(feebBackContInputBlkSize.width, feebBackContInputBlkSize.height),
                listener = handler(self, self.onFeedBackContEdit_), x = - pageContAreaWidth / 2 + inputBlkMagrins.left + feebBackContInputBlkSize.width / 2, y =
                    pageContAreaHeight / 2 - inputBlkMagrins.top - feebBackContInputBlkSize.height / 2})
                :addTo(helpFeedBackContPage)

            self.feedBackContEdit_:setFont(ui.DEFAULT_TTF_FONT, editNorTextFontSize)
            self.feedBackContEdit_:setFontColor(editTextColor)

            -- self.feedBackContEdit_:setPlaceHolder(bm.LangUtil.getText("HELP", "FEED_BACK_HINT"))
            self.feedBackContEdit_:setPlaceholderFont(ui.DEFAULT_TTF_FONT, editNorTextFontSize)
            self.feedBackContEdit_:setPlaceholderFontColor(editPlaceholderColor)

            self.feedBackContEdit_:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
            self.feedBackContEdit_:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)

            nk.EditBoxManager:addEditBox(self.feedBackContEdit_)

            local labelParam = {
                fontSize = 0,
                color = display.COLOR_BLACK
            }

            local feedBackContLblMagrinBorHoriz = 15
            local feedBackContLblMagrinBorVect = 8

            labelParam.fontSize = editNorTextFontSize
            labelParam.color = editPlaceholderColor  -- State Default

            self.feedBackContText_ = display.newTTFLabel({text = "", size = labelParam.fontSize, color = labelParam.color, dimensions = cc.size(feebBackContInputBlkSize.width -
                feedBackContLblMagrinBorHoriz * 2, feebBackContInputBlkSize.height - feedBackContLblMagrinBorVect * 2), align = ui.TEXT_ALIGN_LEFT})
                :pos(self.feedBackContEdit_:getPositionX(), self.feedBackContEdit_:getPositionY())
                :addTo(helpFeedBackContPage)

            self.feedBackContText_:setString(bm.LangUtil.getText("HELP", "FEED_BACK_HINT"))

            local imgUploadBgSize = {
                width = 130,
                height = 124
            }

            local uploadImgBgMagrins = {
                right = 15,
                top = 16
            }

            local imgLoadBg = display.newScale9Sprite("#help_bgBlkDent.png", pageContAreaWidth / 2 - uploadImgBgMagrins.right - imgUploadBgSize.width / 2,
                pageContAreaHeight / 2 - uploadImgBgMagrins.top - imgUploadBgSize.height / 2, cc.size(imgUploadBgSize.width, imgUploadBgSize.height))
                :addTo(helpFeedBackContPage)

            self.feedBackImgUploadBtn_ = cc.ui.UIPushButton.new({normal = "#help_icUploadImg.png", pressed = "#help_icUploadImg.png", disabled = "#help_icUploadImg.png"},
                {scale9 = false})
                :onButtonClicked(buttontHandler(self, self.onImgUploadBtnCallBack_))
                :pos(imgUploadBgSize.width / 2, imgUploadBgSize.height / 2)
                :addTo(imgLoadBg)

            local imgUploadBtnSize = {
                width = 130,
                height = 46
            }

            labelParam.fontSize = 25
            labelParam.color = display.COLOR_WHITE

            self.sendFeedBackBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnYellowRigOutl.png", pressed = "#common_btnYellowRigOutl.png", disabled =
                "#common_btnGreyLitRigOut.png"}, {scale9 = true})
                :setButtonSize(imgUploadBtnSize.width, imgUploadBtnSize.height)
                :setButtonLabel(display.newTTFLabel({text = "发送", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
                :onButtonClicked(buttontHandler(self, self.onSendFeedBackBtnCallBack_))
                :pos(imgLoadBg:getPositionX(), self.feedBackContEdit_:getPositionY() - feebBackContInputBlkSize.height / 2 + imgUploadBtnSize.height / 2)
                :addTo(helpFeedBackContPage)

            local divLineMagrinTop = 25
            local divLineWidthFixHoriz = 16

            local divLineFeedBackScaleSize = {
                width = pageContAreaWidth - divLineWidthFixHoriz * 2,
                height = 4
            }

            local divLineFeedBack = display.newScale9Sprite("#help_divLineFeedBack.png", 0, self.feedBackContEdit_:getPositionY() - feebBackContInputBlkSize.height / 2 -
                divLineMagrinTop - divLineFeedBackScaleSize.height / 2, cc.size(divLineFeedBackScaleSize.width, divLineFeedBackScaleSize.height))
                :addTo(helpFeedBackContPage)

            local replyListViewMagrinTop = 16
            local replyListViewMagrinContPageHoriz = 12

            local replyListViewSize = {
                width = pageContAreaWidth - replyListViewMagrinContPageHoriz * 2,
                height = 140
            }

            self.feedBackReplyListView_ = bm.ui.ListView.new({viewRect = cc.rect(- replyListViewSize.width / 2, - replyListViewSize.height / 2, replyListViewSize.width,
                replyListViewSize.height), direction = bm.ui.ListView.DIRECTION_VERTICAL}, FeedBackReplyListItem)
                :pos(0, divLineFeedBack:getPositionY() - divLineFeedBackScaleSize.height / 2 - replyListViewMagrinTop - replyListViewSize.height / 2)
                :addTo(helpFeedBackContPage)

            -- self.feedBackReplyListView_:setData({1, 2, 3, 4, 5})
            self.feedBackReplyListView_:setNotHide(true)

            labelParam.fontSize = 28
            labelParam.color = display.COLOR_RED

            self.feedBackNoRecordTip_ = display.newTTFLabel({text = bm.LangUtil.getText("HELP", "NO_FEED_BACK"), size = labelParam.fontSize, color = labelParam.color, align =
                ui.TEXT_ALIGN_CENTER})
                :pos(0, divLineFeedBack:getPositionY() - divLineFeedBackScaleSize.height / 2 - replyListViewMagrinTop - replyListViewSize.height / 2)
                :addTo(helpFeedBackContPage)
                :hide()

            -- Init FeedBackCommon Module --
            FeedbackCommon.initFeedback()
            return helpFeedBackContPage
        end,

        [2] = function()
            -- body
            local helpCommonProbContPage = display.newNode()

            local commonProbContWidthFixBor = 16
            local commonProbContHeightFixBor = 18

            local commonProbListViewSize = {
                width = pageContAreaWidth - commonProbContWidthFixBor * 2,
                height = pageContAreaHeight - commonProbContHeightFixBor * 2
            }

            self.commonProbListView_ = bm.ui.ListView.new({viewRect = cc.rect(- commonProbListViewSize.width / 2, - commonProbListViewSize.height / 2,
                commonProbListViewSize.width, commonProbListViewSize.height), direction = bm.ui.ListView.DIRECTION_VERTICAL}, HelpCommonProbListItem)
                :addTo(helpCommonProbContPage)

            -- self.commonProbListView_:setData({{"Q1", "A1"}, {"Q2", "A2"}, {"Q3", "A3"}, {"Q4", "A4"}})

            self.commonProbListView_:setNotHide(true)
            return helpCommonProbContPage
        end,

        [3] = function()
            -- body
            local helpUserAidContPage = display.newNode()

            local userAidContWidthFixBor = 16
            local userAidContHeightFixBor = 18

            local userAidListViewSize = {
                width = pageContAreaWidth - userAidContWidthFixBor * 2,
                height = pageContAreaHeight - userAidContHeightFixBor * 2
            }

            self.usrAidListView_ = bm.ui.ListView.new({viewRect = cc.rect(- userAidListViewSize.width / 2, - userAidListViewSize.height / 2, userAidListViewSize.width,
                userAidListViewSize.height), direction = bm.ui.ListView.DIRECTION_VERTICAL}, HelpUsrAidListItem)
                :addTo(helpUserAidContPage)

            self.usrAidListView_:setNotHide(true)
            return helpUserAidContPage
        end
    }

    self.helpContPageViews_ = self.helpContPageViews_ or {}

    for _, page in pairs(self.helpContPageViews_) do
        if page then
            --todo
            page:hide()
        end
    end

    local page = self.helpContPageViews_[pageIdx]

    if not page then
        --todo
        page = drawHelpPagesMainContByTabIdx[pageIdx]()
        self.helpContPageViews_[pageIdx] = page
        page:addTo(self.helpContPageNode_)
    end

    page:show()
end

function HelpView:setLoading(isLoading)
    if isLoading then
        if not self.loadingBar_ then
            self.loadingBar_ = nk.ui.Juhua.new()
                :addTo(self.helpContPageNode_)
        end
    else
        if self.loadingBar_ then
            self.loadingBar_:removeFromParent()
            self.loadingBar_ = nil
        end
    end
end

function HelpView:sendFeedbackSucc()
    -- body
    self.feedBackContText_:setString(bm.LangUtil.getText("HELP", "FEED_BACK_HINT"))
    if self.uploadedImg_ then
        cc.Director:getInstance():getTextureCache():removeTexture(self.uploadedImg_:getTexture())
        self.uploadedImg_:removeFromParent()
        self.uploadedImg_ = nil
    end
end

function HelpView:onLeftOprTabBtnSelChanged_(evt)
    -- body
    local tabLblColors = {
        nor = display.COLOR_WHITE,
        sel = display.COLOR_GREEN
    }

    if not self.leftTabSelIdx_ then
        --todo
        self.leftTabSelIdx_ = evt.selected

        self.leftOprBtns_[self.leftTabSelIdx_].label_:setTextColor(tabLblColors.sel)
    end

    local isChanged = self.leftTabSelIdx_ ~= evt.selected

    if isChanged then
        --todo
        self.leftOprBtns_[self.leftTabSelIdx_].label_:setTextColor(tabLblColors.nor)

        self.leftOprBtns_[evt.selected].label_:setTextColor(tabLblColors.sel)

        self.leftTabSelIdx_ = evt.selected
    end

    self:renderHelpContPageViews(self.leftTabSelIdx_)

    self:getHelpPagesData()
end

-- Main ContPage Ctrl Events --
function HelpView:onFeedBackContEdit_(evt)
    -- body
    if evt == "began" then
        --todo
        local displayText = self.feedBackContText_:getString()
        if displayText == bm.LangUtil.getText("HELP", "FEED_BACK_HINT") then
            self.feedBackContEdit_:setText("")
        else
            self.feedBackContEdit_:setText(displayText)
        end

        self.feedBackContText_:setString("")
    elseif evt == "changed" then
        --todo
    elseif evt == "ended" then
        --todo
        local text = self.feedBackContEdit_:getText()
        if string.len(text) <= 0 then
            text = bm.LangUtil.getText("HELP", "FEED_BACK_HINT")
        end

        self.feedBackContEdit_:setText("")
        self.feedBackContText_:setString(text)
    elseif evt == "return" then
        --todo
    end
end

function HelpView:onImgUploadBtnCallBack_(evt)
    -- body
    self.feedBackImgUploadBtn_:setButtonEnabled(false)

    nk.Native:pickupPic(function(success, result)
        if success then
            self.isPicUploadSucc = true
            self.picFilePath = result

            if self.uploadedImg_ then
                cc.Director:getInstance():getTextureCache():removeTexture(self.uploadedImg_:getTexture())
                self.uploadedImg_:removeFromParent()
                self.uploadedImg_ = nil
            end

            local setImageSize = function(width, height, sprite)
                local sX = width / sprite:getContentSize().width
                local sY = height/ sprite:getContentSize().height
                local scale = math.min(sX, sY)

                sprite:scale(scale * 0.9)
            end

            self.uploadedImg_ = display.newSprite(self.picFilePath)
                :addTo(self.feedBackImgUploadBtn_)

            local imgUploadBtnSize = {
                width = 120,
                height = 108
            }

            setImageSize(imgUploadBtnSize.width, imgUploadBtnSize.height, self.uploadedImg_)
        else
            if result == "nosdcard" then
                nk.TopTipManager:showTopTip(bm.LangUtil.getText("USERINFO", "UPLOAD_PIC_NO_SDCARD"))
            else
                nk.TopTipManager:showTopTip(bm.LangUtil.getText("USERINFO", "UPLOAD_PIC_PICK_IMG_FAIL"))
            end
        end

        self.feedBackImgUploadBtn_:setButtonEnabled(true)
    end)
end

function HelpView:onSendFeedBackBtnCallBack_(evt)
    -- body
    local feedBackContText = self.feedBackContText_:getString()
    if feedBackContText == bm.LangUtil.getText("HELP", "FEED_BACK_HINT") then
        --todo
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("HELP", "MUST_INPUT_FEEDBACK_TEXT_MSG"))
        return
    end

    self.sendFeedBackBtn_:setButtonEnabled(false)
    local param = {title = "", ftype = "1", fwords = feedBackContText, fcontact = ""}

    FeedbackCommon.sendFeedback(param, function(succ, result)
        if succ then
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("HELP", "FEED_BACK_SUCCESS"))
            
            if self.isPicUploadSucc then
                self:uploadImg(result.ret.fid, self.picFilePath)
            else
                self:sendFeedbackSucc()
            end
        else
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("COMMON", "BAD_NETWORK"))
            -- if result == "network" then
            --     nk.TopTipManager:showTopTip(bm.LangUtil.getText("COMMON", "BAD_NETWORK"))
            -- else
            --     nk.TopTipManager:showTopTip(bm.LangUtil.getText("COMMON", "BAD_NETWORK"))
            -- end
        end

        self.sendFeedBackBtn_:setButtonEnabled(true)
    end)

    self:updateFeedBackRecordListView()
end

function HelpView:uploadImg(fid, picFilePath)
    -- body
    FeedbackCommon.uploadPic(fid, picFilePath, function(succ, result)
        if succ then
            self:sendFeedbackSucc()
        else
            nk.TopTipManager:showTopTip(bm.LangUtil.getText("COMMON", "BAD_NETWORK"))
        end
    end)
end

function HelpView:getHelpPagesData()
    -- body
    local getHelpPageContDataByTabIdx = {
        [1] = function()
            -- body
            self.controller_:getFeedbackListData()
        end,

        [2] = function()
            -- body
            local commonProData = self.controller_:getHelpCommonProData()
            self:setCommonProListData(commonProData)
        end,

        [3] = function()
            -- body
            local userAidData = self.controller_:getUserAidData()
            self:setUserAidListData(userAidData)
        end
    }

    getHelpPageContDataByTabIdx[self.leftTabSelIdx_]()
    self:setLoading(true)
end

function HelpView:onGetFeedBackReplyData(data)
    -- body
    -- dump(data, "HelpView:onGetFeedBackReplyData.data :====================")
    self:setLoading(false)
    if data and #data > 0 then
        --todo
        self.feedBackRecordListData_ = data

        self.feedBackNoRecordTip_:hide()
        self.feedBackReplyListView_:setData(self.feedBackRecordListData_)
    else
        self.feedBackRecordListData_ = nil

        self.feedBackReplyListView_:setData(nil)
        self.feedBackNoRecordTip_:show()

        self.feedBackRecordListData_ = {}
    end
end

function HelpView:updateFeedBackRecordListView()
    -- body
    local feedBackContText = self.feedBackContText_:getString()

    if not self.feedBackRecordListData_ then
        --todo
        self.feedBackRecordListData_ = {}
    end

    table.insert(self.feedBackRecordListData_, 1, {answer = "", content = feedBackContText})

    self:setLoading(false)
    self.feedBackNoRecordTip_:hide()
    self.feedBackReplyListView_:setData(self.feedBackRecordListData_)
end

function HelpView:setCommonProListData(data)
    -- body
    self.schedulerPool_:delayCall(function()
        self:setLoading(false)
        self.commonProbListView_:setData(data)
    end, 0.5)
end

function HelpView:setUserAidListData(data)
    -- body
    self.schedulerPool_:delayCall(function()
        self:setLoading(false)
        self.usrAidListView_:setData(data)
    end, 0.5)
end

function HelpView:updatePanelListView()
    -- body
    if self.feedBackReplyListView_ then
        --todo
        self.feedBackReplyListView_:update()
    end

    if self.commonProbListView_ then
        --todo
        self.commonProbListView_:update()
    end

    if self.usrAidListView_ then
        --todo
        self.usrAidListView_:update()
    end
end

-- Only Provide For SettingView To Call --
function HelpView:showPanel()
    -- body
    self:showPanel_()
end

function HelpView:onShowed()
    self:updatePanelListView()
end

function HelpView:onEnter()
    -- body
end

function HelpView:onExit()
    self.schedulerPool_:clearAll()

    nk.EditBoxManager:removeEditBox(self.feedBackContEdit_)
end

function HelpView:onCleanup()
    -- body
    display.removeSpriteFramesWithFile("help_texture.plist", "help_texture.png")

    nk.schedulerPool:delayCall(function()
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    end, 0.1)
end

return HelpView