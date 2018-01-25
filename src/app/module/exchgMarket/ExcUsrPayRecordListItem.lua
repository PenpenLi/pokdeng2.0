--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-06-08 14:47:49
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: ExcUsrPayRecordListItem.lua Created By Tsing7x.
--

local ExcUsrPayRecordListItem = class("ExcUsrPayRecordListItem", bm.ui.ListItem)

function ExcUsrPayRecordListItem:ctor()
	-- body
	self:setNodeEventEnabled(true)

	local recordBgModel = display.newSprite("#excMar_bgPrdExcRecord.png")
	local recordBgSizeCal = recordBgModel:getContentSize()

	local excViewLeftPanel = display.newSprite("#excMar_bgPanelLeft.png")
	local excViewLeftPanelSizeCal = excViewLeftPanel:getContentSize()

	local recordListviewMarginHoriz = 14 * nk.widthScale

	local recordItemsGapVect = 8

	local itemSize = {
		width = display.width - excViewLeftPanelSizeCal.width - recordListviewMarginHoriz * 2,
		height = recordBgSizeCal.height + recordItemsGapVect
	}

	self.super.ctor(self, itemSize.width, itemSize.height)

	local itemBgScaleSize = {
		width = itemSize.width,
		height = recordBgSizeCal.height
	}

	local itemBgStencil = {
		x = 27,
		y = 4,
		width = 678,
		height = 93
	}

	self.itemBg_ = display.newScale9Sprite("#excMar_bgPrdExcRecord.png", itemSize.width / 2, itemSize.height / 2, cc.size(itemBgScaleSize.width,
		itemBgScaleSize.height), cc.rect(itemBgStencil.x, itemBgStencil.y, itemBgStencil.width, itemBgStencil.height))
		:addTo(self)

	local prdItemImgMagrinLeft = 18 * nk.widthScale

	local labelParam = {
		fontSize = 0,
		color = display.COLOR_BLACK
	}

	local prdImgShownWidth = 80
	self.prdItemImg_ = display.newSprite()
	self.prdItemImg_:pos(prdItemImgMagrinLeft + prdImgShownWidth / 2, recordBgSizeCal.height / 2)
		:addTo(self.itemBg_)

	-- self.prdItemImg_:scale(prdImgShownWidth / self.prdItemImg_:getContentSize().width)

	self.prdItemImgLoaderId_ = nk.ImageLoader:nextLoaderId()

	local prdExcRecordInfoDescMagrinLeft = 25 * nk.widthScale
	local prdExcRecordInfoDescGapVect = 15

	labelParam.fontSize = 24
	labelParam.color = display.COLOR_WHITE
	self.prdItemName_ = display.newTTFLabel({text = "PrdName * 0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
	self.prdItemName_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
	self.prdItemName_:pos(prdItemImgMagrinLeft + prdImgShownWidth + prdExcRecordInfoDescMagrinLeft, recordBgSizeCal.height / 2 +
		prdExcRecordInfoDescGapVect / 2 + self.prdItemName_:getContentSize().height / 2)
		:addTo(self.itemBg_)

	labelParam.fontSize = 22
	labelParam.color = display.COLOR_BLUE
	self.prdExcData_ = display.newTTFLabel({text = "1970-01-01 08:00", size = labelParam.fontSize, color = labelParam.color, align =
		ui.TEXT_ALIGN_CENTER})
	self.prdExcData_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
	self.prdExcData_:pos(prdItemImgMagrinLeft + prdImgShownWidth + prdExcRecordInfoDescMagrinLeft, recordBgSizeCal.height / 2 -
		prdExcRecordInfoDescGapVect / 2 - self.prdExcData_:getContentSize().height / 2)
		:addTo(self.itemBg_)

	local copyBtnSize = {
		width = 120,
		height = 42
	}

	local copyBtnMagrinRight = 20

	labelParam.fontSize = 25
	labelParam.color = display.COLOR_WHITE
	self.oprCopyBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnYellowRigOutl.png", pressed = "#common_btnYellowRigOutl.png", disabled =
		"#common_btnGreyLitRigOut.png"}, {scale9 = true})
		:setButtonSize(copyBtnSize.width, copyBtnSize.height)
		:setButtonLabel(display.newTTFLabel({text = bm.LangUtil.getText("SCOREMARKET", "COPY"), size = labelParam.fontSize, color = labelParam.color,
			align = ui.TEXT_ALIGN_CENTER}))
		:onButtonClicked(buttontHandler(self, self.onOprCopyBtnCallBack_))
		:pos(itemBgScaleSize.width - copyBtnSize.width / 2 - copyBtnMagrinRight, itemBgScaleSize.height / 2)
		:addTo(self.itemBg_)
		:hide()

	self.oprCopyBtn_:setTouchSwallowEnabled(false)
	self.oprCopyBtn_:setButtonEnabled(false)
end

function ExcUsrPayRecordListItem:onPrdImgLoaded_(success, sprite)
	-- body
	if success then
        local tex = sprite:getTexture()
        local texSize = tex:getContentSize()

        if self and self.prdItemImg_ then
        	--todo
        	self.prdItemImg_:setTexture(tex)
		    self.prdItemImg_:setTextureRect(cc.rect(0, 0, texSize.width, texSize.height))

		    local prdImgShownWidth = 80
	        local scaleSize = prdImgShownWidth / texSize.width

		    self.prdItemImg_:scale(scaleSize)
        end
    end
end

function ExcUsrPayRecordListItem:onDataSet(changed, data)
	-- body
	if changed then
		--todo
		self.prdItemName_:setString(data.name or "PrdName")
		self.prdExcData_:setString(data.time or "1970-01-01 08:00.")

		local category = data.category or 0
		if tonumber(category) == 2 then
			--todo
			self.prdItemName_:setString((data.name or "PrdName") .. "×" .. (data.pin or 0))
	        self.oprCopyBtn_:setButtonEnabled(true)
	        self.oprCopyBtn_:setVisible(true)
		else
			self.oprCopyBtn_:setButtonEnabled(false)
			self.oprCopyBtn_:setVisible(false)
		end

		if string.len(data.imgurl or "") > 5 then
			--todo
			nk.ImageLoader:loadAndCacheImage(self.prdItemImgLoaderId_, data.imgurl, handler(self, self.onPrdImgLoaded_))
		end
	end
end

function ExcUsrPayRecordListItem:onOprCopyBtnCallBack_(evt)
	-- body
	if self.data_.pin then
        nk.Native:setClipboardText(self.data_.pin)
        nk.TopTipManager:showTopTip(bm.LangUtil.getText("SCOREMARKET", "COPY_SUCCESS"))
    end
end

function ExcUsrPayRecordListItem:onEnter()
	-- body
end

function ExcUsrPayRecordListItem:onExit()
	-- body
	nk.ImageLoader:cancelJobByLoaderId(self.prdItemImgLoaderId_)
end

function ExcUsrPayRecordListItem:onCleanup()
	-- body
end

return ExcUsrPayRecordListItem