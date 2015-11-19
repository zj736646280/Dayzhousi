--
-- Author: student
-- Date: 2015-11-10 16:09:12
--

local FightingTouchLayer = class("FightingTouchLayer", function()
	return display.newNode()
end)

tagDirection = {
	rocker_STARY=0,
    rocker_RIGHT=1,
    rocker_UP=2,
    rocker_LEFT=3,
    rocker_DOWN=4,
    rocker_LEFT_UP=5,
    rocker_LEFT_DOWN=6,
    rocker_RIGHT_UP=7,
    rocker_RIGHT_DOWN=8
}

function FightingTouchLayer:ctor(h,m,map)--class中实现的时候多了一个参数，所以第二个位置才开始接收参数
	self.hero = m
	-- dump(h)
	self.Map = map
	self.NoGoLayer = self.Map:getLayer("block") 
	print(m:getPositionX())
	self.move = 0
	--摇杆
	self:initRocker()
	--技能
	self:initSkills()

end

function FightingTouchLayer:isCanMove(p)
	local x = p.x/self.Map:getTileSize().width
	local y = self.Map:getMapSize().height - (p.y / self.Map:getTileSize().height)

	local currentPoint = cc.p(x,y)
	-- print("x = " .. x .. "y = " ..y)
	--判断是否在地图范围内
	if x ~= self.Map:getMapSize().width and self.Map:getMapSize().height ~= y then
		local tilegId = self.NoGoLayer:getTileGIDAt(currentPoint)
		local value = self.Map:getPropertiesForGID(tilegId)
		-- dump(value)
		if tilegId ~= nil then
			if value ~= 0 then
				-- self.he.isCanMove = false--人物不能移动
				return false--不能移动
			end
		end
		return true--可以移动
	end
end

function FightingTouchLayer:update(dt)

	local move 
	local mintus = 0.1
	local buchang = 32
	local sc = 0.5--必须和创建时的缩放大小一样
	if self.move == tagDirection.rocker_STARY then
		--不动
		-- self.hero:doEvent("normal")
	elseif self.move == tagDirection.rocker_RIGHT then
		--向右移动
		self.hero:setScaleX(-sc)
		if self:isCanMove(cc.p(buchang+self.hero:getPositionX(),self.hero:getPositionY()+0)) then
			move = cc.MoveBy:create(mintus,cc.p(buchang,0))
		end
		-- self.hero:setPosition(self.hero:getPositionX() + 5,self.hero:getPositionY())
	elseif self.move == tagDirection.rocker_UP then
		--向上移动
		if self:isCanMove(cc.p(0+self.hero:getPositionX(),self.hero:getPositionY()+buchang)) then
			move = cc.MoveBy:create(mintus,cc.p(0,buchang))
		end
		
		-- self.hero:setPosition(self.hero:getPositionX(),self.hero:getPositionY() + 10)
	elseif self.move == tagDirection.rocker_LEFT then
		--向左移动
		self.hero:setScaleX(sc)
		if self:isCanMove(cc.p(-buchang+self.hero:getPositionX(),self.hero:getPositionY()+0)) then
			move = cc.MoveBy:create(mintus,cc.p(-buchang,0))
		end
		
		-- self.hero:setPosition(self.hero:getPositionX() - 5,self.hero:getPositionY())
	elseif self.move == tagDirection.rocker_DOWN then
		--向下移动
		if self:isCanMove(cc.p(0+self.hero:getPositionX(),self.hero:getPositionY()-buchang)) then
			move = cc.MoveBy:create(mintus,cc.p(0,-buchang))
		end
		-- self.hero:setPosition(self.hero:getPositionX(),self.hero:getPositionY() - 10)	
	elseif self.move == tagDirection.rocker_LEFT_UP then
		--向左下移动
		self.hero:setScaleX(sc)
		if self:isCanMove(cc.p(self.hero:getPositionX()-buchang*0.7,self.hero:getPositionY()+buchang*0.7)) then
			move = cc.MoveBy:create(mintus,cc.p(-buchang*0.7,buchang*0.7))
		end
		
		-- self.hero:setPosition(self.hero:getPositionX() - 3.5,self.hero:getPositionY() + 7)
	elseif self.move == tagDirection.rocker_LEFT_DOWN then
		--向左上移动
		self.hero:setScaleX(sc)
		if self:isCanMove(cc.p(-buchang*0.7+self.hero:getPositionX(),self.hero:getPositionY()-buchang*0.7)) then
			move = cc.MoveBy:create(mintus,cc.p(-buchang*0.7,-buchang*0.7))
		end
		
		-- self.hero:setPosition(self.hero:getPositionX() - 3.5,self.hero:getPositionY() - 7)
	elseif self.move == tagDirection.rocker_RIGHT_UP then
		--向右上移动
		self.hero:setScaleX(-sc)
		if self:isCanMove(cc.p(buchang*0.7+self.hero:getPositionX(),self.hero:getPositionY()+buchang*0.7)) then
			move = cc.MoveBy:create(mintus,cc.p(buchang*0.7,buchang*0.7))
		end
		
		-- self.hero:setPosition(self.hero:getPositionX() + 3.5,self.hero:getPositionY() + 7)
	elseif self.move == tagDirection.rocker_RIGHT_DOWN then
		--向右下移动
		self.hero:setScaleX(-sc)
		if self:isCanMove(cc.p(buchang*0.7+self.hero:getPositionX(),self.hero:getPositionY()-buchang*0.7)) then
			move = cc.MoveBy:create(mintus,cc.p(buchang*0.7,-buchang*0.7))
		end
		
		-- self.hero:setPosition(self.hero:getPositionX() + 3.5,self.hero:getPositionY() - 7)
	end
	-- self.hero:stopAllActions()
	if move~=nil then
		self.hero:runAction(move)
	end
	self.hero:doEvent("move2")
end

function FightingTouchLayer:initSkills()

	--技能按钮
	-- local btn1 = cc.ui.UIPushButton.new({normal="2.png",pressed="2.png"})
 --    btn1:setTag(1002)
 --    btn1:onButtonClicked(function(event)
 --        -- dump(event)
 --        printf("ButtonClicked")
 --    end)
    -- btn1:pos(display.cx, display.cy+90)
    -- self:addChild(btn1)
    --C++中的 button
    self.skillButton1 = ccui.Button:create("2.png","2.png")
    self.skillButton1:setTag(100)
    self.skillButton1:setPosition(cc.p(display.right- 161,display.bottom + 52))
    self.skillButton1:setPressedActionEnabled(true)
    self.skillButton1:addTouchEventListener(function(psender,event)
    	if event == 2 then
    		print("技能一"..psender:getTag())
    		self.hero:doEvent("skills1")
    		-- self.hero.isPutSkills = true
    	end
    end)
    self:addChild(self.skillButton1)

    self.skillButton2 = ccui.Button:create("2.png","2.png")
    self.skillButton2:setTag(101)
    self.skillButton2:setPosition(cc.p(display.right- 137,display.bottom + 99))
    self.skillButton2:setPressedActionEnabled(true)
    self.skillButton2:addTouchEventListener(function(psender,event)
    	if event == 2 then
    		print("技能二"..psender:getTag())
    		self.hero:doEvent("skills2")
    		-- self.hero.isPutSkills=true
    	end
    end)
    self:addChild(self.skillButton2)

    self.skillButton3 = ccui.Button:create("2.png","2.png")
    self.skillButton3:setTag(102)
    self.skillButton3:setPosition(cc.p(display.right- 99,display.bottom + 137))
    self.skillButton3:setPressedActionEnabled(true)
    self.skillButton3:addTouchEventListener(function(psender,event)
    	if event == 2 then
    		print("技能三"..psender:getTag())
    		self.hero:doEvent("skills3")
    		-- self.hero.isPutSkills=true
    	end
    end)
    self:addChild(self.skillButton3)

    self.skillButton4 = ccui.Button:create("img/icon/skill/hyjn-tiao.png","img/icon/skill/hyjn-tiao.png")
    self.skillButton4:setTag(103)
    self.skillButton4:setPosition(cc.p(display.right- 52,display.bottom + 161))
    self.skillButton4:setScale(0.5)
    self.skillButton4:setPressedActionEnabled(true)
    self.skillButton4:addTouchEventListener(function(psender,event)
    	if event == 2 then
    		print("技能四"..psender:getTag())
    	end
    end)
    self:addChild(self.skillButton4)
    self.count = 0
    self.skillButton5 = ccui.Button:create("img/icon/skill/pugong-up.png","img/icon/skill/pugong-over.png")
    self.skillButton5:setTag(104)
    self.skillButton5:setPosition(cc.p(display.right- 70,display.bottom + 70))
    self.skillButton5:setScale(0.5)
    self.skillButton5:setPressedActionEnabled(true)
    self.skillButton5:addTouchEventListener(function(psender,event)
    	if event == 2 then
    		print("技能五"..psender:getTag())
    		-- self.count = self.count + 1

    		if self.count == 0 and self.hero.DengDaiGongJiJieSHu == false then--点击一次
    			scheduler.performWithDelayGlobal(handler(self, self.updateSingleDelay),0.3)
    			-- self.sch1 = scheduleGlobal(handler(self, self.updateSingleDelay),0.1)
    			self.count = self.count + 1
			elseif self.count == 1 and self.hero.DengDaiGongJiJieSHu == false then--双击
				scheduler.performWithDelayGlobal(handler(self, self.updateDoubleDelay),0.3)
				-- self.sch2 = scheduleGlobal(handler(self, self.updateDoubleDelay),0.1)
    			self.count = self.count + 1
			elseif self.count == 2 and self.hero.DengDaiGongJiJieSHu == false then
			 	--todo --三连击
				self:ThreeClicked()
    		end
    	end
    end)
    self:addChild(self.skillButton5)
end

function FightingTouchLayer:updateSingleDelay()
	--单击
	if self.count == 1 and self.hero.DengDaiGongJiJieSHu == false then
		print("单击")
		self.hero.isGongJiCiShu = 1
		self.hero:doEvent("attack1")
		self:resumeclick()
		self.hero.DengDaiGongJiJieSHu = true
	end
	
end

function FightingTouchLayer:updateDoubleDelay()
	--双击
	if self.count == 2 and self.hero.DengDaiGongJiJieSHu == false then
		print("双击")
		self.hero.isGongJiCiShu = 2
		self.hero:doEvent("attack1")
		self:resumeclick()
		self.hero.DengDaiGongJiJieSHu = true
	end
end

function FightingTouchLayer:ThreeClicked()
	--三击
	-- self:resumeclick()
	if self.hero.DengDaiGongJiJieSHu == false then
		print("三击")
		self.hero.isGongJiCiShu = 3
		self.hero:doEvent("attack1")
		self:resumeclick()
		self.hero.DengDaiGongJiJieSHu = true--等待攻击结束
	end
	
	-- scheduler.performWithDelayGlobal(handler(self, self.resumeclick),3)

	
end

function FightingTouchLayer:resumeclick()
	self.count = 0
end

function FightingTouchLayer:initRocker()
	
	self.RockerBG = display.newSprite("img/ui/battleUI/caogan-waiyuan.png")
	self.RockerBG:pos(self:getPositionX() + display.left + self.RockerBG:getContentSize().width/2 +30,self:getPositionY()+ display.bottom + self.RockerBG:getContentSize().width/2 + 30):addTo(self)
	self.Rocker = display.newSprite("img/ui/battleUI/caozuodian1.png"):pos(self.RockerBG:getPosition()):addTo(self)

	self.RockerBGPos = {}
	self.RockerBGPos.x = self.RockerBG:getPositionX()
	self.RockerBGPos.y = self.RockerBG:getPositionY()
	-- local s = self.RockerBG:getPos()
	-- print("x = "..self.RockerBGPos.y)
	self.RockerBGR = self.RockerBG:getContentSize().width/2


--注册监听
	self:addTouchA()
end
--求亮点之间的距离
function FightingTouchLayer:distance(p1,p2)
	return math.sqrt((p1.x-p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y))
end

function FightingTouchLayer:corea(p1,p2)
	return (p1.x - p2.x)/(self:distance(p1,p2))
end

function FightingTouchLayer:checkdirection(angle,p)

	if (p.x >= self.RockerBGPos.x) and (p.y >= self.RockerBGPos.y) then
		if (math.radian2angle(angle)>22.5) and (math.radian2angle(angle)<67.5) then
			--向上
			-- print("右上")
			self.move = tagDirection.rocker_RIGHT_UP
			return
		elseif math.radian2angle(angle)>67.5 then
			-- print("上")
			self.move = tagDirection.rocker_UP
			return
		elseif math.radian2angle(angle)<22.5 then
			-- print("右")
			self.move = tagDirection.rocker_RIGHT
			return
		end

	elseif (p.x < self.RockerBGPos.x) and (p.y > self.RockerBGPos.y) then
		if (math.radian2angle(angle)>112.5) and (math.radian2angle(angle)<152.5) then
			-- print("左上")
			self.move = tagDirection.rocker_LEFT_UP
			return
		elseif math.radian2angle(angle) < 112.5 then
			-- print("上")
			self.move = tagDirection.rocker_UP
			return
		elseif math.radian2angle(angle) > 152.5 then
			-- print("左")
			self.move = tagDirection.rocker_LEFT
			return
		end

	elseif (p.x < self.RockerBGPos.x) and (p.y <= self.RockerBGPos.y) then
		if (math.radian2angle(angle)>112.5) and (math.radian2angle(angle)<152.5) then
			-- print("左下")
			self.move = tagDirection.rocker_LEFT_DOWN
			return
		elseif math.radian2angle(angle)>112.5 then
			-- print("左")
			self.move = tagDirection.rocker_LEFT
			return
		elseif math.radian2angle(angle)<152.5 then
			-- print("下")
			self.move = tagDirection.rocker_DOWN
			return
		end

	elseif (p.x > self.RockerBGPos.x) and (p.y < self.RockerBGPos.y) then
		if (math.radian2angle(angle)>22.5) and (math.radian2angle(angle)<67.5) then
			-- print("右下")
			self.move = tagDirection.rocker_RIGHT_DOWN
			return
		elseif math.radian2angle(angle)>67.5 then
			-- print("下")
			self.move = tagDirection.rocker_DOWN
			return
		elseif math.radian2angle(angle)<22.5 then
			-- print("右")
			self.move = tagDirection.rocker_RIGHT
			return
		end
	end
end

function FightingTouchLayer:addTouchA()
	local function touchbegan(location,event)
		p = location:getLocation()
		--如果出了边界将不出发事件
		if self:distance(p,self.RockerBGPos) < self.RockerBGR then
			--开启时间调度
			if self.hero.isPutSkills == true then
				if self._schedule ~= nil then
					scheduler.unscheduleGlobal(self._schedule)
				end
			else
				self._schedule = scheduler.scheduleGlobal(handler(self, self.update),0.1)
			end
			return true
		end
		return false
	end

	local function touchEnd(location,event)
		self.move = 0
		--让点回到中心
		self.Rocker:setPosition(self.RockerBGPos)
		--停止英雄的运动
		self.hero:stopAllActions()
		self.hero:doEvent("normal")
		scheduler.unscheduleGlobal(self._schedule)
		self._schedule = nil
	end

	local function touchMove(location,event)
		local p = location:getLocation()
		angle = math.acos(self:corea(p,self.RockerBGPos))--弧度制的
		-- math.acos()
		self:checkdirection(angle,p)

		if self:distance(p,self.RockerBGPos) > self.RockerBGR then
			local x = self.RockerBGR * math.cos(angle)
			local y = self.RockerBGR * math.sin(angle)
			if p.y >= self.RockerBGPos.x then
				self.Rocker:setPosition(self.RockerBGPos.x+x,self.RockerBGPos.y+y)
			else
				self.Rocker:setPosition(self.RockerBGPos.x+x,self.RockerBGPos.y-y)
			end
		else
			self.Rocker:setPosition(p)
		end
		--更新英雄位置
		if self._schedule == nil and self.hero.isPutSkills == false then
			self._schedule = scheduler.scheduleGlobal(handler(self, self.update),0.1 )
		else
			-- print("有时间调度")
		end
		-- self._schedule = scheduler.scheduleGlobal(handler(self, self.update),0.5)
	end

	local listener = cc.EventListenerTouchOneByOne:create()
	local dis  = cc.Director:getInstance():getEventDispatcher()
	-- listener
	listener:registerScriptHandler(touchbegan,cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(touchEnd,cc.Handler.EVENT_TOUCH_ENDED)
	listener:registerScriptHandler(touchMove,cc.Handler.EVENT_TOUCH_MOVED)

	dis:addEventListenerWithSceneGraphPriority(listener, self)
end

-- function FightingTouchLayer:upShiJian(dt)
	
-- end

return FightingTouchLayer