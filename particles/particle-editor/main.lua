local particle = nil
local system = nil
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

local configTable = {
  { name = "particle image", value = "orb.png"},
  { name = "x", value = width / 2, },
  { name = "y", value = height / 2, },
  { name = "emission rate", value = 100, },
  { name = "speed min", value = 200 },
  { name = "speed max", value = 300 },
  { name = "linear acceleration xmin", value = 100 },
  { name = "linear acceleration ymin", value = 200 },
  { name = "linear acceleration xmax", value = 300 },
  { name = "linear acceleration ymax", value = 300 },
  { name = "emitter life time", value = 2, },
  { name = "particle life time", value = 1, },
  { name = "direction", value = 0, },
  { name = "spread", value = 360, },
  { name = "radial acceleration", value = -2000, },
  { name = "tangential acceleration", value = 1000, },
}

for index, row in ipairs(configTable) do
  configTable[row.name:gsub(" ", "_")] = index
end

config = {}
metas = {
  __index = function(self, key) return configTable[configTable[key]].value end,
  __newindex = function(self, key, value) configTable[configTable[key]].value = value end
}
setmetatable(config, metas)

function love.load()
  love.keyboard.setKeyRepeat(true)

  local c = config
  particle = love.graphics.newImage(c.particle_image)
  system = love.graphics.newParticleSystem(particle, 10000)
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
  system:stop()
end

function readInputs()
  local c = config
  -- system reset
  if love.keyboard.isDown("space") then
    system:reset()
  end
  -- emission rate
  if love.keyboard.isDown("r") then
    if love.keyboard.isDown("rshift", "lshift", "capslock") then
      c.emission_rate = c.emission_rate + 1
    else
      c.emission_rate = c.emission_rate + 1
    end
  end
  -- emitter life time
  if love.keyboard.isDown("e") then
    if love.keyboard.isDown("rshift", "lshift", "capslock") then
      c.emitter_life_time = c.emitter_life_time + 1
    else
      c.emitter_life_time = c.emitter_life_time - 1
    end
  end
  -- particle life time
  if love.keyboard.isDown("l") then
    if love.keyboard.isDown("rshift", "lshift", "capslock") then
      c.particle_life_time = c.particle_life_time + 1
    else
      c.particle_life_time = c.particle_life_time - 1
    end
  end
  -- tangential acceleration
  if love.keyboard.isDown("t") then
    if love.keyboard.isDown("rshift", "lshift", "capslock") then
      c.tangential_acceleration = c.tangential_acceleration + 10
    else
      c.tangential_acceleration = c.tangential_acceleration - 10
    end
  end
end

function love.update(delta)
  readInputs()
  local x, y = love.mouse.getPosition()
  system:setPosition(x, y)
  system:start()
  system:update(delta)
end

function displayConfig()
  local c = config
  love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
  love.graphics.print("Particle: '" .. tostring(c.particle_image) .. "'", 10, 25)
  love.graphics.print("Emission rate: " .. tostring(c.emission_rate), 10, 40)
  love.graphics.print("Emitter life time: " .. tostring(c.emitter_life_time), 10, 55)
  love.graphics.print("Particle life time: " .. tostring(c.particle_life_time), 10, 70)
  love.graphics.print("Tangential acceleration: " .. tostring(c.tangential_acceleration), 10, 85)
end

function love.draw()
  displayConfig()
  love.graphics.draw(system, 0, 0)
end
