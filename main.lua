-- title:   game title
-- author:  pandalk, mastoast
-- license: MIT License
-- script:  lua
-- input:  mouse
-- saveid: ldjam59mastoastpandalk

objects = {}
inputs = {x=0,y=0,left=false,clickL=false,releaseL=false}

function BOOT()
	t=0
	test = create(button, 120, 120)
end

function TIC()
	update()
	draw()
	t=t+1
end

function update()
	updateInputs()
	--
	for i, obj in ipairs(objects) do
        obj:update()
    end
end

function updateInputs()
	local x,y,left,middle,right=mouse()
	inputs.x = x
	inputs.y = y
	inputs.clickL = not inputs.left and left
	inputs.releaseL = inputs.left and not left
	inputs.left = left
end

function draw()
	cls(0)
	map()
	--
	for i, obj in ipairs(objects) do
        obj:draw()
    end
	--
	print(inputs.left,0, 0, 3)
end

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

button = new_type(object)
button.hover=false

function button.update(self)
	local x,y,click=mouse()
	self.hover=self:contains(x,y)
	if (self.hover and inputs.clickL) then
		self:on_click()
	end
end
function button.on_click(self)
	-- action on click
end
function button.draw(self)
	if self.hover then
		circ(self.x + self.hit_w/2,self.y + self.hit_h/2,self.hit_w,4)
	else
		circ(self.x + self.hit_w/2,self.y + self.hit_h/2,self.hit_w,3)
	end
end

-- <TILES>
-- 001:eccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
-- 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
-- 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
-- 017:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 019:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <TRACKS>
-- 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

