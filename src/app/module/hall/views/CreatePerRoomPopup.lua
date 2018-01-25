--
-- Author: ThinkerWang
-- Date: 2015-09-14 12:14:50
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: CreatePerRoomPopup.lua Create && Reconstructed By Tsing7x.
--

local CreatePerRoomPopup = class("CreatePerRoomPopup", nk.ui.Panel)

function CreatePerRoomPopup:ctor()
    self:setNodeEventEnabled(true)
    self.super.ctor(self, self.SIZE_LARGE)

    self.background_:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onBackgourndTouch_))

    local roomCreateTitle = display.newSprite("#roomChos_perRoomTiCrt.png")
    self:addPanelTitleBar(roomCreateTitle)

    local panelTitleBarSize = self:getTitleBarSize()
    local panelBorWTop = 6

    local feeDetBtnSize = {
        width = 32,
        height = 32
    }

    local feeDetMagrins = {
        top = 10,
        left = 18
    }

    self.feeDetBtn_ = cc.ui.UIPushButton.new({normal = "#roomChos_btnSighMark.png", pressed = "#roomChos_btnSighMark.png", disabled = "#roomChos_btnSighMark.png"},
        {scale9 = false})
        :onButtonClicked(buttontHandler(self, self.onfeeDetBtnCallBack_))
        :pos(- self.width_ / 2 + feeDetMagrins.left + feeDetBtnSize.width / 2, self.height_ / 2 - panelTitleBarSize.height - panelBorWTop - feeDetMagrins.top -
            feeDetBtnSize.height / 2)
        :addTo(self)

    local labelParam = {
        fontSize = 0,
        color = display.COLOR_WHITE
    }

    -- Main Info Input Area --
    -- Ins Lbls --
    local infoInsLblsCntMagrinTop = 64
    local infoInsLblsMagrinLeft = 190
    local infoInsLblsCntMagrinEach = 60

    local createInfoInsStrs = bm.LangUtil.getText("HALL", "PERSONALROOM_CREATEINS")

    labelParam.fontSize = 25
    labelParam.color = display.COLOR_WHITE

    -- Info Edit Block --
    local infoInputEdtBoxSize = {
        width = 310,
        height = 42
    }

    local infoInputEdtBoxMagrinLeft = 20
    local infoInputEdtBoxPosYFix = 0

    local editInputInfoFontSize = 22

    local editTextColor = display.COLOR_WHITE
    local editPlaceholderColor = display.COLOR_GREEN

    -- Info Edit Block END! --
    local infoInsLbls = {}
    for i = 1, #createInfoInsStrs do
        infoInsLbls[i] = display.newTTFLabel({text = createInfoInsStrs[i], size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
        infoInsLbls[i]:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
        infoInsLbls[i]:pos(- self.width_ / 2 + infoInsLblsMagrinLeft, self.height_ / 2 - panelTitleBarSize.height - panelBorWTop - infoInsLblsCntMagrinTop -
            infoInsLblsCntMagrinEach * (i - 1))
            :addTo(self)
    end

    local feeDetBorSize = {
        width = 255,
        height = 120
    }

    local feeDetInfoBorMagrinLeft = 5
    -- local feeDetInfoBorMagrinTop = 12

    self.roomFeeDetInfoBor_ = display.newScale9Sprite("#roomChos_bgPerFeeDet.png", self.feeDetBtn_:getPositionX() + feeDetBtnSize.width / 2 +
        feeDetBorSize.width / 2 + feeDetInfoBorMagrinLeft, self.feeDetBtn_:getPositionY() + feeDetBtnSize.height / 2 - feeDetBorSize.height / 2,
            cc.size(feeDetBorSize.width, feeDetBorSize.height))
        :addTo(self)

    labelParam.fontSize = 20
    labelParam.color = display.COLOR_WHITE

    local roomFeeLblShownMagrinHoriz = 8

    local roomFeeDetInfo = display.newTTFLabel({text = bm.LangUtil.getText("HALL", "PERSONAL_CREATE_ROOM_TIPS"), size = labelParam.fontSize, color = labelParam.color,
        dimensions = cc.size(feeDetBorSize.width - roomFeeLblShownMagrinHoriz * 2, feeDetBorSize.height), align = ui.TEXT_ALIGN_CENTER})
        :pos(feeDetBorSize.width / 2, feeDetBorSize.height / 2)
        :addTo(self.roomFeeDetInfoBor_)

    self.roomFeeDetInfoBor_:setVisible(false)

    local roomNameMaxLen = 60

    self.roomNameEdit_ = cc.ui.UIInput.new({image = "#common_bgInputLayer.png", size = cc.size(infoInputEdtBoxSize.width, infoInputEdtBoxSize.height), listener =
        handler(self, self.onRoomNameEdit_), x = infoInsLbls[1]:getPositionX() + infoInsLbls[1]:getContentSize().width + infoInputEdtBoxMagrinLeft +
            infoInputEdtBoxSize.width / 2, y = infoInsLbls[1]:getPositionY() - infoInputEdtBoxPosYFix})
        :addTo(self, self.ZORDER_CONT)

    self.roomNameEdit_:setFont(ui.DEFAULT_TTF_FONT, editInputInfoFontSize)
    self.roomNameEdit_:setFontColor(editTextColor)

    self.roomNameEdit_:setMaxLength(roomNameMaxLen)
    self.roomNameEdit_:setPlaceHolder(bm.LangUtil.getText("HALL", "PERSONALROOM_HINTROOMNAME"))
    self.roomNameEdit_:setPlaceholderFont(ui.DEFAULT_TTF_FONT, editInputInfoFontSize)
    self.roomNameEdit_:setPlaceholderFontColor(editPlaceholderColor)

    self.roomNameEdit_:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    self.roomNameEdit_:setReturnType(cc.KEYBOARD_RETURNTYPE_GO)

    local roomFeeDisplayBg = display.newScale9Sprite("#common_bgInputLayer.png", infoInsLbls[2]:getPositionX() + infoInsLbls[2]:getContentSize().width +
        infoInputEdtBoxMagrinLeft + infoInputEdtBoxSize.width / 2, infoInsLbls[2]:getPositionY() - infoInputEdtBoxPosYFix, cc.size(infoInputEdtBoxSize.width,
            infoInputEdtBoxSize.height))
        :addTo(self, self.ZORDER_CONT)

    roomFeeDisplayBg:setTouchEnabled(true)
    roomFeeDisplayBg:addNodeEventListener(cc.NODE_TOUCH_EVENT, buttontHandler(self, self.onRoomFeeInputCallBack_))

    local baseChipLblMagrinLeft = 5

    -- BaseChip Num Integer Multiple Of 100, Default :100 --
    self.baseChipNum_ = display.newTTFLabel({text = "100", size = editInputInfoFontSize, color = editTextColor, align = ui.TEXT_ALIGN_CENTER})
    self.baseChipNum_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.baseChipNum_:pos(baseChipLblMagrinLeft, infoInputEdtBoxSize.height / 2)
        :addTo(roomFeeDisplayBg)

    self.curBaseChipNumString = self.baseChipNum_:getString()
    self.inputBaseChipNumString = ""

    local roomPswMaxLen = 6

    self.roomPswEdit_ = cc.ui.UIInput.new({image = "#common_bgInputLayer.png", size = cc.size(infoInputEdtBoxSize.width, infoInputEdtBoxSize.height), listener =
        handler(self, self.onRoomPswEdit_), x = infoInsLbls[3]:getPositionX() + infoInsLbls[3]:getContentSize().width + infoInputEdtBoxMagrinLeft +
            infoInputEdtBoxSize.width / 2, y = infoInsLbls[3]:getPositionY() - infoInputEdtBoxPosYFix})
        :addTo(self, self.ZORDER_CONT)

    self.roomPswEdit_:setFont(ui.DEFAULT_TTF_FONT, editInputInfoFontSize)
    self.roomPswEdit_:setFontColor(editTextColor)

    self.roomPswEdit_:setMaxLength(roomPswMaxLen)
    self.roomPswEdit_:setPlaceHolder(bm.LangUtil.getText("HALL", "PERSONALROOM_HINTROOMPSW"))
    self.roomPswEdit_:setPlaceholderFont(ui.DEFAULT_TTF_FONT, editInputInfoFontSize)
    self.roomPswEdit_:setPlaceholderFontColor(editPlaceholderColor)

    self.roomPswEdit_:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.roomPswEdit_:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)

    local roomBaseInfoInsMagrinLastEdtBox = 38
    local roomBaseInfoInsGapEach = 96

    local feeRateIns = display.newTTFLabel({text = bm.LangUtil.getText("HALL", "PERSONALROOM_CREATEINSBOT")[1], size = labelParam.fontSize, color = labelParam.color,
        align = ui.TEXT_ALIGN_CENTER})
    feeRateIns:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    feeRateIns:pos(infoInsLbls[3]:getPositionX(), self.roomPswEdit_:getPositionY() - infoInputEdtBoxSize.height / 2 - roomBaseInfoInsMagrinLastEdtBox -
        feeRateIns:getContentSize().height / 2)
        :addTo(self)

    local roomMinBuyInIns = display.newTTFLabel({text = bm.LangUtil.getText("HALL", "PERSONALROOM_CREATEINSBOT")[2], size = labelParam.fontSize, color = labelParam.color,
        align = ui.TEXT_ALIGN_CENTER})
    roomMinBuyInIns:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    roomMinBuyInIns:pos(feeRateIns:getPositionX() + feeRateIns:getContentSize().width + roomBaseInfoInsGapEach, feeRateIns:getPositionY())
        :addTo(self)

    labelParam.fontSize = 22
    labelParam.color = styles.FONT_COLOR.GOLDEN_TEXT

    local roomBaseInfoMagrinIns = 10
    self.roomFeeRate_ = display.newTTFLabel({text = "0%", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.roomFeeRate_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.roomFeeRate_:pos(feeRateIns:getPositionX() + feeRateIns:getContentSize().width + roomBaseInfoMagrinIns, feeRateIns:getPositionY())
        :addTo(self)

    -- Fixed Temporary, Call Func setBaseChipNum If Change, Add roomFeeRate_ Set In Func setBaseChipNum
    self.roomFeeRate_:setString("10%")

    self.roomMinBuyIn_ = display.newTTFLabel({text = "0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
    self.roomMinBuyIn_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    self.roomMinBuyIn_:pos(roomMinBuyInIns:getPositionX() + roomMinBuyInIns:getContentSize().width + roomBaseInfoMagrinIns, roomMinBuyInIns:getPositionY())
        :addTo(self)

    labelParam.fontSize = 18
    labelParam.color = display.COLOR_BLACK

    local nonePswTipsMagrinTop = 4
    local nonePswTips = display.newTTFLabel({text = bm.LangUtil.getText("HALL", "PERSONALROOM_HINTROOMPSWNONE"), size = labelParam.fontSize, color = labelParam.color,
        align = ui.TEXT_ALIGN_CENTER})
    nonePswTips:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
    nonePswTips:pos(self.roomPswEdit_:getPositionX() - infoInputEdtBoxSize.width / 2, self.roomPswEdit_:getPositionY() - infoInputEdtBoxSize.height / 2 -
        nonePswTipsMagrinTop - nonePswTips:getContentSize().height / 2)
        :addTo(self)

    -- Area Create Room Bot --
    local dentBotStencil = {
        x = 5,
        y = 1,
        width = 113,
        height = 80
    }

    local dentBotAreaSizeH = 80
    local dentBotBorH = 5

    local dentBotBlock = display.newScale9Sprite("#common_bgDentPanelBot.png", 0, - self.height_ / 2 + dentBotAreaSizeH / 2 + dentBotBorH, cc.size(self.width_,
        dentBotAreaSizeH), cc.rect(dentBotStencil.x, dentBotStencil.y, dentBotStencil.width, dentBotStencil.height))
        :addTo(self)

    local createRoomBtnSize = {
        width = 180,
        height = 60
    }

    labelParam.fontSize = 28
    labelParam.color = display.COLOR_WHITE

    self.createRoomBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnGreenRigOutl.png", pressed = "#common_btnGreenRigOutl.png", disabled =
        "#common_btnGreyLitRigOut.png"}, {scale9 = true})
        :setButtonSize(createRoomBtnSize.width, createRoomBtnSize.height)
        :setButtonLabel(display.newTTFLabel({text = "创建筹码房间", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked(buttontHandler(self, self.onCreatePerRoomBtnCallBack_))
        :pos(self.width_ / 2, dentBotAreaSizeH / 2)
        :addTo(dentBotBlock)

    self:addCloseBtn()

    nk.EditBoxManager:addEditBox(self.roomNameEdit_)
    nk.EditBoxManager:addEditBox(self.roomPswEdit_)
end

function CreatePerRoomPopup:setBaseChipNum()
    self.baseChipNum_:setString(bm.formatNumberWithSplit(self.curBaseChipNumString))
    self.roomMinBuyIn_:setString(20 * tonumber(self.curBaseChipNumString))
end

function CreatePerRoomPopup:onBackgourndTouch_(evt)
    -- body
    local isFeeDetInfoVisble = self.roomFeeDetInfoBor_:isVisible()

    if isFeeDetInfoVisble then
        --todo
        self.roomFeeDetInfoBor_:setVisible(false)
    end
end

function CreatePerRoomPopup:onfeeDetBtnCallBack_(evt)
    -- body
    local isFeeDetInfoVisble = self.roomFeeDetInfoBor_:isVisible()

    if isFeeDetInfoVisble then
        --todo
        self.roomFeeDetInfoBor_:setVisible(false)
    else
        self.roomFeeDetInfoBor_:setVisible(true)
    end
end

function CreatePerRoomPopup:onRoomNameEdit_(evt)
	if evt == "began" then
        local isFeeDetInfoVisble = self.roomFeeDetInfoBor_:isVisible()

        if isFeeDetInfoVisble then
            --todo
            self.roomFeeDetInfoBor_:setVisible(false)
        end
    elseif evt == "changed" then
        local text = self.roomNameEdit_:getText()
        local filteredText = nk.keyWordFilter(text)

        if filteredText ~= text then
            self.roomNameEdit_:setText(filteredText)
        end

        self.roomName_ = self.roomNameEdit_:getText()
    elseif evt == "ended" then
        
    elseif evt == "return" then

    end
end

function CreatePerRoomPopup:onRoomFeeInputCallBack_(evt)
    -- body
    local isFeeDetInfoVisble = self.roomFeeDetInfoBor_:isVisible()

    if isFeeDetInfoVisble then
        --todo
        self.roomFeeDetInfoBor_:setVisible(false)
    end

    nk.ui.DigitInputPanel.new():showPanel(handler(self, self.onBaseChipDigitInput), handler(self, self.onBaseChipDigitDel))
end

function CreatePerRoomPopup:onRoomPswEdit_(evt)
	if evt == "began" then
        local isFeeDetInfoVisble = self.roomFeeDetInfoBor_:isVisible()

        if isFeeDetInfoVisble then
            --todo
            self.roomFeeDetInfoBor_:setVisible(false)
        end
    elseif evt == "changed" then

    elseif evt == "ended" then
        self.roomPsw_ = self.roomPswEdit_:getText()

    elseif evt == "return" then
        
    end
end

function CreatePerRoomPopup:onCreatePerRoomBtnCallBack_(evt)
    -- body
    self.createRoomBtn_:setButtonEnabled(false)

    local roomName = ""
    local roomPsw = ""
    local roomBaseChipNum = tonumber(self.curBaseChipNumString)

    if not self.roomName_ or string.len(string.trim(self.roomName_)) <= 0 then
        roomName = bm.LangUtil.getText("HALL", "PERSONAL_ROOM_DEF_ROOMNAME")
    else
        roomName_ = self.roomName_
    end

    if not self.roomPsw_ or string.len(string.trim(self.roomPsw_)) <= 0 then
        roomPsw = nil
    else
        roomPsw = self.roomPsw_
    end

    if roomPsw and string.len(roomPsw) ~= 6 then
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("HALL", "PERSONALROOM_HINTROOMPSW"))
        return
    end

    if nk.userData["aUser.money"] < 20 * roomBaseChipNum then
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("HALL", "PERSONAL_ROOM_NOT_ENOUGH"))
        return
    end

    nk.server:createPersonalRoom(nil, roomBaseChipNum, roomName, roomPsw)

    self:hidePanel_()
end

function CreatePerRoomPopup:onBaseChipDigitInput(inputNum)
    -- body
    if string.len(self.inputBaseChipNumString) <= 0 and inputNum == 0 then
        return
    end

    self.inputBaseChipNumString = self.inputBaseChipNumString .. inputNum

    self.curBaseChipNumString = self.inputBaseChipNumString .. "00"

    if tonumber(self.curBaseChipNumString) >= 1000000 then
        self.curBaseChipNumString = "1000000"
        self.inputBaseChipNumString = "10000"
    end

    self:setBaseChipNum()
end

function CreatePerRoomPopup:onBaseChipDigitDel()
    -- body
    if self.curBaseChipNumString == "100" then
        --todo
        self.inputBaseChipNumString = ""
        return
    end

    if string.len(self.inputBaseChipNumString) == 1 then
        --todo
        self.curBaseChipNumString = "100"
        self.inputBaseChipNumString = ""

        self:setBaseChipNum()
        return
    end

    local curLength = string.len(self.inputBaseChipNumString)
    local currentString = string.sub(self.inputBaseChipNumString, 0, curLength - 1)

    self.inputBaseChipNumString = currentString
    self.curBaseChipNumString = self.inputBaseChipNumString .. "00"

    self:setBaseChipNum()
end

function CreatePerRoomPopup:showPanel()
    self:showPanel_()
    return self
end

function CreatePerRoomPopup:onShowed()

end

function CreatePerRoomPopup:onEnter()
    -- body
end

function CreatePerRoomPopup:onExit()
    -- body
    nk.EditBoxManager:removeEditBox(self.roomNameEdit_)
    nk.EditBoxManager:removeEditBox(self.roomPswEdit_)
end

function CreatePerRoomPopup:onCleanup()
    -- body
end

return CreatePerRoomPopup