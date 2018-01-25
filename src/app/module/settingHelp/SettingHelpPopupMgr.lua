--
-- Author: viking@boomegg.com
-- Date: 2014-08-21 17:35:59
-- Copyright: Copyright (c) 2014, BOOMEGG INTERACTIVE CO., LTD All rights reserved.
-- Description: SettingHelpPopupMgr.lua ReConstructed By Tsing7x.
--

local SettingView = import(".setting.SettingView")
local HelpView = import(".help.HelpView")

local SettingHelpPopupMgr = class("SettingHelpPopupMgr")

function SettingHelpPopupMgr:ctor(inRoomState, isHelp, helpSubTab)
    self.inRoomState_ = inRoomState

    self.isContHelp_ = isHelp
    self.helpSubTab_ = isHelp and helpSubTab or 1

    self.contView_ = nil

    if self.isContHelp_ then
        --todo
        self.contView_ = HelpView.new(self.helpSubTab_)
    else
        self.contView_ = SettingView.new(self.inRoomState_)
    end
end

function SettingHelpPopupMgr:isContHelpView()
    -- body
    return self.isContHelp_
end

function SettingHelpPopupMgr:getInRoomState()
    -- body
    return self.inRoomState_
end

function SettingHelpPopupMgr:showPanel()
    self.contView_:showPanel()

    return self
end

function SettingHelpPopupMgr:onShowed()
    -- body
    if self.contView_ and self.contView_.onShowed then
        --todo
        self.contView_:onShowed()
    end
end

return SettingHelpPopupMgr