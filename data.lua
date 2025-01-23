local nauvisOptions = { 'nauvis', 'mickora'}
local vulcanusOptions = { 'vulcanus', 'froodara'}
local glebaOptions = { 'gleba', 'nekohaven', 'quadromire'}
local fulgoraOptions = { 'fulgora', 'nekohaven'}
local aqulioOptions = { 'aqulio'}
local extraContentOptions =  {}
local t3Options = {}
local tZeroOptions = { 'akularis', 'gerkizia'}
local selectedPlanets = {}

local function getRandomPlanet(options)
    return options[math.random(1, #options)]
end

local function hideOtherPlanets(options, selected)
    for _, option in pairs(options) do
        if option ~= selected then
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
    local selectedNauvis = getRandomPlanet(nauvisOptions)
    local selectedVulcanus = getRandomPlanet(vulcanusOptions)
    local selectedGleba = getRandomPlanet(glebaOptions)
    local selectedFulgora = getRandomPlanet(fulgoraOptions)
    local selectedAqulio = getRandomPlanet(aqulioOptions)
    local selectedTZero = getRandomPlanet(tZeroOptions)

    table.insert(selectedPlanets, selectedNauvis)
    -- Use a T0 if Nauvis is T3
    if checkIfSelectedInsideOptions(selectedNauvis, t3Options) then
        table.insert(selectedPlanets, selectedTZero)
    else
        selectedTZero = nil
    end 
    
    
    if checkIfAnyContains(selectedPlanets, vulcanusOptions) then
        selectedVulcanus = nil
    else
        table.insert(selectedPlanets, selectedVulcanus)
        moveSpaceConnections("vulcanus", selectedVulcanus)
    end 

    if checkIfAnyContains(selectedPlanets, glebaOptions) then
        selectedGleba = nil
    else
        table.insert(selectedPlanets, selectedGleba)
        moveSpaceConnections("gleba", selectedGleba)
    end 

    if checkIfAnyContains(selectedPlanets, fulgoraOptions) then
        selectedFulgora = nil
    else
        table.insert(selectedPlanets, selectedFulgora)
        moveSpaceConnections("fulgora", selectedFulgora)

    end 

    if checkIfAnyContains(selectedPlanets, aqulioOptions) then
        selectedAqulio = nil
    else
        table.insert(selectedPlanets, selectedAqulio)
        moveSpaceConnections("aqulio", selectedAqulio)

    end 

    hideOtherPlanets(vulcanusOptions, selectedVulcanus)
    hideOtherPlanets(glebaOptions, selectedGleba)
    hideOtherPlanets(fulgoraOptions, selectedFulgora)
    hideOtherPlanets(nauvisOptions, selectedNauvis)

end