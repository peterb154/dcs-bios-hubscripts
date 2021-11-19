
AIRCRAFT = "P-51D"

NEUTRAL = "0"
CLOSE = "1"
AUTO = "2"
OPEN = "3"

OIL = {}
OIL.LOW = 57000
OIL.REDLINE = 58000
OIL.HIGH = 59000
OIL.TEMP = "P-51D/OIL_TEMP"
OIL.CONTROL = "OIL_CONTROL"
OIL.COVER = "OIL_CONTROL_COVER"
OIL.MSG = "oil NONE"
hub.sendSimCommand(OIL.COVER, "1")

COOL = {}
COOL.LOW = OIL.LOW
COOL.REDLINE = OIL.REDLINE
COOL.HIGH = OIL.HIGH
COOL.TEMP = "P-51D/COOLANT_TEMP"
COOL.CONTROL = "COOLANT_CONTROL"
COOL.COVER = "COOLANT_CONTROL_COVER"
COOL.MSG = "coolant NONE"
hub.sendSimCommand(COOL.COVER, "1")

hub.registerOutputCallback(function()
	if hub.getSimString("MetadataStart/_ACFT_NAME") == AIRCRAFT then
		OIL.MSG = setSwitch(OIL.TEMP, OIL.CONTROL, OIL.REDLINE, OIL.LOW, OIL.HIGH)
		COOL.MSG = setSwitch(COOL.TEMP, COOL.CONTROL, COOL.REDLINE, COOL.LOW, COOL.HIGH)
	end
end)

function setSwitch(temp, control, redline, low, high)
	temp = hub.getSimInteger(temp)
	if temp < low then
	  hub.sendSimCommand(control, CLOSE)
      message = tostring(temp) .. " closing"
	elseif temp > high then
	  hub.sendSimCommand(control, OPEN)
      message = tostring(temp) .. " opening"
	else
	  hub.sendSimCommand(control, NEUTRAL)
      message = tostring(temp) .. " neutral"
	end
	return message
end