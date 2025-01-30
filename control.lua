local bigunpack = require("__big-data-string2__.unpack")
local decode = tostring
local function get_my_data(name)
    return decode(bigunpack(name))
end

script.on_init(function()

    local planet = get_my_data("startingPlanet")
    local hideNauvis = get_my_data("hideNauvis")
    log(hideNauvis)

    if hideNauvis == "true" then
        game.forces.player.set_surface_hidden(game.surfaces.nauvis, true)
    end
    remote.call("APS", "override_planet", planet)

    log("start on:" .. planet)
end)
