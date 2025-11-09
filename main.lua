local component = require("component")
local computer = require("computer")
local internet = require("internet")
local shell = require("shell")
local unicode = require("unicode")
local fs = require("filesystem")
local gpu = component.gpu
local screen = component.list("screen")()
gpu.bind(screen)
local w, h = gpu.getResolution()

local currentVersion = "1.0.0"

local function clear()
  gpu.setBackground(0x000000)
  gpu.fill(1, 1, w, h, " ")
end

local function center(y, text, color)
  gpu.setForeground(color or 0xFFFFFF)
  gpu.set(math.floor(w / 2 - unicode.len(text) / 2), y, text)
end

local function drawMenu()
  clear()
  center(2, "MC-Barsik OS 🐾", 0x00FF00)
  center(5, "[1] Терминал")
  center(6, "[2] Редактор")
  center(7, "[3] Обновления")
  center(8, "[4] Выход")
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

local function fetchText(url)
  local handle = internet.request(url)
  local result = ""
  for chunk in handle do result = result .. chunk end
  return result
end

local function updateMenu()
  clear()
  center(2, "Обновления MC-BarsOS", 0x00FFAA)
  center(5, "[1] Назад")
  center(6, "[2] Проверить обновления")
  center(7, "[3] Восстановить систему")

  while true do
    local _, _, _, _, _, key = computer.pullSignal()
    if key == 2 then break
    elseif key == 3 then checkUpdates()
    elseif key == 4 then restoreSystem()
    end
    updateMenu()
  end
end

function checkUpdates()
  clear()
  center(2, "Проверка обновлений...", 0xAAAAFF)

  local lastVer = fetchText("https://raw.githubusercontent.com/barsik0396/barsmc/main/last_ver.txt")
  local supported = fetchText("https://raw.githubusercontent.com/barsik0396/barsmc/main/supported_vers.txt")

  if currentVersion == lastVer then
    center(h // 2, "У вас последняя версия BarsOS — " .. currentVersion, 0x00FF00)
    os.sleep(3)
  else
    local status = supported:find(currentVersion) and "SUPPORT" or "UNSUPPORT"
    center(h // 2 - 1, "Найдено обновление " .. lastVer .. "!", 0xFFAA00)
    center(h // 2, "Ваша версия: " .. currentVersion .. ", статус системы: [" .. status .. "]", 0xAAAAAA)
    center(h // 2 + 2, "[1] Скачать и установить")
    center(h // 2 + 3, "[2] Отмена")

    while true do
      local _, _, _, _, _, key = computer.pullSignal()
      if key == 2 then break
      elseif key == 1 then
        shell.execute("wget -f https://raw.githubusercontent.com/barsik0396/barsmc/main/ubdate.lua /home/ubdate.lua")
        fs.makeDirectory("/home/.autorun")
        fs.copy("/home/ubdate.lua", "/home/.autorun/ubdate.lua")
        computer.shutdown(true)
      end
    end
  end
end

function restoreSystem()
  clear()
  center(2, "Меню восстановления системы", 0xFFAAAA)
  center(4, "[1] Восстановить версию 0.9.0")
  center(5, "[2] Восстановить версию 1.0.0")
  center(6, "[3] Назад")
  os.sleep(3)
end

drawMenu()

while true do
  local _, _, _, _, _, key = computer.pullSignal()
  if key == 2 then terminal()
  elseif key == 3 then editor()
  elseif key == 4 then updateMenu()
  elseif key == 5 then os.shutdown()
  end
  drawMenu()
end
