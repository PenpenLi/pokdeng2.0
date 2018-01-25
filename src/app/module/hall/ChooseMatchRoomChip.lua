--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-03-09 19:39:19
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: ChooseMatchRoomChip.lua Reconstructed By Tsing7x.
--

local ChooseMatchRoomChip = class("ChooseMatchRoomChip", bm.ui.ListItem)

function ChooseMatchRoomChip:ctor()
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	self:setNodeEventEnabled(true)
    local roomChoseBgModel = display.newSprite("#roomChos_roomMatchBgItem.png")
    local roomChoseBgSizeCal = roomChoseBgModel:getContentSize()

    local itemGapGapBorderHoriz = 24 * nk.widthScale
    local itemHeightExtraVert = 26

    local itemSize = cc.size(roomChoseBgSizeCal.width + itemGapGapBorderHoriz * 2, roomChoseBgSizeCal.height +
        itemHeightExtraVert * 2)

	ChooseMatchRoomChip.super.ctor(self, itemSize.width, itemSize.height)

    local itemBg = roomChoseBgModel:pos(itemSize.width / 2, itemSize.height / 2)
        :addTo(self, 0)

    local prizeIconPosYCentOffSet = 85
    local prizeIconPosXCentOffSet = 5

    -- local prizeIconShownWidth = 142
    self.trophyImg_ = display.newSprite()
        :pos(roomChoseBgSizeCal.width / 2 - prizeIconPosXCentOffSet, roomChoseBgSizeCal.height / 2 +
            prizeIconPosYCentOffSet)
        :addTo(itemBg)

    self.trophyImgloaderId_ = nk.ImageLoader:nextLoaderId()
    -- Init Label Param --
    local labelParam = {
        fontSize = 0,
        color = display.COLOR_WHITE
    }

    labelParam.fontSize = 35
    labelParam.color = display.COLOR_WHITE

    local labelNamePosYCentOffSet = 24
    self.roomInfoName_ = display.newTTFLabel({text = "Room Name", size = labelParam.fontSize, color = labelParam.color,
        align = ui.TEXT_ALIGN_CENTER})
        :pos(roomChoseBgSizeCal.width / 2, roomChoseBgSizeCal.height / 2 - labelNamePosYCentOffSet)
        :addTo(itemBg)

    labelParam.fontSize = 18
    labelParam.color = display.COLOR_WHITE

    local labelOpenTimeCentMagrinTop = 26
    self.matchOpenTime_ = display.newTTFLabel({text = "(Opening Time: 00:00)", size = labelParam.fontSize, color = labelParam.color,
        align = ui.TEXT_ALIGN_CENTER})
        :pos(roomChoseBgSizeCal.width / 2, self.roomInfoName_:getPositionY() - labelOpenTimeCentMagrinTop)
        :addTo(itemBg)

    local applyBtnSize = {
        width = 108,
        height = 108
    }

    labelParam.fontSize = 30
    labelParam.color = display.COLOR_WHITE

    local applyBtnMagrinBot = 12
    self.applyMatchBtn_ = cc.ui.UIPushButton.new({normal = "#roomChos_btnMatchApply.png", pressed = "#roomChos_btnMatchApply.png",
        disabled = "#roomChos_btnMatchApply.png"}, {scale9 = false})
        :setButtonLabel(display.newTTFLabel({text = "报名", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked(buttontHandler(self, self.applyClick_))
        :pos(roomChoseBgSizeCal.width / 2, applyBtnSize.height / 2 + applyBtnMagrinBot)
        :addTo(itemBg)

    self.applyMatchBtn_:setTouchSwallowEnabled(false)
    self.applyMatchBtn_:setButtonEnabled(false)

    labelParam.fontSize = 16
    labelParam.color = display.COLOR_GREEN

    self.onLinePlayerNum_ = display.newTTFLabel({text = "0", size = labelParam.fontSize, color = labelParam.color, align = ui.TEXT_ALIGN_CENTER})
        :pos(itemSize.width / 2, itemHeightExtraVert / 2)
        :addTo(self, 1)
end

function ChooseMatchRoomChip:onTrophyImgLoadCompelet(success, sprite)
    -- body
    if success then
        --todo
        local tex = sprite:getTexture()
        local texSize = tex:getContentSize()

        if self and self.trophyImg_ then
            --todo
            self.trophyImg_:setTexture(tex)
            self.trophyImg_:setTextureRect(cc.rect(0, 0, texSize.width, texSize.height))

            local prizeIconShownWidth = 142
            self.trophyImg_:scale(prizeIconShownWidth / texSize.width)

            if self.data_ and tonumber(self.data_.open) == 0 then
                self.trophyImg_:hide()
            end
        end
    end
end

function ChooseMatchRoomChip:setPlayerCount(count)
    -- body
    if count >= 0 then
        
        self.onLinePlayerNum_:setString(bm.formatNumberWithSplit(count))

        if self.data_ and tonumber(self.data_.open) == 0 then
            self.onLinePlayerNum_:setString("0")
        end
    end
end

function ChooseMatchRoomChip:onDataSet(dataChanged, data)
    if dataChanged then
        --todo
        if data.icon1 and string.len(data.icon1) > 5 then
            --todo
            nk.ImageLoader:loadAndCacheImage(self.trophyImgloaderId_, data.icon1, handler(self, self.onTrophyImgLoadCompelet), 
                nk.ImageLoader.CACHE_TYPE_MATCH)
        end

        self.roomInfoName_:setString(data.name or "Room Type Name")

        self.matchOpenTime_:setString("(Opening Time: 00:01)")

        self.applyMatchBtn_:setButtonEnabled(true)

        self:setPlayerCount(data.playerCount or 0)
    end
end

function ChooseMatchRoomChip:applyClick_()
    self:dispatchEvent({name="ITEM_EVENT", data = self.data_})
end

function ChooseMatchRoomChip:onEnter()
    -- body
end

function ChooseMatchRoomChip:onExit()
    -- body
    if self.trophyImgloaderId_ then
        nk.ImageLoader:cancelJobByLoaderId(self.trophyImgloaderId_)
        self.trophyImgloaderId_ = nil
    end
end

function ChooseMatchRoomChip:onCleanup()

end

return ChooseMatchRoomChip