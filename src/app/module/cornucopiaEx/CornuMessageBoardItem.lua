local CornuMessageBoardItem = class("CornuMessageBoardItem", bm.ui.ListItem)

local WIDTH = 240
local HEIGHT = 90
function CornuMessageBoardItem:ctor()
    self:setNodeEventEnabled(true)
    
    CornuMessageBoardItem.super.ctor(self, WIDTH, HEIGHT)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    -- display.newScale9Sprite("#cor_words_bg.png", 0, 0, cc.size(WIDTH,HEIGHT))
    -- :addTo(self)
    -- :pos(WIDTH/2,HEIGHT/2)
    --local test  = bm.LangUtil.getText("LOGIN","FEED_BACK_HINT")
    self.message_ = display.newTTFLabel({text = "", color = cc.c3b(0x5A, 0x7C, 0xAE), size = 20,dimensions = cc.size(WIDTH-10, HEIGHT), align = ui.TEXT_ALIGN_LEFT})
    :addTo(self)
    :align(display.CENTER_LEFT)
    :pos(10,HEIGHT/2+10)

    display.newScale9Sprite("#cor_mini_line.png", 0, 0, cc.size(WIDTH,2))
    :addTo(self)
    :pos(WIDTH/2,0)
    
end
function CornuMessageBoardItem:onGoFriend()
    self:dispatchEvent({name="ITEM_EVENT", data = self.data_})
end

function CornuMessageBoardItem:onDataSet(changedata,data)
    self.data_ = data
    if data then
        local str = "[ "..data.fnickname.."]: "..data.msg 
        self.message_:setString(""..str)
    end   
end
function CornuMessageBoardItem:onCleanup()
	
end

return CornuMessageBoardItem