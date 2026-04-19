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
hero.hit_x = 4
hero.hit_y = 4
hero.start = nil
hero.target = nil
hero.speed = 2
hero.c = 0

function hero.update(self)
	if self.target then
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
end

function hero.draw(self)
	if self.target then
		line(self.x, self.y, self.target.x, self.target.y, 11)
		circ(self.target.x, self.target.y, 3, 11)
		circb(self.target.x, self.target.y, 5, 11)
	end
	spr(self.spr, self.x - self.hit_x,self.y - self.hit_y, 0)
	if selected == self then
		circb(self.x,self.y,11,self.c)
		circb(self.x,self.y,7,self.c)
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
	if self.hover then
		rectb(self.x-1,self.y-1,self.hit_w+2,self.hit_h+2,14)
	else
		rectb(self.x-1,self.y-1,self.hit_w+2,self.hit_h+2,3)
	end
	
end

function portrait.on_click(self)
	if self.hero then
		selected = self.hero
	end
end

-- THREAT
threat = new_type(button)
threat.score = 50
threat.type = "fire"
threat.delay = 180

function threat.update(self)
	self.delay = self.delay - 1
	if self.delay < 0 then
		self.destroyed = true
	end
end

function threat.draw(self)
	trib(self.x,self.y,self.x-3,self.y-5,self.x+3,self.y-5,4)
	circ(self.x, self.y-10, 5, 4)
	printc(math.ceil(self.delay/60), self.x, self.y-10, 12)
	-- circb(self.target.x, self.target.y, 5, 11)
end