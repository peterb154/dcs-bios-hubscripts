--[[
TODO:
]]--
TARGET_AIRCRAFT = "51D"
THIS_AIRCRAFT = hub.getSimString("MetadataStart/_ACFT_NAME")

TAIL = {}
TAIL.RADAR_POWER = "WARNING_RADAR_POWER"
TAIL.RADAR_ON = "1"
TAIL.RADAR_OFF = "0"
TAIL.RADAR_LIGHT_ON = 1
TAIL.RADAR_LIGHT_OFF = 0
TAIL.RADAR_LIGHT = "P-51D/RADAR_WARNING_LIGHT" -- only here for todo above
TAIL.RADAR_WARM = false

ALTITUDE = {}
ALTITUDE.VALUE = "P-51D/ALTIMETER_VALUE"
ALTITUDE.RADAR_ON = 3000
ALTITUDE.ON_GROUND = 500
ALTITUDE.FLYING = false
MESSAGE = "NONE"

hub.registerOutputCallback(function()
    if string.find(THIS_AIRCRAFT, TARGET_AIRCRAFT) then
        alt = hub.getSimInteger(ALTITUDE.VALUE)
        if alt > ALTITUDE.RADAR_ON then
            -- we are over radar alt, turn radar on
            hub.sendSimCommand(TAIL.RADAR_POWER, TAIL.RADAR_ON)
        elseif alt < ALTITUDE.ON_GROUND then
            -- we are on ground
            if TAIL.RADAR_WARM then
                -- radar is warm, turn it off
                hub.sendSimCommand(TAIL.RADAR_POWER, TAIL.RADAR_OFF)
            else
                -- radar is cold, turn it on
                hub.sendSimCommand(TAIL.RADAR_POWER, TAIL.RADAR_ON)
            end
            if hub.getSimInteger(TAIL.RADAR_LIGHT) == TAIL.RADAR_LIGHT_ON then
                -- we are on the ground and the radar is warm
                TAIL.RADAR_WARM = true
            end
        else
            -- < 3000' and above 500', reset the radar warmup for next time below 500
            TAIL.RADAR_WARM = false
        end
    end
end)