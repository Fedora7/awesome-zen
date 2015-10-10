-- Alexander Tsepkov, 2015
--
-- Logic to compute window positions in order to tile them on the fly, even when in floating layout


local awful = require("awful")

local position = {}

local capi =
{
    client = client,
    mouse = mouse,
    screen = screen,
    awesome = awesome,
}
local coords = {
    left = {
        x = 0,
        y = 0,
        h = 1,
        w = 1 / 2
    },
    right = {
        x = 1 / 2,
        y = 0,
        h = 1,
        w = 1 / 2
    },
    top = {
        x = 0,
        y = 0,
        h = 1 / 2,
        w = 1,
    },
    bottom = {
        x = 0,
        y = 1 / 2,
        h = 1 / 2,
        w = 1
    },
    top_left = {
        x = 0,
        y = 0,
        h = 1 / 2,
        w = 1 / 2
    },
    top_right = {
        x = 1 / 2,
        y = 0,
        h = 1 / 2,
        w = 1 / 2
    },
    bottom_left = {
        x = 0,
        y = 1 / 2,
        h = 1 / 2,
        w = 1 / 2
    },
    bottom_right = {
        x = 1 / 2,
        y = 1 / 2,
        h = 1 / 2,
        w = 1 / 2
    },
    fullscreen = {
        x = 0,
        y = 0,
        h = 1,
        w = 1
    },
    center_pad = {
        x = 1 / 8,
        y = 1 / 8,
        h = (1 / 4) * 3,
        w = (1 / 4) * 3
    },
    left_third = {
        x = 0,
        y = 0,
        h = 1,
        w = 1 / 3
    },
    middle_third = {
        x = (1 / 3),
        y = 0,
        h = 1,
        w = 1 / 3
    },
    left_two_thirds = {
        x = 0,
        y = 0,
        h = 1,
        w = (1 / 3) * 2
    },
    right_third = {
        x = ((1 / 3) * 2),
        y = 0,
        h = 1,
        w = 1 / 3
    },
    right_two_thirds = {
        x = (1 / 3),
        y = 0,
        h = 1,
        w = (1 / 3) * 2
    },
    middle_two_thirds = {
        x = (1 / 6),
        y = 0,
        h = 1,
        w = (1 / 3) * 2
    }
}


-- takes geometry, client window, and parent window (uses entire screen as parent window if omitted)
-- resizes client window based on geometry in relation to parent window. If geometry is a string, uses
-- one of existing geometry presets, if geometry is a table, reads x, y, w, h values from it to determine
-- position and size.
function position.at(geometry, c, p)
    if type(geometry) == "string" then
        geometry = coords[geometry]
    end
    local c = c or capi.client.focus
    local c_geometry = c:geometry()
    local screen = c.screen or awful.screen.getbycoord(c_geometry.x, c_geometry.y)
    local s_geometry
    if p then
        s_geometry = p:geometry()
    else
        s_geometry = capi.screen[screen].geometry
    end
    return c:geometry({
        x = s_geometry.x + s_geometry.width * geometry.x,
        y = s_geometry.y + s_geometry.height * geometry.y,
        width = s_geometry.width * geometry.w,
        height = s_geometry.height * geometry.h
    })
end

return position