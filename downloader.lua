local fs = require("filesystem")
local shell = require("shell")
local internet = require("internet")
local computer = require("computer")
local component = require("component")
local gpu = component.gpu
local screen = component.list("screen")()
gpu.bind(screen)
local w, h = gpu.getResolution()

local function center(y, text, color)
  gpu.setForeground(color or 0xFFFFFF)
  gpu.fill(1, y, w, 1, " ")
  gpu.set(math.floor(w / 2 - #text / 2), y, text)
end

local function fetchCommands()
  local handle = internet.request("https://raw.githubusercontent.com/barsik0396/barsmc/main/ubdate_commands.txt")
  local result = ""
  for chunk in handle do result = result .. chunk end
  return result
end

local function runCommands(commands)
  for line in commands:gmatch("[^\r\n]+") do
    center(2, "Выполняется: " .. line, 0xAAAAFF)
    shell.execute(line)
    os.sleep(1)
  end
end

local function finalize()
  fs.remove("/home/.autorun/downloader.lua")
  fs.copy("/home/main.lua", "/home/.autorun/main.lua")
  computer.shutdown(true)
end

center(1, "BarsOS: загрузка компонентов", 0x00FF00)
local cmds = fetchCommands()
runCommands(cmds)
finalize()
