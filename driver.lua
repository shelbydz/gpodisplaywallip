--
-- Copyright 2018 Complete AV
-- driver.lua
--

-- Binding variables
SERIAL_BINDING = 1

-- Properties
SET_ID = "00"

-- Serial Commands
OSD_MENU = "F4 88 %s FD %s"
KEY_CODES = {
	   ["MENU"]		= "43",
		["CANCEL"]	= "50", -- Exit on the remote
		["DOWN"]		= "4B",
		["UP"]		= "47",
		["LEFT"]		= "57",
		["RIGHT"]		= "53",
		["ENTER"]		= "04",
		["NUMBER_1"]	= "1D",
		["NUMBER_2"]	= "1C",
		["NUMBER_3"]	= "46",
		["NUMBER_4"]	= "15",
		["NUMBER_5"]	= "15",
		["NUMBER_6"]	= "45",
		["NUMBER_7"]	= "00",
		["NUMBER_8"]	= "1F",
		["NUMBER_9"]	= "1B",
		["NUMBER_0"]	= "1E"
}
CMDS_SERIAL = {	 
		--Power
		["ON"]		= "F5 88 00 FE FE 01",
		["OFF"]		= "F5 88 00 FE FE 00",
		
		--Input Toggle
		["DP"]		= "F5 88 00 FE 01 01",
		["HDMI"] 		= "F5 88 00 FE 01 02"
}

function ProcessCommand(strCommand)
	local command = ""
	if KEY_CODES[strCommand] ~= nil then
		-- return concated keycode
		command = string.format(OSD_MENU, SET_ID, KEY_CODES[strCommand]) 
		C4:DebugLog("Key code found: " .. command)
	elseif CMDS_SERIAL[strCommand] ~= nil then
		-- return command from cmds
		command = CMDS_SERIAL[strCommand]
		C4:DebugLog("Serial command found: " .. command)
	else
		-- Command not supported
	   	C4:DebugLog(strCommand .. " command not found for binding id: " .. SERIAL_BINDING)
	end
    return command
end

-- Manage Properties

function OnPropertyChanged(strName)
    SET_ID = Properties[strName]
    C4:DebugLog("SET_ID property changed to " .. Properties[strName])
end

-- C4 Stuff

function OnDriverInit()
    SET_ID = Properties["Set ID"]
    C4:DebugLog("SET_ID property set to " .. Properties[strName])
end

function ReceivedFromProxy(idBinding, strCommand, tParams)
	local command = ProcessCommand(strCommand)
	C4:SendToSerial(SERIAL_BINDING, tohex(command))
	C4:DebugLog("Sending command " .. strCommand .. ": " .. command .. " to binding ID " .. SERIAL_BINDING)
end

function ReceivedFromSerial(idBinding, strData)
    -- local serialData = hexdump(strData)
    -- TODO Send this back to the proxy
    hexdump(strData)
    C4:DebugLog("Received from serial device: " .. strData)
end
