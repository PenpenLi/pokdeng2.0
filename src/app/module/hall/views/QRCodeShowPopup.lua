--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-04-12 18:34:17
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: QRCodeShowPopup.lua Create && Reconstructed By Tsing7x.
--

local QRCodeShowPopup = class("QRCodeShowPopup", nk.ui.Panel)

function QRCodeShowPopup:ctor()
	-- body
	self:setNodeEventEnabled(true)
	self.super.ctor(self, self.SIZE_SMALL)

	local titleQR = display.newSprite("#roomChos_perRoomTiQR.png")
	self:addPanelTitleBar(titleQR)

	local QRCodeFramePosYOffset = 20
	local QRCodeFrame = display.newSprite("#common_gameQRCode.png")
		:pos(0, - QRCodeFramePosYOffset)
		:addTo(self)

	labelParam = {
		fontSize = 0,
		color = display.COLOR_WHITE
	}

	local inviteFriendTipMagrinBot = 22

	labelParam.fontSize = 18
	labelParam.color = display.COLOR_WHITE

	local inviteFriendTip = display.newTTFLabel({text = bm.LangUtil.getText("HALL", "PERSONAL_ROOM_QRSCAN_TIP_BOTTOM"), size = labelParam.fontSize, color = labelParam.color,
		align = ui.TEXT_ALIGN_CENTER})
	inviteFriendTip:pos(0, - self.SIZE_SMALL[2] / 2 + inviteFriendTipMagrinBot + inviteFriendTip:getContentSize().height / 2)
		:addTo(self)


	self:addCloseBtn()
end

function QRCodeShowPopup:showPanel()
	-- body
	self:showPanel_()
end

function QRCodeShowPopup:onEnter()
	-- body
end

function QRCodeShowPopup:onExit()
	-- body
end

function QRCodeShowPopup:onCleanup()
	-- body
end

return QRCodeShowPopup