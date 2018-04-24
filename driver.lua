--
-- Copyright 2018 Complete AV
-- driver.lua
--

-- Binding variables
SERIAL_BINDING = 1

-- Serial Commands
CMDS_SERIAL = {	 
		--Power
		["ON"]             = "F5 88 00 FE FE 01",
		["OFF"]            = "F5 88 00 FE FE 00",
		
		--Input Toggle
		["DP"]=			"F5 88 00 FE 01 01",
		["HDMI"]=			"F5 88 00 FE 01 02"
}

function ReceivedFromProxy(idBinding, strCommand, tParams)
    print("strCommand " .. strCommand)
    if CMDS_SERIAL[strCommand] ~= nil then
	   
	   C4:SendToSerial(SERIAL_BINDING, tohex(CMDS_SERIAL[strCommand]))
	   C4:DebugLog("Sending command " .. strCommand .. ": " .. CMDS_SERIAL(strCommand) .. " to binding ID " .. SERIAL_BINDING)
    else 
	   C4:DebugLog(strCommand .. " command not found for binding id: " .. SERIAL_BINDING)
    end
end

function ReceivedFromSerial(idBinding, strData)
    local serialData = hexdump(strData)
    C4:DebugLog("Received from serial device: " serialData)
end