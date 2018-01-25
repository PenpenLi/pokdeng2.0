--
-- Author: KevinYu
-- Date: 2016-12-29 14:50:44
-- 输入框管理，因为cocos2dx的引擎cocos\ui目录下的控件，触摸是事件是根据渲染层次的；
-- 而lua这边的触摸是一个管理，统一派发的，级别为为-1；所以lua的触摸屏蔽层，屏蔽不了输入框,触摸会被输入框吞噬
-- 只能主动关闭输入框触摸

local EditBoxManager = class("EditBoxManager")

function EditBoxManager:ctor()
	self.editboxList_ = {}
	self.onEditBoxTouchEnabledId_ = bm.EventCenter:addEventListener(nk.eventNames.ENABLED_EDITBOX_TOUCH, handler(self, self.onEditBoxTouchEnabled_))
    self.onEditBoxTouchDisenabledId_ = bm.EventCenter:addEventListener(nk.eventNames.DISENABLED_EDITBOX_TOUCH, handler(self, self.onEditBoxTouchDisenabled_))
end

function EditBoxManager:addEditBox(editbox, count)
	assert(editbox, "editbox is nil")
	editbox.referenceCount_ = count or 0
	table.insert(self.editboxList_, editbox)

	-- dump(self.editboxList_, "EditBoxManager:addEditBox.editboxList :================")
	-- for _, editbox in ipairs(self.editboxList_) do
	-- 	log("self.editboxList_[" .. _ .. "].referenceCount_ :" .. editbox.referenceCount_)
	-- end
end

function EditBoxManager:removeEditBox(editbox)
	table.removebyvalue(self.editboxList_, editbox)

	-- dump(self.editboxList_, "EditBoxManager:addEditBox.editboxList :================")
	-- for _, editbox in ipairs(self.editboxList_) do
	-- 	log("self.editboxList_[" .. _ .. "].referenceCount_ :" .. editbox.referenceCount_)
	-- end
end

function EditBoxManager:onEditBoxTouchEnabled_()
    for _, editbox in ipairs(self.editboxList_) do
		editbox.referenceCount_ = editbox.referenceCount_ - 1

		-- dump(editbox, "editbox.info :==============")
		-- log("editbox.referenceCount_ :" .. editbox.referenceCount_)
		if editbox.referenceCount_ <= 1 then --referenceCount_ <= 1 Return To Shielded EditBox
	        -- log("Enabled editbox Touch!")
	        editbox:setTouchEnabled(true)
	    end
	end
end

function EditBoxManager:onEditBoxTouchDisenabled_()
	for _, editbox in ipairs(self.editboxList_) do
		editbox.referenceCount_ = editbox.referenceCount_ + 1

		-- dump(editbox, "editbox.info :==============")
		-- log("editbox.referenceCount_ :" .. editbox.referenceCount_)
		if editbox.referenceCount_ > 1 then
			-- log("Disabled editbox Touch!")
			editbox:setTouchEnabled(false)
		end
	end
end

return EditBoxManager