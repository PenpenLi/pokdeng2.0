--
-- Author: tony
-- Date: 2014-07-08 20:11:05
--
local RoomViewPosition = {}
local P = RoomViewPosition

local paddingLeft = (display.width - 928) * 0.5 -- 928为设计布局宽度
local paddingBottom = (display.height - (528 + 72 + 8)) * 0.5 + (72 + 8) -- 528为设计布局高度，72为底部操作按钮高度，8为底部操作按钮与屏幕边缘的间隙
-- 座位位置
P.SeatPosition = {
    cc.p(640 + paddingLeft, 458 + paddingBottom - 30), 
    cc.p(820 + paddingLeft, 395 + paddingBottom - 30), 
    cc.p(876 + paddingLeft, 260 + paddingBottom - 30), 
    cc.p(822 + paddingLeft, 115 + paddingBottom - 30), 
    cc.p(468 + paddingLeft, 82 + paddingBottom - 30), 
    cc.p(106 + paddingLeft, 115 + paddingBottom - 30), 
    cc.p(50 + paddingLeft, 260 + paddingBottom - 30), 
    cc.p(106 + paddingLeft, 395 + paddingBottom - 30), 
    cc.p(284 + paddingLeft, 458 + paddingBottom - 30), 
    cc.p(226 + 238 + paddingLeft, 446 + paddingBottom-30+40),
}

-- paddingLeft = (display.width - 720) * 0.5 -- 720为设计布局宽度

-- 下注位置
P.BetPosition = {
    cc.p(198 + display.cx, display.cy + 105), 
    cc.p(282 + display.cx, display.cy + 48), 
    cc.p(288 + display.cx, display.cy - 25), 
    cc.p(228 + display.cx, display.cy - 100), 
    cc.p(display.cx, display.cy - 98), 
    cc.p(display.cx - 228, display.cy - 100), 
    cc.p(display.cx - 288, display.cy - 25), 
    cc.p(display.cx - 282, display.cy + 48), 
    cc.p(display.cx - 198, display.cy + 105)
}

paddingLeft = (display.width - 440) * 0.5 -- 432为设计布局宽度
-- 奖池位置
P.PotPosition = {
    cc.p(220 + paddingLeft, P.SeatPosition[2].y - 128), 
    cc.p(128 + paddingLeft, P.SeatPosition[2].y - 128), 
    cc.p(312 + paddingLeft, P.SeatPosition[2].y - 128), 
    cc.p(36  + paddingLeft, P.SeatPosition[2].y - 128), 
    cc.p(404 + paddingLeft, P.SeatPosition[2].y - 128), 
    cc.p(174 + paddingLeft, P.SeatPosition[1].y - 160), 
    cc.p(266 + paddingLeft, P.SeatPosition[1].y - 160), 
    cc.p(82  + paddingLeft, P.SeatPosition[1].y - 160), 
    cc.p(358 + paddingLeft, P.SeatPosition[1].y - 160)
}

-- 发牌位置（10号位为荷官发牌位置）
P.DealCardPosition = {
    cc.p(P.SeatPosition[1].x - 54, P.SeatPosition[1].y - 64 - 30),
    cc.p(P.SeatPosition[2].x - 60, P.SeatPosition[2].y - 36 - 30),
    cc.p(P.SeatPosition[3].x - 82, P.SeatPosition[3].y),
    cc.p(P.SeatPosition[4].x - 58, P.SeatPosition[4].y + 58),
    cc.p(P.SeatPosition[5].x + 72, P.SeatPosition[5].y + 72), 
    cc.p(P.SeatPosition[6].x + 60, P.SeatPosition[6].y + 64), 
    cc.p(P.SeatPosition[7].x + 122, P.SeatPosition[7].y - 5), 
    cc.p(P.SeatPosition[8].x + 80, P.SeatPosition[8].y - 30 - 30), 
    cc.p(P.SeatPosition[9].x + 54, P.SeatPosition[9].y - 64 - 30)   
}

--发牌开始位置
P.DealCardStartPosition = {
    cc.p(650 - 480 + display.cx, 425 - 320 + display.cy - 30), 
    cc.p(700 - 480 + display.cx, 415 - 320 + display.cy - 30), 
    cc.p(750 - 480 + display.cx, 340 - 320 + display.cy - 30), 
    cc.p(695 - 480 + display.cx, 280 - 320 + display.cy - 30), 
    cc.p(490 - 480 + display.cx, 272 - 320 + display.cy - 30),
    cc.p(230 - 480 + display.cx, 300 - 320 + display.cy - 30),
    cc.p(210 - 480 + display.cx, 355 - 320 + display.cy - 30),
    cc.p(235 - 480 + display.cx, 405 - 320 + display.cy - 30),
    cc.p(315 - 480 + display.cx, 422 - 320 + display.cy - 30),
    cc.p(display.cx + 20, P.SeatPosition[1].y - 104 - 30)
}

-- dealer位置（10号位为荷官位置）
P.DealerPosition = {
    cc.p(680 - 480 + display.cx, 425 - 320 + display.cy - 30), 
    cc.p(670 - 480 + display.cx, 415 - 320 + display.cy - 30), 
    cc.p(720 - 480 + display.cx, 340 - 320 + display.cy - 30), 
    cc.p(725 - 480 + display.cx, 280 - 320 + display.cy - 30), 
    cc.p(460 - 480 + display.cx, 272 - 320 + display.cy - 30),
    cc.p(200 - 480 + display.cx, 300 - 320 + display.cy - 30),
    cc.p(240 - 480 + display.cx, 355 - 320 + display.cy - 30),
    cc.p(265 - 480 + display.cx, 405 - 320 + display.cy - 30),
    cc.p(285 - 480 + display.cx, 422 - 320 + display.cy - 30),
    cc.p(display.cx - 15, P.SeatPosition[1].y - 100 - 30)
}

return RoomViewPosition