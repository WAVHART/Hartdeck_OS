-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 5,

        border_size = 1,

        col = {
            active_border   = { colors = {"rgba(e8eaed88)"} },
            inactive_border = "rgba(59595955)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 20,
        rounding_power = 1,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 0.8,
        inactive_opacity = 0.6,

        shadow = {
            enabled      = true,
            range        = 20,
            render_power = 3,
            color        = 0xaa000000,
        },

        blur = {
            enabled   = true,
            size      = 13,
            passes    = 3,
            vibrancy  = 0.1696,
        },
    },
})
