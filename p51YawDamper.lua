TARGET_AIRCRAFT = "51D"
THIS_AIRCRAFT = hub.getSimString("MetadataStart/_ACFT_NAME")

COMFORT_ZONE_PCT = .1

RUDDER = {}
RUDDER.TRIM_CTRL = "RUDDER_TRIM"
RUDDER.TRIM_VAL = "P-51D/RUDDER_TRIM"
RUDDER.BALL = "P-51D/SLIPBALL"
RUDDER.CENTER = 65536 / 2
RUDDER.CENTER_LEFT = RUDDER.CENTER * (1 - COMFORT_ZONE_PCT)
RUDDER.CENTER_RIGHT = RUDDER.CENTER * (1 + COMFORT_ZONE_PCT)
RUDDER.TRIM_INCR = 500 -- 3200 = 1 degree
MESSAGE = "NONE"


hub.registerOutputCallback(function()
    if string.find(THIS_AIRCRAFT, TARGET_AIRCRAFT) then
        trim = tonumber(hub.getSimInteger(RUDDER.TRIM_VAL))
        ball = tonumber(hub.getSimInteger(RUDDER.BALL))
        msg = "center= " .. RUDDER.CENTER .. ", current trim: " .. trim .. ", ball: " .. ball
        trim_adjust = 0
        if ball < RUDDER.CENTER_LEFT then
            -- ball is left of center. step on the ball, adding left rudder trim
            msg = msg .. ", ball is left, sub trim:" .. RUDDER.TRIM_INCR
            trim_adjust = trim_adjust - RUDDER.TRIM_INCR
        elseif ball > RUDDER.CENTER_RIGHT then
            -- ball is right of center. step on the ball, adding left rudder trim
            msg = msg .. ", ball is right, add trim: " .. RUDDER.TRIM_INCR
            trim_adjust = trim_adjust + RUDDER.TRIM_INCR
        else
            -- no change required
            msg = msg .. ", ball is center"
            trim_adjust = 0
        end
        msg = msg .. " , setting " .. RUDDER.TRIM_CTRL .. " adjusting: " .. trim_adjust
        hub.sendSimCommand(RUDDER.TRIM_CTRL, trim_adjust)
        MESSAGE = msg .. ". new trim set to: " .. hub.getSimInteger(RUDDER.TRIM_VAL)
    end
end)
