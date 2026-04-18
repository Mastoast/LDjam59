function lerp(a,b,mu)
	return a*(1-mu)+b*mu
end

function coserp(a,b,mu)
	local T=(1-math.cos(mu*math.pi))/2
	return a*(1-T)+b*T
end

function printc(t,x,y,c)
    local w=print(t,0,-8)
    print(t,x-(w/2),y,c or 15)
end

function dist(a, b)
    return math.sqrt((a.x - b.x)^2 + (a.y - b.y)^2)
end