--
-- Author: TsingZhang@boyaa.com
-- Date: 2017-06-15 17:51:21
-- Copyright: Copyright (c) 2015, BOYAA INTERACTIVE CO., LTD All rights reserved.
-- Description: ClipImage.lua Reconstructed By Tsing7x.
--

local ClipImage = class("ClipImage",function()
	return display.newNode()
end)

function ClipImage:ctor(imgName, stencilImg)

	self.imgClipNode_ = cc.ClippingNode:create()
		:addTo(self)

	self.stencilMaskImg_ = display.newSprite(stencilImg)

	self.imgClipNode_:setStencil(self.stencilMaskImg_)
	self.imgClipNode_:setAlphaThreshold(0.01)
	-- self.imgClipNode_:setInverted(true)

	self.imgToClip_ = display.newSprite(imgName)
	-- self.imgToClip_:setBlendFunc(GL_DST_COLOR, GL_ONE)

	self.imgClipNode_:addChild(self.imgToClip_, 1)
end

function ClipImage:clipImgLoadedCallback_(success, sprite)
    if success then
		--todo
		local tex = sprite:getTexture()
		local texSize = tex:getContentSize()

		local headImgShownWidth = self.stencilMaskImg_:getContentSize().width

		if headImgShownWidth <= 0 then
			--todo
			headImgShownWidth = 100
		end

		if self and self.imgToClip_ then
			--todo
			self.imgToClip_:setTexture(tex)
			self.imgToClip_:setTextureRect(cc.rect(0, 0, texSize.width, texSize.height))

			self.imgToClip_:scale(headImgShownWidth / texSize.width)
		end
	end
end

function ClipImage:addCoverLayer(coverLayer)
	-- body
	self.imgCover_ = coverLayer
	self.imgCover_:addTo(self.imgClipNode_, 2)
		:hide()
end

function ClipImage:setStencilImg(imgName)
	-- body
	self.stencilMaskImg_ = nil
	self.stencilMaskImg_ = display.newSprite(imgName)

	self.imgClipNode_:setStencil(self.stencilMaskImg_)
end

function ClipImage:setImgToClipStr(imgName)
	-- body
	self.imgToClip_:removeFromParent()
	self.imgToClip_ = nil

	self.imgToClip_ = display.newSprite(imgName)
		:addTo(self.imgClipNode_, 1)
end

function ClipImage:setImgToClipUrl(imgurl)
	if not self.clipImgLoaderId_ then
		self.clipImgLoaderId_ = nk.ImageLoader:nextLoaderId()
	end

	nk.ImageLoader:loadAndCacheImage(self.clipImgLoaderId_, imgurl, handler(self, self.clipImgLoadedCallback_), nk.ImageLoader.CACHE_TYPE_USER_HEAD_IMG)

end

function ClipImage:setImgCoverShowState(state)
	-- body
	if state then
		--todo
		self.imgCover_:show()
	else
		self.imgCover_:hide()
	end
end

function ClipImage:getImgCover()
	-- body
	return self.imgCover_
end

return ClipImage