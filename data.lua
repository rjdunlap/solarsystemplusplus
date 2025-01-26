local vanillaPlanets = {'nauvis', 'vulcanus', 'gleba', 'fulgora', 'aquilo'}
local allPlanets = {'nauvis', 'vulcanus', 'gleba', 'fulgora', 'aquilo',
                    'mickora', 'hexalith', 'quadromire',
                    'froodara', 'tchekor',
                    'nekohaven', 'tapatrion',
                    'hexalith',
                    'akularis', 'gerkizia',
                 }

local nauvisOptions = { 'nauvis', 'mickora', 'hexalith', 'quadromire'}
local vulcanusOptions = { 'vulcanus', 'froodara', 'tchekor'}
local glebaOptions = { 'gleba', 'nekohaven', 'tapatrion'}
local fulgoraOptions = { 'fulgora', 'nekohaven', 'tchekor'}
local aqulioOptions = { 'aquilo', 'tapatrion'}
local extraContentOptions =  {}
local t3Options = {'hexalith'}
local tZeroOptions = { 'akularis', 'gerkizia'}
local selectedPlanets = {}

local function getRandomPlanet(options)

    return options[math.random(1, #options)]
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
            data.raw.planet[option].hidden = true
            data.raw.planet[option].map_gen_settings = nil
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

function BuildSolarSystem()
    -- feed seed

    math.randomseed(settings.startup["solar-system-random-seed"].value)

    local selectedNauvis = getRandomPlanet(nauvisOptions)
    local selectedVulcanus = getRandomPlanet(vulcanusOptions)
    local selectedGleba = getRandomPlanet(glebaOptions)
    local selectedFulgora = getRandomPlanet(fulgoraOptions)
    local selectedAqulio = getRandomPlanet(aqulioOptions)
    local selectedTZero = getRandomPlanet(tZeroOptions)
    --local selectedExtraContent = getRandomPlanet(extraContentOptions)

    table.insert(selectedPlanets, selectedNauvis)
    moveSpaceConnections("nauvis", selectedNauvis)

    -- Use a T0 if Nauvis is a T3
    if checkIfSelectedInsideOptions(selectedNauvis, t3Options) then
        table.insert(selectedPlanets, selectedTZero)
        
        --all T0 should already have a connection Nauvis?
    else
        selectedTZero = ""
    end

    moveSpaceConnections("nauvis", selectedNauvis)

    local tmpVul = checkIfAnyContains(selectedPlanets, vulcanusOptions)
    if tmpVul ~= "" then
        selectedVulcanus = tmpVul
        moveSpaceConnections("vulcanus", selectedVulcanus)
    else
        table.insert(selectedPlanets, selectedVulcanus)
        moveSpaceConnections("vulcanus", selectedVulcanus)
    end 

    local tmpGleba = checkIfAnyContains(selectedPlanets, glebaOptions)
    if tmpGleba ~= "" then
        selectedGleba = tmpGleba
        moveSpaceConnections("gleba", selectedGleba)
    else
        table.insert(selectedPlanets, selectedGleba)
        moveSpaceConnections("gleba", selectedGleba)
    end 

    local tmpFulgora = checkIfAnyContains(selectedPlanets, fulgoraOptions)
    if tmpFulgora ~= "" then
        selectedFulgora = tmpFulgora
        moveSpaceConnections("fulgora", selectedFulgora)
    else
        table.insert(selectedPlanets, selectedFulgora)
        moveSpaceConnections("fulgora", selectedFulgora)
    end

    local tmpAqulio = checkIfAnyContains(selectedPlanets, aqulioOptions)
    if tmpAqulio ~= "" then
        selectedAqulio = tmpAqulio
        moveSpaceConnections("aqulio", selectedAqulio)
    else
        table.insert(selectedPlanets, selectedAqulio)
        moveSpaceConnections("aqulio", selectedAqulio)
    end

    log(serpent.block(selectedPlanets))
    hideOtherPlanets(allPlanets, selectedPlanets)
end

BuildSolarSystem()