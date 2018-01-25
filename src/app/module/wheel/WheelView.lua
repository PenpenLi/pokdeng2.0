--
-- Author: viking@boomegg.com
-- Date: 2014-10-29 12:02:13
-- Copyright: Copyright (c) 2014, BOOMEGG INTERACTIVE CO., LTD All rights reserved.
-- Description: WheelView.lua Reconstructed By Tsing7x.
--

local WheelSliceView = import(".WheelSliceView")

local WheelView = class("WheelView", function()
    return display.newNode()
end)

function WheelView:ctor()
    self:setNodeEventEnabled(true)

    self.wheel_ = display.newNode()
        :addTo(self)

    self.views = {}
    local view_ = nil
    local degree = 45

    for i = 1, 8 do
        if i % 2 ~= 0 then
            view_ = WheelSliceView.new(WheelSliceView.BLUE)
        else
            view_ = WheelSliceView.new(WheelSliceView.GREEN)
        end

        view_:setRotation(degree * (i - 1))
        view_:addTo(self.wheel_)
        table.insert(self.views, view_)
    end
end

function WheelView:startRotation(callback)
    self.animOverCallback_ = callback
    if self.soundId then
          audio.stopSound(self.soundId)
    end
    self.soundId = nk.SoundManager:playSound(nk.SoundManager.WHEEL_LOOP, false)
    self:rotationByAccelerate()
end

function WheelView:rotationByAccelerate()
    self.wheel_:stopAllActions()

    local animTime = 2.5
    local sequence = transition.sequence({cc.EaseIn:create(cc.RotateBy:create(1, 360), animTime), cc.CallFunc:create(function()
            self:rotationByDefault()
        end)
    })

    self.wheel_:runAction(sequence)
end

function WheelView:rotationByDefault()
    self.wheel_:setRotation(self.destDegree_) -- Allways Set Degree From Org Position

    local rotateTime = 0.5
    local sequence = transition.sequence({cc.RotateBy:create(rotateTime, 360), cc.CallFunc:create(function()
            self:rotationByDecelerate()
        end)
    })

    self.wheel_:runAction(sequence)
end

function WheelView:rotationByDecelerate()
    local rotateTime = 3
    local easeOutTime = 2.5

    local sequence = transition.sequence({cc.EaseOut:create(cc.RotateBy:create(rotateTime, 360), easeOutTime), cc.CallFunc:create(function()
            if self.soundId then
                  audio.stopSound(self.soundId)
            end

            if self.animOverCallback_ then
                self.animOverCallback_()
            end
        end)
    })

    self.wheel_:runAction(sequence)
end

function WheelView:setItemData(items)
    self.items_ = items

    -- dump(items, "WheelView:setItemData.items :===============")
    for i, v in ipairs(items) do
        local view_ = self.views[i]

        view_:setViewId(i)
        view_:setDescText(v.desc)
        view_:setRewImageKey(v.url)
        v.index = i - 1
    end
end

function WheelView:setDestDegreeById(id)
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    local item = self:findItemById(id)
    local index = item.index

    local randDegree = 0
    local offsetDegree = 5
    local randomDegreeRadix = 20

    local minMaxRandOffset = 3
    local degreePerFanVal = 45

    if index == 0 then
        randDegree = math.random(- randomDegreeRadix + offsetDegree, randomDegreeRadix - offsetDegree)
    else
        local min = randomDegreeRadix + minMaxRandOffset + degreePerFanVal * (index - 1) + offsetDegree
        local max = min - minMaxRandOffset + degreePerFanVal - offsetDegree * 2
        randDegree = math.random(min, max)
    end

    -- dump("WheelView:setDestDegreeById.Id :" .. id .. " randDegree :" .. randDegree)

    self.destDegree_ = 360 - randDegree
end

function WheelView:findItemById(id)
    for i, v in pairs(self.items_) do
        -- v.id Start From Num 0 --
        if id == v.id + 1 then
            return v
        end
    end

    return nil
end

function WheelView:findWheelViewById(id)
    -- body
    for k, v in pairs(self.views) do
        local viewId = v:getViewId()

        if viewId == id then
            --todo
            return v
        end
    end

    return nil
end

function WheelView:onEnter()
    -- body
end

function WheelView:onExit()
    self.wheel_:stopAllActions()
    if self.soundId then
          audio.stopSound(self.soundId)
    end
end

function WheelView:onCleanup()
    -- body
end

return WheelView
