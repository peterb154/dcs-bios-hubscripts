--[[
TODOS
- Determine target coolant temp for wep
- Determine target oil temp for wep
]]--


TARGET_AIRCRAFT = "51D"
THIS_AIRCRAFT = hub.getSimString("MetadataStart/_ACFT_NAME")

NEUTRAL = "0"
CLOSE = "1"
AUTO = "2"
OPEN = "3"

COMFORT_ZONE_PCT = .01 -- tolerance for target temp

MP = {}
-- mapping of sim to gauge values
MP.SIM_MIN = 4889
MP.SIM_MAX = 57499
MP.GUA_MIN = 15
MP.GUA_MAX = 67

MP.MAX_CONT = 50 -- above this number is MIL
MP.RED_LINE = 61 -- above this MP is WEP
MP.POWER = "NONE" -- used for debugging
MP.VALUE = "P-51D/MANIFOLD_PRESSURE"

OIL = {}
-- mapping of sim to gauge values
OIL.SIM_MIN = 13646
OIL.SIM_MAX = 64965
OIL.GUA_MIN = 40
OIL.GUA_MAX = 100

OIL.NORM = 75 -- target oil temp below mil
OIL.MIL = 120 -- target oil temp in mil
OIL.WEP = 120 -- target oil temp in wep
OIL.TEMP = "P-51D/OIL_TEMP"
OIL.CONTROL = "OIL_CONTROL"
OIL.COVER = "OIL_CONTROL_COVER"
OIL.MSG = "oil NONE" -- used for debugging
hub.sendSimCommand(OIL.COVER, "1") -- open the oil switch cover

COOL = {}
-- mapping of sim to gauge values
COOL.SIM_MIN = 23166
COOL.SIM_MAX = 57124
COOL.GUA_MIN = 0
COOL.GUA_MAX = 120

COOL.NORM = 105 -- target coolant temp below mil
COOL.MIL = 120 -- target coolant temp in mil
COOL.WEP = 147 -- target coolant temp in wep
COOL.TEMP = "P-51D/COOLANT_TEMP"
COOL.CONTROL = "COOLANT_CONTROL"
COOL.COVER = "COOLANT_CONTROL_COVER"
COOL.MSG = "coolant NONE" -- used for debugging
hub.sendSimCommand(COOL.COVER, "1") -- open coolant door sw cover
MESSAGE = "NONE"

hub.registerOutputCallback(function()
	if string.find(THIS_AIRCRAFT, TARGET_AIRCRAFT) then	
		-- get the target oil temp for this mp power setting
		oil_target_temp = getTargetTemp(OIL.NORM, OIL.MIL, OIL.WEP)
		-- set the oil switch
		OIL.MSG = setSwitch(getOilTemp(), OIL.CONTROL, oil_target_temp)
		
		-- get the target coolant temp for this mp power setting
		cool_target_temp = getTargetTemp(COOL.NORM, COOL.MIL, COOL.WEP)
		-- set the coolant switch
		COOL.MSG = setSwitch(getCoolTemp(), COOL.CONTROL, cool_target_temp)
	end
end)

-- get a gauge output value (120) for a given sim input (75000)
function map(sim_val, sim_min, sim_max, gau_min, gau_max)
	MESSAGE =  gau_min
	return math.floor((sim_val - sim_min) * (gau_max - gau_min) / (sim_max - sim_min) + gau_min)
end

-- get manifold pressure in inches
function getMp()
	return map(hub.getSimInteger(MP.VALUE), MP.SIM_MIN, MP.SIM_MAX, MP.GUA_MIN, MP.GUA_MAX)
end

-- get oil temp in degrees
function getOilTemp()
	return map(hub.getSimInteger(OIL.TEMP), OIL.SIM_MIN, OIL.SIM_MAX, OIL.GUA_MIN, OIL.GUA_MAX)
end

-- get coolant temp in degrees
function getCoolTemp()
	return map(hub.getSimInteger(COOL.TEMP), COOL.SIM_MIN, COOL.SIM_MAX, COOL.GUA_MIN, COOL.GUA_MAX)
end

-- get the target temp for a current mp pressure
function getTargetTemp(norm_temp, mil_temp, wep_temp)
	mp = getMp()
	if mp > MP.MAX_CONT and mp < MP.RED_LINE then
		-- mil power, set temps to mil
		MP.POWER = "MIL"
		return mil_temp
	elseif mp > MP.RED_LINE then
		-- wep, set temps to max
		MP.POWER = "WEP"
		return wep_temp
	end
	-- normal ops
	MP.POWER = "NORM"
	return norm_temp
end

-- set temp control switch to position required to maintain temp
function setSwitch(temp, control, target)
	-- determine low range of comfort zone
	low = target * (1 - COMFORT_ZONE_PCT)
	-- determine high range of comfort zone
	high = target * (1 + COMFORT_ZONE_PCT)
	-- get the current switch position, so that we dont have to update position every loop
	curr_switch = hub.getSimInteger(control)
	-- debug
	message = "temp: " .. tostring(temp) .. ", target: " .. target -- .. ", low: " .. low .. ", high: " .. high
	if temp < low then
	  -- temp is below target temp... close the control
	  hub.sendSimCommand(control, CLOSE)
      return message .. ", door: closing."
	elseif temp > high then
	  -- temp is above the target temp... open the control
	  hub.sendSimCommand(control, OPEN)
      return message .. ", door: opening."
	end
	hub.sendSimCommand(control, NEUTRAL)
    return message .. ", door: neutral."
end
