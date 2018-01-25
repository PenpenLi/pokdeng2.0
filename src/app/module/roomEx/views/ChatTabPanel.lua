--
-- Author: tony
-- Date: 2014-08-06 11:56:22
--
local ChatTabPanel = class("ChatTabPanel", function() return display.newNode() end)

ChatTabPanel.WIDTH = 400
ChatTabPanel.HEIGHT = 637
ChatTabPanel.PAGE_WIDTH = ChatTabPanel.WIDTH - 24
ChatTabPanel.PAGE_HEIGHT = ChatTabPanel.HEIGHT - 80

function ChatTabPanel:ctor(tabTitleLeft, tabTitleRight)
    self.background_ = display.newScale9Sprite("#room_card_review_bg.png", 0, 0, CCSize(ChatTabPanel.WIDTH, ChatTabPanel.HEIGHT))
    self.background_:addTo(self)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)

    self.container_ = display.newNode():pos(0, -30):addTo(self)
    self:pos(- ChatTabPanel.WIDTH * 0.5, ChatTabPanel.HEIGHT * 0.5 )



    -- self.mainTabBar_ = nk.ui.CommonPopupTabBar.new(
    --     {
    --         popupWidth = ChatTabPanel.WIDTH + 60 , 
    --         iconOffsetX = 10, 
    --         btnText = bm.LangUtil.getText("ROOM", "CHAT_MAIN_TAB_TEXT")
    --     }
    -- )
    --     :pos(0, ChatTabPanel.HEIGHT * 0.5 - 32)
    --     :addTo(self)
    -- self.mainTabBar_:onTabChange(handler(self, self.onTabChanged_))


    local BTN_WIDTH = 190
    local BTN_HEIGHT = 58

    self.fastChatPos_ = cc.p(-BTN_WIDTH/2,ChatTabPanel.HEIGHT/2-BTN_HEIGHT/2)
    self.fastChatBtn_ = cc.ui.UIPushButton.new("#room_exp_tab_up.png",{scale9 = true})
        :setButtonLabel("normal", ui.newTTFLabel({text = bm.LangUtil.getText("ROOM", "CHAT_MAIN_TAB_TEXT")[1], color = styles.FONT_COLOR.LIGHT_TEXT, size = 20, align = ui.TEXT_ALIGN_CENTER}))
        :addTo(self)
        :setButtonSize(BTN_WIDTH, BTN_HEIGHT)
        :pos(-BTN_WIDTH/2,ChatTabPanel.HEIGHT/2-BTN_HEIGHT/2)
        :onButtonClicked(handler(self, self.onFastClick_))

    self.historyPos_ = cc.p(BTN_WIDTH/2,ChatTabPanel.HEIGHT/2-BTN_HEIGHT/2)
    self.historyBtn_ = cc.ui.UIPushButton.new("#room_exp_tab_up.png",{scale9 = true})
        :addTo(self)
        :setButtonSize(BTN_WIDTH, BTN_HEIGHT)
        :pos(BTN_WIDTH/2,ChatTabPanel.HEIGHT/2-BTN_HEIGHT/2)
        :setButtonLabel("normal", ui.newTTFLabel({text = bm.LangUtil.getText("ROOM", "CHAT_MAIN_TAB_TEXT")[2], color = styles.FONT_COLOR.LIGHT_TEXT, size = 20, align = ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked(handler(self, self.onHistoryClick_))

    --cc.rect(60,36,4,4)
    self.row_ = display.newScale9Sprite("#room_exp_tab_down.png",0,0,CCSize(BTN_WIDTH,66)):addTo(self)
    self.row_:pos(-BTN_WIDTH/2,ChatTabPanel.HEIGHT/2-BTN_HEIGHT/2-5)
    self.row_text_ = ui.newTTFLabel({text = bm.LangUtil.getText("ROOM", "CHAT_MAIN_TAB_TEXT")[1], color = styles.FONT_COLOR.LIGHT_TEXT, size = 21, align = ui.TEXT_ALIGN_CENTER})
    :addTo(self.row_)
    :pos(BTN_WIDTH/2,66/2)
    

end

function ChatTabPanel:onFastClick_()
    transition.moveTo(self.row_, {time=0.2, x=self.fastChatPos_.x, y=self.fastChatPos_.y-5,
         onComplete = function()
            self:onTabChanged_(1)
            self.row_text_:setString(bm.LangUtil.getText("ROOM", "CHAT_MAIN_TAB_TEXT")[1])
        end,
     easing="OUT"})
end
function ChatTabPanel:onHistoryClick_()
    transition.moveTo(self.row_, {time=0.2, x=self.historyPos_.x, y=self.historyPos_.y-5,
         onComplete = function()
            self:onTabChanged_(2)
            self.row_text_:setString(bm.LangUtil.getText("ROOM", "CHAT_MAIN_TAB_TEXT")[2])
        end,
     easing="OUT"})
end
function ChatTabPanel:showPanel()
    nk.PopupManager:addPopup(self, true, false, true, false)
end

function ChatTabPanel:hidePanel()
    nk.PopupManager:removePopup(self)
end

function ChatTabPanel:onRemovePopup(removeFunc)
    self:stopAllActions()
    transition.moveTo(self, {time=0.3, x=-ChatTabPanel.WIDTH * 0.5, easing="OUT", onComplete=function() 
        removeFunc()
    end})
end

function ChatTabPanel:onShowPopup()
    self:stopAllActions()
    transition.moveTo(self, {time=0.3, x=ChatTabPanel.WIDTH * 0.5 + 8, easing="OUT", onComplete=function()
        if self.onShow then
            self:onShow()
        end
        -- local cbox = self:getCascadeBoundingBox()
        -- cbox:setRect(cbox.x, cbox.y, ChatTabPanel.WIDTH, ChatTabPanel.HEIGHT)
        -- self:setCascadeBoundingBox(cbox)
    end})
end

function ChatTabPanel:setPage(index, page)
    if index == 1 then
        if self.page1_ then
            self.page1_:removeFromParent()
        end
        self.page1_ = page:pos(0, -30):addTo(self):hide()
    elseif index == 2 then
        if self.page2_ then
            self.page2_:removeFromParent()
        end
        self.page2_ = page:pos(0, -30):addTo(self):hide()
    end
    self:selectPage(self.selectedIndex_)
end

function ChatTabPanel:selectPage(index)
    if self.page1_ and self.page2_ then
        if self.selectedIndex_ ~= index then
            if index == 2 then
                self.page1_:hide()
                self.page2_:show()
                self.selectedIndex_ = 2
            elseif index == 1 then
                self.page1_:show()
                self.page2_:hide()
                self.selectedIndex_ = 1
            end
        end
    elseif self.page1_ then
        self.page1_:show()
        self.selectedIndex_ = 1
    elseif self.page2_ then
        self.page2_:show()
        self.selectedIndex_ = 2
    end
end

function ChatTabPanel:onTabChanged_(index)
    print("selecte ", index)
    self:selectPage(index)
end

return ChatTabPanel