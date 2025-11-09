local component = require("component")
local shell = require("shell")
local fs = require("filesystem")
local internet = require("internet")
local gpu = component.gpu
local screen = component.list("screen")()
gpu.bind(screen)
local w, h = gpu.getResolution()

local currentVersion = "1.0.0"
local backupPath = "/home/barsos/backups/" .. currentVersion

local function center(y, text, color)
  gpu.setForeground(color or 0xFFFFFF)
  gpu.fill(1, y, w, 1, " ")
  gpu.set(math.floor(w / 2 - #text / 2), y, text)
end

local function fetch(url)
  local handle = internet.request(url)
  local result = ""
  for chunk in handle do result = result .. chunk end
  return result
end

local function download(url, path)
  local handle = internet.request(url)
  local file = io.open(path, "w")
  for chunk in handle do file:write(chunk) end
  file:close()
end

local function backup()
  fs.makeDirectory(backupPath)
  for file in fs.list("/home/barsos") do
    fs.rename("/home/barsos/" .. file, backupPath .. "/" .. file)
  end
end

local function install()
  center(2, "Выполняется обновление системы", 0x00FF00)
  center(4, "→ Скачивание main.lua")
  download("https://raw.githubusercontent.com/barsik0396/barsmc/main/main.lua", "/home/main.lua")
  center(5, "→ Скачивание downloader.lua")
  download("https://raw.githubusercontent.com/barsik0396/barsmc/main/downloader.lua", "/home/downloader.lua")
  fs.remove("/home/ubdate.lua")
  fs.makeDirectory("/home/.autorun")
  fs.copy("/home/downloader.lua", "/home/.autorun/downloader.lua")
  os.sleep(2)
  computer.shutdown(true)
end

clear()
center(2, "Обновление BarsOS", 0x00FFAA)
center(4, "Создать резервную копию? [Y/N]")

local _, _, _, _, _, key = computer.pullSignal()
if key == 21 then -- Y
  backup()
  install()
elseif key == 49 then -- N
  install()
else
  center(6, "Отмена обновления", 0xFF0000)
end
