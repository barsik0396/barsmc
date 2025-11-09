local component = require("component")
local gpu = component.gpu
local screen = component.list("screen")()
gpu.bind(screen)
local w, h = gpu.getResolution()

local function clear()
  gpu.setBackground(0x000000)
  gpu.fill(1, 1, w, h, " ")
end

local function center(y, text, color)
  gpu.setForeground(color or 0xFFFFFF)
  gpu.set(math.floor(w / 2 - #text / 2), y, text)
end

local function drawMenu()
  clear()
  center(2, "MC-Barsik OS 🐾", 0x00FF00)
  center(5, "[1] Терминал")
  center(6, "[2] Редактор")
  center(7, "[3] Выход")
end

local function terminal()
  clear()
  center(2, "Терминал запущен", 0xAAAAFF)
  os.sleep(2)
end

local function editor()
  clear()
  center(2, "Редактор запущен", 0xAAAAFF)
  os.sleep(2)
end

drawMenu()

while true do
  local _, _, _, _, _, key = computer.pullSignal()
  if key == 2 then terminal()
  elseif key == 3 then editor()
  elseif key == 4 then os.shutdown()
  end
  drawMenu()
end
