local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

local displayedtext = "<return> *enter text* <return>"
local text = ""

function love.load()
  love.keyboard.setKeyRepeat(true)
end

function love.keypressed(key, isrepeat)
  if key == "return" and not isrepeat then
    if love.keyboard.hasTextInput() then
      displayedtext = text
      text = ""
      love.keyboard.setTextInput(false)
    else
      love.keyboard.setTextInput(true)
    end
  end
end

function love.textinput(t)
  text = text .. t
end

function love.draw()
  love.graphics.print("text: '" .. displayedtext .. "'", 30, 30)
  if love.keyboard.hasTextInput() then
    love.graphics.print("input: '" .. text .. "'", 30, 70)
  end
end
