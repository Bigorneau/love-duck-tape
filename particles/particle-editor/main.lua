local particle = nil
local system = nil
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

local configTable = {
  { name = "particle image", value = "orb.png"},
  { name = "x", value = width / 2, },
  { name = "y", value = height / 2, },
  { name = "emission rate", value = 1, key = "e", step = 1},
  { name = "speed min", value = 0, key = "u", step = 1},
  { name = "speed max", value = 0, key = "i", step = 1},
  { name = "linear acceleration xmin", value = 0, key = "h", step = 1},
  { name = "linear acceleration ymin", value = 0, key = "j", step = 1},
  { name = "linear acceleration xmax", value = 0, key = "k", step = 1},
  { name = "linear acceleration ymax", value = 0, key = "l", step = 1},
  { name = "emitter life time", value = 0, key = "q", step = 1},
  { name = "particle life time", value = 0, key = "z", step = 1},
  { name = "direction", value = 0, key = "d", step = 1},
  { name = "spread", value = 0, key = "s", step = 1},
  { name = "radial acceleration", value = 0, key = "r", step = 1},
  { name = "tangential acceleration", value = 0, key = "t", step = "1"},
}

for index, row in ipairs(configTable) do
  configTable[row.name:gsub(" ", "_")] = index
end

function displayConfig()
  local c = config
  love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
  local x = 10
  local y = 25
  for index, field in ipairs(configTable) do
    if field.key then
      love.graphics.print("(" .. field.key .. ") " .. field.name ..  ": " .. tostring(field.value), x, y)
    else
      love.graphics.print(field.name .. ": " .. tostring(field.value), x, y)
    end
    y = y + 15
  end
end

config = {}
metas = {
  __index = function(self, key) return configTable[configTable[key]].value end,
  __newindex = function(self, key, value) configTable[configTable[key]].value = value end
}
setmetatable(config, metas)

function applyConfig()
  local c = config
  system:stop()
  system:setPosition(c.x, c.y)
  system:setEmissionRate(c.emission_rate)
  system:setSpeed(c.speed_min, c.speed_max)
  system:setLinearAcceleration(c.linear_acceleration_xmin, c.linear_acceleration_ymin, c.linear_acceleration_xmax,  c.linear_acceleration_ymax)
  system:setEmitterLifetime(c.emitter_life_time)
  system:setParticleLifetime(c.particle_life_time)
  system:setDirection(c.direction)
  system:setSpread(c.spread)
  system:setRadialAcceleration(c.radial_acceleration)
  system:setTangentialAcceleration(c.tangential_acceleration)
end

function love.load()
  love.keyboard.setKeyRepeat(true)

  local c = config
  particle = love.graphics.newImage(c.particle_image)
  system = love.graphics.newParticleSystem(particle, 10000)
  applyConfig()
end

function readInputs()
  -- configuration table
  for index, field in ipairs(configTable) do
    if field.key and love.keyboard.isDown(field.key) then
      if love.keyboard.isDown("rshift", "lshift", "capslock") then
        field.value = field.value - field.step
      else
        field.value = field.value + field.step
      end
    end
  end
end

function love.update(delta)
  readInputs()
  applyConfig()
  --local x, y = love.mouse.getPosition()
  --system:setPosition(x, y)
  system:start()
  system:update(delta)
end

function love.draw()
  displayConfig()
  love.graphics.draw(system, 0, 0)
end
