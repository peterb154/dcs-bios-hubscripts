TARGET_AIRCRAFT = "51D"
THIS_AIRCRAFT = hub.getSimString("MetadataStart/_ACFT_NAME")

FUEL = {}
FUEL.GUA_RIGHT = "P-51D/RIGHT_FUEL_TANK_VALUE"
FUEL.GUA_LEFT = "P-51D/LEFT_FUEL_TANK_VALUE"
FUEL.SELECTOR = "FUEL_SELECTOR_VALVE"
FUEL.SW_LEFT = "1"
FUEL.SW_FUS = "2"
FUEL.SW_RIGHT = "3"
FUEL.SW_LEFT_EXT = "4"
FUEL.SW_RIGHT_EXT = "5"

MESSAGE = "NONE"

hub.registerOutputCallback(function()
	if string.find(THIS_AIRCRAFT, TARGET_AIRCRAFT) then
		lt_tank_gallons = hub.getSimInteger(FUEL.GUA_LEFT)
		rt_tank_gallons = hub.getSimInteger(FUEL.GUA_LEFT)
		msg = "lt: " .. lt_tank_gallons .. ", rt: " .. rt_tank_gallons 
		if rt_tank_gallons > lt_tank_gallons then
			hub.sendSimCommand(FUEL.SELECTOR, FUEL.SW_RIGHT)
			MESSAGE = msg .. ", right tank"
		else
			hub.sendSimCommand(FUEL.SELECTOR, FUEL.SW_LEFT)
			MESSAGE = msg .. ", left tank"
		end
	end
end)