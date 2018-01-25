--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-06-30 14:45:36
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: GameCardRecListItem.lua Created && Reconstructed By Tsing7x.
--
local HandPoker = import("app.module.room.model.HandPoker")

local ITEMSIZE = nil

local GameCardRecListItem = class("GameCardRecListItem", bm.ui.ListItem)

function GameCardRecListItem:ctor()
	self:setNodeEventEnabled(true)

    local gameCardRecListItemSize = {
        width = 302,
        height = 120
    }

    ITEMSIZE = cc.size(gameCardRecListItemSize.width, gameCardRecListItemSize.height)

	self.super.ctor(self, ITEMSIZE.width, ITEMSIZE.height)

    local itemBgSizeHFix = 1.5

    self.itemBg_ = display.newScale9Sprite("#crdTyGmRc_dentRecItem.png", ITEMSIZE.width / 2, ITEMSIZE.height / 2, cc.size(ITEMSIZE.width, ITEMSIZE.height -
        itemBgSizeHFix * 2))
        :addTo(self)
end

function GameCardRecListItem:onDataSet(dataChanged, data)

    if dataChanged then
        --todo
        if self.index_ % 2 == 0 then
            --todo
            self.itemBg_:hide()
        else
            self.itemBg_:show()
        end

        self:releaseObjs()

        local result = data[3]
        if not result then
            --todo
            result = 0
        end

        local isDealer = data[4]
        local selfHandPoker = HandPoker.new()
        selfHandPoker:setCards(data[1])

        local dealerHandPoker = HandPoker.new()
        dealerHandPoker:setCards(data[2])

        local pokerCardMagrinBgLeft = 20
        local pokerCardWidth = 26
        local pokerCardMagrinBgCnt = 0

        self.pokerCardList = {}
        self.cardIndex_ = 0

        for i = 1, #data[1] do
            self.pokerCardList[i] = nk.ui.PokerCard.new()
                :setCard(data[1][i])
                :showFront()

            self.pokerCardList[i]:pos(pokerCardMagrinBgLeft + pokerCardWidth / 2 * i, ITEMSIZE.height / 2 + pokerCardMagrinBgCnt)
                :addTo(self)
                :scale(.6)

            self.cardIndex_ = i
        end

        local pokdengTagMagrinBgCnt = 30

        if selfHandPoker:isPokdeng() then
            local point = selfHandPoker:getPoint()

            local pokdengIconMagrinLeft = 50
            self.selfPokdengIcon_ = display.newSprite("#pokdeng" .. point .. ".png")
                :pos(pokdengIconMagrinLeft + pokerCardWidth / 2 * self.cardIndex_, ITEMSIZE.height / 2 + pokdengTagMagrinBgCnt)
                :addTo(self)
                :scale(.7)
        end

        local XTimeTagMagrinBgCnt = 40
        local XTimeBgMagrinLeft = 60
        local XTime = selfHandPoker:getX() 
        if XTime > 1 then
            self.Xbg_ = display.newSprite("#X_bg.png")
                :pos(XTimeBgMagrinLeft + pokerCardWidth / 2 * self.cardIndex_, ITEMSIZE.height / 2 + XTimeTagMagrinBgCnt)
                :addTo(self)
                :scale(.7)

            self.XIcon_ = display.newSprite("#X" .. XTime .. ".png")
                :pos(XTimeBgMagrinLeft + pokerCardWidth / 2 * self.cardIndex_, ITEMSIZE.height / 2 + XTimeTagMagrinBgCnt)
                :addTo(self)
                :scale(.7)
        end

        self.dealerPokerList = {}
        self.cardIndex_ = 0

        for i = 1, #data[2] do
            self.dealerPokerList[i] = nk.ui.PokerCard.new()
                :setCard(data[2][i])
                :showFront()

            self.dealerPokerList[i]:pos(pokerCardMagrinBgLeft + ITEMSIZE.width / 2 + pokerCardWidth / 2 * i, ITEMSIZE.height / 2 + pokerCardMagrinBgCnt)
                :addTo(self)
                :scale(.6)

            self.cardIndex_ = i
        end

        if dealerHandPoker:isPokdeng() then
            local point = dealerHandPoker:getPoint()

            local pokdengIconMagrinLeft = 50
            self.dealerPokdengIcon_ = display.newSprite("#pokdeng" .. point .. ".png")
                :pos(pokdengIconMagrinLeft + ITEMSIZE.width / 2 + pokerCardWidth / 2 * self.cardIndex_, ITEMSIZE.height / 2 + pokdengTagMagrinBgCnt)
                :addTo(self)
                :scale(.7)
        end
        
        local XTime = dealerHandPoker:getX() 
        if XTime > 1 then
            self.dealerXbg_ = display.newSprite("#X_bg.png")
                :pos(XTimeBgMagrinLeft + ITEMSIZE.width / 2 + pokerCardWidth / 2 * self.cardIndex_, ITEMSIZE.height / 2 + XTimeTagMagrinBgCnt)
                :addTo(self)
                :scale(.7)

            self.dealerXIcon_ = display.newSprite("#X" .. XTime .. ".png")
                :pos(XTimeBgMagrinLeft + ITEMSIZE.width / 2 + pokerCardWidth / 2 * self.cardIndex_, ITEMSIZE.height / 2 + XTimeTagMagrinBgCnt)
                :addTo(self)
                :scale(.7)
        end

        local stateTagMagrinLeft = 25
        local stateTagMagrinBgCnt = 10
        if isDealer then

            if result > 0 then
                self.stateTagBg_ = display.newSprite("#crdTyGmRc_decTagWin.png")
                    :pos(stateTagMagrinLeft, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                    :addTo(self)

                self.stateTagIcon_ = display.newSprite("#crdTyGmRc_dscTagWin.png")
                    :pos(stateTagMagrinLeft, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                    :addTo(self)

                self.stateDealerTagBg_ = display.newSprite("#crdTyGmRc_decTagWin.png")
                    :pos(stateTagMagrinLeft + ITEMSIZE.width / 2, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                    :addTo(self)

                self.stateDealerTagIcon_ = display.newSprite("#crdTyGmRc_dscTagWin.png")
                    :pos(stateTagMagrinLeft + ITEMSIZE.width / 2, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                    :addTo(self)
            elseif result == 0 then
                self.stateTagBg_ = display.newSprite("#crdTyGmRc_decTagDogFall.png")
                    :pos(stateTagMagrinLeft, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                    :addTo(self)

                self.stateTagIcon_ = display.newSprite("#crdTyGmRc_dscTagDogFall.png")
                    :pos(stateTagMagrinLeft, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                    :addTo(self)

                self.stateDealerTagBg_ = display.newSprite("#crdTyGmRc_decTagDogFall.png")
                    :pos(stateTagMagrinLeft + ITEMSIZE.width / 2, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                    :addTo(self)

                self.stateDealerTagIcon_ = display.newSprite("#crdTyGmRc_dscTagDogFall.png")
                    :pos(stateTagMagrinLeft + ITEMSIZE.width / 2, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                    :addTo(self)
            else
                self.stateTagBg_ = display.newSprite("#crdTyGmRc_decTagLose.png")
                    :pos(stateTagMagrinLeft, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                    :addTo(self)

                self.stateTagIcon_ = display.newSprite("#crdTyGmRc_dscTagLose.png")
                    :pos(stateTagMagrinLeft, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                    :addTo(self)

                self.stateDealerTagBg_ = display.newSprite("#crdTyGmRc_decTagLose.png")
                    :pos(stateTagMagrinLeft + ITEMSIZE.width / 2, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                    :addTo(self)

                self.stateDealerTagIcon_ = display.newSprite("#crdTyGmRc_dscTagLose.png")
                    :pos(stateTagMagrinLeft + ITEMSIZE.width / 2, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                    :addTo(self)
            end

            return 
        end

        if result > 0 then
            self.stateTagBg_ = display.newSprite("#crdTyGmRc_decTagWin.png")
                :pos(stateTagMagrinLeft, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                :addTo(self)

            self.stateTagIcon_ = display.newSprite("#crdTyGmRc_dscTagWin.png")
                :pos(stateTagMagrinLeft, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                :addTo(self)

            self.stateDealerTagBg_ = display.newSprite("#crdTyGmRc_decTagLose.png")
                :pos(stateTagMagrinLeft + ITEMSIZE.width / 2, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                :addTo(self)

            self.stateDealerTagIcon_ = display.newSprite("#crdTyGmRc_dscTagLose.png")
                :pos(stateTagMagrinLeft + ITEMSIZE.width / 2, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                :addTo(self)
        elseif result == 0 then
            self.stateTagBg_ = display.newSprite("#crdTyGmRc_decTagDogFall.png")
                :pos(stateTagMagrinLeft, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                :addTo(self)

            self.stateTagIcon_ = display.newSprite("#crdTyGmRc_dscTagDogFall.png")
                :pos(stateTagMagrinLeft, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                :addTo(self)

            self.stateDealerTagBg_ = display.newSprite("#crdTyGmRc_decTagDogFall.png")
                :pos(stateTagMagrinLeft + ITEMSIZE.width / 2, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                :addTo(self)

            self.stateDealerTagIcon_ = display.newSprite("#crdTyGmRc_dscTagDogFall.png")
                :pos(stateTagMagrinLeft + ITEMSIZE.width / 2, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                :addTo(self)
        else
            self.stateTagBg_ = display.newSprite("#crdTyGmRc_decTagLose.png")
                :pos(stateTagMagrinLeft, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                :addTo(self)

            self.stateTagIcon_ = display.newSprite("#crdTyGmRc_dscTagLose.png")
                :pos(stateTagMagrinLeft, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                :addTo(self)

            self.stateDealerTagBg_ = display.newSprite("#crdTyGmRc_decTagWin.png")
                :pos(stateTagMagrinLeft + ITEMSIZE.width / 2, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                :addTo(self)

            self.stateDealerTagIcon_ = display.newSprite("#crdTyGmRc_dscTagWin.png")
                :pos(stateTagMagrinLeft + ITEMSIZE.width / 2, ITEMSIZE.height / 2 - stateTagMagrinBgCnt)
                :addTo(self)
        end
    end

end

function GameCardRecListItem:releaseObjs()
    if self.dealerPokerList then
        for i = 1, #self.dealerPokerList do
            self.dealerPokerList[i]:removeFromParent()
            self.dealerPokerList[i] = nil
        end
    end

    if self.pokerCardList then
        for i = 1, #self.pokerCardList do
            self.pokerCardList[i]:removeFromParent()
            self.pokerCardList[i] = nil
        end
    end

    if self.stateTagBg_ then
        self.stateTagBg_:removeFromParent()
        self.stateTagIcon_:removeFromParent()
        self.stateDealerTagBg_:removeFromParent()
        self.stateDealerTagIcon_:removeFromParent()

        self.stateTagBg_ = nil
    end

    if self.dealerPokdengIcon_ then
        self.dealerPokdengIcon_:removeFromParent()
        self.dealerPokdengIcon_ = nil
    end

    if self.selfPokdengIcon_ then
        self.selfPokdengIcon_:removeFromParent()
        self.selfPokdengIcon_ = nil
    end

    if self.XIcon_ then
        self.Xbg_:removeFromParent()
        self.XIcon_:removeFromParent()

        self.Xbg_ = nil
        self.XIcon_ = nil
    end

    if self.dealerXIcon_ then
        self.dealerXIcon_:removeFromParent()
        self.dealerXbg_:removeFromParent()

        self.dealerXIcon_ = nil
        self.dealerXbg_ = nil
    end
end

function GameCardRecListItem:onEnter()
    -- body
end

function GameCardRecListItem:onExit()
    -- body
end

function GameCardRecListItem:onCleanup()
    self:releaseObjs()
end

return GameCardRecListItem