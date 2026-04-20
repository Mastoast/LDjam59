function lerp(a,b,mu)
	return a*(1-mu)+b*mu
end

function easeInOutSine(a, b, mu)
    local t = -(math.cos(math.pi * mu) - 1) / 2
    return lerp(a, b, t)
end

function easeInOutCubic(a, b, mu)
    local t
    if mu < 0.5 then
        t = 4 * mu * mu * mu
    else
        t = 1 - (-2 * mu + 2)^3 / 2
    end
    return lerp(a, b, t)
end

function coserp(a,b,mu)
	local T=(1-math.cos(mu*math.pi))/2
	return a*(1-T)+b*T
end

function printc(t,x,y,c,s)
    local w=print(t,0,-8)
    print(t,x-(w/2),y,c or 15,false,s or 1)
end

function dist(a, b)
    return math.sqrt((a.x - b.x)^2 + (a.y - b.y)^2)
end

function rchoice(table)
    return table[math.random(#table)]
end