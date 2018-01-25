--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-05-26 18:23:12
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: BankPswSetUnlockPopup.lua Created By Tsing7x.
--

local SettingHelpPopup = import("app.module.settingHelp.SettingHelpPopupMgr")

local BankPswSetUnlockPopup = class("BankPswSetUnlockPopup", nk.ui.Panel)

function BankPswSetUnlockPopup:ctor(lockState)
    self:setNodeEventEnabled(true)
    self.super.ctor(self, self.SIZE_SMALL)

    self.isLocked_ = lockState or false

    local panelBorWidth = 6

    local titleDesc = nil
    if self.isLocked_ then
        --todo
        titleDesc = display.newSprite("#usrInfo_decTiBankPswUnlock.png")
    else
        titleDesc = display.newSprite("#usrInfo_decTiBankPswSet.png")
    end

    self:addPanelTitleBar(titleDesc)
    local titleBarSize = self:getTitleBarSize()

    local pswOprBtnSize = {
        width = 180,
        height = 60
    }

    local labelParam = {
        fontSize = 0,
        color = display.COLOR_BLACK
    }

    if self.isLocked_ then
        --todo
        -- Release Bank Lock.
        local pswInputPanelMagrinTop = 40

        local pswInputEdtBoxSize = {
            width = 408,
            height = 52
        }

        local editNorTextFontSize = 24
        local editNorTextColor = display.COLOR_WHITE
        local bankPswMaxLenght = 10

        self.pswInputEdit_ = cc.ui.UIInput.new({image = "#usrInfo_bgPswIptLayer.png", size = cc.size(pswInputEdtBoxSize.width, pswInputEdtBoxSize.height), listener = handler(self,
            self.onPswUnlockEdit_), x = 0, y = self.height_ / 2 - panelBorWidth - titleBarSize.height - pswInputPanelMagrinTop - pswInputEdtBoxSize.height / 2})
            :addTo(self)

        self.pswInputEdit_:setFont(ui.DEFAULT_TTF_FONT, editNorTextFontSize)
        self.pswInputEdit_:setFontColor(editNorTextColor)

        self.pswInputEdit_:setPlaceholderFont(ui.DEFAULT_TTF_FONT, editNorTextFontSize)
        self.pswInputEdit_:setPlaceholderFontColor(editNorTextColor)
        self.pswInputEdit_:setPlaceHolder("请输入密码")

        self.pswInputEdit_:setMaxLength(bankPswMaxLenght)
        self.pswInputEdit_:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
        self.pswInputEdit_:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)

        nk.EditBoxManager:addEditBox(self.pswInputEdit_)

        local forgetPswTipLblMagrinTop = 15

        labelParam.fontSize = 20
        labelParam.color = display.COLOR_WHITE
        local forgetPswTipLabel = display.newTTFLabel({text = "忘记密码请向管理员反馈", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
        forgetPswTipLabel:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
        forgetPswTipLabel:pos(self.pswInputEdit_:getPositionX() - pswInputEdtBoxSize.width / 2, self.pswInputEdit_:getPositionY() - pswInputEdtBoxSize.height / 2 -
            forgetPswTipLblMagrinTop - forgetPswTipLabel:getContentSize().height / 2)
            :addTo(self)

        local unlockOprBtnBotMagrinPanelBot = 36
        local unlockoprBtnGapEach = 58

        labelParam.fontSize = 28
        labelParam.color = display.COLOR_WHITE
        self.forgetPswBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnGreenRigOutl.png", pressed = "#common_btnGreenRigOutl.png", disabled = "#common_btnGreyLitRigOut.png"},
            {scale9 = true})
            :setButtonSize(pswOprBtnSize.width, pswOprBtnSize.height)
            :setButtonLabel(display.newTTFLabel({text = "忘记密码", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
            :onButtonClicked(buttontHandler(self, self.onForgetPswBtnCallBack_))
            :pos(- unlockoprBtnGapEach / 2 - pswOprBtnSize.width / 2, - self.height_ / 2 + panelBorWidth + unlockOprBtnBotMagrinPanelBot + pswOprBtnSize.height / 2)
            :addTo(self)

        self.pswUnlockCommitBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnYellowRigOutl.png", pressed = "#common_btnYellowRigOutl.png", disabled = "#common_btnGreyLitRigOut.png"},
            {scale9 = true})
            :setButtonSize(pswOprBtnSize.width, pswOprBtnSize.height)
            :setButtonLabel(display.newTTFLabel({text = "确定", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
            :onButtonClicked(buttontHandler(self, self.onUnlockPswCommitBtnCallBack_))
            :pos(unlockoprBtnGapEach / 2 + pswOprBtnSize.width / 2, - self.height_ / 2 + panelBorWidth + unlockOprBtnBotMagrinPanelBot + pswOprBtnSize.height / 2)
            :addTo(self)
    else
        local pswInputPanelMagrinTop = 36
        local pswInputPanel1Magrin2 = 18

        local pswInputEdtBoxSize = {
            width = 410,
            height = 52
        }

        local editNorTextFontSize = 24
        local editNorTextColor = display.COLOR_WHITE
        local bankPswMaxLenght = 10

        self.pswSetInputEdit_ = cc.ui.UIInput.new({image = "#usrInfo_bgPswIptLayer.png", size = cc.size(pswInputEdtBoxSize.width, pswInputEdtBoxSize.height), listener = handler(self,
            self.onPswSetLockEdit_), x = 0, y = self.height_ / 2 - panelBorWidth - titleBarSize.height - pswInputPanelMagrinTop - pswInputEdtBoxSize.height / 2})
            :addTo(self)

        self.pswSetInputEdit_:setFont(ui.DEFAULT_TTF_FONT, editNorTextFontSize)
        self.pswSetInputEdit_:setFontColor(editNorTextColor)

        self.pswSetInputEdit_:setPlaceholderFont(ui.DEFAULT_TTF_FONT, editNorTextFontSize)
        self.pswSetInputEdit_:setPlaceholderFontColor(editNorTextColor)
        self.pswSetInputEdit_:setPlaceHolder("请输入密码")

        self.pswSetInputEdit_:setMaxLength(bankPswMaxLenght)
        self.pswSetInputEdit_:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
        self.pswSetInputEdit_:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)

        nk.EditBoxManager:addEditBox(self.pswSetInputEdit_)

        self.pswSetCofmInputEdit_ = cc.ui.UIInput.new({image = "#usrInfo_bgPswIptLayer.png", size = cc.size(pswInputEdtBoxSize.width, pswInputEdtBoxSize.height), listener = handler(self,
            self.onPswSetCofmEdit_), x = 0, y = self.pswSetInputEdit_:getPositionY() - pswInputEdtBoxSize.height - pswInputPanel1Magrin2})
            :addTo(self)

        self.pswSetCofmInputEdit_:setFont(ui.DEFAULT_TTF_FONT, editNorTextFontSize)
        self.pswSetCofmInputEdit_:setFontColor(editNorTextColor)

        self.pswSetCofmInputEdit_:setPlaceholderFont(ui.DEFAULT_TTF_FONT, editNorTextFontSize)
        self.pswSetCofmInputEdit_:setPlaceholderFontColor(editNorTextColor)
        self.pswSetCofmInputEdit_:setPlaceHolder("请再次输入密码")

        self.pswSetCofmInputEdit_:setMaxLength(bankPswMaxLenght)
        self.pswSetCofmInputEdit_:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
        self.pswSetCofmInputEdit_:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)

        nk.EditBoxManager:addEditBox(self.pswSetCofmInputEdit_)

        local confrimFlagMagrinLeft = 12

        self.pswCfmFlag_ = display.newSprite("#usrInfo_decFlagPswWrong.png")
        self.pswCfmFlag_:pos(self.pswSetCofmInputEdit_:getPositionX() + pswInputEdtBoxSize.width / 2 + confrimFlagMagrinLeft + self.pswCfmFlag_:getContentSize().width / 2,
            self.pswSetCofmInputEdit_:getPositionY())
            :addTo(self)

        local pswSetCommitBtnMagrinBot = 35

        labelParam.fontSize = 28
        labelParam.color = display.COLOR_WHITE
        self.pswSetCommitBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnYellowRigOutl.png", pressed = "#common_btnYellowRigOutl.png", disabled = "#common_btnGreyLitRigOut.png"},
            {scale9 = true})
            :setButtonSize(pswOprBtnSize.width, pswOprBtnSize.height)
            :setButtonLabel(display.newTTFLabel({text = "确定", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
            :onButtonClicked(buttontHandler(self, self.onPswSetCommitBtnCallBack_))
            :pos(0, - self.height_ / 2 + panelBorWidth + pswSetCommitBtnMagrinBot + pswOprBtnSize.height / 2)
            :addTo(self)

        self.pswSetCommitBtn_:setButtonEnabled(false)
    end

    self:addCloseBtn()
end


function BankPswSetUnlockPopup:onPswUnlockEdit_(evt)
    -- body
    if evt == "began" then
        --todo
    elseif evt == "changed" then
        --todo
    elseif evt == "ended" then
        --todo
        self.unlockPsw_ = self.pswInputEdit_:getText()
    elseif evt == "return" then
        --todo
    end
end

function BankPswSetUnlockPopup:onForgetPswBtnCallBack_(evt)
    -- body
    self.forgetPswBtn_:setButtonEnabled(false)
    SettingHelpPopup.new(false ,true ,1):showPanel()

    self.forgetPswBtn_:setButtonEnabled(true)
end

function BankPswSetUnlockPopup:onUnlockPswCommitBtnCallBack_(evt)
    -- body
    self.pswUnlockCommitBtn_:setButtonEnabled(false)
    if self.unlockPsw_ and string.len(self.unlockPsw_) > 0 then
        --todo
        self.reqCommitPswUnlockBankId_ = nk.http.bankOpenLock(self.unlockPsw_, function(retData)
            -- body
            -- dump(retData, "nk.http.bankOpenLock.retData :==================")
            if self.pswOprSuccCallBack_ then
                --todo
                self.pswOprSuccCallBack_()
            end

            self:hidePanel_()
        end, function(errData)
            -- body
            dump(errData, "nk.http.bankOpenLock.errData :===============")

            self.reqCommitPswUnlockBankId_ = nil
            if checkint(errData.errorCode) == - 1 then
                --todo
                nk.TopTipManager:showTopTip(bm.LangUtil.getText("BANK", "BANK_INPUT_PASSWORD_ERROR"))
            else
                nk.TopTipManager:showTopTip(bm.LangUtil.getText("COMMON", "BAD_NETWORK"))
            end

            self.pswUnlockCommitBtn_:setButtonEnabled(true)
        end)
    else
        nk.TopTipManager:showTopTip("请输入密码后解锁！")

        self.pswUnlockCommitBtn_:setButtonEnabled(true)
    end
end

function BankPswSetUnlockPopup:onPswSetLockEdit_(evt)
    -- body
    if evt == "began" then
        --todo
    elseif evt == "changed" then
        --todo
    elseif evt == "ended" then
        --todo
        self.pswSet_ = self.pswSetInputEdit_:getText()
    elseif evt == "return" then
        --todo
    end
end

function BankPswSetUnlockPopup:onPswSetCofmEdit_(evt)
    -- body
    if evt == "began" then
        --todo
    elseif evt == "changed" then
        --todo
    elseif evt == "ended" then
        --todo
        local pswConfrimStr = self.pswSetCofmInputEdit_:getText()

        if self.pswSet_ and self.pswSet_ == pswConfrimStr then
            --todo
            self.pswCfmFlag_:setSpriteFrame("usrInfo_decFlagPswRight.png")

            self.pswSetCommitBtn_:setButtonEnabled(true)
        else
            self.pswCfmFlag_:setSpriteFrame("usrInfo_decFlagPswWrong.png")

            self.pswSetCommitBtn_:setButtonEnabled(false)
        end
    elseif evt == "return" then
        --todo
    end
end

function BankPswSetUnlockPopup:onPswSetCommitBtnCallBack_(evt)
    -- body
    self.reqPswSetComfId_ = nk.http.bankSetPassword(self.pswSet_, self.pswSet_, function(retData)
        -- dump(retData, "nk.http.bankSetPassword.retData :===================")

        nk.TopTipManager:showTopTip(bm.LangUtil.getText("BANK", "BANK_SET_PASSWORD_SUCCESS_TOP_TIP"))
        nk.userData["aUser.bankLock"] = 1
        if self.pswOprSuccCallBack_ then
            --todo
            self.pswOprSuccCallBack_()
        end

        self:hidePanel_()
    end, function(errData)
        dump(errData, "nk.http.bankSetPassword.errData :=======================")
        self.reqPswSetComfId_ = nil

        nk.TopTipManager:showTopTip(bm.LangUtil.getText("BANK", "BANK_SET_PASSWORD_FAIL_TOP_TIP"))
    end)
end

function BankPswSetUnlockPopup:showPanel(callback)
    self.pswOprSuccCallBack_ = callback

    self:showPanel_()
end

function BankPswSetUnlockPopup:onEnter()
    -- body
end

function BankPswSetUnlockPopup:onExit()
    -- body
    if self.reqCommitPswUnlockBankId_ then
        --todo
        nk.http.cancel(self.reqCommitPswUnlockBankId_)
    end

    if self.reqPswSetComfId_ then
        --todo
        nk.http.cancel(self.reqPswSetComfId_)
    end

    if self.pswInputEdit_ then
        --todo
        nk.EditBoxManager:removeEditBox(self.pswInputEdit_)
    end

    if self.pswSetInputEdit_ then
        --todo
        nk.EditBoxManager:removeEditBox(self.pswSetInputEdit_)
    end

    if self.pswSetCofmInputEdit_ then
        --todo
        nk.EditBoxManager:removeEditBox(self.pswSetCofmInputEdit_)
    end
end

function BankPswSetUnlockPopup:onCleanup()
    -- body
end

return BankPswSetUnlockPopup