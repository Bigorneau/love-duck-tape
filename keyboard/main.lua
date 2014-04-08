local width = love.graphics.getWidth()
local height = love.graphics.getHeight()
local point = {width / 2, height / 2}

function love.load()
	love.keyboard.setKeyRepeat(true)
end

function love.draw()
	love.graphics.point(point[1], point[2])
end

function love.keypressed(key)
	if key == "left" then
		point[1] = (point[1] - 10) % width
	elseif key == "right" then
		point[1] = (point[1] + 10) % width
	elseif key == "up" then
		point[2] = (point[2] - 10) % height
	elseif key == "down" then
		point[2] = (point[2] + 10) % height
	else
		print(key)
	end
end
