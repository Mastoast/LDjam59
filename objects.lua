-- OBJECTS

object = {}
object.hit_x = 0
object.hit_y = 0
object.hit_w = 8
object.hit_h = 8
object.hover = false
lookup = {}
function lookup.__index(self, i) return self.parent[i] end

function object.init(self) end
function object.update(self) end
function object.draw(self) end
function object.on_click(self) end
function object.on_hover(self) end

function object.contains(self, px, py)
    return
        px >= self.x + self.hit_x and
        px < self.x + self.hit_x + self.hit_w and
        py >= self.y + self.hit_y and
        py < self.y + self.hit_y + self.hit_h
end

function new_type(parent)
	local obj = {}
	obj.parent = parent or object
	setmetatable(obj, lookup)
	return obj
end

function create(parent, x, y, hit_w, hit_h)
	local obj = {}
	obj.parent = parent
    obj.x = x
    obj.y = y
    obj.hit_w = hit_w or parent.hit_w or 8
    obj.hit_h = hit_h or parent.hit_h or 8
	setmetatable(obj, lookup)
	table.insert(objects, obj)
	obj:init()
	return obj
end

-- BUTTON

button = new_type(object)
button.hover=false
button.selected=false

function button.update(self)
end

function button.on_click(self)
end

function button.draw(self)
	if self.hover then
		circ(self.x + self.hit_w/2,self.y + self.hit_h/2,self.hit_w/2,4)
	else
		circ(self.x + self.hit_w/2,self.y + self.hit_h/2,self.hit_w/2,3)
	end
end

-- HEROES
hero = new_type(object)
hero.hit_x = -4
hero.hit_y = -4
hero.start = nil
hero.target = nil
hero.speed = 0.5
hero.c = 0
hero.flip = 0
hero.mod = 60

function hero.init(self)
	self.mod = math.random(50,70)
end

function hero.update(self)
	if self.target then
		if self.target.x > self.x then
			self.flip = 0
		end
		if self.target.x < self.x then
			self.flip = 1
		end
		--
		if t%5 == 0 then
			make_trail_ps(self.x, self.y, self.c)
		end
		--
		local sdist = dist(self.start, self.target)
		local cdist = dist(self, self.target)
		local ndist = cdist - self.speed
		local ratio = ndist/sdist
		ratio = math.max(0, math.min(1, ratio))
		if cdist <= 1 then
			self.x = self.target.x
			self.y = self.target.y
			self.target = nil
		else
			self.x = lerp(self.start.x, self.target.x, 1-ratio)
			self.y = lerp(self.start.y, self.target.y, 1-ratio)
		end
	end
	local fighting = false
	for key, obj in pairs(objects) do
		if obj.parent == threat and obj:contains(self.x - self.hit_x, self.y - self.hit_y) then
			local strength = 1
			if obj.type == self.strong then strength = 2 end
			if obj.type == self.weak then strength = 0 end
			obj:fight(strength)
			fighting=true
		end
	end

	if not self.target and not fighting then
		make_aura_ps(self.x+self.hit_x, self.y+self.hit_y)
		if t%(self.mod*2) == self.mod then self.y = self.y + 1 end
		if t%(self.mod*2) == 0 then self.y = self.y - 1 end
	end
end

function hero.draw(self)
	if self.target then
		line(self.x, self.y, self.target.x, self.target.y, self.c)
		circb(self.target.x, self.target.y, 3, self.c)
		circb(self.target.x, self.target.y, 5, self.c)
	end
	spr(self.spr, self.x + self.hit_x,self.y + self.hit_y, 0, 1, self.flip)
	if selected == self then
		circb(self.x,self.y,11,self.c)
		-- mouse preview
		circb(inputs.x, inputs.y, 3, self.c)
	end
end

function hero.on_click(self)
	if selected ~= self then
		selected = self
		sfx(23,'C-5',-1,3)
	end
end

function hero.set_target(self, tx, ty)
	self.start = {x=self.x, y=self.y}
	self.target = {x=tx, y=ty}
end

-- PORTRAITS
portrait = new_type(button)
portrait.hit_w = 16
portrait.hit_h = 16
portrait.hero = nil

function portrait.draw(self)
	spr(self.spr,self.x,self.y,-1,1,0,0,self.hit_w/8,self.hit_h/8)
	rectb(self.x-1,self.y-1,self.hit_w+2,self.hit_h+2,self.hero.c)
	-- if self.hover then
	-- 	rectb(self.x-1,self.y-1,self.hit_w+2,self.hit_h+2,14)
	-- else
	-- 	rectb(self.x-1,self.y-1,self.hit_w+2,self.hit_h+2,3)
	-- end
end

function portrait.on_click(self)
	if self.hero then
		selected = self.hero
	end
end

-- THREAT
threat = new_type(button)
threat.score = 50
threat.mscore = 50
threat.delay = 180
threat.type = "fire"
threat.spr = 142

function threat.spawn(self, x, y, delay, score, type)
	sfx(16,'C-2',-1,3)
	local nt = create(self, x, y)
	nt.delay = delay
	nt.score = score
	nt.mscore = score
	nt.type = type
	return nt
end

function threat.update(self)
	if self.type == "fire" and t%20==0 then
		make_smoke_ps(self.x, self.y)
	end
	if self.type == "gun" and t%20==0 then
		make_gunshot_ps(self.x, self.y)
	end
	if self.type == "unrest" and t%20==0 then
		make_unrest_ps(self.x, self.y)
	end
	self.delay = self.delay - 1
	if self.delay < 0 then
		self.destroyed = true
		sfx(20,'C-4',-1,3)
	end
end

function threat.draw(self)
	circb(self.x, self.y, 4, 2)
	spr(self.spr,self.x-16,self.y-16,0,1,0,0,2,2)
	-- counter
	printc(math.ceil(self.delay/60), self.x-8-1, self.y-12+1, 3)
	printc(math.ceil(self.delay/60), self.x-8, self.y-12, 12)
	-- HP
	if self.score ~= self.mscore then
		line(self.x-17,self.y,self.x-17,lerp(self.y-8, self.y, 1-self.score/self.mscore),6)
		line(self.x-16,self.y,self.x-16,lerp(self.y-8, self.y, 1-self.score/self.mscore),7)
		pix(self.x-16,self.y,6)
	end
end

function threat.fight(self,str)
	local str = str or 1
	self.score = self.score - str
	if str > 0 then
		self.delay = self.delay + 1
	end
	if self.score <= 0 then
		self.destroyed = true
		sfx(19,'C-3',-1,3)
	end
end

-- VILLAIN
villain = new_type(object)
villain.hit_x = -4
villain.hit_y = -12
villain.start = nil
villain.target = nil
villain.speed = 0.6
villain.c = 4
villain.flip = 0
villain.mod = 60
villain.spr = 43
villain.set_target = hero.set_target
villain.hp = 500

function villain.init(self)
	self:set_target(28*8, 14*8)
end

function villain.draw(self)
	spr(self.spr, self.x + self.hit_x,self.y + self.hit_y, 0, 1, self.flip,0,1,2)
end

function villain.update(self)
	if self.target then
		if self.target.x > self.x then
			self.flip = 0
		end
		if self.target.x < self.x then
			self.flip = 1
		end
		--
		if t%5 == 0 then
			make_trail_ps(self.x, self.y, self.c)
		end
		--
		local sdist = dist(self.start, self.target)
		local cdist = dist(self, self.target)
		local ndist = cdist - self.speed
		local ratio = ndist/sdist
		ratio = math.max(0, math.min(1, ratio))
		if cdist <= 1 then
			self.x = self.target.x
			self.y = self.target.y
			self.target = nil
		else
			self.x = lerp(self.start.x, self.target.x, 1-ratio)
			self.y = lerp(self.start.y, self.target.y, 1-ratio)
		end
	end

	local nb_hero = 0
	for key, obj in pairs(objects) do
		if obj.parent == hero and obj:contains(self.x, self.y) then
			nb_hero = nb_hero + 1
		end
	end

	if nb_hero >= 3 then
		self.hp = self.hp - 1
	end

	-- win condition
	if self.hp <= 0 then
		self.destroyed = true
		gstate = 2
	end

	if not self.target then
		if t%20==0 then make_smoke_ps(self.x+self.hit_x, self.y) end
		if t%90==0 then make_gunshot_ps(self.x+self.hit_x, self.y) end
		if t%100==0 then make_unrest_ps(self.x+self.hit_x, self.y) end
	end
end