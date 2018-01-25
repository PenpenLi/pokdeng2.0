--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-04-18 11:03:37
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: PswEntryPopup.lua Create && Reconstructed By Tsing7x.
--

local PswEntryPopup = class("PswEntryPopup", nk.ui.Panel)

function PswEntryPopup:ctor(param, callback)
	-- body
	self.roomEntryCallback_ = callback
	self.roomData_ = param

	self:setNodeEventEnabled(true)

	self.super.ctor(self, self.SIZE_SMALL)

	

	local labelParam = {
		fontSize = 0,
		color = display.COLOR_WHITE
	}

	-- labelParam.fontSize = 32
	-- labelParam.color = display.COLOR_WHITE

	-- local titleLbl = display.newTTFLabel({text = bm.LangUtil.getText("HALL", "PERSONAL_ROOM_ENTRY_TITLE"), size = labelParam.fontSize, color = labelParam.color,
	-- 	align = ui.TEXT_ALIGN_CENTER})
	
	local titlePswEntry = display.newSprite("#roomChos_perRoomTiPswEntry.png")

	self:addPanelTitleBar(titlePswEntry)

	local titleBarSize = self:getTitleBarSize()

	-- Room Info Lbls Area --
	labelParam.fontSize = 26
	labelParam.color = display.COLOR_WHITE

	local popPanelBorHTop = 5
	local roomInfoLblMagrinTop = 55
	local roomNameInfoLblsGap = 6

	local roomNameColum = display.newTTFLabel({text = bm.LangUtil.getText("HALL", "PERSONAL_ROOM_ENTRY_ROOM_NAME"), size = labelParam.fontSize, color = labelParam.color,
		align = ui.TEXT_ALIGN_CENTER})

	local roomNameColumSizeCal = roomNameColum:getContentSize()

	local roomNameLbl = display.newTTFLabel({text = param.roomName or bm.LangUtil.getText("HALL", "PERSONAL_ROOM_DEF_ROOMNAME"), size = labelParam.fontSize, color =
		labelParam.color, align = ui.TEXT_ALIGN_CENTER})

	local roomNameLblSizeCal = roomNameLbl:getContentSize()

	local roomInfoNameColWidth = roomNameColumSizeCal.width + roomNameInfoLblsGap + roomNameLblSizeCal.width

	roomNameColum:pos((roomNameColumSizeCal.width - roomInfoNameColWidth) / 2, self.height_ / 2 - popPanelBorHTop - titleBarSize.height - roomInfoLblMagrinTop -
		roomNameColumSizeCal.height / 2)
		:addTo(self)

	roomNameLbl:pos((roomInfoNameColWidth - roomNameLblSizeCal.width) / 2, roomNameColum:getPositionY())
		:addTo(self)

	local roomIdInfoMagrinTop = 12

	local rommIdColum = display.newTTFLabel({text = bm.LangUtil.getText("HALL", "PERSONAL_ROOM_ENTRY_ROOM_ID"), size = labelParam.fontSize, color = labelParam.color,
		align = ui.TEXT_ALIGN_CENTER})
	rommIdColum:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
	rommIdColum:pos(roomNameColum:getPositionX() - roomNameColumSizeCal.width / 2, roomNameColum:getPositionY() - roomNameColumSizeCal.height / 2 - 
		rommIdColum:getContentSize().height / 2)
		:addTo(self)

	local roomIdLbl = display.newTTFLabel({text = tostring(param.tableID) or "00000", size = labelParam.fontSize, color = labelParam.color, align =
		ui.TEXT_ALIGN_CENTER})
	roomIdLbl:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
	roomIdLbl:pos(rommIdColum:getPositionX() + rommIdColum:getContentSize().width + roomNameInfoLblsGap, rommIdColum:getPositionY())
		:addTo(self)

	-- Psw EditBox View --
	local pswInputEdtBoxSize = {
		width = 310,
		height = 42
	}

	local editInputInfoFontSize = 22

    local editTextColor = display.COLOR_WHITE
    local editPlaceholderColor = display.COLOR_GREEN

    local pswMaxLen = 6

    local edtBoxMagrinTop = 25
    self.pswEdit_ = cc.ui.UIInput.new({image = "#common_bgInputLayer.png", size = cc.size(pswInputEdtBoxSize.width, pswInputEdtBoxSize.height), listener = 
    	handler(self, self.onPswEdit_), x = 0, y = rommIdColum:getPositionY() - rommIdColum:getContentSize().height / 2 - edtBoxMagrinTop -
    		pswInputEdtBoxSize.height / 2})
    	:addTo(self)

    self.pswEdit_:setFont(ui.DEFAULT_TTF_FONT, editInputInfoFontSize)
    self.pswEdit_:setFontColor(editTextColor)

    self.pswEdit_:setMaxLength(pswMaxLen)
    self.pswEdit_:setPlaceHolder(bm.LangUtil.getText("HALL", "PERSONALROOM_HINTROOMPSW"))
    self.pswEdit_:setPlaceholderFont(ui.DEFAULT_TTF_FONT, editInputInfoFontSize)
    self.pswEdit_:setPlaceholderFontColor(editPlaceholderColor)

    self.pswEdit_:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.pswEdit_:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)

    nk.EditBoxManager:addEditBox(self.pswEdit_)

    labelParam.fontSize = 24
    labelParam.color = display.COLOR_RED

    local pswWrongTipMagrinTop = 12
    self.pswWrongTip_ = display.newTTFLabel({text = bm.LangUtil.getText("HALL", "PERSONAL_ROOM_ENTRY_WRONG_PSW_TIP"), size = labelParam.fontSize, color = labelParam.color,
    	align =	ui.TEXT_ALIGN_CENTER})
    self.pswWrongTip_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
	self.pswWrongTip_:pos(self.pswEdit_:getPositionX() - pswInputEdtBoxSize.width / 2, self.pswEdit_:getPositionY() - pswInputEdtBoxSize.height / 2 - pswWrongTipMagrinTop -
		self.pswWrongTip_:getContentSize().height / 2)
    	:addTo(self)

    self.pswWrongTip_:hide()

    -- Bot Area --
    local dentBotStencil = {
        x = 5,
        y = 1,
        width = 113,
        height = 80
    }

    local dentBotBgSize = {
    	width = self.width_,
    	height = 80
	}

	local dentBotBorH = 5

	labelParam.fontSize = 28
    labelParam.color = display.COLOR_WHITE

    local dentBotBlock = display.newScale9Sprite("#common_bgDentPanelBot.png", 0, - self.height_ / 2 + dentBotBgSize.height / 2 + dentBotBorH, cc.size(dentBotBgSize.width,
        dentBotBgSize.height), cc.rect(dentBotStencil.x, dentBotStencil.y, dentBotStencil.width, dentBotStencil.height))
        :addTo(self)

    local entryRoomBtnSize = {
        width = 180,
        height = 60
    }

    self.entryRoomBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnGreenRigOutl.png", pressed = "#common_btnGreenRigOutl.png", disabled = "#common_btnGreyLitRigOut.png"},
    	{scale9 = true})
    	:setButtonSize(entryRoomBtnSize.width, entryRoomBtnSize.height)
    	:setButtonLabel(display.newTTFLabel({text = bm.LangUtil.getText("HALL", "PERSONAL_ROOM_ENTRY_ENTER_ROOM"), size = labelParam.fontSize, color = labelParam.color, align =
			ui.TEXT_ALIGN_CENTER}))
    	:onButtonClicked(buttontHandler(self, self.onEntryRoomBtnCallBack_))
    	:pos(dentBotBgSize.width / 2, dentBotBgSize.height / 2)
    	:addTo(dentBotBlock)

    self.entryRoomBtn_:setButtonEnabled(false)

    self:addCloseBtn()
end

function PswEntryPopup:onPswEdit_(evt)
	-- body
	if evt == "began" then

    elseif evt == "changed" then

    elseif evt == "ended" then
        self.entryPsw_ = self.pswEdit_:getText()
    elseif evt == "return" then
    	if self.entryPsw_ and string.len(self.entryPsw_) == 6 then
    		--todo
    		self.entryRoomBtn_:setButtonEnabled(true)
    	else
    		self.entryRoomBtn_:setButtonEnabled(false)
    	end
    end
end

function PswEntryPopup:onEntryRoomBtnCallBack_(evt)
	-- body
	self.entryRoomBtn_:setButtonEnabled(false)

	if not self.entryPsw_ or string.len(string.trim(self.entryPsw_)) ~= 6 then
		--todo
		self.pswWrongTip_:show()
		return
	end

	self.pswWrongTip_:hide()

	if self.roomEntryCallback_ then
		self.roomEntryCallback_(self.entryPsw_, self.roomData_)
	end
	
	self:hidePanel_()
end

function PswEntryPopup:showPanel()
	-- body
	self:showPanel_()
end

function PswEntryPopup:onEnter()
	-- body
end

function PswEntryPopup:onExit()
	-- body
	nk.EditBoxManager:removeEditBox(self.pswEdit_)
end

function PswEntryPopup:onCleanup()
	-- body
end

return PswEntryPopup