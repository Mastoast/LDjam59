-- title:   game title
-- author:  pandalk, mastoast
-- license: MIT License
-- script:  lua
-- input:  mouse
-- saveid: ldjam59mastoastpandalk

require "objects"
require "utils"

objects = {}
inputs = {x=0,y=0,left=false,clickL=false,releaseL=false}
selected = nil

function BOOT()
	t=0
	test = create(button, 120, 120)
	hero1 = create(hero, 120, 60)
end

function TIC()
	update()
	draw()
	t=t+1
end

function update()
	updateInputs()
	if inputs.clickL then
		hero1.start = {x=hero1.x,y=hero1.y}
		hero1.target = {x=inputs.x,y=inputs.y}
	end
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
	-- print(inputs.left,0, 0, 3)
end

-- <TILES>
-- 001:eccccccccc888888caaaaaaaca222888ca2c222ccacc0c22cacc0ccccacc0ccc
-- 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
-- 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
-- 017:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 019:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 238:000111110001aaaa011121100111211001311111013300000133030301133000
-- 239:1000000012000000121111001221110012211120022211200222112000221120
-- 250:0000000000000000000000000000000000000000011111110111111100000000
-- 251:0000000000000000000000000000000000000111111111111111111100000000
-- 252:0000000000000000000000000000000000000000111111111111111100000000
-- 253:0000000000000000000000000000000000000000111111101111111000000000
-- 254:011330300111330001113303011111330aaaaa000aaaaa000033330000000000
-- 255:3022112000021120300111203311112003aaaa2003aaaa200333333000000000
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
-- 000:4141418d8d8dbfbfbf24245ddd4274db74971db37b70e6ae4c96d7a5d2f37171badf7cd3cbae25faf8ac41bcbc5fe4e4
-- </PALETTE>

