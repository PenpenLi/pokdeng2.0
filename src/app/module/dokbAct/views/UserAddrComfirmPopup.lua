--
-- Author: TsingZhang@boyaa.com
-- Date: 2016-06-03 14:32:43
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: UserAddrComfirmPopup.lua Create && ReConstructed By Tsing7x.
--

local AddrComboItem = import(".UserAddrComboBoxItem")
local UserAddrController = import(".UserAddrController")

local PANEL_WIDTH = 790
local PANEL_HEIGHT = 470

local UserAddrComfirmPopup = class("UserAddrComfirmPopup", nk.ui.Panel)

function UserAddrComfirmPopup:ctor()
	-- body
	self:setNodeEventEnabled(true)
	self.super.ctor(self, {PANEL_WIDTH, PANEL_HEIGHT})

	self.controller_ = UserAddrController.new(self)
	self:renderMainView()
    self:addCloseBtn()

	self.controller_:getUserAddress(handler(self, self.bindAddressInfo_))
end

function UserAddrComfirmPopup:renderMainView()
	-- body
    local labelParam = {
        fontSize = 0,
        color = display.COLOR_WHITE
    }

    labelParam.fontSize = 30
    labelParam.color = display.COLOR_WHITE

    local titleLbl = display.newTTFLabel({text = bm.LangUtil.getText("RECVADDR", "RECV_INFO"), size = labelParam.fontSize, color = labelParam.color, align =
        ui.TEXT_ALIGN_CENTER})

    self:addPanelTitleBar(titleLbl)

    labelParam.fontSize = 25
    labelParam.color = display.COLOR_WHITE

    local infoMainInsLblBlockMagrinTop = 24
    local infomainInsLblMagrinEach = 20
    local infoMainInsLblMagrinLeft = 170

    local infoMainInsStrs = bm.LangUtil.getText("RECVADDR", "INFO_INS")
    local infoMainInsLbls = {}

    local titleBarDentBorH = 8
    local panelTilteBarHeight = self:getTitleBarSize().height

    local infoMainInsLblModel = display.newTTFLabel({text = infoMainInsStrs[1], size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    local infoMainInsLblSizeCal = infoMainInsLblModel:getContentSize()

    for i = 1, #infoMainInsStrs do
        infoMainInsLbls[i] = display.newTTFLabel({text = infoMainInsStrs[i], size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
        infoMainInsLbls[i]:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
        infoMainInsLbls[i]:pos(- PANEL_WIDTH / 2 + infoMainInsLblMagrinLeft, PANEL_HEIGHT / 2 - panelTilteBarHeight - titleBarDentBorH - infoMainInsLblBlockMagrinTop -
            (i * 2 - 1) * infoMainInsLblSizeCal.height / 2 - (i - 1) * infomainInsLblMagrinEach)
            :addTo(self, self.ZORDER_CONT)
    end

    -- Edit Block --
    local editNorBarSize = {
        width = 370,
        height = 40
    }

    local editBarMagrinLeft = 15

    local editNorBarPosFix = {
        x = 20,
        y = 2
    }

    local editNorBarFontSize = 24

    local editTextColor = display.COLOR_WHITE
    local editPlaceholderColor = display.COLOR_GREEN
    -- EditName -- 
    local nameMaxLength = 128

    self.nameEdit_ = cc.ui.UIInput.new({image = "#common_bgInputLayer.png", size = cc.size(editNorBarSize.width, editNorBarSize.height), listener =
        handler(self, self.onNameEdit_), x = infoMainInsLbls[1]:getPositionX() + infoMainInsLbls[1]:getContentSize().width + editBarMagrinLeft +
            editNorBarSize.width / 2 - editNorBarPosFix.x, y = infoMainInsLbls[1]:getPositionY() - editNorBarPosFix.y})
        :addTo(self, self.ZORDER_CONT)

    self.nameEdit_:setFont(ui.DEFAULT_TTF_FONT, editNorBarFontSize)
    self.nameEdit_:setFontColor(editTextColor)

    self.nameEdit_:setMaxLength(nameMaxLength)
    self.nameEdit_:setPlaceHolder(bm.LangUtil.getText("SCOREMARKET", "USER_NAME"))
    self.nameEdit_:setPlaceholderFont(ui.DEFAULT_TTF_FONT, editNorBarFontSize)
    self.nameEdit_:setPlaceholderFontColor(editPlaceholderColor)

    self.nameEdit_:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    self.nameEdit_:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)

    -- SexChkBtn --
    labelParam.fontSize = 25
    labelParam.color = display.COLOR_WHITE

    local sexBtnLblOffset = {
        x = 22,
        y = 0
    }

    local sexRdbtnsGap = 130

    self.sexCheckBtnGroup_ = nk.ui.CheckBoxButtonGroup.new()

    self.sexChkBtns_ = {}

    self.sexChkBtns_[1] = cc.ui.UICheckBoxButton.new({on = "#userAddr_rdbtnSex_sel.png", off = "#userAddr_rdbtnSex_unSel.png"}, {scale9 = false})
        :setButtonLabel(display.newTTFLabel({text = bm.LangUtil.getText("SCOREMARKET", "MAN"), size = labelParam.fontSize, color = labelParam.color, align =
            ui.TEXT_ALIGN_CENTER}))
        :setButtonLabelOffset(sexBtnLblOffset.x, sexBtnLblOffset.y)
        :pos(infoMainInsLbls[2]:getPositionX() + infoMainInsLbls[2]:getContentSize().width + editBarMagrinLeft, infoMainInsLbls[2]:getPositionY() - editNorBarPosFix.y)
        :addTo(self, self.ZORDER_CONT)

    self.sexCheckBtnGroup_:addButton(self.sexChkBtns_[1])

    self.sexChkBtns_[2] = self.sexChkBtns_[1]:createCloneInstance_()
        :setButtonLabel(display.newTTFLabel({text = bm.LangUtil.getText("SCOREMARKET", "FEMALE"), size = labelParam.fontSize, color = labelParam.color, align =
            ui.TEXT_ALIGN_CENTER}))
        :setButtonLabelOffset(sexBtnLblOffset.x, sexBtnLblOffset.y)
        :pos(self.sexChkBtns_[1]:getPositionX() + sexRdbtnsGap, infoMainInsLbls[2]:getPositionY() - editNorBarPosFix.y)
        :addTo(self, self.ZORDER_CONT)

    self.sexCheckBtnGroup_:addButton(self.sexChkBtns_[2])

    self.sexCheckBtnGroup_:onButtonSelectChanged(buttontHandler(self, self.onSexRdBtnSelChangeCallBack_))

    local sexIdx = nil

    if nk.userData["aUser.msex"] == 2 or nk.userData["aUser.msex"] == 0 then
        --todo
        sexIdx = 2
    else
        sexIdx = 1
    end
    self.sexCheckBtnGroup_:getButtonAtIndex(sexIdx):setButtonSelected(true)

    -- AddrDetail --
    local comboxBgParam = {
        width = 122,
        height = editNorBarSize.height
    }

    local addrDetailEdtBarMagrinLeft = 8
    local addrDetailEditBarWidth = editNorBarSize.width - comboxBgParam.width - addrDetailEdtBarMagrinLeft

    local addrDetMaxLength = 96
    self.addressEdit_ = cc.ui.UIInput.new({image = "#common_bgInputLayer.png", size = cc.size(addrDetailEditBarWidth, editNorBarSize.height), listener = handler(self,
        self.onAddressEdit_), x = infoMainInsLbls[3]:getPositionX() + infoMainInsLbls[3]:getContentSize().width + editBarMagrinLeft +
            comboxBgParam.width + addrDetailEditBarWidth / 2 + addrDetailEdtBarMagrinLeft - editNorBarPosFix.x, y = infoMainInsLbls[3]:getPositionY() -
                editNorBarPosFix.y})
        :addTo(self, self.ZORDER_CONT)

    self.addressEdit_:setFont(ui.DEFAULT_TTF_FONT, editNorBarFontSize)
    self.addressEdit_:setFontColor(editTextColor)

    self.addressEdit_:setMaxLength(addrDetMaxLength)
    self.addressEdit_:setPlaceHolder(bm.LangUtil.getText("SCOREMARKET", "DETAIL_ADDRESS"))
    self.addressEdit_:setPlaceholderFont(ui.DEFAULT_TTF_FONT, editNorBarFontSize)
    self.addressEdit_:setPlaceholderFontColor(editPlaceholderColor)

    self.addressEdit_:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    self.addressEdit_:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
        
    -- Addr Combox View --
    local comboxItemParam = {
        width = 118,
        height = 25
    }

    labelParam.fontSize = 24
    labelParam.color = display.COLOR_WHITE

    local params = {}
    params.itemCls = AddrComboItem
    params.listWidth = comboxItemParam.width
    params.listHeight = comboxItemParam.height * 6
    params.listOffY = - comboxItemParam.height * 2 / 3 
    params.borderSize = cc.size(comboxBgParam.width, comboxBgParam.height)
    params.lblSize = labelParam.fontSize
    params.lblcolor = labelParam.color
    params.barNoScale = true

    self.combo_ = nk.ui.ComboboxView.new(params)
        :pos(infoMainInsLbls[3]:getPositionX() + infoMainInsLbls[3]:getContentSize().width + editBarMagrinLeft + comboxBgParam.width / 2 - editNorBarPosFix.x,
            infoMainInsLbls[3]:getPositionY() - editNorBarPosFix.y)
        :addTo(self, 100)

    local cityDataList = bm.LangUtil.getText("SCOREMARKET", "CITY")
    self.combo_:setData(cityDataList, cityDataList[1])

    -- TelNum && EmailAddr-- 
    local telMaxLength = 10

    self.telEdit_ = cc.ui.UIInput.new({image = "#common_bgInputLayer.png", size = cc.size(editNorBarSize.width, editNorBarSize.height), listener = handler(self,
        self.onTelEdit_), x = infoMainInsLbls[4]:getPositionX() + infoMainInsLbls[4]:getContentSize().width + editBarMagrinLeft + editNorBarSize.width / 2 -
            editNorBarPosFix.x, y = infoMainInsLbls[4]:getPositionY() - editNorBarPosFix.y})
        :addTo(self, self.ZORDER_CONT)

    self.telEdit_:setFont(ui.DEFAULT_TTF_FONT, editNorBarFontSize)
    self.telEdit_:setFontColor(editTextColor)

    self.telEdit_:setMaxLength(telMaxLength)
    self.telEdit_:setPlaceHolder(bm.LangUtil.getText("SCOREMARKET", "MOBEL_TEL"))
    self.telEdit_:setPlaceholderFont(ui.DEFAULT_TTF_FONT, editNorBarFontSize)
    self.telEdit_:setPlaceholderFontColor(editPlaceholderColor)

    self.telEdit_:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.telEdit_:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)

    local emailMaxLength = 32

    self.emailEdit_ = cc.ui.UIInput.new({image = "#common_bgInputLayer.png", size = cc.size(editNorBarSize.width, editNorBarSize.height), listener = handler(self,
        self.onEmailEdit_), x = infoMainInsLbls[5]:getPositionX() + infoMainInsLbls[5]:getContentSize().width + editBarMagrinLeft + editNorBarSize.width / 2 -
            editNorBarPosFix.x, y = infoMainInsLbls[5]:getPositionY() - editNorBarPosFix.y})
        :addTo(self, self.ZORDER_CONT)

    self.emailEdit_:setFont(ui.DEFAULT_TTF_FONT, editNorBarFontSize)
    self.emailEdit_:setFontColor(editTextColor)

    self.emailEdit_:setMaxLength(emailMaxLength)
    self.emailEdit_:setPlaceHolder(bm.LangUtil.getText("SCOREMARKET", "EMAIL"))
    self.emailEdit_:setPlaceholderFont(ui.DEFAULT_TTF_FONT, editNorBarFontSize)
    self.emailEdit_:setPlaceholderFontColor(editPlaceholderColor)

    self.emailEdit_:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    self.emailEdit_:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)

    -- AreaBelow -- 
    local dentBotStencil = {
        x = 5,
        y = 1,
        width = 113,
        height = 80
    }

    local dentBotAreaSizeH = 80
    local dentBotBorH = 5

    local dentBotBlock = display.newScale9Sprite("#common_bgDentPanelBot.png", 0, - PANEL_HEIGHT / 2 + dentBotAreaSizeH / 2 + dentBotBorH, cc.size(PANEL_WIDTH,
        dentBotAreaSizeH), cc.rect(dentBotStencil.x, dentBotStencil.y, dentBotStencil.width, dentBotStencil.height))
        :addTo(self)

    local updAddrBtnSize = {
        width = 180,
        height = 60
    }

    labelParam.fontSize = 26
    labelParam.color = display.COLOR_WHITE

    self.updAddrInfoBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnGreenRigOutl.png", pressed = "#common_btnGreenRigOutl.png", disabled =
        "#common_btnGreyLitRigOut.png"}, {scale9 = true})
        :setButtonSize(updAddrBtnSize.width, updAddrBtnSize.height)
        :setButtonLabel(display.newTTFLabel({text = bm.LangUtil.getText("RECVADDR", "UPDATE_INFO"), size = labelParam.fontSize, color =
            labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked(buttontHandler(self, self.onUpdateAddrInfoCallBack_))
        :pos(PANEL_WIDTH / 2, dentBotAreaSizeH / 2)
        :addTo(dentBotBlock)

    local tipsMagrinBot = 15

    labelParam.fontSize = 18
    labelParam.color = display.COLOR_WHITE

    local tipsBot = display.newTTFLabel({text = bm.LangUtil.getText("RECVADDR", "DISCLAIM"), size = labelParam.fontSize, color = labelParam.color,
        align = ui.TEXT_ALIGN_CENTER})
    tipsBot:pos(0, - PANEL_HEIGHT / 2 + dentBotAreaSizeH + dentBotBorH + tipsMagrinBot + tipsBot:getContentSize().height / 2)
        :addTo(self)

    self.infoEditBoxList_ = {
        self.nameEdit_,
        self.addressEdit_,
        self.telEdit_,
        self.emailEdit_
    }

    for i, editbox in ipairs(self.infoEditBoxList_) do
        nk.EditBoxManager:addEditBox(editbox)
    end
end

function UserAddrComfirmPopup:onNameEdit_(evt)
	-- body
	if evt == "began" then

    elseif evt == "changed" then
        local text = self.nameEdit_:getText()
        local filteredText = nk.keyWordFilter(text)

        if filteredText ~= text then
            self.nameEdit_:setText(filteredText)
        end

        self.editNick_ = self.nameEdit_:getText()
    elseif evt == "ended" then

    elseif evt == "return" then

    end
end

function UserAddrComfirmPopup:onSexRdBtnSelChangeCallBack_(evt)
    -- body
    -- if evt.selected == 1 then
    --     --todo
    --     self.sexChkBtns[1].label_:setTextColor(cc.c3b(152, 229, 228))
    --     self.sexChkBtns[2].label_:setTextColor(display.COLOR_WHITE)
    -- else
    --     self.sexChkBtns[1].label_:setTextColor(display.COLOR_WHITE)
    --     self.sexChkBtns[2].label_:setTextColor(cc.c3b(152, 229, 228))
    -- end
    self.sexIndex_ = evt.selected
end

function UserAddrComfirmPopup:onTelEdit_(evt)
	-- body
	if evt == "began" then

    elseif evt == "changed" then
        local text = self.telEdit_:getText()
        if string.find(text, "^[+-]?%d+$") then

            local textTrim = string.trim(text)
            local len = string.len(textTrim)

            if len < 9 then
               text = ""
            end
            self.telEdit_:setText(textTrim)
            self.editTel_ = textTrim
        else
            -- Illegal Tel Num --
            self.editTel_ = self.editTel_ or ""
            self.telEdit_:setText(self.editTel_)
        end
    elseif evt == "ended" then

    elseif evt == "return" then

    end
end

function UserAddrComfirmPopup:onAddressEdit_(evt)
	-- body
	if evt == "began" then

    elseif evt == "changed" then
        local text = self.addressEdit_:getText()
        local filteredText = nk.keyWordFilter(text)
        if filteredText ~= text then
            self.addressEdit_:setText(filteredText)
        end

        text = self.addressEdit_:getText()
        local addrTextLenthReal = string.len(string.trim(text))
        if addrTextLenthReal <= 0 then
            --todo
            text = ""
            self.addressEdit_:setText(text)
        end

        self.editAddress_ = text
    elseif evt == "ended" then

    elseif evt == "return" then

    end
end

function UserAddrComfirmPopup:onEmailEdit_(evt)
	-- body
	if evt == "began" then

    elseif evt == "changed" then
        local text = string.trim(self.emailEdit_:getText())
        local filteredText = nk.keyWordFilter(text)

        if filteredText ~= text then
            --todo
            self.emailEdit_:setText(filteredText)
        end

        -- Check Email Addr Legality --
        -- if self:isRightEmail(text) then
        --     --todo
        -- end
        self.editEmail_ = self.emailEdit_:getText()

    elseif evt == "ended" then

    elseif evt == "return" then

    end
end

function UserAddrComfirmPopup:onUpdateAddrInfoCallBack_()
    -- body
    self.updAddrInfoBtn_:setButtonEnabled(false)

    local result = nil

    local params = {}
    params.name = self.editNick_ or ""

    if params.name == nil or params.name == "" then
        result = bm.LangUtil.getText("SCOREMARKET", "USER_NAME")
    end
    
    params.tel = self.editTel_

    if params.tel == nil or params.tel == "" then
        result = bm.LangUtil.getText("SCOREMARKET", "MOBEL_TEL")
    end

    params.address = self.editAddress_ or ""

    if params.address == nil or params.address == "" then
        result = bm.LangUtil.getText("SCOREMARKET", "DETAIL_ADDRESS")
    end

    params.mail = self.editEmail_ or ""

    if params.mail == nil or params.mail == "" then
        result = bm.LangUtil.getText("SCOREMARKET", "EMAIL")
    end

    if result then
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("SCOREMARKET", "ALERT_WRITEADDRESS", result))
        self.updAddrInfoBtn_:setButtonEnabled(true)
        return
    end

     params.sex = self.sexIndex_ or ""
     params.city = self.combo_:getText() or ""

     self.controller_:saveUserAddress(params, self.saveAddrCallBack_)
     self:hidePanel_()
end

function UserAddrComfirmPopup:bindAddressInfo_(data)
	-- body
	if data then
        self.editEmail_ = data.mail or ""
        self.editTel_ = data.tel or ""
        self.editAddress_ = data.address or ""
        self.editNick_ = data.name or ""

        local cityDataList = bm.LangUtil.getText("SCOREMARKET", "CITY")

        if self and self.combo_ then
            self.combo_:setText(data.city or cityDataList[1])
        end

        self.emailEdit_:setText(data.mail)
        self.nameEdit_:setText(data.name)
        self.telEdit_:setText(data.tel)
        self.addressEdit_:setText(data.address)
        data.sex = checkint(data.sex or 0)

        if data.sex ~= 1 and data.sex ~= 2 then
            data.sex = 1
        end
        self.sexIndex_ = data.sex

        self.sexCheckBtnGroup_:getButtonAtIndex(self.sexIndex_):setButtonSelected(true)
    end
end

function UserAddrComfirmPopup:isRightEmail(str)
     if string.len(str or "") < 6 then return false end
     local b,e = string.find(str or "", '@')
     local bstr = ""
     local estr = ""
     if b then
         bstr = string.sub(str, 1, b - 1)
         estr = string.sub(str, e + 1, -1)
     else
         return false
     end

     -- check the string before '@'
     local p1, p2 = string.find(bstr, "[%w_]+")
     if (p1 ~= 1) or (p2 ~= string.len(bstr)) then return false end

     -- check the string after '@'
     if string.find(estr, "^[%.]+") then return false end
     if string.find(estr, "%.[%.]+") then return false end
     if string.find(estr, "@") then return false end
     if string.find(estr, "[%.]+$") then return false end

     _, count = string.gsub(estr, "%.", "")
     if (count < 1 ) or (count > 3) then
         return false
     end

     return true
 end

function UserAddrComfirmPopup:showPanel(callBack)
	-- body
    self.saveAddrCallBack_ = callBack

	self:showPanel_()
	return self
end

function UserAddrComfirmPopup:onShowed()
    -- body
    if self and self.combo_ then
        --todo
        self.combo_:onShowed()
    end
end

function UserAddrComfirmPopup:onEnter()
	-- body
end

function UserAddrComfirmPopup:onExit()
	-- body
    for _, editbox in ipairs(self.infoEditBoxList_) do
        nk.EditBoxManager:removeEditBox(editbox)
    end
	-- self.controller_:dispose()
end

function UserAddrComfirmPopup:onCleanup()
	-- body
    nk.schedulerPool:delayCall(function()
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    end, 0.1)
end

return UserAddrComfirmPopup