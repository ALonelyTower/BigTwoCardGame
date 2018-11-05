local zone_guid = '5c2e47'
local green_chip = '2dc2e1'
local yellow_chip = '4dbbee'
local red_chip = '44614a'
local EMPTY = 0
local NUM_CARDS_DEAL = 1
local spawned_objs = {}


local deal_card_parameters = {
    click_function = 'dealCard',
    function_owner = nil,
    label = 'Deal Card',
    position = {0, 0, 0, 0},
    width = 500,
    height = 500,
    font_size = 100,
}

local setup_game_parameters = {
    click_function = 'setupGame',
    function_owner = nil,
    label = 'Setup Game',
    position = {0, 0, 0, 0},
    width = 500,
    height = 500,
    font_size = 100,
}

local clear_cards_parameters = {
    click_function = 'clearCards',
    function_owner = nil,
    label = 'Clear Cards',
    position = {0, 0, 0, 0},
    width = 500,
    height = 500,
    font_size = 100,
}

function onLoad()
    setup_game_button = getObjectFromGUID(green_chip)
    setup_game_button.createButton(setup_game_parameters)

    check_zone_button = getObjectFromGUID(yellow_chip)
    check_zone_button.createButton(deal_card_parameters)
    
    clear_cards_button = getObjectFromGUID(red_chip)
    clear_cards_button.createButton(clear_cards_parameters)
end

-- function onObjectDrop(player, obj)
--     if obj.name == 'Card' then
--         table.insert(spawned_objs, obj)
--     end
-- end

function onObjectLeaveScriptingZone(zone, obj)
    if obj.name == 'Card' then
        table.insert(spawned_objs, obj)
    end
end

function onObjectSpawn(obj)
    table.insert(spawned_objs, obj)
end

function setupGame()
    zone_objects = _getZoneObjects()
    if #zone_objects == EMPTY then
        spawnObject(
            {type = 'Deck',
             position = {-8, 3, 8},
             callback_function = function(obj) obj.flip() end}
            )
    else
        print("There's something in the deck area.")
    end
end

function dealCard()
    zone_objects = _getZoneObjects()
    if #zone_objects != EMPTY then
        for index, zone_object in pairs(zone_objects) do
            zone_object.deal(NUM_CARDS_DEAL)
        end
    else
        print("Nothing left to deal.")
    end
end

function clearCards()
    if #spawned_objs != EMPTY then
        for index, zone_object in pairs(spawned_objs) do
            zone_object.destroyObject()
            spawned_objs[index] = nil
        end
        assert(#spawned_objs == EMPTY)
    else
        print("Nothing to clear.")
    end
end

function _getZoneObjects()
    script_zone = getObjectFromGUID(zone_guid)
    return script_zone.getObjects()
end