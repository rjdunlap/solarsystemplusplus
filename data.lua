local vanillaPlanets = {'nauvis', 'vulcanus', 'gleba', 'fulgora', 'aquilo'}
local nauvisOptions = { 'nauvis', 'mickora', 'hexalith', 'quadromire'}
local vulcanusOptions = { 'vulcanus', 'froodara'}
local glebaOptions = { 'gleba', 'nekohaven', 'tapatrion'}
local fulgoraOptions = { 'fulgora', 'nekohaven', 'tchekor'}
local aqulioOptions = { 'aquilo', 'tapatrion'}
local extraContentOptions =  {}
local t3Options = {'hexalith'}
local tZeroOptions = { 'akularis', 'gerkizia'}
local selectedPlanets = {}

local function getRandomPlanet(options)
    -- needs to use map seed
    return options[math.random(1, #options)]
end

local function hideOtherPlanets(options, selected)
    for _, option in pairs(options) do
        if option ~= selected and option ~= nil then
            if option == 'nauvis' then
                game.forces.player.set_surface_hidden(game.surfaces.nauvis, true)
            end

            data.raw.planet[option].hidden = true
            data.raw.planet[option].map_gen_settings = nil
        end
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
                return true
            end
        end
    end
    return false
end


local function moveSpaceConnections(basePlanet, selected) 
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

function BuildSolarSystem()
    -- Use from settings
    math.randomseed(1)
    local selectedNauvis = getRandomPlanet(nauvisOptions)
    local selectedVulcanus = getRandomPlanet(vulcanusOptions)
    local selectedGleba = getRandomPlanet(glebaOptions)
    local selectedFulgora = getRandomPlanet(fulgoraOptions)
    local selectedAqulio = getRandomPlanet(aqulioOptions)
    local selectedTZero = getRandomPlanet(tZeroOptions)
    --local selectedExtraContent = getRandomPlanet(extraContentOptions)

    table.insert(selectedPlanets, selectedNauvis)

    -- Use a T0 if Nauvis is a T3
    if checkIfSelectedInsideOptions(selectedNauvis, t3Options) then
        table.insert(selectedPlanets, selectedTZero)
        --build connection from T0 to 'Nauvis'
    else
        selectedTZero = ""
    end 
    
    moveSpaceConnections("nauvis", selectedNauvis)
    
    if checkIfAnyContains(selectedPlanets, vulcanusOptions) then
        selectedVulcanus = ""
    else
        table.insert(selectedPlanets, selectedVulcanus)
        moveSpaceConnections("vulcanus", selectedVulcanus)
    end 

    if checkIfAnyContains(selectedPlanets, glebaOptions) then
        selectedGleba = ""
    else
        table.insert(selectedPlanets, selectedGleba)
        moveSpaceConnections("gleba", selectedGleba)
    end 

    if checkIfAnyContains(selectedPlanets, fulgoraOptions) then
        selectedFulgora = ""
    else
        table.insert(selectedPlanets, selectedFulgora)
        moveSpaceConnections("fulgora", selectedFulgora)

    end 

    if checkIfAnyContains(selectedPlanets, aqulioOptions) then
        selectedAqulio = ""
    else
        table.insert(selectedPlanets, selectedAqulio)
        moveSpaceConnections("aqulio", selectedAqulio)

    end 

    hideOtherPlanets(tZeroOptions, selectedNauvis)
    hideOtherPlanets(nauvisOptions, selectedTZero)
    hideOtherPlanets(vulcanusOptions, selectedVulcanus)
    hideOtherPlanets(glebaOptions, selectedGleba)
    hideOtherPlanets(fulgoraOptions, selectedFulgora)
    hideOtherPlanets(aqulioOptions, selectedAqulio)
    --hideOtherPlanets(extraContentOptions, selectedExtraContent)
end

BuildSolarSystem()