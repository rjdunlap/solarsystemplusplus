local vanillaPlanets = {'nauvis', 'vulcanus', 'gleba', 'fulgora', 'aquilo'}
local allPlanets = {'nauvis', 'vulcanus', 'gleba', 'fulgora', 'aquilo',
                    'mickora', 'hexalith', 'quadromire', 'vicrox',
                    'froodara', 'tchekor', 'ithurice',
                    'nekohaven', 'tapatrion',
                    'hexalith',
                    'akularis', 'gerkizia',
                 }

local nauvisOptions = { 'nauvis', 'mickora', 'hexalith', 'quadromire', 'vicrox'}
local vulcanusOptions = { 'vulcanus', 'froodara', 'tchekor'}
local glebaOptions = { 'gleba', 'nekohaven', 'tapatrion'}
local fulgoraOptions = { 'fulgora', 'nekohaven', 'tchekor', 'ithurice', 'vicrox'}
local aqulioOptions = { 'aquilo', 'tapatrion', 'ithurice'}
local extraContentOptions =  {}
local t3Options = {'hexalith'}
local tZeroOptions = { 'akularis', 'gerkizia'}
local selectedPlanets = {}
local nonStartPlanet = { 'aquilo', 'hexalith'}

local bigpack = require("__big-data-string2__.pack")
local encode = tostring
local function set_my_data(name, data)
    return bigpack(name, encode(data))
end

local hideNauvis = true

local function getRandomPlanet(options)
    return options[math.random(1, #options)]
end

local function hideConnections(planetName)
    local index = 0
    for i, connection in pairs (data.raw["space-connection"]) do
        index = index + 1
        if connection == nil then
            break
        end
        --log(serpent.block(planetName) .. " -> " .. serpent.block(connection.from) .. " " .. serpent.block(connection.to))
        if connection.from == planetName or connection.to == planetName then
            connection.hidden = true
            connection.from = planetName
            connection.to = planetName
        end 
    end
end

local function hideTechnology(techName)
    for _, tech in pairs (data.raw["technology"]) do
        --log(serpent.block(techName) .. " -> " .. serpent.block(tech.name))

        if tech == nil or tech.name == nil or techName == nil then
            break
        end
        if string.find(tech.name, techName) then
            --log("found")
            data.raw["technology"][tech.name].hidden = true
        end 
    end
end

local function hideOtherPlanets(options, selected)
    for _, s in pairs(selected) do
        for i, option in pairs(options) do
            if option == s then
                table.remove(options, i)
            end
        end
    end
    
    for _, option in pairs(options) do
            if option == "nauvis" then
                hideNauvis = false
            end

            --log(serpent.block(option))
            hideConnections(option)

            data.raw.planet[option].hidden = true
            data.raw.planet[option].map_gen_settings = nil

            --remove unlock tech
            hideTechnology(option)
    end
end

local function checkIfSelectedInsideOptions(selected, options)
    for _, option in pairs(options) do
        if option == selected then
            return true
        end
    end
    return false
end

local function checkIfAnyContains(set, set2)
    for _, selected in pairs(set) do
        for _, option in pairs(set2) do
            if option == selected then
                return selected
            end
        end
    end
    return ""
end

local function selectStartPlanet(start, selectedPlanets)
    --log(serpent.block(start))
    if start ~= "" then
        return start
    end

    while start == "" do
        local index = math.random(1, #selectedPlanets)
        
        start = selectedPlanets[index]
        
        for _, option in pairs(nonStartPlanet) do
            if option == start then
                start = ""
            end
        end
        
        --log("selected start:" .. serpent.block(start))
    end

    return start
end

local function moveSpaceConnections(basePlanet, selected)
    if basePlanet == selected then
        return
    end

    for _,connection in pairs (data.raw["space-connection"]) do


        if connection == nil then
            break
        end
        if connection.from == basePlanet then
            data.raw["space-connection"][connection.name].from = selected
        end 
        if connection.to == basePlanet then
            data.raw["space-connection"][connection.name].to = selected
        end
    end
end

function preFeedRandomSeed()
    -- feed seed
    local seed = settings.startup["solar-system-random-seed"].value
    local v = 0
    for i = 0, seed % 2 do
        v = math.random()
    end
    for i = 0, seed % 3 do
        v = math.random()
    end
    for i = 0, seed % 5 do
        v = math.random()
    end
    for i = 0, seed % 7 do
        v = math.random()
    end
    for i = 0, seed % 11 do
        v = math.random()
    end
    for i = 0, seed / 13 do
        v = math.random()
    end
    for i = 0, seed / 17 do
        v = math.random()
    end
    for i = 0, seed % 19 do
        v = math.random()
    end
    for i = 0, seed % 23 do
        v = math.random()
    end
    for i = 0, seed % 29 do
        v = math.random()
    end
end

local function nthdigit(a , b)
    while b > 0 do
        b = b - 1
        a = a / 10
    end
    return math.floor(a) % 10
end

-- deterministic selection of planets based on digit location
function HanaSystem(options, digit)
    local seed = settings.startup["solar-system-random-seed"].value
    local fixDigit = nthdigit(seed, digit)

    local planet = options[fixDigit % #options + 1]
    --log("digit: " .. fixDigit .. serpent.block(planet))
    return planet
end

function BuildSolarSystem()
    local selectedNauvis
    local selectedVulcanus
    local selectedGleba
    local selectedFulgora
    local selectedAqulio
    local selectedTZero


    if settings.startup["solar-system-random"].value then
        preFeedRandomSeed()

        selectedNauvis = getRandomPlanet(nauvisOptions)
        selectedVulcanus = getRandomPlanet(vulcanusOptions)
        selectedGleba = getRandomPlanet(glebaOptions)
        selectedFulgora = getRandomPlanet(fulgoraOptions)
        selectedAqulio = getRandomPlanet(aqulioOptions)
        selectedTZero = getRandomPlanet(tZeroOptions)
        --local selectedExtraContent = getRandomPlanet(extraContentOptions)
    end

    if settings.startup["solar-system-random"].value ~= true then

        selectedTZero = HanaSystem(tZeroOptions, 1)
        selectedNauvis = HanaSystem(nauvisOptions, 2)
        selectedVulcanus = HanaSystem(vulcanusOptions, 3)
        selectedGleba = HanaSystem(glebaOptions, 4)
        selectedFulgora = HanaSystem(fulgoraOptions, 5)
        selectedAqulio = HanaSystem(aqulioOptions, 6)
        --local selectedExtraContent = HanaSystem(extraContentOptions, 7)
    end

    local startingPlanet = ""

    table.insert(selectedPlanets, selectedNauvis)
    moveSpaceConnections("nauvis", selectedNauvis)

    -- Use a T0 if Nauvis is a T3
    if checkIfSelectedInsideOptions(selectedNauvis, t3Options) then
        table.insert(selectedPlanets, selectedTZero)
        
        startingPlanet = selectedTZero
    else
        selectedTZero = ""
    end

    moveSpaceConnections("nauvis", selectedNauvis)

    local tmpVul = checkIfAnyContains(selectedPlanets, vulcanusOptions)
    if settings.startup["solar-system-random"].value and tmpVul ~= "" then
        selectedVulcanus = tmpVul
        moveSpaceConnections("vulcanus", selectedVulcanus)
    else
        table.insert(selectedPlanets, selectedVulcanus)
        moveSpaceConnections("vulcanus", selectedVulcanus)
    end 

    local tmpGleba = checkIfAnyContains(selectedPlanets, glebaOptions)
    if settings.startup["solar-system-random"].value and tmpGleba ~= "" then
        selectedGleba = tmpGleba
        moveSpaceConnections("gleba", selectedGleba)
    else
        table.insert(selectedPlanets, selectedGleba)
        moveSpaceConnections("gleba", selectedGleba)
    end 

    local tmpFulgora = checkIfAnyContains(selectedPlanets, fulgoraOptions)
    if settings.startup["solar-system-random"].value and tmpFulgora ~= "" then
        selectedFulgora = tmpFulgora
        moveSpaceConnections("fulgora", selectedFulgora)
    else
        table.insert(selectedPlanets, selectedFulgora)
        moveSpaceConnections("fulgora", selectedFulgora)
    end

    local tmpAqulio = checkIfAnyContains(selectedPlanets, aqulioOptions)
    log("tmpAqulio " .. tmpAqulio)
    log("selectedAqulio " .. selectedAqulio)
    if settings.startup["solar-system-random"].value and tmpAqulio ~= "" then
        selectedAqulio = tmpAqulio
        moveSpaceConnections("aquilo", selectedAqulio)
    else
        table.insert(selectedPlanets, selectedAqulio)
        moveSpaceConnections("aquilo", selectedAqulio)
    end

    startingPlanet = selectStartPlanet(startingPlanet, selectedPlanets)

    if startingPlanet == 'nauvis' then
        startingPlanet = "none"
    end
    --log(startingPlanet)
    --log(serpent.block(startingPlanet))
    data:extend{set_my_data("startingPlanet", startingPlanet)}
    data:extend{set_my_data("hideNauvis", hideNauvis)}

    --log(serpent.block(selectedPlanets))
    hideOtherPlanets(allPlanets, selectedPlanets)

    --log(serpent.block(selectedPlanets))
end

BuildSolarSystem()