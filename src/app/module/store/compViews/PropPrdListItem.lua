--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-06-14 16:12:11
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: PropPrdListItem.lua Created By Tsing7x.
--

local PropPrdListItem = class("PropPrdListItem", bm.ui.ListItem)

function PropPrdListItem:ctor(data)
	-- body
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	self:setNodeEventEnabled(true)

	local itemBgPanelModel = display.newSprite("#propGift_bgPropItem.png")
	local itemBgSizeCal = itemBgPanelModel:getContentSize()

	local itemSizeWBorFix = 3
	local itemBgMagrinEachVect = 4

	local propPrdItemSize = {
		width = itemBgSizeCal.width + itemSizeWBorFix * 2,
		height = itemBgSizeCal.height + itemBgMagrinEachVect
	}

	self.super.ctor(self, propPrdItemSize.width, propPrdItemSize.height)

	self.itemBg_ = display.newSprite("#propGift_bgPropItem.png")
		:pos(propPrdItemSize.width / 2, propPrdItemSize.height / 2)
		:addTo(self)

	local propPrdFrameImgCntMagrinLeft = 65

	local propPrdImg = display.newSprite("#propGift_icPrdPropPack.png")
		:pos(propPrdFrameImgCntMagrinLeft, itemBgSizeCal.height / 2)
		:addTo(self.itemBg_)

	local labelParam = {
		fontSize = 0,
		color = display.COLOR_BLACK	
	}

	local propInfoDescLblPaddingLeft = 120

	local propNameLblMagrinTop = 12

	labelParam.fontSize = 22
	labelParam.color = display.COLOR_WHITE
	self.propName_ = display.newTTFLabel({text = "Prop *0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
	self.propName_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
	self.propName_:pos(propInfoDescLblPaddingLeft, itemBgSizeCal.height - propNameLblMagrinTop - self.propName_:getContentSize().height / 2)
		:addTo(self.itemBg_)

	local propContDescLblMagrinTop = 4
	local propContDescLblShownWidth = 245

	labelParam.fontSize = 20
	labelParam.color = display.COLOR_WHITE
	local propDesc = display.newTTFLabel({text = bm.LangUtil.getText("STORE", "PROPITEM_DESC"), size = labelParam.fontSize, color = labelParam.color, dimensions = cc.size(propContDescLblShownWidth,
		0), align = ui.TEXT_ALIGN_LEFT})
	propDesc:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
	propDesc:pos(propInfoDescLblPaddingLeft, self.propName_:getPositionY() - self.propName_:getContentSize().height / 2 - propContDescLblMagrinTop -
		propDesc:getContentSize().height / 2)
		:addTo(self.itemBg_)

	local priceIcMagrinRight = 208
	local prdPropIc = display.newSprite("#propGift_icPrdPriceChip.png")
	prdPropIc:pos(itemBgSizeCal.width - priceIcMagrinRight - prdPropIc:getContentSize().width / 2, itemBgSizeCal.height / 2)
		:addTo(self.itemBg_)

	local priceLblMagrinLeft = 6

	labelParam.fontSize = 20
	labelParam.color = styles.FONT_COLOR.GOLDEN_TEXT
	self.propPrice_ = display.newTTFLabel({text = "0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
	self.propPrice_:setAnchorPoint(display.ANCHOR_POINTS[display.CENTER_LEFT])
	self.propPrice_:pos(prdPropIc:getPositionX() + prdPropIc:getContentSize().width / 2 + priceLblMagrinLeft, itemBgSizeCal.height / 2)
		:addTo(self.itemBg_)

	local propBuyBtnSize = {
		width = 110,
		height = 54
	}

	local propBuyBtnMagrinRight = 12

	labelParam.fontSize = 28
	labelParam.color = display.COLOR_WHITE
	self.goBuyPropBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnGreenRigOutl.png", pressed = "#common_btnGreenRigOutl.png", disabled = "#common_btnGreyLitRigOut.png"},
		{scale9 = true})
		:setButtonSize(propBuyBtnSize.width, propBuyBtnSize.height)
		:setButtonLabel(display.newTTFLabel({text = "购买", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
		:onButtonClicked(buttontHandler(self, self.onPropBuyBtnCallBack_))
		:pos(itemBgSizeCal.width - propBuyBtnMagrinRight - propBuyBtnSize.width / 2, itemBgSizeCal.height / 2)
		:addTo(self.itemBg_)
end

function PropPrdListItem:onDataSet(dataChanged, data)
	-- body
	if dataChanged then
		--todo
		self.propName_:setString(bm.LangUtil.getText("STORE", "PROP_PACK") .. (data.num or 0))

		self.propPrice_:setString(bm.formatNumberWithSplit(data.money or 0))
	end
end

function PropPrdListItem:onPropBuyBtnCallBack_(evt)
	-- body
	self:dispatchEvent({name="ITEM_EVENT", data = self.data_})
end

function PropPrdListItem:onEnter()
	-- body
end

function PropPrdListItem:onExit()
	-- body
end

function PropPrdListItem:onCleanup()
	-- body
end

return PropPrdListItem