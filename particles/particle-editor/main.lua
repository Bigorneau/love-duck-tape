local particle = nil
local system = nil
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

local configTable = {
  { name = "particle image", value = "orb.png"},
  { name = "position x", value = width / 2, },
  { name = "position y", value = height / 2, },
  { name = "area spread xmax", value = 0, key = "a", step = 1, min = 0},
  { name = "area spread ymax", value = 0, key = "b", step = 1, min = 0},
  { name = "buffer size", value = 1, key = "c", step = 1, min = 1},
  { name = "direction", value = 0, key = "d", step = math.pi / 6, mod = 2 * math.pi},
  { name = "emission rate", value = 1, key = "e", step = 1, min = 0},
  { name = "emitter life time", value = 0, key = "f", step = 1, min = 0},
  { name = "linear acceleration xmin", value = 0, key = "g", step = 1},
  { name = "linear acceleration ymin", value = 0, key = "h", step = 1},
  { name = "linear acceleration xmax", value = 0, key = "i", step = 1},
  { name = "linear acceleration ymax", value = 0, key = "j", step = 1},
  { name = "offset x", value = 0, key = "k", step = 1},
  { name = "offset y", value = 0, key = "l", step = 1},
  { name = "particle life time", value = 0, key = "m", step = 1},
  { name = "radial acceleration", value = 0, key = "n", step = math.pi / 6, mod = 2 * math.pi},
  { name = "image rotation min", value = 0, key = "o", step = math.pi / 6, mod = 2 * math.pi},
  { name = "image rotation max", value = 0, key = "p", step = math.pi / 6, mod = 2 * math.pi},
  { name = "size variation", value = 0, key = "q", step = 1, mod = 2},
  { name = "speed min", value = 0, key = "r", step = 1},
  { name = "speed max", value = 0, key = "s", step = 1},
  { name = "spin min", value = 0, key = "t", step = math.pi / 6, mod = 2 * math.pi},
  { name = "spin max", value = 0, key = "u", step = math.pi / 6, mod = 2 * math.pi},
  { name = "spin variation", value = 0, key = "v", step = 1, mod = 2},
  { name = "spread", value = 0, key = "w", step = 1},
  { name = "tangential acceleration", value = 0, key = "x", step = "1"},
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
  system:setPosition(c.position_x, c.position_y)
  system:setAreaSpread("normal", c.area_spread_xmax, c.area_spread_ymax)
  system:setBufferSize(c.buffer_size)
  -- setColors()
  system:setDirection(c.direction)
  system:setEmissionRate(c.emission_rate)
  system:setEmitterLifetime(c.emitter_life_time)
  -- setInsertMode()
  system:setLinearAcceleration(c.linear_acceleration_xmin, c.linear_acceleration_ymin, c.linear_acceleration_xmax,  c.linear_acceleration_ymax)
  system:setOffset(c.offset_x, c.offset_y)
  system:setParticleLifetime(c.particle_life_time)
  system:setRadialAcceleration(c.radial_acceleration)
  -- setRelativeRotation()
  system:setRotation(c.image_rotation_min, c.image_rotation_max)
  system:setSizeVariation(c.size_variation)
  -- setSizes()
  system:setSpeed(c.speed_min, c.speed_max)
  system:setSpin(c.spin_min, c.spin_max)
  system:setSpinVariation(c.spin_variation)
  system:setSpread(c.spread)
  system:setTangentialAcceleration(c.tangential_acceleration)
  -- setTexture()
  system:stop()
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
  local value = 0
  for index, field in ipairs(configTable) do
    if field.key and love.keyboard.isDown(field.key) then
      if love.keyboard.isDown("rshift", "lshift", "capslock") then
        value = field.value - field.step
      else
        value = field.value + field.step
      end
      -- value bounds
      if field.mod then
        field.value = value % field.mod
      else
        field.value = value
      end
      if field.min and value < field.min then
        field.value = field.min
      end
    end
  end
end

function love.update(delta)
  readInputs()
  applyConfig()
  local x, y = love.mouse.getPosition()
  system:setPosition(x, y)
  system:start()
  system:update(delta)
end

function love.draw()
  displayConfig()
  love.graphics.draw(system, 0, 0)
end
