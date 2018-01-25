--
-- Author: johnny@boomegg.com
-- Date: 2014-08-14 14:42:32
-- Copyright: Copyright (c) 2014, BOOMEGG INTERACTIVE CO., LTD All rights reserved.
-- Description: Dialog.lua Reconstruct By TsingZhang.

local Panel = import(".Panel")

local Dialog = class("Dialog", Panel)

Dialog.FIRST_BTN_CLICK  = 1
Dialog.SECOND_BTN_CLICK = 2
Dialog.CLOSE_BTN_CLICK  = 3

function Dialog:ctor(args)

    if type(args) == "string" then
        self.messageText_ = args
        self.titleText_ = bm.LangUtil.getText("COMMON", "NOTICE")
        self.firstBtnText_ = bm.LangUtil.getText("COMMON", "CANCEL")
        self.secondBtnText_ = bm.LangUtil.getText("COMMON", "CONFIRM")

    elseif type(args) == "table" then
        self.messageText_ = args.messageText
        self.titleText_ = args.titleText or bm.LangUtil.getText("COMMON", "NOTICE")
        self.firstBtnText_ = args.firstBtnText or bm.LangUtil.getText("COMMON", "CANCEL")
        self.secondBtnText_ = args.secondBtnText or bm.LangUtil.getText("COMMON", "CONFIRM")

        self.specialWidth_ = args.specialWidth
        self.callback_ = args.callback
        
        self.noCloseBtn_ = (args.hasCloseButton == false)
        self.noFristBtn_ = (args.hasFirstButton == false)
        self.notCloseWhenTouchModel_ = (args.closeWhenTouchModel == false)
        -- self.showStandUpTips = (args.showStandUpTips == 1)--此项打开显示一个checkbox,目前为房间站起专用
        -- self.standUpCallback = args.standUpCallback
    end

    local defaultWidth, defaultHeight = self.SIZE_SMALL[1], self.SIZE_SMALL[2]

    -- Set Dialog Width --
    local dialogWidth = self.specialWidth_ or defaultWidth

    -- Init Message Text --
    local labelParam = {
        fontSize = 0,
        color = display.COLOR_WHITE
    }

    labelParam.fontSize = 26
    labelParam.color = styles.FONT_COLOR.LIGHT_TEXT

    local messageLblMagrinBorHoriz = 16
    local messageLabel = display.newTTFLabel({text = self.messageText_, size = labelParam.fontSize, color = labelParam.color, dimensions =
        cc.size(dialogWidth - messageLblMagrinBorHoriz * 2, 0), align = ui.TEXT_ALIGN_CENTER})

    local dialogContMagrinGapVert = 48
    local titleBarHeight = 66

    local dialogBtnSize = {
        width = 180,
        height = 60
    }
    local dialogBtnMagrinBot = 35

    local dialogHeight =  messageLabel:getContentSize().height + dialogContMagrinGapVert * 2 + dialogBtnSize.height + titleBarHeight +
        dialogBtnMagrinBot

    if dialogHeight < defaultHeight then
        --todo
        dialogHeight = defaultHeight
    end

    self.super.ctor(self, {dialogWidth, dialogHeight})

    labelParam.fontSize = 30
    labelParam.color = styles.FONT_COLOR.LIGHT_TEXT

    local titleLbl = display.newTTFLabel({text = self.titleText_, size = labelParam.fontSize, color = labelParam.color, align =
        ui.TEXT_ALIGN_CENTER})

    self:addPanelTitleBar(titleLbl)

    if not self.noCloseBtn_ then
        self:addCloseBtn()
    end
    
    messageLabel:addTo(self)

    -- Init Dialog Btns --
    local dialogBtnsMagrinBorHoriz = 48 * nk.widthScale

    local showFirstBtn = false
    if not self.noFristBtn_ then
        --todo
        if self.firstBtnText_ then
            --todo
            showFirstBtn = true
        end
    end

    labelParam.fontSize = 28
    labelParam.color = styles.FONT_COLOR.LIGHT_TEXT

    self.secondBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnYellowRigOutl.png", pressed = "#common_btnYellowRigOutl.png", disabled =
        "#common_btnGreyLitRigOut.png"}, {scale9 = true})
        :setButtonSize(dialogBtnSize.width, dialogBtnSize.height)
        :setButtonLabel(display.newTTFLabel({text = self.secondBtnText_, size = labelParam.fontSize, color = labelParam.color, align =
            ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked(buttontHandler(self, self.onButtonClick_))
        :addTo(self)

    if showFirstBtn then
        --todo
        self.firstBtn_ = cc.ui.UIPushButton.new({normal = "#common_btnGreenRigOutl.png", pressed = "#common_btnGreenRigOutl.png", disabled =
            "#common_btnGreyLitRigOut.png"}, {scale9 = true})
            :setButtonSize(dialogBtnSize.width, dialogBtnSize.height)
            :setButtonLabel(display.newTTFLabel({text = self.firstBtnText_, size = labelParam.fontSize, color = labelParam.color, align =
                ui.TEXT_ALIGN_CENTER}))
            :onButtonClicked(buttontHandler(self, self.onButtonClick_))
            :pos(- dialogWidth / 2 + dialogBtnsMagrinBorHoriz + dialogBtnSize.width / 2, - dialogHeight / 2 + dialogBtnMagrinBot +
                dialogBtnSize.height / 2)
            :addTo(self)

        self.secondBtn_:pos(dialogWidth / 2 - dialogBtnsMagrinBorHoriz - dialogBtnSize.width / 2, - dialogHeight / 2 + dialogBtnMagrinBot +
            dialogBtnSize.height / 2)
    else
        self.secondBtn_:pos(0, - dialogHeight / 2 + dialogBtnMagrinBot + dialogBtnSize.height / 2)
    end

    -- if self.showStandUpTips==true then
    --     local selectBtn = cc.ui.UICheckBoxButton.new({off = "#checkbox_button_off_2.png", on = "#checkbox_button_on_2.png"});
    --     selectBtn:setButtonLabel(cc.ui.UILabel.new({text = bm.LangUtil.getText("ROOM", "STAND_UP_TIPS"), size = 28,  color = display.COLOR_WHITE}))
    --     selectBtn:setButtonLabelOffset(40, 0)
    --     selectBtn:setButtonLabelAlignment(display.LEFT_CENTER)
    --     selectBtn:align(display.CENTER, -150, -30)
    --     selectBtn:addTo(self)
    --     selectBtn:onButtonClicked(
    --         function(event) 
    --             self.isSelect = selectBtn:isButtonSelected();
    --         end
    --     )
    --     messageLabel:pos(0, (PADDING + BTN_HEIGHT - TOP_HEIGHT) * 0.5 + 30)
    -- else

    -- end
end

-- Evt Btn Click --
function Dialog:onButtonClick_(evt)
    -- if self.showStandUpTips==true and self.isSelect and self.isSelect == true then
    --     self.standUpCallback()
    --     self.callback_ = nil
    --     self.standUpCallback=nil
    --     self:hidePanel_()
    --     return
    -- end 

    if self.callback_ then
        if evt.target == self.firstBtn_ then
            self.callback_(Dialog.FIRST_BTN_CLICK)
        elseif evt.target == self.secondBtn_ then
            self.callback_(Dialog.SECOND_BTN_CLICK)
        end
    end

    self.callback_ = nil

    if self.hidePanel_ then
        --todo
        self:hidePanel_()
    end
end

function Dialog:show()
    if self.notCloseWhenTouchModel_ then
        self:showPanel_(true, true, false, true)
    else
        self:showPanel_()
    end

    return self
end

function Dialog:onRemovePopup(removeFunc)
    if self.callback_ then
        self.callback_(Dialog.CLOSE_BTN_CLICK)
    end
    removeFunc()
end

-- override func onClose
function Dialog:onClose()
    if self.callback_ then
        self.callback_(Dialog.CLOSE_BTN_CLICK)
    end
    
    self.callback_ = nil
    self:hidePanel_()
end

return Dialog