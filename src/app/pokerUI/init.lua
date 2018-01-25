--
-- Author: Johnny Lee
-- Date: 2014-07-10 16:44:55
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: pokerUI init.lua Reorganization By Tsing7x.
local pokerUI = {}

pokerUI.Panel = import(".Panel")
pokerUI.Dialog = import(".Dialog")
pokerUI.ProgressBar = import(".ProgressBar")
pokerUI.RoomLoading = import(".RoomLoading")
pokerUI.Juhua = import(".Juhua")
pokerUI.ClipImage = import(".ClipImage")

pokerUI.PaoPaoTips = import(".PaoPaoTips")
pokerUI.ChangeChipAnim = import(".ChangeChipAnim")

pokerUI.PokerCard = import(".PokerCard")
pokerUI.SimpleButton = import(".SimpleButton")
pokerUI.CheckBoxButtonGroup = import(".CheckBoxButtonGroup")
pokerUI.TabBarWithIndicator = import(".TabBarWithIndicator")
pokerUI.CommonPopupTabBar = import(".CommonPopupTabBar")
pokerUI.CommonPopupTabBarEx	= import(".CommonPopupTabBarEx")
pokerUI.CheckBoxButtonGroupEx = import(".CheckBoxButtonGroupEx")
pokerUI.ComboboxView = import(".ComboboxView")

pokerUI.DigitInputPanel = import(".DigitInputPanel")

-- Add ButtontHandler Click Btn Sounds Music --
function buttontHandler(obj, method)
    return function(...)
        nk.SoundManager:playSound(nk.SoundManager.CLICK_BUTTON)
        return method(obj, ...)
    end
end

return pokerUI
