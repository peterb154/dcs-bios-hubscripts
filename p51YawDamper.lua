TARGET_AIRCRAFT = "51D"
THIS_AIRCRAFT = hub.getSimString("MetadataStart/_ACFT_NAME")

RUDDER = {}
RUDDER.TRIM_CTRL = "RUDDER_TRIM"
RUDDER.TRIM_VAL = "P-51D/RUDDER_TRIM"
RUDDER.BALL = "P-51D/SLIPBALL"
RUDDER.CENTER = 65536 / 2
RUDDER.TRIM_INCR = 3200 -- 1 degree
MESSAGE = "NONE"

COMFORT_ZONE_PCT = .01

hub.registerOutputCallback(function()
    if string.find(THIS_AIRCRAFT, TARGET_AIRCRAFT) then
        trim = hub.getSimInteger(RUDDER.TRIM_VAL)
        ball = hub.getSimInteger(RUDDER.BALL)
        msg = "center: " .. RUDDER.CENTER .. ", trim: " .. trim .. ", ball: " .. ball
        MESSAGE = msg .. ", trimming: " .. trim
        if ball < BALL.CENTER then
            MESSAGE = "left"
            -- ball is left of center. step on the ball, adding left rudder trim
            new_trim_value = trim - RUDDER.TRIM_INCR
        --elseif ball > BALL.CENTER then
        --    MESSAGE = "right"
        --    -- ball is right of center. step on the ball, adding left rudder trim
        --    new_trim_value = trim + RUDDER.TRIM_INCR
        --else
        --    MESSAGE = "center"
        --    -- no change required
        --    new_trim_value = trim
        end
        MESSAGE = msg .. ", trimming: " .. new_trim_value
        hub.sendSimCommand(RUDDER.TRIM_CTRL, new_trim_value)
    end
end)
