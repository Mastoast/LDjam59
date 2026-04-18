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
    obj.hit_w = hit_w or 8
    obj.hit_h = hit_h or 8
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
	local x,y,click=mouse()
	self.hover=self:contains(x,y)
	if (self.hover and inputs.clickL) then
		self:on_click()
	end
end
function button.on_click(self)
	-- self.selected=true
end
function button.draw(self)
	if self.hover then
		circ(self.x + self.hit_w/2,self.y + self.hit_h/2,self.hit_w,4)
	else
		circ(self.x + self.hit_w/2,self.y + self.hit_h/2,self.hit_w,3)
	end
end

-- HEROES
hero = new_type(button)
hero.start = nil
hero.target = nil
hero.speed = 2

function hero.update(self)
	if self.target then
		local sdist = dist(self.start, self.target)
		local cdist = dist(self, self.target)
		local ratio = (cdist-self.speed)/sdist
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
	rect(self.x - self.hit_w/2,self.y - self.hit_h/2,self.hit_w,self.hit_h,8)

end