--
-- Author: TsingZhang@boyaa.com
-- Date: 2016-06-03 14:59:21
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: UserAddrController.lua Create && Reconstructed By TsingZhang.
--

local UserAddrController = class("UserAddrController")

function UserAddrController:ctor(view)
	-- body
	self.view_ = view
end

function UserAddrController:getUserAddress(callback)
	-- body
	self.reqGetDefaultUserAddrId_ = nk.http.getUserAddress(function(retData)
		-- dump(retData, "getUserAddress.retData :===================")
		callback(retData)

	end, function(errData)
		self.reqGetDefaultUserAddrId_ = nil
		dump(errData, "getUserAddress.errData :===================")
	end)
end

function UserAddrController:saveUserAddress(info, alertAddrCallBack)
	-- body
	self.reqSaveUserAddrId_ = nk.http.saveUserAddress(info, function(retData)
			-- dump(retData, "saveUserAddress.retData :===================")

			nk.TopTipManager:showTopTip(bm.LangUtil.getText("SCOREMARKET", "SAVEADDRESS_SUCCESS"))

			if alertAddrCallBack then
				--todo
				alertAddrCallBack()
			end

		end, function(errData)
			self.reqSaveUserAddrId_ = nil
			dump(errData, "saveUserAddress.errData :===================")

			nk.TopTipManager:showTopTip(bm.LangUtil.getText("SCOREMARKET", "SAVEADDRESS_FAIL"))
		end
	)
end

function UserAddrController:dispose()
	-- body
	if self.reqGetDefaultUserAddrId_ then
		--todo
		nk.http.cancel(self.reqGetDefaultUserAddrId_)
	end

	if self.reqSaveUserAddrId_ then
		--todo
		nk.http.cancel(self.reqSaveUserAddrId_)
	end
end

return UserAddrController