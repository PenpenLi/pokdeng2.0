--
-- Author: XT
-- Date: 2015-09-21 20:11:59
-- http://blog.csdn.net/a102111/article/details/43236947
-- Description: ComboboxView.lua ReConstructed By Tsing7x.
--

local ComboboxView = class("ComboboxView", function()
	return display.newNode()
end)

function ComboboxView:ctor(params, popListCallBack, itemClkCallBack)
	self.lblSize_ = params.lblSize or 22
	self.borderSize_ = params.borderSize or cc.size(160, 42)
	self.lblcolor_ = params.lblcolor or display.COLOR_BLACK

	self.barRes_ = params.barRes or "#usrAddr_arrowDown.png"
	self.borderRes_ = params.borderRes or "#common_bgInputLayer.png"
	self.isNotScaleBar_ = params.barNoScale or false
	self.listBgRes_ = params.listBgRes or "#userAddr_denListBg.png"

	self.itemCls_ = params.itemCls
	self.listWidth_ = params.listWidth
	self.listHeight_ = params.listHeight
	self.listOffX_ = params.listOffX or 0
	self.listOffY_ = params.listOffY or 0

	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

	-- Add Crux Event Callback --
	self.popListCallBack_ = popListCallBack 
	self.itemClkCallBack_ = itemClkCallBack

	self.borderBg_ = display.newScale9Sprite(self.borderRes_, 0, 0, self.borderSize_)
		:addTo(self, 1)

	self.icon_ = nil
	local arrowBarPosX = 0

	local arrowIconMagrinRight = 10
	local defaultArrowBarScaleSizeBorLen = 42

	if self.isNotScaleBar_ then
	 	--todo
	 	self.icon_ = display.newSprite(self.barRes_)
	 	
	 	arrowBarPosX = self.borderSize_.width / 2 - self.icon_:getContentSize().width / 2 - arrowIconMagrinRight
	 	self.icon_:pos(arrowBarPosX, 0)
	 		:addTo(self, 2)
	else
		arrowBarPosX = self.borderSize_.width / 2 - defaultArrowBarScaleSizeBorLen / 2 - arrowIconMagrinRight
		self.icon_ = display.newScale9Sprite(self.barRes_, arrowBarPosX, 0, cc.size(defaultArrowBarScaleSizeBorLen, defaultArrowBarScaleSizeBorLen))
			:addTo(self, 2)
	end

	self.lbl_ = display.newTTFLabel({text = "name",	color = self.lblcolor_,	size = self.lblSize_, align = ui.TEXT_ALIGN_LEFT, dimensions =
		cc.size(self.borderSize_.width - self.borderSize_.height, 0)})
		:addTo(self, 3)

	self.btn_ = cc.ui.UIPushButton.new({normal = "#common_modTransparent.png", pressed = "#common_modTransparent.png", disabled =
		"#common_modTransparent.png"}, {scale9=true})
		:setButtonSize(self.borderSize_.width, self.borderSize_.height)
		:onButtonPressed(function(evt)
			self.icon_:pos(arrowBarPosX + 1, - 1)
		end)
		:onButtonRelease(function(evt)
			self.icon_:pos(arrowBarPosX, 0)
			if evt.touchInTarget then
				nk.SoundManager:playSound(nk.SoundManager.CLICK_BUTTON)
				self:onBtnClicked_()
			end
		end)
		:addTo(self, 5)

	self:addDropList_()
end


function ComboboxView:addDropList_()
	if not self.list_ then
		local listBgSizeAdjListCont = {
			widthFix = 5,
			heightFix = 5
		}

		self.listBg_ = display.newScale9Sprite(self.listBgRes_, self.listOffX_, - self.listHeight_ / 2 + self.listOffY_, cc.size(self.listWidth_ +
			listBgSizeAdjListCont.widthFix, self.listHeight_ + listBgSizeAdjListCont.heightFix))
			:addTo(self, 91)

        self.list_ = bm.ui.ListView.new({viewRect = cc.rect(- self.listWidth_ / 2, - self.listHeight_ / 2, self.listWidth_, self.listHeight_),
			direction=bm.ui.ListView.DIRECTION_VERTICAL}, self.itemCls_)
        :pos(self.listOffX_, - self.listHeight_ / 2 + self.listOffY_)
        :addTo(self, 99)

        self.listBg_:hide()
        self.list_:hide()
	    self:onShowed()

	    self.list_:addEventListener("ITEM_EVENT", handler(self, self.onItemEvent_))
	end
end

function ComboboxView:onBtnClicked_()
	if self.popListCallBack_ then
		--todo
		self.popListCallBack_()
	end
	
	if self.isNewData_ then
		self.list_:setData(self.data_, true)
		self.isNewData_ = nil
	end

	if self.list_:isVisible() then
		self.listBg_:hide()
		self:hideList()
	else
		bm.EventCenter:dispatchEvent(nk.eventNames.DISENABLED_EDITBOX_TOUCH)
		self.listBg_:show()
		self.list_:show()

		self:addModule()
	end
end

function ComboboxView:hideList()
	if self.list_ then
		self.listBg_:hide()
		self.list_:hide()
		if self.modal_ then
	        self.modal_:removeFromParent()
	        self.modal_ = nil
	    end

	    bm.EventCenter:dispatchEvent(nk.eventNames.ENABLED_EDITBOX_TOUCH)
	end
end

function ComboboxView:setData(value, defaultStr)
	local data = {}
    for i = 1, #value do
        data[i] = {}
        data[i].id = i
        data[i].selected = false
        data[i].title = value[i]
    end

	self.data_ = data
	self.isNewData_ = true
	self.lbl_:setString(defaultStr or "")

	return self
end

function ComboboxView:setText(value)
	self.lbl_:setString(value or "")
end

function ComboboxView:getText()
	return self.lbl_:getString()
end

function ComboboxView:onShowed()
	if self.list_ then
		self.list_:setScrollContentTouchRect()
        self.list_:update()
    end
end

function ComboboxView:onItemEvent_(evt)
    if evt.type == "DROPDOWN_LIST_SELECT" then
        if self.itemClkCallBack_ then
            self.itemClkCallBack_(evt.data)
        end

        self.lbl_:setString(evt.data.title or "")
    end
    self:hideList()
end

function ComboboxView:addModule()
    if not self.modal_ then
        self.modal_ = display.newScale9Sprite("#common_modRiAnGrey.png", 0, 0, cc.size(display.width * 1.5, display.height * 1.5))
            :pos(0, 0)
            :addTo(self, - 1)
        self.modal_:setTouchEnabled(true)
        self.modal_:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.hideList))
    end    
end

return ComboboxView;