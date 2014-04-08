local width = love.graphics.getWidth()
local height = love.graphics.getHeight()
local point = {width / 2, height / 2}

function love.load()
	love.keyboard.setKeyRepeat(true)
end

function love.draw()
	love.graphics.point(point[1], point[2])
end

function love.update(dt)
	local x = point[1]
	local y = point[2]
	if love.keyboard.isDown("left") then
		x = x - 10
	end
	if love.keyboard.isDown("right") then
		x = x + 10
	end
	if love.keyboard.isDown("up") then
		y = y - 10
	end
	if love.keyboard.isDown("down") then
		y = y + 10
	end

	-- bounds
	point[1] = x % width
	point[2] = y % height
end
