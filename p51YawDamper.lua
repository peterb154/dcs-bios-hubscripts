--[[
TODO:
- tune the slope
- implement some form of damping on the ball indication.. It's inertia causes oscillations
]]--
TARGET_AIRCRAFT = "51D"
THIS_AIRCRAFT = hub.getSimString("MetadataStart/_ACFT_NAME")

COMFORT_ZONE_PCT = .08 -- the percentage of ball deflection to allow before we start trimming
MESSAGE = "NONE" -- used for debugging

RUDDER = {}
RUDDER.TRIM_CTRL = "RUDDER_TRIM"
RUDDER.TRIM_VAL = "P-51D/RUDDER_TRIM"
RUDDER.BALL = "P-51D/SLIPBALL"
RUDDER.CENTER = 65536 / 2
RUDDER.CENTER_LEFT = RUDDER.CENTER * (1 - COMFORT_ZONE_PCT) -- how far off center to the left to start trimming
RUDDER.CENTER_RIGHT = RUDDER.CENTER * (1 + COMFORT_ZONE_PCT) -- how far off center to the right to start trimming
RUDDER.TRIM_INCR_100 = 300 --  The amount to move the trim wheel each cycle at @100 mph. Slower speeds need more trim
RUDDER.TRIM_INCR_500 = 50 -- The amount to move the trim wheel each cycle at @500 mph. Higher speeds need less trim

AIRSPEED = {}
AIRSPEED.MPH = "P-51D/AIRSPEED_MPH_VALUE"

hub.registerOutputCallback(function()
    if string.find(THIS_AIRCRAFT, TARGET_AIRCRAFT) then
        trim = hub.getSimInteger(RUDDER.TRIM_VAL)
        ball = hub.getSimInteger(RUDDER.BALL)
        trim_incr = getTrimIncr()
        msg = "mph: " .. getMph() .. ", trim incr: " .. trim_incr .. ", "
        MESSAGE = mph
        if ball < RUDDER.CENTER_LEFT then
            -- ball is left of center. add left rudder trim
            msg = msg .. "ball is left, "
            trim_adjust = - trim_incr -- negative numbers go left
        elseif ball > RUDDER.CENTER_RIGHT then
            -- ball is right of center. add right rudder trim
            msg = msg .. "ball is right, "
            trim_adjust = trim_incr -- positive number go right
        else
            -- no change required
            msg = msg .. "ball is center, "
            trim_adjust = 0 -- do nothing
        end
        msg = msg .. "adjusting trim by: " .. trim_adjust
        hub.sendSimCommand(RUDDER.TRIM_CTRL, trim_adjust)
        MESSAGE = msg
    end
end)

-- get airspeed gauge mph
function getMph()
    return hub.getSimInteger(AIRSPEED.MPH)
end

-- function to determine what the trim increment should be at this airspeed
function getTrimIncr()
    mph = getMph()
    return map(mph, 100, 500, RUDDER.TRIM_INCR_100, RUDDER.TRIM_INCR_500)
end

-- get a gauge output value for a given input
function map(sim_val, sim_min, sim_max, gau_min, gau_max)
    return math.floor((sim_val - sim_min) * (gau_max - gau_min) / (sim_max - sim_min) + gau_min)
end
