local CornuFriendMessageBoardItem = class("CornuFriendMessageBoardItem", bm.ui.ListItem)

local WIDTH = 240
local HEIGHT = 60
function CornuFriendMessageBoardItem:ctor()
    self:setNodeEventEnabled(true)
    CornuFriendMessageBoardItem.super.ctor(self, WIDTH, HEIGHT)

     display.newScale9Sprite("#cor_words_bg.png", 0, 0, cc.size(WIDTH,HEIGHT))
    -- :addTo(self)
    -- :pos(WIDTH/2,HEIGHT/2)
    --local test  = bm.LangUtil.getText("LOGIN","FEED_BACK_HINT")
    self.message_ = display.newTTFLabel({text = "", color = cc.c3b(0x5A, 0x7C, 0xAE), size = 20,dimensions = cc.size(WIDTH-10, HEIGHT), align = ui.TEXT_ALIGN_LEFT})
    :addTo(self)
    :align(display.CENTER_LEFT)
    :pos(10,HEIGHT/2)

    display.newScale9Sprite("#cor_mini_line.png", 0, 0, cc.size(WIDTH,2))
    :addTo(self)
    :pos(WIDTH/2,0)
    
end
function CornuFriendMessageBoardItem:onGoFriend()

end

function CornuFriendMessageBoardItem:onDataSet(dataChanged, data)
    --if data then
        local name = nk.Native:getFixedWidthText("", 20, (data.fnickname or ""), 100)
        local str = "["..name.."]: "..data.msg 
        self.message_:setString(""..str)
       -- self.message_:setString(""..data)
    --end   
end
function CornuFriendMessageBoardItem:onCleanup()
	
end

return CornuFriendMessageBoardItem