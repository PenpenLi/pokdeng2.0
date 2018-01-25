-- 
-- Author: LeoLuo
-- Date: 2015-06-12 16:30:43
-- Description: OnOff.lua ReConstructed By Tsing7x.
--

local OnOff = class("OnOff")
local logger = bm.Logger.new("OnOff")

function OnOff:ctor()
	self.onoff_ = {}
    self.version_ = {}
    self.onOffTip_ = {}
end

function OnOff:init(retData)
    self.onoff_ = retData.open
    self.version_ = retData.version
    self.onOffTip_ = retData.opentips

end

-- @param :isRawValue Is Return Value Org.
function OnOff:check(name, isRawValue)
    local value = isset(self.onoff_, name) and tonumber(self.onoff_[name]) == 1

    if isRawValue then
        value = isset(self.onoff_, name) and tonumber(self.onoff_[name]) or nil
    end
    return value
end

function OnOff:checkTip(name)
    local tip = isset(self.onOffTip_, name) and (self.onOffTip_[name]) or nil
    return tip
end

function OnOff:checkVersion(name, version)
    return isset(self.version_, name) and self.version_[name] == version
end

function OnOff:checkLocalVersion(name)
    local version = checkint(nk.userDefault:getStringForKey(nk.cookieKeys.CONFIG_VER .. "_" .. name, 0))
    return self:checkVersion(name, version)
end

function OnOff:saveNewVersionInLocal(name)
    nk.userDefault:setStringForKey(nk.cookieKeys.CONFIG_VER .. "_" .. name, 0)
end

function OnOff:checkReportError(name)
	return isset(self.onoff_, name) and checkint(self.onoff_[name]) == 1
end

return OnOff