local tile_name = "express-concrete"
local tint = {r = 0.7, g = 0.7, b = 0.7, a = 1}
local map_color = {r = 0.09, g = 0.09, b = 0.09, a = 1}
local icon_path = "__base__/graphics/terrain/tutorial-grid/tutorial-grid1.png"
local icon = {{icon = icon_path, icon_size = 32, tint = tint}}

local tile_source = data.raw.tile["tutorial-grid"] or data.raw.tile["refined-concrete"] or data.raw.tile["concrete"]
local item_source = data.raw.item["refined-concrete"] or data.raw.item["concrete"]
local recipe_source = data.raw.recipe["refined-concrete"] or data.raw.recipe["concrete"]

if not tile_source then
  error("Express Concrete requires a base tile prototype to copy.")
end

if not item_source then
  error("Express Concrete requires the concrete or refined-concrete item prototype to copy.")
end

local express_tile = table.deepcopy(tile_source)
express_tile.name = tile_name
express_tile.localised_name = {"tile-name." .. tile_name}
express_tile.localised_description = {"tile-description." .. tile_name}
express_tile.tint = tint
express_tile.map_color = map_color
express_tile.walking_speed_modifier = 2.5
express_tile.decorative_removal_probability = 1
express_tile.minable = {mining_time = 0.1, result = tile_name}
express_tile.placeable_by = {item = tile_name, count = 1}
express_tile.can_be_part_of_blueprint = true
express_tile.icons = table.deepcopy(icon)
express_tile.icon = nil
express_tile.icon_size = nil
express_tile.hidden = false
express_tile.hidden_in_factoriopedia = false

data:extend({express_tile})

local express_item = table.deepcopy(item_source)
express_item.name = tile_name
express_item.localised_name = {"item-name." .. tile_name}
express_item.localised_description = {"item-description." .. tile_name}
express_item.icons = table.deepcopy(icon)
express_item.icon = nil
express_item.icon_size = nil
express_item.pictures = nil
express_item.subgroup = "terrain"
express_item.order = "b[concrete]-d[express-concrete]"
express_item.stack_size = 100
if item_source.place_as_tile then
  express_item.place_as_tile = table.deepcopy(item_source.place_as_tile)
else
  express_item.place_as_tile = {
    result = tile_name,
    condition_size = 1,
    condition = {layers = {water_tile = true}}
  }
end
express_item.place_as_tile.result = tile_name
express_item.place_as_tile.condition_size = express_item.place_as_tile.condition_size or 1
express_item.flags = express_item.flags or {}

local express_recipe = {
  type = "recipe",
  name = tile_name,
  localised_name = {"recipe-name." .. tile_name},
  localised_description = {"recipe-description." .. tile_name},
  category = "crafting-with-fluid",
  enabled = false,
  energy_required = 20,
  ingredients = {
    {type = "item", name = "refined-concrete", amount = 20},
    {type = "item", name = "steel-plate", amount = 10},
    {type = "item", name = "iron-stick", amount = 20},
    {type = "item", name = "copper-cable", amount = 20},
    {type = "fluid", name = "water", amount = 100}
  },
  results = {{type = "item", name = tile_name, amount = 10}},
  main_product = tile_name,
  icons = table.deepcopy(icon),
  subgroup = "terrain",
  order = "b[concrete]-d[express-concrete]"
}

if not data.raw.item["refined-concrete"] then
  express_recipe.ingredients = {
    {type = "item", name = "concrete", amount = 50},
    {type = "item", name = "steel-plate", amount = 10},
    {type = "item", name = "iron-stick", amount = 20},
    {type = "item", name = "copper-cable", amount = 20},
    {type = "fluid", name = "water", amount = 100}
  }
end

if recipe_source and recipe_source.category then
  express_recipe.category = recipe_source.category
end

data:extend({express_item, express_recipe})

local concrete_technology = data.raw.technology["concrete"]
if concrete_technology then
  concrete_technology.effects = concrete_technology.effects or {}
  table.insert(concrete_technology.effects, {type = "unlock-recipe", recipe = tile_name})
else
  data.raw.recipe[tile_name].enabled = true
end
